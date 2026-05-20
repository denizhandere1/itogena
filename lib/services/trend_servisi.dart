import 'dart:math' as math;

import 'veritabani_servisi.dart';
import 'cita_aktivasyon_servisi.dart';

class TrendServisi {
  static Future<Map<String, dynamic>> koloniTrendiGetir(int koloniId) async {
    final muayeneler = await VeritabaniServisi.muayeneleriGetir(koloniId);

    if (muayeneler.isEmpty) {
      return {
        'trend': 'Veri Yok',
        'ivme': 0.0,
        'hamIvme': 0.0,
        'duzeltilmisIvme': 0.0,
        'gunlukMomentum': 0.0,
        'momentumSkoru': 0,
        'momentumEtiketi': 'Veri Yok',
        'momentumAciklama': 'Henüz muayene verisi bulunmuyor.',
        'pencereler': <Map<String, dynamic>>[],
        'gecmis': <Map<String, dynamic>>[],
        'aciklama': 'Henüz muayene verisi bulunmuyor.',
      };
    }

    final eskiYeniSirali = List<Map<String, dynamic>>.from(muayeneler.reversed)
      ..sort((a, b) => _tarih(a['tarih']).compareTo(_tarih(b['tarih'])));

    final son = eskiYeniSirali.last;
    final sonTarih = _tarih(son['tarih']);
    final sonCita = _toInt(son['citaSayisi']);
    final bool bolmeYapildi = _toInt(son['bolmeYapildi']) == 1;
    final bool kovanSondu = _toInt(son['kovanSondu']) == 1;
    final int balCita = _toInt(son['bal_cita']);
    final bool balAkimiAktif = await _balAkimiAktifMi(koloniId);

    double hamIvme = 0.0;
    double duzeltilmisIvme = 0.0;
    if (eskiYeniSirali.length >= 2) {
      final referansIndex = eskiYeniSirali.length >= 3
          ? eskiYeniSirali.length - 3
          : eskiYeniSirali.length - 2;
      final referans = eskiYeniSirali[referansIndex];
      hamIvme = (sonCita - _toInt(referans['citaSayisi'])).toDouble();
      final normalize = _normalizeEdilmisCitaFarki(
        oncekiMuayene: referans,
        sonMuayene: son,
        balAkimiAktif: balAkimiAktif,
      );
      duzeltilmisIvme = _toDouble(normalize['duzeltilmisFark']);
    }

    final pencereler = <Map<String, dynamic>>[
      _pencereHesapla(eskiYeniSirali, sonTarih, 7, balAkimiAktif: balAkimiAktif),
      _pencereHesapla(eskiYeniSirali, sonTarih, 14, balAkimiAktif: balAkimiAktif),
      _pencereHesapla(eskiYeniSirali, sonTarih, 21, balAkimiAktif: balAkimiAktif),
      _pencereHesapla(eskiYeniSirali, sonTarih, 42, balAkimiAktif: balAkimiAktif),
    ];

    final p7 = _oran(pencereler, 7);
    final p14 = _oran(pencereler, 14);
    final p21 = _oran(pencereler, 21);
    final p42 = _oran(pencereler, 42);

    final agirlikliMomentum = _agirlikliMomentum(p7, p14, p21, p42);
    final momentumEtiketi = _momentumEtiketi(agirlikliMomentum);
    final momentumSkoru = _momentumSkoru(agirlikliMomentum);

    String trend = 'Stabil';
    String aciklama = 'Koloni genel olarak stabil görünüyor.';

    if (kovanSondu) {
      trend = 'Sönmüş';
      aciklama = 'Son muayenede kovanın söndüğü işaretlenmiş.';
    } else if (bolmeYapildi) {
      trend = duzeltilmisIvme >= 0 ? 'Kontrollü Bölme' : 'Bölme Sonrası İzleme';
      aciklama = 'Bölme işaretli olduğu için çıta değişimi doğrudan zayıflama olarak okunmadı.';
    } else if (agirlikliMomentum >= 0.20) {
      trend = 'Güçlü Biyolojik Yön';
      aciklama = 'Koloni zamana göre güçlü biyolojik gelişim yönü gösteriyor.';
    } else if (agirlikliMomentum >= 0.07) {
      trend = 'Yükseliş';
      aciklama = 'Koloni zamana göre sağlıklı biyolojik gelişim yönünde.';
    } else if (balCita > 0 && duzeltilmisIvme < 0) {
      trend = 'Hasat Sonrası Stabil';
      aciklama = 'Bal sinyali mevcut; küçük düşüşler üretim / hasat bağlamında okunuyor.';
    } else if (agirlikliMomentum < -0.02 || duzeltilmisIvme < 0) {
      trend = 'Düşüş';
      aciklama = 'Koloni zamana göre güç kaybı eğilimi gösteriyor.';
    } else if (agirlikliMomentum > 0.0 && agirlikliMomentum < 0.07) {
      trend = 'Yavaş Gelişim';
      aciklama = 'Koloni gelişiyor ancak momentum düşük.';
    }

    return {
      'trend': trend,
      'ivme': duzeltilmisIvme,
      'hamIvme': hamIvme,
      'duzeltilmisIvme': duzeltilmisIvme,
      'gunlukMomentum': _yuvarla(agirlikliMomentum),
      'momentumSkoru': momentumSkoru,
      'momentumEtiketi': momentumEtiketi,
      'momentumAciklama': _momentumAciklama(momentumEtiketi, agirlikliMomentum),
      'pencereler': pencereler,
      'aciklama': aciklama,
      'gecmis': eskiYeniSirali
          .map(
            (m) => {
              'tarih': m['tarih'],
              'cita': _toInt(m['citaSayisi']),
              'bal': _toInt(m['bal_cita']),
              'bolmeYapildi': _toInt(m['bolmeYapildi']),
              'kovanSondu': _toInt(m['kovanSondu']),
            },
          )
          .toList(),
    };
  }

