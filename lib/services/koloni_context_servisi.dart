import 'package:itogena_v45/gen_l10n/app_localizations.dart';
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
  // Cache key: "$koloniId:$localeName" — locale-aware caching.
  static final Map<String, Future<KoloniContext>> _hafifContextCache = {};
  static final Map<String, Future<KoloniContext>> _biyolojikContextCache = {};

  static String _cacheKey(int koloniId, AppLocalizations? l) =>
      '$koloniId:${l?.localeName ?? 'tr'}';

  /// İlk ekran için hafif context üretir.
  ///
  /// Biyolojik model bu çağrıda zorunlu değildir. Çünkü biyolojik model ağırdır
  /// ve mevcut mimaride ilgili sekme/alan açıldığında lazy-load çalışması daha
  /// doğru kullanıcı deneyimi verir.
  static Future<KoloniContext> getir(
    int koloniId, {
    bool forceRefresh = false,
    AppLocalizations? l,
  }) {
    final key = _cacheKey(koloniId, l);
    if (forceRefresh) {
      _hafifContextCache.remove(key);
    }

    final future = _hafifContextCache[key] ??= _olustur(
      koloniId,
      biyolojikModelYukle: false,
      l: l,
    );

    return _guvenliFutureDon(
      cacheKey: key,
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
    AppLocalizations? l,
  }) {
    final key = _cacheKey(koloniId, l);
    if (forceRefresh) {
      _biyolojikContextCache.remove(key);
    }

    final future = _biyolojikContextCache[key] ??= _olustur(
      koloniId,
      biyolojikModelYukle: true,
      l: l,
    );

    return _guvenliFutureDon(
      cacheKey: key,
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

    _hafifContextCache.removeWhere((k, _) => k.startsWith('$koloniId:'));
    _biyolojikContextCache.removeWhere((k, _) => k.startsWith('$koloniId:'));
  }

  static void tumCacheTemizle() => cacheTemizle();

  static Future<KoloniContext> _guvenliFutureDon({
    required String cacheKey,
    required Future<KoloniContext> future,
    required bool biyolojikModelYuklu,
  }) async {
    try {
      return await future;
    } catch (_) {
      final cache = biyolojikModelYuklu ? _biyolojikContextCache : _hafifContextCache;
      if (identical(cache[cacheKey], future)) {
        cache.remove(cacheKey);
      }
      rethrow;
    }
  }

  static Future<KoloniContext> _olustur(
    int koloniId, {
    required bool biyolojikModelYukle,
    AppLocalizations? l,
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

    // Performans: Koloni detay açılışında ana karar ve seçilim için
    // KoloniKararMotoru iki ayrı kez çalıştırılmamalı. Bu iki çıktı artık
    // KararAsistanServisi.kararVeBiyolojiBirlesikGetir üzerinden tek karar
    // zincirinden alınır. Böylece detay ekranı açılırken aynı koloni profili,
    // donör/seçilim ve biyoloji hesapları tekrar edilmez.
    final yanSonuclar = await Future.wait<dynamic>([
      KararAsistanServisi.surecDurumuGetir(
        koloniId,
        hazirKoloni: koloni,
        hazirMuayeneler: muayeneler,
        forceRefresh: false,
      ),
      KararAsistanServisi.kararVeBiyolojiBirlesikGetir(
        koloniId,
        koloni,
        siraliDonorler: const <Map<String, dynamic>>[],
        forceRefresh: false,
        l: l,
      ),
      YonetimDurumServisi.kararlarGetir(
        koloniId,
        hazirKoloni: koloni,
        l: l,
      ),
      VeritabaniServisi.aktifBalAkimGetir(
        arilikId: arilikId != null && arilikId > 0 ? arilikId : null,
      ),
      if (biyolojikModelYukle) KoloniBiyolojikModelServisi.modelGetir(koloniId),
    ]);

    final surecDurumu = Map<String, dynamic>.from(
      yanSonuclar[0] as Map? ?? const <String, dynamic>{},
    );
    final kararBirlesik = Map<String, dynamic>.from(
      yanSonuclar[1] as Map? ?? const <String, dynamic>{},
    );
    final anaKarar = _stringMap(
      kararBirlesik['anaKarar'] as Map? ?? const <String, dynamic>{},
    );
    final secilim = _stringMap(
      kararBirlesik['secilim'] as Map? ?? const <String, dynamic>{},
    );
    final yonetimKararlari = List<Map<String, dynamic>>.from(
      yanSonuclar[2] as List? ?? const <Map<String, dynamic>>[],
    );
    final yonetimOzeti = YonetimDurumServisi.ozetSec(yonetimKararlari);
    final balAkimiHam = yanSonuclar[3];
    final balAkimi = balAkimiHam is Map
        ? Map<String, dynamic>.from(balAkimiHam)
        : const <String, dynamic>{};

    Map<String, dynamic>? biyolojikModel;
    if (biyolojikModelYukle && yanSonuclar.length >= 5) {
      final ham = yanSonuclar[4];
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


  static Map<String, String> _stringMap(Map<dynamic, dynamic> kaynak) {
    final sonuc = <String, String>{};
    for (final entry in kaynak.entries) {
      sonuc[entry.key.toString()] = (entry.value ?? '').toString();
    }
    return sonuc;
  }

  static int? _nullableInt(dynamic deger) {
    if (deger == null) return null;
    if (deger is int) return deger;
    if (deger is double) return deger.round();
    return int.tryParse(deger.toString());
  }
}
