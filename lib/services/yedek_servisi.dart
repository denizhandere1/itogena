import 'dart:convert';

import 'package:path/path.dart' as p;

import 'package:sqflite/sqflite.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'karar_asistan_servisi.dart';
import 'veritabani_servisi.dart';

class YedekServisi {
  static const String uygulamaAdi = 'itogena';
  static const int yedekFormatVersiyonu = 4;
  static const int veritabaniVersiyonu = 18;
  static const int schemaVersion = 2;

  static const String appVersionName = '1.0.10';
  static const int appVersionCode = 11;

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
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersionName = packageInfo.version.trim().isEmpty
        ? appVersionName
        : packageInfo.version.trim();
    final currentVersionCode =
        int.tryParse(packageInfo.buildNumber.trim()) ?? appVersionCode;

    await VeritabaniServisi.veriButunlugunuDogrula();

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
        'appVersionName': currentVersionName,
        'appVersionCode': currentVersionCode,
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

    await _metaDogrula(kok);

    final dynamic dataDynamic = kok['data'];
    if (dataDynamic is! Map<String, dynamic>) {
      throw Exception('Yedek dosyasında veri bölümü bulunamadı.');
    }

    final Map<String, dynamic> data = dataDynamic;
    _tablolariDogrula(data);

    final db = await VeritabaniServisi.db;
    await _kolonUyumlulugunuDogrula(db, data);
    _tarihButunlugunuDogrula(data);

    // Atomic restore güvenlik katmanı:
    // Ana veritabanına dokunmadan önce yedek verisi aynı şema ile
    // geçici bir SQLite veritabanına yüklenir. Bu prova başarısız olursa
    // mevcut kullanıcı verisi silinmez ve ana DB değişmeden kalır.
    await _yedegiGeciciVeritabanindaDene(db, data);

    await db.transaction((txn) async {
      await _tumVeriyiTemizle(txn);
      await _tumVeriyiYukle(txn, data);
      await _sqliteSayaclariniSifirla(txn);
    });

