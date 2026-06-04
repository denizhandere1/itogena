import 'veritabani_servisi.dart';

class BiyolojiTakvimBilgisi {
  final String anaKazanmaYontemi;
  final DateTime baslangic;
  final DateTime? memeKapanmaBaslangic;
  final DateTime? memeKapanmaBitis;
  final DateTime? anaCikisiBaslangic;
  final DateTime? anaCikisiBitis;
  final DateTime? ciftlesmeBaslangic;
  final DateTime? ciftlesmeBitis;
  final DateTime? yumurtlamaKontrolBaslangic;
  final DateTime? yumurtlamaKontrolBitis;
  final DateTime? kovanaDokunmaBaslangic;
  final DateTime? kovanaDokunmaBitis;
  final DateTime? kabulKontrolBaslangic;
  final DateTime? kabulKontrolBitis;

  const BiyolojiTakvimBilgisi({
    required this.anaKazanmaYontemi,
    required this.baslangic,
    this.memeKapanmaBaslangic,
    this.memeKapanmaBitis,
    this.anaCikisiBaslangic,
    this.anaCikisiBitis,
    this.ciftlesmeBaslangic,
    this.ciftlesmeBitis,
    this.yumurtlamaKontrolBaslangic,
    this.yumurtlamaKontrolBitis,
    this.kovanaDokunmaBaslangic,
    this.kovanaDokunmaBitis,
    this.kabulKontrolBaslangic,
    this.kabulKontrolBitis,
  });

  Map<String, dynamic> toMap() {
    return {
      'anaKazanmaYontemi': anaKazanmaYontemi,
      'baslangic': _iso(baslangic),
      'memeKapanmaBaslangic': _isoOrNull(memeKapanmaBaslangic),
      'memeKapanmaBitis': _isoOrNull(memeKapanmaBitis),
      'anaCikisiBaslangic': _isoOrNull(anaCikisiBaslangic),
      'anaCikisiBitis': _isoOrNull(anaCikisiBitis),
      'ciftlesmeBaslangic': _isoOrNull(ciftlesmeBaslangic),
      'ciftlesmeBitis': _isoOrNull(ciftlesmeBitis),
      'yumurtlamaKontrolBaslangic': _isoOrNull(yumurtlamaKontrolBaslangic),
      'yumurtlamaKontrolBitis': _isoOrNull(yumurtlamaKontrolBitis),
      'kovanaDokunmaBaslangic': _isoOrNull(kovanaDokunmaBaslangic),
      'kovanaDokunmaBitis': _isoOrNull(kovanaDokunmaBitis),
      'kabulKontrolBaslangic': _isoOrNull(kabulKontrolBaslangic),
      'kabulKontrolBitis': _isoOrNull(kabulKontrolBitis),
    };
  }

  static String _iso(DateTime dt) {
    return '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  static String? _isoOrNull(DateTime? dt) => dt == null ? null : _iso(dt);
}

class BiyolojiAnalizSonucu {
  final bool veriVarMi;

  final bool anaUretimGirisimVarMi;
  final bool anasizBirakildiMi;
  final int anasizlikGunSayisi;

  final bool zamanKritik;
  final bool mudahaleGerekli;

  // Bu üç alan geriye dönük API uyumluluğu için tutulur.
  // Kullanıcıdan larva yaşı / erkek arı durumu / çiftleşme durumu alınmaz;
  // bu nedenle bu alanlar artık karar, skor ve yorum üretiminde kullanılmaz.
  final bool erkekHazirlikYetersiz;
  final bool memeTakibiGecikmis;
  final bool larvaKalitesiDusuk;
  final bool anaUretimIcinUygun;

  final String durumKodu;
  final String baslik;
  final String mesaj;

  // Geriye dönük API uyumluluğu için nötr değer döner.
  final String larvaKaliteSinifi;
  final String memeTakipDurumu;
  final String erkekHazirlikDurumu;
  final String ciftlesmeDurumu;

  final List<String> notlar;
  final Map<String, dynamic> hamVeri;

  const BiyolojiAnalizSonucu({
    required this.veriVarMi,
    required this.anaUretimGirisimVarMi,
    required this.anasizBirakildiMi,
    required this.anasizlikGunSayisi,
    required this.zamanKritik,
    required this.mudahaleGerekli,
    required this.erkekHazirlikYetersiz,
    required this.memeTakibiGecikmis,
    required this.larvaKalitesiDusuk,
    required this.anaUretimIcinUygun,
    required this.durumKodu,
    required this.baslik,
    required this.mesaj,
    required this.larvaKaliteSinifi,
    required this.memeTakipDurumu,
    required this.erkekHazirlikDurumu,
    required this.ciftlesmeDurumu,
    required this.notlar,
    required this.hamVeri,
  });

