import 'dart:math' as math;

import 'veritabani_servisi.dart';

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

    double hamIvme = 0.0;
    double duzeltilmisIvme = 0.0;
    if (eskiYeniSirali.length >= 2) {
      final referansIndex = eskiYeniSirali.length >= 3
          ? eskiYeniSirali.length - 3
          : eskiYeniSirali.length - 2;
      final referans = eskiYeniSirali[referansIndex];
      hamIvme = (sonCita - _toInt(referans['citaSayisi'])).toDouble();
      duzeltilmisIvme = _duzeltilmisCitaFarki(
        oncekiCita: _toInt(referans['citaSayisi']),
        sonCita: sonCita,
        bolmeYapildi: bolmeYapildi,
        balCita: balCita,
        kovanSondu: kovanSondu,
      ).toDouble();
    }

    final pencereler = <Map<String, dynamic>>[
      _pencereHesapla(eskiYeniSirali, sonTarih, 7),
      _pencereHesapla(eskiYeniSirali, sonTarih, 14),
      _pencereHesapla(eskiYeniSirali, sonTarih, 21),
      _pencereHesapla(eskiYeniSirali, sonTarih, 42),
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
      trend = 'Güçlü Momentum';
      aciklama = 'Koloni zamana göre güçlü büyüme momentumu gösteriyor.';
    } else if (agirlikliMomentum >= 0.07) {
      trend = 'Yükseliş';
      aciklama = 'Koloni zamana göre sağlıklı gelişim yönünde.';
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
    int pencereGun,
  ) {
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
    final citaFarki = _duzeltilmisCitaFarki(
      oncekiCita: _toInt(referans['citaSayisi']),
      sonCita: _toInt(son['citaSayisi']),
      bolmeYapildi: _toInt(son['bolmeYapildi']) == 1,
      balCita: _toInt(son['bal_cita']),
      kovanSondu: _toInt(son['kovanSondu']) == 1,
    );
    final gunlukArtis = citaFarki / gercekGun;

    return {
      'gun': pencereGun,
      'citaFarki': citaFarki,
      'gercekGun': gercekGun,
      'gunlukArtis': _yuvarla(gunlukArtis),
      'etiket': _momentumEtiketi(gunlukArtis),
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
    return '$etiket: ortalama günlük çıta artışı $oran olarak hesaplandı. Bu değer kesin ölçüm değil, muayene aralıklarına göre normalize edilmiş saha tahminidir.';
  }

  static int _duzeltilmisCitaFarki({
    required int oncekiCita,
    required int sonCita,
    required bool bolmeYapildi,
    required int balCita,
    required bool kovanSondu,
  }) {
    if (kovanSondu) return -999;
    final fark = sonCita - oncekiCita;
    if (bolmeYapildi && fark < 0) return 0;
    if (balCita > 0 && fark < 0) return 0;
    return fark;
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

  static double _yuvarla(double v) => double.parse(v.toStringAsFixed(3));
}
