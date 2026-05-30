import 'koloni_grid_context.dart';
import 'veritabani_servisi.dart';
import 'cita_aktivasyon_servisi.dart';

class KoloniGridContextServisi {
  static final Map<int, Future<KoloniGridContext>> _futureCache = {};

  /// Grid performans servisi.
  ///
  /// Bu servis özellikle koloniler sayfası için hafif tutulur. Grid açılışında
  /// biyolojik model, risk motoru, projeksiyon, yönetim karar motoru ve donör
  /// analizi çalıştırılmaz. Kartta ilk bakış için gerekli olan bilgiler son
  /// muayene ve koloni satırından okunur:
  ///
  /// - aktif / pasif durumu
  /// - skor
  /// - fiziksel çıta
  /// - yavru yok alarmı
  /// - oğul attı alarmı
  /// - ana memesi / oğul belirtisi alarmı
  ///
  /// Alan aç / kat ver gibi işlevsel aktivasyon gerektiren kararlar detay
  /// ekranındaki biyolojik modelde hesaplanır. Aksi halde koloniler sayfası
  /// her açılışta tüm koloniler için ağır biyolojik model çalıştırır ve mobil
  /// cihazda belirgin gecikme üretir.
  static Future<Map<int, KoloniGridContext>> topluGetir({
    required List<Map<String, dynamic>> koloniler,
    required Map<int, bool> aktiflikMap,
    bool forceRefresh = false,
  }) async {
    if (forceRefresh) {
      for (final koloni in koloniler) {
        final id = _toInt(koloni['id']);
        if (id > 0) _futureCache.remove(id);
      }
    }

    final ids = koloniler
        .map((k) => _toInt(k['id']))
        .where((id) => id > 0)
        .toList(growable: false);

    final muayeneMap = await _sonMuayenelerMapGetir(ids);
    final sonuc = <int, KoloniGridContext>{};

    for (final koloni in koloniler) {
      final id = _toInt(koloni['id']);
      if (id <= 0) {
        sonuc[id] = KoloniGridContext.bos(
          koloniId: id,
          aktifMi: false,
        );
        continue;
      }

      final context = _hafifContextOlustur(
        koloni,
        aktifMi: aktiflikMap[id] ?? true,
        muayeneler: muayeneMap[id] ?? const <Map<String, dynamic>>[],
        sonMuayene: muayeneMap[id]?.isNotEmpty == true ? muayeneMap[id]![0] : null,
        oncekiMuayene: muayeneMap[id]?.length == 2 ? muayeneMap[id]![1] : null,
      );

      sonuc[id] = context;
      _futureCache[id] = Future<KoloniGridContext>.value(context);
    }

    return sonuc;
  }

  static Future<KoloniGridContext> getir(
    Map<String, dynamic> koloni, {
    required bool aktifMi,
    bool forceRefresh = false,
  }) async {
    final id = _toInt(koloni['id']);
    if (id <= 0) {
      return KoloniGridContext.bos(koloniId: id, aktifMi: aktifMi);
    }

    if (forceRefresh) {
      _futureCache.remove(id);
    }

    final future = _futureCache[id] ??= _olusturHafif(koloni, aktifMi: aktifMi);

    try {
      return await future;
    } catch (_) {
      if (identical(_futureCache[id], future)) {
        _futureCache.remove(id);
      }
      return KoloniGridContext.bos(
        koloniId: id,
        aktifMi: aktifMi,
        skor: _toInt(koloni['skor']),
        sonCita: _toInt(koloni['sonCita']),
      );
    }
  }

  static void cacheTemizle([int? koloniId]) {
    if (koloniId == null || koloniId <= 0) {
      _futureCache.clear();
      return;
    }
    _futureCache.remove(koloniId);
  }

  static Future<KoloniGridContext> _olusturHafif(
    Map<String, dynamic> koloni, {
    required bool aktifMi,
  }) async {
    final id = _toInt(koloni['id']);
    final muayeneMap = await _sonMuayenelerMapGetir(<int>[id]);
    return _hafifContextOlustur(
      koloni,
      aktifMi: aktifMi,
      muayeneler: muayeneMap[id] ?? const <Map<String, dynamic>>[],
      sonMuayene: muayeneMap[id]?.isNotEmpty == true ? muayeneMap[id]![0] : null,
      oncekiMuayene: muayeneMap[id]?.length == 2 ? muayeneMap[id]![1] : null,
    );
  }

