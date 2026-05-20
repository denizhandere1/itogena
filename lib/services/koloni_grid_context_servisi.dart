import 'grid_durum_servisi.dart';
import 'koloni_grid_context.dart';

class KoloniGridContextServisi {
  static final Map<int, Future<KoloniGridContext>> _futureCache = {};

  static Future<Map<int, KoloniGridContext>> topluGetir({
    required List<Map<String, dynamic>> koloniler,
    required Map<int, bool> aktiflikMap,
    bool forceRefresh = false,
  }) async {
    final entries = await Future.wait(
      koloniler.map((koloni) async {
        final id = _toInt(koloni['id']);
        if (id <= 0) {
          return MapEntry<int, KoloniGridContext>(
            id,
            KoloniGridContext.bos(
              koloniId: id,
              aktifMi: false,
            ),
          );
        }

        final context = await getir(
          koloni,
          aktifMi: aktiflikMap[id] ?? true,
          forceRefresh: forceRefresh,
        );
        return MapEntry<int, KoloniGridContext>(id, context);
      }),
    );

    return Map<int, KoloniGridContext>.fromEntries(entries);
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

    final future = _futureCache[id] ??= _olustur(koloni, aktifMi: aktifMi);

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

  static Future<KoloniGridContext> _olustur(
    Map<String, dynamic> koloni, {
    required bool aktifMi,
  }) async {
    final id = _toInt(koloni['id']);
    final skor = _toInt(koloni['skor']);
    final sonCita = _toInt(koloni['sonCita']);

    final durum = await GridDurumServisi.koloniKartDurumuGetir(
      id,
      hazirKoloni: koloni,
    );

    final alarm = Map<String, bool>.from(
      durum['alarm'] ?? const <String, bool>{},
    );
    final yonetim = Map<String, dynamic>.from(
      durum['yonetim'] ?? const <String, dynamic>{},
    );

    return KoloniGridContext(
      koloniId: id,
      aktifMi: aktifMi,
      skor: skor,
      sonCita: sonCita,
      anaMemesiKritik: alarm['anaMemesiKritik'] == true,
      anaMemesiTakip: alarm['anaMemesiTakip'] == true,
      ogulAtti: alarm['ogulAtti'] == true,
      yavruYok: durum['yavruYok'] == true,
      yonetimEtiketi: (yonetim['kisa'] ?? '').toString().trim(),
      fizikselCita: _toInt(yonetim['fizikselCita']) > 0
          ? _toInt(yonetim['fizikselCita'])
          : sonCita,
      islevselUretimCita: _toInt(yonetim['islevselUretimCita']),
      aktivasyonYuzde: _toInt(
        yonetim['toplamHacimAktivasyonYuzde'] ??
            yonetim['gosterimAktivasyonYuzde'] ??
            yonetim['aktivasyonYuzde'],
      ),
    );
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }
}
