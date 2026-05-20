import 'dart:math' as math;

class CitaAktivasyonServisi {
  static const String petekTipiTemel = 'Temel petek';
  static const String petekTipiKabarmis = 'Kabarmış petek';
  static const String petekTipiKarisik = 'Karışık petek';
  static const String petekTipiBalli = 'Ballı/stoklu petek';
  static const String petekTipiYavrulu = 'Yavrulu destek çıtası';

  static const String hacimTipiYok = 'yok';
  static const String hacimTipiKuluclukGenislemesi = 'kulucluk_genislemesi';
  static const String hacimTipiKatGecisi = 'kat_gecisi';
  static const String hacimTipiBallikUretimGenislemesi = 'ballik_uretim_genislemesi';
  static const String hacimTipiRiskliHizliGenisleme = 'riskli_hizli_genisleme';
  static const String hacimTipiHasatKaynakliDusus = 'hasat_kaynakli_dusus';
  static const String hacimTipiBiyolojikZayiflamaSuphesi = 'biyolojik_zayiflama_suphesi';

  static Map<String, dynamic> hesapla({
    required Map<String, dynamic>? sonMuayene,
    required Map<String, dynamic>? oncekiMuayene,
    Map<String, dynamic>? trend,
    Map<String, dynamic>? suruplukPenceresi,
    bool balAkimiAktif = false,
    bool hasatSonrasiSurec = false,
    double? sezonKatsayisi,
  }) {
    final int fizikselCita = _pozitifInt(sonMuayene?['citaSayisi']);
    final int oncekiCita = _pozitifInt(oncekiMuayene?['citaSayisi']);
    final int yavruluCita = _pozitifInt(sonMuayene?['yavruluCita']);
    final int balCita = _pozitifInt(sonMuayene?['bal_cita']);
    final String yavruDuzeni =
        (sonMuayene?['yavruDuzeni'] ?? '').toString().trim();
    final int kayitliTemelPetek = _pozitifInt(sonMuayene?['eklenenTemelPetek']);
    final int kayitliKabarmisPetek =
        _pozitifInt(sonMuayene?['eklenenKabarmisPetek']);
    final String petekTipi =
        _petekTipiNormalize(sonMuayene?['eklenenPetekTipi']);
    final DateTime? sonTarih = _tarihParse(sonMuayene?['tarih']);
    final DateTime? oncekiTarih = _tarihParse(oncekiMuayene?['tarih']);

    if (fizikselCita <= 0) {
      return _sonuc(
        fizikselCita: fizikselCita,
        oncekiCita: oncekiCita,
        eklenenCita: 0,
        gecenGun: 0,
        aktivasyonSuresiGun: 0,
        aktivasyonOrani: 1.0,
        islevselCitaMin: 0,
        islevselCitaMax: 0,
        petekTipi: petekTipi,
        aniArtisVar: false,
        katGecisiVar: false,
        uyariSeviyesi: 'yok',
        mesaj: 'Çıta verisi yok.',
      );
    }

    if (oncekiCita <= 0 || oncekiMuayene == null) {
      return _sonuc(
        fizikselCita: fizikselCita,
        oncekiCita: oncekiCita,
        eklenenCita: 0,
        gecenGun: 0,
        aktivasyonSuresiGun: 0,
        aktivasyonOrani: 1.0,
        islevselCitaMin: fizikselCita.toDouble(),
        islevselCitaMax: fizikselCita.toDouble(),
        petekTipi: petekTipi,
        aniArtisVar: false,
        katGecisiVar: fizikselCita >= 11,
        uyariSeviyesi: 'yok',
        mesaj:
            'İlk/başlangıç kaydı sıkışık düzen kabulüyle mevcut kapasite olarak okunur.',
      );
    }

    final int citaDegisimi = fizikselCita - oncekiCita;
    final int eklenenCita = math.max(0, citaDegisimi);
    final int azalanCita = math.max(0, -citaDegisimi);
    final bool kayittaBalHasatVar = balCita > 0 || hasatSonrasiSurec;

    if (azalanCita > 0) {
      final bool hasatKaynakliDusus = kayittaBalHasatVar && azalanCita >= 1;
      final bool biyolojikZayiflamaSuphesi = !hasatKaynakliDusus && azalanCita >= 2;
      final String hacimDegisimTipi = hasatKaynakliDusus
          ? hacimTipiHasatKaynakliDusus
          : (biyolojikZayiflamaSuphesi
              ? hacimTipiBiyolojikZayiflamaSuphesi
              : hacimTipiYok);
      final String seviye = biyolojikZayiflamaSuphesi ? 'uyari' : 'yok';
      final String mesaj = hasatKaynakliDusus
          ? 'Son muayeneye göre $azalanCita çıta düşüş var. Bal/hasat kaydı bulunduğu için bu düşüş biyolojik zayıflama değil, hasat kaynaklı hacim daralması olarak okunur.'
          : (biyolojikZayiflamaSuphesi
              ? 'Son muayeneye göre $azalanCita çıta düşüş var. Hasat kaydı görünmediği için sistem bunu biyolojik zayıflama şüphesiyle izler.'
              : 'Çıta sayısında küçük düşüş var; mevcut kapasite güncel fiziksel hacimden okunur.');
      return _sonuc(
        fizikselCita: fizikselCita,
        oncekiCita: oncekiCita,
        eklenenCita: 0,
        azalanCita: azalanCita,
        gecenGun: _gunFarki(oncekiTarih, sonTarih),
        aktivasyonSuresiGun: 0,
        aktivasyonOrani: 1.0,
        islevselCitaMin: fizikselCita.toDouble(),
        islevselCitaMax: fizikselCita.toDouble(),
        petekTipi: petekTipi,
        aniArtisVar: false,
        katGecisiVar: fizikselCita >= 11,
        hacimDegisimTipi: hacimDegisimTipi,
        uretimGuvenliMi: !biyolojikZayiflamaSuphesi,
        balAkimiGenislemesi: false,
        hasatKaynakliDusus: hasatKaynakliDusus,
        riskliSisirme: biyolojikZayiflamaSuphesi,
        uyariSeviyesi: seviye,
        mesaj: mesaj,
      );
    }

    final _PetekDagilimi petekDagilimi = _petekDagilimiOlustur(
      eklenenCita: eklenenCita,
      kayitliTemel: kayitliTemelPetek,
      kayitliKabarmis: kayitliKabarmisPetek,
      fallbackTip: petekTipi,
    );
    if (eklenenCita <= 0) {
      return _sonuc(
        fizikselCita: fizikselCita,
        oncekiCita: oncekiCita,
        eklenenCita: 0,
        gecenGun: _gunFarki(oncekiTarih, sonTarih),
        aktivasyonSuresiGun: 0,
        aktivasyonOrani: 1.0,
        islevselCitaMin: fizikselCita.toDouble(),
        islevselCitaMax: fizikselCita.toDouble(),
        petekTipi: petekTipi,
        aniArtisVar: false,
        katGecisiVar: fizikselCita >= 11,
        hacimDegisimTipi: hacimTipiYok,
        uretimGuvenliMi: true,
        uyariSeviyesi: 'yok',
        mesaj: 'Yeni hacim artışı yok; mevcut çıta sayısı doğrudan okunur.',
      );
    }

    final int gecenGun = math.max(0, _gunFarki(oncekiTarih, sonTarih));
    final bool katGecisiVar = oncekiCita >= 9 && fizikselCita >= 11;
    final bool ballikSonrasiGenisleme = oncekiCita >= 11 && fizikselCita > oncekiCita;
    // Aktivasyon süresi hesaplanırken henüz sağlıklı bal akımı genişlemesi
    // sınıflaması oluşmamıştır. Bu nedenle burada yalnızca ham hızlı artış
    // sinyali kullanılır; nihai aniArtisVar aşağıda riskliSisirme üzerinden
    // belirlenir.
    final bool hamHizliArtisVar = eklenenCita >= 3 && !katGecisiVar;
    final _AktivasyonDinamikleri aktivasyonDinamikleri =
        _aktivasyonDinamikleriHesapla(
      oncekiCita: oncekiCita,
      fizikselCita: fizikselCita,
      eklenenCita: eklenenCita,
      yavruluCita: yavruluCita,
      balCita: balCita,
      yavruDuzeni: yavruDuzeni,
      trend: trend,
      balAkimiAktif: balAkimiAktif,
      sezonKatsayisi: sezonKatsayisi,
      katGecisiVar: katGecisiVar,
      aniArtisVar: hamHizliArtisVar,
    );
    final int aktivasyonSuresi = _aktivasyonSuresiGun(
      petekTipi: petekDagilimi.ozetTip,
      temelPetekAdedi: petekDagilimi.temel,
      kabarmisPetekAdedi: petekDagilimi.kabarmis,
      oncekiCita: oncekiCita,
      fizikselCita: fizikselCita,
      eklenenCita: eklenenCita,
      yavruluCita: yavruluCita,
      balCita: balCita,
      yavruDuzeni: yavruDuzeni,
      trend: trend,
      suruplukPenceresi: suruplukPenceresi,
      balAkimiAktif: balAkimiAktif,
      sezonKatsayisi: sezonKatsayisi,
      katGecisiVar: katGecisiVar,
      aniArtisVar: hamHizliArtisVar,
      aktivasyonDinamikleri: aktivasyonDinamikleri,
    );

    final double oran = aktivasyonSuresi <= 0
        ? 1.0
        : (gecenGun / aktivasyonSuresi).clamp(0.0, 1.0).toDouble();
    final double belirsizlik = eklenenCita >= 3 ? 0.12 : 0.08;
    final double oranMin = (oran - belirsizlik).clamp(0.0, 1.0).toDouble();
    final double oranMax = (oran + belirsizlik).clamp(0.0, 1.0).toDouble();
    final double islevselMin = math.min(
      fizikselCita.toDouble(),
      oncekiCita + eklenenCita * oranMin,
    );
    final double islevselMax = math.min(
      fizikselCita.toDouble(),
      oncekiCita + eklenenCita * oranMax,
    );

    final bool aktivasyonSaglikli = oran >= 0.70 || islevselMax >= fizikselCita - 0.5;
    final bool balAkimiGenislemesi =
        ballikSonrasiGenisleme && balAkimiAktif && aktivasyonSaglikli;
    final bool riskliSisirme =
        eklenenCita >= 3 && !katGecisiVar && !balAkimiGenislemesi;
    final bool aniArtisVar = riskliSisirme;
    final String hacimDegisimTipi = katGecisiVar
        ? hacimTipiKatGecisi
        : (balAkimiGenislemesi
            ? hacimTipiBallikUretimGenislemesi
            : (riskliSisirme
                ? hacimTipiRiskliHizliGenisleme
                : hacimTipiKuluclukGenislemesi));
    final bool uretimGuvenliMi =
        balAkimiGenislemesi || (!riskliSisirme && aktivasyonSaglikli);
    final String uyariSeviyesi = riskliSisirme
        ? 'kritik'
        : (katGecisiVar || balAkimiGenislemesi
            ? 'not'
            : (eklenenCita >= 2 ? 'uyari' : 'not'));

    final String mesaj;
    if (riskliSisirme) {
      mesaj = balAkimiAktif
          ? 'Son muayeneye göre $eklenenCita çıta artış var. Bal akımı içinde olsa bile aktivasyon sağlıklı görünmediği için sistem yeni hacmi temkinli okur.'
          : 'Son muayeneye göre $eklenenCita çıta artış var. Bal akımı dışında hızlı genişleme olduğu için sistem yeni hacmin tamamını hemen üretim gücü saymaz.';
    } else if (katGecisiVar) {
      mesaj =
          'Koloni 9–10 çıta eşiğinden 11+ çıtaya çıktığı için kat/ballık geçişi kabul edildi. Yeni üst hacim kademeli aktive edilir.';
    } else if (balAkimiGenislemesi) {
      mesaj =
          'Kat sonrası bal akımı içinde sağlıklı üretim genişlemesi görülüyor. Hızlı üst hacim artışı bu bağlamda normalleştirildi.';
    } else if (eklenenCita >= 2) {
      mesaj =
          'Son muayeneye göre $eklenenCita çıta artış var. Muayene aralığı ve koloni gücü dikkate alınarak kontrollü genişleme kabul edilir.';
    } else {
      mesaj =
          'Yeni verilen çıta kademeli olarak işlevsel kapasiteye dahil edilir.';
    }

    return _sonuc(
      fizikselCita: fizikselCita,
      oncekiCita: oncekiCita,
      eklenenCita: eklenenCita,
      gecenGun: gecenGun,
      aktivasyonSuresiGun: aktivasyonSuresi,
      aktivasyonOrani: oran,
      islevselCitaMin: islevselMin,
      islevselCitaMax: islevselMax,
      petekTipi: petekDagilimi.ozetTip,
      temelPetekAdedi: petekDagilimi.temel,
      kabarmisPetekAdedi: petekDagilimi.kabarmis,
      aniArtisVar: aniArtisVar,
      katGecisiVar: katGecisiVar,
      hacimDegisimTipi: hacimDegisimTipi,
      uretimGuvenliMi: uretimGuvenliMi,
      balAkimiGenislemesi: balAkimiGenislemesi,
      hasatKaynakliDusus: false,
      riskliSisirme: riskliSisirme,
      aktivasyonDinamikleri: aktivasyonDinamikleri,
      uyariSeviyesi: uyariSeviyesi,
      mesaj: mesaj,
    );
  }