  static KoloniGridContext _hafifContextOlustur(
    Map<String, dynamic> koloni, {
    required bool aktifMi,
    List<Map<String, dynamic>> muayeneler = const <Map<String, dynamic>>[],
    Map<String, dynamic>? sonMuayene,
    Map<String, dynamic>? oncekiMuayene,
  }) {
    final id = _toInt(koloni['id']);
    final skor = _toInt(koloni['skor']);
    final sonCita = _toInt(
      sonMuayene?['citaSayisi'] ?? koloni['sonCita'],
    );

    final bool yavruYok = sonMuayene != null &&
        _sonMuayenedeYavruGorulmediMi(sonMuayene);
    final bool ogulAtti = _toInt(sonMuayene?['ogulAtti']) == 1;
    final bool anaMemesi = _anaMemesiAlarmiVarMi(sonMuayene);
    final bool yalanciAnaRiski = _yalanciAnaRiskiVarMi(
      muayeneler: muayeneler,
      sonMuayene: sonMuayene,
      yavruYok: yavruYok,
    );
    final bool yavruIziVar = _yavruIziVarMi(sonMuayene);

    // Kırmızı ünlem: yavru yok, oğul riski / ana memesi,
    // oğul attı veya yalancı ana riski.
    final bool kritikUnlem = yavruYok || anaMemesi || ogulAtti || yalanciAnaRiski;

    final Map<String, dynamic> aktivasyon = CitaAktivasyonServisi.hesapla(
      sonMuayene: sonMuayene,
      oncekiMuayene: oncekiMuayene,
    );
    final int islevselUretimCita = _toInt(aktivasyon['islevselUretimCita']);
    final int aktivasyonYuzde = _toInt(
      aktivasyon['toplamHacimAktivasyonYuzde'] ??
          aktivasyon['gosterimAktivasyonYuzde'] ??
          aktivasyon['toplamAktivasyonYuzde'],
    );
    final String yonetimEtiketi = _hafifYonetimEtiketi(
      koloni: koloni,
      sonMuayene: sonMuayene,
      fizikselCita: sonCita,
      islevselUretimCita: islevselUretimCita,
      aktivasyonYuzde: aktivasyonYuzde,
      yavruYok: yavruYok,
      ogulAtti: ogulAtti,
      anaMemesi: anaMemesi,
      yalanciAnaRiski: yalanciAnaRiski,
      yavruIziVar: yavruIziVar,
    );

    return KoloniGridContext(
      koloniId: id,
      aktifMi: aktifMi,
      skor: skor,
      sonCita: sonCita,
      // Kırmızı ünlem: yavru yok, oğul riski / ana memesi,
      // oğul attı veya yalancı ana riski.
      // Turuncu takip noktası yalnızca kritik olmayan takip sinyalleri için kalır.
      anaMemesiKritik: kritikUnlem,
      anaMemesiTakip: false,
      ogulAtti: ogulAtti,
      yavruYok: yavruYok,
      yonetimEtiketi: yonetimEtiketi,
      fizikselCita: sonCita,
      islevselUretimCita: islevselUretimCita,
      aktivasyonYuzde: aktivasyonYuzde,
    );
  }

  static Future<Map<int, List<Map<String, dynamic>>>> _sonMuayenelerMapGetir(
    List<int> koloniIdleri,
  ) async {
    if (koloniIdleri.isEmpty) return const <int, List<Map<String, dynamic>>>{};

    final dbClient = await VeritabaniServisi.db;
    final placeholders = List.filled(koloniIdleri.length, '?').join(',');

    final rows = await dbClient.query(
      'muayeneler',
      where: 'koloniId IN ($placeholders)',
      whereArgs: koloniIdleri,
      orderBy: 'koloniId ASC, tarih DESC, id DESC',
    );

    final sonuc = <int, List<Map<String, dynamic>>>{};
    for (final row in rows) {
      final id = _toInt(row['koloniId']);
      if (id <= 0) continue;
      final liste = sonuc.putIfAbsent(id, () => <Map<String, dynamic>>[]);
      if (liste.length >= 8) continue;
      liste.add(Map<String, dynamic>.from(row));
    }
    return sonuc;
  }


