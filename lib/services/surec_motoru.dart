import 'veritabani_servisi.dart';
import 'ari_biyoloji_servisi.dart';
import 'trend_servisi.dart';

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

      if (_toInt(m['gunlukKapaliYavruGoruldu']) == 1) return true;
      if (_toInt(m['disaridanHazirAnaVerildi']) == 1) return true;
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
      if (_toInt(m['gunlukKapaliYavruGoruldu']) == 1) return true;
    }
    return false;
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
    if (grup == 'OGUL' || kod.contains('OGUL_BELIRTISI')) return 2;
    if (grup == 'OGUL_SONRASI' || kod.contains('OGUL_SONRASI')) return 3;
    if (grup == 'BOLME' || kod.contains('BOLME')) return 4;
    if (grup == 'GELISIM' || kod.contains('GELISIM')) return 5;
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
