import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import 'karar_asistan_servisi.dart';
import 'veritabani_servisi.dart';

class YedekServisi {
  static const String uygulamaAdi = 'itogena';
  static const int yedekFormatVersiyonu = 4;
  static const int veritabaniVersiyonu = 18;
  static const int schemaVersion = 2;

  static const String appVersionName = '1.0.9';
  static const int appVersionCode = 10;

  static const List<String> _zorunluTablolar = [
    'ariliklar',
    'koloniler',
    'muayeneler',
    'koloni_olaylari',
    'koloni_numara_gecmisi',
    'ayarlar',
  ];

  static Future<String> yedekAl() async {
    final db = await VeritabaniServisi.db;

    final ariliklar = await db.query('ariliklar', orderBy: 'id ASC');
    final koloniler = await db.query('koloniler', orderBy: 'id ASC');
    final muayeneler = await db.query('muayeneler', orderBy: 'id ASC');
    final olaylar = await db.query('koloni_olaylari', orderBy: 'id ASC');
    final numaraGecmisi = await db.query(
      'koloni_numara_gecmisi',
      orderBy: 'id ASC',
    );
    final ayarlar = await db.query('ayarlar', orderBy: 'anahtar ASC');

    final yedek = <String, dynamic>{
      'meta': <String, dynamic>{
        'app': uygulamaAdi,
        'backupVersion': yedekFormatVersiyonu,
        'schemaVersion': schemaVersion,
        'dbVersion': veritabaniVersiyonu,
        'appVersionName': appVersionName,
        'appVersionCode': appVersionCode,
        'createdAt': DateTime.now().toIso8601String(),
      },
      'data': <String, dynamic>{
        'ariliklar': ariliklar.map(_satiriMapeCevir).toList(),
        'koloniler': koloniler.map(_satiriMapeCevir).toList(),
        'muayeneler': muayeneler.map(_satiriMapeCevir).toList(),
        'koloni_olaylari': olaylar.map(_satiriMapeCevir).toList(),
        'koloni_numara_gecmisi': numaraGecmisi.map(_satiriMapeCevir).toList(),
        'ayarlar': ayarlar.map(_satiriMapeCevir).toList(),
      },
    };

    return const JsonEncoder.withIndent('  ').convert(yedek);
  }

  static Future<void> yedektenYukle(String jsonStr) async {
    if (jsonStr.trim().isEmpty) {
      throw Exception('Yedek verisi boş görünüyor.');
    }

    final dynamic ham;
    try {
      ham = jsonDecode(jsonStr);
    } catch (_) {
      throw Exception('Yedek dosyası okunamadı. JSON formatı bozuk.');
    }

    if (ham is! Map<String, dynamic>) {
      throw Exception('Yedek dosyası beklenen formatta değil.');
    }

    final Map<String, dynamic> kok = ham;

    _metaDogrula(kok);

    final dynamic dataDynamic = kok['data'];
    if (dataDynamic is! Map<String, dynamic>) {
      throw Exception('Yedek dosyasında veri bölümü bulunamadı.');
    }

    final Map<String, dynamic> data = dataDynamic;
    _tablolariDogrula(data);

    final db = await VeritabaniServisi.db;
    await _kolonUyumlulugunuDogrula(db, data);

    await db.transaction((txn) async {
      await _tumVeriyiTemizle(txn);
      await _tumVeriyiYukle(txn, data);
      await _sqliteSayaclariniSifirla(txn);
    });

    await VeritabaniServisi.sistemBakimiCalistir();
    KararAsistanServisi.tumCacheTemizle();
  }

  static void _metaDogrula(Map<String, dynamic> kok) {
    final dynamic metaDynamic = kok['meta'];
    if (metaDynamic is! Map<String, dynamic>) {
      throw Exception('Yedek dosyasında meta bilgisi bulunamadı.');
    }

    final app = (metaDynamic['app'] ?? '').toString().trim();
    if (app != uygulamaAdi) {
      throw Exception('Bu yedek İTOGENA uygulamasına ait görünmüyor.');
    }

    final backupVersion = _toInt(metaDynamic['backupVersion']);
    if (backupVersion <= 0) {
      throw Exception('Yedek format sürümü okunamadı.');
    }

    final backupSchemaVersion = _toInt(metaDynamic['schemaVersion']);
    final backupDbVersion = _toInt(metaDynamic['dbVersion']);
    final backupAppVersionName =
        (metaDynamic['appVersionName'] ?? '').toString().trim();
    final backupAppVersionCode = _toInt(metaDynamic['appVersionCode']);

    if (backupVersion < yedekFormatVersiyonu ||
        backupSchemaVersion < schemaVersion ||
        backupDbVersion < veritabaniVersiyonu) {
      throw Exception(
        'Bu yedek eski bir İTOGENA sürümüne ait. '
        'Veri kaybı veya eksik alan riski nedeniyle otomatik yükleme durduruldu. '
        'Yedek: format $backupVersion, şema $backupSchemaVersion, DB $backupDbVersion. '
        'Gerekli: format $yedekFormatVersiyonu, şema $schemaVersion, DB $veritabaniVersiyonu.',
      );
    }

    if (backupVersion > yedekFormatVersiyonu ||
        backupSchemaVersion > schemaVersion ||
        backupDbVersion > veritabaniVersiyonu) {
      throw Exception(
        'Bu yedek daha yeni bir İTOGENA sürümünde oluşturulmuş. '
        'Önce uygulamayı güncellemelisin. '
        'Yedek: format $backupVersion, şema $backupSchemaVersion, DB $backupDbVersion. '
        'Bu uygulama: format $yedekFormatVersiyonu, şema $schemaVersion, DB $veritabaniVersiyonu.',
      );
    }

    if (backupAppVersionCode > appVersionCode) {
      final yedekSurum = backupAppVersionName.isEmpty
          ? backupAppVersionCode.toString()
          : '$backupAppVersionName ($backupAppVersionCode)';
      throw Exception(
        'Bu yedek daha yeni bir uygulama sürümünde oluşturulmuş. '
        'Yedek sürümü: $yedekSurum. '
        'Önce uygulamayı güncellemelisin.',
      );
    }
  }

