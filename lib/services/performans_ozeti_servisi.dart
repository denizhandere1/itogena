import 'koloni_karar_motoru.dart';
import 'veritabani_servisi.dart';
import 'ari_biyoloji_servisi.dart';

class PerformansOzeti {
  final int genelSkor;
  final String durum;

  final bool donorMu;
  final int? donorSirasi;

  final bool vetoVarMi;
  final String? vetoNedeni;

  final int donorSkoru;

  final List<KriterOzeti> kriterler;

  final List<String> gucluYonler;
  final List<String> zayifYonler;

  final String genelYorum;

  final Map<String, dynamic> hamProfil;

  PerformansOzeti({
    required this.genelSkor,
    required this.durum,
    required this.donorMu,
    required this.donorSirasi,
    required this.vetoVarMi,
    required this.vetoNedeni,
    required this.donorSkoru,
    required this.kriterler,
    required this.gucluYonler,
    required this.zayifYonler,
    required this.genelYorum,
    required this.hamProfil,
  });
}

class KriterOzeti {
  final String ad;
  final int skor;
  final String yorum;

  KriterOzeti({
    required this.ad,
    required this.skor,
    required this.yorum,
  });
}

class PerformansOzetiServisi {
  static Future<PerformansOzeti> getir(int koloniId) async {
    final koloni = await VeritabaniServisi.koloniOzetiGetir(koloniId);
    final sonuc = await KoloniKararMotoru.kararUret(koloniId, koloni);
    final biyoloji = await AriBiyolojiServisi.analizYap(koloniId);

    final profil = Map<String, dynamic>.from(sonuc.profil)
      ..addAll({
        'biyolojiDurumKodu': biyoloji.durumKodu,
        'biyolojiBaslik': biyoloji.baslik,
        'biyolojiMesaj': biyoloji.mesaj,
        'biyolojiAnaUretimIcinUygun': biyoloji.anaUretimIcinUygun,
        'biyolojiZamanKritik': biyoloji.zamanKritik,
        'biyolojiMudahaleGerekli': biyoloji.mudahaleGerekli,
        'biyolojiMemeTakibiGecikmis': biyoloji.memeTakibiGecikmis,
        'biyolojiAnasizlikGunSayisi': biyoloji.anasizlikGunSayisi,
        'biyolojiMemeTakipDurumu': biyoloji.memeTakipDurumu,
        'biyolojiNotlar': biyoloji.notlar,
      });

    final int genelSkor = _toInt(profil['skor']);
    final int donorSkoru = _toInt(profil['donorSkoru']);

    final int donorSirasi = sonuc.donorSirasi;
    final bool donorMu = donorSirasi > 0;
    final bool veto = sonuc.donorVeto;

    final String? vetoNedeni = _vetoMetniOlustur(profil);

    final int uremeHam = _toInt(profil['uremePuani']);
    final int uretimHam = _toInt(profil['uretimPuani']);
    final int dayaniklilikHam = _toInt(profil['dayaniklilikPuani']);
    final int davranisHam = _toInt(profil['davranisPuani']);
    final int soyHam = _toInt(profil['soyPuani']);
    final int veriGuveniHam = _toInt(profil['veriGuveniPuani']);

    final int ureme = _normalizeTo100(uremeHam, 30);
    final int uretim = _normalizeTo100(uretimHam, 20);
    final int dayaniklilik = _normalizeTo100(dayaniklilikHam, 20);
    final int davranis = _normalizeTo100(davranisHam, 10);
    final int soy = _normalizeTo100(soyHam, 15);
    final int veriGuveni = _normalizeTo100(veriGuveniHam, 5);

    final kriterler = <KriterOzeti>[
      KriterOzeti(ad: 'Üreme', skor: ureme, yorum: _yorum(ureme)),
      KriterOzeti(ad: 'Üretim', skor: uretim, yorum: _yorum(uretim)),
      KriterOzeti(
        ad: 'Dayanıklılık',
        skor: dayaniklilik,
        yorum: _yorum(dayaniklilik),
      ),
      KriterOzeti(ad: 'Davranış', skor: davranis, yorum: _yorum(davranis)),
      KriterOzeti(ad: 'Hat Gücü', skor: soy, yorum: _yorum(soy)),
      KriterOzeti(
        ad: 'Veri Güveni',
        skor: veriGuveni,
        yorum: _yorum(veriGuveni),
      ),
      KriterOzeti(
        ad: 'Biyolojik Durum',
        skor: _biyolojiSkoru(biyoloji),
        yorum: _biyolojiYorumu(biyoloji),
      ),
    ];

    final guclu = <String>[];
    final zayif = <String>[];

    void kontrol(String ad, int s) {
      if (s >= 80) guclu.add('$ad güçlü.');
      if (s < 50) zayif.add('$ad zayıf.');
    }

    kontrol('Üreme', ureme);
    kontrol('Üretim', uretim);
    kontrol('Dayanıklılık', dayaniklilik);
    kontrol('Davranış', davranis);
    kontrol('Hat Gücü', soy);
    kontrol('Veri Güveni', veriGuveni);

    final int biyolojiSkoru = _biyolojiSkoru(biyoloji);
    if (biyolojiSkoru >= 80) {
      guclu.add('Biyolojik zamanlama uygun.');
    } else if (biyolojiSkoru < 50) {
      zayif.add('Biyolojik zamanlama dikkat istiyor.');
    }

    if (biyoloji.anaUretimIcinUygun) {
      guclu.add('Ana üretimi için uygun pencere görünüyor.');
    }
    if (biyoloji.memeTakibiGecikmis) {
      zayif.add('Meme takibi gecikmiş olabilir.');
    }
    if (biyoloji.zamanKritik) {
      zayif.add('Biyolojik süreçte zaman kritik hale gelmiş.');
    }

    final String durum = _durumMetni(genelSkor, veto, donorMu, donorSirasi);
    final String genelYorum = _genelYorumOlustur(
      skor: genelSkor,
      donorSkoru: donorSkoru,
      donorSirasi: donorSirasi,
      veto: veto,
      kararKodu: sonuc.kararKodu,
      profil: profil,
      biyoloji: biyoloji,
    );

    return PerformansOzeti(
      genelSkor: genelSkor,
      durum: durum,
      donorMu: donorMu,
      donorSirasi: donorMu ? donorSirasi : null,
      vetoVarMi: veto,
      vetoNedeni: vetoNedeni,
      donorSkoru: donorSkoru,
      kriterler: kriterler,
      gucluYonler: guclu,
      zayifYonler: zayif,
      genelYorum: genelYorum,
      hamProfil: {
        ...profil,
        'uremePuaniHam': uremeHam,
        'uretimPuaniHam': uretimHam,
        'dayaniklilikPuaniHam': dayaniklilikHam,
        'davranisPuaniHam': davranisHam,
        'soyPuaniHam': soyHam,
        'veriGuveniPuaniHam': veriGuveniHam,
      },
    );
  }

