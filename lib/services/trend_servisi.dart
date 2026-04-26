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
        'gecmis': <Map<String, dynamic>>[],
        'aciklama': 'Henüz muayene verisi bulunmuyor.',
      };
    }

    final eskiYeniSirali = List<Map<String, dynamic>>.from(muayeneler.reversed);

    double hamIvme = 0.0;
    double duzeltilmisIvme = 0.0;

    if (eskiYeniSirali.length >= 3) {
      final son = eskiYeniSirali.last;
      final referans = eskiYeniSirali[eskiYeniSirali.length - 3];

      hamIvme = (_toInt(son['citaSayisi']) - _toInt(referans['citaSayisi']))
          .toDouble();

      duzeltilmisIvme = _duzeltilmisCitaFarki(
        oncekiCita: _toInt(referans['citaSayisi']),
        sonCita: _toInt(son['citaSayisi']),
        bolmeYapildi: _toInt(son['bolmeYapildi']) == 1,
        balCita: _toInt(son['bal_cita']),
        kovanSondu: _toInt(son['kovanSondu']) == 1,
      ).toDouble();
    } else if (eskiYeniSirali.length >= 2) {
      final son = eskiYeniSirali.last;
      final referans = eskiYeniSirali[eskiYeniSirali.length - 2];

      hamIvme = (_toInt(son['citaSayisi']) - _toInt(referans['citaSayisi']))
          .toDouble();

      duzeltilmisIvme = _duzeltilmisCitaFarki(
        oncekiCita: _toInt(referans['citaSayisi']),
        sonCita: _toInt(son['citaSayisi']),
        bolmeYapildi: _toInt(son['bolmeYapildi']) == 1,
        balCita: _toInt(son['bal_cita']),
        kovanSondu: _toInt(son['kovanSondu']) == 1,
      ).toDouble();
    }

    final sonMuayene = eskiYeniSirali.last;
    final bool bolmeYapildi = _toInt(sonMuayene['bolmeYapildi']) == 1;
    final bool kovanSondu = _toInt(sonMuayene['kovanSondu']) == 1;
    final int balCita = _toInt(sonMuayene['bal_cita']);

    String trend = 'Stabil';
    String aciklama = 'Koloni genel olarak stabil görünüyor.';

    if (kovanSondu) {
      trend = 'Sönmüş';
      aciklama =
      'Son muayenede kovanın söndüğü işaretlenmiş. Bu nedenle aktif gelişim trendi yerine yaşam döngüsü sonu bilgisi gösteriliyor.';
    } else if (bolmeYapildi) {
      if (duzeltilmisIvme >= 0) {
        trend = 'Kontrollü Bölme';
        aciklama =
        'Son muayenede bölme işaretli. Çıta düşüşü doğrudan zayıflama sayılmadı; kontrollü çoğalma olarak yorumlandı.';
      } else {
        trend = 'Bölme Sonrası İzleme';
        aciklama =
        'Son muayenede bölme işaretli. Bölme sonrası koloni yönü izlenmeli.';
      }
    } else if (balCita > 0 && duzeltilmisIvme < 0) {
      trend = 'Hasat Sonrası Stabil';
      aciklama =
      'Bal sinyali mevcut. Küçük düşüşler doğrudan zayıflama değil, üretim / hasat bağlamında okunuyor.';
    } else if (duzeltilmisIvme > 0) {
      trend = 'Yükseliş';
      aciklama = 'Koloni düzeltilmiş ivmeye göre yükseliş gösteriyor.';
    } else if (duzeltilmisIvme < 0) {
      trend = 'Düşüş';
      aciklama = 'Koloni düzeltilmiş ivmeye göre düşüş gösteriyor.';
    }

    return {
      'trend': trend,
      'ivme': duzeltilmisIvme,
      'hamIvme': hamIvme,
      'duzeltilmisIvme': duzeltilmisIvme,
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
    final koloniler =
    await VeritabaniServisi.kovanlariAriligaGoreGetir(arilikId);

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

  static int _duzeltilmisCitaFarki({
    required int oncekiCita,
    required int sonCita,
    required bool bolmeYapildi,
    required int balCita,
    required bool kovanSondu,
  }) {
    if (kovanSondu) {
      return -999;
    }

    final fark = sonCita - oncekiCita;

    if (bolmeYapildi && fark < 0) {
      return 0;
    }

    if (balCita > 0 && fark < 0) {
      return 0;
    }

    return fark;
  }

  static int _toInt(dynamic deger) {
    if (deger == null) return 0;
    if (deger is int) return deger;
    return int.tryParse(deger.toString()) ?? 0;
  }
}