  Map<String, dynamic> toMap() {
    return {
      'veriVarMi': veriVarMi,
      'anaUretimGirisimVarMi': anaUretimGirisimVarMi,
      'anasizBirakildiMi': anasizBirakildiMi,
      'anasizlikGunSayisi': anasizlikGunSayisi,
      'zamanKritik': zamanKritik,
      'mudahaleGerekli': mudahaleGerekli,
      'erkekHazirlikYetersiz': erkekHazirlikYetersiz,
      'memeTakibiGecikmis': memeTakibiGecikmis,
      'larvaKalitesiDusuk': larvaKalitesiDusuk,
      'anaUretimIcinUygun': anaUretimIcinUygun,
      'durumKodu': durumKodu,
      'baslik': baslik,
      'mesaj': mesaj,
      'larvaKaliteSinifi': larvaKaliteSinifi,
      'memeTakipDurumu': memeTakipDurumu,
      'erkekHazirlikDurumu': erkekHazirlikDurumu,
      'ciftlesmeDurumu': ciftlesmeDurumu,
      'notlar': notlar,
      'hamVeri': hamVeri,
    };
  }
}

class _AktifBiyolojiTetik {
  final DateTime baslangic;
  final String anaKazanmaYontemi;
  final String tetikKodu;
  final Map<String, dynamic>? kaynakMuayene;

  const _AktifBiyolojiTetik({
    required this.baslangic,
    required this.anaKazanmaYontemi,
    required this.tetikKodu,
    this.kaynakMuayene,
  });
}

class AriBiyolojiServisi {
  static BiyolojiTakvimBilgisi anaKazanmaTakvimi({
    required DateTime baslangic,
    String anaKazanmaYontemi = 'kendi_anasi',
  }) {
    final temizBaslangic = _temizTarih(baslangic);
    final yontem = normalizeAnaKazanmaYontemi(anaKazanmaYontemi);

    if (yontem == 'hazir_ana') {
      return BiyolojiTakvimBilgisi(
        anaKazanmaYontemi: yontem,
        baslangic: temizBaslangic,
        kabulKontrolBaslangic: temizBaslangic,
        kabulKontrolBitis: temizBaslangic.add(const Duration(days: 3)),
        yumurtlamaKontrolBaslangic: temizBaslangic.add(const Duration(days: 4)),
        yumurtlamaKontrolBitis: temizBaslangic.add(const Duration(days: 10)),
        kovanaDokunmaBaslangic: temizBaslangic,
        kovanaDokunmaBitis: temizBaslangic.add(const Duration(days: 3)),
      );
    }

    if (yontem == 'kapali_meme') {
      // Hazır kapalı ana memesinin yaşı çoğu sahada kesin bilinmez.
      // Bu nedenle dar tek gün yerine güvenli pencere kullanılır.
      return BiyolojiTakvimBilgisi(
        anaKazanmaYontemi: yontem,
        baslangic: temizBaslangic,
        anaCikisiBaslangic: temizBaslangic.add(const Duration(days: 1)),
        anaCikisiBitis: temizBaslangic.add(const Duration(days: 8)),
        ciftlesmeBaslangic: temizBaslangic.add(const Duration(days: 8)),
        ciftlesmeBitis: temizBaslangic.add(const Duration(days: 18)),
        yumurtlamaKontrolBaslangic: temizBaslangic.add(const Duration(days: 14)),
        yumurtlamaKontrolBitis: temizBaslangic.add(const Duration(days: 30)),
        kovanaDokunmaBaslangic: temizBaslangic,
        kovanaDokunmaBitis: temizBaslangic.add(const Duration(days: 14)),
      );
    }

    return BiyolojiTakvimBilgisi(
      anaKazanmaYontemi: yontem,
      baslangic: temizBaslangic,

      // Gün sayımı sahada başlangıç günü 1. gün kabul edilerek okunur.
      // DateTime hesabında bu nedenle 6. gün = başlangıç + 5 gündür.
      memeKapanmaBaslangic: temizBaslangic.add(const Duration(days: 5)), // 6. gün
      memeKapanmaBitis: temizBaslangic.add(const Duration(days: 7)), // 8. gün
      anaCikisiBaslangic: temizBaslangic.add(const Duration(days: 15)), // 16. gün
      anaCikisiBitis: temizBaslangic.add(const Duration(days: 20)), // 21. gün
      ciftlesmeBaslangic: temizBaslangic.add(const Duration(days: 21)), // 22. gün
      ciftlesmeBitis: temizBaslangic.add(const Duration(days: 25)), // 26. gün
      yumurtlamaKontrolBaslangic: temizBaslangic.add(const Duration(days: 26)), // 27. gün
      yumurtlamaKontrolBitis: temizBaslangic.add(const Duration(days: 31)), // 32. gün
      kovanaDokunmaBaslangic: temizBaslangic.add(const Duration(days: 15)), // 16. gün
      kovanaDokunmaBitis: temizBaslangic.add(const Duration(days: 25)), // 26. gün
    );
  }

