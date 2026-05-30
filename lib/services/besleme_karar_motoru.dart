import 'surec_motoru.dart';
import 'veritabani_servisi.dart';
import 'koloni_biyolojik_model_servisi.dart';

class BeslemeKararSonucu {
  final bool gerekliMi;
  final String tip;
  final String oncelik;
  final String mesaj;
  final String risk;
  final List<String> gerekceler;

  /// Tahmini uygulama bandı. Kesin reçete değildir; koloni gücü,
  /// yavru baskısı, stok durumu, sezon ve süreç birlikte okunarak üretilir.
  final String dozBandi;
  final String tekrarAraligi;
  final String dozNotu;

  const BeslemeKararSonucu({
    required this.gerekliMi,
    required this.tip,
    required this.oncelik,
    required this.mesaj,
    required this.risk,
    required this.gerekceler,
    this.dozBandi = '',
    this.tekrarAraligi = '',
    this.dozNotu = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'gerekliMi': gerekliMi,
      'tip': tip,
      'oncelik': oncelik,
      'mesaj': mesaj,
      'risk': risk,
      'gerekceler': gerekceler,
      'dozBandi': dozBandi,
      'tekrarAraligi': tekrarAraligi,
      'dozNotu': dozNotu,
    };
  }
}

class BeslemeKararMotoru {
  static const int balAkimiOncesiBeslemeKesmeGun = 20;

  static final Map<int, Future<BeslemeKararSonucu>> _kararFutureCache = {};

  /// Besleme kartı aynı koloni açılışında tekrar tekrar hesaplanmasın.
  /// Muayene/koloni değişikliklerinde KararAsistanServisi üzerinden temizlenir.
  static Future<BeslemeKararSonucu> kararGetir(
    int koloniId, {
    bool forceRefresh = false,
  }) async {
    if (forceRefresh) {
      _kararFutureCache.remove(koloniId);
    }

    final future = _kararFutureCache[koloniId] ??= _kararHesapla(koloniId);

    try {
      return await future;
    } catch (_) {
      if (identical(_kararFutureCache[koloniId], future)) {
        _kararFutureCache.remove(koloniId);
      }
      rethrow;
    }
  }

  static void cacheTemizle([int? koloniId]) {
    if (koloniId == null || koloniId <= 0) {
      _kararFutureCache.clear();
      return;
    }
    _kararFutureCache.remove(koloniId);
  }

  static void tumCacheTemizle() => cacheTemizle();

