import 'veritabani_servisi.dart';

class HatAnalizSonucu {
  final int kokKoloniId;
  final String kokKovanNo;
  final bool kokAktifMi;
  final int temsilKoloniId;
  final String temsilKovanNo;

  final int toplamKoloni;
  final int aktifKoloni;
  final int sonenKoloni;

  final double sonmeOrani;
  final double kisGucluCikisOrani;

  final double ortalamaMaxCita;
  final double ortalamaBalCita;

  final double hatSkoru;
  final String karar;
  final String gerekce;
  final List<String> notlar;
  final List<String> aksiyonlar;

  final bool ogulKaynakli;
  final bool ogulOlayiVar;
  final int ogulKaynakliKoloniSayisi;
  final int ogulOlayiKoloniSayisi;

  const HatAnalizSonucu({
    required this.kokKoloniId,
    required this.kokKovanNo,
    required this.kokAktifMi,
    required this.temsilKoloniId,
    required this.temsilKovanNo,
    required this.toplamKoloni,
    required this.aktifKoloni,
    required this.sonenKoloni,
    required this.sonmeOrani,
    required this.kisGucluCikisOrani,
    required this.ortalamaMaxCita,
    required this.ortalamaBalCita,
    required this.hatSkoru,
    required this.karar,
    required this.gerekce,
    required this.notlar,
    required this.aksiyonlar,
    required this.ogulKaynakli,
    required this.ogulOlayiVar,
    required this.ogulKaynakliKoloniSayisi,
    required this.ogulOlayiKoloniSayisi,
  });
}

