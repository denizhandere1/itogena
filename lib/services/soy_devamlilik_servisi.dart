
import 'package:sqflite/sqflite.dart';
import 'veritabani_servisi.dart';

class SoyDevamlilikSonucu {
  final int koloniId;
  final int toplamTureyen;
  final int aktifTureyen;
  final int sonenTureyen;
  final int hesabaKatilmayanCokYeni;
  final double yasamaOrani;
  final double guvenKatsayisi;
  final int puan;
  final String durum;
  final String yorum;
  final bool veriYetersizMi;

  const SoyDevamlilikSonucu({
    required this.koloniId,
    required this.toplamTureyen,
    required this.aktifTureyen,
    required this.sonenTureyen,
    required this.hesabaKatilmayanCokYeni,
    required this.yasamaOrani,
    required this.guvenKatsayisi,
    required this.puan,
    required this.durum,
    required this.yorum,
    required this.veriYetersizMi,
  });

  Map<String, dynamic> toMap() {
    return {
      'koloniId': koloniId,
      'toplamTureyen': toplamTureyen,
      'aktifTureyen': aktifTureyen,
      'sonenTureyen': sonenTureyen,
      'hesabaKatilmayanCokYeni': hesabaKatilmayanCokYeni,
      'yasamaOrani': yasamaOrani,
      'guvenKatsayisi': guvenKatsayisi,
      'puan': puan,
      'durum': durum,
      'yorum': yorum,
      'veriYetersizMi': veriYetersizMi,
    };
  }
}

class SoyDevamlilikServisi {
  static const int minimumGunEsigi = 45;
  static const int guvenIcinTamEsik = 4;
  static const double notrMerkez = 0.70;
  static const int maxMutlakPuan = 6;

  static Future<SoyDevamlilikSonucu> analizYap(int koloniId) async {
    final db = await VeritabaniServisi.db;
    final now = DateTime.now();

    final tumCocuklar = await db.query(
      'koloniler',
      where: 'kaynakKoloniId = ?',
      whereArgs: [koloniId],
      orderBy: 'olusturmaTarihi ASC, id ASC',
    );

    if (tumCocuklar.isEmpty) {
      return SoyDevamlilikSonucu(
        koloniId: koloniId,
        toplamTureyen: 0,
        aktifTureyen: 0,
        sonenTureyen: 0,
        hesabaKatilmayanCokYeni: 0,
        yasamaOrani: 0,
        guvenKatsayisi: 0,
        puan: 0,
        durum: 'Veri Yok',
        yorum: 'Bu koloniden türeyen kayıtlı koloni görünmüyor.',
        veriYetersizMi: true,
      );
    }

    int aktif = 0;
    int sonen = 0;
    int cokYeni = 0;

    for (final cocuk in tumCocuklar) {
      final olusturma = await _koloniBaslangicTarihiBul(db, cocuk);
      if (olusturma == null) {
        cokYeni++;
        continue;
      }

      final gunFarki = now.difference(olusturma).inDays;
      if (gunFarki < minimumGunEsigi) {
        cokYeni++;
        continue;
      }

      final cocukId = _toInt(cocuk['id']);
      final aktifMi = cocukId > 0
          ? await VeritabaniServisi.koloniAktifMi(cocukId)
          : false;
      if (aktifMi) {
        aktif++;
      } else {
        sonen++;
      }
    }

    final toplam = aktif + sonen;

    if (toplam <= 0) {
      return SoyDevamlilikSonucu(
        koloniId: koloniId,
        toplamTureyen: 0,
        aktifTureyen: 0,
        sonenTureyen: 0,
        hesabaKatilmayanCokYeni: cokYeni,
        yasamaOrani: 0,
        guvenKatsayisi: 0,
        puan: 0,
        durum: 'Veri Yetersiz',
        yorum:
        'Türeyen koloniler var; ancak henüz en az 45 gün geçmiş yeterli veri oluşmamış.',
        veriYetersizMi: true,
      );
    }

    final oran = aktif / toplam;
    final guven = (toplam / guvenIcinTamEsik).clamp(0.0, 1.0);

    double hamEtki = ((oran - notrMerkez) / 0.30) * maxMutlakPuan;
    hamEtki = hamEtki.clamp(
      -maxMutlakPuan.toDouble(),
      maxMutlakPuan.toDouble(),
    );

    final double yumusatmis = hamEtki * guven;
    final int puan = yumusatmis.round().clamp(-maxMutlakPuan, maxMutlakPuan);

    final durum = _durumUret(
      toplamTureyen: toplam,
      yasamaOrani: oran,
      puan: puan,
    );

    final yorum = _yorumUret(
      toplamTureyen: toplam,
      aktifTureyen: aktif,
      sonenTureyen: sonen,
      cokYeni: cokYeni,
      yasamaOrani: oran,
      puan: puan,
      guven: guven,
    );

    return SoyDevamlilikSonucu(
      koloniId: koloniId,
      toplamTureyen: toplam,
      aktifTureyen: aktif,
      sonenTureyen: sonen,
      hesabaKatilmayanCokYeni: cokYeni,
      yasamaOrani: oran,
      guvenKatsayisi: guven,
      puan: puan,
      durum: durum,
      yorum: yorum,
      veriYetersizMi: toplam < 2,
    );
  }