  static Future<BeslemeKararSonucu> _kararHesapla(int koloniId) async {
    final sonuclar = await Future.wait<dynamic>([
      VeritabaniServisi.koloniOzetiGetir(koloniId),
      VeritabaniServisi.muayeneleriGetir(koloniId),
      SurecMotoru.durumGetir(koloniId),
      KoloniBiyolojikModelServisi.modelGetir(koloniId),
    ]);

    final koloni = Map<String, dynamic>.from(sonuclar[0]);
    final muayeneler = List<Map<String, dynamic>>.from(sonuclar[1]);
    final surec = sonuclar[2];
    final biyolojikModel = Map<String, dynamic>.from(sonuclar[3]);
    final sonMuayene = muayeneler.isNotEmpty ? muayeneler.first : null;

    final int toplamCita = _toInt(
      sonMuayene?['citaSayisi'] ?? koloni['sonCita'],
    );
    final double islevselCitaOrta = _toDouble(
      (biyolojikModel['citaAktivasyon'] ?? const <String, dynamic>{})['islevselCitaOrta'] ??
          biyolojikModel['islevselToplamCita'] ??
          toplamCita,
    );
    final int islevselUretimCita = _toInt(
      (biyolojikModel['citaAktivasyon'] ?? const <String, dynamic>{})['islevselUretimCita'] ??
          biyolojikModel['islevselUretimCita'] ??
          islevselCitaOrta.floor(),
    );
    final double aktivasyonOrani = _toDouble(
      (biyolojikModel['citaAktivasyon'] ?? const <String, dynamic>{})['aktivasyonOrani'] ?? 1.0,
    );
    final String hacimDegisimTipi =
        ((biyolojikModel['citaAktivasyon'] ?? const <String, dynamic>{})['hacimDegisimTipi'] ??
                biyolojikModel['hacimDegisimTipi'] ??
                '')
            .toString();
    final bool riskliSisirme =
        (biyolojikModel['riskliSisirme'] == true) ||
            ((biyolojikModel['citaAktivasyon'] ?? const <String, dynamic>{})['riskliSisirme'] == true) ||
            hacimDegisimTipi == 'riskli_hizli_genisleme';
    final bool uretimGuvenliMi =
        (biyolojikModel['uretimGuvenliMi'] == true) ||
            ((biyolojikModel['citaAktivasyon'] ?? const <String, dynamic>{})['uretimGuvenliMi'] == true);
    final bool hacimAktivasyonuTamDegil =
        toplamCita >= 8 && (islevselUretimCita < 8 || aktivasyonOrani < 0.70 || riskliSisirme);

    final int kararCita = islevselUretimCita > 0 ? islevselUretimCita : toplamCita;
    final int yavruluCita = _tahminiYavruCita(
      kararCita,
      _toInt(sonMuayene?['yavruluCita']),
    );
    final int stokCita = _tahminiStokCita(
      kararCita,
      yavruluCita,
      _toInt(sonMuayene?['bal_cita'] ?? koloni['bal_cita']),
    );

    final String koloniSinifi =
        (biyolojikModel['koloniSinifi'] ?? '').toString().trim().toUpperCase();
    // Bal kalıntısı uyarısı yalnızca gerçek hasat/üretim eşiğine gelmiş
    // kolonide anlamlıdır. 8 çıta altı gelişim kolonisine hasat kolonisi gibi
    // davranmak sahada yanlış alarm üretir.
    final bool hasatKolonisi =
        toplamCita >= 8 &&
            ((biyolojikModel['hasatBeklentisiVarMi'] == true) ||
                koloniSinifi == 'URETIM' ||
                koloniSinifi == 'HASAT') &&
            uretimGuvenliMi &&
            !riskliSisirme;

    final bool hasatSonrasiSurec = surec.aktifSurecler.any((s) {
      final grup = s.grup.toUpperCase();
      final kod = s.kod.toUpperCase();
      return grup.contains('HASAT') || kod.contains('HASAT');
    });

    final bool anaSureciVar = surec.aktifSurecler.any((s) {
      final grup = s.grup.toUpperCase();
      final kod = s.kod.toUpperCase();
      return grup.contains('ANASIZLIK') ||
          kod.contains('ANASIZLIK') ||
          kod.contains('ANA_KAZANMA');
    });

    // Kritik kural:
    // Hasat/üretim gücüne girmiş kolonide bal akımına 20 gün veya daha az
    // kaldıysa besleme baskısı aranmaz; doğrudan "besleme önerilmez" denir.
    // Çünkü bu artık stok/gelişim değil, bal kalitesi ve kalıntı güvenliği kararıdır.
    if (hasatKolonisi) {
      final int arilikId = _toInt(koloni['arilikId']);
      final balAkimi = await VeritabaniServisi.aktifBalAkimGetir(
        arilikId: arilikId > 0 ? arilikId : null,
      );
      final DateTime? baslangic = balAkimi?['bas'] as DateTime?;
      final DateTime? bitis = balAkimi?['bit'] as DateTime?;

      final DateTime bugun = _gun(DateTime.now());

      int? gunKaldi;
      bool kesmePenceresi = false;
      bool akimIcinde = false;

      if (baslangic != null) {
        final DateTime bas = _gun(baslangic);
        gunKaldi = bas.difference(bugun).inDays;

        kesmePenceresi =
            gunKaldi >= 0 && gunKaldi <= balAkimiOncesiBeslemeKesmeGun;
      }

      if (baslangic != null && bitis != null) {
        final DateTime bas = _gun(baslangic);
        final DateTime bit = _gun(bitis);
        akimIcinde = !bugun.isBefore(bas) && !bugun.isAfter(bit);
      }

      if (kesmePenceresi || akimIcinde) {
        final String zamanMetni = akimIcinde
            ? 'Bal akımı başladı.'
            : 'Bal akımına $gunKaldi gün kaldı; bal akımından $balAkimiOncesiBeslemeKesmeGun gün önce besleme kesilmeli.';

        return BeslemeKararSonucu(
          gerekliMi: false,
          tip: 'Besleme Önerilmez',
          oncelik: 'kritik',
          mesaj:
              '$zamanMetni Hasat hedeflenen kolonide şeker bazlı besleme yapılmamalı.',
          risk:
              'Şurup veya şekerli yem, nektar akımıyla birlikte bala taşınabilir. Hasat kalitesi açısından risk oluşturur.',
          gerekceler: const [
            '',

          ],
          dozBandi: '0 ml',
          tekrarAraligi: 'Bal akımı ve hasat penceresinde uygulanmaz',
          dozNotu:
              'Bu karar yalnızca hasat hedefli kolonide bal kalitesi güvenliği içindir.',
        );
      }
    }

    if (hacimAktivasyonuTamDegil && !hasatKolonisi) {
      final doz = _gelisimDestegiDozu(kararCita, yavruluCita, stokCita);
      return BeslemeKararSonucu(
        gerekliMi: false,
        tip: stokCita <= 1 ? 'Ölçülü Destek' : 'Gelişim Takibi',
        oncelik: riskliSisirme ? 'orta' : 'dusuk',
        mesaj:
            stokCita <= 1
                ? 'Yeni verilen hacim oturma aşamasında. Stok ve yavru durumuna göre ölçülü destek değerlendirilebilir.'
                : 'Yeni verilen hacim oturma aşamasında. Stok, yavru ve aktivasyon birlikte takip edilmeli.',
        risk:
            riskliSisirme
                ? 'Hacim hızlı açıldıysa fazla besleme koloni düzenini bozabilir; destek ölçülü tutulmalıdır.'
                : '',
        gerekceler: [
          stokCita <= 1
              ? 'Stok durumuna göre destek değerlendirilebilir'
              : 'Yeni hacim aktivasyonu takip edilir',
          'İşlevsel üretim çıtası yaklaşık $islevselUretimCita çıta',
          'Aktivasyon yaklaşık %${(aktivasyonOrani * 100).round()}',
        ],
        dozBandi: stokCita <= 1 ? doz['band']! : '',
        tekrarAraligi: stokCita <= 1 ? doz['aralik']! : '',
        dozNotu:
            stokCita <= 1
                ? 'Amaç koloniyi şişirmek değil, yeni hacim oturana kadar ölçülü enerji desteği sağlamaktır.'
                : '',
      );
    }

    if (anaSureciVar) {
      final doz = _hafifDestekDozu(kararCita);
      return BeslemeKararSonucu(
        gerekliMi: false,
        tip: 'Kontrollü Destek',
        oncelik: 'orta',
        mesaj:
            'Ana kazanma veya anasızlık sürecinde destek gerekiyorsa az ve kontrollü düşünülmeli.',
        risk:
            'Kovanı gereksiz açmak ana kabulü ve çiftleşme sürecini bozabilir.',
        gerekceler: const [
          'Aktif ana kazanma / anasızlık süreci var',
          'Stres azaltma öncelikli olmalı',
        ],
        dozBandi: doz['band']!,
        tekrarAraligi: doz['aralik']!,
        dozNotu:
            'Amaç koloniyi şişirmek değil, süreci strese sokmadan hafif enerji desteği sağlamaktır.',
      );
    }

    if (hasatSonrasiSurec && stokCita < 2) {
      final doz = _stokTamamlamaDozu(kararCita);
      return BeslemeKararSonucu(
        gerekliMi: false,
        tip: 'Stok Tamamlama',
        oncelik: 'orta',
        mesaj:
            'Hasat sonrası dönemde stok durumuna göre 2:1 şurup ile stok tamamlama değerlendirilebilir.',
        risk:
            'Aşırı hacim, açıkta yem ve yağmacılık riski kontrol edilmeli.',
        gerekceler: const [
          'Hasat sonrası bakım süreci aktif',
          'Stok alanı baskı altında görünüyor',
        ],
        dozBandi: doz['band']!,
        tekrarAraligi: doz['aralik']!,
        dozNotu:
            'Stok tamamlama amacı gelişim teşvikinden farklıdır; koloni sıkışık düzende tutulmalıdır.',
      );
    }

    if (yavruluCita >= 5 && stokCita <= 1) {
      final doz = _proteinDestekDozu(kararCita);
      return BeslemeKararSonucu(
        gerekliMi: false,
        tip: 'Polenli Destek',
        oncelik: 'orta',
        mesaj:
            'Yavru gelişimi sürüyor. Polen stoğu sahada zayıf görülürse protein desteği değerlendirilebilir.',
        risk:
            'Gereksiz protein desteği tüketilmezse bozulma ve hijyen riski oluşturabilir.',
        gerekceler: const [
          'Yavru alanı geniş',
          'Stok/polen baskısı oluşuyor',
        ],
        dozBandi: doz['band']!,
        tekrarAraligi: doz['aralik']!,
        dozNotu:
            'Protein desteği yalnızca polen eksikliği sahada doğrulanırsa anlamlıdır.',
      );
    }

    if (kararCita <= 5) {
      final doz = _gelisimDestegiDozu(kararCita, yavruluCita, stokCita);
      return BeslemeKararSonucu(
        gerekliMi: false,
        tip: 'Gelişim Desteği',
        oncelik: 'orta',
        mesaj:
            'Koloni gelişim düzeninde. Stok durumuna göre ölçülü 1:1 şurup desteği değerlendirilebilir.',
        risk:
            'Aşırı besleme yağmacılık ve kovan içi denge bozulması riski yaratabilir.',
        gerekceler: const [
          'Düşük çıta seviyesinde gelişim kolonisi',
          'Karar kovan içi stok gözlemine göre verilmeli',
        ],
        dozBandi: doz['band']!,
        tekrarAraligi: doz['aralik']!,
        dozNotu:
            'Amaç yavru gelişimini desteklemek; fazla şurup verip kovan içi dengeyi bozmamak olmalıdır.',
      );
    }

    if (kararCita <= 7 && stokCita <= 1) {
      final doz = _gelisimDestegiDozu(kararCita, yavruluCita, stokCita);
      return BeslemeKararSonucu(
        gerekliMi: false,
        tip: 'Ölçülü Destek',
        oncelik: 'orta',
        mesaj:
            'Koloni orta güçte. Stok durumuna göre ölçülü gelişim desteği değerlendirilebilir.',
        risk:
            'Aşırı teşvik oğul baskısı veya yağmacılık riskini artırabilir.',
        gerekceler: const [
          'Orta güçte koloni',
          'Karar kovan içi stok gözlemine göre verilmeli',
        ],
        dozBandi: doz['band']!,
        tekrarAraligi: doz['aralik']!,
        dozNotu:
            'Saha gözleminde polen ve nektar gelişi yeterliyse besleme azaltılabilir.',
      );
    }

    return const BeslemeKararSonucu(
      gerekliMi: false,
      tip: 'Besleme Yönetimi',
      oncelik: 'dusuk',
      mesaj:
          'Besleme kararı kovan içi stok, yavru yükü ve saha nektar/polen gelişine göre verilmelidir.',
      risk: '',
      gerekceler: [
        'Sistem stok durumunu kesin ölçmez; saha gözlemi belirleyicidir',
      ],
      dozBandi: '',
      tekrarAraligi: '',
      dozNotu:
          'Stok zayıf görülürse ölçülü destek değerlendirilebilir; yeterli görülürse yalnızca takip edilebilir.',
    );
  }