  static int _aktivasyonSuresiGun({
    required String petekTipi,
    required int temelPetekAdedi,
    required int kabarmisPetekAdedi,
    required int oncekiCita,
    required int fizikselCita,
    required int eklenenCita,
    required int yavruluCita,
    required int balCita,
    required String yavruDuzeni,
    required Map<String, dynamic>? trend,
    required Map<String, dynamic>? suruplukPenceresi,
    required bool balAkimiAktif,
    double? sezonKatsayisi,
    required bool katGecisiVar,
    required bool aniArtisVar,
    required _AktivasyonDinamikleri aktivasyonDinamikleri,
  }) {
    int gun;
    final int toplamPetek = temelPetekAdedi + kabarmisPetekAdedi;
    if (toplamPetek > 0) {
      final int toplamGun = (temelPetekAdedi * 24) + (kabarmisPetekAdedi * 9);
      gun = (toplamGun / toplamPetek).round();
    } else {
      switch (petekTipi) {
        case petekTipiKabarmis:
          gun = 9;
          break;
        case petekTipiBalli:
          gun = 4;
          break;
        case petekTipiYavrulu:
          gun = 3;
          break;
        case petekTipiTemel:
        default:
          gun = 24;
          break;
      }
    }

    final String duzen = yavruDuzeni.toLowerCase();
    final double momentum = _toDouble(trend?['gunlukMomentum']);
    final String momentumEtiketi =
        (trend?['momentumEtiketi'] ?? '').toString().toLowerCase();
    final bool balAkimiPenceresi = balAkimiAktif;

    if (oncekiCita >= 8) gun -= 2;
    if (yavruluCita >= 5) gun -= 2;
    if (duzen.contains('blok')) gun -= 2;
    if (duzen.contains('normal')) gun -= 1;
    if (balAkimiPenceresi || balCita > 0) gun -= 2;
    if (momentum > 0.08 ||
        momentumEtiketi.contains('güç') ||
        momentumEtiketi.contains('iyi')) gun -= 2;
    if (katGecisiVar) gun += 2;
    if (aniArtisVar) gun += 5;
    if (eklenenCita >= 5) gun += 3;
    if (duzen.contains('dağınık') ||
        duzen.contains('daginik') ||
        duzen.contains('kambur')) gun += 4;
    if (oncekiCita <= 5 && eklenenCita >= 2) gun += 3;

    final double dinamikSure = gun / aktivasyonDinamikleri.toplamKatsayi;
    final int altSinir = petekTipi == petekTipiYavrulu || petekTipi == petekTipiBalli ? 2 : 3;
    final int ustSinir = petekTipi == petekTipiTemel ? 36 : 28;
    return dinamikSure.round().clamp(altSinir, ustSinir).toInt();
  }