  static Future<double> arilikKislamaBasarisi(int arilikId) async {
    final koloniler = await VeritabaniServisi.kovanlariAriligaGoreGetir(arilikId);
    if (koloniler.isEmpty) return 0.0;

    double toplam = 0.0;
    int sayi = 0;

    for (final k in koloniler) {
      final guncel = _toInt(k['sonCita']);
      final zirve = _toInt(k['maxCitaKapasiye']);
      if (zirve <= 0) continue;
      toplam += (guncel / zirve);
      sayi++;
    }

    if (sayi == 0) return 0.0;
    return (toplam / sayi) * 100;
  }

  static Map<String, dynamic> _pencereHesapla(
    List<Map<String, dynamic>> sirali,
    DateTime sonTarih,
    int pencereGun, {
    required bool balAkimiAktif,
  }) {
    if (sirali.length < 2) {
      return {
        'gun': pencereGun,
        'citaFarki': 0,
        'gercekGun': 0,
        'gunlukArtis': 0.0,
        'etiket': 'Veri Yok',
      };
    }

    Map<String, dynamic>? referans;
    for (final m in sirali.reversed.skip(1)) {
      final tarih = _tarih(m['tarih']);
      final farkGun = sonTarih.difference(tarih).inDays.abs();
      if (farkGun >= math.max(3, (pencereGun * 0.45).round())) {
        referans = m;
        if (farkGun >= pencereGun) break;
      }
    }

    referans ??= sirali.first;
    final son = sirali.last;
    final gercekGun = math.max(1, sonTarih.difference(_tarih(referans['tarih'])).inDays.abs());
    final normalize = _normalizeEdilmisCitaFarki(
      oncekiMuayene: referans,
      sonMuayene: son,
      balAkimiAktif: balAkimiAktif,
    );
    final double citaFarki = _toDouble(normalize['duzeltilmisFark']);
    final double hamFark = _toDouble(normalize['hamFark']);
    final double gunlukArtis = citaFarki / gercekGun;

    return {
      'gun': pencereGun,
      'citaFarki': _yuvarla(citaFarki),
      'hamCitaFarki': _yuvarla(hamFark),
      'gercekGun': gercekGun,
      'gunlukArtis': _yuvarla(gunlukArtis),
      'etiket': _momentumEtiketi(gunlukArtis),
      'normalizeKodu': normalize['kod'],
      'normalizeAciklama': normalize['aciklama'],
      'aktivasyonOrani': normalize['aktivasyonOrani'],
      'hacimDegisimTipi': normalize['hacimDegisimTipi'],
    };
  }