  static String tarihAraligiMetni(DateTime? bas, DateTime? bit) {
    if (bas == null && bit == null) return '-';
    if (bas != null && bit == null) return tarihMetni(bas);
    if (bas == null && bit != null) return tarihMetni(bit);
    final b = _temizTarih(bas!);
    final e = _temizTarih(bit!);
    if (b == e) return tarihMetni(b);
    return '${tarihMetni(b)} - ${tarihMetni(e)}';
  }

  static String tarihMetni(DateTime dt) {
    final d = _temizTarih(dt);
    return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
  }

  static Future<BiyolojiAnalizSonucu> analizYap(int koloniId) async {
    final koloni = await VeritabaniServisi.koloniOzetiGetir(koloniId);
    final muayeneler = await VeritabaniServisi.muayeneleriGetir(koloniId);

    if (koloni.isEmpty) {
      return _veriYokSonucu('Koloni kaydı bulunamadı.');
    }

    final _AktifBiyolojiTetik? tetik = _aktifBiyolojiTetikBul(
      koloni: koloni,
      muayeneler: muayeneler,
    );

    if (tetik == null) {
      if (muayeneler.isEmpty) {
        return _veriYokSonucu(
          'Bu koloni için aktif biyolojik süreç veya muayene verisi bulunmuyor.',
        );
      }

      return const BiyolojiAnalizSonucu(
        veriVarMi: true,
        anaUretimGirisimVarMi: false,
        anasizBirakildiMi: false,
        anasizlikGunSayisi: 0,
        zamanKritik: false,
        mudahaleGerekli: false,
        erkekHazirlikYetersiz: false,
        memeTakibiGecikmis: false,
        larvaKalitesiDusuk: false,
        anaUretimIcinUygun: false,
        durumKodu: 'TAKIP_YOK',
        baslik: 'Biyolojik zamanlama takibi pasif',
        mesaj:
            'Bu koloni için açık ana kazanma süreci görünmüyor. Biyolojik takvim yalnızca aktif tetik varsa çalışır.',
        larvaKaliteSinifi: 'Kullanılmıyor',
        memeTakipDurumu: 'Takip Yok',
        erkekHazirlikDurumu: 'Kullanılmıyor',
        ciftlesmeDurumu: 'Kullanılmıyor',
        notlar: <String>[
          'Açık biyolojik süreç yok.',
          'Günlük / kapalı yavru görüldüyse önceki süreç kapanmış kabul edilir.',
        ],
        hamVeri: <String, dynamic>{},
      );
    }

    final takvim = anaKazanmaTakvimi(
      baslangic: tetik.baslangic,
      anaKazanmaYontemi: tetik.anaKazanmaYontemi,
    );

    final int anasizlikGunSayisi = anasizlikGunSayisiHesapla(
      _tarihDbFormatla(tetik.baslangic),
      referans: _simdi(),
    );
    final int surecGunNo = surecGunNoHesapla(tetik.baslangic);
    final Map<String, dynamic> sahaUyarisi = sahaUyarisiUret(
      baslangic: tetik.baslangic,
      anaKazanmaYontemi: tetik.anaKazanmaYontemi,
    );

    final son = muayeneler.isEmpty ? <String, dynamic>{} : muayeneler.first;
    final String memeDurumu = _normalizeMemeDurumu(_stringAlan(son, 'memeDurumu'));
    final String memeTakipDurumu = _memeTakipDurumuHesapla(
      anaKazanmaYontemi: tetik.anaKazanmaYontemi,
      anasizlikGunSayisi: anasizlikGunSayisi,
      memeDurumu: memeDurumu,
    );

    final bugun = _temizTarih(_simdi());
    final bool yumurtlamaGecikti = takvim.yumurtlamaKontrolBitis != null &&
        bugun.isAfter(_temizTarih(takvim.yumurtlamaKontrolBitis!));
    final bool memeTakibiGecikmis = memeTakipDurumu == 'Gecikmiş' ||
        memeTakipDurumu == 'Kritik' ||
        yumurtlamaGecikti;
    final bool dokunmaPenceresi = _tarihAraliginda(
      bugun,
      takvim.kovanaDokunmaBaslangic,
      takvim.kovanaDokunmaBitis,
    );
    final bool yumurtlamaKontrolPenceresi = _tarihAraliginda(
      bugun,
      takvim.yumurtlamaKontrolBaslangic,
      takvim.yumurtlamaKontrolBitis,
    );

    final bool zamanKritik = yumurtlamaGecikti || memeTakibiGecikmis;
    final bool mudahaleGerekli = yumurtlamaGecikti;
    final bool anaUretimIcinUygun = !zamanKritik && !mudahaleGerekli;

    final List<String> notlar = <String>[
      'Biyolojik süreç başlangıcı: ${tarihMetni(tetik.baslangic)}.',
      'Ana kazanma yöntemi: ${_anaKazanmaYontemiMetni(tetik.anaKazanmaYontemi)}.',
      'Süreç yaşı: $anasizlikGunSayisi gün.',
    ];

    if (takvim.memeKapanmaBaslangic != null) {
      notlar.add(
        'Tahmini meme kapanma: ${tarihAraligiMetni(takvim.memeKapanmaBaslangic, takvim.memeKapanmaBitis)}.',
      );
    }
    if (takvim.anaCikisiBaslangic != null) {
      notlar.add(
        'Tahmini ana çıkışı: ${tarihAraligiMetni(takvim.anaCikisiBaslangic, takvim.anaCikisiBitis)}.',
      );
    }
    if (takvim.ciftlesmeBaslangic != null) {
      notlar.add(
        'Çiftleşme uçuş penceresi: ${tarihAraligiMetni(takvim.ciftlesmeBaslangic, takvim.ciftlesmeBitis)}.',
      );
    }
    if (takvim.yumurtlamaKontrolBaslangic != null) {
      notlar.add(
        'Yumurtlama kontrol penceresi: ${tarihAraligiMetni(takvim.yumurtlamaKontrolBaslangic, takvim.yumurtlamaKontrolBitis)}.',
      );
    }
    if (dokunmaPenceresi) {
      notlar.add(
        'Kovana dokunma penceresi aktif. Gereksiz açma ana kabulünü veya çiftleşme sürecini bozabilir.',
      );
    }
    if (yumurtlamaKontrolPenceresi) {
      notlar.add(
        'Yumurtlama kontrol penceresi aktif. Günlük / kapalı yavru görülürse süreç kapanır.',
      );
    }

    final _DurumPaketi durum = _durumUret(
      anaKazanmaYontemi: tetik.anaKazanmaYontemi,
      anasizlikGunSayisi: anasizlikGunSayisi,
      anaUretimIcinUygun: anaUretimIcinUygun,
      mudahaleGerekli: mudahaleGerekli,
      zamanKritik: zamanKritik,
      memeTakibiGecikmis: memeTakibiGecikmis,
      dokunmaPenceresi: dokunmaPenceresi,
      yumurtlamaKontrolPenceresi: yumurtlamaKontrolPenceresi,
    );

    return BiyolojiAnalizSonucu(
      veriVarMi: true,
      anaUretimGirisimVarMi: false,
      anasizBirakildiMi: true,
      anasizlikGunSayisi: anasizlikGunSayisi,
      zamanKritik: zamanKritik,
      mudahaleGerekli: mudahaleGerekli,
      erkekHazirlikYetersiz: false,
      memeTakibiGecikmis: memeTakibiGecikmis,
      larvaKalitesiDusuk: false,
      anaUretimIcinUygun: anaUretimIcinUygun,
      durumKodu: durum.kod,
      baslik: durum.baslik,
      mesaj: durum.mesaj,
      larvaKaliteSinifi: 'Kullanılmıyor',
      memeTakipDurumu: memeTakipDurumu,
      erkekHazirlikDurumu: 'Kullanılmıyor',
      ciftlesmeDurumu: takvim.ciftlesmeBaslangic == null
          ? 'Kullanılmıyor'
          : tarihAraligiMetni(takvim.ciftlesmeBaslangic, takvim.ciftlesmeBitis),
      notlar: notlar,
      hamVeri: <String, dynamic>{
        'koloniId': koloniId,
        'koloni': koloni,
        'sonMuayene': son,
        'aktifTetikKodu': tetik.tetikKodu,
        'anasizBirakildiMi': true,
        'anasizBaslangicTarihi': _tarihDbFormatla(tetik.baslangic),
        'anasizlikGunSayisi': anasizlikGunSayisi,
        'surecGunNo': surecGunNo,
        'memeDurumu': memeDurumu,
        'anaKazanmaYontemi': tetik.anaKazanmaYontemi,
        'takvim': takvim.toMap(),
        'sahaUyarisi': sahaUyarisi,
        'dokunmaPenceresi': dokunmaPenceresi,
        'yumurtlamaKontrolPenceresi': yumurtlamaKontrolPenceresi,
      },
    );
  }

