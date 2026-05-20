import 'veritabani_servisi.dart';
import 'sezon_biyoloji_matrisi.dart';

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

  /// FAZ 11: merkezi sezon-biyoloji matrisi.
  ///
  /// Eski iki parçalı sezon bilgisini bozmadan, karar motorlarının kullanacağı
  /// biyolojik sezon bağlamını üretir. Sezon artık yalnızca "kış/üretim" değil;
  /// yavru beklentisi, stok baskısı, aktivasyon katsayısı ve saha amacını da taşır.
  static Future<SezonBiyolojiBilgisi> aktifSezonBiyolojiBilgisiGetir({
    DateTime? tarih,
    int? arilikId,
  }) {
    return SezonBiyolojiMatrisi.bilgiGetir(
      tarih: tarih,
      arilikId: arilikId,
    );
  }

  static Future<Map<String, dynamic>> aktifSezonBiyolojiGetir({
    DateTime? tarih,
    int? arilikId,
  }) async {
    final bilgi = await aktifSezonBiyolojiBilgisiGetir(
      tarih: tarih,
      arilikId: arilikId,
    );
    return bilgi.toMap();
  }
}
