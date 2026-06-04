import 'veritabani_servisi.dart';

class SezonBiyolojiBilgisi {
  final String kod;
  final String ad;
  final String yavruBeklentisi;
  final String stokDurumu;
  final String polenAriEkmegi;
  final String anaAmac;
  final String aktivasyonEtiketi;
  final double aktivasyonKatsayisi;
  final double riskFreni;
  final bool balAkimiAktif;
  final bool balAkimiOncesiMi;
  final bool hasatSonrasiMi;
  final int? balAkiminaKalanGun;
  final int? balAkimindanSonraGecenGun;
  final String sahaMesaji;
  final List<String> gerekceler;

  const SezonBiyolojiBilgisi({
    required this.kod,
    required this.ad,
    required this.yavruBeklentisi,
    required this.stokDurumu,
    required this.polenAriEkmegi,
    required this.anaAmac,
    required this.aktivasyonEtiketi,
    required this.aktivasyonKatsayisi,
    required this.riskFreni,
    required this.balAkimiAktif,
    required this.balAkimiOncesiMi,
    required this.hasatSonrasiMi,
    this.balAkiminaKalanGun,
    this.balAkimindanSonraGecenGun,
    required this.sahaMesaji,
    required this.gerekceler,
  });

  Map<String, dynamic> toMap() {
    return {
      'kod': kod,
      'ad': ad,
      'yavruBeklentisi': yavruBeklentisi,
      'stokDurumu': stokDurumu,
      'polenAriEkmegi': polenAriEkmegi,
      'anaAmac': anaAmac,
      'aktivasyonEtiketi': aktivasyonEtiketi,
      'aktivasyonKatsayisi': aktivasyonKatsayisi,
      'riskFreni': riskFreni,
      'balAkimiAktif': balAkimiAktif,
      'balAkimiOncesiMi': balAkimiOncesiMi,
      'hasatSonrasiMi': hasatSonrasiMi,
      'balAkiminaKalanGun': balAkiminaKalanGun,
      'balAkimindanSonraGecenGun': balAkimindanSonraGecenGun,
      'sahaMesaji': sahaMesaji,
      'gerekceler': gerekceler,
    };
  }
}

class SezonBiyolojiMatrisi {
  static const int balAkimiOncesiHazirlikGun = 42;
  static const int hasatSonrasiPencereGun = 21;

  static Future<SezonBiyolojiBilgisi> bilgiGetir({
    DateTime? tarih,
    int? arilikId,
  }) async {
    final gun = _gun(tarih ?? DateTime.now());
    final balPencereleri = await _balAkimPencereleriGetir(
      yil: gun.year,
      arilikId: arilikId,
    );
    final balDurumu = _balAkimDurumu(gun, balPencereleri);

    final String sezonKodu = _sezonKoduBelirle(gun, balDurumu);
    final temel = _temelBilgi(sezonKodu);
    final gerekceler = <String>[];

    if (balDurumu.aktif) {
      gerekceler.add('Bal akımı penceresi aktif.');
    } else if (balDurumu.kalanGun != null &&
        balDurumu.kalanGun! <= balAkimiOncesiHazirlikGun) {
      gerekceler.add('Bal akımına ${balDurumu.kalanGun} gün kaldı.');
    } else if (balDurumu.sonraGecenGun != null &&
        balDurumu.sonraGecenGun! <= hasatSonrasiPencereGun) {
      gerekceler.add('Bal akımı bitiminden sonra ${balDurumu.sonraGecenGun} gün geçti.');
    }
    gerekceler.add(temel['gerekce']!.toString());

    return SezonBiyolojiBilgisi(
      kod: sezonKodu,
      ad: temel['ad']!.toString(),
      yavruBeklentisi: temel['yavruBeklentisi']!.toString(),
      stokDurumu: temel['stokDurumu']!.toString(),
      polenAriEkmegi: temel['polenAriEkmegi']!.toString(),
      anaAmac: temel['anaAmac']!.toString(),
      aktivasyonEtiketi: temel['aktivasyonEtiketi']!.toString(),
      aktivasyonKatsayisi: temel['aktivasyonKatsayisi']! as double,
      riskFreni: temel['riskFreni']! as double,
      balAkimiAktif: balDurumu.aktif,
      balAkimiOncesiMi: sezonKodu == 'bal_akimi_oncesi',
      hasatSonrasiMi: sezonKodu == 'hasat_sonrasi',
      balAkiminaKalanGun: balDurumu.kalanGun,
      balAkimindanSonraGecenGun: balDurumu.sonraGecenGun,
      sahaMesaji: temel['sahaMesaji']!.toString(),
      gerekceler: gerekceler,
    );
  }

