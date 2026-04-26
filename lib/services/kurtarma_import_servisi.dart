import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'veritabani_servisi.dart';

class KurtarmaImportServisi {
  static Future<void> calistir() async {
    final db = await VeritabaniServisi.db;

    // YENİ ARILIK OLUŞTUR (VERİ SİLME YOK)
    final int arilikId =
    await VeritabaniServisi.arilikEkle('ULUKOY_KURTARMA');

    // CSV OKU
    final kovanCsv =
    await rootBundle.loadString('assets/import/kovanlar_import.csv');
    final muayeneCsv =
    await rootBundle.loadString('assets/import/muayeneler_import.csv');

    final kovanlar = _parseCsv(kovanCsv);
    final muayeneler = _parseCsv(muayeneCsv);

    // KOVANNO → ID MAP
    final Map<String, int> koloniMap = {};

    // 1. KOLONİLERİ EKLE
    for (var row in kovanlar) {
      final kovanNo = row['kovanNo'] ?? '';

      final id = await VeritabaniServisi.koloniEkle({
        'arilikId': arilikId,
        'kovanNo': kovanNo,
        'ilkKovanNo': kovanNo,
        'anaYili': row['anaYili'] ?? '2025',
        'kaynakTipi': row['kaynakTipi'] ?? 'Bilinmiyor',
        'kaynakKoloni': row['kaynakKoloni'] ?? '',
        'genetik': '',
        'rol': 'Üretim',
        'sahaSirasi': 0,
        'sonCita': 0,
        'maxCitaKapasiye': 0,
        'bal_cita': 0,
        'skor': 0,
        'notMetni': 'CSV kurtarma',
      });

      koloniMap[kovanNo] = id;
    }

    // 2. KAYNAK BAĞLANTILARI GÜNCELLE
    for (var row in kovanlar) {
      final kovanNo = row['kovanNo'];
      final kaynak = row['kaynakKoloni'];

      if (kaynak != null &&
          kaynak.isNotEmpty &&
          koloniMap.containsKey(kaynak)) {
        await db.update(
          'koloniler',
          {
            'kaynakKoloniId': koloniMap[kaynak],
            'ebeveynKoloniId': koloniMap[kaynak],
          },
          where: 'id = ?',
          whereArgs: [koloniMap[kovanNo]],
        );
      }
    }

    // 3. MUAYENELERİ EKLE
    for (var row in muayeneler) {
      final kovanNo = row['kovanNo'];

      if (!koloniMap.containsKey(kovanNo)) continue;

      await VeritabaniServisi.muayeneEkle({
        'koloniId': koloniMap[kovanNo],
        'tarih': row['tarih'] ?? '',
        'citaSayisi': int.tryParse(row['cita'] ?? '0') ?? 0,
        'bal_cita': int.tryParse(row['bal'] ?? '0') ?? 0,
        'yavruluCita': int.tryParse(row['yavru'] ?? '0') ?? 0,
        'ogulAtti': (row['ogul'] == '1') ? 1 : 0,
        'ogulBelirtisi': 0,
        'bolmeYapildi': 0,
        'kovanSondu': 0,
        'notlar': 'CSV kurtarma',
        'mizac': 'Sakin',
        'yavruDuzeni': 'Normal',
        'anaAriGoruldu': 1,
        'varroaGoruldu': 0,
      });
    }
  }

  // BASİT CSV PARSER
  static List<Map<String, String>> _parseCsv(String csv) {
    final lines = const LineSplitter().convert(csv);
    final headers = lines.first.split(',');

    return lines.skip(1).map((line) {
      final values = line.split(',');
      final Map<String, String> map = {};
      for (int i = 0; i < headers.length; i++) {
        map[headers[i]] = i < values.length ? values[i] : '';
      }
      return map;
    }).toList();
  }
}