class HatAnalizServisi {
  static Future<List<HatAnalizSonucu>> analizleriGetir() async {
    final koloniler = await VeritabaniServisi.kolonileriGetir(
      sadeceAktifler: false,
    );

    if (koloniler.isEmpty) return [];

    final ogulAtanIdler =
    await VeritabaniServisi.ogulAttanKoloniIdleriniGetir();

    final koloniIdleri = koloniler
        .map((k) => _toInt(k['id']))
        .where((id) => id > 0)
        .toList(growable: false);
    final aktiflikHaritasi =
    await VeritabaniServisi.koloniAktiflikHaritasiGetir(koloniIdleri);

    final Map<int, List<Map<String, dynamic>>> gruplar = {};

    for (final k in koloniler) {
      final int kokId = _kokKoloniIdBul(k);
      gruplar.putIfAbsent(kokId, () => []);
      gruplar[kokId]!.add(k);
    }

    final List<HatAnalizSonucu> sonuc = [];

    for (final entry in gruplar.entries) {
      final int kokId = entry.key;
      final List<Map<String, dynamic>> liste = entry.value;

      final Map<String, dynamic> kokKoloni = liste.firstWhere(
            (k) => _toInt(k['id']) == kokId,
        orElse: () => liste.first,
      );

      final int toplam = liste.length;
      int aktif = 0;
      int sonen = 0;
      final List<Map<String, dynamic>> aktifKoloniler = [];

      for (final koloni in liste) {
        final koloniId = _toInt(koloni['id']);
        final aktifMi = koloniId > 0
            ? (aktiflikHaritasi[koloniId] ?? false)
            : false;
        if (aktifMi) {
          aktif++;
          aktifKoloniler.add(koloni);
        } else {
          sonen++;
        }
      }

      aktifKoloniler.sort((a, b) {
        final int aSira = _toInt(a['sahaSirasi']);
        final int bSira = _toInt(b['sahaSirasi']);
        if (aSira != bSira) return aSira.compareTo(bSira);
        return _toInt(a['id']).compareTo(_toInt(b['id']));
      });

      final bool kokAktifMi = _koloniKaydiAktifMi(
        kokKoloni,
        aktiflikHaritasi,
      );
      final Map<String, dynamic> temsilKoloni = kokAktifMi
          ? kokKoloni
          : (aktifKoloniler.isNotEmpty ? aktifKoloniler.first : kokKoloni);

      // Tamamen sönmüş, yaşayan hiçbir devamı kalmamış hatlar
      // ana listede gösterilmez. Ama kök sönmüş olsa bile hatta en az
      // bir aktif koloni varsa hat görünmeye devam eder.
      if (aktif <= 0) {
        continue;
      }

      final double sonmeOrani =
      toplam == 0 ? 0 : (sonen / toplam) * 100.0;

      double maxCitaToplam = 0;
      double balToplam = 0;
      int kisGuclu = 0;

      int ogulKaynakliKoloniSayisi = 0;
      int ogulOlayiKoloniSayisi = 0;

      for (final k in liste) {
        final int maxCita = _maxCitaBul(k);
        final int balCita = _balCitaBul(k);

        maxCitaToplam += maxCita;
        balToplam += balCita;

        if (_kistanGucluCiktiMi(k)) {
          kisGuclu++;
        }

        final String kaynakTipi =
        (k['kaynakTipi'] ?? '').toString().toLowerCase();
        if (kaynakTipi.contains('oğul') || kaynakTipi.contains('ogul')) {
          ogulKaynakliKoloniSayisi++;
        }

        if (ogulAtanIdler.contains(_toInt(k['id']))) {
          ogulOlayiKoloniSayisi++;
        }
      }

      final double ortalamaMaxCita =
      toplam == 0 ? 0 : maxCitaToplam / toplam;
      final double ortalamaBalCita =
      toplam == 0 ? 0 : balToplam / toplam;
      final double kisGucluCikisOrani =
      toplam == 0 ? 0 : (kisGuclu / toplam) * 100.0;

      final bool ogulKaynakli = ogulKaynakliKoloniSayisi > 0;
      final bool ogulOlayiVar = ogulOlayiKoloniSayisi > 0;

      final bool veriYetersiz = toplam < 2;
      final bool tekrarEdenSonme = sonen >= 2;
      final bool yuksekSonmeOrani = sonmeOrani >= 35;
      final bool iyiGelisim = ortalamaMaxCita >= 10;
      final bool iyiBal = ortalamaBalCita >= 4;
      final bool iyiKisCikisi = kisGucluCikisOrani >= 60;

      double skor = 100;

      if (veriYetersiz) skor -= 25;
      if (ogulKaynakli) skor -= 40;
      if (ogulOlayiVar) skor -= (18 + (ogulOlayiKoloniSayisi * 5));
      if (sonen == 1) skor -= 10;
      if (tekrarEdenSonme) skor -= 25;
      if (yuksekSonmeOrani) skor -= 15;
      if (!iyiGelisim) skor -= 10;
      if (iyiBal) skor += 8;
      if (iyiKisCikisi) skor += 6;

      if (skor < 0) skor = 0;
      if (skor > 100) skor = 100;

      final List<String> notlar = [];
      final List<String> aksiyonlar = [];

      final String karar;
      final String gerekce;

      if (veriYetersiz) {
        karar = 'Veri Yetersiz';
        gerekce =
        'Bu hat için güvenilir karar üretecek kadar yeterli koloni geçmişi oluşmamış.';
        notlar.add('En az iki koloni ve daha fazla saha tekrarına ihtiyaç var.');
        aksiyonlar.add('Bu hat için veri toplamaya devam et');
        aksiyonlar.add('Erken damızlık kararı verme');
      } else if (ogulKaynakli || ogulOlayiVar) {
        karar = 'Operasyonel Hat';
        gerekce =
        'Bu hatta oğul kökeni veya gerçekleşmiş oğul olayı bulunduğu için donör hat olarak kabul edilmez.';
        if (ogulKaynakli) {
          notlar.add(
            'Bu hatta oğul kökenli koloni sayısı: $ogulKaynakliKoloniSayisi.',
          );
        }
        if (ogulOlayiVar) {
          notlar.add(
            'Bu hatta gerçekleşmiş oğul olayı görülen koloni sayısı: $ogulOlayiKoloniSayisi.',
          );
        }
        notlar.add(
          'Oğul temizliği bozulmuş hat, donör çoğaltma için uygun sayılmaz.',
        );
        aksiyonlar.add('Bu hattan ana üretme');
        aksiyonlar.add('Yeni bölme üretimini sınırlı tut');
        aksiyonlar.add('Üretim veya destek hattı olarak değerlendir');
      } else if (tekrarEdenSonme || yuksekSonmeOrani) {
        karar = 'Riskli Hat';
        gerekce =
        'Bu hatta tekrar eden sönme veya yüksek sönme oranı görülüyor.';
        notlar.add(
          'Sönme oranı %${sonmeOrani.toStringAsFixed(0)} düzeyinde.',
        );
        if (sonen >= 2) {
          notlar.add('Tekrarlayan sönmeler seçilim açısından güçlü negatif sinyaldir.');
        }
        aksiyonlar.add('Bu hattan bölme yapma');
        aksiyonlar.add('Donör havuzuna alma');
        aksiyonlar.add('Hat elemesini veya ana yenilemeyi değerlendir');
      } else if (iyiGelisim && iyiBal && iyiKisCikisi) {
        karar = 'Donör Hat';
        gerekce =
        'Hat; gelişim, üretim ve dayanıklılık açısından güçlü ve dengeli görünüyor.';
        notlar.add('Bu hat donör çoğaltma için öncelikli adaydır.');
        aksiyonlar.add('Bu hattan ana üret');
        aksiyonlar.add('Temiz çoğaltma hattı olarak koru');
        aksiyonlar.add('Donör havuzunda önceliklendir');
      } else if (iyiGelisim || iyiBal) {
        karar = 'Güçlü Üretim Hattı';
        gerekce =
        'Hat donör kadar temiz ve güçlü görünmese de üretim omurgası olarak değerlidir.';
        if (iyiGelisim) {
          notlar.add('Hat içinde gelişim gücü olumlu görünüyor.');
        }
        if (iyiBal) {
          notlar.add('Ortalama bal performansı olumlu ayrışıyor.');
        }
        aksiyonlar.add('Bu hattı üretimde koru');
        aksiyonlar.add('Sınırlı ve kontrollü bölme düşün');
        aksiyonlar.add('Donör değil, üretim omurgası olarak değerlendir');
      } else {
        karar = 'Takip Edilmeli';
        gerekce =
        'Hat tamamen zayıf görünmüyor; ancak çoğaltma kararı için daha net tekrar ve performans verisi gerekiyor.';
        notlar.add('Bu hat için izleme devam etmeli.');
        aksiyonlar.add('İzlemeye devam et');
        aksiyonlar.add('Kararı ertele, veri biriktir');
        aksiyonlar.add('Kritik kolonilerde muayene sıklığını artır');
      }

      if (sonen == 1) {
        notlar.add('Tek sönme doğrudan eleme değildir, ama uyarı sinyalidir.');
      }
      if (iyiKisCikisi) {
        notlar.add('Kıştan çıkış gücü olumlu görünüyor.');
      }
      if (!kokAktifMi) {
        notlar.add(
          'Kök koloni artık aktif değil; ancak bu hatta yaşayan alt koloniler bulunduğu için hat görünmeye devam ediyor.',
        );
      }

      sonuc.add(
        HatAnalizSonucu(
          kokKoloniId: kokId,
          kokKovanNo: (kokKoloni['kovanNo'] ?? '-').toString(),
          kokAktifMi: kokAktifMi,
          temsilKoloniId: _toInt(temsilKoloni['id']),
          temsilKovanNo: (temsilKoloni['kovanNo'] ?? '-').toString(),
          toplamKoloni: toplam,
          aktifKoloni: aktif,
          sonenKoloni: sonen,
          sonmeOrani: sonmeOrani,
          kisGucluCikisOrani: kisGucluCikisOrani,
          ortalamaMaxCita: ortalamaMaxCita,
          ortalamaBalCita: ortalamaBalCita,
          hatSkoru: skor,
          karar: karar,
          gerekce: gerekce,
          notlar: notlar,
          aksiyonlar: aksiyonlar,
          ogulKaynakli: ogulKaynakli,
          ogulOlayiVar: ogulOlayiVar,
          ogulKaynakliKoloniSayisi: ogulKaynakliKoloniSayisi,
          ogulOlayiKoloniSayisi: ogulOlayiKoloniSayisi,
        ),
      );
    }

    sonuc.sort((a, b) {
      final kararSirasi =
      _kararOnceligi(a.karar).compareTo(_kararOnceligi(b.karar));
      if (kararSirasi != 0) return kararSirasi;

      final skorSirasi = b.hatSkoru.compareTo(a.hatSkoru);
      if (skorSirasi != 0) return skorSirasi;

      return b.ortalamaBalCita.compareTo(a.ortalamaBalCita);
    });

    return sonuc;
  }

