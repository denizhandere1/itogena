import 'veritabani_servisi.dart';
import 'ari_biyoloji_servisi.dart';
import 'trend_servisi.dart';
import 'arilik_uyari_servisi.dart';
import 'cita_aktivasyon_servisi.dart';

class SurecUyarisi {
  final String kod;
  final String grup;
  final String baslik;
  final String mesaj;
  final String tip;
  final int oncelik;
  final String referansTarihMetni;
  final String bitisTarihMetni;

  const SurecUyarisi({
    required this.kod,
    required this.grup,
    required this.baslik,
    required this.mesaj,
    required this.tip,
    required this.oncelik,
    this.referansTarihMetni = '',
    this.bitisTarihMetni = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'kod': kod,
      'grup': grup,
      'baslik': baslik,
      'mesaj': mesaj,
      'tip': tip,
      'oncelik': oncelik,
      'referansTarihMetni': referansTarihMetni,
      'bitisTarihMetni': bitisTarihMetni,
    };
  }
}

class SurecDurumu {
  final List<SurecUyarisi> aktifSurecler;
  final SurecUyarisi? dominantSurec;

  const SurecDurumu({
    required this.aktifSurecler,
    required this.dominantSurec,
  });

  Map<String, dynamic> toMap() {
    return {
      'aktifSurecler': aktifSurecler.map((e) => e.toMap()).toList(),
      'dominantSurec': dominantSurec?.toMap(),
    };
  }
}

class SurecMotoru {
  static final Map<int, Future<SurecDurumu>> _durumFutureCache = {};

  static const int _ogulBelirtisiMaxGun = 14;
  static const int _bolmeSonrasiMaxGun = 45;
  static const int _ogulSonrasiMaxGun = 45;
  static const int _hasatSonrasiAnaKartGun = 7;
  static const int _hasatSonrasiMaxGun = 21;
  static const int _anasizlikMaxGun = 45;

  static Future<SurecDurumu> durumGetir(
    int koloniId, {
    Map<String, dynamic>? hazirKoloni,
    List<Map<String, dynamic>>? hazirMuayeneler,
    bool forceRefresh = false,
  }) async {
    if (forceRefresh || hazirKoloni != null || hazirMuayeneler != null) {
      final future = _durumHesapla(
        koloniId,
        hazirKoloni: hazirKoloni,
        hazirMuayeneler: hazirMuayeneler,
      );
      _durumFutureCache[koloniId] = future;
      return _guvenliFutureDon(koloniId, future);
    }

    final future = _durumFutureCache[koloniId] ??= _durumHesapla(koloniId);
    return _guvenliFutureDon(koloniId, future);
  }

  static void cacheTemizle([int? koloniId]) {
    if (koloniId == null) {
      _durumFutureCache.clear();
      return;
    }
    _durumFutureCache.remove(koloniId);
  }

  static void tumCacheTemizle() => cacheTemizle();

  static Future<SurecDurumu> _guvenliFutureDon(
    int koloniId,
    Future<SurecDurumu> future,
  ) async {
    try {
      return await future;
    } catch (_) {
      if (identical(_durumFutureCache[koloniId], future)) {
        _durumFutureCache.remove(koloniId);
      }
      rethrow;
    }
  }


  static bool _hazirKoloniAktifMi(
    Map<String, dynamic> koloni,
    List<Map<String, dynamic>> muayeneler,
  ) {
    if (VeritabaniServisi.sonmusDurumMu(koloni['durum'])) return false;
    if (muayeneler.isEmpty) return true;
    return _toInt(muayeneler.first['kovanSondu']) != 1;
  }

  static Future<SurecDurumu> _durumHesapla(
    int koloniId, {
    Map<String, dynamic>? hazirKoloni,
    List<Map<String, dynamic>>? hazirMuayeneler,
  }) async {
    final koloni = hazirKoloni ?? await VeritabaniServisi.koloniOzetiGetir(koloniId);
    final muayeneler =
        hazirMuayeneler ?? await VeritabaniServisi.muayeneleriGetir(koloniId);

    if (koloni.isEmpty) {
      return const SurecDurumu(
        aktifSurecler: <SurecUyarisi>[],
        dominantSurec: null,
      );
    }

    final bool aktifMi = hazirKoloni != null && hazirMuayeneler != null
        ? _hazirKoloniAktifMi(koloni, muayeneler)
        : await VeritabaniServisi.koloniAktifMi(koloniId);
    if (!aktifMi) {
      return const SurecDurumu(
        aktifSurecler: <SurecUyarisi>[],
        dominantSurec: null,
      );
    }

    final bugun = _gun(DateTime.now());
    final List<SurecUyarisi> surecler = <SurecUyarisi>[];

    final anasizlik = _anasizlikSureci(
      koloni: koloni,
      muayeneler: muayeneler,
      bugun: bugun,
    );
    if (anasizlik != null) surecler.add(anasizlik);

    final ogulBelirtisi = _ogulBelirtisiSureci(
      muayeneler: muayeneler,
      bugun: bugun,
    );
    if (ogulBelirtisi != null) surecler.add(ogulBelirtisi);

    final ogulSonrasi = _ogulSonrasiSureci(
      muayeneler: muayeneler,
      bugun: bugun,
    );
    if (ogulSonrasi != null) surecler.add(ogulSonrasi);

    // Aynı biyolojik olay iki ayrı mesaj üretmesin.
    // Kolonide anasızlık / ana kazanma penceresi açıksa, bölme sonrası
    // toparlanma mesajı geri planda kalır. Ana gelişimi daha kritik süreçtir.
    if (anasizlik == null) {
      final bolmeSonrasi = _bolmeSonrasiSureci(
        muayeneler: muayeneler,
        bugun: bugun,
      );
      if (bolmeSonrasi != null) surecler.add(bolmeSonrasi);
    }

    final yavruYokTani = await _yavruYokTaniSureci(
      koloni: koloni,
      muayeneler: muayeneler,
      bugun: bugun,
    );
    if (yavruYokTani != null) surecler.add(yavruYokTani);

    final hasatSonrasi = _hasatSonrasiSureci(
      muayeneler: muayeneler,
      bugun: bugun,
    );
    if (hasatSonrasi != null) surecler.add(hasatSonrasi);

    // Gürültü kuralı:
    // Açık ve görünür bir süreç varsa gelişim yavaş uyarısı verilmez.
    // Bu uyarı yalnızca açıklanamayan gelişim durmasını yakalamak için çalışır.
    if (surecler.isEmpty) {
      final gelisimYavas = await _gelisimYavasSureci(
        muayeneler: muayeneler,
        bugun: bugun,
      );
      if (gelisimYavas != null) surecler.add(gelisimYavas);
    }

    final benzersiz = _tekillestir(surecler)
      ..sort(_surecKarsilastir);

    return SurecDurumu(
      aktifSurecler: benzersiz,
      dominantSurec: benzersiz.isEmpty ? null : benzersiz.first,
    );
  }