  static Future<Map<String, dynamic>> analizMapiGetir(int koloniId) async {
    final sonuc = await analizYap(koloniId);
    return sonuc.toMap();
  }

  static int anasizlikGunSayisiHesapla(
    String? anasizBaslangicTarihi, {
    DateTime? referans,
  }) {
    final metin = (anasizBaslangicTarihi ?? '').trim();
    if (metin.isEmpty) return 0;

    final DateTime? baslangic = _guvenliTarihParse(metin);
    if (baslangic == null) return 0;

    final DateTime bugun = _temizTarih(referans ?? _simdi());
    final int fark = bugun.difference(_temizTarih(baslangic)).inDays;
    if (fark < 0) return 0;

    // Saha dili: başlangıç günü 1. gündür.
    return fark + 1;
  }

  static int surecGunNoHesapla(
    DateTime baslangic, {
    DateTime? referans,
  }) {
    final DateTime bugun = _temizTarih(referans ?? _simdi());
    final int fark = bugun.difference(_temizTarih(baslangic)).inDays;
    if (fark < 0) return 0;
    return fark + 1;
  }

  static Map<String, dynamic> sahaUyarisiUret({
    required DateTime baslangic,
    String anaKazanmaYontemi = 'kendi_anasi',
    DateTime? referans,
  }) {
    final yontem = normalizeAnaKazanmaYontemi(anaKazanmaYontemi);
    final temizBaslangic = _temizTarih(baslangic);
    final int gunNo = surecGunNoHesapla(
      temizBaslangic,
      referans: referans,
    );
    final kontrolTarihi = tarihMetni(
      temizBaslangic.add(const Duration(days: 4)),
    );

    if (gunNo <= 0) {
      return const <String, dynamic>{
        'gunNo': 0,
        'baslik': 'Biyolojik süreç henüz başlamadı',
        'mesaj': 'Başlangıç tarihi bugünden sonra görünüyor.',
        'neYap': '',
        'neYapma': '',
        'gerekce': '',
        'seviye': 'takip',
      };
    }

    if (yontem == 'hazir_ana') {
      if (gunNo <= 3) {
        return <String, dynamic>{
          'gunNo': gunNo,
          'baslik': 'Hazır ana kabul süreci',
          'mesaj':
              'Kovanı gereksiz açma. Hazır ana kafesten çıkış ve kabul sürecindedir. '
              'Dışarıdan gözlem yap. Besleme gerekiyorsa kısa ve sakin çalış. '
              'Kovanı uzun süre açık tutma; anayı aramak için çerçeve karıştırma. '
              'Bu dönemde işçi arıların yeni anayı kabul etmesi gerekir. Koku ve feromon dengesi bozulursa kabul riske girer.',
          'seviye': 'uyari',
        };
      }
      return <String, dynamic>{
        'gunNo': gunNo,
        'baslik': 'Hazır ana yumurtlama kontrolü',
        'mesaj':
            'Kovanı kontrollü açıp günlük veya kapalı yavru kontrolü yapabilirsin. '
            'Günlük / kapalı yavru gördüysen muayene ekranında ilgili kutucuğu işaretle. '
            'Gereksiz tekrar kontrol yapma. '
            'Günlük veya kapalı yavru, ananın kabul edildiğini ve yumurtlamaya başladığını gösterir.',
        'seviye': 'takip',
      };
    }

    if (yontem == 'kapali_meme') {
      if (gunNo <= 14) {
        return <String, dynamic>{
          'gunNo': gunNo,
          'baslik': 'Kapalı ana memesi / ana çıkışı süreci',
          'mesaj':
              'Kovanı gereksiz açma. Ana çıkışı ve ilk kabul dönemi başlamış olabilir. '
              'Besleme gerekiyorsa çok kısa çalış; tercihen dış gözlemle yetin. '
              'Ana memesini aramak için çerçeve karıştırma; kovanı sarsma. '
              'Kapalı memenin gerçek yaşı sahada çoğu zaman kesin bilinmez. Ana çıkışı, kabul ve olgunlaşma dönemi hassastır.',
          'seviye': 'uyari',
        };
      }
      return <String, dynamic>{
        'gunNo': gunNo,
        'baslik': 'Kapalı meme sonrası yumurtlama kontrolü',
        'mesaj':
            'Kovanı kontrollü açıp günlük veya kapalı yavru kontrolü yapabilirsin. '
            'Günlük / kapalı yavru gördüysen muayene ekranında ilgili kutucuğu işaretle. '
            'Yumurtlama görülmediyse hemen sert müdahale yapma; hava ve çiftleşme koşullarını değerlendir. '
            'Kapalı meme ile başlayan süreçte yumurtlama takvimi memenin yaşına ve çiftleşme koşullarına göre genişler.',
        'seviye': 'takip',
      };
    }

    if (gunNo <= 5) {
      return <String, dynamic>{
        'gunNo': gunNo,
        'baslik': '5. gün kapalı meme kontrolü',
        'mesaj':
            '$kontrolTarihi tarihinde kısa kontrol yap. Kapalı/kapanmış ana memelerini boz; açık veya henüz kapanmamış memeleri bırak. '
            'Amaç tüm memeleri yok etmek değil, çok erken kapanmış ve kalite riski taşıyan memeleri elemek. '
            'Kovanı uzun süre açık tutma, çerçeveleri sarsma ve gereksiz arama yapma. '
            'Çok erken kapanmış meme çoğu zaman daha yaşlı larvadan yapılır; bu da ana kalitesi riskini artırır.',
        'seviye': 'kritik',
      };
    }

    if (gunNo <= 8) {
      return <String, dynamic>{
        'gunNo': gunNo,
        'baslik': 'Ana memesi kapanma süreci',
        'mesaj':
            'Kovanı dikkatlice açıp 1/1 şurup veya polenli arı keki ile besleme yapabilirsin. '
            'Besleme gerekiyorsa kısa, sakin ve sarsmadan çalış. '
            'Meme aramak için gereksiz çerçeve karıştırma. '
            'Bu dönemde ana memeleri kapanır. Besin desteği koloninin ana memesi ve yavru bakım gücünü korur.',
        'seviye': 'takip',
      };
    }

    if (gunNo <= 15) {
      return <String, dynamic>{
        'gunNo': gunNo,
        'baslik': 'Ana memesi kapandı',
        'mesaj':
            'Kovana gerekmedikçe müdahale yapılmamalı. Dış gözlem yap. Zorunlu besleme varsa çok kısa çalış. '
            'Ana memelerini elleme; çerçeveleri sarsma. '
            'Ana kapalı meme içinde gelişir. Sarsıntı ve gereksiz müdahale meme içindeki gelişimi riske atabilir.',
        'seviye': 'uyari',
      };
    }

    if (gunNo <= 21) {
      return <String, dynamic>{
        'gunNo': gunNo,
        'baslik': 'Kovanı açma',
        'mesaj':
            'Ana çıkışı tamamlanmış ve kovan içi olgunlaşma / kabul sürecine girmiş olabilir. '
            'Kovanı açma, sarsma, çerçeve çekme. Dışarıdan uçuş ve sakinlik gözlemiyle yetin. '
            'Yeni ana bu dönemde hassastır. Kovan içi nem, koku, feromon ve kabul dengesi bozulursa ana kaybı riski artar.',
        'seviye': 'kritik',
      };
    }

    if (gunNo <= 26) {
      return <String, dynamic>{
        'gunNo': gunNo,
        'baslik': 'Çiftleşme uçuşu süreci',
        'mesaj':
            'Kovana müdahale etme. Ana tahminen çiftleşme uçuşu sürecinde olabilir. '
            'Dış gözlem yap. Giriş-çıkış düzenini ve koloni sakinliğini izle. '
            'Kovanı açma; anayı arama. Ana yön bulma ve çiftleşme uçuşları yapabilir. '
            'Açma ve sarsıntı yön bulma, uçuş başarısı ve ana dönüşünü riske sokar.',
        'seviye': 'kritik',
      };
    }

    return <String, dynamic>{
      'gunNo': gunNo,
      'baslik': 'Yumurtlama kontrol penceresi',
      'mesaj':
          'Kovanı dikkatlice açıp yumurtlama kontrolü yapabilirsin. '
          'Günlük veya kapalı yavru görüyorsan muayene ekranında “Günlük / kapalı yavru görüldü” kutucuğunu işaretle. '
          'Süreç kapanır ve koloni yönetim sürecine geçer. '
          'Sürekli aç-kapa yapma. Yumurtlama yoksa not al ve birkaç gün sonra tekrar kontrollü değerlendir. '
          'Günlük veya kapalı yavru yeni ananın çalıştığını gösterir. Bu, ana kazanma sürecinin sahadaki en net kapanış sinyalidir.',
      'seviye': 'takip',
    };
  }