  static String _hafifYonetimEtiketi({
    required Map<String, dynamic> koloni,
    required Map<String, dynamic>? sonMuayene,
    required int fizikselCita,
    required int islevselUretimCita,
    required int aktivasyonYuzde,
    required bool yavruYok,
    required bool ogulAtti,
    required bool anaMemesi,
    required bool yalanciAnaRiski,
    required bool yavruIziVar,
  }) {
    if (sonMuayene == null || fizikselCita <= 0) return '';

    // Grid etiketi arıcının ilk bakışta neye odaklanacağını söyler.
    // Olağanüstü biyolojik süreçler, rutin alan/kat kararlarından önce gelir.
    // Rutin işler detayda devam eder; gridde yalnızca en kritik başlık öne çıkar.
    if (yavruYok) return 'Yavru yok';
    if (anaMemesi) return 'Meme kontrolü';
    if (yalanciAnaRiski) return 'Yalancı ana riski';
    if (ogulAtti && !yavruIziVar) return 'Bekleme süreci';
    if (ogulAtti && yavruIziVar) return 'Süreç izleniyor';

    final bool suruplukVarMi = _toBool(koloni['suruplukVarMi'], varsayilan: true);
    final bool suruplukKaldirildiMi = _toBool(sonMuayene['suruplukKaldirildiMi']);
    final bool suruplukHacimKaplarMi = suruplukVarMi && !suruplukKaldirildiMi;

    final int kuluclukKapasitesi = suruplukHacimKaplarMi ? 9 : 10;
    final int birinciKatVermeEsigi = kuluclukKapasitesi;
    final int katliKabulEsigi = kuluclukKapasitesi + 1;
    final int ucuncuKatVermeEsigi = kuluclukKapasitesi + 10;
    final int ucKatliKabulEsigi = kuluclukKapasitesi + 11;

    final bool aktivasyonTam = aktivasyonYuzde >= 95 &&
        islevselUretimCita >= fizikselCita;
    if (!aktivasyonTam) return '';

    if (fizikselCita == ucuncuKatVermeEsigi) return '3. kat ver';
    if (fizikselCita >= ucKatliKabulEsigi) return 'Alan aç';
    if (fizikselCita == birinciKatVermeEsigi) return 'Kat ver';
    if (fizikselCita >= katliKabulEsigi) return 'Alan aç';
    if (fizikselCita >= 4 && fizikselCita < birinciKatVermeEsigi) {
      return 'Alan aç';
    }

    return '';
  }

  static bool _toBool(dynamic v, {bool varsayilan = false}) {
    if (v == null) return varsayilan;
    if (v is bool) return v;
    if (v is int) return v == 1;
    if (v is double) return v.round() == 1;
    final temiz = v.toString().trim().toLowerCase();
    if (temiz.isEmpty) return varsayilan;
    return temiz == '1' ||
        temiz == 'true' ||
        temiz == 'evet' ||
        temiz == 'var';
  }

  static bool _sonMuayenedeYavruGorulmediMi(Map<String, dynamic> muayene) {
    final yavruDuzeni = (muayene['yavruDuzeni'] ?? '')
        .toString()
        .trim()
        .toLowerCase();
    final yavruluCita = _toInt(muayene['yavruluCita']);

    if (yavruDuzeni == 'yok') return true;
    if (yavruDuzeni.contains('yok') && yavruluCita <= 0) return true;
    return yavruluCita <= 0 && yavruDuzeni.isEmpty;
  }

  static bool _anaMemesiAlarmiVarMi(Map<String, dynamic>? muayene) {
    if (muayene == null) return false;
    if (_toInt(muayene['ogulBelirtisi']) == 1) return true;

    final meme = (muayene['memeDurumu'] ?? '').toString().trim().toLowerCase();
    if (meme.isEmpty || meme == 'yok') return false;
    return meme.contains('açık') ||
        meme.contains('acik') ||
        meme.contains('kapalı') ||
        meme.contains('kapali') ||
        meme.contains('çıkmış') ||
        meme.contains('cikmis') ||
        meme.contains('meme');
  }


