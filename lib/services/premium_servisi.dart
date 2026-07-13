import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'veritabani_servisi.dart';

class PremiumServisi {
  static const bool _incelemeTestModu = false;

  static const String aylikId = 'itogena_pro_aylik';
  static const String yillikId = 'itogena_pro_yillik';
  static const Set<String> _urunIdleri = {aylikId, yillikId};
  static Set<String> get urunIdleri => _urunIdleri;

  static final ValueNotifier<bool> isProNotifier = ValueNotifier(false);
  static bool get isPro => isProNotifier.value;

  // Hangi üründen (aylık/yıllık) abone olunduğu — yalnızca "mevcut planınız"
  // gösterimi içindir, özellik kilidi bu değerden etkilenmez.
  static final ValueNotifier<String?> aktifUrunIdNotifier = ValueNotifier(null);
  static String? get aktifUrunId => aktifUrunIdNotifier.value;

  // UI katmanının satın alma durumunu (pending/error/canceled dahil) izlemesi
  // için ham akış — entitlement güncellemesi zaten _satinaAlmalariIsle'da yapılır.
  static Stream<List<PurchaseDetails>> get satinAlmaAkisi =>
      InAppPurchase.instance.purchaseStream;

  static StreamSubscription<List<PurchaseDetails>>? _abonelik;
  static Timer? _periyodikDogrulama;
  static bool _yuklendi = false;

  // Uygulama başlarken çağrılır
  static Future<void> yukle() async {
    if (_incelemeTestModu) {
      isProNotifier.value = true;
      return;
    }
    if (_yuklendi) return;
    _yuklendi = true;

    // Önce yerel cache'i yükle (hızlı açılış için)
    final yerel = await VeritabaniServisi.ayarStringGetir(
      'premium_aktif',
      varsayilan: '0',
    );
    isProNotifier.value = yerel == '1';

    final yerelUrunId = await VeritabaniServisi.ayarStringGetir(
      'premium_urun_id',
      varsayilan: '',
    );
    aktifUrunIdNotifier.value = yerelUrunId.isEmpty ? null : yerelUrunId;

    final store = InAppPurchase.instance;
    final musait = await store.isAvailable();
    if (!musait) return;

    // Satın alma akışını dinle
    _abonelik = store.purchaseStream.listen(
      _satinaAlmalariIsle,
      onError: (_) {},
    );

    // Geçmiş satın almaları geri yükle (abonelik aktif mi?)
    await store.restorePurchases();

    // Uygulama açıkken abonelik durumu (iptal/expire) düzenli aralıklarla
    // Play'den yeniden doğrulansın — bir kere aktif olması kalıcı sayılmasın.
    _periyodikDogrulama = Timer.periodic(
      const Duration(hours: 6),
      (_) => dogrula(),
    );
  }

  // Uygulama öne geldiğinde (resume) veya periyodik olarak çağrılır
  static Future<void> dogrula() async {
    if (_incelemeTestModu) return;
    final store = InAppPurchase.instance;
    final musait = await store.isAvailable();
    if (!musait) return;
    await store.restorePurchases();
  }

  static Future<void> _satinaAlmalariIsle(
    List<PurchaseDetails> satinaAlmalar,
  ) async {
    bool aktif = false;
    String? urunId;
    for (final satinaAlma in satinaAlmalar) {
      if (!_urunIdleri.contains(satinaAlma.productID)) continue;

      if (satinaAlma.status == PurchaseStatus.purchased ||
          satinaAlma.status == PurchaseStatus.restored) {
        aktif = true;
        urunId = satinaAlma.productID;
      }

      if (satinaAlma.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(satinaAlma);
      }
    }

    await VeritabaniServisi.ayarKaydet('premium_aktif', aktif ? '1' : '0');
    isProNotifier.value = aktif;

    await VeritabaniServisi.ayarKaydet('premium_urun_id', aktif ? (urunId ?? '') : '');
    aktifUrunIdNotifier.value = aktif ? urunId : null;
  }

  // Aylık/Yıllık ürünlerin gerçek fiyat bilgilerini getirir — fiyatlandırma
  // ekranında hardcoded fiyat yerine kullanılır.
  static Future<List<ProductDetails>> urunleriGetir() async {
    final store = InAppPurchase.instance;
    final musait = await store.isAvailable();
    if (!musait) return [];
    final sonuc = await store.queryProductDetails(_urunIdleri);
    return sonuc.productDetails;
  }

  // Satın alma başlat — UI'dan çağrılır
  static Future<bool> satinaAlBaslat(String urunId) async {
    final store = InAppPurchase.instance;
    final musait = await store.isAvailable();
    if (!musait) return false;

    final sonuc = await store.queryProductDetails({urunId});
    if (sonuc.productDetails.isEmpty) return false;

    final urun = sonuc.productDetails.first;
    final parametre = PurchaseParam(productDetails: urun);
    return store.buyNonConsumable(purchaseParam: parametre);
  }

  // Geçmiş satın almaları geri yükle — UI'dan çağrılır
  static Future<void> geriYukle() async {
    final store = InAppPurchase.instance;
    final musait = await store.isAvailable();
    if (!musait) return;
    await store.restorePurchases();
  }

  static void dispose() {
    _abonelik?.cancel();
    _abonelik = null;
    _periyodikDogrulama?.cancel();
    _periyodikDogrulama = null;
    _yuklendi = false;
  }
}