  static String normalizeAnaKazanmaYontemi(dynamic deger) {
    final temiz = (deger ?? '').toString().trim().toLowerCase();
    if (temiz == 'kapali_meme' ||
        temiz == 'kapalı ana memesi var' ||
        temiz == 'kapali ana memesi var') {
      return 'kapali_meme';
    }
    if (temiz == 'hazir_ana' ||
        temiz == 'hazır çiftleşmiş ana verildi' ||
        temiz == 'hazir ciftlesmis ana verildi') {
      return 'hazir_ana';
    }
    return 'kendi_anasi';
  }

  static BiyolojiAnalizSonucu _veriYokSonucu(String mesaj) {
    return BiyolojiAnalizSonucu(
      veriVarMi: false,
      anaUretimGirisimVarMi: false,
      anasizBirakildiMi: false,
      anasizlikGunSayisi: 0,
      zamanKritik: false,
      mudahaleGerekli: false,
      erkekHazirlikYetersiz: false,
      memeTakibiGecikmis: false,
      larvaKalitesiDusuk: false,
      anaUretimIcinUygun: false,
      durumKodu: 'VERI_YOK',
      baslik: 'Biyolojik analiz için veri yok',
      mesaj: mesaj,
      larvaKaliteSinifi: 'Kullanılmıyor',
      memeTakipDurumu: 'Bilinmiyor',
      erkekHazirlikDurumu: 'Kullanılmıyor',
      ciftlesmeDurumu: 'Kullanılmıyor',
      notlar: const <String>[
        'Biyolojik zamanlama yorumları için aktif süreç gerekir.',
      ],
      hamVeri: const <String, dynamic>{},
    );
  }

