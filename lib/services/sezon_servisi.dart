import 'veritabani_servisi.dart';

class SezonServisi {
  static Future<Map<String, String>> aktifSezonBilgisiGetir([DateTime? tarih]) async {
    return VeritabaniServisi.aktifSezonBilgisiGetir(tarih);
  }

  static Future<String> aktifSezonAdiGetir([DateTime? tarih]) async {
    final bilgi = await aktifSezonBilgisiGetir(tarih);
    return bilgi['ad'] ?? 'Bilinmeyen Sezon';
  }

  static Future<String> aktifSezonAralikMetniGetir([DateTime? tarih]) async {
    final bilgi = await aktifSezonBilgisiGetir(tarih);
    final bas = bilgi['baslangic'] ?? '--';
    final bit = bilgi['bitis'] ?? '--';
    return '$bas / $bit';
  }

  static Future<bool> kisSezonuMu([DateTime? tarih]) async {
    final bilgi = await aktifSezonBilgisiGetir(tarih);
    return bilgi['kod'] == 'kis';
  }

  static Future<bool> uretimSezonuMu([DateTime? tarih]) async {
    final bilgi = await aktifSezonBilgisiGetir(tarih);
    return bilgi['kod'] == 'uretim';
  }
}