  static _AktivasyonDinamikleri _aktivasyonDinamikleriHesapla({
    required int oncekiCita,
    required int fizikselCita,
    required int eklenenCita,
    required int yavruluCita,
    required int balCita,
    required String yavruDuzeni,
    required Map<String, dynamic>? trend,
    required bool balAkimiAktif,
    double? sezonKatsayisi,
    required bool katGecisiVar,
    required bool aniArtisVar,
  }) {
    // Hacim artışı sonrası yeni çıtaları hemen tam güç saymak sistemi yanıltır.
    // Bu nedenle koloni gücü, genişleme öncesindeki taşıyıcı arı hacminden okunur.
    final int tasiyiciCita = oncekiCita > 0 ? oncekiCita : fizikselCita;
    final String duzen = yavruDuzeni.toLowerCase();
    final double momentum = _toDouble(trend?['gunlukMomentum']);
    final String momentumEtiketi =
        (trend?['momentumEtiketi'] ?? '').toString().toLowerCase();

    double koloniGucu;
    if (tasiyiciCita <= 2) {
      koloniGucu = 0.55;
    } else if (tasiyiciCita <= 4) {
      koloniGucu = 0.75;
    } else if (tasiyiciCita <= 6) {
      koloniGucu = 1.00;
    } else if (tasiyiciCita <= 8) {
      koloniGucu = 1.18;
    } else if (tasiyiciCita <= 10) {
      koloniGucu = 1.32;
    } else {
      koloniGucu = 1.45;
    }

    double gencIsci;
    if (yavruluCita <= 0) {
      gencIsci = 0.75;
    } else if (yavruluCita <= 2) {
      gencIsci = 0.90;
    } else if (yavruluCita <= 4) {
      gencIsci = 1.05;
    } else {
      gencIsci = 1.20;
    }
    if (duzen.contains('blok')) gencIsci += 0.05;
    if (duzen.contains('dağınık') ||
        duzen.contains('daginik') ||
        duzen.contains('kambur') ||
        duzen.contains('yok')) {
      gencIsci -= 0.15;
    }
    gencIsci = gencIsci.clamp(0.65, 1.25).toDouble();

    double sezon;
    if (sezonKatsayisi != null && sezonKatsayisi > 0) {
      sezon = sezonKatsayisi.clamp(0.20, 1.50).toDouble();
    } else if (balAkimiAktif) {
      sezon = 1.35;
    } else if (balCita > 0) {
      sezon = 1.12;
    } else {
      sezon = 1.00;
    }

    double trendKatsayisi = 1.00;
    if (momentum > 0.08 ||
        momentumEtiketi.contains('güç') ||
        momentumEtiketi.contains('iyi')) {
      trendKatsayisi = 1.10;
    } else if (momentum < -0.04 ||
        momentumEtiketi.contains('zayıf') ||
        momentumEtiketi.contains('zayif') ||
        momentumEtiketi.contains('düş') ||
        momentumEtiketi.contains('dus')) {
      trendKatsayisi = 0.85;
    }

    double riskFreni = 1.00;
    if (aniArtisVar) riskFreni *= 0.80;
    if (katGecisiVar) riskFreni *= 0.92;
    if (tasiyiciCita <= 5 && eklenenCita >= 2) riskFreni *= 0.82;
    if (eklenenCita >= 5) riskFreni *= 0.88;
    if (duzen.contains('dağınık') ||
        duzen.contains('daginik') ||
        duzen.contains('kambur') ||
        duzen.contains('yok')) {
      riskFreni *= 0.85;
    }
    riskFreni = riskFreni.clamp(0.55, 1.00).toDouble();

    final double toplam =
        (koloniGucu * gencIsci * sezon * trendKatsayisi * riskFreni)
            .clamp(0.45, 1.65)
            .toDouble();

    return _AktivasyonDinamikleri(
      koloniGucuKatsayisi: koloniGucu,
      gencIsciKatsayisi: gencIsci,
      sezonKatsayisi: sezon,
      trendKatsayisi: trendKatsayisi,
      riskFreni: riskFreni,
      toplamKatsayi: toplam,
    );
  }

