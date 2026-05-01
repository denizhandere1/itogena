import 'surec_motoru.dart';

class BolmeSurecUyarisi {
  final String kod;
  final String baslik;
  final String mesaj;
  final String seviye;
  final String referansTarihMetni;
  final String bitisTarihMetni;

  const BolmeSurecUyarisi({
    required this.kod,
    required this.baslik,
    required this.mesaj,
    required this.seviye,
    this.referansTarihMetni = '',
    this.bitisTarihMetni = '',
  });
}

/// Geriye dönük uyumluluk katmanı.
/// Bölme / anasızlık penceresi artık tek merkezden, SurecMotoru üzerinden okunur.
/// Bu sınıfı çağıran eski ekran veya servis varsa aynı veri yapısını bozmadan sonuç döner.
class BolmeSurecServisi {
  static Future<List<BolmeSurecUyarisi>> uyarilariGetir(int koloniId) async {
    final surecDurumu = await SurecMotoru.durumGetir(koloniId);

    return surecDurumu.aktifSurecler
        .where((u) => u.grup == 'BOLME' || u.grup == 'ANASIZLIK')
        .map(
          (u) => BolmeSurecUyarisi(
            kod: u.kod,
            baslik: u.baslik,
            mesaj: u.mesaj,
            seviye: _seviyeDonustur(u.tip),
            referansTarihMetni: u.referansTarihMetni,
            bitisTarihMetni: u.bitisTarihMetni,
          ),
        )
        .toList(growable: false);
  }

  static String _seviyeDonustur(String tip) {
    switch (tip.trim().toLowerCase()) {
      case 'kritik':
        return 'kritik';
      case 'uyari':
        return 'uyari';
      default:
        return 'takip';
    }
  }
}