  static Future<Map<int, SoyDevamlilikSonucu>> topluAnalizYap(
      List<int> koloniIdleri,
      ) async {
    final Map<int, SoyDevamlilikSonucu> sonuc = {};
    final benzersiz = koloniIdleri.where((e) => e > 0).toSet().toList();

    for (final koloniId in benzersiz) {
      sonuc[koloniId] = await analizYap(koloniId);
    }
    return sonuc;
  }

  static Future<DateTime?> _koloniBaslangicTarihiBul(
      Database db,
      Map<String, dynamic> koloni,
      ) async {
    final olusturmaMetni = (koloni['olusturmaTarihi'] ?? '').toString().trim();
    final olusturma = _guvenliTarihParse(olusturmaMetni);
    if (olusturma != null) return olusturma;

    final int id = _toInt(koloni['id']);
    if (id <= 0) return null;

    final ilkMuayene = await db.query(
      'muayeneler',
      columns: ['tarih'],
      where: 'koloniId = ?',
      whereArgs: [id],
      orderBy: 'tarih ASC, id ASC',
      limit: 1,
    );

    if (ilkMuayene.isEmpty) return null;
    final tarihMetni = (ilkMuayene.first['tarih'] ?? '').toString().trim();
    return _guvenliTarihParse(tarihMetni);
  }

  static bool _sonmusDurumMu(dynamic durum) {
    // Geriye dönük uyumluluk için tutulur.
    // Normal akışta aktiflik/sönmüşlük yalnızca VeritabaniServisi.koloniAktifMi
    // üzerinden okunur.
    return VeritabaniServisi.sonmusDurumMu(durum);
  }

  static int _toInt(dynamic deger) {
    if (deger == null) return 0;
    if (deger is int) return deger;
    if (deger is double) return deger.round();
    return int.tryParse(deger.toString()) ?? 0;
  }

  static DateTime? _guvenliTarihParse(String metin) {
    if (metin.trim().isEmpty) return null;

    final dogrudan = DateTime.tryParse(metin);
    if (dogrudan != null) {
      return DateTime(dogrudan.year, dogrudan.month, dogrudan.day);
    }

    if (metin.contains('.')) {
      final p = metin.split('.');
      if (p.length == 3) {
        final gun = int.tryParse(p[0]);
        final ay = int.tryParse(p[1]);
        final yil = int.tryParse(p[2]);
        if (gun != null && ay != null && yil != null) {
          return DateTime(yil, ay, gun);
        }
      }
    }

    if (metin.contains('/')) {
      final p = metin.split('/');
      if (p.length == 3) {
        final gun = int.tryParse(p[0]);
        final ay = int.tryParse(p[1]);
        final yil = int.tryParse(p[2]);
        if (gun != null && ay != null && yil != null) {
          return DateTime(yil, ay, gun);
        }
      }
    }

    return null;
  }

  static String _durumUret({
    required int toplamTureyen,
    required double yasamaOrani,
    required int puan,
  }) {
    if (toplamTureyen <= 0) return 'Veri Yok';
    if (puan >= 4 && yasamaOrani >= 0.80) return 'Güçlü Soy';
    if (puan >= 1 && yasamaOrani >= 0.65) return 'Olumlu Soy';
    if (puan <= -4 || yasamaOrani < 0.40) return 'Zayıf Soy';
    if (puan <= -1 || yasamaOrani < 0.60) return 'Riskli Soy';
    return 'Nötr';
  }

  static String _yorumUret({
    required int toplamTureyen,
    required int aktifTureyen,
    required int sonenTureyen,
    required int cokYeni,
    required double yasamaOrani,
    required int puan,
    required double guven,
  }) {
    if (toplamTureyen <= 0) {
      return 'Bu koloniden türeyen kayıtlı koloni görünmüyor.';
    }

    final yuzde = (yasamaOrani * 100).round();

    String temel;
    if (puan >= 4) {
      temel = '%$yuzde devamlılık. Güçlü soy.';
    } else if (puan >= 1) {
      temel = '%$yuzde devamlılık. Olumlu soy.';
    } else if (puan <= -4) {
      temel = '%$yuzde devamlılık. Zayıf soy.';
    } else if (puan <= -1) {
      temel = '%$yuzde devamlılık. Riskli soy.';
    } else {
      temel = '%$yuzde devamlılık. Nötr soy.';
    }

    String veriNotu = '';
    if (guven < 0.50) {
      veriNotu = ' Veri zayıf, dikkatli değerlendirilmeli.';
    } else if (guven < 1.0) {
      veriNotu = ' Veri sınırlı, izlenmeli.';
    }

    String sayiNotu = '';
    if (toplamTureyen > 0) {
      sayiNotu =
      ' $aktifTureyen aktif, $sonenTureyen sönen türeyen koloni görülüyor.';
    }

    String yeniNotu = '';
    if (cokYeni > 0) {
      yeniNotu =
      ' $cokYeni koloni değerlendirmeye alınamayacak kadar yeni görünüyor.';
    }

    return '$temel$veriNotu$sayiNotu$yeniNotu'.trim();
  }
}
