import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'veritabani_servisi.dart';

class PremiumServisi {
  static const String aylikId = 'itogena_pro_aylik';
  static const String yillikId = 'itogena_pro_yillik';
  static const Set<String> _urunIdleri = {aylikId, yillikId};

  static final ValueNotifier<bool> isProNotifier = ValueNotifier(false);
  static bool get isPro => isProNotifier.value;

  static StreamSubscription<List<PurchaseDetails>>? _abonelik;
  static bool _yuklendi = false;

  // Uygulama başlarken çağrılır
  static Future<void> yukle() async {
    if (_yuklendi) return;
    _yuklendi = true;

    // Önce yerel cache'i yükle (hızlı açılış için)
    final yerel = await VeritabaniServisi.ayarStringGetir(
      'premium_aktif',
      varsayilan: '0',
    );
    isProNotifier.value = yerel == '1';

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
  }

  static Future<void> _satinaAlmalariIsle(
    List<PurchaseDetails> satinaAlmalar,
  ) async {
    bool aktif = false;
    for (final satinaAlma in satinaAlmalar) {
      if (!_urunIdleri.contains(satinaAlma.productID)) continue;

      if (satinaAlma.status == PurchaseStatus.purchased ||
          satinaAlma.status == PurchaseStatus.restored) {
        aktif = true;
      }

      if (satinaAlma.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(satinaAlma);
      }
    }

    final yeniDeger = aktif ? '1' : '0';
    await VeritabaniServisi.ayarKaydet('premium_aktif', yeniDeger);
    isProNotifier.value = aktif;
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
    _yuklendi = false;
  }
}