  static int _biyolojiSkoru(BiyolojiAnalizSonucu biyoloji) {
    int skor = 100;
    if (!biyoloji.veriVarMi) skor -= 35;
    if (biyoloji.memeTakibiGecikmis) skor -= 20;
    if (biyoloji.mudahaleGerekli) skor -= 20;
    if (biyoloji.zamanKritik) skor -= 25;
    if (biyoloji.anaUretimIcinUygun) skor += 5;
    if (skor < 0) skor = 0;
    if (skor > 100) skor = 100;
    return skor;
  }

  static String _biyolojiYorumu(BiyolojiAnalizSonucu biyoloji) {
    if (!biyoloji.veriVarMi) return 'Biyolojik veri yetersiz';
    if (biyoloji.zamanKritik) return 'Zaman kritik';
    if (biyoloji.mudahaleGerekli) return 'Müdahale gerekli';
    if (biyoloji.anaUretimIcinUygun) return 'Uygun';
    if (biyoloji.memeTakibiGecikmis) return 'Dikkat';
    return 'İzlenmeli';
  }
  static String? _vetoMetniOlustur(Map<String, dynamic> profil) {
    final bool donorVeto = (profil['donorVeto'] ?? false) == true;
    if (!donorVeto) return null;

    final bool dogrudanOgulKokenli =
        (profil['dogrudanOgulKokenli'] ?? false) == true;
    final bool kendisiOgulAtti =
        (profil['kendisiOgulAtti'] ?? false) == true;
    final bool kaynakTipiOgul =
        (profil['kaynakTipiOgul'] ?? false) == true;
    final bool ataHattaOgulAtti =
        (profil['ataHattaOgulAtti'] ?? false) == true;

    if (kendisiOgulAtti) {
      return 'Bu koloni kendi geçmişinde oğul attığı için donör havuzundan çıkarıldı. Bu, performans cezası değil; seçilim filtresidir.';
    }

    if (dogrudanOgulKokenli || kaynakTipiOgul) {
      return 'Bu koloni oğul kökenli olduğu için donör havuzuna alınmadı. Bu, performans düşüklüğü anlamına gelmez; sadece temiz donör havuzunda yer almaz.';
    }

    if (ataHattaOgulAtti) {
      return 'Bu koloni atasal hatta oğul izi taşıdığı için temiz donör havuzunda değerlendirilmedi. Performansı ayrıca kendi verisiyle okunur.';
    }

    return 'Donör veto kriteri nedeniyle donör havuzu dışında tutuldu. Bu durum performans puanını düşürmez; yalnızca seçilim sonucunu etkiler.';
  }