  static String _anaKazanmaYontemiBul({
    required Map<String, dynamic> koloni,
    required List<Map<String, dynamic>> muayeneler,
    required DateTime baslangic,
  }) {
    for (final m in muayeneler) {
      final DateTime? tarih = _parseTarih(m['tarih']);
      if (tarih == null || tarih.isBefore(_gun(baslangic))) continue;
      final metin = (m['anaKazanmaYontemi'] ?? '').toString().trim();
      if (metin.isNotEmpty) return _normalizeAnaKazanmaYontemi(metin);
    }

    final koloniMetni = (koloni['anaKazanmaYontemi'] ?? '').toString().trim();
    if (koloniMetni.isNotEmpty) return _normalizeAnaKazanmaYontemi(koloniMetni);
    return 'kendi_anasi';
  }

  static String _normalizeAnaKazanmaYontemi(dynamic deger) {
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

  static SurecUyarisi? _anasizlikSureci({
    required Map<String, dynamic> koloni,
    required List<Map<String, dynamic>> muayeneler,
    required DateTime bugun,
  }) {
    final DateTime? baslangic = _anasizlikBaslangiciBul(
      koloni: koloni,
      muayeneler: muayeneler,
    );
    if (baslangic == null) return null;

    final DateTime basGun = _gun(baslangic);
    final int gun = bugun.difference(basGun).inDays;
    if (gun < 0 || gun > _anasizlikMaxGun) return null;

    if (_anasizlikKapandiMi(muayeneler: muayeneler, baslangic: baslangic)) {
      return null;
    }

    final String anaKazanmaYontemi =
    AriBiyolojiServisi.normalizeAnaKazanmaYontemi(
      _anaKazanmaYontemiBul(
        koloni: koloni,
        muayeneler: muayeneler,
        baslangic: baslangic,
      ),
    );

    final Map<String, dynamic> sahaUyarisi = AriBiyolojiServisi.sahaUyarisiUret(
      baslangic: basGun,
      anaKazanmaYontemi: anaKazanmaYontemi,
      referans: bugun,
    );

    final String baslik =
    (sahaUyarisi['baslik'] ?? 'Ana kazanma süreci').toString();
    final String mesaj = (sahaUyarisi['mesaj'] ?? '').toString();
    final String neYap = (sahaUyarisi['neYap'] ?? '').toString();
    final String neYapma = (sahaUyarisi['neYapma'] ?? '').toString();
    final String gerekce = (sahaUyarisi['gerekce'] ?? '').toString();
    final String seviye = (sahaUyarisi['seviye'] ?? 'takip').toString();

    final String birlesikMesaj = _mesajParcalariniDogalBirlestir(<String>[
      mesaj,
      neYap,
      neYapma,
      gerekce,
    ]);

    final String kod;
    switch (anaKazanmaYontemi) {
      case 'hazir_ana':
        kod = 'ANASIZLIK_HAZIR_ANA';
        break;
      case 'kapali_meme':
        kod = 'ANASIZLIK_KAPALI_MEME';
        break;
      case 'kendi_anasi':
      default:
        kod = 'ANASIZLIK';
        break;
    }

    return SurecUyarisi(
      kod: kod,
      grup: 'ANASIZLIK',
      baslik: baslik,
      mesaj: birlesikMesaj,
      tip: seviye == 'kritik' ? 'kritik' : (seviye == 'uyari' ? 'uyari' : 'takip'),
      oncelik: seviye == 'kritik' ? 100 : (seviye == 'uyari' ? 96 : 92),
      referansTarihMetni: AriBiyolojiServisi.tarihMetni(basGun),
      bitisTarihMetni: '',
    );
  }

  static SurecUyarisi? _ogulBelirtisiSureci({
    required List<Map<String, dynamic>> muayeneler,
    required DateTime bugun,
  }) {
    if (muayeneler.isEmpty) return null;
    final son = muayeneler.first;
    final DateTime? tarih = _parseTarih(son['tarih']);
    if (tarih == null) return null;

    final int gun = bugun.difference(tarih).inDays;
    if (gun < 0 || gun > _ogulBelirtisiMaxGun) return null;

    final bool ogulBelirtisi = _toInt(son['ogulBelirtisi']) == 1;
    final bool bolmeYapildi = _toInt(son['bolmeYapildi']) == 1;
    final bool ogulAtti = _toInt(son['ogulAtti']) == 1;

    if (!ogulBelirtisi || bolmeYapildi || ogulAtti) return null;

    if (gun <= 3) {
      return SurecUyarisi(
        kod: 'OGUL_BELIRTISI',
        grup: 'OGUL',
        baslik: 'Oğul riski',
        mesaj:
        'Ana memesi görüldü. Bu sağlık sorunu değil, oğul davranışı ve koloni sıkışıklığı işaretidir. Koloniyi sakin biçimde kontrol et; gerekiyorsa bölme yap veya 1–2 kaliteli meme bırakıp fazlasını azalt.',
        tip: 'kritik',
        oncelik: 97,
        referansTarihMetni: _format(tarih),
      );
    }

    if (gun <= 7) {
      return SurecUyarisi(
        kod: 'OGUL_BELIRTISI',
        grup: 'OGUL',
        baslik: 'Oğul riski',
        mesaj:
        'İlk hafta artçı oğul riski yüksektir. Meme sayısını kontrol et; birden fazla güçlü meme bırakmak koloniyi tekrar bölebilir. Gerekiyorsa bölme veya fazla memeleri azaltma kararı ver.',
        tip: 'kritik',
        oncelik: 96,
        referansTarihMetni: _format(tarih),
      );
    }

    return SurecUyarisi(
      kod: 'OGUL_BELIRTISI',
      grup: 'OGUL',
      baslik: 'Oğul riski takibi',
      mesaj:
      'Oğul belirtisi takip döneminde. Yeni meme, sıkışıklık veya huzursuzluk yoksa süreç kendiliğinden sönümlenir; gereksiz tekrar uyarı üretmez.',
      tip: 'takip',
      oncelik: 88,
      referansTarihMetni: _format(tarih),
    );
  }

  static SurecUyarisi? _ogulSonrasiSureci({
    required List<Map<String, dynamic>> muayeneler,
    required DateTime bugun,
  }) {
    final DateTime? tetik = _sonTetikTarihi(muayeneler, 'ogulAtti');
    if (tetik == null) return null;

    final int gun = bugun.difference(_gun(tetik)).inDays;
    if (gun < 0 || gun > _ogulSonrasiMaxGun) return null;

    if (_surecKapandiMi(muayeneler: muayeneler, baslangic: tetik)) {
      return null;
    }

    if (gun <= 7) {
      return SurecUyarisi(
        kod: 'OGUL_SONRASI',
        grup: 'OGUL_SONRASI',
        baslik: 'Oğul sonrası artçı oğul riski',
        mesaj:
        'İlk 7 gün artçı oğul riski yüksektir. Meme sayısını sadeleştir; 1–2 kaliteli meme bırak, fazlasını azalt. Birden fazla ana çıkışı koloniyi tekrar bölebilir.',
        tip: 'kritik',
        oncelik: 95,
        referansTarihMetni: _format(tetik),
      );
    }

    if (gun <= 20) {
      return SurecUyarisi(
        kod: 'OGUL_SONRASI',
        grup: 'OGUL_SONRASI',
        baslik: 'Oğul sonrası yeni ana süreci',
        mesaj:
        'Koloniyi gereksiz açma. Ana çıkışı, olgunlaşma ve çiftleşme süreci hassastır. Dış gözlem yap; kovanı sarsma ve anayı aramak için çerçeve karıştırma.',
        tip: 'takip',
        oncelik: 93,
        referansTarihMetni: _format(tetik),
      );
    }

    if (gun <= 30) {
      return SurecUyarisi(
        kod: 'OGUL_SONRASI',
        grup: 'OGUL_SONRASI',
        baslik: 'Oğul sonrası yumurtlama kontrolü',
        mesaj:
        'Yumurtlama kontrolü yapılabilir. Günlük veya kapalı yavru görülürse muayenede işaretle; süreç kapanır. Yavru yoksa hemen sert müdahale yapma, hava ve çiftleşme koşullarını değerlendir.',
        tip: 'takip',
        oncelik: 90,
        referansTarihMetni: _format(tetik),
      );
    }

    return SurecUyarisi(
      kod: 'OGUL_SONRASI',
      grup: 'OGUL_SONRASI',
      baslik: 'Oğul sonrası gecikmiş süreç',
      mesaj:
      'Yumurtlama hâlâ yoksa ana durumu sahada doğrulanmalı. Gerekirse ana verme, birleştirme veya yeniden ana kazandırma kararı düşünülür.',
      tip: 'kritik',
      oncelik: 94,
      referansTarihMetni: _format(tetik),
    );
  }

  static SurecUyarisi? _bolmeSonrasiSureci({
    required List<Map<String, dynamic>> muayeneler,
    required DateTime bugun,
  }) {
    final DateTime? tetik = _sonTetikTarihi(muayeneler, 'bolmeYapildi');
    if (tetik == null) return null;

    final int gun = bugun.difference(_gun(tetik)).inDays;
    if (gun < 0 || gun > _bolmeSonrasiMaxGun) return null;

    if (_surecKapandiMi(muayeneler: muayeneler, baslangic: tetik)) {
      return null;
    }

    // Bölme sonrası toparlanma yalnızca takvimle açık kalmaz.
    // Bölünen ana koloni 7 aktif/işlevsel çıtaya ulaştıysa bölme travması atlatılmış kabul edilir.
    // Bu durumda süreç kartı geri çekilir; kat, besleme ve hacim yönetimi gibi yönetim kararları devralır.
    if (_bolmeToparlanmasiBiyolojikOlarakKapandiMi(
      muayeneler: muayeneler,
      baslangic: tetik,
    )) {
      return null;
    }

    if (gun <= 30) {
      return SurecUyarisi(
        kod: 'BOLME_SONRASI',
        grup: 'BOLME',
        baslik: 'Bölme sonrası toparlanma',
        mesaj:
        'Koloniyi sıkışık tut ve besleme yap. Yeni düzen kurulana kadar destek gerekir.',
        tip: 'takip',
        oncelik: 89,
        referansTarihMetni: _format(tetik),
      );
    }

    return SurecUyarisi(
      kod: 'BOLME_SONRASI',
      grup: 'BOLME',
      baslik: 'Bölme sonrası toparlanma',
      mesaj: 'Ana durumunu kontrol et. Toparlanma gecikmiş olabilir.',
      tip: 'uyari',
      oncelik: 90,
      referansTarihMetni: _format(tetik),
    );
  }


  static bool _bolmeToparlanmasiBiyolojikOlarakKapandiMi({
    required List<Map<String, dynamic>> muayeneler,
    required DateTime baslangic,
  }) {
    for (final m in muayeneler) {
      final DateTime? tarih = _parseTarih(m['tarih']);
      if (tarih == null || !tarih.isAfter(_gun(baslangic))) continue;
      if (_toInt(m['kovanSondu']) == 1) continue;

      final int cita = _toInt(m['citaSayisi']);
      final bool yavruGeriDondu = _muayenedeYavruGorulduMu(m);
      final bool duzenliYavruVar = yavruGeriDondu && !_muayenedeYavruYokMu(m);

      // Bölme toparlanması yalnızca takvimle kapanmaz.
      // Asıl kapanış sinyali: yavrunun geri dönmesi + koloninin yeniden üretim hacmine yaklaşmasıdır.
      // 7 çıta altındaki kolonilerde yavru dönse bile süreç, destek yönetimiyle izlenmeye devam eder.
      if (cita >= 7 && duzenliYavruVar) return true;

      // Kullanıcı özellikle günlük/kapalı yavru gördüğünü işaretlediyse ve koloni 6 çıtanın altına düşmemişse,
      // bölme travması kapanmış kabul edilir. Sonraki kararları besleme/alan/yönetim katmanı devralır.
      if (cita >= 6 && _toInt(m['gunlukKapaliYavruGoruldu']) == 1) return true;
    }

    return false;
  }


  static Future<SurecUyarisi?> _yavruYokTaniSureci({
    required Map<String, dynamic> koloni,
    required List<Map<String, dynamic>> muayeneler,
    required DateTime bugun,
  }) async {
    if (muayeneler.isEmpty) return null;

    final son = muayeneler.first;
    final DateTime? sonTarih = _parseTarih(son['tarih']);
    if (sonTarih == null) return null;

    final bool yavruYok = _muayenedeYavruYokMu(son);
    if (!yavruYok) return null;

    final DateTime? anasizlikBaslangic = _anasizlikBaslangiciBul(
      koloni: koloni,
      muayeneler: muayeneler,
    );
    final DateTime? ogulTetik = _sonTetikTarihi(muayeneler, 'ogulAtti');
    final DateTime? bolmeTetik = _sonTetikTarihi(muayeneler, 'bolmeYapildi');

    DateTime? referans = anasizlikBaslangic ?? ogulTetik ?? bolmeTetik;
    String aktifBaglam = '';
    String grup = 'YAVRU_YOK';

    if (anasizlikBaslangic != null) {
      aktifBaglam = 'ana kazanma';
      grup = 'ANASIZLIK';
    } else if (ogulTetik != null) {
      aktifBaglam = 'oğul sonrası';
      grup = 'OGUL_SONRASI';
    } else if (bolmeTetik != null) {
      aktifBaglam = 'bölme sonrası';
      grup = 'BOLME';
    }

    final bool aktifAnaBaglamiVar = referans != null;
    referans ??= sonTarih;

    final int gun = bugun.difference(_gun(referans)).inDays;
    if (gun < 0) return null;

    if (aktifAnaBaglamiVar) {
      if (_surecKapandiMi(muayeneler: muayeneler, baslangic: referans)) {
        return null;
      }
      if (gun > _anasizlikMaxGun) {
        return null;
      }
    }

    final int toplamCita = _toInt(son['citaSayisi']);
    final int balliCita = _toInt(son['bal_cita']);
    final bool kucukKoloni = toplamCita > 0 && toplamCita <= 4;
    final bool cokKucukKoloni = toplamCita > 0 && toplamCita <= 3;
    final int ardisikYavrusuz = _ardisikYavrusuzMuayeneSayisi(muayeneler);
    final DateTime? sonYavruTarihi = _sonYavruGorulenTarih(muayeneler);
    final int yavrusuzGun = sonYavruTarihi == null
        ? gun
        : bugun.difference(_gun(sonYavruTarihi)).inDays.clamp(0, 9999).toInt();

    Map<String, dynamic> trend = const <String, dynamic>{};
    try {
      final int koloniId = _toInt(koloni['id'] ?? son['koloniId']);
      if (koloniId > 0) {
        trend = await TrendServisi.koloniTrendiGetir(koloniId);
      }
    } catch (_) {
      trend = const <String, dynamic>{};
    }

    final double gunlukMomentum = _toDouble(trend['gunlukMomentum']);
    final String trendMetni =
        '${trend['trend'] ?? ''} ${trend['momentumEtiketi'] ?? ''}'.toLowerCase();
    final bool trendZayif = gunlukMomentum < -0.02 ||
        trendMetni.contains('düş') ||
        trendMetni.contains('dus') ||
        trendMetni.contains('zayıf') ||
        trendMetni.contains('zayif');

    final bool balAkimiAktif = await _balAkimiAktifMi(
      bugun: bugun,
      arilikId: _toInt(koloni['arilikId']),
    );

    final String mizac = (son['mizac'] ?? '').toString().trim().toLowerCase();
    final bool koloniSakin = mizac.contains('sakin');
    final bool koloniHuzursuz = mizac.contains('sinirli') ||
        mizac.contains('saldırgan') ||
        mizac.contains('saldirgan');
    final bool? polenGelisiVar =
        _notEtiketiBoolOku(son['notlar'], 'TANI_POLEN');
    final bool? balGelisiGuclu =
        _notEtiketiBoolOku(son['notlar'], 'TANI_BAL_GELISI');

    final bool balBaskisiOlabilir = balAkimiAktif &&
        toplamCita >= 6 &&
        (balGelisiGuclu == true ||
            balliCita >= mathMaxInt(2, (toplamCita * 0.35).round()));

    final bool ariKusuRiski = await _arilikRiskiAktifMi(
      bugun,
      'ari_kusu',
      arilikId: _toInt(koloni['arilikId']),
    );

    final bool erkekYavruBaskin = _erkekYavruBaskinMi(son);
    final bool yalanciAnaSuphesi = _yalanciAnaSuphesiVarMi(son);

    int yasamGucu = 100;
    yasamGucu -= 20;
    if (cokKucukKoloni) {
      yasamGucu -= 30;
    } else if (kucukKoloni) {
      yasamGucu -= 20;
    }
    if (gun >= 43 || yavrusuzGun >= 45) {
      yasamGucu -= 40;
    } else if (gun >= 36 || yavrusuzGun >= 35) {
      yasamGucu -= 25;
    } else if (gun >= 21 || yavrusuzGun >= 21) {
      yasamGucu -= 10;
    }
    if (ardisikYavrusuz >= 3) {
      yasamGucu -= 18;
    } else if (ardisikYavrusuz >= 2) {
      yasamGucu -= 10;
    }
    if (trendZayif) yasamGucu -= 15;
    if (koloniHuzursuz) yasamGucu -= 6;
    if (polenGelisiVar == false) yasamGucu -= 6;
    if (erkekYavruBaskin || yalanciAnaSuphesi) yasamGucu -= 25;
    if (balBaskisiOlabilir) yasamGucu += 10;
    if (koloniSakin) yasamGucu += 4;
    if (polenGelisiVar == true) yasamGucu += 6;
    if (aktifAnaBaglamiVar && gun <= 30) yasamGucu += 8;
    yasamGucu = yasamGucu.clamp(0, 100).toInt();

    final List<String> gerekceler = <String>[
      if (aktifAnaBaglamiVar) '$aktifBaglam sürecinden $gun gün geçmiş',
      if (!aktifAnaBaglamiVar) 'aktif ana kazanma süreci görünmüyor',
      if (toplamCita > 0) '$toplamCita çıta güç seviyesi',
      if (ardisikYavrusuz >= 2) '$ardisikYavrusuz ardışık yavrusuz kayıt',
      if (trendZayif) 'gelişim yönü zayıflıyor',
      if (koloniSakin) 'koloni sakin işaretlenmiş',
      if (koloniHuzursuz) 'koloni huzursuz işaretlenmiş',
      if (polenGelisiVar == true) 'polen gelişi var',
      if (polenGelisiVar == false) 'polen gelişi yok',
      if (balGelisiGuclu == true) 'bal/nektar gelişi güçlü',
      if (balGelisiGuclu == false) 'bal/nektar gelişi güçlü değil',
      if (balBaskisiOlabilir) 'bal akımı ve ballı çıta baskısı var',
      if (ariKusuRiski) 'arı kuşu riski aktif',
      if (erkekYavruBaskin) 'erkek yavru baskısı işaretlenmiş',
      if (yalanciAnaSuphesi) 'yalancı ana / düzensiz yumurta şüphesi var',
    ];

    String baslik;
    String mesaj;
    String tip;
    int oncelik;
    String kod;

    if (aktifAnaBaglamiVar && gun <= 20) {
      kod = 'YAVRU_YOK_NORMAL_BEKLEME';
      baslik = 'Yavru yokluğu bu aşamada normal olabilir';
      mesaj =
          'Yavru düzeni “Yok” kaydedildi; ancak $aktifBaglam sürecinde $gun. gündesin. Bu dönemde yavru görülmemesi tek başına sorun değildir. Kovanı bu tarihte açmak gerekli olmayabilir; gereksiz açma bakire ana ve kabul sürecini bozabilir.';
      tip = 'takip';
      oncelik = 94;
    } else if (aktifAnaBaglamiVar && gun <= 30) {
      kod = 'YAVRU_YOK_ERKEN_TAKIP';
      baslik = 'Yumurtlama için hâlâ erken olabilir';
      mesaj =
          'Yavru düzeni “Yok” kaydedildi. $aktifBaglam sürecinden $gun gün geçmiş. Koloni sakin ve çalışıyorsa hemen sert müdahale önerilmez; 5–7 gün sonra günlük yumurta / genç larva kontrolü daha doğru olur.';
      tip = 'takip';
      oncelik = 95;
    } else if (balBaskisiOlabilir) {
      kod = 'YAVRU_YOK_BAL_BASKISI';
      baslik = 'Yavru yokluğu bal baskısıyla ilişkili olabilir';
      mesaj =
          'Yavru görünmemesi doğrudan anasızlık anlamına gelmeyebilir. Bal akımı aktif ve ballı çıta oranı yüksek görünüyor; ana yumurtlayacak boş alan bulamıyor olabilir. Önce alan ve bal baskısını değerlendir, erken ana müdahalesi yapma.';
      tip = 'uyari';
      oncelik = 96;
    } else if (erkekYavruBaskin || yalanciAnaSuphesi) {
      kod = 'YAVRU_YOK_ANA_PROBLEMI';
      baslik = 'Ana kalitesi / yalancı ana riski';
      mesaj =
          'Yavru yokluğu erkek yavru baskısı veya düzensiz yumurta belirtisiyle birlikte okunuyor. Bu durum çiftleşememiş ana, sperm problemi veya yalancı ana başlangıcı anlamına gelebilir. Beklemeyi uzatma; koloni gücüne göre ana değiştirme veya birleştirme değerlendir.';
      tip = 'kritik';
      oncelik = 99;
    } else if (yasamGucu < 50 || (kucukKoloni && (gun >= 35 || yavrusuzGun >= 35))) {
      kod = 'YAVRU_YOK_BIYOLOJIK_COKUS';
      baslik = 'Biyolojik geri dönüş kapasitesi düşük';
      mesaj =
          'Koloni uzun süredir yeni işçi üretmiyor olabilir. $toplamCita çıta seviyesinde yavrusuzluk uzarsa mevcut nüfus yaşlanır ve koloni doğal küçülmeye gidebilir. Yoğun emek harcamadan önce güçlü koloniyle birleştirme veya sınırlı destek seçeneğini değerlendir.';
      tip = 'kritik';
      oncelik = 98;
    } else if (aktifAnaBaglamiVar && gun >= 36) {
      kod = 'YAVRU_YOK_GECIKMIS_TANI';
      baslik = 'Yavru yokluğu riskli gecikmeye girdi';
      mesaj =
          'Beklenen yumurtlama penceresi aşılmaya başladı. Geç çiftleşme, arı kuşu kaynaklı ana kaybı, ana başarısızlığı veya zayıf koloni olasılıkları birlikte değerlendirilmeli. ${ariKusuRiski ? 'Arı kuşu riski aktif olduğu için çiftleşme kaybı ihtimali yükselir. ' : ''}${koloniSakin && polenGelisiVar == true ? 'Koloni sakinliği ve polen gelişi içeride ana olma ihtimalini tamamen dışlamaz. ' : ''}${koloniHuzursuz || polenGelisiVar == false ? 'Huzursuzluk veya polen yokluğu anasızlık/zayıflama şüphesini artırır. ' : ''}5–7 gün içinde net kontrol yap; hâlâ yavru yoksa beklemeyi uzatma.';
      tip = 'kritik';
      oncelik = 97;
    } else if (aktifAnaBaglamiVar && gun >= 31) {
      kod = 'YAVRU_YOK_TANI_ADAYI';
      baslik = 'Yumurtlama gecikiyor olabilir';
      mesaj =
          'Yavru düzeni “Yok” kaydedildi ve $aktifBaglam sürecinden $gun gün geçmiş. Bu artık yalnızca normal bekleme olarak bırakılmamalı; koloni davranışı, polen gelişi, ana memesi kalıntısı, bal baskısı ve erkek yavru baskısı birlikte okunmalı.';
      tip = 'uyari';
      oncelik = 95;
    } else {
      kod = 'YAVRU_YOK_NORMAL_KOLONI_TANI';
      baslik = 'Normal kolonide yavru yokluğu';
      mesaj =
          'Aktif bölme/oğul/ana kazanma süreci görünmeden yavru düzeni “Yok” kaydedildi. Bu durum ana durumu, bal baskısı, koloni zayıflaması veya yalancı ana riski açısından kontrol edilmelidir.';
      tip = 'uyari';
      oncelik = 92;
    }

    final String gerekceMetni = gerekceler.isEmpty
        ? ''
        : ' Sistem gerekçesi: ${gerekceler.join(', ')}. Yaşam gücü okuması: $yasamGucu/100.';

    return SurecUyarisi(
      kod: kod,
      grup: grup,
      baslik: baslik,
      mesaj: '$mesaj$gerekceMetni',
      tip: tip,
      oncelik: oncelik,
      referansTarihMetni: _format(referans),
    );
  }

  static bool _muayenedeYavruYokMu(Map<String, dynamic> m) {
    final String yavruDuzeni =
        (m['yavruDuzeni'] ?? '').toString().trim().toLowerCase();
    final int yavruluCita = _toInt(m['yavruluCita']);
    if (yavruDuzeni == 'yok' || yavruDuzeni.contains('yok')) return true;
    return yavruluCita <= 0 && yavruDuzeni.isEmpty;
  }

  static int _ardisikYavrusuzMuayeneSayisi(
    List<Map<String, dynamic>> muayeneler,
  ) {
    int sayi = 0;
    for (final m in muayeneler) {
      if (_muayenedeYavruYokMu(m)) {
        sayi++;
      } else {
        break;
      }
    }
    return sayi;
  }

  static DateTime? _sonYavruGorulenTarih(List<Map<String, dynamic>> muayeneler) {
    for (final m in muayeneler) {
      if (!_muayenedeYavruYokMu(m)) {
        return _parseTarih(m['tarih']);
      }
    }
    return null;
  }

  static bool? _notEtiketiBoolOku(dynamic notlar, String anahtar) {
    final metin = (notlar ?? '').toString();
    final desen = RegExp('\\[$anahtar=([01])\\]');
    final eslesme = desen.firstMatch(metin);
    if (eslesme == null) return null;
    return eslesme.group(1) == '1';
  }

  static bool _erkekYavruBaskinMi(Map<String, dynamic> m) {
    final bool? etiket = _notEtiketiBoolOku(m['notlar'], 'TANI_ERKEK_YAVRU');
    if (etiket != null) return etiket;

    final metin =
        '${m['erkekAriDurumu'] ?? ''} ${m['memeDurumu'] ?? ''} ${m['notlar'] ?? ''}'
            .toLowerCase();
    return metin.contains('erkek yavru') ||
        metin.contains('erkek göz') ||
        metin.contains('erkek goz') ||
        metin.contains('baskın') ||
        metin.contains('baskin') ||
        metin.contains('kambur');
  }

  static bool _yalanciAnaSuphesiVarMi(Map<String, dynamic> m) {
    final metin =
        '${m['ciftlesmeDurumu'] ?? ''} ${m['notlar'] ?? ''}'.toLowerCase();
    return metin.contains('yalancı') ||
        metin.contains('yalanci') ||
        metin.contains('çoklu yumurta') ||
        metin.contains('coklu yumurta') ||
        metin.contains('düzensiz yumurta') ||
        metin.contains('duzensiz yumurta');
  }

  static Future<bool> _balAkimiAktifMi({
    required DateTime bugun,
    int? arilikId,
  }) async {
    try {
      final balAkimi = await VeritabaniServisi.aktifBalAkimGetir(
        arilikId: arilikId != null && arilikId > 0 ? arilikId : null,
      );
      final DateTime? bas = balAkimi?['bas'] as DateTime?;
      final DateTime? bit = balAkimi?['bit'] as DateTime?;
      if (bas == null || bit == null) return false;
      return _aralikAktif(bugun, bas, bit);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> _arilikRiskiAktifMi(
    DateTime bugun,
    String kodParcasi, {
    int? arilikId,
  }) async {
    try {
      final uyarilar = await ArilikUyariServisi.uyarilariGetir(
        bugun,
        arilikId: arilikId != null && arilikId > 0 ? arilikId : null,
      );
      return uyarilar.any((u) {
        final kod = u.kod.toLowerCase();
        return kod.contains(kodParcasi.toLowerCase());
      });
    } catch (_) {
      return false;
    }
  }

  static int mathMaxInt(int a, int b) => a > b ? a : b;


  static SurecUyarisi? _hasatSonrasiSureci({
    required List<Map<String, dynamic>> muayeneler,
    required DateTime bugun,
  }) {
    DateTime? tetik;
    for (final m in muayeneler) {
      final DateTime? tarih = _parseTarih(m['tarih']);
      if (tarih == null) continue;
      final int hasat = _toInt(m['bal_cita']);
      if (hasat > 0) {
        tetik = tarih;
        break;
      }
    }

    if (tetik == null) return null;

    final int gun = bugun.difference(_gun(tetik)).inDays;
    if (gun < 0 || gun > _hasatSonrasiMaxGun) return null;
    if (tetik.year != bugun.year && gun > 31) return null;

    if (_hasatSonrasiBakimYapildiMi(muayeneler: muayeneler, baslangic: tetik)) {
      return null;
    }

    final bool anaKartDonemi = gun <= _hasatSonrasiAnaKartGun;

    return SurecUyarisi(
      kod: anaKartDonemi ? 'HASAT_SONRASI' : 'HASAT_SONRASI_ARKA_PLAN',
      grup: 'HASAT',
      baslik: 'Hasat sonrası bakım gerekli',
      mesaj:
      'Bal alındıysa koloni strese girebilir. Arı basmayan petek veya kat varsa kaldır, koloniyi sıkışık düzene al. Stok zayıfsa kısa süreli 1:1 şurup destek olabilir; kış stoğu eksikse 2:1 şurup veya uygun hazır yem düşün. Varroa sayımı ya da mücadele penceresini geciktirme.',
      tip: 'takip',
      oncelik: anaKartDonemi ? 70 : 24,
      referansTarihMetni: _format(tetik),
      bitisTarihMetni: _format(_gun(tetik).add(const Duration(days: _hasatSonrasiMaxGun))),
    );
  }

  static Future<SurecUyarisi?> _gelisimYavasSureci({
    required List<Map<String, dynamic>> muayeneler,
    required DateTime bugun,
  }) async {
    if (muayeneler.length < 3) return null;

    final DateTime? aktifBaslangic = await _aktifDonemBaslangici(bugun);
    final DateTime? balAkimBaslangic = await _birinciBalAkimBaslangici(bugun);

    if (aktifBaslangic == null || balAkimBaslangic == null) return null;

    // Yalnızca aktif gelişim başlangıcı ile bal akımı başlangıcı arasında çalışır.
    if (bugun.isBefore(aktifBaslangic) || !bugun.isBefore(balAkimBaslangic)) {
      return null;
    }

    final List<Map<String, dynamic>> pencereMuayeneleri = [];

    for (final m in muayeneler) {
      final DateTime? tarih = _parseTarih(m['tarih']);
      if (tarih == null) continue;

      final DateTime gun = _gun(tarih);

      if (gun.isBefore(aktifBaslangic)) continue;
      if (!gun.isBefore(balAkimBaslangic)) continue;

      pencereMuayeneleri.add(m);
    }

    if (pencereMuayeneleri.length < 3) return null;

    pencereMuayeneleri.sort((a, b) {
      final DateTime at = _parseTarih(a['tarih']) ?? DateTime(1900);
      final DateTime bt = _parseTarih(b['tarih']) ?? DateTime(1900);
      return bt.compareTo(at);
    });

    final List<Map<String, dynamic>> sonUc =
    pencereMuayeneleri.take(3).toList();

    if (sonUc.length < 3) return null;

    // Açıklayıcı olay, ciddi müdahale veya pozitif momentum varsa bu uyarı anlamsızdır.
    if (sonUc.any(_gelisimYavasUyarisiniEngelleyenKayitMi)) return null;

    final koloniId = _toInt(sonUc.first['koloniId']);
    if (koloniId > 0) {
      final trend = await TrendServisi.koloniTrendiGetir(koloniId);
      final momentum = _toDouble(trend['gunlukMomentum']);
      if (momentum >= 0.03) return null;
    }

    final List<Map<String, dynamic>> eskiYeni = sonUc.reversed.toList();

    final int c1 = _toInt(eskiYeni[0]['citaSayisi']);
    final int c2 = _toInt(eskiYeni[1]['citaSayisi']);
    final int c3 = _toInt(eskiYeni[2]['citaSayisi']);

    if (c1 <= 0 || c2 <= 0 || c3 <= 0) return null;

    // Çok zayıf / yeni destek kolonilerinde bu uyarı gürültü üretir.
    if (c1 < 4) return null;

    final bool artisVar = c2 > c1 || c3 > c2;
    if (artisVar) return null;

    return const SurecUyarisi(
      kod: 'GELISIM_YAVAS',
      grup: 'GELISIM',
      baslik: 'Gelişim yavaş görünüyor',
      mesaj:
      'Bu dönem için normal değil. Kontrol et. Ana var mı, günlük düzen var mı? Yavru alanı yeterli mi? Polen akışı var mı? (yoksa polenli kek ver) Varroa baskısı var mı?',
      tip: 'uyari',
      oncelik: 72,
    );
  }

  static bool _gelisimYavasUyarisiniEngelleyenKayitMi(
      Map<String, dynamic> m,
      ) {
    if (_toInt(m['bolmeYapildi']) == 1) return true;
    if (_toInt(m['ogulAtti']) == 1) return true;
    if (_toInt(m['ogulBelirtisi']) == 1) return true;
    if (_toInt(m['anasizBirakildiMi']) == 1) return true;
    if (_toInt(m['anaDegisimPlanlandiMi']) == 1) return true;
    if (_toInt(m['kovanSondu']) == 1) return true;
    if (_toInt(m['bal_cita']) > 0) return true;

    if (_toInt(m['anaUretimGirisimVarMi']) == 1) return true;
    if (_toInt(m['disaridanHazirAnaVerildi']) == 1) return true;

    // anaAriGoruldu alanı eski kayıtlarda boş olabilir.
    // Boş kayıt engel sayılmaz; açıkça 0 ise ana görülmedi kabul edilir.
    if (m.containsKey('anaAriGoruldu') && m['anaAriGoruldu'] != null) {
      if (_toInt(m['anaAriGoruldu']) == 0) return true;
    }

    return false;
  }

  static Future<DateTime?> _aktifDonemBaslangici(DateTime referans) async {
    final mmDd = await VeritabaniServisi.ayarStringGetir(
      'season_uretim_baslangic',
      varsayilan: '03-15',
    );

    return _mmDdToDate(mmDd, referans.year);
  }

  static Future<DateTime?> _birinciBalAkimBaslangici(DateTime referans) async {
    final mmDd = await VeritabaniServisi.ayarStringGetir(
      'bal_akim1_baslangic',
      varsayilan: '05-25',
    );

    return _mmDdToDate(mmDd, referans.year);
  }

  static DateTime? _mmDdToDate(String mmDd, int yil) {
    final temiz = mmDd.trim();
    if (temiz.isEmpty) return null;

    final p = temiz.split('-');
    if (p.length != 2) return null;

    final ay = int.tryParse(p[0]);
    final gun = int.tryParse(p[1]);

    if (ay == null || gun == null) return null;
    if (ay < 1 || ay > 12) return null;
    if (gun < 1 || gun > 31) return null;

    try {
      return DateTime(yil, ay, gun);
    } catch (_) {
      return null;
    }
  }

  static DateTime? _anasizlikBaslangiciBul({
    required Map<String, dynamic> koloni,
    required List<Map<String, dynamic>> muayeneler,
  }) {
    for (final m in muayeneler) {
      final bool anasiz = _toInt(m['anasizBirakildiMi']) == 1;
      if (!anasiz) continue;
      final DateTime? ozel = _parseTarih(m['anasizBaslangicTarihi']);
      final DateTime? tarih = _parseTarih(m['tarih']);
      return ozel ?? tarih;
    }

    final String kaynakTipi =
    (koloni['kaynakTipi'] ?? '').toString().trim().toLowerCase();
    if (kaynakTipi == 'bölme' || kaynakTipi == 'bolme') {
      return _parseTarih(koloni['olusturmaTarihi']);
    }

    return null;
  }

  static bool _anasizlikKapandiMi({
    required List<Map<String, dynamic>> muayeneler,
    required DateTime baslangic,
  }) {
    for (final m in muayeneler) {
      final DateTime? tarih = _parseTarih(m['tarih']);
      if (tarih == null || !tarih.isAfter(_gun(baslangic))) continue;
      if (_anaSureciKapatanMuayeneMi(m, disaridanHazirAnaKapatir: true)) {
        return true;
      }
    }
    return false;
  }

  static bool _surecKapandiMi({
    required List<Map<String, dynamic>> muayeneler,
    required DateTime baslangic,
  }) {
    for (final m in muayeneler) {
      final DateTime? tarih = _parseTarih(m['tarih']);
      if (tarih == null || !tarih.isAfter(_gun(baslangic))) continue;
      if (_anaSureciKapatanMuayeneMi(m)) return true;
    }
    return false;
  }

  static bool _anaSureciKapatanMuayeneMi(
    Map<String, dynamic> m, {
    bool disaridanHazirAnaKapatir = false,
  }) {
    if (_toInt(m['kovanSondu']) == 1) return true;
    if (_toInt(m['gunlukKapaliYavruGoruldu']) == 1) return true;
    if (disaridanHazirAnaKapatir && _toInt(m['disaridanHazirAnaVerildi']) == 1) {
      return true;
    }

    // Eski veya eksik kayıtlarda kullanıcı kapanış kutusunu işaretlememiş olabilir.
    // Açıkça yavrulu çıta ya da yok dışında yavru düzeni görülüyorsa süreç biyolojik olarak kapanmış sayılır.
    return _muayenedeYavruGorulduMu(m);
  }

  static bool _muayenedeYavruGorulduMu(Map<String, dynamic> m) {
    if (_toInt(m['gunlukKapaliYavruGoruldu']) == 1) return true;
    if (_toInt(m['yavruluCita']) > 0) return true;

    final String yavruDuzeni =
        (m['yavruDuzeni'] ?? '').toString().trim().toLowerCase();
    if (yavruDuzeni.isEmpty) return false;
    if (yavruDuzeni == 'yok' || yavruDuzeni.contains('yok')) return false;

    return yavruDuzeni.contains('blok') ||
        yavruDuzeni.contains('normal') ||
        yavruDuzeni.contains('dağınık') ||
        yavruDuzeni.contains('daginik') ||
        yavruDuzeni.contains('kambur');
  }

  static bool _hasatSonrasiBakimYapildiMi({
    required List<Map<String, dynamic>> muayeneler,
    required DateTime baslangic,
  }) {
    // Hasat sonrası süreç biyolojik ana kazanma süreci değildir.
    // Günlük/kapalı yavru bu pencereyi kapatmaz; varroa veya besleme gibi
    // bakım eylemleri pencereyi kapatır/hafifletir.
    for (final m in muayeneler) {
      final DateTime? tarih = _parseTarih(m['tarih']);
      if (tarih == null || !tarih.isAfter(_gun(baslangic))) continue;

      final varroa = (m['varroaMucadele'] ?? '').toString().trim().toLowerCase();
      final beslemeTipi = (m['beslemeTipi'] ?? '').toString().trim().toLowerCase();

      if (varroa.isNotEmpty && varroa != 'yok') return true;
      if (_toInt(m['beslemeYapildi']) == 1) return true;
      if (beslemeTipi.isNotEmpty && beslemeTipi != 'yok') return true;
    }
    return false;
  }

  static bool _aralikAktif(DateTime tarih, DateTime? bas, DateTime? bit) {
    if (bas == null || bit == null) return false;
    final t = _gun(tarih);
    final b = _gun(bas);
    final e = _gun(bit);
    return !t.isBefore(b) && !t.isAfter(e);
  }

  static DateTime? _sonTetikTarihi(
      List<Map<String, dynamic>> muayeneler,
      String alan,
      ) {
    for (final m in muayeneler) {
      if (_toInt(m[alan]) == 1) {
        return _parseTarih(m['tarih']);
      }
    }
    return null;
  }

  static String _mesajParcalariniDogalBirlestir(List<String> parcalar) {
    final temizParcalar = parcalar
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .map(_cumleSonuTamamla)
        .toList(growable: false);

    return temizParcalar.join(' ');
  }

  static String _cumleSonuTamamla(String metin) {
    final temiz = metin.trim();
    if (temiz.isEmpty) return '';

    final son = temiz.substring(temiz.length - 1);
    if (son == '.' || son == '!' || son == '?' || son == ':') {
      return temiz;
    }

    return '$temiz.';
  }

  static int _surecKarsilastir(SurecUyarisi a, SurecUyarisi b) {
    final aKat = _surecKategoriSirasi(a);
    final bKat = _surecKategoriSirasi(b);
    if (aKat != bKat) return aKat.compareTo(bKat);

    final aTarih = _parseTarih(a.referansTarihMetni);
    final bTarih = _parseTarih(b.referansTarihMetni);
    if (aTarih != null && bTarih != null) {
      final tarihKarsilastir = bTarih.compareTo(aTarih);
      if (tarihKarsilastir != 0) return tarihKarsilastir;
    } else if (aTarih != null) {
      return -1;
    } else if (bTarih != null) {
      return 1;
    }

    return b.oncelik.compareTo(a.oncelik);
  }

  static int _surecKategoriSirasi(SurecUyarisi surec) {
    final grup = surec.grup.toUpperCase();
    final kod = surec.kod.toUpperCase();

    if (grup == 'ANASIZLIK' || kod.contains('ANASIZLIK')) return 1;
    if (kod.contains('YAVRU_YOK')) return 2;
    if (grup == 'OGUL' || kod.contains('OGUL_BELIRTISI')) return 3;
    if (grup == 'OGUL_SONRASI' || kod.contains('OGUL_SONRASI')) return 4;
    if (grup == 'BOLME' || kod.contains('BOLME')) return 5;
    if (grup == 'GELISIM' || kod.contains('GELISIM')) return 6;
    if (grup == 'HASAT' || kod.contains('HASAT')) return 8;
    return 20;
  }

  static List<SurecUyarisi> _tekillestir(List<SurecUyarisi> liste) {
    final Map<String, SurecUyarisi> harita = <String, SurecUyarisi>{};
    for (final surec in liste) {
      final mevcut = harita[surec.grup];
      if (mevcut == null || surec.oncelik > mevcut.oncelik) {
        harita[surec.grup] = surec;
      }
    }
    return harita.values.toList();
  }

  static DateTime _gun(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  static DateTime? _parseTarih(dynamic deger) {
    final metin = (deger ?? '').toString().trim();
    if (metin.isEmpty) return null;

    final dogrudan = DateTime.tryParse(metin);
    if (dogrudan != null) return _gun(dogrudan);

    final p = metin.split('.');
    if (p.length == 3) {
      final gun = int.tryParse(p[0]);
      final ay = int.tryParse(p[1]);
      final yil = int.tryParse(p[2]);
      if (gun != null && ay != null && yil != null) {
        return DateTime(yil, ay, gun);
      }
    }
    return null;
  }

  static String _format(DateTime dt) {
    final gun = dt.day.toString().padLeft(2, '0');
    final ay = dt.month.toString().padLeft(2, '0');
    return '$gun.$ay.${dt.year}';
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }
}