  static double _agirlikliMomentum(double p7, double p14, double p21, double p42) {
    double toplam = 0.0;
    double agirlik = 0.0;
    void ekle(double v, double a) {
      if (v == 0.0) return;
      toplam += v * a;
      agirlik += a;
    }
    ekle(p7, 0.20);
    ekle(p14, 0.25);
    ekle(p21, 0.35);
    ekle(p42, 0.20);
    if (agirlik == 0) return 0.0;
    return toplam / agirlik;
  }

  static double _oran(List<Map<String, dynamic>> pencereler, int gun) {
    for (final p in pencereler) {
      if (_toInt(p['gun']) == gun) {
        final v = p['gunlukArtis'];
        if (v is num) return v.toDouble();
        return double.tryParse(v.toString()) ?? 0.0;
      }
    }
    return 0.0;
  }

  static String _momentumEtiketi(double gunlukArtis) {
    if (gunlukArtis >= 0.25) return 'Patlayıcı büyüme';
    if (gunlukArtis >= 0.15) return 'Güçlü büyüme';
    if (gunlukArtis >= 0.07) return 'Sağlıklı gelişim';
    if (gunlukArtis >= 0.03) return 'Yavaş gelişim';
    if (gunlukArtis > -0.02) return 'Duraklama';
    return 'Düşüş';
  }

  static int _momentumSkoru(double gunlukArtis) {
    if (gunlukArtis <= -0.08) return 0;
    final skor = ((gunlukArtis + 0.08) / 0.33 * 100).round();
    return skor.clamp(0, 100).toInt();
  }

  static String _momentumAciklama(String etiket, double gunlukArtis) {
    final oran = _yuvarla(gunlukArtis);
    return '$etiket: ortalama günlük biyolojik yön $oran olarak hesaplandı. Bu değer fiziksel çıta farkı değil; hasat, bölme, kat geçişi, işlevsel aktivasyon ve muayene aralığına göre normalize edilmiş saha tahminidir.';
  }