  static String _kisCikisOzetMetni(Map<String, dynamic> profil) {
    final bool veriVar = (profil['kisCikisVeriYeterliMi'] ?? false) == true;
    final String yorum = (profil['kisCikisYorum'] ?? '').toString().trim();

    if (!veriVar) {
      return yorum.isNotEmpty ? yorum : 'Kış çıkış verisi yetersiz.';
    }

    final int girisCita = _toInt(profil['kisGirisReferansCita']);
    final int cikisCita = _toInt(profil['kisSonuReferansCita']);
    final String girisTarih =
    (profil['kisGirisReferansTarih'] ?? '').toString().trim();
    final String cikisTarih =
    (profil['kisSonuReferansTarih'] ?? '').toString().trim();
    final double oran = _toDouble(profil['kisCikisOrani']) * 100;

    final List<String> parcalar = [];

    if (yorum.isNotEmpty) {
      parcalar.add('Kış çıkışı: $yorum.');
    }

    if (girisCita > 0 || cikisCita > 0) {
      parcalar.add('Referans çıta: $girisCita → $cikisCita.');
    }

    if (oran > 0) {
      parcalar.add('Koruma oranı: %${oran.toStringAsFixed(0)}.');
    }

    if (girisTarih.isNotEmpty && cikisTarih.isNotEmpty) {
      parcalar.add('Aralık: $girisTarih / $cikisTarih.');
    }

    return parcalar.join(' ');
  }

