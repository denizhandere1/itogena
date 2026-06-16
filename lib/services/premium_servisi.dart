import 'package:flutter/foundation.dart';
import 'package:itogena_v45/services/veritabani_servisi.dart';

class PremiumServisi {
  static final ValueNotifier<bool> isProNotifier = ValueNotifier(false);
  static bool _yuklendi = false;

  static bool get isPro => isProNotifier.value;

  // Uygulama başlarken bir kez çağrılır
  static Future<void> yukle() async {
    if (_yuklendi) return;
    final deger = await VeritabaniServisi.ayarStringGetir(
      'premium_aktif',
      varsayilan: '0',
    );
    isProNotifier.value = deger == '1';
    _yuklendi = true;
  }

  // Geliştirme/test için — ödeme sistemi kurulduğunda bu kaldırılacak
  static Future<void> proAktifEt() async {
    await VeritabaniServisi.ayarKaydet('premium_aktif', '1');
    isProNotifier.value = true;
  }

  static Future<void> proIptalEt() async {
    await VeritabaniServisi.ayarKaydet('premium_aktif', '0');
    isProNotifier.value = false;
  }
}