  static int _kokKoloniIdBul(Map<String, dynamic> k) {
    final kokKoloniId = _toInt(k['kokKoloniId']);
    if (kokKoloniId > 0) return kokKoloniId;

    final kaynakTipi = (k['kaynakTipi'] ?? '').toString().trim().toLowerCase();
    final kaynakKoloniId = _toInt(k['kaynakKoloniId']);

    if (kaynakTipi == 'ana hat' || kaynakKoloniId <= 0) {
      return _toInt(k['id']);
    }

    return kaynakKoloniId;
  }

  static bool _sonmusMu(Map<String, dynamic> k) {
    // Geriye dönük uyumluluk için tutulur.
    // Aktiflik kararı normal akışta merkezi aktiflik haritasından okunur;
    // id olmayan geçici kayıtlar aktif kabul edilmez.
    return VeritabaniServisi.sonmusDurumMu(k['durum']);
  }

  static bool _koloniKaydiAktifMi(
    Map<String, dynamic> k,
    Map<int, bool> aktiflikHaritasi,
  ) {
    final koloniId = _toInt(k['id']);
    if (koloniId <= 0) return false;
    return aktiflikHaritasi[koloniId] ?? false;
  }

  static int _maxCitaBul(Map<String, dynamic> k) {
    return _ilkDoluInt([
      k['maxCitaKapasiye'],
      k['maxCita'],
      k['sonCita'],
      k['citaSayisi'],
    ]);
  }

