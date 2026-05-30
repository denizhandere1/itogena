import 'yonetim_durum_servisi.dart';
import 'surec_motoru.dart';
import 'veritabani_servisi.dart';

class GridDurumServisi {
  static final Map<int, Future<Map<String, dynamic>>> _futureCache = {};

  /// Koloni grid kartı için hafif durum üretir.
  ///
  /// Bu servis ana karar, genetik seçim veya detay biyolojik açıklama üretmez.
  /// Sadece gridde gösterilecek alarm, yavru-yok ve kısa yönetim özetini taşır.
  static Future<Map<String, dynamic>> koloniKartDurumuGetir(
    int koloniId, {
    Map<String, dynamic>? hazirKoloni,
    bool forceRefresh = false,
  }) async {
    if (koloniId <= 0) {
      return const <String, dynamic>{
        'alarm': <String, bool>{},
        'yonetim': <String, dynamic>{},
        'yavruYok': false,
      };
    }

    // Hazır koloni geldiğinde cache'e güvenmek yerine güncel parametre ile üret.
    // Grid yüklemesinde koloni satırı zaten elde olduğu için eski cache verisi
    // ile yeni liste satırının karışmasını önler.
    if (forceRefresh || hazirKoloni != null) {
      final future = _olustur(koloniId, hazirKoloni: hazirKoloni);
      _futureCache[koloniId] = future;
      return _guvenliDon(koloniId, future);
    }

    final future = _futureCache[koloniId] ??= _olustur(koloniId);
    return _guvenliDon(koloniId, future);
  }

  static void cacheTemizle([int? koloniId]) {
    if (koloniId == null || koloniId <= 0) {
      _futureCache.clear();
      return;
    }
    _futureCache.remove(koloniId);
  }

  static Future<Map<String, dynamic>> _guvenliDon(
    int koloniId,
    Future<Map<String, dynamic>> future,
  ) async {
    try {
      return await future;
    } catch (_) {
      if (identical(_futureCache[koloniId], future)) {
        _futureCache.remove(koloniId);
      }
      return const <String, dynamic>{
        'alarm': <String, bool>{},
        'yonetim': <String, dynamic>{},
        'yavruYok': false,
      };
    }
  }

  static Future<Map<String, dynamic>> _olustur(
    int koloniId, {
    Map<String, dynamic>? hazirKoloni,
  }) async {
    final sonuclar = await Future.wait<dynamic>([
      _alarmDurumuGetir(koloniId),
      YonetimDurumServisi.ozetGetir(
        koloniId,
        hazirKoloni: hazirKoloni,
      ),
      VeritabaniServisi.muayeneleriGetir(koloniId),
    ]);

    final alarm = Map<String, bool>.from(
      sonuclar[0] ?? const <String, bool>{},
    );
    final yonetim = Map<String, dynamic>.from(
      sonuclar[1] ?? const <String, dynamic>{},
    );
    final muayeneler = List<Map<String, dynamic>>.from(
      sonuclar[2] ?? const <Map<String, dynamic>>[],
    );

    final bool yavruYok = muayeneler.isNotEmpty &&
        _sonMuayenedeYavruGorulmediMi(muayeneler.first);

    final bool kritikBiyolojikSurec = yavruYok ||
        alarm['anaMemesiKritik'] == true ||
        alarm['ogulAtti'] == true ||
        alarm['yalanciAnaRiski'] == true;

    final Map<String, dynamic> gridYonetim = kritikBiyolojikSurec
        ? const <String, dynamic>{}
        : _gridYonetimKarariniSadelestir(yonetim);

    return <String, dynamic>{
      'alarm': alarm,
      'yonetim': gridYonetim,
      'yavruYok': yavruYok,
    };
  }

  static Future<Map<String, bool>> _alarmDurumuGetir(int koloniId) async {
    final surecDurumu = await SurecMotoru.durumGetir(koloniId);

    bool anaMemesiKritik = false;
    bool anaMemesiTakip = false;
    bool ogulAtti = false;
    bool yalanciAnaRiski = false;

    for (final surec in surecDurumu.aktifSurecler) {
      final kod = surec.kod.toUpperCase();
      final grup = surec.grup.toUpperCase();

      if (grup == 'OGUL_BELIRTISI' ||
          kod.contains('OGUL_BELIRTISI') ||
          kod.contains('ANA_MEMESI')) {
        if (surec.tip.trim().toLowerCase() == 'kritik' || surec.oncelik >= 90) {
          anaMemesiKritik = true;
        } else {
          anaMemesiTakip = true;
        }
      }

      if (grup == 'OGUL_SONRASI' || kod.contains('OGUL_SONRASI')) {
        ogulAtti = true;
      }

      if (kod.contains('YAVRU_YOK_ANA_PROBLEMI') ||
          kod.contains('YALANCI') ||
          (surec.baslik.toLowerCase().contains('yalancı') ||
              surec.baslik.toLowerCase().contains('yalanci'))) {
        yalanciAnaRiski = true;
      }
    }

    return <String, bool>{
      'anaMemesiKritik': anaMemesiKritik,
      'anaMemesiTakip': anaMemesiTakip && !anaMemesiKritik,
      'ogulAtti': ogulAtti,
      'yalanciAnaRiski': yalanciAnaRiski,
    };
  }

  static Map<String, dynamic> _gridYonetimKarariniSadelestir(
    Map<String, dynamic> yonetim,
  ) {
    if (yonetim.isEmpty) return const <String, dynamic>{};

    final String birlesik = [
      yonetim['kod'],
      yonetim['baslik'],
      yonetim['kisa'],
      yonetim['mesaj'],
      yonetim['tip'],
    ].where((e) => e != null).join(' ').toLowerCase();

    // Şurupluk kaldırma saha kayıt bilgisidir; gridde karar/uyarı gibi
    // konuşmaz. Muayenede işaretlenirse biyolojik model zaten uyumlanır.
    if (birlesik.contains('surupluk') ||
        birlesik.contains('şurupluk') ||
        birlesik.contains('şurupluğu') ||
        birlesik.contains('suruplugu')) {
      return const <String, dynamic>{};
    }

    return Map<String, dynamic>.from(yonetim);
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

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }
}