  static SezonBiyolojiBilgisi varsayilanBilgi([DateTime? tarih]) {
    final gun = _gun(tarih ?? DateTime.now());
    final kod = _mevsimselKod(gun);
    final temel = _temelBilgi(kod);
    return SezonBiyolojiBilgisi(
      kod: kod,
      ad: temel['ad']!.toString(),
      yavruBeklentisi: temel['yavruBeklentisi']!.toString(),
      stokDurumu: temel['stokDurumu']!.toString(),
      polenAriEkmegi: temel['polenAriEkmegi']!.toString(),
      anaAmac: temel['anaAmac']!.toString(),
      aktivasyonEtiketi: temel['aktivasyonEtiketi']!.toString(),
      aktivasyonKatsayisi: temel['aktivasyonKatsayisi']! as double,
      riskFreni: temel['riskFreni']! as double,
      balAkimiAktif: false,
      balAkimiOncesiMi: kod == 'bal_akimi_oncesi',
      hasatSonrasiMi: kod == 'hasat_sonrasi',
      sahaMesaji: temel['sahaMesaji']!.toString(),
      gerekceler: [temel['gerekce']!.toString()],
    );
  }

  static Map<String, dynamic> varsayilanMap([DateTime? tarih]) {
    return varsayilanBilgi(tarih).toMap();
  }

  static String _sezonKoduBelirle(DateTime gun, _BalAkimDurumu balDurumu) {
    if (balDurumu.aktif) return 'bal_akimi';
    if (balDurumu.kalanGun != null &&
        balDurumu.kalanGun! > 0 &&
        balDurumu.kalanGun! <= balAkimiOncesiHazirlikGun) {
      return 'bal_akimi_oncesi';
    }
    if (balDurumu.sonraGecenGun != null &&
        balDurumu.sonraGecenGun! >= 0 &&
        balDurumu.sonraGecenGun! <= hasatSonrasiPencereGun) {
      return 'hasat_sonrasi';
    }
    return _mevsimselKod(gun);
  }

  static String _mevsimselKod(DateTime gun) {
    final ay = gun.month;
    final gunNo = gun.day;

    if (ay == 12 || ay == 1 || ay == 2) return 'kis';
    if (ay == 3) return gunNo <= 15 ? 'kis_cikisi' : 'ilkbahar_gelisim';
    if (ay == 4) return 'ilkbahar_gelisim';
    if (ay == 5) return 'bal_akimi_oncesi';
    if (ay == 6) return 'bal_akimi';
    if (ay == 7 || ay == 8) return 'hasat_sonrasi';
    if (ay == 9 || ay == 10) return 'sonbahar_hazirlik';
    return 'gec_sonbahar';
  }

