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
  }) async {
    final ozet = await KararAsistanServisi.yonetimDurumOzetiGetir(
      koloniId,
      hazirKoloni: hazirKoloni,
    );
    if (_suruplukYonetimKarariMi(ozet)) {
      return const <String, dynamic>{};
    }
    return Map<String, dynamic>.from(ozet);
  }

  static Future<List<Map<String, dynamic>>> kararlarGetir(
    int koloniId, {
    Map<String, dynamic>? hazirKoloni,
  }) async {
    final kararlar = await KararAsistanServisi.yonetimKararlariGetir(
      koloniId,
      hazirKoloni: hazirKoloni,
    );
    return kararlar
        .where((k) => !_suruplukYonetimKarariMi(k))
        .map((k) => Map<String, dynamic>.from(k))
        .toList(growable: false);
  }

  static Map<String, dynamic> ozetSec(
    List<Map<String, dynamic>> kararlar,
  ) {
    final gridKararlari = kararlar
        .where((k) => k['gridGosterilebilir'] != false)
        .where((k) => !_suruplukYonetimKarariMi(k))
        .toList(growable: false);
    if (gridKararlari.isEmpty) {
      return const <String, dynamic>{};
    }

    final sirali = List<Map<String, dynamic>>.from(gridKararlari)
      ..sort((a, b) => _toInt(b['oncelik']).compareTo(_toInt(a['oncelik'])));
    return Map<String, dynamic>.from(sirali.first);
  }

  static bool _suruplukYonetimKarariMi(Map<String, dynamic> karar) {
    final birlesik = [
      karar['kod'],
      karar['baslik'],
      karar['kisa'],
      karar['mesaj'],
      karar['tip'],
    ].where((e) => e != null).join(' ').toLowerCase();

    return birlesik.contains('surupluk') ||
        birlesik.contains('şurupluk') ||
        birlesik.contains('şurupluğu') ||
        birlesik.contains('suruplugu');
  }

  static int _toInt(dynamic deger) {
    if (deger == null) return 0;
    if (deger is int) return deger;
    if (deger is double) return deger.round();
    return int.tryParse(deger.toString()) ?? 0;
  }
}
