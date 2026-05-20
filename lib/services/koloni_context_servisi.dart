import 'koloni_context.dart';
import 'karar_asistan_servisi.dart';
import 'yonetim_durum_servisi.dart';
import 'koloni_biyolojik_model_servisi.dart';
import 'veritabani_servisi.dart';

/// ITOGENA koloni bağlam servisi.
///
/// Bu servis yeni karar üretmez. Mevcut karar, süreç ve biyoloji servislerinden
/// gelen çıktıları tek bir KoloniContext içinde toplar. İlk hedef, özellikle
/// KoloniDetaySayfasi gibi ağır ekranlarda aynı koloni verisinin farklı
/// Future zincirleriyle tekrar tekrar okunmasını azaltmaktır.
class KoloniContextServisi {
  static final Map<int, Future<KoloniContext>> _hafifContextCache = {};
  static final Map<int, Future<KoloniContext>> _biyolojikContextCache = {};

  /// İlk ekran için hafif context üretir.
  ///
  /// Biyolojik model bu çağrıda zorunlu değildir. Çünkü biyolojik model ağırdır
  /// ve mevcut mimaride ilgili sekme/alan açıldığında lazy-load çalışması daha
  /// doğru kullanıcı deneyimi verir.
  static Future<KoloniContext> getir(
    int koloniId, {
    bool forceRefresh = false,
  }) {
    if (forceRefresh) {
      _hafifContextCache.remove(koloniId);
    }

    final future = _hafifContextCache[koloniId] ??= _olustur(
      koloniId,
      biyolojikModelYukle: false,
    );

    return _guvenliFutureDon(
      koloniId: koloniId,
      future: future,
      biyolojikModelYuklu: false,
    );
  }

  /// Biyolojik model gereken alanlar için context üretir.
  ///
  /// Bu çağrı sekme açılışı, hacim aktivasyon kartı veya biyolojik görünüm gibi
  /// kontrollü noktalarda kullanılmalıdır. İlk ekran açılışına bağlanmamalıdır.
  static Future<KoloniContext> getirBiyolojikModelIle(
    int koloniId, {
    bool forceRefresh = false,
  }) {
    if (forceRefresh) {
      _biyolojikContextCache.remove(koloniId);
    }

    final future = _biyolojikContextCache[koloniId] ??= _olustur(
      koloniId,
      biyolojikModelYukle: true,
    );

    return _guvenliFutureDon(
      koloniId: koloniId,
      future: future,
      biyolojikModelYuklu: true,
    );
  }

  static void cacheTemizle([int? koloniId]) {
    if (koloniId == null || koloniId <= 0) {
      _hafifContextCache.clear();
      _biyolojikContextCache.clear();
      return;
    }

    _hafifContextCache.remove(koloniId);
    _biyolojikContextCache.remove(koloniId);
  }

  static void tumCacheTemizle() => cacheTemizle();

  static Future<KoloniContext> _guvenliFutureDon({
    required int koloniId,
    required Future<KoloniContext> future,
    required bool biyolojikModelYuklu,
  }) async {
    try {
      return await future;
    } catch (_) {
      final cache = biyolojikModelYuklu ? _biyolojikContextCache : _hafifContextCache;
      if (identical(cache[koloniId], future)) {
        cache.remove(koloniId);
      }
      rethrow;
    }
  }

  static Future<KoloniContext> _olustur(
    int koloniId, {
    required bool biyolojikModelYukle,
  }) async {
    final temel = await Future.wait<dynamic>([
      VeritabaniServisi.koloniOzetiGetir(koloniId),
      VeritabaniServisi.muayeneleriGetir(koloniId),
    ]);

    final koloni = Map<String, dynamic>.from(
      temel[0] as Map? ?? const <String, dynamic>{},
    );
    final muayeneler = List<Map<String, dynamic>>.from(
      temel[1] as List? ?? const <Map<String, dynamic>>[],
    );

    final sonMuayene = muayeneler.isNotEmpty
        ? Map<String, dynamic>.from(muayeneler.first)
        : null;
    final oncekiMuayene = muayeneler.length >= 2
        ? Map<String, dynamic>.from(muayeneler[1])
        : null;

    final int? arilikId = _nullableInt(koloni['arilikId']);

    final yanSonuclar = await Future.wait<dynamic>([
      KararAsistanServisi.surecDurumuGetir(
        koloniId,
        hazirKoloni: koloni,
        hazirMuayeneler: muayeneler,
        forceRefresh: false,
      ),
      KararAsistanServisi.anaKararUret(
        koloniId,
        koloni,
        donorAnaliziBekle: false,
      ),
      KararAsistanServisi.secilimDurumuGetir(
        koloniId,
        koloni,
      ),
      YonetimDurumServisi.kararlarGetir(
        koloniId,
        hazirKoloni: koloni,
      ),
      VeritabaniServisi.aktifBalAkimGetir(
        arilikId: arilikId != null && arilikId > 0 ? arilikId : null,
      ),
      if (biyolojikModelYukle) KoloniBiyolojikModelServisi.modelGetir(koloniId),
    ]);

    final surecDurumu = Map<String, dynamic>.from(
      yanSonuclar[0] as Map? ?? const <String, dynamic>{},
    );
    final anaKarar = Map<String, String>.from(
      yanSonuclar[1] as Map? ?? const <String, String>{},
    );
    final secilim = Map<String, String>.from(
      yanSonuclar[2] as Map? ?? const <String, String>{},
    );
    final yonetimKararlari = List<Map<String, dynamic>>.from(
      yanSonuclar[3] as List? ?? const <Map<String, dynamic>>[],
    );
    final yonetimOzeti = YonetimDurumServisi.ozetSec(yonetimKararlari);
    final balAkimiHam = yanSonuclar[4];
    final balAkimi = balAkimiHam is Map
        ? Map<String, dynamic>.from(balAkimiHam)
        : const <String, dynamic>{};

    Map<String, dynamic>? biyolojikModel;
    if (biyolojikModelYukle && yanSonuclar.length >= 6) {
      final ham = yanSonuclar[5];
      if (ham is Map) {
        biyolojikModel = Map<String, dynamic>.from(ham);
      }
    }

    return KoloniContext(
      koloniId: koloniId,
      arilikId: arilikId,
      koloni: koloni,
      muayeneler: muayeneler,
      sonMuayene: sonMuayene,
      oncekiMuayene: oncekiMuayene,
      surecDurumu: surecDurumu,
      anaKarar: anaKarar,
      secilim: secilim,
      yonetimOzeti: yonetimOzeti,
      yonetimKararlari: yonetimKararlari,
      balAkimi: balAkimi,
      biyolojikModel: biyolojikModel,
    );
  }

  static int _toInt(dynamic deger) {
    if (deger == null) return 0;
    if (deger is int) return deger;
    if (deger is double) return deger.round();
    return int.tryParse(deger.toString()) ?? 0;
  }

  static int? _nullableInt(dynamic deger) {
    if (deger == null) return null;
    if (deger is int) return deger;
    if (deger is double) return deger.round();
    return int.tryParse(deger.toString());
  }
}