  static Map<String, Object> _temelBilgi(String kod) {
    switch (kod) {
      case 'kis':
        return {
          'ad': 'Kış',
          'yavruBeklentisi': 'çok düşük / yok',
          'stokDurumu': 'yüksek stok gerekir',
          'polenAriEkmegi': 'düşük',
          'anaAmac': 'yaşama ve sıkı küme düzeni',
          'aktivasyonEtiketi': 'çok düşük',
          'aktivasyonKatsayisi': 0.20,
          'riskFreni': 0.75,
          'sahaMesaji': 'Koloni büyütülmez; stok, nem ve sıkışık düzen önceliklidir.',
          'gerekce': 'Kış döneminde biyolojik genişleme sınırlıdır.',
        };
      case 'kis_cikisi':
        return {
          'ad': 'Kış Çıkışı',
          'yavruBeklentisi': 'artan',
          'stokDurumu': 'kritik takip',
          'polenAriEkmegi': 'artan',
          'anaAmac': 'açlık riski ve kontrollü gelişim',
          'aktivasyonEtiketi': 'düşük / orta',
          'aktivasyonKatsayisi': 0.60,
          'riskFreni': 0.90,
          'sahaMesaji': 'Koloni desteklenebilir; ani genişletme hâlâ risklidir.',
          'gerekce': 'Kış çıkışında yavru başlar ama iş gücü henüz tam açılmamıştır.',
        };
      case 'ilkbahar_gelisim':
        return {
          'ad': 'İlkbahar Gelişimi',
          'yavruBeklentisi': 'yüksek',
          'stokDurumu': 'tüketim yüksek',
          'polenAriEkmegi': 'yüksek',
          'anaAmac': 'güçlü ve dengeli büyüme',
          'aktivasyonEtiketi': 'yüksek',
          'aktivasyonKatsayisi': 1.20,
          'riskFreni': 1.00,
          'sahaMesaji': 'Genişleme ve yavru desteği değerlendirilebilir; koloni kapasitesi aşılmamalıdır.',
          'gerekce': 'İlkbaharda yavru ve genç işçi kapasitesi artar.',
        };
      case 'bal_akimi_oncesi':
        return {
          'ad': 'Bal Akımı Öncesi',
          'yavruBeklentisi': 'yüksek',
          'stokDurumu': 'hazırlık',
          'polenAriEkmegi': 'yüksek',
          'anaAmac': 'üretime hazırlık',
          'aktivasyonEtiketi': 'yüksek',
          'aktivasyonKatsayisi': 1.35,
          'riskFreni': 1.00,
          'sahaMesaji': 'Alan, şurupluk, besleme kesimi ve üretim hazırlığı birlikte okunmalıdır.',
          'gerekce': 'Bal akımı öncesi koloni üretim kapasitesine hazırlanır.',
        };
      case 'bal_akimi':
        return {
          'ad': 'Bal Akımı',
          'yavruBeklentisi': 'orta / dengeli',
          'stokDurumu': 'bal alanı hızlı dolar',
          'polenAriEkmegi': 'orta',
          'anaAmac': 'üretim ve bal kalitesi',
          'aktivasyonEtiketi': 'çok yüksek',
          'aktivasyonKatsayisi': 1.50,
          'riskFreni': 1.00,
          'sahaMesaji': 'Besleme baskılanır; üretim alanı, bal işleme ve hasat güvenliği öne çıkar.',
          'gerekce': 'Bal akımı döneminde nektar ve petek kullanım hızı en yüksek seviyededir.',
        };
      case 'hasat_sonrasi':
        return {
          'ad': 'Hasat Sonrası',
          'yavruBeklentisi': 'azalan',
          'stokDurumu': 'yeniden kurulum',
          'polenAriEkmegi': 'orta',
          'anaAmac': 'toparlanma ve denge',
          'aktivasyonEtiketi': 'orta',
          'aktivasyonKatsayisi': 0.90,
          'riskFreni': 0.92,
          'sahaMesaji': 'Hasat kaynaklı çıta düşüşü çöküş sayılmaz; koloni dengeye dönüş açısından izlenir.',
          'gerekce': 'Hasat sonrası biyolojik yön yeniden kurulum ve toparlanmadır.',
        };
      case 'sonbahar_hazirlik':
        return {
          'ad': 'Sonbahar Hazırlık',
          'yavruBeklentisi': 'orta',
          'stokDurumu': 'yüksek stok hedefi',
          'polenAriEkmegi': 'yüksek',
          'anaAmac': 'kış arısı ve stok hazırlığı',
          'aktivasyonEtiketi': 'orta',
          'aktivasyonKatsayisi': 0.75,
          'riskFreni': 0.85,
          'sahaMesaji': 'Kış arısı, stok, varroa ve daraltma kararları birlikte okunmalıdır.',
          'gerekce': 'Sonbaharda üretimden çok kışa sağlam giriş önemlidir.',
        };
      case 'gec_sonbahar':
      default:
        return {
          'ad': 'Geç Sonbahar',
          'yavruBeklentisi': 'düşük',
          'stokDurumu': 'yüksek stok korunmalı',
          'polenAriEkmegi': 'orta / düşük',
          'anaAmac': 'daralma ve kış düzeni',
          'aktivasyonEtiketi': 'düşük',
          'aktivasyonKatsayisi': 0.40,
          'riskFreni': 0.80,
          'sahaMesaji': 'Genişletme yapılmaz; hacim, stok ve savunma dengesi korunur.',
          'gerekce': 'Geç sonbaharda biyolojik genişleme düşer, kış düzeni öne çıkar.',
        };
    }
  }