  static bool _yavruIziVarMi(Map<String, dynamic>? muayene) {
    if (muayene == null) return false;

    if (_toInt(muayene['gunlukKapaliYavruGoruldu']) == 1) return true;
    if (_toInt(muayene['yavruluCita']) > 0) return true;

    final yavruDuzeni = (muayene['yavruDuzeni'] ?? '')
        .toString()
        .trim()
        .toLowerCase();

    if (yavruDuzeni.isEmpty) return false;
    if (yavruDuzeni == 'yok' || yavruDuzeni.contains('yok')) return false;

    return yavruDuzeni == 'blok' ||
        yavruDuzeni == 'normal' ||
        yavruDuzeni == 'dağınık' ||
        yavruDuzeni == 'daginik' ||
        yavruDuzeni == 'kambur';
  }



  static bool _yalanciAnaRiskiVarMi({
    required List<Map<String, dynamic>> muayeneler,
    required Map<String, dynamic>? sonMuayene,
    required bool yavruYok,
  }) {
    if (sonMuayene == null || !yavruYok) return false;

    // Günlük/kapalı yavru veya yavrulu çıta varsa yalancı ana alarmı üretilmez.
    // Grid hızlı katmandır; kesin tanı değil, kırmızı dikkat işareti üretir.
    if (_toInt(sonMuayene['gunlukKapaliYavruGoruldu']) == 1) return false;
    if (_toInt(sonMuayene['yavruluCita']) > 0) return false;

    DateTime? sonTetikTarihi;
    int ogulTetikSayisi = 0;

    for (final m in muayeneler) {
      final bool ogulTetik = _toInt(m['ogulAtti']) == 1;
      final bool bolmeTetik = _toInt(m['bolmeYapildi']) == 1;
      final bool anasizTetik = _toInt(m['anasizBirakildiMi']) == 1;
      final bool anaGirisimTetik = _toInt(m['anaUretimGirisimVarMi']) == 1;

      if (ogulTetik) ogulTetikSayisi++;

      if (!(ogulTetik || bolmeTetik || anasizTetik || anaGirisimTetik)) {
        continue;
      }

      final tarih = _parseTarih(m['tarih']);
      if (tarih == null) continue;
      if (sonTetikTarihi == null || tarih.isAfter(sonTetikTarihi)) {
        sonTetikTarihi = tarih;
      }
    }

    if (sonTetikTarihi == null) return false;

    final bugun = _gun(DateTime.now());
    final gecenGun = bugun.difference(_gun(sonTetikTarihi)).inDays;
    if (gecenGun < 0) return false;

    final int ardArdaYavruYok = _ardArdaYavruYokSayisi(muayeneler);

    // Oğul/bölme/anasızlık sonrası 45 gün geçtiyse ve yavru hâlâ yoksa
    // gridde kırmızı ünlem yakılır.
    if (gecenGun >= 45) return true;

    // 32. günden sonra iki ardışık yavrusuz kayıt varsa risk yükselir.
    if (gecenGun >= 32 && ardArdaYavruYok >= 2) return true;

    // Tekrarlayan oğul kaydı koloni gücünü hızla düşürür; erken uyarı eşiği
    // daha aşağı alınır.
    if (ogulTetikSayisi >= 2 && gecenGun >= 24 && ardArdaYavruYok >= 1) {
      return true;
    }

    return false;
  }

  static int _ardArdaYavruYokSayisi(List<Map<String, dynamic>> muayeneler) {
    int sayi = 0;
    for (final m in muayeneler) {
      if (_sonMuayenedeYavruGorulmediMi(m)) {
        sayi++;
      } else {
        break;
      }
    }
    return sayi;
  }

  static DateTime? _parseTarih(dynamic v) {
    final s = (v ?? '').toString().trim();
    if (s.isEmpty) return null;

    final iso = DateTime.tryParse(s);
    if (iso != null) return _gun(iso);

    if (s.contains('.')) {
      final p = s.split('.');
      if (p.length == 3) {
        final gun = int.tryParse(p[0]);
        final ay = int.tryParse(p[1]);
        final yil = int.tryParse(p[2]);
        if (gun != null && ay != null && yil != null) {
          return DateTime(yil, ay, gun);
        }
      }
    }

    if (s.contains('/')) {
      final p = s.split('/');
      if (p.length == 3) {
        final gun = int.tryParse(p[0]);
        final ay = int.tryParse(p[1]);
        final yil = int.tryParse(p[2]);
        if (gun != null && ay != null && yil != null) {
          return DateTime(yil, ay, gun);
        }
      }
    }

    return null;
  }

  static DateTime _gun(DateTime t) => DateTime(t.year, t.month, t.day);

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }
}