  static Map<String, dynamic> _sonuc({
    required int fizikselCita,
    required int oncekiCita,
    required int eklenenCita,
    int azalanCita = 0,
    required int gecenGun,
    required int aktivasyonSuresiGun,
    required double aktivasyonOrani,
    required double islevselCitaMin,
    required double islevselCitaMax,
    required String petekTipi,
    int temelPetekAdedi = 0,
    int kabarmisPetekAdedi = 0,
    required bool aniArtisVar,
    required bool katGecisiVar,
    String hacimDegisimTipi = hacimTipiYok,
    bool uretimGuvenliMi = true,
    bool balAkimiGenislemesi = false,
    bool hasatKaynakliDusus = false,
    bool riskliSisirme = false,
    _AktivasyonDinamikleri? aktivasyonDinamikleri,
    required String uyariSeviyesi,
    required String mesaj,
  }) {
    final double orta = ((islevselCitaMin + islevselCitaMax) / 2)
        .clamp(0.0, fizikselCita.toDouble())
        .toDouble();
    final double toplamHacimAktivasyonOrani = fizikselCita <= 0
        ? 1.0
        : (orta / fizikselCita).clamp(0.0, 1.0).toDouble();
    final int toplamHacimAktivasyonYuzde =
        (toplamHacimAktivasyonOrani * 100).round().clamp(0, 100).toInt();
    final int yeniHacimAktivasyonYuzde =
        (aktivasyonOrani.clamp(0.0, 1.0) * 100).round().clamp(0, 100).toInt();
    final String ozet;
    if (eklenenCita <= 0) {
      ozet = mesaj;
    } else {
      ozet =
          '$fizikselCita fiziksel çıtanın yaklaşık ${_fmt(orta)} çıtası işlevsel üretim kapasitesi olarak okunur. Toplam hacim aktivasyonu yaklaşık %$toplamHacimAktivasyonYuzde.';
    }

    return {
      'fizikselCita': fizikselCita,
      'oncekiCita': oncekiCita,
      'eklenenCita': eklenenCita,
      'azalanCita': azalanCita,
      'gecenGun': gecenGun,
      'aktivasyonSuresiGun': aktivasyonSuresiGun,
      // İç motorlar için: yalnızca yeni eklenen hacmin devreye giriş oranıdır.
      'aktivasyonOrani': aktivasyonOrani,
      'yeniHacimAktivasyonOrani': aktivasyonOrani,
      'yeniHacimAktivasyonYuzde': yeniHacimAktivasyonYuzde,
      // Kullanıcıya gösterilecek ana oran: toplam işlevsel kapasite / fiziksel hacim.
      'toplamHacimAktivasyonOrani': toplamHacimAktivasyonOrani,
      'toplamHacimAktivasyonYuzde': toplamHacimAktivasyonYuzde,
      'toplamAktivasyonOrani': toplamHacimAktivasyonOrani,
      'toplamAktivasyonYuzde': toplamHacimAktivasyonYuzde,
      'gosterimAktivasyonOrani': toplamHacimAktivasyonOrani,
      'gosterimAktivasyonYuzde': toplamHacimAktivasyonYuzde,
      'islevselCitaMin': double.parse(islevselCitaMin.toStringAsFixed(1)),
      'islevselCitaMax': double.parse(islevselCitaMax.toStringAsFixed(1)),
      'islevselCitaOrta': double.parse(orta.toStringAsFixed(1)),
      'islevselUretimCita': orta.floor(),
      'petekTipi': petekTipi,
      'temelPetekAdedi': temelPetekAdedi,
      'kabarmisPetekAdedi': kabarmisPetekAdedi,
      'aniArtisVar': aniArtisVar,
      'katGecisiVar': katGecisiVar,
      'hacimDegisimTipi': hacimDegisimTipi,
      'uretimGuvenliMi': uretimGuvenliMi,
      'balAkimiGenislemesi': balAkimiGenislemesi,
      'hasatKaynakliDusus': hasatKaynakliDusus,
      'riskliSisirme': riskliSisirme,
      'koloniGucuKatsayisi': aktivasyonDinamikleri?.koloniGucuKatsayisi ?? 1.0,
      'gencIsciKatsayisi': aktivasyonDinamikleri?.gencIsciKatsayisi ?? 1.0,
      'sezonKatsayisi': aktivasyonDinamikleri?.sezonKatsayisi ?? 1.0,
      'trendKatsayisi': aktivasyonDinamikleri?.trendKatsayisi ?? 1.0,
      'riskFreni': aktivasyonDinamikleri?.riskFreni ?? 1.0,
      'aktivasyonHizKatsayisi': aktivasyonDinamikleri?.toplamKatsayi ?? 1.0,
      'uyariSeviyesi': uyariSeviyesi,
      'mesaj': mesaj,
      'ozet': ozet,
    };
  }

