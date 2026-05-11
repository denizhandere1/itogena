import 'surec_motoru.dart';
import 'veritabani_servisi.dart';

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
    ]);

    final koloni = Map<String, dynamic>.from(sonuclar[0]);
    final muayeneler = List<Map<String, dynamic>>.from(sonuclar[1]);
    final surec = sonuclar[2];
    final sonMuayene = muayeneler.isNotEmpty ? muayeneler.first : null;

    final int toplamCita = _toInt(
      sonMuayene?['citaSayisi'] ?? koloni['sonCita'],
    );
    final int yavruluCita = _tahminiYavruCita(
      toplamCita,
      _toInt(sonMuayene?['yavruluCita']),
    );
    final int stokCita = _tahminiStokCita(
      toplamCita,
      yavruluCita,
      _toInt(sonMuayene?['bal_cita'] ?? koloni['bal_cita']),
    );

    final bool hasatKolonisi = toplamCita >= 8;

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
      final balAkimi = await VeritabaniServisi.aktifBalAkimGetir();
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
            : 'Bal akımına $gunKaldi gün kaldı; $balAkimiOncesiBeslemeKesmeGun günlük besleme kesme penceresi başladı.';

        return BeslemeKararSonucu(
          gerekliMi: false,
          tip: 'Besleme Önerilmez',
          oncelik: 'kritik',
          mesaj:
              '$zamanMetni Hasat hedeflenen kolonide şeker bazlı besleme yapılmamalı.',
          risk:
              'Şurup veya şekerli yem, nektar akımıyla birlikte bala taşınabilir. Bu durum balın doğallığını, lezzetini ve güvenilirliğini zedeler; hasat kalitesi açısından risk oluşturur.',
          gerekceler: const [
            'Koloni işlevsel olarak 8 çıta ve üzeri üretim/hasat gücüne girmiş görünüyor',
            'Bal akımı öncesi/akım içi besleme kısıtı aktif',
            'Bu aşamada amaç besleme değil; alan, kat, şurupluk ve hasat hazırlığı yönetimidir',
          ],
          dozBandi: '0 ml',
          tekrarAraligi: 'Bal akımı ve hasat penceresinde uygulanmaz',
          dozNotu:
              'Şurupluk kovandaysa muayenede gerçekten kaldırıldı olarak işaretle. Hasat hedefi olmayan zayıf/gelişim kolonileri bu kuralın dışında ayrıca değerlendirilir.',
        );
      }
    }

    if (anaSureciVar) {
      final doz = _hafifDestekDozu(toplamCita);
      return BeslemeKararSonucu(
        gerekliMi: true,
        tip: 'Kontrollü Destek',
        oncelik: 'orta',
        mesaj:
            'Ana kazanma veya anasızlık süreci varsa besleme az ve kontrollü düşünülmeli.',
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
      final doz = _stokTamamlamaDozu(toplamCita);
      return BeslemeKararSonucu(
        gerekliMi: true,
        tip: '2:1 Şurup',
        oncelik: 'orta',
        mesaj:
            'Hasat sonrası stok baskısı görünüyor. Kış hazırlığı için stok tamamlama değerlendirilebilir.',
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
      final doz = _proteinDestekDozu(toplamCita);
      return BeslemeKararSonucu(
        gerekliMi: true,
        tip: 'Polenli Destek',
        oncelik: 'orta',
        mesaj:
            'Yavru gelişimi sürüyor. Polen stoğu zayıfsa protein desteği düşünülebilir.',
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

    if (toplamCita <= 5) {
      final doz = _gelisimDestegiDozu(toplamCita, yavruluCita, stokCita);
      return BeslemeKararSonucu(
        gerekliMi: true,
        tip: '1:1 Şurup',
        oncelik: 'orta',
        mesaj:
            'Koloni gelişim döneminde görünüyor. Hafif gelişim desteği düşünülebilir.',
        risk:
            'Yağmacılık riski açısından giriş daraltması ve ölçülü besleme önemlidir.',
        gerekceler: const [
          'Koloni düşük çıta seviyesinde',
          'Gelişim/destek yönetimi öncelikli',
        ],
        dozBandi: doz['band']!,
        tekrarAraligi: doz['aralik']!,
        dozNotu:
            'Amaç yavru gelişimini desteklemek; fazla şurup verip kovan içi dengeyi bozmamak olmalıdır.',
      );
    }

    if (toplamCita <= 7 && stokCita <= 1) {
      final doz = _gelisimDestegiDozu(toplamCita, yavruluCita, stokCita);
      return BeslemeKararSonucu(
        gerekliMi: true,
        tip: '1:1 Şurup',
        oncelik: 'orta',
        mesaj:
            'Koloni orta güçte ancak stok baskısı görünüyor. Ölçülü gelişim desteği düşünülebilir.',
        risk:
            'Aşırı teşvik oğul baskısı veya yağmacılık riskini artırabilir.',
        gerekceler: const [
          'Orta güçte koloni',
          'Stok tamponu sınırlı',
        ],
        dozBandi: doz['band']!,
        tekrarAraligi: doz['aralik']!,
        dozNotu:
            'Saha gözleminde polen ve nektar gelişi yeterliyse besleme azaltılabilir.',
      );
    }

    return const BeslemeKararSonucu(
      gerekliMi: false,
      tip: 'İzle',
      oncelik: 'dusuk',
      mesaj:
          'Şu an belirgin bir besleme baskısı görünmüyor. Stok ve yavru gelişimi izlenmeli.',
      risk: '',
      gerekceler: [
        'Mevcut biyolojik denge belirgin destek baskısı üretmiyor',
      ],
      dozBandi: '0 ml',
      tekrarAraligi: 'Şimdilik uygulanmaz',
      dozNotu:
          'Besleme yerine saha gözlemi, stok kontrolü ve gelişim takibi yeterli görünüyor.',
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

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }
}
