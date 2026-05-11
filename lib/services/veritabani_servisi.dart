import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class VeritabaniServisi {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final yol = join(await getDatabasesPath(), 'itogena_v100.db');

    return openDatabase(
      yol,
      version: 23,
      onCreate: (db, version) async {
        await _tablolariOlustur(db);
        await _guvenliMigrasyon(db);
        await _indeksleriOlustur(db);
        await _varsayilanAyarlariYukle(db);
        await _soyKimlikleriniOnar(db);
        await _tumArilikSiralariniNormalizeEtDb(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await _guvenliMigrasyon(db);
        await _indeksleriOlustur(db);
        await _varsayilanAyarlariYukle(db);
        await _soyKimlikleriniOnar(db);
        await _tumArilikSiralariniNormalizeEtDb(db);
      },
      onOpen: (db) async {
        // onOpen içinde yazma yapan işlemler çalıştırılmıyor.
        // Rapor ve analiz ekranları veritabanını salt okuma akışında da açabilmeli.
        // Varsayılan ayar yükleme, soy onarma ve sıra normalize etme gibi yazma
        // işlemleri yalnızca onCreate / onUpgrade akışında yapılır.
      },
    );
  }

  static Future<void> _tablolariOlustur(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ariliklar (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ad TEXT NOT NULL,
        konum TEXT,
        kurulusTarihi TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS koloniler (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        arilikId INTEGER,
        kovanNo TEXT,
        sistemKimlik TEXT,
        anaYili TEXT,
        kaynakTipi TEXT,
        kaynakKoloni TEXT,
        kaynakKoloniId INTEGER,
        ebeveynKoloniId INTEGER,
        kokKoloniId INTEGER,
        kaynakKovanNoSnapshot TEXT,
        anaKazanmaYontemi TEXT,
        ilkKovanNo TEXT,
        kovanNoGecmisi TEXT,
        genetik TEXT,
        rol TEXT,
        durum TEXT DEFAULT 'aktif',
        olusturmaTarihi TEXT,
        sonCita INTEGER DEFAULT 0,
        maxCitaKapasiye INTEGER DEFAULT 0,
        bal_cita INTEGER DEFAULT 0,
        skor INTEGER DEFAULT 0,
        sahaSirasi INTEGER,
        kovanTipi TEXT DEFAULT 'Langstroth',
        suruplukVarMi INTEGER DEFAULT 1,
        notMetni TEXT,
        FOREIGN KEY (arilikId) REFERENCES ariliklar (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS koloni_numara_gecmisi (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        koloniId INTEGER NOT NULL,
        kovanNo TEXT NOT NULL,
        baslangicTarihi TEXT,
        bitisTarihi TEXT,
        aktifMi INTEGER DEFAULT 1,
        FOREIGN KEY (koloniId) REFERENCES koloniler (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS koloni_olaylari (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        koloniId INTEGER NOT NULL,
        tarih TEXT,
        olayTipi TEXT NOT NULL,
        ilgiliKoloniId INTEGER,
        aciklama TEXT,
        metaJson TEXT,
        FOREIGN KEY (koloniId) REFERENCES koloniler (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS muayeneler (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        koloniId INTEGER,
        tarih TEXT,
        citaSayisi INTEGER,
        bal_cita INTEGER,
        yavruluCita INTEGER,
        yavruDuzeni TEXT,
        mizac TEXT,
        beslemeTipi TEXT,
        beslemeYapildi INTEGER DEFAULT 0,
        varroaMucadele TEXT,
        anaAriGoruldu INTEGER,
        varroaGoruldu INTEGER,
        ogulBelirtisi INTEGER,
        ogulAtti INTEGER DEFAULT 0,
        bolmeYapildi INTEGER DEFAULT 0,
        kovanSondu INTEGER DEFAULT 0,
        anaUretimGirisimVarMi INTEGER DEFAULT 0,
        anasizBirakildiMi INTEGER DEFAULT 0,
        anasizBaslangicTarihi TEXT,
        larvaYasiGun INTEGER,
        memeDurumu TEXT,
        erkekAriDurumu TEXT,
        ciftlesmeDurumu TEXT,
        anaDegisimPlanlandiMi INTEGER DEFAULT 0,
        suruplukKaldirildiMi INTEGER DEFAULT 0,
        suruplukKaldirmaManuelMi INTEGER DEFAULT 0,
        eklenenPetekTipi TEXT,
        eklenenTemelPetek INTEGER DEFAULT 0,
        eklenenKabarmisPetek INTEGER DEFAULT 0,
        notlar TEXT,
        FOREIGN KEY (koloniId) REFERENCES koloniler (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ayarlar (
        anahtar TEXT PRIMARY KEY,
        deger TEXT
      )
    ''');
  }

  static Future<void> _guvenliMigrasyon(Database db) async {
    await _kolonEkleYoksa(db, 'ariliklar', 'kurulusTarihi', 'TEXT');

    await _kolonEkleYoksa(db, 'koloniler', 'arilikId', 'INTEGER');
    await _kolonEkleYoksa(db, 'koloniler', 'sistemKimlik', 'TEXT');
    await _kolonEkleYoksa(db, 'koloniler', 'anaYili', 'TEXT');
    await _kolonEkleYoksa(db, 'koloniler', 'kaynakTipi', 'TEXT');
    await _kolonEkleYoksa(db, 'koloniler', 'kaynakKoloni', 'TEXT');
    await _kolonEkleYoksa(db, 'koloniler', 'kaynakKoloniId', 'INTEGER');
    await _kolonEkleYoksa(db, 'koloniler', 'ebeveynKoloniId', 'INTEGER');
    await _kolonEkleYoksa(db, 'koloniler', 'kokKoloniId', 'INTEGER');
    await _kolonEkleYoksa(db, 'koloniler', 'kaynakKovanNoSnapshot', 'TEXT');
    await _kolonEkleYoksa(db, 'koloniler', 'anaKazanmaYontemi', 'TEXT');
    await _kolonEkleYoksa(db, 'koloniler', 'ilkKovanNo', 'TEXT');
    await _kolonEkleYoksa(db, 'koloniler', 'kovanNoGecmisi', 'TEXT');
    await _kolonEkleYoksa(db, 'koloniler', 'genetik', 'TEXT');
    await _kolonEkleYoksa(db, 'koloniler', 'rol', 'TEXT');
    await _kolonEkleYoksa(db, 'koloniler', 'durum', "TEXT DEFAULT 'aktif'");
    await _kolonEkleYoksa(db, 'koloniler', 'olusturmaTarihi', 'TEXT');
    await _kolonEkleYoksa(db, 'koloniler', 'sonCita', 'INTEGER DEFAULT 0');
    await _kolonEkleYoksa(
      db,
      'koloniler',
      'maxCitaKapasiye',
      'INTEGER DEFAULT 0',
    );
    await _kolonEkleYoksa(db, 'koloniler', 'bal_cita', 'INTEGER DEFAULT 0');
    await _kolonEkleYoksa(db, 'koloniler', 'skor', 'INTEGER DEFAULT 0');
    await _kolonEkleYoksa(db, 'koloniler', 'sahaSirasi', 'INTEGER');
    await _kolonEkleYoksa(db, 'koloniler', 'kovanTipi', "TEXT DEFAULT 'Langstroth'");
    await _kolonEkleYoksa(db, 'koloniler', 'suruplukVarMi', 'INTEGER DEFAULT 1');
    await _kolonEkleYoksa(db, 'koloniler', 'notMetni', 'TEXT');

    await _kolonEkleYoksa(db, 'muayeneler', 'yavruluCita', 'INTEGER');
    await _kolonEkleYoksa(db, 'muayeneler', 'yavruDuzeni', 'TEXT');
    await _kolonEkleYoksa(db, 'muayeneler', 'mizac', 'TEXT');
    await _kolonEkleYoksa(db, 'muayeneler', 'beslemeTipi', 'TEXT');
    await _kolonEkleYoksa(
      db,
      'muayeneler',
      'beslemeYapildi',
      'INTEGER DEFAULT 0',
    );
    await _kolonEkleYoksa(db, 'muayeneler', 'varroaMucadele', 'TEXT');
    await _kolonEkleYoksa(db, 'muayeneler', 'anaAriGoruldu', 'INTEGER');
    await _kolonEkleYoksa(db, 'muayeneler', 'varroaGoruldu', 'INTEGER');
    await _kolonEkleYoksa(db, 'muayeneler', 'ogulBelirtisi', 'INTEGER');
    await _kolonEkleYoksa(db, 'muayeneler', 'ogulAtti', 'INTEGER DEFAULT 0');
    await _kolonEkleYoksa(
      db,
      'muayeneler',
      'bolmeYapildi',
      'INTEGER DEFAULT 0',
    );
    await _kolonEkleYoksa(
      db,
      'muayeneler',
      'kovanSondu',
      'INTEGER DEFAULT 0',
    );
    await _kolonEkleYoksa(
      db,
      'muayeneler',
      'anaUretimGirisimVarMi',
      'INTEGER DEFAULT 0',
    );
    await _kolonEkleYoksa(
      db,
      'muayeneler',
      'anasizBirakildiMi',
      'INTEGER DEFAULT 0',
    );
    await _kolonEkleYoksa(db, 'muayeneler', 'anasizBaslangicTarihi', 'TEXT');
    await _kolonEkleYoksa(db, 'muayeneler', 'anaKazanmaYontemi', 'TEXT');
    await _kolonEkleYoksa(db, 'muayeneler', 'larvaYasiGun', 'INTEGER');
    await _kolonEkleYoksa(db, 'muayeneler', 'memeDurumu', 'TEXT');
    await _kolonEkleYoksa(db, 'muayeneler', 'erkekAriDurumu', 'TEXT');
    await _kolonEkleYoksa(db, 'muayeneler', 'ciftlesmeDurumu', 'TEXT');
    await _kolonEkleYoksa(
      db,
      'muayeneler',
      'anaDegisimPlanlandiMi',
      'INTEGER DEFAULT 0',
    );
    await _kolonEkleYoksa(
      db,
      'muayeneler',
      'kapaliYavruluCitaAktarildi',
      'INTEGER DEFAULT 0',
    );
    await _kolonEkleYoksa(
      db,
      'muayeneler',
      'disaridanHazirAnaVerildi',
      'INTEGER DEFAULT 0',
    );
    await _kolonEkleYoksa(
      db,
      'muayeneler',
      'gunlukKapaliYavruGoruldu',
      'INTEGER DEFAULT 0',
    );
    await _kolonEkleYoksa(db, 'muayeneler', 'varroaSecimleri', 'TEXT');
    await _kolonEkleYoksa(
      db,
      'muayeneler',
      'suruplukKaldirildiMi',
      'INTEGER DEFAULT 0',
    );
    await _kolonEkleYoksa(
      db,
      'muayeneler',
      'suruplukKaldirmaManuelMi',
      'INTEGER DEFAULT 0',
    );
    await _kolonEkleYoksa(db, 'muayeneler', 'eklenenPetekTipi', 'TEXT');
    await _kolonEkleYoksa(db, 'muayeneler', 'eklenenTemelPetek', 'INTEGER DEFAULT 0');
    await _kolonEkleYoksa(db, 'muayeneler', 'eklenenKabarmisPetek', 'INTEGER DEFAULT 0');
    await _kolonEkleYoksa(db, 'muayeneler', 'notlar', 'TEXT');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS koloni_numara_gecmisi (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        koloniId INTEGER NOT NULL,
        kovanNo TEXT NOT NULL,
        baslangicTarihi TEXT,
        bitisTarihi TEXT,
        aktifMi INTEGER DEFAULT 1,
        FOREIGN KEY (koloniId) REFERENCES koloniler (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS koloni_olaylari (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        koloniId INTEGER NOT NULL,
        tarih TEXT,
        olayTipi TEXT NOT NULL,
        ilgiliKoloniId INTEGER,
        aciklama TEXT,
        metaJson TEXT,
        FOREIGN KEY (koloniId) REFERENCES koloniler (id)
      )
    ''');

    // Eski sürümlerde migration nedeniyle aktif kolonilerde suruplukVarMi = 0 kalmış olabilir.
    // Bu değer her zaman fiziksel olarak şurupluk yok anlamına gelmez.
    // Aktif kolonilerde şurupluk varsayılan ekipman kabul edilir; sönmüş/pasif kolonilere dokunulmaz.
    await db.rawUpdate('''
      UPDATE koloniler
      SET suruplukVarMi = 1
      WHERE
        (suruplukVarMi IS NULL OR suruplukVarMi = 0)
        AND LOWER(COALESCE(durum, 'aktif'))
            NOT IN ('sondu','söndü','pasif')
    ''');
  }

  static Future<void> _kolonEkleYoksa(
      Database db,
      String tablo,
      String kolon,
      String tip,
      ) async {
    final varMi = await _kolonVarMi(db, tablo, kolon);
    if (!varMi) {
      await db.execute('ALTER TABLE $tablo ADD COLUMN $kolon $tip');
    }
  }

  static Future<bool> _kolonVarMi(
      Database db,
      String tablo,
      String kolon,
      ) async {
    final sonuc = await db.rawQuery("PRAGMA table_info($tablo)");
    return sonuc.any((satir) => satir['name'] == kolon);
  }

  static Future<void> _indeksleriOlustur(Database db) async {
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_koloniler_arilik_sira ON koloniler(arilikId, sahaSirasi)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_muayeneler_koloni_tarih ON muayeneler(koloniId, tarih DESC)',
    );
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_koloniler_sistem_kimlik ON koloniler(sistemKimlik)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_koloniler_kok ON koloniler(kokKoloniId)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_koloniler_ebeveyn ON koloniler(ebeveynKoloniId)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_numara_gecmisi_koloni ON koloni_numara_gecmisi(koloniId, aktifMi)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_koloni_olaylari_koloni_tarih ON koloni_olaylari(koloniId, tarih DESC)',
    );
  }

  static Future<void> _soyKimlikleriniOnar(DatabaseExecutor db) async {
    final koloniler = await db.query('koloniler', orderBy: 'id ASC');

    for (final koloni in koloniler) {
      final int id = _toInt(koloni['id']);
      final String kovanNo = (koloni['kovanNo'] ?? '').toString().trim();
      final String ilkKovanNo = (koloni['ilkKovanNo'] ?? '').toString().trim();
      final String sistemKimlik = (koloni['sistemKimlik'] ?? '').toString().trim();
      final int kaynakKoloniId = _toInt(koloni['kaynakKoloniId']);
      final int ebeveynKoloniId = _toInt(koloni['ebeveynKoloniId']);
      final int kokKoloniId = _toInt(koloni['kokKoloniId']);
      final String kaynakKoloni = (koloni['kaynakKoloni'] ?? '').toString().trim();
      final int arilikId = _toInt(koloni['arilikId']);
      final String durum = (koloni['durum'] ?? '').toString().trim();
      final String olusturmaTarihi = (koloni['olusturmaTarihi'] ?? '').toString().trim();

      final Map<String, dynamic> guncelle = {};

      if (sistemKimlik.isEmpty) {
        guncelle['sistemKimlik'] = _sistemKimlikOlustur(id);
      }

      if (ilkKovanNo.isEmpty && kovanNo.isNotEmpty) {
        guncelle['ilkKovanNo'] = kovanNo;
      }

      final String kovanNoGecmisi = (koloni['kovanNoGecmisi'] ?? '').toString().trim();
      if (kovanNoGecmisi.isEmpty && kovanNo.isNotEmpty) {
        final ilk = ilkKovanNo.isNotEmpty ? ilkKovanNo : kovanNo;
        guncelle['kovanNoGecmisi'] = ilk;
      }

      if (durum.isEmpty) {
        guncelle['durum'] = await _koloniAktifMiDb(db, id) ? 'aktif' : 'sondu';
      }

      if (olusturmaTarihi.isEmpty) {
        final ilkMuayene = await db.query(
          'muayeneler',
          where: 'koloniId = ?',
          whereArgs: [id],
          orderBy: 'tarih ASC, id ASC',
          limit: 1,
        );
        guncelle['olusturmaTarihi'] = ilkMuayene.isNotEmpty
            ? (ilkMuayene.first['tarih']?.toString() ?? _bugun())
            : _bugun();
      }

      int resolvedEbeveynId = ebeveynKoloniId > 0 ? ebeveynKoloniId : kaynakKoloniId;

      if (ebeveynKoloniId <= 0 && resolvedEbeveynId > 0) {
        guncelle['ebeveynKoloniId'] = resolvedEbeveynId;
      }

      if (kokKoloniId <= 0) {
        if (resolvedEbeveynId > 0 && resolvedEbeveynId != id) {
          final ebeveynKaydi = await db.query(
            'koloniler',
            where: 'id = ?',
            whereArgs: [resolvedEbeveynId],
            limit: 1,
          );
          if (ebeveynKaydi.isNotEmpty) {
            final ebeveynKok = _toInt(ebeveynKaydi.first['kokKoloniId']);
            guncelle['kokKoloniId'] = ebeveynKok > 0 ? ebeveynKok : resolvedEbeveynId;
          } else {
            guncelle['kokKoloniId'] = id;
          }
        } else {
          guncelle['kokKoloniId'] = id;
        }
      }

      if (guncelle.isNotEmpty) {
        await db.update(
          'koloniler',
          guncelle,
          where: 'id = ?',
          whereArgs: [id],
        );
      }

      await _numaraGecmisiKaydiniGarantiEt(
        db,
        koloniId: id,
        kovanNo: kovanNo.isNotEmpty ? kovanNo : (ilkKovanNo.isNotEmpty ? ilkKovanNo : ''),
      );
    }
  }

  static Future<Map<String, dynamic>?> _koloniBulAriliktaKovanNoIleDb(
      DatabaseExecutor db, {
        required int arilikId,
        required String kovanNo,
        int? haricKoloniId,
        bool sadeceAktifler = false,
      }) async {
    final temiz = kovanNo.trim();
    if (temiz.isEmpty || arilikId <= 0) return null;

    final adaylar = await db.query(
      'koloniler',
      where: haricKoloniId == null
          ? 'arilikId = ?'
          : 'arilikId = ? AND id != ?',
      whereArgs: haricKoloniId == null ? [arilikId] : [arilikId, haricKoloniId],
      orderBy: 'id DESC',
    );

    final arananlar = _tumNumaraVaryasyonlari(temiz);

    for (final kayit in adaylar) {
      if (sadeceAktifler) {
        final koloniId = _toInt(kayit['id']);
        final aktifMi = koloniId > 0
            ? await _koloniAktifMiDb(db, koloniId, koloniKaydi: kayit)
            : !sonmusDurumMu(kayit['durum']);
        if (!aktifMi) continue;
      }
      final aktifNo = (kayit['kovanNo'] ?? '').toString().trim();
      final ilkNo = (kayit['ilkKovanNo'] ?? '').toString().trim();

      final adayNumaralar = <String>{
        ..._tumNumaraVaryasyonlari(aktifNo),
      }..removeWhere((e) => e.trim().isEmpty);

      final eslesmeVar = adayNumaralar.any(arananlar.contains);
      if (eslesmeVar) return kayit;
    }

    return null;
  }

  static Set<String> _tumNumaraVaryasyonlari(String metin) {
    final temiz = metin.trim();
    if (temiz.isEmpty) return <String>{};

    final sonuc = <String>{temiz};

    final parensiz = temiz.replaceAll(RegExp(r'\s+'), '');
    if (parensiz.isNotEmpty) sonuc.add(parensiz);

    final eskiDeseni = RegExp(r'^(.*?)\s*\(\s*Eski\s*(.*?)\s*\)$', caseSensitive: false);
    final eslesme = eskiDeseni.firstMatch(temiz);
    if (eslesme != null) {
      final yeniNo = (eslesme.group(1) ?? '').trim();
      final eskiNo = (eslesme.group(2) ?? '').trim();
      if (yeniNo.isNotEmpty) sonuc.add(yeniNo);
      if (eskiNo.isNotEmpty) sonuc.add(eskiNo);
    }

    return sonuc;
  }


  static const Map<String, String> varsayilanAyarDegerleri = {
    'destek_max_maks_cita': '4',
    'orta_koloni_max_cita': '6',
    'guclu_koloni_min_cita': '7',
    'bolme_adayi_min_cita': '9',
    'ana_degisim_sezon_esigi': '2',
    'mudahale_min_skor': '45',
    'uretim_min_skor': '70',
    'damizlik_min_skor': '85',
    'season_kis_baslangic': '09-01',
    'season_kis_bitis': '03-15',
    'season_uretim_baslangic': '03-15',
    'season_uretim_bitis': '08-31',
    'kis_destek_max_maks_cita': '3',
    'kis_orta_koloni_max_cita': '5',
    'kis_guclu_koloni_min_cita': '6',
    'kis_bolme_adayi_min_cita': '9',
    'kis_ana_degisim_sezon_esigi': '2',
    'kis_mudahale_min_skor': '50',
    'kis_uretim_min_skor': '72',
    'kis_damizlik_min_skor': '88',
    'uretim_destek_max_maks_cita': '4',
    'uretim_orta_koloni_max_cita': '6',
    'uretim_guclu_koloni_min_cita': '7',
    'uretim_bolme_adayi_min_cita': '9',
    'uretim_ana_degisim_sezon_esigi': '2',
    'uretim_mudahale_min_skor': '45',
    'uretim_uretim_min_skor': '70',
    'uretim_damizlik_min_skor': '85',
    'kis_agirlik_gelisim': '35',
    'kis_agirlik_verim': '0',
    'kis_agirlik_saglik': '40',
    'kis_agirlik_mizac': '10',
    'kis_agirlik_yavru': '0',
    'uretim_agirlik_gelisim': '30',
    'uretim_agirlik_verim': '25',
    'uretim_agirlik_saglik': '25',
    'uretim_agirlik_mizac': '10',
    'uretim_agirlik_yavru': '10',
    'kistan_cikis_aferin_cita_min': '6',
    'kistan_cikis_aferin_skor_bonus': '5',
    'kistan_cikis_aferin_ana_yas_max': '2',
    'kistan_cikis_aferin_tarih_baslangic': '03-01',
    'kistan_cikis_aferin_tarih_bitis': '05-15',
    'davranis_toleransi': 'standart',
    'ekonomik_arili_cita': '900',
    'ekonomik_bos_kovan': '1500',
    'ekonomik_petek_sayi': '0',
    'ekonomik_petek_deger': '120',
    'ekonomik_bal_kg_fiyat': '600',
    'bal_akim1_baslangic': '05-25',
    'bal_akim1_bitis': '06-15',
    'bal_akim2_aktif': '0',
    'bal_akim2_baslangic': '08-20',
    'bal_akim2_bitis': '09-20',
    'risk_ari_kusu_baslangic': '05-01',
    'risk_ari_kusu_bitis': '08-31',
    'risk_esek_arisi_baslangic': '07-01',
    'risk_esek_arisi_bitis': '10-31',
    'risk_yagmacilik_baslangic': '07-01',
    'risk_yagmacilik_bitis': '09-30',
    'risk_mum_guvesi_baslangic': '06-01',
    'risk_mum_guvesi_bitis': '09-30',
    'risk_fare_baslangic': '11-01',
    'risk_fare_bitis': '02-28',
  };

  static String varsayilanAyarDegeri(String anahtar) {
    return varsayilanAyarDegerleri[anahtar] ?? '';
  }

  static const List<Map<String, String>> riskTakvimiTanimlari = [
    {
      'kod': 'ARI_KUSU',
      'baslik': 'Arı kuşu',
      'baslangicAnahtar': 'risk_ari_kusu_baslangic',
      'bitisAnahtar': 'risk_ari_kusu_bitis',
    },
    {
      'kod': 'ESEK_ARISI',
      'baslik': 'Eşek arısı / sarıca',
      'baslangicAnahtar': 'risk_esek_arisi_baslangic',
      'bitisAnahtar': 'risk_esek_arisi_bitis',
    },
    {
      'kod': 'YAGMACILIK',
      'baslik': 'Yağmacılık',
      'baslangicAnahtar': 'risk_yagmacilik_baslangic',
      'bitisAnahtar': 'risk_yagmacilik_bitis',
    },
    {
      'kod': 'MUM_GUVESI',
      'baslik': 'Mum güvesi',
      'baslangicAnahtar': 'risk_mum_guvesi_baslangic',
      'bitisAnahtar': 'risk_mum_guvesi_bitis',
    },
    {
      'kod': 'FARE',
      'baslik': 'Fare',
      'baslangicAnahtar': 'risk_fare_baslangic',
      'bitisAnahtar': 'risk_fare_bitis',
    },
  ];

  static Future<void> _varsayilanAyarlariYukle(Database db) async {
    for (final entry in varsayilanAyarDegerleri.entries) {
      await db.insert(
        'ayarlar',
        {'anahtar': entry.key, 'deger': entry.value},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  static Future<String> aktifSezonKoduGetir([DateTime? tarih]) async {
    final t = tarih ?? DateTime.now();

    final kisBas = await ayarStringGetir(
      'season_kis_baslangic',
      varsayilan: '09-01',
    );
    final kisBit = await ayarStringGetir(
      'season_kis_bitis',
      varsayilan: '03-15',
    );
    final uretimBas = await ayarStringGetir(
      'season_uretim_baslangic',
      varsayilan: '03-15',
    );
    final uretimBit = await ayarStringGetir(
      'season_uretim_bitis',
      varsayilan: '08-31',
    );

    if (_tarihAraliktaMi(t, kisBas, kisBit, yilTasmasi: true)) {
      return 'kis';
    }

    if (_tarihAraliktaMi(t, uretimBas, uretimBit, yilTasmasi: false)) {
      return 'uretim';
    }

    return t.month >= 3 && t.month <= 8 ? 'uretim' : 'kis';
  }

  static Future<Map<String, String>> aktifSezonBilgisiGetir([
    DateTime? tarih,
  ]) async {
    final t = tarih ?? DateTime.now();
    final sezon = await aktifSezonKoduGetir(t);

    if (sezon == 'kis') {
      return {
        'kod': 'kis',
        'ad': 'Kışlama / Dayanıklılık',
        'baslangic': await ayarStringGetir(
          'season_kis_baslangic',
          varsayilan: '09-01',
        ),
        'bitis': await ayarStringGetir(
          'season_kis_bitis',
          varsayilan: '03-15',
        ),
      };
    }

    return {
      'kod': 'uretim',
      'ad': 'Gelişim / Üretim',
      'baslangic': await ayarStringGetir(
        'season_uretim_baslangic',
        varsayilan: '03-15',
      ),
      'bitis': await ayarStringGetir(
        'season_uretim_bitis',
        varsayilan: '08-31',
      ),
    };
  }

  static bool _tarihAraliktaMi(
      DateTime tarih,
      String baslangicMmDd,
      String bitisMmDd, {
        required bool yilTasmasi,
      }) {
    final bas = _ayGunToDate(tarih.year, baslangicMmDd);
    final bit = _ayGunToDate(tarih.year, bitisMmDd);

    if (!yilTasmasi) {
      return !tarih.isBefore(bas) && !tarih.isAfter(bit);
    }

    final bitErtesiYil = _ayGunToDate(tarih.year + 1, bitisMmDd);
    final basOncekiYil = _ayGunToDate(tarih.year - 1, baslangicMmDd);

    final buYilKis = !tarih.isBefore(bas) && !tarih.isAfter(bitErtesiYil);
    final gecenYilKis = !tarih.isBefore(basOncekiYil) && !tarih.isAfter(bit);
    return buYilKis || gecenYilKis;
  }

  static DateTime _ayGunToDate(int yil, String mmDd) {
    final parcalar = mmDd.split('-');
    final ay = int.tryParse(parcalar.first) ?? 1;
    final gun = int.tryParse(parcalar.last) ?? 1;
    return DateTime(yil, ay, gun);
  }

  static Future<List<Map<String, dynamic>>> ariliklariGetir() async {
    return (await db).query('ariliklar', orderBy: 'id ASC');
  }

  static Future<Map<int, Map<String, dynamic>>> arilikOzetleriGetir() async {
    final dbClient = await db;
    final ariliklar = await dbClient.query('ariliklar', orderBy: 'id ASC');

    final Map<int, Map<String, dynamic>> sonuc = {};

    for (final arilik in ariliklar) {
      final arilikId = _toInt(arilik['id']);
      if (arilikId <= 0) continue;

      final koloniler = await dbClient.query(
        'koloniler',
        columns: ['id', 'durum', 'skor'],
        where: 'arilikId = ?',
        whereArgs: [arilikId],
      );

      final toplam = koloniler.length;
      int aktif = 0;
      int pasif = 0;
      int skorToplam = 0;

      for (final koloni in koloniler) {
        final koloniId = _toInt(koloni['id']);
        final aktifMi = koloniId > 0
            ? await _koloniAktifMiDb(dbClient, koloniId, koloniKaydi: koloni)
            : !sonmusDurumMu(koloni['durum']);

        if (aktifMi) {
          aktif++;
        } else {
          pasif++;
        }

        skorToplam += _toInt(koloni['skor']);
      }

      sonuc[arilikId] = {
        'toplam': toplam,
        'aktif': aktif,
        'pasif': pasif,
        'ortalamaSkor': toplam == 0 ? 0 : (skorToplam / toplam).round(),
      };
    }

    return sonuc;
  }

  static Future<int> arilikEkle(
    String ad, {
    String konum = '',
    String? kurulusTarihi,
  }) async {
    final dbClient = await db;
    final temizTarih = _tarihZorunluIso(
      kurulusTarihi,
      alanAdi: 'Arılık başlangıç tarihi',
      varsayilan: _bugun(),
    );

    return dbClient.transaction<int>((txn) async {
      final id = await txn.insert(
        'ariliklar',
        {
          'ad': ad.trim(),
          'konum': konum.trim(),
          'kurulusTarihi': temizTarih,
        },
      );

      await _arilikKurulusTarihiDogrulaDb(
        txn,
        arilikId: id,
        kurulusTarihi: temizTarih,
      );

      return id;
    });
  }

  static Future<int> arilikGuncelle(
    int id, {
    String? ad,
    String? konum,
    String? kurulusTarihi,
  }) async {
    if (id <= 0) return 0;

    final dbClient = await db;

    return dbClient.transaction<int>((txn) async {
      final mevcut = await txn.query(
        'ariliklar',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (mevcut.isEmpty) return 0;

      final eski = mevcut.first;
      final temizTarih = _tarihZorunluIso(
        kurulusTarihi ?? eski['kurulusTarihi'],
        alanAdi: 'Arılık başlangıç tarihi',
        varsayilan: _bugun(),
      );

      await _arilikKurulusTarihiDogrulaDb(
        txn,
        arilikId: id,
        kurulusTarihi: temizTarih,
      );

      return txn.update(
        'ariliklar',
        {
          'ad': (ad ?? eski['ad'] ?? '').toString().trim(),
          'konum': (konum ?? eski['konum'] ?? '').toString().trim(),
          'kurulusTarihi': temizTarih,
        },
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  static Future<int> arilikSil(int arilikId) async {
    if (arilikId <= 0) {
      throw Exception('Silinecek arılık bulunamadı.');
    }

    final dbClient = await db;

    return dbClient.transaction<int>((txn) async {
      final arilikKaydi = await txn.query(
        'ariliklar',
        where: 'id = ?',
        whereArgs: [arilikId],
        limit: 1,
      );

      if (arilikKaydi.isEmpty) {
        throw Exception('Silinecek arılık veritabanında bulunamadı.');
      }

      final koloniler = await txn.query(
        'koloniler',
        columns: ['id'],
        where: 'arilikId = ?',
        whereArgs: [arilikId],
      );

      final koloniIdleri = koloniler
          .map((e) => _toInt(e['id']))
          .where((id) => id > 0)
          .toList(growable: false);

      for (final parca in _idParcalari(koloniIdleri)) {
        if (parca.isEmpty) continue;
        final yerTutucular = List.filled(parca.length, '?').join(',');

        // Başka arılıklarda bu kolonilere yanlışlıkla bağlanmış kayıt varsa,
        // silinen arılıktan sonra kırık ebeveyn/kaynak referansı kalmasın.
        await txn.update(
          'koloniler',
          {'kaynakKoloniId': null, 'ebeveynKoloniId': null},
          where:
              'arilikId != ? AND (kaynakKoloniId IN ($yerTutucular) OR ebeveynKoloniId IN ($yerTutucular))',
          whereArgs: [arilikId, ...parca, ...parca],
        );

        await txn.rawUpdate(
          'UPDATE koloniler SET kokKoloniId = id WHERE arilikId != ? AND kokKoloniId IN ($yerTutucular)',
          [arilikId, ...parca],
        );

        await txn.delete(
          'muayeneler',
          where: 'koloniId IN ($yerTutucular)',
          whereArgs: parca,
        );

        await txn.delete(
          'koloni_numara_gecmisi',
          where: 'koloniId IN ($yerTutucular)',
          whereArgs: parca,
        );

        await txn.delete(
          'koloni_olaylari',
          where:
              'koloniId IN ($yerTutucular) OR ilgiliKoloniId IN ($yerTutucular)',
          whereArgs: [...parca, ...parca],
        );
      }

      await txn.delete(
        'koloniler',
        where: 'arilikId = ?',
        whereArgs: [arilikId],
      );

      await txn.delete(
        'ayarlar',
        where: 'anahtar LIKE ?',
        whereArgs: ['arilik_${arilikId}_%'],
      );

      final silinenArilik = await txn.delete(
        'ariliklar',
        where: 'id = ?',
        whereArgs: [arilikId],
      );

      await _veriButunlugunuDogrulaDb(txn);
      return silinenArilik;
    });
  }


  static Future<List<Map<String, dynamic>>> kolonileriGetir({
    bool sadeceAktifler = true,
  }) async {
    final dbClient = await db;
    final koloniler = await dbClient.query(
      'koloniler',
      orderBy: 'sahaSirasi ASC, id ASC',
    );

    if (!sadeceAktifler) return koloniler;

    final List<Map<String, dynamic>> sonuc = [];
    for (final koloni in koloniler) {
      final koloniId = _toInt(koloni['id']);
      final aktifMi = koloniId > 0
          ? await _koloniAktifMiDb(dbClient, koloniId, koloniKaydi: koloni)
          : !sonmusDurumMu(koloni['durum']);
      if (aktifMi) {
        sonuc.add(koloni);
      }
    }
    return sonuc;
  }

  static Future<List<Map<String, dynamic>>> kovanlariAriligaGoreGetir(
      int arilikId, {
        bool sadeceAktifler = false,
      }) async {
    final dbClient = await db;
    final koloniler = await dbClient.query(
      'koloniler',
      where: 'arilikId = ?',
      whereArgs: [arilikId],
      orderBy: 'sahaSirasi ASC, id ASC',
    );

    if (!sadeceAktifler) return koloniler;

    final List<Map<String, dynamic>> sonuc = [];
    for (final koloni in koloniler) {
      final koloniId = _toInt(koloni['id']);
      final aktifMi = koloniId > 0
          ? await _koloniAktifMiDb(dbClient, koloniId, koloniKaydi: koloni)
          : !sonmusDurumMu(koloni['durum']);
      if (aktifMi) {
        sonuc.add(koloni);
      }
    }
    return sonuc;
  }

  static Future<Map<String, dynamic>?> koloniBulAriliktaKovanNoIle(
      int arilikId,
      String kovanNo, {
        int? haricKoloniId,
        bool sadeceAktifler = false,
      }) async {
    return _koloniBulAriliktaKovanNoIleDb(
      await db,
      arilikId: arilikId,
      kovanNo: kovanNo,
      haricKoloniId: haricKoloniId,
      sadeceAktifler: sadeceAktifler,
    );
  }

  static Future<List<Map<String, dynamic>>> soyZinciriGetir(int koloniId) async {
    final dbClient = await db;
    final List<Map<String, dynamic>> zincir = [];

    Map<String, dynamic>? aktif = await koloniOzetiGetir(koloniId);
    if (aktif.isEmpty) return zincir;

    while (aktif != null && aktif.isNotEmpty) {
      zincir.insert(0, aktif);
      final ebeveynId = _toInt(aktif['ebeveynKoloniId']);
      final kaynakId = ebeveynId > 0 ? ebeveynId : _toInt(aktif['kaynakKoloniId']);
      if (kaynakId <= 0) break;

      final ebeveyn = await dbClient.query(
        'koloniler',
        where: 'id = ?',
        whereArgs: [kaynakId],
        limit: 1,
      );

      if (ebeveyn.isEmpty) break;
      aktif = ebeveyn.first;
    }

    return zincir;
  }

  static Future<Map<String, dynamic>> koloniHikayeOzetiGetir(int koloniId) async {
    final zincir = await soyZinciriGetir(koloniId);
    final mevcut = await koloniOzetiGetir(koloniId);

    if (mevcut.isEmpty) {
      return {
        'soyZinciriMetni': '-',
        'hikayeMetni': 'Koloni kaydı bulunamadı.',
        'kaynakGuncelNo': '-',
      };
    }

    final List<String> zincirParcalari = zincir.map((k) {
      final ilk = (k['ilkKovanNo'] ?? '').toString().trim();
      final anlik = (k['kovanNo'] ?? '').toString().trim();
      return ilk.isNotEmpty ? ilk : (anlik.isNotEmpty ? anlik : '-');
    }).toList();

    final soyZinciriMetni = zincirParcalari.isEmpty ? '-' : zincirParcalari.join(' → ');

    final String mevcutNo = (mevcut['kovanNo'] ?? '').toString().trim();
    final String ilkNo = (mevcut['ilkKovanNo'] ?? '').toString().trim();
    final String kaynakTipi = (mevcut['kaynakTipi'] ?? '').toString().trim();
    final int ebeveynId = _toInt(mevcut['ebeveynKoloniId']);
    final int kokKoloniId = _toInt(mevcut['kokKoloniId']);
    final String sistemKimlik = (mevcut['sistemKimlik'] ?? '').toString().trim();
    final String genetikHatKodu =
    kokKoloniId > 0 ? 'HAT-${kokKoloniId.toString().padLeft(4, '0')}' : '-';

    String kaynakGuncelNo = '-';
    String kaynakIlkNo = (mevcut['kaynakKovanNoSnapshot'] ?? '').toString().trim();

    if (ebeveynId > 0) {
      final ebeveyn = await koloniOzetiGetir(ebeveynId);
      if (ebeveyn.isNotEmpty) {
        kaynakGuncelNo = (ebeveyn['kovanNo'] ?? '').toString().trim();
        if (kaynakIlkNo.isEmpty) {
          kaynakIlkNo = (ebeveyn['ilkKovanNo'] ?? ebeveyn['kovanNo'] ?? '')
              .toString()
              .trim();
        }
      }
    }

    final numaraGecmisiKayitlari = await numaraGecmisiGetir(koloniId);
    final numaraGecmisiMetni = numaraGecmisiKayitlari.isEmpty
        ? ((mevcut['kovanNoGecmisi'] ?? '').toString().trim().isEmpty
        ? (mevcutNo.isEmpty ? '-' : mevcutNo)
        : (mevcut['kovanNoGecmisi'] ?? '').toString())
        : numaraGecmisiKayitlari
        .map((e) => (e['kovanNo'] ?? '').toString().trim())
        .where((e) => e.isNotEmpty)
        .join(' → ');

    final String hikayeMetni;
    if (kaynakTipi == 'Ana Hat' || ebeveynId <= 0) {
      if (ilkNo.isNotEmpty && mevcutNo.isNotEmpty && ilkNo != mevcutNo) {
        hikayeMetni =
        'Bu koloni ana hat / bağımsız soy başlangıcı olarak kaydedildi. İlk saha etiketi $ilkNo idi. Daha sonra görünen numarası $mevcutNo olarak güncellendi. Sistem kimliği değişmediği için soy hattı korunmaktadır.';
      } else {
        hikayeMetni =
        'Bu koloni ana hat / bağımsız soy başlangıcı olarak kaydedildi. Soy takibi saha numarasıyla değil, sabit sistem kimliği ile sürdürülmektedir.';
      }
    } else {
      final kaynakParcasi = kaynakIlkNo.isNotEmpty ? kaynakIlkNo : kaynakGuncelNo;
      hikayeMetni =
      'Bu koloni ${kaynakParcasi.isEmpty ? 'tanımlı bir ebeveynden' : kaynakParcasi} üzerinden $kaynakTipi olarak türedi. Ana soy hattı sistem tarafından otomatik hesaplanır; kullanıcı yalnızca saha etiketini görür.';
    }

    final kokKoloni = kokKoloniId > 0 ? await koloniOzetiGetir(kokKoloniId) : <String, dynamic>{};
    final kokNo = kokKoloni.isNotEmpty
        ? ((kokKoloni['ilkKovanNo'] ?? kokKoloni['kovanNo'] ?? '-').toString())
        : '-';

    return {
      'soyZinciriMetni': soyZinciriMetni,
      'hikayeMetni': hikayeMetni,
      'kaynakGuncelNo': kaynakGuncelNo,
      'mevcutNo': mevcutNo,
      'ilkNo': ilkNo,
      'numaraGecmisiMetni': numaraGecmisiMetni,
      'sistemKimlik': sistemKimlik,
      'kokKoloniId': kokKoloniId,
      'kokNo': kokNo,
      'genetikHatKodu': genetikHatKodu,
      'ebeveynKoloniId': ebeveynId,
      'kaynakTipi': kaynakTipi,
    };
  }


  static Future<Set<int>> ogulAttanKoloniIdleriniGetir() async {
    final dbClient = await db;
    final rows = await dbClient.rawQuery(
      'SELECT DISTINCT koloniId FROM muayeneler WHERE IFNULL(ogulAtti, 0) = 1',
    );
    return rows
        .map((e) => _toInt(e['koloniId']))
        .where((e) => e > 0)
        .toSet();
  }

  static Future<Map<String, dynamic>> ogulRiskOzetiGetir(int koloniId) async {
    final tumKoloniler = await kolonileriGetir(sadeceAktifler: false);
    if (tumKoloniler.isEmpty) {
      return {
        'dogrudanOgulKokenli': false,
        'kendisiOgulAtti': false,
        'ataHattaOgulAtti': false,
        'ogulRiskiTasir': false,
        'ebeveynOgulAtti': false,
        'kokOgulAtti': false,
        'riskKaynakKoloniIdleri': <int>[],
      };
    }

    final byId = <int, Map<String, dynamic>>{
      for (final k in tumKoloniler) _toInt(k['id']): k,
    };

    final aktif = byId[koloniId] ?? await koloniOzetiGetir(koloniId);
    if (aktif.isEmpty) {
      return {
        'dogrudanOgulKokenli': false,
        'kendisiOgulAtti': false,
        'ataHattaOgulAtti': false,
        'ogulRiskiTasir': false,
        'ebeveynOgulAtti': false,
        'kokOgulAtti': false,
        'riskKaynakKoloniIdleri': <int>[],
      };
    }

    final ogulAtanIdler = await ogulAttanKoloniIdleriniGetir();
    final bool dogrudanOgulKokenli = _kaynakTipiOgulMu(
      (aktif['kaynakTipi'] ?? '').toString(),
    );
    final bool kendisiOgulAtti = ogulAtanIdler.contains(koloniId);

    final List<int> atalar = [];
    final Set<int> ziyaret = <int>{};
    int ebeveynId = _toInt(aktif['ebeveynKoloniId'] ?? aktif['kaynakKoloniId']);
    while (ebeveynId > 0 && !ziyaret.contains(ebeveynId)) {
      ziyaret.add(ebeveynId);
      atalar.add(ebeveynId);
      final ebeveyn = byId[ebeveynId] ?? await koloniOzetiGetir(ebeveynId);
      if (ebeveyn.isEmpty) break;
      ebeveynId = _toInt(ebeveyn['ebeveynKoloniId'] ?? ebeveyn['kaynakKoloniId']);
    }

    final riskKaynakKoloniIdleri = atalar.where(ogulAtanIdler.contains).toList();
    final bool ebeveynOgulAtti = riskKaynakKoloniIdleri.isNotEmpty && atalar.isNotEmpty && riskKaynakKoloniIdleri.first == atalar.first;
    final int kokKoloniId = _toInt(aktif['kokKoloniId']);
    final bool kokOgulAtti = kokKoloniId > 0 && ogulAtanIdler.contains(kokKoloniId);
    final bool ataHattaOgulAtti = riskKaynakKoloniIdleri.isNotEmpty;
    final bool ogulRiskiTasir = dogrudanOgulKokenli || kendisiOgulAtti || ataHattaOgulAtti;

    return {
      'dogrudanOgulKokenli': dogrudanOgulKokenli,
      'kendisiOgulAtti': kendisiOgulAtti,
      'ataHattaOgulAtti': ataHattaOgulAtti,
      'ogulRiskiTasir': ogulRiskiTasir,
      'ebeveynOgulAtti': ebeveynOgulAtti,
      'kokOgulAtti': kokOgulAtti,
      'riskKaynakKoloniIdleri': riskKaynakKoloniIdleri,
    };
  }

  static Future<Map<String, dynamic>> hatSonmeAnaliziGetir(int koloniId) async {
    final tumKoloniler = await kolonileriGetir(sadeceAktifler: false);
    if (tumKoloniler.isEmpty) {
      return _bosHatSonmeOzeti();
    }

    final byId = <int, Map<String, dynamic>>{};
    for (final koloni in tumKoloniler) {
      byId[_toInt(koloni['id'])] = koloni;
    }

    Map<String, dynamic>? aktif = byId[koloniId] ?? await koloniOzetiGetir(koloniId);
    if (aktif == null || aktif.isEmpty) {
      return _bosHatSonmeOzeti();
    }

    while (aktif != null && aktif.isNotEmpty) {
      final kaynakId = _toInt(aktif['kaynakKoloniId']);
      if (kaynakId <= 0 || !byId.containsKey(kaynakId)) break;
      aktif = byId[kaynakId];
    }

    if (aktif == null || aktif.isEmpty) {
      return _bosHatSonmeOzeti();
    }

    final kokId = _toInt(aktif['id']);
    final kokNo = (aktif['ilkKovanNo'] ?? aktif['kovanNo'] ?? '').toString().trim();

    final tumHat = <Map<String, dynamic>>[];
    final ziyaret = <int>{};

    void ekleAltHat(Map<String, dynamic> ebeveyn) {
      final ebeveynId = _toInt(ebeveyn['id']);
      if (ebeveynId <= 0 || ziyaret.contains(ebeveynId)) return;
      ziyaret.add(ebeveynId);
      tumHat.add(ebeveyn);

      final ebeveynKovanNo = (ebeveyn['kovanNo'] ?? '').toString().trim();
      final ebeveynIlkNo = (ebeveyn['ilkKovanNo'] ?? '').toString().trim();

      for (final aday in tumKoloniler) {
        final adayId = _toInt(aday['id']);
        if (ziyaret.contains(adayId)) continue;

        final kaynakId = _toInt(aday['kaynakKoloniId']);
        final kaynakNo = (aday['kaynakKoloni'] ?? '').toString().trim();

        final idBag = kaynakId > 0 && kaynakId == ebeveynId;
        final metinBag = kaynakId <= 0 && kaynakNo.isNotEmpty && (
            kaynakNo == ebeveynKovanNo ||
                (ebeveynIlkNo.isNotEmpty && kaynakNo == ebeveynIlkNo)
        );

        if (idBag || metinBag) {
          ekleAltHat(aday);
        }
      }
    }

    ekleAltHat(aktif);

    final idler = tumHat.map((e) => _toInt(e['id'])).where((e) => e > 0).toList();
    final sonMuayeneMap = await _koloniSonMuayeneMapGetir(idler);

    int sonenToplam = 0;
    int sonenTureyen = 0;
    final List<String> sonenNumaralar = [];

    for (final koloni in tumHat) {
      final id = _toInt(koloni['id']);
      final son = sonMuayeneMap[id];
      final sonmus = son != null && _toInt(son['kovanSondu']) == 1;
      if (!sonmus) continue;

      sonenToplam++;
      final kovanNo = (koloni['kovanNo'] ?? '').toString().trim();
      sonenNumaralar.add(kovanNo.isEmpty ? '#$id' : kovanNo);
      if (id != kokId) {
        sonenTureyen++;
      }
    }

    final tureyen = tumHat.where((e) => _toInt(e['id']) != kokId).length;
    final aktifToplam = tumHat.length - sonenToplam;
    final double sonmeOrani = tureyen <= 0
        ? (sonenToplam > 0 ? 100.0 : 0.0)
        : (sonenTureyen / tureyen) * 100.0;

    String seviye = 'Temiz';
    String aciklama = 'Bu hatta tekrar eden sönme görülmüyor.';
    int etkiPuani = 0;

    if (sonenTureyen >= 3 || (sonenTureyen >= 2 && sonmeOrani >= 50)) {
      seviye = 'Ciddi Risk';
      aciklama =
      'Bu hatta tekrar eden sönmeler belirginleşmiş. Sayı ve oran birlikte okunduğunda seçilim açısından güçlü bir risk sinyali oluşuyor.';
      etkiPuani = 30;
    } else if (sonenTureyen >= 2) {
      seviye = 'Risk';
      aciklama =
      'Bu hatta birden fazla sönme kaydı var. Tekil olay sınırı aşılmış görünüyor; hat dikkatle izlenmeli.';
      etkiPuani = 18;
    } else if (sonenTureyen == 1) {
      seviye = 'Uyarı';
      aciklama =
      'Bu hatta ilk sönme kaydı görülüyor. Tek başına hüküm verdirmez; ancak izleme notu olarak önemlidir.';
      etkiPuani = 8;
    }

    return {
      'kokKoloniId': kokId,
      'kokKovanNo': kokNo,
      'hatToplamKoloni': tumHat.length,
      'tureyenKoloni': tureyen,
      'sonenToplam': sonenToplam,
      'sonenTureyen': sonenTureyen,
      'aktifToplam': aktifToplam,
      'sonmeOrani': sonmeOrani,
      'riskSeviyesi': seviye,
      'aciklama': aciklama,
      'etkiPuani': etkiPuani,
      'sonenNumaralar': sonenNumaralar,
    };
  }

  static Future<Map<int, Map<String, dynamic>>> _koloniSonMuayeneMapGetir(
      List<int> koloniIdleri,
      ) async {
    final sonuc = <int, Map<String, dynamic>>{};
    if (koloniIdleri.isEmpty) return sonuc;

    final dbClient = await db;
    final placeholders = List.filled(koloniIdleri.length, '?').join(',');
    final muayeneler = await dbClient.query(
      'muayeneler',
      where: 'koloniId IN ($placeholders)',
      whereArgs: koloniIdleri,
      orderBy: 'tarih DESC, id DESC',
    );

    for (final muayene in muayeneler) {
      final koloniId = _toInt(muayene['koloniId']);
      sonuc.putIfAbsent(koloniId, () => muayene);
    }

    return sonuc;
  }

  static Map<String, dynamic> _bosHatSonmeOzeti() {
    return {
      'kokKoloniId': 0,
      'kokKovanNo': '-',
      'hatToplamKoloni': 0,
      'tureyenKoloni': 0,
      'sonenToplam': 0,
      'sonenTureyen': 0,
      'aktifToplam': 0,
      'sonmeOrani': 0.0,
      'riskSeviyesi': 'Veri Yok',
      'aciklama': 'Hat düzeyi sönme analizi için yeterli veri bulunmuyor.',
      'etkiPuani': 0,
      'sonenNumaralar': <String>[],
    };
  }



  static String _kaynakTipiNormalize(dynamic deger) {
    final ham = (deger ?? '').toString().trim();
    if (ham.isEmpty) return '';

    final k = ham
        .toLowerCase()
        .replaceAll('ı', 'i')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ş', 's')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c');

    if (k == 'ana hat' || k == 'anahat') return 'Ana Hat';
    if (k == 'bolme') return 'Bölme';
    if (k == 'ogul' || k == 'ogul (kaynak bilinmiyor)') return 'Oğul';
    if (k == 'dis kaynak' || k == 'satin alma' || k == 'paket ari') {
      return 'Dış Kaynak';
    }

    return ham;
  }

  static Future<int> _arilikMaksSiraGetirTx(DatabaseExecutor exec, int arilikId) async {
    if (arilikId <= 0) return 0;
    final sonuc = await exec.rawQuery(
      "SELECT COALESCE(MAX(sahaSirasi), 0) AS maks FROM koloniler WHERE arilikId = ? AND LOWER(COALESCE(durum, 'aktif')) NOT IN ('sondu', 'söndü', 'pasif')",
      [arilikId],
    );
    return _toInt(sonuc.first['maks']);
  }

  static Future<void> _sirayaYerAcTx(
      DatabaseExecutor exec, {
        required int arilikId,
        required int hedefSira,
        int? haricKoloniId,
      }) async {
    if (arilikId <= 0 || hedefSira <= 0) return;

    final where = haricKoloniId == null
        ? "arilikId = ? AND sahaSirasi >= ? AND LOWER(COALESCE(durum, 'aktif')) NOT IN ('sondu', 'söndü', 'pasif')"
        : "arilikId = ? AND sahaSirasi >= ? AND id != ? AND LOWER(COALESCE(durum, 'aktif')) NOT IN ('sondu', 'söndü', 'pasif')";
    final args = haricKoloniId == null
        ? [arilikId, hedefSira]
        : [arilikId, hedefSira, haricKoloniId];

    await exec.rawUpdate(
      'UPDATE koloniler SET sahaSirasi = COALESCE(sahaSirasi, 0) + 1 WHERE $where',
      args,
    );
  }

  static Future<void> _sirayiSikistirTx(
      DatabaseExecutor exec, {
        required int arilikId,
        required int baslangicSira,
        int? haricKoloniId,
      }) async {
    if (arilikId <= 0 || baslangicSira <= 0) return;

    final where = haricKoloniId == null
        ? "arilikId = ? AND sahaSirasi > ? AND LOWER(COALESCE(durum, 'aktif')) NOT IN ('sondu', 'söndü', 'pasif')"
        : "arilikId = ? AND sahaSirasi > ? AND id != ? AND LOWER(COALESCE(durum, 'aktif')) NOT IN ('sondu', 'söndü', 'pasif')";
    final args = haricKoloniId == null
        ? [arilikId, baslangicSira]
        : [arilikId, baslangicSira, haricKoloniId];

    await exec.rawUpdate(
      'UPDATE koloniler SET sahaSirasi = CASE WHEN COALESCE(sahaSirasi, 0) > 1 THEN sahaSirasi - 1 ELSE 1 END WHERE $where',
      args,
    );
  }

  static Future<int> _hedefSiraBelirleTx(
      DatabaseExecutor exec, {
        required int arilikId,
        required int istenenSira,
        int? haricKoloniId,
      }) async {
    final maks = await _arilikMaksSiraGetirTx(exec, arilikId);
    if (istenenSira <= 0) return maks + 1;

    var ustSinir = maks + 1;
    if (haricKoloniId != null && haricKoloniId > 0) {
      ustSinir = maks;
    }
    if (ustSinir <= 0) ustSinir = 1;

    if (istenenSira < 1) return 1;
    if (istenenSira > ustSinir) return ustSinir;
    return istenenSira;
  }

  static Future<void> _arilikSiralariniNormalizeEtDb(
      DatabaseExecutor exec, {
        required int arilikId,
      }) async {
    if (arilikId <= 0) return;

    final kayitlar = await exec.query(
      'koloniler',
      where: "arilikId = ? AND LOWER(COALESCE(durum, 'aktif')) NOT IN ('sondu', 'söndü', 'pasif')",
      whereArgs: [arilikId],
      orderBy: 'CASE WHEN COALESCE(sahaSirasi, 0) <= 0 THEN 1 ELSE 0 END ASC, sahaSirasi ASC, id ASC',
    );

    var sira = 1;
    for (final kayit in kayitlar) {
      final id = _toInt(kayit['id']);
      if (id <= 0) continue;
      final mevcut = _toInt(kayit['sahaSirasi']);
      if (mevcut != sira) {
        await exec.update(
          'koloniler',
          {'sahaSirasi': sira},
          where: 'id = ?',
          whereArgs: [id],
        );
      }
      sira++;
    }
  }

  static Future<void> _tumArilikSiralariniNormalizeEtDb(DatabaseExecutor exec) async {
    final ariliklar = await exec.query('ariliklar');
    for (final arilik in ariliklar) {
      final arilikId = _toInt(arilik['id']);
      if (arilikId > 0) {
        await _arilikSiralariniNormalizeEtDb(exec, arilikId: arilikId);
      }
    }
  }

  static bool sonmusDurumMu(dynamic durumDegeri) {
    final durum = (durumDegeri ?? '').toString().trim().toLowerCase();
    return durum == 'sondu' || durum == 'söndü' || durum == 'pasif';
  }

  static String _kovanTipiNormalize(dynamic deger) {
    final temiz = (deger ?? '').toString().trim().toLowerCase();
    if (temiz.contains('dadant')) return 'Dadant';
    return 'Langstroth';
  }

  static int _toBoolInt(dynamic deger) {
    if (deger == true) return 1;
    if (deger is int) return deger == 1 ? 1 : 0;
    final temiz = (deger ?? '').toString().trim().toLowerCase();
    return temiz == '1' || temiz == 'true' || temiz == 'evet' || temiz == 'var' ? 1 : 0;
  }

  static Future<int> koloniEkle(Map<String, dynamic> veri) async {
    final dbClient = await db;

    final int id = await dbClient.transaction<int>((txn) async {
      final kayit = Map<String, dynamic>.from(veri);

      final kovanNo = (kayit['kovanNo'] ?? '').toString().trim();
      final kaynakTipi = _kaynakTipiNormalize(kayit['kaynakTipi']);
      kayit['kaynakTipi'] = kaynakTipi;

      final int arilikId = _toInt(kayit['arilikId']);
      final int ebeveynKoloniId =
      _toInt(kayit['ebeveynKoloniId'] ?? kayit['kaynakKoloniId']);

      if (arilikId > 0 && kovanNo.isNotEmpty) {
        final cakisanAktif = await _koloniBulAriliktaKovanNoIleDb(
          txn,
          arilikId: arilikId,
          kovanNo: kovanNo,
          sadeceAktifler: true,
        );
        if (cakisanAktif != null) {
          final cakisanNo = (cakisanAktif['kovanNo'] ?? '').toString().trim();
          throw Exception(
            'Bu numara arılıkta aktif bir koloni tarafından kullanılıyor: $cakisanNo',
          );
        }
      }

      if (arilikId > 0) {
        await _arilikSiralariniNormalizeEtDb(txn, arilikId: arilikId);
      }

      if (((kayit['ilkKovanNo'] ?? '').toString().trim()).isEmpty &&
          kovanNo.isNotEmpty) {
        kayit['ilkKovanNo'] = kovanNo;
      }
      if (((kayit['kovanNoGecmisi'] ?? '').toString().trim()).isEmpty &&
          kovanNo.isNotEmpty) {
        kayit['kovanNoGecmisi'] = kovanNo;
      }

      if (kaynakTipi == 'Ana Hat') {
        kayit['kaynakKoloni'] = '-';
        kayit['kaynakKoloniId'] = null;
        kayit['kaynakKovanNoSnapshot'] = null;
      } else if (kaynakTipi == 'Dış Kaynak') {
        kayit['kaynakKoloni'] = 'Dış Kaynak';
        kayit['kaynakKoloniId'] = null;
        kayit['kaynakKovanNoSnapshot'] = null;
      }

      kayit['ebeveynKoloniId'] = ebeveynKoloniId > 0 ? ebeveynKoloniId : null;
      kayit['durum'] = ((kayit['durum'] ?? '').toString().trim().isEmpty)
          ? 'aktif'
          : kayit['durum'];
      kayit['kovanTipi'] = _kovanTipiNormalize(kayit['kovanTipi']);
      kayit['suruplukVarMi'] = _toBoolInt(kayit['suruplukVarMi']);

      kayit['olusturmaTarihi'] = _tarihZorunluIso(
        kayit['olusturmaTarihi'],
        alanAdi: 'Koloni oluşturma tarihi',
        varsayilan: _bugun(),
      );

      await _koloniTarihiniDogrulaDb(
        txn,
        koloniId: 0,
        arilikId: arilikId,
        olusturmaTarihi: kayit['olusturmaTarihi'].toString(),
      );

      final istenenSira = _toInt(kayit['sahaSirasi']);
      final hedefSira = await _hedefSiraBelirleTx(
        txn,
        arilikId: arilikId,
        istenenSira: istenenSira,
      );

      if (arilikId > 0) {
        await _sirayaYerAcTx(txn, arilikId: arilikId, hedefSira: hedefSira);
      }
      kayit['sahaSirasi'] = hedefSira;

      final id = await txn.insert('koloniler', kayit);

      String? sistemKimlik = (kayit['sistemKimlik'] ?? '').toString().trim();
      if (sistemKimlik.isEmpty) {
        sistemKimlik = _sistemKimlikOlustur(id);
      }

      int kokKoloniId = _toInt(kayit['kokKoloniId']);
      if (kokKoloniId <= 0) {
        if (ebeveynKoloniId > 0) {
          int ebeveynKok = 0;
          final ebeveynKaydi = await txn.query(
            'koloniler',
            where: 'id = ?',
            whereArgs: [ebeveynKoloniId],
            limit: 1,
          );
          if (ebeveynKaydi.isNotEmpty) {
            ebeveynKok = _toInt(ebeveynKaydi.first['kokKoloniId']);
          }
          kokKoloniId = ebeveynKok > 0 ? ebeveynKok : ebeveynKoloniId;
        } else if (kaynakTipi == 'Ana Hat' ||
            kaynakTipi == 'Dış Kaynak' ||
            ebeveynKoloniId <= 0) {
          kokKoloniId = id;
        }
      }

      await txn.update(
        'koloniler',
        {
          'sistemKimlik': sistemKimlik,
          'kokKoloniId': kokKoloniId > 0 ? kokKoloniId : id,
          'ebeveynKoloniId': ebeveynKoloniId > 0 ? ebeveynKoloniId : null,
        },
        where: 'id = ?',
        whereArgs: [id],
      );

      if (kovanNo.isNotEmpty) {
        await _numaraGecmisiKaydiniGarantiEt(txn, koloniId: id, kovanNo: kovanNo);
      }

      final olayTipi = _olayTipiUret(kaynakTipi);
      await _koloniOlayiEkle(
        txn,
        koloniId: id,
        olayTipi: olayTipi,
        ilgiliKoloniId: ebeveynKoloniId > 0 ? ebeveynKoloniId : null,
        aciklama: olayTipi == 'OLUSUM_ANA_HAT'
            ? 'Koloni ana hat / bağımsız başlangıç olarak oluşturuldu.'
            : 'Koloni $kaynakTipi olarak oluşturuldu.',
        tarih: (kayit['olusturmaTarihi'] ?? _bugun()).toString(),
      );

      await _ilkMuayeneKaydiniGarantiEt(
        txn,
        koloniId: id,
        olusturmaTarihi: (kayit['olusturmaTarihi'] ?? _bugun()).toString(),
        ilkToplamCita: _toInt(kayit['sonCita']),
        ilkBalCita: _toInt(kayit['bal_cita']),
        notMetni: (kayit['notMetni'] ?? '').toString(),
      );

      // await _soyKimlikleriniOnar(txn);
      if (arilikId > 0) {
        await _arilikSiralariniNormalizeEtDb(txn, arilikId: arilikId);
      }
      return id;
    });

    if (id > 0) {
      await skorHesaplaVeGuncelle(id);
    }

    return id;
  }

  static Future<int> koloniGuncelle(int id, Map<String, dynamic> veri) async {
    final dbClient = await db;

    return dbClient.transaction<int>((txn) async {
      final mevcut = await txn.query(
        'koloniler',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (mevcut.isEmpty) return 0;

      final eski = mevcut.first;
      final yeniKovanNo =
      (veri['kovanNo'] ?? eski['kovanNo'] ?? '').toString().trim();
      final eskiKovanNo = (eski['kovanNo'] ?? '').toString().trim();

      final eskiArilikId = _toInt(eski['arilikId']);
      final yeniArilikId = _toInt(veri['arilikId'] ?? eski['arilikId']);
      final eskiSira = _toInt(eski['sahaSirasi']);
      final istenenSira = _toInt(veri['sahaSirasi'] ?? eski['sahaSirasi']);
      final yeniKaynakTipi = _kaynakTipiNormalize(
        veri['kaynakTipi'] ?? eski['kaynakTipi'],
      );
      final yeniOlusturmaTarihi = _tarihZorunluIso(
        veri['olusturmaTarihi'] ?? eski['olusturmaTarihi'],
        alanAdi: 'Koloni oluşturma tarihi',
        varsayilan: _bugun(),
      );

      await _koloniTarihiniDogrulaDb(
        txn,
        koloniId: id,
        arilikId: yeniArilikId,
        olusturmaTarihi: yeniOlusturmaTarihi,
      );

      if (yeniArilikId > 0 && yeniKovanNo.isNotEmpty) {
        final cakisanAktif = await _koloniBulAriliktaKovanNoIleDb(
          txn,
          arilikId: yeniArilikId,
          kovanNo: yeniKovanNo,
          haricKoloniId: id,
          sadeceAktifler: true,
        );
        if (cakisanAktif != null) {
          final cakisanNo = (cakisanAktif['kovanNo'] ?? '').toString().trim();
          throw Exception(
            'Bu numara arılıkta aktif bir koloni tarafından kullanılıyor: $cakisanNo',
          );
        }
      }

      if (eskiArilikId > 0) {
        await _arilikSiralariniNormalizeEtDb(txn, arilikId: eskiArilikId);
      }
      if (yeniArilikId > 0 && yeniArilikId != eskiArilikId) {
        await _arilikSiralariniNormalizeEtDb(txn, arilikId: yeniArilikId);
      }

      final hedefSira = await _hedefSiraBelirleTx(
        txn,
        arilikId: yeniArilikId,
        istenenSira: istenenSira,
        haricKoloniId: id,
      );

      if (eskiArilikId != yeniArilikId) {
        if (eskiArilikId > 0 && eskiSira > 0) {
          await _sirayiSikistirTx(
            txn,
            arilikId: eskiArilikId,
            baslangicSira: eskiSira,
            haricKoloniId: id,
          );
        }
        if (yeniArilikId > 0) {
          await _sirayaYerAcTx(
            txn,
            arilikId: yeniArilikId,
            hedefSira: hedefSira,
            haricKoloniId: id,
          );
        }
      } else if (hedefSira != eskiSira && yeniArilikId > 0) {
        if (hedefSira < eskiSira) {
          await txn.rawUpdate(
            '''
            UPDATE koloniler
            SET sahaSirasi = COALESCE(sahaSirasi, 0) + 1
            WHERE arilikId = ? AND id != ? AND sahaSirasi >= ? AND sahaSirasi < ?
              AND LOWER(COALESCE(durum, 'aktif')) NOT IN ('sondu', 'söndü', 'pasif')
            ''',
            [yeniArilikId, id, hedefSira, eskiSira],
          );
        } else {
          await txn.rawUpdate(
            '''
            UPDATE koloniler
            SET sahaSirasi = CASE WHEN COALESCE(sahaSirasi, 0) > 1 THEN sahaSirasi - 1 ELSE 1 END
            WHERE arilikId = ? AND id != ? AND sahaSirasi <= ? AND sahaSirasi > ?
              AND LOWER(COALESCE(durum, 'aktif')) NOT IN ('sondu', 'söndü', 'pasif')
            ''',
            [yeniArilikId, id, hedefSira, eskiSira],
          );
        }
      }

      final guncel = <String, dynamic>{
        'arilikId': yeniArilikId,
        'kovanNo': yeniKovanNo,
        'sistemKimlik': veri['sistemKimlik'] ?? eski['sistemKimlik'],
        'anaYili': veri['anaYili'] ?? eski['anaYili'],
        'kaynakTipi': yeniKaynakTipi,
        'kaynakKoloni': veri['kaynakKoloni'] ?? eski['kaynakKoloni'],
        'kaynakKoloniId': veri['kaynakKoloniId'] ?? eski['kaynakKoloniId'],
        'ebeveynKoloniId': veri['ebeveynKoloniId'] ??
            veri['kaynakKoloniId'] ??
            eski['ebeveynKoloniId'] ??
            eski['kaynakKoloniId'],
        'kokKoloniId': veri['kokKoloniId'] ?? eski['kokKoloniId'],
        'kaynakKovanNoSnapshot':
        veri['kaynakKovanNoSnapshot'] ?? eski['kaynakKovanNoSnapshot'],
        'anaKazanmaYontemi': _anaKazanmaYontemiNormalize(
          veri['anaKazanmaYontemi'] ?? eski['anaKazanmaYontemi'],
        ),
        'ilkKovanNo':
        veri['ilkKovanNo'] ?? eski['ilkKovanNo'] ?? eski['kovanNo'],
        'kovanNoGecmisi': veri['kovanNoGecmisi'] ?? eski['kovanNoGecmisi'],
        'genetik': veri['genetik'] ?? eski['genetik'],
        'rol': veri['rol'] ?? eski['rol'],
        'durum': veri['durum'] ?? eski['durum'],
        'olusturmaTarihi': yeniOlusturmaTarihi,
        'sonCita': veri['sonCita'] ?? eski['sonCita'],
        'maxCitaKapasiye': veri['maxCitaKapasiye'] ?? eski['maxCitaKapasiye'],
        'bal_cita': veri['bal_cita'] ?? eski['bal_cita'],
        'skor': veri['skor'] ?? eski['skor'],
        'sahaSirasi': hedefSira,
        'kovanTipi': _kovanTipiNormalize(veri['kovanTipi'] ?? eski['kovanTipi']),
        'suruplukVarMi': _toBoolInt(veri['suruplukVarMi'] ?? eski['suruplukVarMi']),
        'notMetni': veri['notMetni'] ?? eski['notMetni'],
      };

      if (yeniKaynakTipi == 'Ana Hat') {
        guncel['kaynakKoloni'] = '-';
        guncel['kaynakKoloniId'] = null;
        guncel['ebeveynKoloniId'] = null;
        guncel['kaynakKovanNoSnapshot'] = null;
      } else if (yeniKaynakTipi == 'Dış Kaynak') {
        guncel['kaynakKoloni'] = 'Dış Kaynak';
        guncel['kaynakKoloniId'] = null;
        guncel['ebeveynKoloniId'] = null;
        guncel['kaynakKovanNoSnapshot'] = null;
      }

      final sonuc = await txn.update(
        'koloniler',
        guncel,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (yeniKovanNo.isNotEmpty) {
        await _numaraGecmisiKaydiniGarantiEt(
          txn,
          koloniId: id,
          kovanNo: yeniKovanNo,
        );
      }

      if (eskiKovanNo.isNotEmpty &&
          yeniKovanNo.isNotEmpty &&
          eskiKovanNo != yeniKovanNo) {
        await _koloniOlayiEkle(
          txn,
          koloniId: id,
          olayTipi: 'NUMARA_DEGISIKLIGI',
          aciklama:
          'Koloni saha etiketi $eskiKovanNo → $yeniKovanNo olarak güncellendi.',
        );
      }

      // await _soyKimlikleriniOnar(txn);
      return sonuc;
    });
  }

  static Future<bool> koloniAktifMi(int koloniId) async {
    return _koloniAktifMiDb(await db, koloniId);
  }

  static Future<bool> _koloniAktifMiDb(
      DatabaseExecutor dbClient,
      int koloniId, {
        Map<String, dynamic>? koloniKaydi,
      }) async {
    Map<String, dynamic>? koloni = koloniKaydi;
    if (koloni == null) {
      final koloniKayitlari = await dbClient.query(
        'koloniler',
        columns: ['id', 'durum'],
        where: 'id = ?',
        whereArgs: [koloniId],
        limit: 1,
      );
      if (koloniKayitlari.isEmpty) return false;
      koloni = koloniKayitlari.first;
    }

    if (sonmusDurumMu(koloni['durum'])) {
      return false;
    }

    final sonMuayene = await dbClient.query(
      'muayeneler',
      columns: ['kovanSondu'],
      where: 'koloniId = ?',
      whereArgs: [koloniId],
      orderBy: 'tarih DESC, id DESC',
      limit: 1,
    );

    if (sonMuayene.isEmpty) return true;
    return _toInt(sonMuayene.first['kovanSondu']) != 1;
  }

  static Future<void> koloniNumarasiniDegistir({
    required int koloniId,
    required String yeniKovanNo,
  }) async {
    final dbClient = await db;
    final temizYeniNo = yeniKovanNo.trim();

    if (temizYeniNo.isEmpty) {
      throw Exception('Yeni koloni numarası boş bırakılamaz.');
    }

    final mevcut = await dbClient.query(
      'koloniler',
      where: 'id = ?',
      whereArgs: [koloniId],
      limit: 1,
    );

    if (mevcut.isEmpty) {
      throw Exception('Koloni kaydı bulunamadı.');
    }

    final koloni = mevcut.first;
    final arilikId = _toInt(koloni['arilikId']);
    final mevcutNo = (koloni['kovanNo'] ?? '').toString().trim();

    if (mevcutNo == temizYeniNo) {
      throw Exception('Yeni numara mevcut numara ile aynı.');
    }

    final cakisan = await _koloniBulAriliktaKovanNoIleDb(
      dbClient,
      arilikId: arilikId,
      kovanNo: temizYeniNo,
      haricKoloniId: koloniId,
      sadeceAktifler: true,
    );

    if (cakisan != null) {
      final cakisanNo = (cakisan['kovanNo'] ?? '').toString().trim();
      throw Exception('Bu numara arılıkta aktif bir koloni tarafından kullanılıyor: $cakisanNo');
    }

    final ilkNo = (koloni['ilkKovanNo'] ?? '').toString().trim();
    final gecmisMetni = (koloni['kovanNoGecmisi'] ?? '').toString().trim();
    final gecmisListe = gecmisMetni
        .split(' → ')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (gecmisListe.isEmpty && ilkNo.isNotEmpty) {
      gecmisListe.add(ilkNo);
    }
    if (gecmisListe.isEmpty && mevcutNo.isNotEmpty) {
      gecmisListe.add(mevcutNo);
    }
    if (gecmisListe.isEmpty || gecmisListe.last != mevcutNo) {
      gecmisListe.add(mevcutNo);
    }
    if (!gecmisListe.contains(temizYeniNo)) {
      gecmisListe.add(temizYeniNo);
    }

    await dbClient.update(
      'koloniler',
      {
        'kovanNo': temizYeniNo,
        'ilkKovanNo': ilkNo.isNotEmpty ? ilkNo : mevcutNo,
        'kovanNoGecmisi': gecmisListe.join(' → '),
      },
      where: 'id = ?',
      whereArgs: [koloniId],
    );

    await dbClient.update(
      'koloni_numara_gecmisi',
      {
        'aktifMi': 0,
        'bitisTarihi': _bugun(),
      },
      where: 'koloniId = ? AND aktifMi = 1',
      whereArgs: [koloniId],
    );

    await dbClient.insert(
      'koloni_numara_gecmisi',
      {
        'koloniId': koloniId,
        'kovanNo': temizYeniNo,
        'baslangicTarihi': _bugun(),
        'bitisTarihi': null,
        'aktifMi': 1,
      },
    );

    await _koloniOlayiEkle(
      dbClient,
      koloniId: koloniId,
      olayTipi: 'NUMARA_DEGISIKLIGI',
      aciklama: 'Koloni saha etiketi $mevcutNo → $temizYeniNo olarak değiştirildi.',
    );
  }

  static Future<int> koloniSil(int id) async {
    final dbClient = await db;

    return dbClient.transaction<int>((txn) async {
      final mevcut = await txn.query(
        'koloniler',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (mevcut.isEmpty) return 0;

      final koloni = mevcut.first;
      final arilikId = _toInt(koloni['arilikId']);
      final sahaSirasi = _toInt(koloni['sahaSirasi']);

      await txn.delete(
        'koloni_numara_gecmisi',
        where: 'koloniId = ?',
        whereArgs: [id],
      );
      await txn.delete(
        'koloni_olaylari',
        where: 'koloniId = ? OR ilgiliKoloniId = ?',
        whereArgs: [id, id],
      );

      final sonuc = await txn.delete(
        'koloniler',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (sonuc > 0 && arilikId > 0 && sahaSirasi > 0) {
        await _sirayiSikistirTx(
          txn,
          arilikId: arilikId,
          baslangicSira: sahaSirasi,
        );
        await _arilikSiralariniNormalizeEtDb(txn, arilikId: arilikId);
      }

      return sonuc;
    });
  }

  static Future<Map<String, dynamic>> koloniOzetiGetir(int id) async {
    final sonuc = await (await db).query(
      'koloniler',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    return sonuc.isNotEmpty ? sonuc.first : {};
  }

  static Future<List<Map<String, dynamic>>> muayeneleriGetir(int koloniId) async {
    return (await db).query(
      'muayeneler',
      where: 'koloniId = ?',
      whereArgs: [koloniId],
      orderBy: 'tarih DESC, id DESC',
    );
  }

  static Future<Map<int, Map<String, dynamic>>> sonMuayeneHaritasiGetir(
    List<int> koloniIdleri,
  ) async {
    final temizIdler = koloniIdleri.where((id) => id > 0).toSet().toList();
    if (temizIdler.isEmpty) return <int, Map<String, dynamic>>{};

    final dbClient = await db;
    final sonuc = <int, Map<String, dynamic>>{};

    for (final parca in _idParcalari(temizIdler)) {
      if (parca.isEmpty) continue;
      final yerTutucular = List.filled(parca.length, '?').join(',');
      final satirlar = await dbClient.query(
        'muayeneler',
        where: 'koloniId IN ($yerTutucular)',
        whereArgs: parca,
        orderBy: 'koloniId ASC, tarih DESC, id DESC',
      );

      for (final satir in satirlar) {
        final koloniId = _toInt(satir['koloniId']);
        if (koloniId <= 0) continue;
        sonuc.putIfAbsent(koloniId, () => satir);
      }
    }

    return sonuc;
  }

  static Future<Map<int, bool>> koloniAktiflikHaritasiGetir(
    List<int> koloniIdleri,
  ) async {
    final temizIdler = koloniIdleri.where((id) => id > 0).toSet().toList();
    if (temizIdler.isEmpty) return <int, bool>{};

    final dbClient = await db;
    final sonuc = <int, bool>{};

    for (final parca in _idParcalari(temizIdler)) {
      if (parca.isEmpty) continue;
      final yerTutucular = List.filled(parca.length, '?').join(',');

      final koloniler = await dbClient.query(
        'koloniler',
        columns: ['id', 'durum'],
        where: 'id IN ($yerTutucular)',
        whereArgs: parca,
      );

      for (final koloni in koloniler) {
        final koloniId = _toInt(koloni['id']);
        if (koloniId <= 0) continue;
        sonuc[koloniId] = !sonmusDurumMu(koloni['durum']);
      }

      final sonMuayeneMap = await sonMuayeneHaritasiGetir(parca);
      for (final koloniId in parca) {
        if (sonuc[koloniId] != true) {
          sonuc[koloniId] = false;
          continue;
        }

        final sonMuayene = sonMuayeneMap[koloniId];
        if (sonMuayene == null) continue;
        if (_toInt(sonMuayene['kovanSondu']) == 1) {
          sonuc[koloniId] = false;
        }
      }
    }

    return sonuc;
  }

  static List<List<int>> _idParcalari(List<int> idler, {int parcaBoyutu = 400}) {
    final sonuc = <List<int>>[];
    for (var i = 0; i < idler.length; i += parcaBoyutu) {
      final bitis = i + parcaBoyutu > idler.length ? idler.length : i + parcaBoyutu;
      sonuc.add(idler.sublist(i, bitis));
    }
    return sonuc;
  }

  static Future<void> _ilkMuayeneKaydiniGarantiEt(
      DatabaseExecutor exec, {
        required int koloniId,
        required String olusturmaTarihi,
        required int ilkToplamCita,
        required int ilkBalCita,
        required String notMetni,
      }) async {
    if (koloniId <= 0 || ilkToplamCita <= 0) return;

    final mevcut = await exec.query(
      'muayeneler',
      where: 'koloniId = ?',
      whereArgs: [koloniId],
      limit: 1,
    );

    if (mevcut.isNotEmpty) return;

    final temizNot = notMetni.trim();
    final otomatikNot = temizNot.isEmpty
        ? 'İlk koloni kaydı sırasında otomatik başlangıç muayenesi oluşturuldu.'
        : 'İlk koloni kaydı sırasında otomatik başlangıç muayenesi oluşturuldu. Not: ' + temizNot;

    await exec.insert('muayeneler', {
      'koloniId': koloniId,
      'tarih': olusturmaTarihi.trim().isEmpty ? _bugun() : olusturmaTarihi,
      'citaSayisi': ilkToplamCita,
      'bal_cita': ilkBalCita,
      'yavruluCita': 0,
      'yavruDuzeni': 'Normal',
      'mizac': 'Sakin',
      'beslemeTipi': 'Yok',
      'beslemeYapildi': 0,
      'varroaMucadele': null,
      'anaAriGoruldu': 1,
      'varroaGoruldu': 0,
      'ogulBelirtisi': 0,
      'ogulAtti': 0,
      'bolmeYapildi': 0,
      'kovanSondu': 0,
      'anaUretimGirisimVarMi': 0,
      'anasizBirakildiMi': 0,
      'anasizBaslangicTarihi': null,
      'anaKazanmaYontemi': null,
      'larvaYasiGun': null,
      'memeDurumu': null,
      'erkekAriDurumu': null,
      'ciftlesmeDurumu': null,
      'anaDegisimPlanlandiMi': 0,
      'kapaliYavruluCitaAktarildi': 0,
      'disaridanHazirAnaVerildi': 0,
      'gunlukKapaliYavruGoruldu': 0,
      'varroaSecimleri': null,
      'suruplukKaldirildiMi': 0,
      'suruplukKaldirmaManuelMi': 0,
      'eklenenPetekTipi': null,
      'eklenenTemelPetek': 0,
      'eklenenKabarmisPetek': 0,
      'notlar': otomatikNot,
    });
  }

  static Future<int> muayeneEkle(Map<String, dynamic> veri) async {
    final dbClient = await db;
    final veriTam = Map<String, dynamic>.from(veri);
    veriTam['ogulAtti'] = _toInt(veriTam['ogulAtti']);
    veriTam['anaUretimGirisimVarMi'] = 0;
    veriTam['anasizBirakildiMi'] = _toInt(veriTam['anasizBirakildiMi']);
    veriTam['anaDegisimPlanlandiMi'] = _toInt(veriTam['anaDegisimPlanlandiMi']);
    veriTam['anaKazanmaYontemi'] = _anaKazanmaYontemiNormalize(veriTam['anaKazanmaYontemi']);
    veriTam['kapaliYavruluCitaAktarildi'] = _toInt(veriTam['kapaliYavruluCitaAktarildi']);
    veriTam['disaridanHazirAnaVerildi'] = _toInt(veriTam['disaridanHazirAnaVerildi']);
    veriTam['gunlukKapaliYavruGoruldu'] = _toInt(veriTam['gunlukKapaliYavruGoruldu']);
    veriTam['suruplukKaldirildiMi'] = _toInt(veriTam['suruplukKaldirildiMi']);
    veriTam['suruplukKaldirmaManuelMi'] = _toInt(veriTam['suruplukKaldirmaManuelMi']);
    veriTam['eklenenPetekTipi'] = _eklenenPetekTipiNormalize(veriTam['eklenenPetekTipi']);
    veriTam['eklenenTemelPetek'] = _toInt(veriTam['eklenenTemelPetek']);
    veriTam['eklenenKabarmisPetek'] = _toInt(veriTam['eklenenKabarmisPetek']);
    veriTam['varroaSecimleri'] = _varroaSecimleriNormalize(veriTam['varroaSecimleri']);
    veriTam['varroaMucadele'] = _varroaMucadeleOzetineCevir(veriTam['varroaSecimleri'], fallback: veriTam['varroaMucadele']);
    veriTam['tarih'] = _tarihZorunluIso(
      veriTam['tarih'],
      alanAdi: 'Muayene tarihi',
      varsayilan: _bugun(),
    );

    final koloniId = _toInt(veriTam['koloniId']);
    await _muayeneTarihiniDogrulaDb(
      dbClient,
      koloniId: koloniId,
      muayeneTarihi: veriTam['tarih'].toString(),
    );

    final id = await dbClient.insert('muayeneler', veriTam);

    if (koloniId > 0) {
      await skorHesaplaVeGuncelle(koloniId);
    }

    return id;
  }

  static Future<int> muayeneGuncelle(int id, Map<String, dynamic> veri) async {
    final dbClient = await db;

    final veriTam = Map<String, dynamic>.from(veri);
    veriTam['ogulAtti'] = _toInt(veriTam['ogulAtti']);
    veriTam['anaUretimGirisimVarMi'] = 0;
    veriTam['anasizBirakildiMi'] = _toInt(veriTam['anasizBirakildiMi']);
    veriTam['anaDegisimPlanlandiMi'] = _toInt(veriTam['anaDegisimPlanlandiMi']);
    veriTam['anaKazanmaYontemi'] = _anaKazanmaYontemiNormalize(veriTam['anaKazanmaYontemi']);
    veriTam['kapaliYavruluCitaAktarildi'] = _toInt(veriTam['kapaliYavruluCitaAktarildi']);
    veriTam['disaridanHazirAnaVerildi'] = _toInt(veriTam['disaridanHazirAnaVerildi']);
    veriTam['gunlukKapaliYavruGoruldu'] = _toInt(veriTam['gunlukKapaliYavruGoruldu']);
    veriTam['suruplukKaldirildiMi'] = _toInt(veriTam['suruplukKaldirildiMi']);
    veriTam['suruplukKaldirmaManuelMi'] = _toInt(veriTam['suruplukKaldirmaManuelMi']);
    veriTam['eklenenPetekTipi'] = _eklenenPetekTipiNormalize(veriTam['eklenenPetekTipi']);
    veriTam['eklenenTemelPetek'] = _toInt(veriTam['eklenenTemelPetek']);
    veriTam['eklenenKabarmisPetek'] = _toInt(veriTam['eklenenKabarmisPetek']);
    veriTam['varroaSecimleri'] = _varroaSecimleriNormalize(veriTam['varroaSecimleri']);
    veriTam['varroaMucadele'] = _varroaMucadeleOzetineCevir(
      veriTam['varroaSecimleri'],
      fallback: veriTam['varroaMucadele'],
    );
    veriTam['tarih'] = _tarihZorunluIso(
      veriTam['tarih'],
      alanAdi: 'Muayene tarihi',
      varsayilan: _bugun(),
    );

    final koloniId = _toInt(veriTam['koloniId']);
    await _muayeneTarihiniDogrulaDb(
      dbClient,
      koloniId: koloniId,
      muayeneTarihi: veriTam['tarih'].toString(),
    );

    final sonuc = await dbClient.update(
      'muayeneler',
      veriTam,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (koloniId > 0) {
      await skorHesaplaVeGuncelle(koloniId);
    }

    return sonuc;
  }

  static Future<int> muayeneSil(int id) async {
    final dbClient = await db;

    final kayit = await dbClient.query(
      'muayeneler',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    final koloniId = kayit.isNotEmpty ? _toInt(kayit.first['koloniId']) : 0;

    final sonuc = await dbClient.delete(
      'muayeneler',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (koloniId > 0) {
      await skorHesaplaVeGuncelle(koloniId);
    }

    return sonuc;
  }

  static Future<void> skorHesaplaVeGuncelle(int koloniId) async {
    final dbClient = await db;

    final muayeneler = await dbClient.query(
      'muayeneler',
      where: 'koloniId = ?',
      whereArgs: [koloniId],
      orderBy: 'tarih ASC, id ASC',
    );

    if (muayeneler.isEmpty) {
      await dbClient.update(
        'koloniler',
        {
          'sonCita': 0,
          'maxCitaKapasiye': 0,
          'bal_cita': 0,
          'skor': 0,
        },
        where: 'id = ?',
        whereArgs: [koloniId],
      );
      return;
    }

    final son = muayeneler.last;
    final onceki = muayeneler.length >= 2 ? muayeneler[muayeneler.length - 2] : null;
    final bool ilkAsama = muayeneler.length == 1;

    final sonCita = _toInt(son['citaSayisi']);
    final maxCita = muayeneler
        .map((m) => _toInt(m['citaSayisi']))
        .fold<int>(0, (a, b) => a > b ? a : b);

    final maxBal = muayeneler
        .map((m) => _toInt(m['bal_cita']))
        .fold<int>(0, (a, b) => a > b ? a : b);

    final tarih = DateTime.tryParse((son['tarih'] ?? '').toString()) ?? DateTime.now();
    final sezon = await aktifSezonKoduGetir(tarih);

    // SERBEST METİN ANALİZİ YOK:
    // Notlardan varroa/oğul okumuyoruz. Yalnızca kayıtlı alanlar kullanılır.
    final varroaMucadele = (son['varroaMucadele'] ?? '').toString().trim();
    final bool varroaAcikGoruldu = _toInt(son['varroaGoruldu']) == 1;
    // Oğul verisi sağlık puanı için kullanılmaz.
    // Oğul, donör/genetik istikrar tarafında sert veto olarak değerlendirilir.
    final bolmeVar = _toInt(son['bolmeYapildi']) == 1;
    final kovanSondu = _toInt(son['kovanSondu']) == 1;

    final mizacMetni = (son['mizac'] ?? '').toString();
    final yavruDuzeni = (son['yavruDuzeni'] ?? '').toString();
    final beslemeTipi = (son['beslemeTipi'] ?? '').toString();

    final bool sonMuayenedeBeslemeVar =
        _toInt(son['beslemeYapildi']) == 1 ||
            (beslemeTipi.trim().isNotEmpty && beslemeTipi.trim().toLowerCase() != 'yok');

    final int sonBeslemeSayisi = muayeneler.reversed
        .take(3)
        .where((m) {
          final tip = (m['beslemeTipi'] ?? '').toString().trim().toLowerCase();
          return _toInt(m['beslemeYapildi']) == 1 ||
              (tip.isNotEmpty && tip != 'yok');
        })
        .length;

    final koloni = await koloniOzetiGetir(koloniId);
    final anaYiliMetni = (koloni['anaYili'] ?? '').toString().trim();
    final anaYili = int.tryParse(anaYiliMetni);
    final anaYasi = anaYili == null ? 0 : (DateTime.now().year - anaYili);
    final ogulRiskOzeti = await ogulRiskOzetiGetir(koloniId);

    if (kovanSondu) {
      await dbClient.update(
        'koloniler',
        {
          'sonCita': sonCita,
          'maxCitaKapasiye': maxCita,
          'bal_cita': maxBal,
          'skor': 5,
        },
        where: 'id = ?',
        whereArgs: [koloniId],
      );
      return;
    }

    double gelisimPuani;
    if (sezon == 'kis') {
      final gucluEsik = await ayarIntGetir(
        'kis_guclu_koloni_min_cita',
        varsayilan: 6,
      );
      gelisimPuani = (sonCita / gucluEsik) * 100.0;
    } else {
      gelisimPuani = (sonCita / 10.0) * 100.0;
    }

    if (onceki != null) {
      final oncekiCita = _toInt(onceki['citaSayisi']);
      if (bolmeVar && sonCita < oncekiCita) {
        gelisimPuani += (oncekiCita - sonCita) * 6.0;
      }
    }

    gelisimPuani = gelisimPuani.clamp(0, 100).toDouble();

    double verimPuani;
    if (sezon == 'kis') {
      // Kışta kalan bal arıcının yönetim tercihidir; performans puanı değildir.
      verimPuani = 0;
    } else {
      verimPuani = (maxBal / 8.0) * 100.0;
      if (maxBal > 0) {
        verimPuani += 8;
      }
    }

    // Besleme verimi cezalandırmaz. Besleme, bal performansı değil yönetim sinyalidir.
    verimPuani = verimPuani.clamp(0, 100).toDouble();

    // Varroa mantığı:
    // - Nottan okuma YOK
    // - varroaGoruldu alanı puanlamada kullanılmıyor
    // - Yalnızca varroaMucadele kayıtlı alanı ve sezon bazlı minimum disiplin dikkate alınır
    final kisMucadeleTarihleri = <String>{};
    final uretimMucadeleTarihleri = <String>{};

    for (final m in muayeneler) {
      final mucadele = (m['varroaMucadele'] ?? '').toString().trim();
      if (mucadele.isEmpty || mucadele.toLowerCase() == 'yok') continue;

      final mtarih = DateTime.tryParse((m['tarih'] ?? '').toString()) ?? tarih;
      final mSezon = await aktifSezonKoduGetir(mtarih);
      final gun = (m['tarih'] ?? '').toString().trim();
      if (gun.isEmpty) continue;

      if (mSezon == 'kis') {
        kisMucadeleTarihleri.add(gun);
      } else {
        uretimMucadeleTarihleri.add(gun);
      }
    }

    final bool kisMucadeleOlumlu = kisMucadeleTarihleri.length >= 2;
    final bool uretimMucadeleOlumlu = uretimMucadeleTarihleri.isNotEmpty;
    final bool hicMucadeleKaydiYok =
        kisMucadeleTarihleri.isEmpty && uretimMucadeleTarihleri.isEmpty;
    final bool sonMuayenedeMucadeleVar =
        varroaMucadele.isNotEmpty && varroaMucadele.toLowerCase() != 'yok';

    double saglikPuani = 100;

    if (sezon == 'kis') {
      if (kisMucadeleOlumlu) {
        saglikPuani += 6;
      } else if (!hicMucadeleKaydiYok) {
        saglikPuani -= 4;
      }
    } else {
      if (uretimMucadeleOlumlu || sonMuayenedeMucadeleVar) {
        saglikPuani += 4;
      } else if (!hicMucadeleKaydiYok) {
        saglikPuani -= 4;
      }
    }

    if (varroaAcikGoruldu && !sonMuayenedeMucadeleVar) {
      // Açık varroa görüldüyse ve aynı kayıtta mücadele yoksa sağlık riski vardır.
      // Oğuldan farklı olarak bu gerçek bir koloni sağlığı baskısıdır.
      saglikPuani -= 12;
    } else if (varroaAcikGoruldu && sonMuayenedeMucadeleVar) {
      // Sorun görülmüş ama aynı kayıtta müdahale de yapılmışsa ceza sınırlı kalır.
      saglikPuani -= 4;
    }

    if (anaYasi >= 3) {
      saglikPuani -= sezon == 'kis' ? 10 : 7;
    } else if (anaYasi == 2) {
      saglikPuani -= sezon == 'kis' ? 4 : 2;
    }

    if (yavruDuzeni == 'Kambur' && sezon != 'kis') {
      // Kambur yavru sıradan düşük puan değil; yalancı ana / ana problemi riski olarak okunur.
      saglikPuani -= 18;
    }

    // Ana görülmedi alanı eski kayıtlarda boş/0 gelebilir.
    // Bu yüzden sağlık puanında otomatik ceza üretmez; ana kazanma süreçleri ayrı motorlarda okunur.
    saglikPuani = saglikPuani.clamp(0, 100).toDouble();

    final davranisToleransi = await ayarStringGetir(
      'davranis_toleransi',
      varsayilan: 'standart',
    );

    double mizacPuani = 70;
    if (davranisToleransi == 'esnek') {
      mizacPuani = 70;
    } else {
      if (mizacMetni == 'Sakin') {
        mizacPuani = 100;
      } else if (mizacMetni == 'Sinirli') {
        mizacPuani = 60;
      } else if (mizacMetni == 'Saldırgan') {
        mizacPuani = 20;
      }
    }

    double yavruPuani = 70;
    if (sezon == 'kis') {
      // Kışta yavru düzeni beklenen performans verisi değildir.
      yavruPuani = 0;
    } else if (yavruDuzeni == 'Blok') {
      yavruPuani = 100;
    } else if (yavruDuzeni == 'Normal') {
      yavruPuani = 85;
    } else if (yavruDuzeni == 'Dağınık') {
      yavruPuani = 45;
    } else if (yavruDuzeni == 'Kambur') {
      yavruPuani = 20;
    }

    final agirlikGelisim = await ayarIntGetir(
      sezon == 'kis' ? 'kis_agirlik_gelisim' : 'uretim_agirlik_gelisim',
      varsayilan: sezon == 'kis' ? 35 : 30,
    );
    final agirlikVerimHam = await ayarIntGetir(
      sezon == 'kis' ? 'kis_agirlik_verim' : 'uretim_agirlik_verim',
      varsayilan: sezon == 'kis' ? 0 : 25,
    );
    final agirlikSaglik = await ayarIntGetir(
      sezon == 'kis' ? 'kis_agirlik_saglik' : 'uretim_agirlik_saglik',
      varsayilan: sezon == 'kis' ? 40 : 25,
    );
    final agirlikMizac = await ayarIntGetir(
      sezon == 'kis' ? 'kis_agirlik_mizac' : 'uretim_agirlik_mizac',
      varsayilan: sezon == 'kis' ? 10 : 10,
    );
    final agirlikYavruHam = await ayarIntGetir(
      sezon == 'kis' ? 'kis_agirlik_yavru' : 'uretim_agirlik_yavru',
      varsayilan: sezon == 'kis' ? 0 : 10,
    );

    final int agirlikVerim = sezon == 'kis' ? 0 : agirlikVerimHam;
    final int agirlikYavru = sezon == 'kis' ? 0 : agirlikYavruHam;

    final int aktifAgirlikToplami =
        agirlikGelisim + agirlikVerim + agirlikSaglik + agirlikMizac + agirlikYavru;

    double toplam = aktifAgirlikToplami <= 0
        ? 0
        : ((gelisimPuani * agirlikGelisim) +
        (verimPuani * agirlikVerim) +
        (saglikPuani * agirlikSaglik) +
        (mizacPuani * agirlikMizac) +
        (yavruPuani * agirlikYavru)) /
        aktifAgirlikToplami;

    if (yavruDuzeni == 'Kambur' && sezon != 'kis') {
      // Özel risk: skor tamamen sıfırlanmaz, fakat yüksek performans gibi görünmesine izin verilmez.
      toplam = toplam.clamp(0, 58).toDouble();
    } else if (yavruDuzeni == 'Dağınık' && sezon != 'kis') {
      toplam = toplam.clamp(0, 78).toDouble();
    }

    if (sonBeslemeSayisi > 0 && saglikPuani >= 70 && gelisimPuani >= 45) {
      toplam += sonMuayenedeBeslemeVar ? 3 : 2;
    }

    if (ilkAsama) {
      final ilkAsamaTaban = sonCita >= 7 ? 55 : (sonCita >= 5 ? 45 : 35);
      if (toplam < ilkAsamaTaban) toplam = ilkAsamaTaban.toDouble();
    }

    if (davranisToleransi != 'esnek' && sonCita > 8 && mizacMetni == 'Saldırgan') {
      toplam *= 0.2;
    }

    final aferinBas = await ayarStringGetir(
      'kistan_cikis_aferin_tarih_baslangic',
      varsayilan: '03-01',
    );
    final aferinBit = await ayarStringGetir(
      'kistan_cikis_aferin_tarih_bitis',
      varsayilan: '04-30',
    );
    final aferinCitaMin = await ayarIntGetir(
      'kistan_cikis_aferin_cita_min',
      varsayilan: 6,
    );
    final aferinBonus = await ayarIntGetir(
      'kistan_cikis_aferin_skor_bonus',
      varsayilan: 5,
    );
    final aferinAnaYasMax = await ayarIntGetir(
      'kistan_cikis_aferin_ana_yas_max',
      varsayilan: 2,
    );

    final aferinDonemi = _tarihAraliktaMi(
      tarih,
      aferinBas,
      aferinBit,
      yilTasmasi: false,
    );

    if (sezon == 'uretim' &&
        aferinDonemi &&
        sonCita >= aferinCitaMin &&
        saglikPuani >= 70 &&
        (anaYasi == 0 || anaYasi <= aferinAnaYasMax)) {
      toplam += aferinBonus;
    }

    final int nihaiSkor = toplam.round().clamp(0, 100);

    await dbClient.update(
      'koloniler',
      {
        'sonCita': sonCita,
        'maxCitaKapasiye': maxCita,
        'bal_cita': maxBal,
        'skor': nihaiSkor,
      },
      where: 'id = ?',
      whereArgs: [koloniId],
    );
  }

  static Future<void> tumSkorlariYenidenHesapla() async {
    final dbClient = await db;
    final koloniler = await dbClient.query('koloniler', columns: ['id'], orderBy: 'id ASC');
    for (final k in koloniler) {
      final id = _toInt(k['id']);
      if (id > 0) {
        await skorHesaplaVeGuncelle(id);
      }
    }
  }

  static Future<int> ayarIntGetir(
      String anahtar, {
        int varsayilan = 0,
      }) async {
    final sonuc = await (await db).query(
      'ayarlar',
      where: 'anahtar = ?',
      whereArgs: [anahtar],
      limit: 1,
    );

    if (sonuc.isEmpty) return varsayilan;
    return int.tryParse(sonuc.first['deger'].toString()) ?? varsayilan;
  }

  static Future<String> ayarStringGetir(
      String anahtar, {
        String varsayilan = '',
      }) async {
    final sonuc = await (await db).query(
      'ayarlar',
      where: 'anahtar = ?',
      whereArgs: [anahtar],
      limit: 1,
    );

    if (sonuc.isEmpty) return varsayilan;
    return sonuc.first['deger']?.toString() ?? varsayilan;
  }

  static Future<void> ayarKaydet(String anahtar, String deger) async {
    await (await db).insert(
      'ayarlar',
      {'anahtar': anahtar, 'deger': deger},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (_balAkimAyariMi(anahtar)) {
      balAkimCacheTemizle();
    }
  }


  static const List<String> _arilikKalibrasyonAnahtarlari = [
    'bal_akim1_baslangic',
    'bal_akim1_bitis',
    'bal_akim2_aktif',
    'bal_akim2_baslangic',
    'bal_akim2_bitis',
    'risk_ari_kusu_baslangic',
    'risk_ari_kusu_bitis',
    'risk_esek_arisi_baslangic',
    'risk_esek_arisi_bitis',
    'risk_yagmacilik_baslangic',
    'risk_yagmacilik_bitis',
    'risk_mum_guvesi_baslangic',
    'risk_mum_guvesi_bitis',
    'risk_fare_baslangic',
    'risk_fare_bitis',
  ];

  static String _varsayilanKalibrasyonDegeri(String anahtar) {
    return varsayilanAyarDegeri(anahtar);
  }

  static Future<String> kalibrasyonAyarGetir(
    String anahtar, {
    int? arilikId,
  }) async {
    return _arilikAyariGetir(
      arilikId: arilikId,
      anahtar: anahtar,
      varsayilan: varsayilanAyarDegeri(anahtar),
    );
  }

  static Future<void> kalibrasyonAyarKaydet(
    String anahtar,
    String deger, {
    int? arilikId,
  }) async {
    final kayitAnahtari = arilikId != null && arilikId > 0
        ? 'arilik_${arilikId}_$anahtar'
        : anahtar;
    await ayarKaydet(kayitAnahtari, deger);
  }

  static Future<void> arilikKalibrasyonunuKopyala({
    required int kaynakArilikId,
    required int hedefArilikId,
  }) async {
    if (kaynakArilikId <= 0 || hedefArilikId <= 0) return;
    if (kaynakArilikId == hedefArilikId) return;

    for (final anahtar in _arilikKalibrasyonAnahtarlari) {
      final kaynakOzelAnahtar = 'arilik_${kaynakArilikId}_$anahtar';
      final hedefOzelAnahtar = 'arilik_${hedefArilikId}_$anahtar';

      final kaynakOzelDeger = await ayarStringGetir(
        kaynakOzelAnahtar,
        varsayilan: '',
      );

      final deger = kaynakOzelDeger.trim().isNotEmpty
          ? kaynakOzelDeger
          : await ayarStringGetir(
              anahtar,
              varsayilan: _varsayilanKalibrasyonDegeri(anahtar),
            );

      await ayarKaydet(hedefOzelAnahtar, deger);
    }

    balAkimCacheTemizle(arilikId: hedefArilikId);
  }


  static Future<void> veriButunlugunuDogrula() async {
    final dbClient = await db;
    await _veriButunlugunuDogrulaDb(dbClient);
  }

  static Future<void> _veriButunlugunuDogrulaDb(DatabaseExecutor exec) async {
    final ariliklar = await exec.query('ariliklar', orderBy: 'id ASC');
    for (final arilik in ariliklar) {
      final arilikId = _toInt(arilik['id']);
      if (arilikId <= 0) continue;
      final kurulusTarihi = _tarihZorunluIso(
        arilik['kurulusTarihi'],
        alanAdi: 'Arılık başlangıç tarihi',
        varsayilan: _bugun(),
      );
      await _arilikKurulusTarihiDogrulaDb(
        exec,
        arilikId: arilikId,
        kurulusTarihi: kurulusTarihi,
      );
    }

    final koloniler = await exec.query('koloniler', orderBy: 'id ASC');
    for (final koloni in koloniler) {
      final koloniId = _toInt(koloni['id']);
      if (koloniId <= 0) continue;
      final arilikId = _toInt(koloni['arilikId']);
      final olusturmaTarihi = _tarihZorunluIso(
        koloni['olusturmaTarihi'],
        alanAdi: 'Koloni oluşturma tarihi',
        varsayilan: _bugun(),
      );
      await _koloniTarihiniDogrulaDb(
        exec,
        koloniId: koloniId,
        arilikId: arilikId,
        olusturmaTarihi: olusturmaTarihi,
      );
    }

    final muayeneler = await exec.query('muayeneler', orderBy: 'id ASC');
    for (final muayene in muayeneler) {
      final koloniId = _toInt(muayene['koloniId']);
      final muayeneTarihi = _tarihZorunluIso(
        muayene['tarih'],
        alanAdi: 'Muayene tarihi',
        varsayilan: _bugun(),
      );
      await _muayeneTarihiniDogrulaDb(
        exec,
        koloniId: koloniId,
        muayeneTarihi: muayeneTarihi,
      );
    }
  }

  static Future<void> sistemBakimiCalistir() async {
    final dbClient = await db;
    await _varsayilanAyarlariYukle(dbClient);
    await _soyKimlikleriniOnar(dbClient);
    await _tumArilikSiralariniNormalizeEtDb(dbClient);
    await _veriButunlugunuDogrulaDb(dbClient);
  }

  static Future<List<Map<String, dynamic>>> gucluKolonileriGetir() async {
    final esik = await ayarIntGetir('guclu_koloni_min_cita', varsayilan: 7);

    return (await db).query(
      'koloniler',
      where: 'sonCita >= ?',
      whereArgs: [esik],
      orderBy: 'skor DESC, sonCita DESC',
    );
  }

  static Future<List<Map<String, dynamic>>> riskliKolonileriGetir() async {
    final esik = await ayarIntGetir('destek_max_maks_cita', varsayilan: 4);

    return (await db).query(
      'koloniler',
      where: 'sonCita <= ?',
      whereArgs: [esik],
      orderBy: 'sonCita ASC, skor ASC',
    );
  }

  static Future<List<Map<String, dynamic>>> bolmeAdaylari() async {
    const esik = 6;

    return (await db).query(
      'koloniler',
      where: 'sonCita >= ?',
      whereArgs: [esik],
      orderBy: 'sonCita DESC, skor DESC',
    );
  }

  static Future<List<Map<String, dynamic>>> anaDegisimAdaylari() async {
    final koloniler = await (await db).query('koloniler');
    final simdikiYil = DateTime.now().year;
    final esik = await ayarIntGetir('ana_degisim_sezon_esigi', varsayilan: 2);

    return koloniler.where((k) {
      final anaYili =
          int.tryParse((k['anaYili'] ?? '').toString()) ?? simdikiYil;
      return (simdikiYil - anaYili) >= esik;
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> aktifArilikOzetRaporuGetir() async {
    return (await db).rawQuery('''
      SELECT
        id,
        kovanNo,
        anaYili,
        sonCita,
        maxCitaKapasiye AS maksCita,
        skor AS saglikSkoru
      FROM koloniler
      ORDER BY sahaSirasi ASC, id ASC
    ''');
  }

  static Future<List<Map<String, dynamic>>> numaraGecmisiGetir(int koloniId) async {
    return (await db).query(
      'koloni_numara_gecmisi',
      where: 'koloniId = ?',
      whereArgs: [koloniId],
      orderBy: 'id ASC',
    );
  }


  static bool _kaynakTipiOgulMu(String kaynakTipi) {
    final temiz = kaynakTipi.toLowerCase().trim();
    return temiz.contains('oğul') || temiz.contains('ogul');
  }

  static String _sistemKimlikOlustur(int id) {
    return 'ITG-K-${id.toString().padLeft(6, '0')}';
  }

  static String _bugun() {
    return DateTime.now().toIso8601String().split('T').first;
  }

  static String _tarihZorunluIso(
    dynamic deger, {
    required String alanAdi,
    String? varsayilan,
  }) {
    final ham = (deger ?? '').toString().trim();
    final kullanilacak = ham.isEmpty ? (varsayilan ?? '') : ham;
    if (kullanilacak.trim().isEmpty) {
      throw Exception('$alanAdi boş olamaz.');
    }

    final tarih = DateTime.tryParse(kullanilacak);
    if (tarih == null) {
      throw Exception('$alanAdi geçerli bir tarih değil: $kullanilacak');
    }

    return _isoGun(tarih);
  }

  static DateTime? _tarihParseGun(dynamic deger) {
    final ham = (deger ?? '').toString().trim();
    if (ham.isEmpty) return null;
    final tarih = DateTime.tryParse(ham);
    if (tarih == null) return null;
    return DateTime(tarih.year, tarih.month, tarih.day);
  }

  static String _isoGun(DateTime tarih) {
    final gun = DateTime(tarih.year, tarih.month, tarih.day);
    return gun.toIso8601String().split('T').first;
  }

  static bool _gunSonraMi(DateTime sol, DateTime sag) {
    final a = DateTime(sol.year, sol.month, sol.day);
    final b = DateTime(sag.year, sag.month, sag.day);
    return a.isAfter(b);
  }

  static Future<DateTime?> _arilikKurulusTarihiGetirDb(
    DatabaseExecutor exec,
    int arilikId,
  ) async {
    if (arilikId <= 0) return null;
    final kayit = await exec.query(
      'ariliklar',
      columns: ['kurulusTarihi'],
      where: 'id = ?',
      whereArgs: [arilikId],
      limit: 1,
    );
    if (kayit.isEmpty) return null;
    return _tarihParseGun(kayit.first['kurulusTarihi']);
  }

  static Future<DateTime?> _arilikEnEskiKoloniTarihiGetirDb(
    DatabaseExecutor exec,
    int arilikId, {
    int? haricKoloniId,
  }) async {
    if (arilikId <= 0) return null;

    final where = StringBuffer(
      "arilikId = ? AND COALESCE(olusturmaTarihi, '') != ''",
    );
    final whereArgs = <Object?>[arilikId];

    if (haricKoloniId != null && haricKoloniId > 0) {
      where.write(' AND id != ?');
      whereArgs.add(haricKoloniId);
    }

    final kayit = await exec.query(
      'koloniler',
      columns: ['olusturmaTarihi'],
      where: where.toString(),
      whereArgs: whereArgs,
      orderBy: 'olusturmaTarihi ASC, id ASC',
      limit: 1,
    );

    if (kayit.isEmpty) return null;
    return _tarihParseGun(kayit.first['olusturmaTarihi']);
  }

  static Future<DateTime?> _koloniIlkMuayeneTarihiGetirDb(
    DatabaseExecutor exec,
    int koloniId, {
    int? haricMuayeneId,
  }) async {
    if (koloniId <= 0) return null;

    final where = StringBuffer(
      "koloniId = ? AND COALESCE(tarih, '') != ''",
    );
    final whereArgs = <Object?>[koloniId];

    if (haricMuayeneId != null && haricMuayeneId > 0) {
      where.write(' AND id != ?');
      whereArgs.add(haricMuayeneId);
    }

    final kayit = await exec.query(
      'muayeneler',
      columns: ['tarih'],
      where: where.toString(),
      whereArgs: whereArgs,
      orderBy: 'tarih ASC, id ASC',
      limit: 1,
    );

    if (kayit.isEmpty) return null;
    return _tarihParseGun(kayit.first['tarih']);
  }

  static Future<void> _arilikKurulusTarihiDogrulaDb(
    DatabaseExecutor exec, {
    required int arilikId,
    required String kurulusTarihi,
  }) async {
    if (arilikId <= 0) return;

    final kurulus = _tarihParseGun(kurulusTarihi);
    if (kurulus == null) {
      throw Exception('Arılık başlangıç tarihi geçerli değil: $kurulusTarihi');
    }

    final enEskiKoloni = await _arilikEnEskiKoloniTarihiGetirDb(
      exec,
      arilikId,
    );

    if (enEskiKoloni != null && _gunSonraMi(kurulus, enEskiKoloni)) {
      throw Exception(
        'Arılık başlangıç tarihi, arılıktaki en eski koloni tarihinden sonra olamaz. '
        'En eski koloni tarihi: ${_isoGun(enEskiKoloni)}',
      );
    }
  }

  static Future<void> _koloniTarihiniDogrulaDb(
    DatabaseExecutor exec, {
    required int koloniId,
    required int arilikId,
    required String olusturmaTarihi,
  }) async {
    final olusturma = _tarihParseGun(olusturmaTarihi);
    if (olusturma == null) {
      throw Exception('Koloni oluşturma tarihi geçerli değil: $olusturmaTarihi');
    }

    final arilikKurulus = await _arilikKurulusTarihiGetirDb(exec, arilikId);
    if (arilikKurulus != null && _gunSonraMi(arilikKurulus, olusturma)) {
      throw Exception(
        'Koloni oluşturma tarihi, arılık başlangıç tarihinden önce olamaz. '
        'Arılık başlangıç tarihi: ${_isoGun(arilikKurulus)}',
      );
    }

    if (koloniId > 0) {
      final ilkMuayene = await _koloniIlkMuayeneTarihiGetirDb(exec, koloniId);
      if (ilkMuayene != null && _gunSonraMi(olusturma, ilkMuayene)) {
        throw Exception(
          'Koloni oluşturma tarihi, o koloninin ilk muayene tarihinden sonra olamaz. '
          'İlk muayene tarihi: ${_isoGun(ilkMuayene)}',
        );
      }
    }
  }

  static Future<void> _muayeneTarihiniDogrulaDb(
    DatabaseExecutor exec, {
    required int koloniId,
    required String muayeneTarihi,
  }) async {
    if (koloniId <= 0) {
      throw Exception('Muayene için geçerli bir koloni kaydı bulunamadı.');
    }

    final muayene = _tarihParseGun(muayeneTarihi);
    if (muayene == null) {
      throw Exception('Muayene tarihi geçerli değil: $muayeneTarihi');
    }

    final koloni = await exec.query(
      'koloniler',
      columns: ['olusturmaTarihi', 'arilikId'],
      where: 'id = ?',
      whereArgs: [koloniId],
      limit: 1,
    );

    if (koloni.isEmpty) {
      throw Exception('Muayene eklenecek koloni bulunamadı.');
    }

    final arilikId = _toInt(koloni.first['arilikId']);
    final arilikKurulus = await _arilikKurulusTarihiGetirDb(exec, arilikId);
    if (arilikKurulus != null && _gunSonraMi(arilikKurulus, muayene)) {
      throw Exception(
        'Muayene tarihi, arılık başlangıç tarihinden önce olamaz. '
        'Arılık başlangıç tarihi: ${_isoGun(arilikKurulus)}',
      );
    }

    final olusturma = _tarihParseGun(koloni.first['olusturmaTarihi']);
    if (olusturma != null && _gunSonraMi(olusturma, muayene)) {
      throw Exception(
        'Muayene tarihi, koloni oluşturma tarihinden önce olamaz. '
        'Koloni oluşturma tarihi: ${_isoGun(olusturma)}',
      );
    }
  }

  static String _olayTipiUret(String kaynakTipi) {
    switch (kaynakTipi) {
      case 'Bölme':
        return 'OLUSUM_BOLME';
      case 'Oğul':
        return 'OLUSUM_OGUL';
      case 'Ana Hat':
        return 'OLUSUM_ANA_HAT';
      case 'Satın Alma':
      case 'Paket Arı':
      case 'Dış Kaynak':
        return 'OLUSUM_DIS_KAYNAK';
      default:
        return 'OLUSUM_DIGER';
    }
  }

  static Future<void> _koloniOlayiEkle(
      DatabaseExecutor dbClient, {
        required int koloniId,
        required String olayTipi,
        int? ilgiliKoloniId,
        String? aciklama,
        String? tarih,
        String? metaJson,
      }) async {
    await dbClient.insert(
      'koloni_olaylari',
      {
        'koloniId': koloniId,
        'tarih': (tarih ?? _bugun()),
        'olayTipi': olayTipi,
        'ilgiliKoloniId': ilgiliKoloniId,
        'aciklama': aciklama,
        'metaJson': metaJson,
      },
    );
  }

  static Future<void> _numaraGecmisiKaydiniGarantiEt(
      DatabaseExecutor dbClient, {
        required int koloniId,
        required String kovanNo,
      }) async {
    final temizNo = kovanNo.trim();
    if (koloniId <= 0 || temizNo.isEmpty) return;

    final aktifKayit = await dbClient.query(
      'koloni_numara_gecmisi',
      where: 'koloniId = ? AND aktifMi = 1',
      whereArgs: [koloniId],
      orderBy: 'id DESC',
      limit: 1,
    );

    if (aktifKayit.isNotEmpty) {
      final aktifNo = (aktifKayit.first['kovanNo'] ?? '').toString().trim();
      if (aktifNo == temizNo) return;

      await dbClient.update(
        'koloni_numara_gecmisi',
        {
          'aktifMi': 0,
          'bitisTarihi': _bugun(),
        },
        where: 'id = ?',
        whereArgs: [_toInt(aktifKayit.first['id'])],
      );
    }

    final ayniKayit = await dbClient.query(
      'koloni_numara_gecmisi',
      where: 'koloniId = ? AND kovanNo = ?',
      whereArgs: [koloniId, temizNo],
      orderBy: 'id DESC',
      limit: 1,
    );

    if (ayniKayit.isNotEmpty) {
      await dbClient.update(
        'koloni_numara_gecmisi',
        {
          'aktifMi': 1,
          'bitisTarihi': null,
        },
        where: 'id = ?',
        whereArgs: [_toInt(ayniKayit.first['id'])],
      );
      return;
    }

    await dbClient.insert(
      'koloni_numara_gecmisi',
      {
        'koloniId': koloniId,
        'kovanNo': temizNo,
        'baslangicTarihi': _bugun(),
        'bitisTarihi': null,
        'aktifMi': 1,
      },
    );
  }


  static String? _anaKazanmaYontemiNormalize(dynamic deger) {
    final temiz = (deger ?? '').toString().trim().toLowerCase();
    if (temiz.isEmpty || temiz == 'null') return null;

    if (temiz == 'kendi_anasi' ||
        temiz == 'kendi anasını yapacak' ||
        temiz == 'kendi anasini yapacak' ||
        temiz == 'sifirdan' ||
        temiz == 'sıfırdan') {
      return 'kendi_anasi';
    }

    if (temiz == 'kapali_meme' ||
        temiz == 'kapalı ana memesi var' ||
        temiz == 'kapali ana memesi var' ||
        temiz == 'kapalı meme' ||
        temiz == 'kapali meme') {
      return 'kapali_meme';
    }

    if (temiz == 'hazir_ana' ||
        temiz == 'hazır çiftleşmiş ana verildi' ||
        temiz == 'hazir ciftlesmis ana verildi' ||
        temiz == 'hazır ana' ||
        temiz == 'hazir ana') {
      return 'hazir_ana';
    }

    return 'kendi_anasi';
  }

  static String _varroaSecimleriNormalize(dynamic ham) {
    final secimler = _varroaSecimListesi(ham);
    return secimler.isEmpty ? '' : secimler.join(',');
  }

  static List<String> varroaSecimleriniGetir(Map<String, dynamic> muayene) {
    return _varroaSecimListesi(muayene['varroaSecimleri'] ?? muayene['varroaMucadele']);
  }

  static List<String> _varroaSecimListesi(dynamic ham) {
    if (ham == null) return <String>[];
    if (ham is List) {
      return ham
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty && e.toLowerCase() != 'yok')
          .toSet()
          .toList();
    }

    final metin = ham.toString().trim();
    if (metin.isEmpty || metin.toLowerCase() == 'yok') return <String>[];

    String normalizeToken(String token) {
      final t = token.trim().toLowerCase();
      if (t == 'oksalik asit') return 'oksalik';
      if (t == 'varroset') return 'amitraz';
      if (t == 'diğer' || t == 'diger') return 'formik';
      return t;
    }

    return metin
        .split(',')
        .map(normalizeToken)
        .where((e) => e.isNotEmpty && e != 'yok')
        .toSet()
        .toList();
  }

  static String? _eklenenPetekTipiNormalize(dynamic deger) {
    final temiz = (deger ?? '').toString().trim().toLowerCase();
    if (temiz.isEmpty || temiz == '-' || temiz == 'yok') return null;
    if (temiz.contains('kabar')) return 'Kabarmış petek';
    if (temiz.contains('temel')) return 'Temel petek';
    if (temiz.contains('ball') || temiz.contains('stok')) return 'Ballı/stoklu petek';
    if (temiz.contains('yavru')) return 'Yavrulu destek çıtası';
    return 'Temel petek';
}

  static String? _varroaMucadeleOzetineCevir(dynamic ham, {dynamic fallback}) {
    final secimler = _varroaSecimListesi(ham);
    if (secimler.isNotEmpty) return secimler.first;
    final fallbackMetin = (fallback ?? '').toString().trim();
    return fallbackMetin.isEmpty ? null : fallbackMetin;
  }
  static int _toInt(dynamic deger) {
    if (deger == null) return 0;
    if (deger is int) return deger;
    return int.tryParse(deger.toString()) ?? 0;
  }

  // ======================================================
  // BAL AKIMI MERKEZİ + CACHE
  // ======================================================

  static final Map<String, Map<String, dynamic>?> _balAkimCache = {};

  static bool _balAkimAyariMi(String anahtar) {
    if (anahtar == 'bal_akim1_baslangic' ||
        anahtar == 'bal_akim1_bitis' ||
        anahtar == 'bal_akim2_aktif' ||
        anahtar == 'bal_akim2_baslangic' ||
        anahtar == 'bal_akim2_bitis') {
      return true;
    }

    return anahtar.startsWith('arilik_') &&
        (anahtar.endsWith('_bal_akim1_baslangic') ||
            anahtar.endsWith('_bal_akim1_bitis') ||
            anahtar.endsWith('_bal_akim2_aktif') ||
            anahtar.endsWith('_bal_akim2_baslangic') ||
            anahtar.endsWith('_bal_akim2_bitis'));
  }

  static void balAkimCacheTemizle({int? arilikId}) {
    if (arilikId != null && arilikId > 0) {
      _balAkimCache.remove('arilik_$arilikId');
      return;
    }
    _balAkimCache.clear();
  }

  static Future<String> _arilikAyariGetir({
    required int? arilikId,
    required String anahtar,
    required String varsayilan,
  }) async {
    if (arilikId != null && arilikId > 0) {
      final ozelAnahtar = 'arilik_${arilikId}_$anahtar';
      final ozelDeger = await ayarStringGetir(ozelAnahtar, varsayilan: '');
      if (ozelDeger.trim().isNotEmpty) return ozelDeger;
    }

    return ayarStringGetir(anahtar, varsayilan: varsayilan);
  }

  static Future<Map<String, dynamic>?> aktifBalAkimGetir({
    DateTime? tarih,
    int? arilikId,
  }) async {
    final cacheKey = (arilikId != null && arilikId > 0) ? 'arilik_$arilikId' : 'global';
    if (tarih == null && _balAkimCache.containsKey(cacheKey)) {
      return _balAkimCache[cacheKey];
    }

    final referans = tarih ?? DateTime.now();
    final yil = referans.year;
    final bugun = DateTime(referans.year, referans.month, referans.day);

    final balAkim1Bas = await _arilikAyariGetir(
      arilikId: arilikId,
      anahtar: 'bal_akim1_baslangic',
      varsayilan: varsayilanAyarDegeri('bal_akim1_baslangic'),
    );
    final balAkim1Bit = await _arilikAyariGetir(
      arilikId: arilikId,
      anahtar: 'bal_akim1_bitis',
      varsayilan: varsayilanAyarDegeri('bal_akim1_bitis'),
    );
    final balAkim2Aktif = await _arilikAyariGetir(
      arilikId: arilikId,
      anahtar: 'bal_akim2_aktif',
      varsayilan: varsayilanAyarDegeri('bal_akim2_aktif'),
    );
    final balAkim2Bas = await _arilikAyariGetir(
      arilikId: arilikId,
      anahtar: 'bal_akim2_baslangic',
      varsayilan: varsayilanAyarDegeri('bal_akim2_baslangic'),
    );
    final balAkim2Bit = await _arilikAyariGetir(
      arilikId: arilikId,
      anahtar: 'bal_akim2_bitis',
      varsayilan: varsayilanAyarDegeri('bal_akim2_bitis'),
    );

    DateTime? toDate(String s) {
      final temiz = s.trim();
      if (temiz.isEmpty) return null;
      final p = temiz.split('-');
      if (p.length != 2) return null;
      final ay = int.tryParse(p[0]);
      final gun = int.tryParse(p[1]);
      if (ay == null || gun == null) return null;
      return DateTime(yil, ay, gun);
    }

    final List<Map<String, dynamic>> adaylar = [];

    final a1b = toDate(balAkim1Bas);
    final a1e = toDate(balAkim1Bit);
    if (a1b != null && a1e != null && !a1e.isBefore(a1b)) {
      adaylar.add({
        'etiket': '1. bal akımı',
        'bas': a1b,
        'bit': a1e,
        'arilikId': arilikId,
      });
    }

    if (balAkim2Aktif == '1') {
      final a2b = toDate(balAkim2Bas);
      final a2e = toDate(balAkim2Bit);
      if (a2b != null && a2e != null && !a2e.isBefore(a2b)) {
        adaylar.add({
          'etiket': '2. bal akımı',
          'bas': a2b,
          'bit': a2e,
          'arilikId': arilikId,
        });
      }
    }

    adaylar.sort(
      (a, b) => (a['bas'] as DateTime).compareTo(b['bas'] as DateTime),
    );

    for (final akim in adaylar) {
      final bitis = akim['bit'];
      if (bitis is DateTime && !bugun.isAfter(bitis)) {
        if (tarih == null) _balAkimCache[cacheKey] = akim;
        return akim;
      }
    }

    if (tarih == null) _balAkimCache[cacheKey] = null;
    return null;
  }



  static Future<Map<String, dynamic>> suruplukKaldirmaPenceresiGetir(
    int koloniId, {
    DateTime? tarih,
  }) async {
    final referansHam = tarih ?? DateTime.now();
    final bugun = DateTime(
      referansHam.year,
      referansHam.month,
      referansHam.day,
    );

    final koloni = await koloniOzetiGetir(koloniId);
    final bool suruplukVarMi = _toInt(koloni['suruplukVarMi']) == 1;
    final int arilikId = _toInt(koloni['arilikId']);
    const int varsayilanGun = 20;

    final akimlar = await _balAkimAdaylariGetir(
      tarih: bugun,
      arilikId: arilikId > 0 ? arilikId : null,
    );

    for (final akim in akimlar) {
      final bas = akim['bas'];
      final bit = akim['bit'];
      if (bas is! DateTime || bit is! DateTime) continue;
      if (bugun.isAfter(bit)) continue;

      final pencereBaslangic = bas.subtract(const Duration(days: varsayilanGun));
      final kalanGun = bas.difference(bugun).inDays;
      final aktif = !bugun.isBefore(pencereBaslangic) && !bugun.isAfter(bit);
      final etiket = (akim['etiket'] ?? 'bal akımı').toString();

      if (aktif) {
        final mesaj = kalanGun >= 0
            ? '$etiket başlangıcına $kalanGun gün kaldı. Şeker kalıntısı riskini azaltmak için beslemeyi sonlandır; şurupluğu kaldırıp yerine petek verebilirsin.'
            : '$etiket dönemi içindesin. Şeker kalıntısı riskini azaltmak için besleme yapılmamalı; şurupluk kaldırılmış olmalı.';
        return {
          'aktif': true,
          'suruplukVarMi': true,
          'etiket': etiket,
          'gun': varsayilanGun,
          'kalanGun': kalanGun,
          'bas': bas,
          'bit': bit,
          'basMetni': _isoTarih(bas),
          'bitMetni': _isoTarih(bit),
          'mesaj': mesaj,
        };
      }

      return {
        'aktif': false,
        'suruplukVarMi': true,
        'etiket': etiket,
        'gun': varsayilanGun,
        'kalanGun': kalanGun,
        'bas': bas,
        'bit': bit,
        'basMetni': _isoTarih(bas),
        'bitMetni': _isoTarih(bit),
        'mesaj': '$etiket başlangıcına $kalanGun gün var. Şurupluk kaldırma uyarısı bal akımından $varsayilanGun gün önce açılır.',
      };
    }

    return {
      'aktif': false,
      'suruplukVarMi': true,
      'gun': varsayilanGun,
      'mesaj': 'Yaklaşan aktif bal akımı penceresi bulunmadı. Hasat sonrası besleme döneminde şurupluk yeniden kullanılabilir.',
    };
  }

  // ======================================================
  // KARAR ZAMAN BAĞLAMI
  // ======================================================

  /// Koloni karar motorunun kullandığı hafif zaman bağlamıdır.
  /// Yeni bir zaman motoru değildir; mevcut sezon ve bal akımı ayarlarını tek
  /// noktadan okuyup karar motoruna sade bir bağlam verir.
  static Future<Map<String, dynamic>> kararZamanBaglamiGetir({
    DateTime? tarih,
    int? arilikId,
  }) async {
    final referansHam = tarih ?? DateTime.now();
    final bugun = DateTime(
      referansHam.year,
      referansHam.month,
      referansHam.day,
    );

    final sezonKodu = await aktifSezonKoduGetir(bugun);
    final akimlar = await _balAkimAdaylariGetir(
      tarih: bugun,
      arilikId: arilikId,
    );

    Map<String, dynamic>? siradakiAkim;
    Map<String, dynamic>? icindeBulunulanAkim;
    Map<String, dynamic>? sonGecmisAkim;

    for (final akim in akimlar) {
      final bas = akim['bas'];
      final bit = akim['bit'];
      if (bas is! DateTime || bit is! DateTime) continue;

      if (!bugun.isBefore(bas) && !bugun.isAfter(bit)) {
        icindeBulunulanAkim = akim;
        siradakiAkim ??= akim;
      } else if (bugun.isBefore(bas)) {
        siradakiAkim ??= akim;
      } else if (bugun.isAfter(bit)) {
        sonGecmisAkim = akim;
      }
    }

    final DateTime? balAkimBaslangic =
        (siradakiAkim?['bas'] is DateTime) ? siradakiAkim!['bas'] as DateTime : null;
    final DateTime? balAkimBitis =
        (siradakiAkim?['bit'] is DateTime) ? siradakiAkim!['bit'] as DateTime : null;
    final DateTime? sonBalAkimBitis =
        (sonGecmisAkim?['bit'] is DateTime) ? sonGecmisAkim!['bit'] as DateTime : null;

    final int? balAkiminaKalanGun = balAkimBaslangic == null
        ? null
        : balAkimBaslangic.difference(bugun).inDays;

    final bool balAkiminda = icindeBulunulanAkim != null;
    final bool hasatSonrasi = sonBalAkimBitis != null && bugun.isAfter(sonBalAkimBitis);

    String bolmePenceresi;
    String bolmePencereMesaji;

    if (sezonKodu == 'kis') {
      bolmePenceresi = 'kapali';
      bolmePencereMesaji =
          'Kış döneminde bölme önerilmez. Koloni gücü korunmalı ve sezon planına alınmalıdır.';
    } else if (balAkiminda) {
      bolmePenceresi = 'bal_akiminda';
      bolmePencereMesaji =
          'Bal akımı içinde standart bölme önerilmez. Ancak bilinçli üretim stratejisinde yavru azaltma amaçlı özel bölme ayrıca değerlendirilebilir.';
    } else if (balAkiminaKalanGun != null && balAkiminaKalanGun >= 57) {
      bolmePenceresi = 'uygun';
      bolmePencereMesaji =
          'Bal akımına 57 günden fazla var. Güçlü kolonilerde bölme kararı saha açısından anlamlıdır.';
    } else if (balAkiminaKalanGun != null && balAkiminaKalanGun >= 0) {
      bolmePenceresi = 'gec';
      bolmePencereMesaji =
          'Bal akımına 57 günden az kaldı. Standart bölme geç kalmış sayılır; güçlü koloniyi eksiltmek üretim riskini artırır.';
    } else if (hasatSonrasi) {
      bolmePenceresi = 'hasat_sonrasi';
      bolmePencereMesaji =
          'Hasat sonrası ana gündem bölme değil; varroa, besleme, sıkıştırma ve kışa hazırlıktır.';
    } else {
      bolmePenceresi = 'kapali';
      bolmePencereMesaji =
          'Bu tarih aralığında standart bölme kararı güçlü görünmez. Sezon ve bal akımı takvimine göre yeniden değerlendirilmelidir.';
    }

    String anaDegisimPenceresi;
    String anaDegisimPencereMesaji;

    if (sezonKodu == 'kis') {
      anaDegisimPenceresi = 'kapali';
      anaDegisimPencereMesaji =
          'Kış döneminde ana değişimi önerilmez; gerekiyorsa sezon planına alınır.';
    } else if (hasatSonrasi) {
      anaDegisimPenceresi = 'uygun';
      anaDegisimPencereMesaji =
          'Hasat sonrası dönem ana değişimi için güçlü karar penceresidir. Yeni ana yıpranmadan yeni sezona girer.';
    } else if (balAkiminda || (balAkiminaKalanGun != null && balAkiminaKalanGun >= 0)) {
      anaDegisimPenceresi = 'zorunlu_degilse_ertele';
      anaDegisimPencereMesaji =
          'Bal akımı öncesi veya sırasında ana değişimi yalnızca zorunlu sorun varsa düşünülmelidir; planlı değişim hasat sonrasına bırakılmalıdır.';
    } else {
      anaDegisimPenceresi = 'planla';
      anaDegisimPencereMesaji =
          'Ana değişimi için karar sezon bağlamıyla birlikte izlenmeli; en güçlü pencere hasat sonrasıdır.';
    }

    return {
      'tarih': _isoTarih(bugun),
      'sezonKodu': sezonKodu,
      'balAkiminda': balAkiminda,
      'hasatSonrasi': hasatSonrasi,
      'balAkiminaKalanGun': balAkiminaKalanGun,
      'balAkimBaslangic': balAkimBaslangic == null ? null : _isoTarih(balAkimBaslangic),
      'balAkimBitis': balAkimBitis == null ? null : _isoTarih(balAkimBitis),
      'bolmePenceresi': bolmePenceresi,
      'bolmePencereMesaji': bolmePencereMesaji,
      'anaDegisimPenceresi': anaDegisimPenceresi,
      'anaDegisimPencereMesaji': anaDegisimPencereMesaji,
    };
  }

  static Future<List<Map<String, dynamic>>> _balAkimAdaylariGetir({
    required DateTime tarih,
    int? arilikId,
  }) async {
    final yil = tarih.year;

    final balAkim1Bas = await _arilikAyariGetir(
      arilikId: arilikId,
      anahtar: 'bal_akim1_baslangic',
      varsayilan: varsayilanAyarDegeri('bal_akim1_baslangic'),
    );
    final balAkim1Bit = await _arilikAyariGetir(
      arilikId: arilikId,
      anahtar: 'bal_akim1_bitis',
      varsayilan: varsayilanAyarDegeri('bal_akim1_bitis'),
    );
    final balAkim2Aktif = await _arilikAyariGetir(
      arilikId: arilikId,
      anahtar: 'bal_akim2_aktif',
      varsayilan: varsayilanAyarDegeri('bal_akim2_aktif'),
    );
    final balAkim2Bas = await _arilikAyariGetir(
      arilikId: arilikId,
      anahtar: 'bal_akim2_baslangic',
      varsayilan: varsayilanAyarDegeri('bal_akim2_baslangic'),
    );
    final balAkim2Bit = await _arilikAyariGetir(
      arilikId: arilikId,
      anahtar: 'bal_akim2_bitis',
      varsayilan: varsayilanAyarDegeri('bal_akim2_bitis'),
    );

    DateTime? toDate(String s) {
      final temiz = s.trim();
      if (temiz.isEmpty) return null;
      final p = temiz.split('-');
      if (p.length != 2) return null;
      final ay = int.tryParse(p[0]);
      final gun = int.tryParse(p[1]);
      if (ay == null || gun == null) return null;
      return DateTime(yil, ay, gun);
    }

    final List<Map<String, dynamic>> adaylar = [];

    final a1b = toDate(balAkim1Bas);
    final a1e = toDate(balAkim1Bit);
    if (a1b != null && a1e != null && !a1e.isBefore(a1b)) {
      adaylar.add({
        'etiket': '1. bal akımı',
        'bas': a1b,
        'bit': a1e,
        'arilikId': arilikId,
      });
    }

    if (balAkim2Aktif == '1') {
      final a2b = toDate(balAkim2Bas);
      final a2e = toDate(balAkim2Bit);
      if (a2b != null && a2e != null && !a2e.isBefore(a2b)) {
        adaylar.add({
          'etiket': '2. bal akımı',
          'bas': a2b,
          'bit': a2e,
          'arilikId': arilikId,
        });
      }
    }

    adaylar.sort(
      (a, b) => (a['bas'] as DateTime).compareTo(b['bas'] as DateTime),
    );

    return adaylar;
  }

  static String _isoTarih(DateTime tarih) {
    final yil = tarih.year.toString().padLeft(4, '0');
    final ay = tarih.month.toString().padLeft(2, '0');
    final gun = tarih.day.toString().padLeft(2, '0');
    return '$yil-$ay-$gun';
  }

}