  static Map<String, String> _gelisimDestegiDozu(
    int toplamCita,
    int yavruluCita,
    int stokCita,
  ) {
    int minMl;
    int maxMl;

    if (toplamCita <= 3) {
      minMl = 200;
      maxMl = 350;
    } else if (toplamCita <= 5) {
      minMl = 250;
      maxMl = 500;
    } else {
      minMl = 500;
      maxMl = 750;
    }

    if (yavruluCita >= 4 && stokCita <= 1) {
      maxMl += 250;
    }

    return {
      'band': _mlBand(minMl, maxMl),
      'aralik': '2–3 gün arayla, saha stok durumuna göre',
    };
  }

  static Map<String, String> _hafifDestekDozu(int toplamCita) {
    if (toplamCita <= 5) {
      return {
        'band': '200–350 ml',
        'aralik': '2–3 gün arayla, kısa süreli',
      };
    }

    return {
      'band': '250–500 ml',
      'aralik': '2–3 gün arayla, kısa süreli',
    };
  }

  static Map<String, String> _stokTamamlamaDozu(int toplamCita) {
    if (toplamCita <= 5) {
      return {
        'band': '500–750 ml',
        'aralik': '2–3 gün arayla, stok kontrolüyle',
      };
    }

    if (toplamCita <= 8) {
      return {
        'band': '750 ml–1 L',
        'aralik': '2–3 gün arayla, stok kontrolüyle',
      };
    }

    return {
      'band': '1–1.5 L',
      'aralik': '2–3 gün arayla, stok tamamlanana kadar',
    };
  }