    await VeritabaniServisi.sistemBakimiCalistir();
    KararAsistanServisi.tumCacheTemizle();
  }

  static Future<void> _metaDogrula(Map<String, dynamic> kok) async {
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

    final packageInfo = await PackageInfo.fromPlatform();
    final currentAppVersionCode =
        int.tryParse(packageInfo.buildNumber.trim()) ?? appVersionCode;

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

    if (backupAppVersionCode > currentAppVersionCode) {
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

  static void _tarihButunlugunuDogrula(Map<String, dynamic> data) {
    final ariliklar = _liste(data, 'ariliklar');
    final koloniler = _liste(data, 'koloniler');
    final muayeneler = _liste(data, 'muayeneler');

    final arilikTarihleri = <int, DateTime>{};
    for (final arilik in ariliklar) {
      final id = _toInt(arilik['id']);
      if (id <= 0) continue;
      arilikTarihleri[id] = _tarihZorunlu(
        arilik['kurulusTarihi'],
        'Arılık başlangıç tarihi',
      );
    }

    final koloniTarihleri = <int, DateTime>{};
    final arilikEnEskiKoloni = <int, DateTime>{};
    for (final koloni in koloniler) {
      final id = _toInt(koloni['id']);
      if (id <= 0) continue;

      final arilikId = _toInt(koloni['arilikId']);
      final olusturma = _tarihZorunlu(
        koloni['olusturmaTarihi'],
        'Koloni oluşturma tarihi',
      );
      koloniTarihleri[id] = olusturma;

      final arilikTarihi = arilikTarihleri[arilikId];
      if (arilikTarihi != null && arilikTarihi.isAfter(olusturma)) {
        throw Exception(
          'Yedek veri bütünlüğü hatalı: koloni oluşturma tarihi arılık başlangıç tarihinden önce. '
          'Koloni id: $id, arılık id: $arilikId.',
        );
      }

      final mevcutEnEski = arilikEnEskiKoloni[arilikId];
      if (mevcutEnEski == null || olusturma.isBefore(mevcutEnEski)) {
        arilikEnEskiKoloni[arilikId] = olusturma;
      }
    }

    for (final entry in arilikTarihleri.entries) {
      final enEski = arilikEnEskiKoloni[entry.key];
      if (enEski != null && entry.value.isAfter(enEski)) {
        throw Exception(
          'Yedek veri bütünlüğü hatalı: arılık başlangıç tarihi, o arılıktaki en eski koloni tarihinden sonra. '
          'Arılık id: ${entry.key}.',
        );
      }
    }

    final koloniIlkMuayene = <int, DateTime>{};
    for (final muayene in muayeneler) {
      final id = _toInt(muayene['id']);
      final koloniId = _toInt(muayene['koloniId']);
      if (koloniId <= 0) {
        throw Exception(
          'Yedek veri bütünlüğü hatalı: muayene geçerli bir koloniye bağlı değil. Muayene id: $id.',
        );
      }

      final tarih = _tarihZorunlu(muayene['tarih'], 'Muayene tarihi');
      final olusturma = koloniTarihleri[koloniId];
      if (olusturma == null) {
        throw Exception(
          'Yedek veri bütünlüğü hatalı: muayenenin bağlı olduğu koloni bulunamadı. Muayene id: $id, koloni id: $koloniId.',
        );
      }
      if (olusturma.isAfter(tarih)) {
        throw Exception(
          'Yedek veri bütünlüğü hatalı: muayene tarihi koloni oluşturma tarihinden önce. '
          'Muayene id: $id, koloni id: $koloniId.',
        );
      }

      final mevcutIlk = koloniIlkMuayene[koloniId];
      if (mevcutIlk == null || tarih.isBefore(mevcutIlk)) {
        koloniIlkMuayene[koloniId] = tarih;
      }
    }

    for (final entry in koloniIlkMuayene.entries) {
      final olusturma = koloniTarihleri[entry.key];
      if (olusturma != null && olusturma.isAfter(entry.value)) {
        throw Exception(
          'Yedek veri bütünlüğü hatalı: koloni oluşturma tarihi ilk muayene tarihinden sonra. '
          'Koloni id: ${entry.key}.',
        );
      }
    }
  }

  static List<Map<String, dynamic>> _liste(
    Map<String, dynamic> data,
    String tablo,
  ) {
    final ham = data[tablo] as List;
    return ham
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(
              e.map((key, value) => MapEntry(key.toString(), value)),
            ))
        .toList(growable: false);
  }

  static DateTime _tarihZorunlu(dynamic deger, String alanAdi) {
    final ham = (deger ?? '').toString().trim();
    if (ham.isEmpty) {
      throw Exception('Yedek veri bütünlüğü hatalı: $alanAdi boş.');
    }

    final tarih = DateTime.tryParse(ham);
    if (tarih == null) {
      throw Exception(
        'Yedek veri bütünlüğü hatalı: $alanAdi geçerli değil: $ham',
      );
    }

    return DateTime(tarih.year, tarih.month, tarih.day);
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


  static Future<void> _yedegiGeciciVeritabanindaDene(
    Database kaynakDb,
    Map<String, dynamic> data,
  ) async {
    final dbKlasoru = await getDatabasesPath();
    final tempPath = p.join(
      dbKlasoru,
      'itogena_restore_preflight_${DateTime.now().millisecondsSinceEpoch}.db',
    );

    Database? tempDb;
    try {
      await databaseFactory.deleteDatabase(tempPath);

      tempDb = await openDatabase(
        tempPath,
        version: veritabaniVersiyonu,
        onCreate: (db, version) async {
          await _semaKopyala(kaynakDb, db);
        },
      );

      await tempDb.transaction((txn) async {
        await _tumVeriyiYukle(txn, data);
        await _sqliteSayaclariniSifirla(txn);
      });

      await _geciciYuklemeSayimlariniDogrula(tempDb, data);
    } catch (e) {
      throw Exception(
        'Yedek ana veritabanına uygulanmadan önce güvenlik provasından geçemedi. '
        'Mevcut veriler korunuyor. Ayrıntı: $e',
      );
    } finally {
      if (tempDb != null && tempDb.isOpen) {
        await tempDb.close();
      }
      await databaseFactory.deleteDatabase(tempPath);
    }
  }

  static Future<void> _semaKopyala(
    Database kaynakDb,
    Database hedefDb,
  ) async {
    final tablolar = await kaynakDb.rawQuery(
      "SELECT name, sql FROM sqlite_master "
      "WHERE type = 'table' AND name IN (${List.filled(_zorunluTablolar.length, '?').join(',')}) "
      "ORDER BY name ASC",
      _zorunluTablolar,
    );

    final bulunanTablolar = tablolar
        .map((e) => (e['name'] ?? '').toString())
        .where((e) => e.isNotEmpty)
        .toSet();

    for (final tablo in _zorunluTablolar) {
      if (!bulunanTablolar.contains(tablo)) {
        throw Exception('Geçici yükleme için "$tablo" tablosunun şeması bulunamadı.');
      }
    }

    for (final satir in tablolar) {
      final sql = (satir['sql'] ?? '').toString().trim();
      if (sql.isEmpty) continue;
      await hedefDb.execute(sql);
    }

    final indeksler = await kaynakDb.rawQuery(
      "SELECT sql FROM sqlite_master "
      "WHERE type = 'index' AND sql IS NOT NULL "
      "AND tbl_name IN (${List.filled(_zorunluTablolar.length, '?').join(',')})",
      _zorunluTablolar,
    );

    for (final satir in indeksler) {
      final sql = (satir['sql'] ?? '').toString().trim();
      if (sql.isEmpty) continue;
      await hedefDb.execute(sql);
    }
  }

  static Future<void> _geciciYuklemeSayimlariniDogrula(
    Database tempDb,
    Map<String, dynamic> data,
  ) async {
    for (final tablo in _zorunluTablolar) {
      final beklenen = (data[tablo] as List).length;
      final sayim = await tempDb.rawQuery('SELECT COUNT(*) AS adet FROM $tablo');
      final yuklenen = _toInt(sayim.first['adet']);
      if (beklenen != yuklenen) {
        throw Exception(
          'Geçici yükleme sayımı tutarsız. Tablo: $tablo, beklenen: $beklenen, yüklenen: $yuklenen.',
        );
      }
    }

    final koloniler = await tempDb.rawQuery(
      'SELECT COUNT(*) AS adet FROM koloniler WHERE arilikId IS NOT NULL AND arilikId NOT IN (SELECT id FROM ariliklar)',
    );
    if (_toInt(koloniler.first['adet']) > 0) {
      throw Exception('Geçici yüklemede arılığı bulunmayan koloni kaydı tespit edildi.');
    }

    final muayeneler = await tempDb.rawQuery(
      'SELECT COUNT(*) AS adet FROM muayeneler WHERE koloniId IS NULL OR koloniId NOT IN (SELECT id FROM koloniler)',
    );
    if (_toInt(muayeneler.first['adet']) > 0) {
      throw Exception('Geçici yüklemede kolonisi bulunmayan muayene kaydı tespit edildi.');
    }
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