  static _AktifBiyolojiTetik? _aktifBiyolojiTetikBul({
    required Map<String, dynamic> koloni,
    required List<Map<String, dynamic>> muayeneler,
  }) {
    for (final m in muayeneler) {
      final bool anasiz = _boolAlan(m, 'anasizBirakildiMi', varsayilan: false);
      if (!anasiz) continue;

      final DateTime? ozel = _guvenliTarihParse(_stringAlan(m, 'anasizBaslangicTarihi'));
      final DateTime? tarih = _guvenliTarihParse(_stringAlan(m, 'tarih'));
      final baslangic = ozel ?? tarih;
      if (baslangic == null) continue;

      if (_biyolojiKapandiMi(muayeneler: muayeneler, baslangic: baslangic)) {
        return null;
      }

      return _AktifBiyolojiTetik(
        baslangic: baslangic,
        anaKazanmaYontemi: normalizeAnaKazanmaYontemi(
          _stringAlan(m, 'anaKazanmaYontemi').isNotEmpty
              ? _stringAlan(m, 'anaKazanmaYontemi')
              : koloni['anaKazanmaYontemi'],
        ),
        tetikKodu: 'MUAYENE_ANASIZLIK',
        kaynakMuayene: m,
      );
    }

    final kaynakTipi = (koloni['kaynakTipi'] ?? '').toString().trim().toLowerCase();
    final bool bolmeKaynagi = kaynakTipi == 'bölme' || kaynakTipi == 'bolme';
    if (bolmeKaynagi) {
      final DateTime? olusturma = _guvenliTarihParse(
        (koloni['olusturmaTarihi'] ?? '').toString().trim(),
      );
      if (olusturma == null) return null;

      if (_biyolojiKapandiMi(muayeneler: muayeneler, baslangic: olusturma)) {
        return null;
      }

      return _AktifBiyolojiTetik(
        baslangic: olusturma,
        anaKazanmaYontemi: normalizeAnaKazanmaYontemi(koloni['anaKazanmaYontemi']),
        tetikKodu: 'YENI_KOLONI_BOLME',
      );
    }

    return null;
  }