  static Map<String, dynamic> _normalizeEdilmisCitaFarki({
    required Map<String, dynamic> oncekiMuayene,
    required Map<String, dynamic> sonMuayene,
    required bool balAkimiAktif,
  }) {
    final int oncekiCita = _toInt(oncekiMuayene['citaSayisi']);
    final int sonCita = _toInt(sonMuayene['citaSayisi']);
    final double hamFark = (sonCita - oncekiCita).toDouble();

    final bool bolmeYapildi = _toInt(sonMuayene['bolmeYapildi']) == 1;
    final bool kovanSondu = _toInt(sonMuayene['kovanSondu']) == 1;

    if (kovanSondu) {
      return _normalizeSonuc(
        hamFark: hamFark,
        duzeltilmisFark: -999.0,
        kod: 'KOVAN_SONDU',
        aciklama: 'Kovan sönmüş işaretlendi; momentum gerçek biyolojik kayıp olarak okunur.',
      );
    }

    final aktivasyon = CitaAktivasyonServisi.hesapla(
      sonMuayene: sonMuayene,
      oncekiMuayene: oncekiMuayene,
      balAkimiAktif: balAkimiAktif,
    );

    final String hacimTipi = (aktivasyon['hacimDegisimTipi'] ?? '').toString();
    final double aktivasyonOrani = _toDouble(aktivasyon['aktivasyonOrani'] ?? 1.0)
        .clamp(0.0, 1.0)
        .toDouble();
    final double islevselCita = _toDouble(aktivasyon['islevselCitaOrta'] ?? sonCita);
    final bool hasatKaynakliDusus = aktivasyon['hasatKaynakliDusus'] == true ||
        hacimTipi == CitaAktivasyonServisi.hacimTipiHasatKaynakliDusus;
    final bool biyolojikZayiflamaSuphesi =
        hacimTipi == CitaAktivasyonServisi.hacimTipiBiyolojikZayiflamaSuphesi;
    final bool katGecisiVar = aktivasyon['katGecisiVar'] == true ||
        hacimTipi == CitaAktivasyonServisi.hacimTipiKatGecisi;
    final bool riskliSisirme = aktivasyon['riskliSisirme'] == true ||
        hacimTipi == CitaAktivasyonServisi.hacimTipiRiskliHizliGenisleme;
    final bool balAkimiGenislemesi = aktivasyon['balAkimiGenislemesi'] == true ||
        hacimTipi == CitaAktivasyonServisi.hacimTipiBallikUretimGenislemesi;
    final bool uretimGuvenli = aktivasyon['uretimGuvenliMi'] != false;

    if (bolmeYapildi && hamFark < 0) {
      return _normalizeSonuc(
        hamFark: hamFark,
        duzeltilmisFark: 0.0,
        kod: 'BOLME_NORMALIZE',
        aciklama: 'Bölme kaydı nedeniyle çıta düşüşü biyolojik zayıflama sayılmadı.',
        aktivasyon: aktivasyon,
      );
    }

    if (hasatKaynakliDusus && hamFark < 0) {
      return _normalizeSonuc(
        hamFark: hamFark,
        duzeltilmisFark: 0.0,
        kod: 'HASAT_NORMALIZE',
        aciklama: 'Bal/hasat kaydı nedeniyle çıta düşüşü biyolojik momentum cezası sayılmadı.',
        aktivasyon: aktivasyon,
      );
    }

    if (hamFark < 0) {
      final double duzeltilmis = biyolojikZayiflamaSuphesi
          ? hamFark
          : math.max(hamFark, -0.5).toDouble();
      return _normalizeSonuc(
        hamFark: hamFark,
        duzeltilmisFark: duzeltilmis,
        kod: biyolojikZayiflamaSuphesi
            ? 'BIYOLOJIK_DUSUS'
            : 'KUCUK_DUSUS_TEMKINLI',
        aciklama: biyolojikZayiflamaSuphesi
            ? 'Hasat/bölme kaydı olmadan belirgin çıta düşüşü biyolojik zayıflama şüphesiyle okundu.'
            : 'Küçük çıta düşüşü tam çöküş sayılmadan temkinli okundu.',
        aktivasyon: aktivasyon,
      );
    }

    if (hamFark <= 0) {
      return _normalizeSonuc(
        hamFark: hamFark,
        duzeltilmisFark: 0.0,
        kod: 'STABIL',
        aciklama: 'Fiziksel hacim değişmedi; momentum nötr okundu.',
        aktivasyon: aktivasyon,
      );
    }

    final double islevselFark = math.max(0.0, islevselCita - oncekiCita);

    if (riskliSisirme) {
      return _normalizeSonuc(
        hamFark: hamFark,
        duzeltilmisFark: math.min(islevselFark, hamFark * 0.35),
        kod: 'RISKI_SISIRME_FRENI',
        aciklama: 'Hızlı hacim artışı aktivasyon tamamlanmadan gerçek büyüme sayılmadı.',
        aktivasyon: aktivasyon,
      );
    }

    if (katGecisiVar && !balAkimiGenislemesi) {
      return _normalizeSonuc(
        hamFark: hamFark,
        duzeltilmisFark: math.min(islevselFark, hamFark * 0.55),
        kod: 'KAT_GECISI_TEMKINLI',
        aciklama: 'Kat/ballık geçişi fiziksel hacim artışı olarak görüldü; biyolojik momentum temkinli normalleştirildi.',
        aktivasyon: aktivasyon,
      );
    }

    if (!uretimGuvenli || aktivasyonOrani < 0.65) {
      return _normalizeSonuc(
        hamFark: hamFark,
        duzeltilmisFark: math.min(islevselFark, hamFark * 0.60),
        kod: 'AKTIVASYON_FRENI',
        aciklama: 'Yeni hacmin aktivasyonu düşük olduğu için büyüme sinyali frenlendi.',
        aktivasyon: aktivasyon,
      );
    }

    if (balAkimiGenislemesi) {
      return _normalizeSonuc(
        hamFark: hamFark,
        duzeltilmisFark: math.min(hamFark, math.max(islevselFark, hamFark * 0.75)),
        kod: 'BAL_AKIMI_GENISLEMESI',
        aciklama: 'Bal akımı içinde sağlıklı üst hacim genişlemesi biyolojik üretim yönü olarak okundu.',
        aktivasyon: aktivasyon,
      );
    }

    return _normalizeSonuc(
      hamFark: hamFark,
      duzeltilmisFark: math.min(hamFark, islevselFark),
      kod: 'ISLEVSEL_ARTIS',
      aciklama: 'Fiziksel artış işlevsel kapasiteye göre normalize edildi.',
      aktivasyon: aktivasyon,
    );
  }

