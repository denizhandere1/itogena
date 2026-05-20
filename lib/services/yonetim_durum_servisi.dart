import 'karar_asistan_servisi.dart';

/// ITOGENA yönetim durumu geçiş servisi.
///
/// Amaç, grid ve context tarafının `KararAsistanServisi` içindeki geniş
/// yönetim API'sine doğrudan bağımlılığını azaltmaktır.
///
/// Bu ilk sürüm bilinçli olarak davranış değiştirmez: mevcut yönetim kararları
/// yine KararAsistanServisi üzerinden üretilir. Sonraki adımda
/// `yonetimKararlariGetir` içeriği parça parça bu servise taşınacak; ekranlar
/// ve context katmanı ise bu dosyayı kullanmaya devam edeceği için dış API
/// sabit kalacaktır.
class YonetimDurumServisi {
  static Future<Map<String, dynamic>> ozetGetir(
    int koloniId, {
    Map<String, dynamic>? hazirKoloni,
  }) {
    return KararAsistanServisi.yonetimDurumOzetiGetir(
      koloniId,
      hazirKoloni: hazirKoloni,
    );
  }

  static Future<List<Map<String, dynamic>>> kararlarGetir(
    int koloniId, {
    Map<String, dynamic>? hazirKoloni,
  }) {
    return KararAsistanServisi.yonetimKararlariGetir(
      koloniId,
      hazirKoloni: hazirKoloni,
    );
  }

  static Map<String, dynamic> ozetSec(
    List<Map<String, dynamic>> kararlar,
  ) {
    final gridKararlari = kararlar
        .where((k) => k['gridGosterilebilir'] != false)
        .toList(growable: false);
    if (gridKararlari.isEmpty) {
      return const <String, dynamic>{};
    }

    final sirali = List<Map<String, dynamic>>.from(gridKararlari)
      ..sort((a, b) => _toInt(b['oncelik']).compareTo(_toInt(a['oncelik'])));
    return Map<String, dynamic>.from(sirali.first);
  }

  static int _toInt(dynamic deger) {
    if (deger == null) return 0;
    if (deger is int) return deger;
    if (deger is double) return deger.round();
    return int.tryParse(deger.toString()) ?? 0;
  }
}