  static bool _biyolojiKapandiMi({
    required List<Map<String, dynamic>> muayeneler,
    required DateTime baslangic,
  }) {
    final bas = _temizTarih(baslangic);
    for (final m in muayeneler) {
      final DateTime? tarih = _guvenliTarihParse(_stringAlan(m, 'tarih'));
      if (tarih == null || !_temizTarih(tarih).isAfter(bas)) continue;
      if (_boolAlan(m, 'gunlukKapaliYavruGoruldu', varsayilan: false)) return true;
      if (_boolAlan(m, 'disaridanHazirAnaVerildi', varsayilan: false)) return true;
    }
    return false;
  }

  static String _memeTakipDurumuHesapla({
    required String anaKazanmaYontemi,
    required int anasizlikGunSayisi,
    required String memeDurumu,
  }) {
    final yontem = normalizeAnaKazanmaYontemi(anaKazanmaYontemi);
    if (yontem == 'hazir_ana') return 'Hazır Ana Takibi';
    if (yontem == 'kapali_meme') return 'Kapalı Meme Takibi';

    if (anasizlikGunSayisi <= 0) return 'Yeni Başladı';
    if (anasizlikGunSayisi <= 2) return 'Erken Pencere';
    if (anasizlikGunSayisi <= 5) {
      if (memeDurumu == 'Yok' || memeDurumu == 'Bilinmiyor') return 'Dikkat';
      return 'Takipte';
    }
    if (anasizlikGunSayisi <= 7) {
      if (memeDurumu == 'Kapalı' || memeDurumu == 'Açık + Kapalı') return 'Yakın Takip';
      if (memeDurumu == 'Yok') return 'Gecikmiş';
      return 'Takipte';
    }
    if (memeDurumu == 'Yok' || memeDurumu == 'Bilinmiyor') return 'Kritik';
    return 'Takipte';
  }

  static _DurumPaketi _durumUret({
    required String anaKazanmaYontemi,
    required int anasizlikGunSayisi,
    required bool anaUretimIcinUygun,
    required bool mudahaleGerekli,
    required bool zamanKritik,
    required bool memeTakibiGecikmis,
    required bool dokunmaPenceresi,
    required bool yumurtlamaKontrolPenceresi,
  }) {
    if (mudahaleGerekli) {
      return const _DurumPaketi(
        kod: 'MUDAHALE_GEREKLI',
        baslik: 'Biyolojik müdahale gerekli',
        mesaj:
            'Yumurtlama kontrol penceresi aşılmış görünüyor. Ana durumu, günlük/kapalı yavru ve koloni davranışı sahada yeniden doğrulanmalıdır.',
      );
    }

    if (zamanKritik) {
      return const _DurumPaketi(
        kod: 'ZAMAN_KRITIK',
        baslik: 'Zamanlama kritik',
        mesaj:
            'Biyolojik süreç takvim dışına kaymış olabilir. Günlük / kapalı yavru yoksa koloni sahada öncelikli kontrol edilmelidir.',
      );
    }

    if (dokunmaPenceresi) {
      return const _DurumPaketi(
        kod: 'DOKUNMA',
        baslik: 'Kovana dokunma penceresi',
        mesaj:
            'Yeni ana çıkışı, olgunlaşma ve çiftleşme süreci hassastır. Bu aralıkta kovana gereksiz müdahale edilmemelidir.',
      );
    }

    if (yumurtlamaKontrolPenceresi) {
      return const _DurumPaketi(
        kod: 'YUMURTLAMA_KONTROL',
        baslik: 'Yumurtlama kontrol penceresi',
        mesaj:
            'Koloni kontrollü açılabilir. Günlük veya kapalı yavru görülürse ana kazanma süreci kapanmış kabul edilir.',
      );
    }

    if (memeTakibiGecikmis) {
      return const _DurumPaketi(
        kod: 'MEME_TAKIP_DIKKAT',
        baslik: 'Meme takibi dikkat istiyor',
        mesaj:
            'Meme gelişim süreci takvime göre yeniden kontrol edilmelidir. Gecikme veya gözden kaçma riski vardır.',
      );
    }

    if (anaUretimIcinUygun) {
      return _DurumPaketi(
        kod: 'UYGUN',
        baslik: 'Biyolojik süreç takvimde',
        mesaj:
            '${_anaKazanmaYontemiMetni(anaKazanmaYontemi)} süreci temel zamanlama açısından normal pencerede ilerliyor.',
      );
    }

    return const _DurumPaketi(
      kod: 'IZLE',
      baslik: 'Biyolojik süreç izlenmeli',
      mesaj:
          'Süreç tamamen olumsuz görünmüyor; karar için yeni muayene verisiyle zaman penceresi izlenmelidir.',
    );
  }