  static Map<String, dynamic> _normalizeSonuc({
    required double hamFark,
    required double duzeltilmisFark,
    required String kod,
    required String aciklama,
    Map<String, dynamic>? aktivasyon,
  }) {
    return {
      'hamFark': _yuvarla(hamFark),
      'duzeltilmisFark': _yuvarla(duzeltilmisFark),
      'kod': kod,
      'aciklama': aciklama,
      'aktivasyonOrani': _yuvarla(_toDouble(aktivasyon?['aktivasyonOrani'] ?? 1.0)),
      'hacimDegisimTipi': (aktivasyon?['hacimDegisimTipi'] ?? '').toString(),
      'islevselCitaOrta': _yuvarla(_toDouble(aktivasyon?['islevselCitaOrta'] ?? 0.0)),
    };
  }

  static Future<bool> _balAkimiAktifMi(int koloniId) async {
    try {
      final koloni = await VeritabaniServisi.koloniOzetiGetir(koloniId);
      final int arilikId = _toInt(koloni['arilikId']);
      final balAkimi = await VeritabaniServisi.aktifBalAkimGetir(
        arilikId: arilikId > 0 ? arilikId : null,
      );
      final DateTime bugun = _tarih(DateTime.now().toIso8601String());
      final DateTime? bas = balAkimi?['bas'] as DateTime?;
      final DateTime? bit = balAkimi?['bit'] as DateTime?;
      if (bas == null || bit == null) return false;
      final basGun = DateTime(bas.year, bas.month, bas.day);
      final bitGun = DateTime(bit.year, bit.month, bit.day);
      return !bugun.isBefore(basGun) && !bugun.isAfter(bitGun);
    } catch (_) {
      return false;
    }
  }

  static DateTime _tarih(dynamic deger) {
    final metin = (deger ?? '').toString().trim();
    final dt = DateTime.tryParse(metin);
    if (dt != null) return DateTime(dt.year, dt.month, dt.day);
    if (metin.contains('.')) {
      final p = metin.split('.');
      if (p.length == 3) {
        final gun = int.tryParse(p[0]) ?? 1;
        final ay = int.tryParse(p[1]) ?? 1;
        final yil = int.tryParse(p[2]) ?? DateTime.now().year;
        return DateTime(yil, ay, gun);
      }
    }
    return DateTime(1900);
  }

  static int _toInt(dynamic deger) {
    if (deger == null) return 0;
    if (deger is int) return deger;
    if (deger is double) return deger.round();
    return int.tryParse(deger.toString()) ?? 0;
  }

  static double _toDouble(dynamic deger) {
    if (deger == null) return 0.0;
    if (deger is double) return deger;
    if (deger is int) return deger.toDouble();
    if (deger is num) return deger.toDouble();
    return double.tryParse(deger.toString()) ?? 0.0;
  }

  static double _yuvarla(double v) => double.parse(v.toStringAsFixed(3));
}