  static _PetekDagilimi _petekDagilimiOlustur({
    required int eklenenCita,
    required int kayitliTemel,
    required int kayitliKabarmis,
    required String fallbackTip,
  }) {
    if (eklenenCita <= 0) {
      return const _PetekDagilimi(
          temel: 0, kabarmis: 0, ozetTip: petekTipiTemel);
    }

    int temel = kayitliTemel.clamp(0, eklenenCita).toInt();
    int kabarmis = kayitliKabarmis.clamp(0, eklenenCita).toInt();
    final int toplam = temel + kabarmis;

    if (toplam == 0) {
      if (fallbackTip == petekTipiKabarmis) {
        kabarmis = eklenenCita;
      } else {
        temel = eklenenCita;
      }
    } else if (toplam < eklenenCita) {
      temel += eklenenCita - toplam;
    } else if (toplam > eklenenCita) {
      // Toplam fazla girildiyse önce temel petekten düşülür.
      // Arıcı kabarmış peteği özellikle işaretlediyse bu bilgi aktivasyon süresi için daha değerlidir.
      int fazla = toplam - eklenenCita;
      final int temelAzalt = math.min(fazla, temel);
      temel -= temelAzalt;
      fazla -= temelAzalt;
      if (fazla > 0) kabarmis = math.max(0, kabarmis - fazla);
    }

    final String ozetTip;
    if (temel > 0 && kabarmis > 0) {
      ozetTip = petekTipiKarisik;
    } else if (kabarmis > 0) {
      ozetTip = petekTipiKabarmis;
    } else {
      ozetTip = petekTipiTemel;
    }

    return _PetekDagilimi(temel: temel, kabarmis: kabarmis, ozetTip: ozetTip);
  }

