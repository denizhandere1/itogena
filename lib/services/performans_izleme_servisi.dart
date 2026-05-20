import 'package:flutter/foundation.dart';

/// Geliştirme sırasında pahalı servis çağrılarını ölçmek için kullanılır.
/// Release modda log üretmez; veri tabanına yazmaz, kalıcı veri değiştirmez.
class PerformansIzlemeServisi {
  static bool aktif = kDebugMode;

  static Future<T> olc<T>(
    String etiket,
    Future<T> Function() islem, {
    int yavasEsikMs = 300,
  }) async {
    if (!aktif) return islem();

    final stopwatch = Stopwatch()..start();
    try {
      return await islem();
    } finally {
      stopwatch.stop();
      final sureMs = stopwatch.elapsedMilliseconds;
      final isaret = sureMs >= yavasEsikMs ? 'YAVAS' : 'OK';
      debugPrint('[ITOGENA-PERF][$isaret] $etiket: ${sureMs}ms');
    }
  }

  static T olcSync<T>(
    String etiket,
    T Function() islem, {
    int yavasEsikMs = 50,
  }) {
    if (!aktif) return islem();

    final stopwatch = Stopwatch()..start();
    try {
      return islem();
    } finally {
      stopwatch.stop();
      final sureMs = stopwatch.elapsedMilliseconds;
      final isaret = sureMs >= yavasEsikMs ? 'YAVAS' : 'OK';
      debugPrint('[ITOGENA-PERF][$isaret] $etiket: ${sureMs}ms');
    }
  }
}
