import 'koloni_karar_motoru.dart';
import 'veritabani_servisi.dart';
import 'ari_biyoloji_servisi.dart';
import 'koloni_biyolojik_model_servisi.dart';

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

    Map<String, dynamic> kabiliyet = const <String, dynamic>{};
    try {
      final biyolojikModel = await KoloniBiyolojikModelServisi.modelGetir(koloniId);
      kabiliyet = Map<String, dynamic>.from(
        biyolojikModel['kabiliyet'] ?? const <String, dynamic>{},
      );
    } catch (_) {
      // Performans özeti biyolojik kabiliyet hesabı başarısız olsa bile açılmalıdır.
      kabiliyet = const <String, dynamic>{};
    }

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
    final int muayeneSayisi = _toInt(profil['muayeneSayisi']);
    final String veriGuveniEtiketi = _veriGuveniEtiketi(muayeneSayisi);
    final String veriGuveniNotu = _veriGuveniNotu(muayeneSayisi);

    final int uremeHam = _toInt(profil['uremePuani']);
    final int uretimHam = _toInt(profil['uretimPuani']);
    final int dayaniklilikHam = _toInt(profil['dayaniklilikPuani']);
    final int davranisHam = _toInt(profil['davranisPuani']);
    final int soyHam = _toInt(profil['soyPuani']);
    final int veriGuveniHam = _toInt(profil['veriGuveniPuani']);
    final int momentum = _toInt(profil['momentumSkoru']);
    final String momentumEtiketi = _gelisimEtiketi((profil['momentumEtiketi'] ?? 'Veri Yok').toString());
    final int petekOrme = _toInt(kabiliyet['petekOrmePuani'] ?? profil['petekOrmePuani']);
    final int yavruBakim = _toInt(kabiliyet['yavruBakimPuani'] ?? profil['yavruBakimPuani']);
    final int nektarToplama = _toInt(kabiliyet['nektarToplamaPuani'] ?? profil['nektarToplamaPuani']);
    final int balIsleme = _toInt(kabiliyet['balIslemePuani'] ?? profil['balIslemePuani']);
    final int kisDayanim = _toInt(kabiliyet['kisDayanimPuani'] ?? profil['kisDayanimPuani']);

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
        yorum: veriGuveniEtiketi,
      ),
      KriterOzeti(
        ad: 'Biyolojik Durum',
        skor: _biyolojiSkoru(biyoloji),
        yorum: _biyolojiYorumu(biyoloji),
      ),
      KriterOzeti(
        ad: 'Üreme Gelişimi',
        skor: momentum,
        yorum: momentumEtiketi,
      ),
      KriterOzeti(
        ad: 'Petek Örme Kapasitesi',
        skor: petekOrme,
        yorum: _kabiliyetYorumu(petekOrme),
      ),
      KriterOzeti(
        ad: 'Yavru Bakım Kapasitesi',
        skor: yavruBakim,
        yorum: _kabiliyetYorumu(yavruBakim),
      ),
      KriterOzeti(
        ad: 'Bal Akımı Kapasitesi',
        skor: ((nektarToplama + balIsleme) / 2).round(),
        yorum: _kabiliyetYorumu(((nektarToplama + balIsleme) / 2).round()),
      ),
      KriterOzeti(
        ad: 'Kış Güvenliği',
        skor: kisDayanim,
        yorum: _kabiliyetYorumu(kisDayanim),
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
    kontrol('Üreme Gelişimi', momentum);
    kontrol('Petek Örme Kapasitesi', petekOrme);
    kontrol('Yavru Bakım Kapasitesi', yavruBakim);
    kontrol('Bal Akımı Kapasitesi', ((nektarToplama + balIsleme) / 2).round());
    kontrol('Kış Güvenliği', kisDayanim);
    if (muayeneSayisi == 1) {
      zayif.add('Veri çok sınırlı: tek muayene karar üretir ama donör ve ana değişim kararları temkinli okunur.');
    } else if (muayeneSayisi >= 2 && muayeneSayisi <= 4) {
      zayif.add('Veri izlenmeli: 2–4 muayene karar verir ama güveni tam sayılmaz.');
    } else if (muayeneSayisi >= 5) {
      guclu.add('Veri güveni yeterli: 5 ve üzeri muayene ile değerlendirme güçlü banda girmiştir.');
    }

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
      profil: {
        ...profil,
        'veriGuveniEtiketi': veriGuveniEtiketi,
        'veriGuveniNotu': veriGuveniNotu,
        'petekOrmePuani': petekOrme,
        'yavruBakimPuani': yavruBakim,
        'nektarToplamaPuani': nektarToplama,
        'balIslemePuani': balIsleme,
        'kisDayanimPuani': kisDayanim,
      },
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
        'veriGuveniEtiketi': veriGuveniEtiketi,
        'veriGuveniNotu': veriGuveniNotu,
        'petekOrmePuani': petekOrme,
        'yavruBakimPuani': yavruBakim,
        'nektarToplamaPuani': nektarToplama,
        'balIslemePuani': balIsleme,
        'kisDayanimPuani': kisDayanim,
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

  static String _kabiliyetYorumu(int puan) {
    if (puan >= 80) return 'Güçlü';
    if (puan >= 60) return 'Yeterli';
    if (puan >= 40) return 'Sınırlı';
    if (puan > 0) return 'Zayıf';
    return 'Veri yok';
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
      return 'Bu koloni kendi geçmişinde oğul attığı için ana üretme havuzundan çıkarıldı. Üretimde kullanılabilir; ancak genetik seçim havuzunda değildir.';
    }

    if (dogrudanOgulKokenli || kaynakTipiOgul) {
      return 'Bu koloni oğul kökenli olduğu için ana üretme havuzuna alınmadı. Performansı ayrı okunur; üretim, destek veya kapalı yavru desteğinde değerlendirilebilir.';
    }

    if (ataHattaOgulAtti) {
      return 'Bu koloni atasal hatta oğul izi taşıdığı için temiz donör havuzunda değerlendirilmedi. Ana üretme; üretim ve saha desteği için ayrı değerlendir.';
    }

    return 'Donör veto kriteri nedeniyle ana üretme havuzu dışında tutuldu. Bu durum genel performansı düşürmez; yalnızca genetik seçilim sonucunu etkiler.';
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
    final String veriGuveniNotu = (profil['veriGuveniNotu'] ?? '').toString().trim();
    final String veriGuveniCumlesi = veriGuveniNotu.isEmpty ? '' : ' Veri güveni: $veriGuveniNotu';

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
      return 'Genetik seçilimde veto alıyor.$kisCumlesi $performansCumlesi Donörlükten çıkma nedeni performans değil, seçilim filtresidir.$veriGuveniCumlesi$biyolojiCumlesi';
    }

    if (donorSirasi == 1) {
      return '$performansCumlesi$kisCumlesi Bu koloni temiz donör havuzunda 1. sıradadır.$veriGuveniCumlesi$biyolojiCumlesi';
    }

    if (donorSirasi == 2) {
      return '$performansCumlesi$kisCumlesi Bu koloni temiz donör havuzunda güçlü bir alternatiftir.$veriGuveniCumlesi$biyolojiCumlesi';
    }

    if (donorSirasi == 3) {
      return '$performansCumlesi$kisCumlesi Bu koloni temiz donör havuzunda yedek güçlü adaydır.$veriGuveniCumlesi$biyolojiCumlesi';
    }

    if (donorSkoru >= 60 && skor >= 70) {
      return '$performansCumlesi$kisCumlesi Temiz donör havuzunda yer alsa da ilk sırada görünmüyor.$veriGuveniCumlesi$biyolojiCumlesi';
    }

    if (kararKodu == 'ANA_DEGISIM' || kararKodu == 'ANA_DEGISIM_DUSUN') {
      return '$performansCumlesi Ana değişimi için standart yaş eşiği 2 yıldır; performans düşüyorsa yenileme düşünülmelidir.$veriGuveniCumlesi$biyolojiCumlesi';
    }

    if (kararKodu == 'BOLME' || kararKodu == 'BOLME_ICIN_UYGUN') {
      return '$performansCumlesi Bu koloni donör önceliğinde değilse bölme gücü açısından değerlendirilebilir.$veriGuveniCumlesi$biyolojiCumlesi';
    }

    if (kararKodu == 'URETIM' ||
        kararKodu == 'URETIM_IZLE' ||
        kararKodu == 'URETIMDE_DEGERLENDIR') {
      return '$performansCumlesi Üretim ve saha sürekliliği açısından değerlidir.$veriGuveniCumlesi$biyolojiCumlesi';
    }

    return '$performansCumlesi Seçilim yeri ile saha kullanımı birlikte izlenmelidir.$veriGuveniCumlesi$biyolojiCumlesi';
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

  static String _veriGuveniEtiketi(int muayeneSayisi) {
    if (muayeneSayisi <= 0) return 'Veri yok';
    if (muayeneSayisi == 1) return 'Veri çok sınırlı';
    if (muayeneSayisi <= 4) return 'İzlenmeli';
    return 'Güvenilir';
  }

  static String _veriGuveniNotu(int muayeneSayisi) {
    if (muayeneSayisi <= 0) {
      return 'Henüz muayene kaydı yok.';
    }
    if (muayeneSayisi == 1) {
      return 'Tek muayene karar üretir ama güven zayıftır.';
    }
    if (muayeneSayisi <= 4) {
      return '2–4 muayene izleme bandıdır.';
    }
    return '5 ve üzeri muayene güvenilir değerlendirme başlangıcıdır.';
  }


  static String _gelisimEtiketi(String etiket) {
    final temiz = etiket.trim();
    if (temiz.isEmpty) return 'Veri yok';

    final kucuk = temiz.toLowerCase();
    if (kucuk.contains('momentum')) {
      return temiz
          .replaceAll('Momentum', 'Üreme gelişimi')
          .replaceAll('momentum', 'üreme gelişimi');
    }
    if (kucuk.contains('güçlü') || kucuk.contains('guclu') || kucuk.contains('yükseliş')) {
      return 'Üreme gelişimi güçlü';
    }
    if (kucuk.contains('düşüş') || kucuk.contains('dus')) {
      return 'Üreme gelişimi zayıflıyor';
    }
    if (kucuk.contains('stabil') || kucuk.contains('durağan')) {
      return 'Üreme gelişimi dengeli';
    }
    return temiz == 'Veri Yok' ? 'Veri yok' : temiz;
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