  static int _balCitaBul(Map<String, dynamic> k) {
    return _ilkDoluInt([
      k['bal_cita'],
      k['balCita'],
    ]);
  }

  static bool _kistanGucluCiktiMi(Map<String, dynamic> k) {
    final maxCita = _maxCitaBul(k);
    final sonCita = _ilkDoluInt([
      k['sonCita'],
      k['citaSayisi'],
    ]);

    if (maxCita <= 0) return false;

    final oran = sonCita / maxCita;
    return sonCita >= 6 && oran >= 0.55;
  }

  static int _ilkDoluInt(List<dynamic> adaylar) {
    for (final a in adaylar) {
      final v = _toInt(a);
      if (v > 0) return v;
    }
    return 0;
  }

  static int _kararOnceligi(String karar) {
    switch (karar) {
      case 'Donör Hat':
        return 0;
      case 'Güçlü Üretim Hattı':
        return 1;
      case 'Takip Edilmeli':
        return 2;
      case 'Veri Yetersiz':
        return 3;
      case 'Operasyonel Hat':
        return 4;
      case 'Riskli Hat':
        return 5;
      default:
        return 6;
    }
  }

  static int _toInt(dynamic deger) {
    if (deger == null) return 0;
    if (deger is int) return deger;
    if (deger is double) return deger.round();
    return int.tryParse(deger.toString()) ?? 0;
  }
}