  static String _genelYorumOlustur({
    required int skor,
    required int donorSkoru,
    required int donorSirasi,
    required bool veto,
    required String kararKodu,
    required Map<String, dynamic> profil,
    required BiyolojiAnalizSonucu biyoloji,
  }) {
    final String kisYorum = _kisCikisOzetMetni(profil);
    final bool kisVeriVar = (profil['kisCikisVeriYeterliMi'] ?? false) == true;

    final String performansCumlesi;
    if (skor >= 85) {
      performansCumlesi = 'Performansı üst seviyede görünüyor.';
    } else if (skor >= 70) {
      performansCumlesi = 'Performansı güçlü görünüyor.';
    } else if (skor >= 50) {
      performansCumlesi = 'Performansı orta seviyede görünüyor.';
    } else {
      performansCumlesi = 'Performansı şu aşamada zayıf görünüyor.';
    }

    final String kisCumlesi = kisVeriVar && kisYorum.isNotEmpty
        ? ' Kış çıkışı "$kisYorum" düzeyinde.'
        : '';

    final String biyolojiCumlesi;
    if (!biyoloji.veriVarMi) {
      biyolojiCumlesi = ' Biyolojik zamanlama verisi henüz sınırlı.';
    } else if (biyoloji.zamanKritik) {
      biyolojiCumlesi = ' Biyolojik süreçte zaman kritik görünüyor.';
    } else if (biyoloji.mudahaleGerekli) {
      biyolojiCumlesi = ' Biyolojik süreçte müdahale ihtiyacı var.';
    } else if (biyoloji.anaUretimIcinUygun) {
      biyolojiCumlesi = ' Biyolojik pencere ana üretimi için uygun görünüyor.';
    } else {
      biyolojiCumlesi = ' Biyolojik süreç izlenmeli.';
    }

    if (veto) {
      return 'Genetik seçilimde veto alıyor.$kisCumlesi $performansCumlesi Donörlükten çıkma nedeni performans değil, seçilim filtresidir.$biyolojiCumlesi';
    }

    if (donorSirasi == 1) {
      return '$performansCumlesi$kisCumlesi Bu koloni temiz donör havuzunda 1. sıradadır.$biyolojiCumlesi';
    }

    if (donorSirasi == 2) {
      return '$performansCumlesi$kisCumlesi Bu koloni temiz donör havuzunda güçlü bir alternatiftir.$biyolojiCumlesi';
    }

    if (donorSirasi == 3) {
      return '$performansCumlesi$kisCumlesi Bu koloni temiz donör havuzunda yedek güçlü adaydır.$biyolojiCumlesi';
    }

    if (donorSkoru >= 60 && skor >= 70) {
      return '$performansCumlesi$kisCumlesi Temiz donör havuzunda yer alsa da ilk sırada görünmüyor.$biyolojiCumlesi';
    }

    if (kararKodu == 'ANA_DEGISIM' || kararKodu == 'ANA_DEGISIM_DUSUN') {
      return '$performansCumlesi Ana değişimi düşünülmesi gereken bir tablo oluşmuş görünüyor.$biyolojiCumlesi';
    }

    if (kararKodu == 'BOLME' || kararKodu == 'BOLME_ICIN_UYGUN') {
      return '$performansCumlesi Bu koloni donör önceliğinde değilse bölme gücü açısından değerlendirilebilir.$biyolojiCumlesi';
    }

    if (kararKodu == 'URETIM' ||
        kararKodu == 'URETIM_IZLE' ||
        kararKodu == 'URETIMDE_DEGERLENDIR') {
      return '$performansCumlesi Üretim ve saha sürekliliği açısından değerlidir.$biyolojiCumlesi';
    }

    return '$performansCumlesi Seçilim yeri ile saha kullanımı birlikte izlenmelidir.$biyolojiCumlesi';
  }

  static String _durumMetni(
      int skor,
      bool veto,
      bool donorMu,
      int donorSirasi,
      ) {
    if (veto) return 'Genetik Veto';
    if (donorMu && donorSirasi == 1) return '1. Donör Adayı';
    if (donorMu && donorSirasi == 2) return '2. Donör Adayı';
    if (donorMu && donorSirasi == 3) return '3. Donör Adayı';
    if (donorMu) return 'Şartlı Donör';
    if (skor >= 70) return 'Güçlü Üretim';
    if (skor >= 50) return 'İzlenmeli';
    return 'Müdahale';
  }

  static String _yorum(int skor) {
    if (skor >= 85) return 'Çok güçlü';
    if (skor >= 70) return 'Güçlü';
    if (skor >= 50) return 'Orta';
    return 'Zayıf';
  }

  static int _normalizeTo100(int ham, int max) {
    if (max <= 0) return 0;
    final deger = ((ham / max) * 100).round();
    if (deger < 0) return 0;
    if (deger > 100) return 100;
    return deger;
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }
}
