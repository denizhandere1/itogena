import 'koloni_grid_context.dart';
import 'veritabani_servisi.dart';

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

    final sonMuayeneMap = await _sonMuayeneMapGetir(ids);
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
        sonMuayene: sonMuayeneMap[id],
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
    final sonMuayeneMap = await _sonMuayeneMapGetir(<int>[id]);
    return _hafifContextOlustur(
      koloni,
      aktifMi: aktifMi,
      sonMuayene: sonMuayeneMap[id],
    );
  }

  static KoloniGridContext _hafifContextOlustur(
    Map<String, dynamic> koloni, {
    required bool aktifMi,
    Map<String, dynamic>? sonMuayene,
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

    return KoloniGridContext(
      koloniId: id,
      aktifMi: aktifMi,
      skor: skor,
      sonCita: sonCita,
      anaMemesiKritik: anaMemesi,
      anaMemesiTakip: false,
      ogulAtti: ogulAtti,
      yavruYok: yavruYok,
      // Ağır yönetim etiketi burada bilinçli olarak boş bırakılır.
      // Alan aç / kat ver gibi kararlar işlevsel aktivasyon gerektirir ve
      // detay ekranındaki biyolojik modelde hesaplanır.
      yonetimEtiketi: '',
      fizikselCita: sonCita,
      islevselUretimCita: 0,
      aktivasyonYuzde: 0,
    );
  }

  static Future<Map<int, Map<String, dynamic>>> _sonMuayeneMapGetir(
    List<int> koloniIdleri,
  ) async {
    if (koloniIdleri.isEmpty) return const <int, Map<String, dynamic>>{};

    final dbClient = await VeritabaniServisi.db;
    final placeholders = List.filled(koloniIdleri.length, '?').join(',');

    final rows = await dbClient.query(
      'muayeneler',
      where: 'koloniId IN ($placeholders)',
      whereArgs: koloniIdleri,
      orderBy: 'koloniId ASC, tarih DESC, id DESC',
    );

    final sonuc = <int, Map<String, dynamic>>{};
    for (final row in rows) {
      final id = _toInt(row['koloniId']);
      if (id <= 0) continue;
      sonuc.putIfAbsent(id, () => Map<String, dynamic>.from(row));
    }
    return sonuc;
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

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }
}