  static Future<List<_BalAkimPenceresi>> _balAkimPencereleriGetir({
    required int yil,
    int? arilikId,
  }) async {
    final pencereler = <_BalAkimPenceresi>[];

    Future<String> ayar(String anahtar) {
      return VeritabaniServisi.kalibrasyonAyarGetir(
        anahtar,
        arilikId: arilikId,
      );
    }

    final bas1 = await ayar('bal_akim1_baslangic');
    final bit1 = await ayar('bal_akim1_bitis');
    final p1 = _pencereOlustur('bal_akim1', bas1, bit1, yil);
    if (p1 != null) pencereler.add(p1);

    final ikinciAktif = (await ayar('bal_akim2_aktif')).trim() == '1';
    if (ikinciAktif) {
      final bas2 = await ayar('bal_akim2_baslangic');
      final bit2 = await ayar('bal_akim2_bitis');
      final p2 = _pencereOlustur('bal_akim2', bas2, bit2, yil);
      if (p2 != null) pencereler.add(p2);
    }

    return pencereler;
  }

  static _BalAkimPenceresi? _pencereOlustur(
    String kod,
    String basMmDd,
    String bitMmDd,
    int yil,
  ) {
    final bas = _ayGunToDate(yil, basMmDd);
    final bit = _ayGunToDate(yil, bitMmDd);
    if (bas == null || bit == null) return null;
    final duzeltilmisBit = bit.isBefore(bas) ? DateTime(yil + 1, bit.month, bit.day) : bit;
    return _BalAkimPenceresi(kod: kod, baslangic: bas, bitis: duzeltilmisBit);
  }

  static _BalAkimDurumu _balAkimDurumu(
    DateTime gun,
    List<_BalAkimPenceresi> pencereler,
  ) {
    bool aktif = false;
    int? kalanGun;
    int? sonraGecenGun;

    for (final p in pencereler) {
      if (!gun.isBefore(p.baslangic) && !gun.isAfter(p.bitis)) {
        aktif = true;
      }
      if (gun.isBefore(p.baslangic)) {
        final fark = p.baslangic.difference(gun).inDays;
        if (kalanGun == null || fark < kalanGun) kalanGun = fark;
      }
      if (gun.isAfter(p.bitis)) {
        final fark = gun.difference(p.bitis).inDays;
        if (sonraGecenGun == null || fark < sonraGecenGun) {
          sonraGecenGun = fark;
        }
      }
    }

    return _BalAkimDurumu(
      aktif: aktif,
      kalanGun: kalanGun,
      sonraGecenGun: sonraGecenGun,
    );
  }

  static DateTime? _ayGunToDate(int yil, String mmDd) {
    final temiz = mmDd.trim();
    if (temiz.isEmpty || !temiz.contains('-')) return null;
    final parcalar = temiz.split('-');
    if (parcalar.length != 2) return null;
    final ay = int.tryParse(parcalar[0]);
    final gun = int.tryParse(parcalar[1]);
    if (ay == null || gun == null) return null;
    if (ay < 1 || ay > 12 || gun < 1 || gun > 31) return null;
    return DateTime(yil, ay, gun);
  }

  static DateTime _gun(DateTime tarih) {
    return DateTime(tarih.year, tarih.month, tarih.day);
  }
}

class _BalAkimPenceresi {
  final String kod;
  final DateTime baslangic;
  final DateTime bitis;

  const _BalAkimPenceresi({
    required this.kod,
    required this.baslangic,
    required this.bitis,
  });
}

class _BalAkimDurumu {
  final bool aktif;
  final int? kalanGun;
  final int? sonraGecenGun;

  const _BalAkimDurumu({
    required this.aktif,
    this.kalanGun,
    this.sonraGecenGun,
  });
}