  static bool _tarihAraliginda(DateTime tarih, DateTime? bas, DateTime? bit) {
    if (bas == null || bit == null) return false;
    final t = _temizTarih(tarih);
    final b = _temizTarih(bas);
    final e = _temizTarih(bit);
    return !t.isBefore(b) && !t.isAfter(e);
  }

  static DateTime _simdi() => DateTime.now();

  static DateTime _temizTarih(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  static DateTime? _guvenliTarihParse(String metin) {
    final temiz = metin.trim();
    if (temiz.isEmpty) return null;

    final dogrudan = DateTime.tryParse(temiz);
    if (dogrudan != null) {
      return DateTime(dogrudan.year, dogrudan.month, dogrudan.day);
    }

    if (temiz.contains('.')) {
      final p = temiz.split('.');
      if (p.length == 3) {
        final gun = int.tryParse(p[0]) ?? 1;
        final ay = int.tryParse(p[1]) ?? 1;
        final yil = int.tryParse(p[2]) ?? DateTime.now().year;
        return DateTime(yil, ay, gun);
      }
    }

    if (temiz.contains('/')) {
      final p = temiz.split('/');
      if (p.length == 3) {
        final gun = int.tryParse(p[0]) ?? 1;
        final ay = int.tryParse(p[1]) ?? 1;
        final yil = int.tryParse(p[2]) ?? DateTime.now().year;
        return DateTime(yil, ay, gun);
      }
    }

    return null;
  }

  static String _tarihDbFormatla(DateTime dt) {
    final d = _temizTarih(dt);
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  static String _anaKazanmaYontemiMetni(String kod) {
    switch (normalizeAnaKazanmaYontemi(kod)) {
      case 'kapali_meme':
        return 'Hazır kapalı ana memesi';
      case 'hazir_ana':
        return 'Hazır çiftleşmiş ana';
      case 'kendi_anasi':
      default:
        return 'Kendi anasını yapacak';
    }
  }

  static bool _boolAlan(
    Map<String, dynamic> veri,
    String anahtar, {
    bool varsayilan = false,
  }) {
    final dynamic deger = veri[anahtar];
    if (deger == null) return varsayilan;
    if (deger is bool) return deger;
    if (deger is int) return deger == 1;
    if (deger is double) return deger.round() == 1;

    final metin = deger.toString().trim().toLowerCase();
    if (metin == '1' || metin == 'true' || metin == 'evet') return true;
    if (metin == '0' || metin == 'false' || metin == 'hayir' || metin == 'hayır') {
      return false;
    }
    return varsayilan;
  }

  static String _stringAlan(Map<String, dynamic> veri, String anahtar) {
    return (veri[anahtar] ?? '').toString().trim();
  }

  static String _normalizeMemeDurumu(String deger) {
    final temiz = deger.trim().toLowerCase();
    if (temiz.isEmpty) return 'Bilinmiyor';
    if (temiz == 'yok') return 'Yok';
    if (temiz == 'açık' || temiz == 'acik') return 'Açık';
    if (temiz == 'kapalı' || temiz == 'kapali') return 'Kapalı';
    if (temiz == 'çıkmış' || temiz == 'cikmis') return 'Çıkmış';
    if (temiz == 'bozulmuş' || temiz == 'bozulmus') return 'Bozulmuş';
    if (temiz == 'açık+kapalı' ||
        temiz == 'acik+kapali' ||
        temiz == 'açık + kapalı' ||
        temiz == 'acik + kapali') {
      return 'Açık + Kapalı';
    }
    return 'Bilinmiyor';
  }
}

class _DurumPaketi {
  final String kod;
  final String baslik;
  final String mesaj;

  const _DurumPaketi({
    required this.kod,
    required this.baslik,
    required this.mesaj,
  });
}
