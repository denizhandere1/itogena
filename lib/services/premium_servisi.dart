import 'package:itogena_v45/services/veritabani_servisi.dart';

class PremiumServisi {
  static bool _isPro = false;
  static bool _yuklendi = false;

  static bool get isPro => _isPro;

  // Uygulama başlarken bir kez çağrılır
  static Future<void> yukle() async {
    if (_yuklendi) return;
    final deger = await VeritabaniServisi.ayarStringGetir(
      'premium_aktif',
      varsayilan: '0',
    );
    _isPro = deger == '1';
    _yuklendi = true;
  }

  // Geliştirme/test için — ödeme sistemi kurulduğunda bu kaldırılacak
  static Future<void> proAktifEt() async {
    await VeritabaniServisi.ayarKaydet('premium_aktif', '1');
    _isPro = true;
  }

  static Future<void> proIptalEt() async {
    await VeritabaniServisi.ayarKaydet('premium_aktif', '0');
    _isPro = false;
  }
}
