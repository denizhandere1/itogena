import 'veritabani_servisi.dart';

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
  static const int _ogulBelirtisiMaxGun = 14;
  static const int _bolmeSonrasiMaxGun = 45;
  static const int _ogulSonrasiMaxGun = 45;
  static const int _hasatSonrasiMaxGun = 60;
  static const int _anasizlikMaxGun = 45;

  static Future<SurecDurumu> durumGetir(int koloniId) async {
    final koloni = await VeritabaniServisi.koloniOzetiGetir(koloniId);
    final muayeneler = await VeritabaniServisi.muayeneleriGetir(koloniId);

    if (koloni.isEmpty) {
      return const SurecDurumu(
        aktifSurecler: <SurecUyarisi>[],
        dominantSurec: null,
      );
    }

    final bool aktifMi = await VeritabaniServisi.koloniAktifMi(koloniId);
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

    final bolmeSonrasi = _bolmeSonrasiSureci(
      muayeneler: muayeneler,
      bugun: bugun,
    );
    if (bolmeSonrasi != null) surecler.add(bolmeSonrasi);

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
      ..sort((a, b) => b.oncelik.compareTo(a.oncelik));

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

    final int gun = bugun.difference(_gun(baslangic)).inDays;
    if (gun < 0 || gun > _anasizlikMaxGun) return null;

    if (_anasizlikKapandiMi(muayeneler: muayeneler, baslangic: baslangic)) {
      return null;
    }

    final String anaKazanmaYontemi = _anaKazanmaYontemiBul(
      koloni: koloni,
      muayeneler: muayeneler,
      baslangic: baslangic,
    );

    if (anaKazanmaYontemi == 'hazir_ana') {
      if (gun <= 3) {
        return const SurecUyarisi(
          kod: 'ANASIZLIK_HAZIR_ANA',
          grup: 'ANASIZLIK',
          baslik: 'Hazır ana kabul süreci',
          mesaj:
          'Hazır ana verildi. Koloniyi gereksiz açma; kabul süreci bozulabilir.',
          tip: 'takip',
          oncelik: 99,
        );
      }
      if (gun <= 10) {
        return const SurecUyarisi(
          kod: 'ANASIZLIK_HAZIR_ANA',
          grup: 'ANASIZLIK',
          baslik: 'Hazır ana kabul süreci',
          mesaj:
          'Ana kabul edilmiş mi ve yumurtlama başlamış mı kontrol et. Günlük görülürse süreç kapanır.',
          tip: 'takip',
          oncelik: 93,
        );
      }
      return const SurecUyarisi(
        kod: 'ANASIZLIK_HAZIR_ANA',
        grup: 'ANASIZLIK',
        baslik: 'Hazır ana kabul süreci',
        mesaj:
        'Yumurtlama hâlâ görülmediyse ana kabulü başarısız olabilir. Koloniyi yeniden değerlendir.',
        tip: 'kritik',
        oncelik: 98,
      );
    }

    if (anaKazanmaYontemi == 'kapali_meme') {
      if (gun <= 7) {
        return const SurecUyarisi(
          kod: 'ANASIZLIK_KAPALI_MEME',
          grup: 'ANASIZLIK',
          baslik: 'Kapalı ana memesi süreci',
          mesaj: 'Kapalı ana memesi bırakıldı, koloniyi gereksiz açma.',
          tip: 'takip',
          oncelik: 99,
        );
      }
      if (gun <= 18) {
        return const SurecUyarisi(
          kod: 'ANASIZLIK_KAPALI_MEME',
          grup: 'ANASIZLIK',
          baslik: 'Kapalı ana memesi süreci',
          mesaj:
          'Ana çıkışı ve çiftleşme süreci beklenir. Koloni sıkışık kalsın, gereksiz müdahale etme.',
          tip: 'takip',
          oncelik: 96,
        );
      }
      if (gun <= 30) {
        return const SurecUyarisi(
          kod: 'ANASIZLIK_KAPALI_MEME',
          grup: 'ANASIZLIK',
          baslik: 'Kapalı ana memesi süreci',
          mesaj:
          'Yumurtlama var mı kontrol et. Günlük / kapalı yavru görülürse süreç kapanır.',
          tip: 'takip',
          oncelik: 92,
        );
      }
      return const SurecUyarisi(
        kod: 'ANASIZLIK_KAPALI_MEME',
        grup: 'ANASIZLIK',
        baslik: 'Kapalı ana memesi süreci',
        mesaj:
        'Yumurtlama gecikti. Ana çıkışı veya çiftleşme başarısız olabilir; koloniyi yeniden değerlendir.',
        tip: 'kritik',
        oncelik: 99,
      );
    }

    final String besinciGun = _format(
      _gun(baslangic.add(const Duration(days: 5))),
    );
    final String cikisBas = _format(
      _gun(baslangic.add(const Duration(days: 11))),
    );
    final String cikisBit = _format(
      _gun(baslangic.add(const Duration(days: 18))),
    );

    if (gun <= 5) {
      return SurecUyarisi(
        kod: 'ANASIZLIK',
        grup: 'ANASIZLIK',
        baslik: 'Anasızlık süreci',
        mesaj:
        '$besinciGun tarihinde kapalı ana memelerini boz. Kontrolsüz ana çıkışı koloniyi böler.',
        tip: 'kritik',
        oncelik: 100,
      );
    }

    if (gun <= 10) {
      return const SurecUyarisi(
        kod: 'ANASIZLIK',
        grup: 'ANASIZLIK',
        baslik: 'Anasızlık süreci',
        mesaj:
        'Koloniyi açma. Memeler kapandı, müdahale ana gelişimini bozabilir.',
        tip: 'takip',
        oncelik: 98,
      );
    }

    if (gun <= 18) {
      return SurecUyarisi(
        kod: 'ANASIZLIK',
        grup: 'ANASIZLIK',
        baslik: 'Anasızlık süreci',
        mesaj:
        '$cikisBas – $cikisBit arasında kovana dokunma. Ana çıkış süreci hassas.',
        tip: 'takip',
        oncelik: 96,
      );
    }

    if (gun <= 25) {
      return const SurecUyarisi(
        kod: 'ANASIZLIK',
        grup: 'ANASIZLIK',
        baslik: 'Anasızlık süreci',
        mesaj:
        'Besleme yap, koloni sıkışık kalsın. Ana çiftleşme döneminde zayıflık risklidir.',
        tip: 'takip',
        oncelik: 94,
      );
    }

    if (gun <= 35) {
      return const SurecUyarisi(
        kod: 'ANASIZLIK',
        grup: 'ANASIZLIK',
        baslik: 'Anasızlık süreci',
        mesaj: 'Yumurtlama var mı kontrol et. Ana düzen kurduysa günlük görülür.',
        tip: 'takip',
        oncelik: 92,
      );
    }

    return const SurecUyarisi(
      kod: 'ANASIZLIK',
      grup: 'ANASIZLIK',
      baslik: 'Anasızlık süreci',
      mesaj:
      'Ana durumunu yeniden değerlendir. Yumurtlama gecikti, süreç başarısız olabilir.',
      tip: 'kritik',
      oncelik: 99,
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
      return const SurecUyarisi(
        kod: 'OGUL_BELIRTISI',
        grup: 'OGUL',
        baslik: 'Oğul riski',
        mesaj:
        'Ana memelerini kontrol et. Fazla memeleri azalt veya bölme yap. Sıkışıklık oğul riskini artırır.',
        tip: 'kritik',
        oncelik: 97,
      );
    }

    if (gun <= 7) {
      return const SurecUyarisi(
        kod: 'OGUL_BELIRTISI',
        grup: 'OGUL',
        baslik: 'Oğul riski',
        mesaj:
        'Artçı oğul riski var. Meme sayısını kontrol et; gerekiyorsa bölme yap veya fazla memeleri azalt.',
        tip: 'kritik',
        oncelik: 96,
      );
    }

    return const SurecUyarisi(
      kod: 'OGUL_BELIRTISI',
      grup: 'OGUL',
      baslik: 'Oğul riski takibi',
      mesaj:
      'Oğul belirtisi süreci takip döneminde. Yeni muayenede oğul belirtisi yoksa süreç kapanır; 14 gün sonunda alarm otomatik düşer.',
      tip: 'takip',
      oncelik: 88,
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

    if (gun <= 3) {
      return const SurecUyarisi(
        kod: 'OGUL_SONRASI',
        grup: 'OGUL_SONRASI',
        baslik: 'Oğul sonrası süreç',
        mesaj: 'Memeleri kontrol et, 1–2 adet bırak. Birden fazla ana koloniyi böler.',
        tip: 'kritik',
        oncelik: 95,
      );
    }

    if (gun <= 10) {
      return const SurecUyarisi(
        kod: 'OGUL_SONRASI',
        grup: 'OGUL_SONRASI',
        baslik: 'Oğul sonrası süreç',
        mesaj: 'Koloniyi açma. Ana çıkış süreci hassas.',
        tip: 'takip',
        oncelik: 93,
      );
    }

    if (gun <= 25) {
      return const SurecUyarisi(
        kod: 'OGUL_SONRASI',
        grup: 'OGUL_SONRASI',
        baslik: 'Oğul sonrası süreç',
        mesaj: 'Bekle, müdahale etme. Yeni ana çiftleşme sürecinde.',
        tip: 'takip',
        oncelik: 91,
      );
    }

    if (gun <= 30) {
      return const SurecUyarisi(
        kod: 'OGUL_SONRASI',
        grup: 'OGUL_SONRASI',
        baslik: 'Oğul sonrası süreç',
        mesaj:
        'Yumurtlama var mı kontrol et. Yeni ana düzen kurduysa günlük görülür.',
        tip: 'takip',
        oncelik: 90,
      );
    }

    return const SurecUyarisi(
      kod: 'OGUL_SONRASI',
      grup: 'OGUL_SONRASI',
      baslik: 'Oğul sonrası süreç',
      mesaj: 'Ana durumunu değerlendir. Yumurtlama yoksa süreç başarısız olabilir.',
      tip: 'kritik',
      oncelik: 94,
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
      return const SurecUyarisi(
        kod: 'BOLME_SONRASI',
        grup: 'BOLME',
        baslik: 'Bölme sonrası toparlanma',
        mesaj:
        'Koloniyi sıkışık tut ve besleme yap. Yeni düzen kurulana kadar destek gerekir.',
        tip: 'takip',
        oncelik: 89,
      );
    }

    return const SurecUyarisi(
      kod: 'BOLME_SONRASI',
      grup: 'BOLME',
      baslik: 'Bölme sonrası toparlanma',
      mesaj: 'Ana durumunu kontrol et. Toparlanma gecikmiş olabilir.',
      tip: 'uyari',
      oncelik: 90,
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

    if (_surecKapandiMi(muayeneler: muayeneler, baslangic: tetik)) {
      return null;
    }

    return const SurecUyarisi(
      kod: 'HASAT_SONRASI',
      grup: 'HASAT',
      baslik: 'Hasat sonrası toparlanma',
      mesaj: 'Besleme yap ve koloni düzenini kur. Kışa girecek arılar bu dönemde oluşur.',
      tip: 'takip',
      oncelik: 87,
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

    // Açıklayıcı olay veya ciddi müdahale varsa bu uyarı anlamsızdır.
    if (sonUc.any(_gelisimYavasUyarisiniEngelleyenKayitMi)) return null;

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
}