  static Map<String, String> _proteinDestekDozu(int toplamCita) {
    if (toplamCita <= 5) {
      return {
        'band': '100–150 g polenli kek',
        'aralik': 'Tüketim durumuna göre küçük parçalar halinde',
      };
    }

    if (toplamCita <= 8) {
      return {
        'band': '150–250 g polenli kek',
        'aralik': 'Tüketim durumuna göre küçük parçalar halinde',
      };
    }

    return {
      'band': '250–400 g polenli kek',
      'aralik': 'Tüketim durumuna göre; bozulma riski izlenerek',
    };
  }

  static String _mlBand(int minMl, int maxMl) {
    String fmt(int ml) {
      if (ml >= 1000) {
        final litre = ml / 1000.0;
        return '${litre.toStringAsFixed(litre == litre.roundToDouble() ? 0 : 1)} L';
      }
      return '$ml ml';
    }

    return '${fmt(minMl)}–${fmt(maxMl)}';
  }


  static int _tahminiYavruCita(int toplamCita, int kayitliYavruCita) {
    if (kayitliYavruCita > 0) {
      return kayitliYavruCita.clamp(0, toplamCita).toInt();
    }
    if (toplamCita <= 0) return 0;
    if (toplamCita <= 3) return 1;
    if (toplamCita <= 5) return 2;
    if (toplamCita <= 7) return 3;
    if (toplamCita <= 8) return 4;
    return 5;
  }

  static int _tahminiStokCita(
    int toplamCita,
    int yavruluCita,
    int kayitliBalliCita,
  ) {
    if (kayitliBalliCita > 0) {
      return kayitliBalliCita.clamp(0, toplamCita).toInt();
    }
    if (toplamCita <= 0) return 0;
    final int tahminiPolenTamponu = toplamCita >= 6 ? 2 : 1;
    return (toplamCita - yavruluCita - tahminiPolenTamponu)
        .clamp(0, toplamCita)
        .toInt();
  }

  static DateTime _gun(DateTime t) => DateTime(t.year, t.month, t.day);

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }
}
