
import 'veritabani_servisi.dart';

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

class BolmeSurecServisi {
  static Future<List<BolmeSurecUyarisi>> uyarilariGetir(int koloniId) async {
    final koloni = await VeritabaniServisi.koloniOzetiGetir(koloniId);
    final muayeneler = await VeritabaniServisi.muayeneleriGetir(koloniId);

    final sonuc = <BolmeSurecUyarisi>[];
    final bugun = _gun(DateTime.now());

    final sonBolmeMuayenesi = muayeneler.cast<Map<String, dynamic>?>().firstWhere(
          (m) => _toInt(m?['bolmeYapildi']) == 1,
      orElse: () => null,
    );

    if (sonBolmeMuayenesi != null) {
      final referans = _parseTarih(sonBolmeMuayenesi['tarih']);
      if (referans != null) {
        final bitis = referans.add(const Duration(days: 4));
        if (!bugun.isAfter(bitis)) {
          sonuc.add(
            BolmeSurecUyarisi(
              kod: 'ANA_KOLONI_TAKIP',
              baslik: 'Bölme sonrası ana koloniyi yakın takip et',
              mesaj:
              'Bu koloni bölünerek azalmış görünüyor. En az 5 gün boyunca yakın takip et ve beslemeyi ihmal etme.',
              seviye: 'takip',
              referansTarihMetni: _format(referans),
              bitisTarihMetni: '${_format(referans)} - ${_format(bitis)}',
            ),
          );
        }
      }
    }

    final kaynakTipi = (koloni['kaynakTipi'] ?? '').toString().trim().toLowerCase();
    final kaynakKoloniId = _toInt(koloni['kaynakKoloniId']);
    final olusturma = _parseTarih(koloni['olusturmaTarihi']);

    final bool yeniBolmeKolonisi =
        kaynakTipi == 'bölme' || (kaynakTipi == 'bolme');

    if (yeniBolmeKolonisi && kaynakKoloniId > 0 && olusturma != null) {
      final gun5 = olusturma.add(const Duration(days: 5));
      final anaCikis = olusturma.add(const Duration(days: 11));
      final yumurtlamaKontrolSonu = olusturma.add(const Duration(days: 25));

      if (!bugun.isAfter(gun5)) {
        sonuc.add(
          BolmeSurecUyarisi(
            kod: 'YENI_BOLME_MEME',
            baslik: 'Kapalı ana memesi kontrolü',
            mesaj:
            '${_format(gun5)} tarihinde kapalı memeleri imha etmelisin. (Erken kapanan memeler kısa süre arı sütü aldığı için düşük kaliteli ana verir.)',
            seviye: 'kritik',
            referansTarihMetni: _format(olusturma),
            bitisTarihMetni: 'Son gün ${_format(gun5)}',
          ),
        );
      }

      if (!bugun.isAfter(anaCikis)) {
        sonuc.add(
          BolmeSurecUyarisi(
            kod: 'YENI_BOLME_BESLEME',
            baslik: 'Beslemeye devam et',
            mesaj:
            'Tahminen ${_format(anaCikis)} tarihine kadar ana çıkana dek koloniyi beslemeye devam et.',
            seviye: 'takip',
            referansTarihMetni: _format(olusturma),
            bitisTarihMetni: 'Tahmini çıkış ${_format(anaCikis)}',
          ),
        );
      }

      if (!bugun.isBefore(anaCikis) && !bugun.isAfter(yumurtlamaKontrolSonu)) {
        sonuc.add(
          BolmeSurecUyarisi(
            kod: 'YENI_BOLME_ACMA',
            baslik: 'Kovanı açma, yumurtlamayı bekle',
            mesaj:
            'Ana çıkışı itibariyle yumurtlama başlayana kadar kovanı açma. Bu dönem gereksiz müdahale ana kabulünü ve süreci bozabilir.',
            seviye: 'bilgi',
            referansTarihMetni: 'Tahmini ana çıkışı ${_format(anaCikis)}',
            bitisTarihMetni: 'Takip sonu ${_format(yumurtlamaKontrolSonu)}',
          ),
        );
      }
    }

    return sonuc;
  }

  static DateTime _gun(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  static DateTime? _parseTarih(dynamic deger) {
    final metin = (deger ?? '').toString().trim();
    if (metin.isEmpty) return null;

    final dogrudan = DateTime.tryParse(metin);
    if (dogrudan != null) {
      return _gun(dogrudan);
    }

    final parcalar = metin.split('.');
    if (parcalar.length == 3) {
      final gun = int.tryParse(parcalar[0]);
      final ay = int.tryParse(parcalar[1]);
      final yil = int.tryParse(parcalar[2]);
      if (gun != null && ay != null && yil != null) {
        return DateTime(yil, ay, gun);
      }
    }

    return null;
  }

  static String _format(DateTime dt) {
    final gun = dt.day.toString().padLeft(2, '0');
    final ay = dt.month.toString().padLeft(2, '0');
    final yil = dt.year.toString();
    return '$gun.$ay.$yil';
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }
}