  static String _petekTipiNormalize(dynamic deger) {
    final temiz = (deger ?? '').toString().trim().toLowerCase();
    if (temiz.contains('kabar')) return petekTipiKabarmis;
    if (temiz.contains('ball') || temiz.contains('stok')) return petekTipiBalli;
    if (temiz.contains('yavru')) return petekTipiYavrulu;
    return petekTipiTemel;
  }

  static int _gunFarki(DateTime? onceki, DateTime? son) {
    if (onceki == null || son == null) return 0;
    return son.difference(onceki).inDays.abs();
  }

  static DateTime? _tarihParse(dynamic deger) {
    final metin = (deger ?? '').toString().trim();
    if (metin.isEmpty) return null;
    final dt = DateTime.tryParse(metin);
    if (dt == null) return null;
    return DateTime(dt.year, dt.month, dt.day);
  }

  static int _pozitifInt(dynamic deger) {
    final v = _toInt(deger);
    return v < 0 ? 0 : v;
  }

  static int _toInt(dynamic deger) {
    if (deger == null) return 0;
    if (deger is int) return deger;
    if (deger is double) return deger.round();
    return int.tryParse(deger.toString()) ?? 0;
  }

  static double _toDouble(dynamic deger) {
    if (deger == null) return 0.0;
    if (deger is double) return deger;
    if (deger is int) return deger.toDouble();
    return double.tryParse(deger.toString()) ?? 0.0;
  }

  static String _fmt(double v) {
    if ((v - v.round()).abs() < 0.05) return v.round().toString();
    return v.toStringAsFixed(1);
  }
}

class _AktivasyonDinamikleri {
  final double koloniGucuKatsayisi;
  final double gencIsciKatsayisi;
  final double sezonKatsayisi;
  final double trendKatsayisi;
  final double riskFreni;
  final double toplamKatsayi;

  const _AktivasyonDinamikleri({
    required this.koloniGucuKatsayisi,
    required this.gencIsciKatsayisi,
    required this.sezonKatsayisi,
    required this.trendKatsayisi,
    required this.riskFreni,
    required this.toplamKatsayi,
  });
}

class _PetekDagilimi {
  final int temel;
  final int kabarmis;
  final String ozetTip;

  const _PetekDagilimi({
    required this.temel,
    required this.kabarmis,
    required this.ozetTip,
  });
}