  static void _tablolariDogrula(Map<String, dynamic> data) {
    for (final tablo in _zorunluTablolar) {
      if (!data.containsKey(tablo)) {
        throw Exception('Yedek dosyasında "$tablo" bölümü eksik.');
      }

      final dynamic liste = data[tablo];
      if (liste is! List) {
        throw Exception('Yedek dosyasında "$tablo" verisi liste değil.');
      }
    }
  }

  static Future<void> _kolonUyumlulugunuDogrula(
    Database db,
    Map<String, dynamic> data,
  ) async {
    for (final tablo in _zorunluTablolar) {
      final tabloKolonlari = await _tabloKolonlariGetir(db, tablo);
      if (tabloKolonlari.isEmpty) {
        throw Exception('Veritabanında "$tablo" tablosu bulunamadı.');
      }

      final liste = data[tablo] as List;
      for (final item in liste) {
        if (item is! Map) {
          throw Exception('"$tablo" içinde geçersiz kayıt bulundu.');
        }

        for (final key in item.keys) {
          final kolon = key.toString();
          if (!tabloKolonlari.contains(kolon)) {
            throw Exception(
              'Yedek dosyasında "$tablo.$kolon" alanı var; '
              'bu uygulamadaki veritabanında bu alan yok. '
              'Yedek daha yeni veya farklı bir şemaya ait olabilir. '
              'Yükleme durduruldu.',
            );
          }
        }
      }
    }
  }

  static Future<Set<String>> _tabloKolonlariGetir(
    Database db,
    String tablo,
  ) async {
    final sonuc = await db.rawQuery('PRAGMA table_info($tablo)');
    return sonuc
        .map((satir) => (satir['name'] ?? '').toString())
        .where((ad) => ad.isNotEmpty)
        .toSet();
  }

  static Future<void> _tumVeriyiTemizle(DatabaseExecutor txn) async {
    await txn.delete('koloni_olaylari');
    await txn.delete('koloni_numara_gecmisi');
    await txn.delete('muayeneler');
    await txn.delete('koloniler');
    await txn.delete('ariliklar');
    await txn.delete('ayarlar');
  }

  static Future<void> _tumVeriyiYukle(
    DatabaseExecutor txn,
    Map<String, dynamic> data,
  ) async {
    await _listeyiTabloyaYukle(txn, 'ariliklar', data['ariliklar'] as List);
    await _listeyiTabloyaYukle(txn, 'koloniler', data['koloniler'] as List);
    await _listeyiTabloyaYukle(txn, 'muayeneler', data['muayeneler'] as List);
    await _listeyiTabloyaYukle(
      txn,
      'koloni_olaylari',
      data['koloni_olaylari'] as List,
    );
    await _listeyiTabloyaYukle(
      txn,
      'koloni_numara_gecmisi',
      data['koloni_numara_gecmisi'] as List,
    );
    await _listeyiTabloyaYukle(txn, 'ayarlar', data['ayarlar'] as List);
  }

  static Future<void> _listeyiTabloyaYukle(
    DatabaseExecutor txn,
    String tablo,
    List liste,
  ) async {
    for (final item in liste) {
      if (item is! Map) {
        throw Exception('"$tablo" içinde geçersiz kayıt bulundu.');
      }

      final satir = Map<String, dynamic>.from(
        item.map((key, value) => MapEntry(key.toString(), value)),
      );

      await txn.insert(
        tablo,
        satir,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<void> _sqliteSayaclariniSifirla(DatabaseExecutor txn) async {
    await txn.rawDelete(
      'DELETE FROM sqlite_sequence WHERE name IN (?, ?, ?, ?, ?)',
      [
        'ariliklar',
        'koloniler',
        'muayeneler',
        'koloni_olaylari',
        'koloni_numara_gecmisi',
      ],
    );
  }

  static Map<String, dynamic> _satiriMapeCevir(Map<String, Object?> satir) {
    return satir.map((key, value) => MapEntry(key, value));
  }

  static int _toInt(dynamic deger) {
    if (deger == null) return 0;
    if (deger is int) return deger;
    if (deger is double) return deger.round();
    return int.tryParse(deger.toString()) ?? 0;
  }
}
