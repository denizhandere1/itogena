import 'package:itogena_v45/gen_l10n/app_localizations.dart';
import 'koloni_karar_motoru.dart';
import 'ari_biyoloji_servisi.dart';
import 'surec_motoru.dart';
import 'baglam_motoru.dart';
import 'veritabani_servisi.dart';
import 'koloni_biyolojik_model_servisi.dart';
import 'besleme_karar_motoru.dart';
import 'performans_ozeti_servisi.dart';
import 'karar_orkestratoru.dart';
import 'koloni_context_servisi.dart';
import 'koloni_grid_context_servisi.dart';

class KararAsistanServisi {
  static void tumCacheTemizle() {
    KoloniKararMotoru.tumCacheTemizle();
    KoloniBiyolojikModelServisi.tumCacheTemizle();
    SurecMotoru.tumCacheTemizle();
    BeslemeKararMotoru.tumCacheTemizle();
    PerformansOzetiServisi.tumCacheTemizle();
    KoloniContextServisi.cacheTemizle();
    KoloniGridContextServisi.cacheTemizle();
  }

  static void arilikCacheTemizle(int? arilikId) {
    KoloniKararMotoru.arilikCacheTemizle(arilikId);
    // Arılık düzeyindeki değişikliklerde hangi kolonilerin etkilendiği
    // her zaman bilinmediği için koloni bazlı cache'ler güvenli tarafta
    // kalacak şekilde tamamen temizlenir.
    KoloniBiyolojikModelServisi.tumCacheTemizle();
    SurecMotoru.tumCacheTemizle();
    BeslemeKararMotoru.tumCacheTemizle();
    PerformansOzetiServisi.tumCacheTemizle();
    KoloniContextServisi.cacheTemizle();
    KoloniGridContextServisi.cacheTemizle();
  }

  static void koloniCacheTemizle(int koloniId) {
    KoloniKararMotoru.koloniCacheTemizle(koloniId);
    KoloniBiyolojikModelServisi.cacheTemizle(koloniId);
    SurecMotoru.cacheTemizle(koloniId);
    BeslemeKararMotoru.cacheTemizle(koloniId);
    PerformansOzetiServisi.cacheTemizle(koloniId);
    KoloniContextServisi.cacheTemizle(koloniId);
    KoloniGridContextServisi.cacheTemizle(koloniId);
  }

  static Future<Map<String, dynamic>> arilikOzetGetir(int arilikId) {
    return KoloniKararMotoru.arilikOzetGetir(arilikId);
  }

  static Future<Map<String, String>> anaKararUret(
      int koloniId,
      Map<String, dynamic> koloni, {
        List<Map<String, dynamic>>? siraliDonorler,
        bool forceRefresh = false,
        bool donorAnaliziBekle = true,
      }) async {
    final surec = await _dominantSurecGetir(koloniId);
    if (_surecKarariBastirirMi(surec)) {
      return _surecAnaKararMap(surec!);
    }

    final orkestrasyon = await orkestrasyonOzetiGetir(
      koloniId,
      koloni,
      hazirKoloni: koloni,
      siraliDonorler: siraliDonorler,
      forceRefresh: forceRefresh,
    );
    final ana = Map<String, dynamic>.from(
      orkestrasyon['anaKarar'] ?? const <String, dynamic>{},
    );
    if (ana.isNotEmpty) {
      return {
        'baslik': (ana['baslik'] ?? '').toString(),
        'mesaj': (ana['mesaj'] ?? '').toString(),
        'renk': _orkestrasyonRenk(ana),
        'ikon': _orkestrasyonIkon(ana),
      };
    }

    final sonuc = await KoloniKararMotoru.kararUret(
      koloniId,
      koloni,
      siraliDonorler: siraliDonorler,
      forceRefresh: forceRefresh,
      donorAnaliziBekle: donorAnaliziBekle,
    );
    return sonuc.toAnaKararMap();
  }

  static Future<bool> gercekDamizlikMi(
      int koloniId,
      Map<String, dynamic> koloni, {
        List<Map<String, dynamic>>? siraliDonorler,
        bool forceRefresh = false,
      }) async {
    final sonuc = await KoloniKararMotoru.kararUret(
      koloniId,
      koloni,
      siraliDonorler: siraliDonorler,
      forceRefresh: forceRefresh,
    );
    return sonuc.gercekDamizlik;
  }

  static Future<Map<String, String>> secilimDurumuGetir(
      int koloniId,
      Map<String, dynamic> koloni, {
        List<Map<String, dynamic>>? siraliDonorler,
        bool forceRefresh = false,
      }) async {
    // Seçilim/genetik katmanı süreç uyarısı ile bastırılmaz.
    // Oğul sonrası, anasızlık, bölme gibi zaman kritik bilgiler süreç kartında görünür;
    // bu metinler genetik kartına taşınırsa kullanıcı yanlış katmanı okur.
    final sonuc = await KoloniKararMotoru.kararUret(
      koloniId,
      koloni,
      siraliDonorler: siraliDonorler,
      forceRefresh: forceRefresh,
    );
    return sonuc.toSecilimMap();
  }

  static Future<List<Map<String, String>>> aksiyonOnerileriUret(
      int koloniId,
      Map<String, dynamic> koloni, {
        List<Map<String, dynamic>>? siraliDonorler,
        bool forceRefresh = false,
        AppLocalizations? l,
      }) async {
    final surec = await _dominantSurecGetir(koloniId);
    if (_surecKarariBastirirMi(surec)) {
      return _surecAksiyonKartlari(surec!, l: l);
    }

    final sonuc = await KoloniKararMotoru.kararUret(
      koloniId,
      koloni,
      siraliDonorler: siraliDonorler,
      forceRefresh: forceRefresh,
    );
    return sonuc.aksiyonKartlari;
  }

  static Future<List<Map<String, dynamic>>> donorAdaylariSiraliGetir({
    int? arilikId,
    bool forceRefresh = false,
  }) {
    return KoloniKararMotoru.donorAdaylariSiraliGetir(
      arilikId: arilikId,
      forceRefresh: forceRefresh,
    );
  }


  static Future<Map<String, dynamic>> surecDurumuGetir(
      int koloniId, {
        Map<String, dynamic>? hazirKoloni,
        List<Map<String, dynamic>>? hazirMuayeneler,
        bool forceRefresh = false,
      }) async {
    final sonuc = await SurecMotoru.durumGetir(
      koloniId,
      hazirKoloni: hazirKoloni,
      hazirMuayeneler: hazirMuayeneler,
      forceRefresh: forceRefresh,
    );
    return sonuc.toMap();
  }

  static Future<Map<String, bool>> koloniKartAlarmDurumuGetir(
      int koloniId,
      ) async {
    final surecDurumu = await SurecMotoru.durumGetir(koloniId);

    bool anaMemesiKritik = false;
    bool anaMemesiTakip = false;
    bool ogulAtti = false;

    for (final surec in surecDurumu.aktifSurecler) {
      final kod = surec.kod.toUpperCase();
      final grup = surec.grup.toUpperCase();

      if (grup == 'OGUL_BELIRTISI' ||
          kod.contains('OGUL_BELIRTISI') ||
          kod.contains('ANA_MEMESI')) {
        if (surec.tip.trim().toLowerCase() == 'kritik' || surec.oncelik >= 90) {
          anaMemesiKritik = true;
        } else {
          anaMemesiTakip = true;
        }
      }

      if (grup == 'OGUL_SONRASI' || kod.contains('OGUL_SONRASI')) {
        ogulAtti = true;
      }
    }

    return {
      'anaMemesiKritik': anaMemesiKritik,
      'anaMemesiTakip': anaMemesiTakip && !anaMemesiKritik,
      'ogulAtti': ogulAtti,
    };
  }

  static Future<Map<String, dynamic>> koloniKartDurumuGetir(
      int koloniId, {
        Map<String, dynamic>? hazirKoloni,
      }) async {
    final sonuclar = await Future.wait<dynamic>([
      koloniKartAlarmDurumuGetir(koloniId),
      yonetimDurumOzetiGetir(koloniId, hazirKoloni: hazirKoloni),
      VeritabaniServisi.muayeneleriGetir(koloniId),
    ]);

    final alarm = Map<String, bool>.from(sonuclar[0] as Map);
    final yonetim = Map<String, dynamic>.from(sonuclar[1] as Map);
    final muayeneler = List<Map<String, dynamic>>.from(sonuclar[2] as List);
    final bool yavruYok = muayeneler.isNotEmpty &&
        _sonMuayenedeYavruGorulmediMi(muayeneler.first);

    return <String, dynamic>{
      'alarm': alarm,
      'yonetim': yonetim,
      'yavruYok': yavruYok,
    };
  }

  static Future<Map<String, dynamic>> biyolojiDurumuGetir(int koloniId) async {
    final sonuc = await AriBiyolojiServisi.analizYap(koloniId);
    return sonuc.toMap();
  }

  static Future<Map<String, dynamic>> kararVeBiyolojiBirlesikGetir(
      int koloniId,
      Map<String, dynamic> koloni, {
        List<Map<String, dynamic>>? siraliDonorler,
        bool forceRefresh = false,
      }) async {
    final karar = await KoloniKararMotoru.kararUret(
      koloniId,
      koloni,
      siraliDonorler: siraliDonorler,
      forceRefresh: forceRefresh,
    );
    final biyoloji = await AriBiyolojiServisi.analizYap(koloniId);
    final surec = await _dominantSurecGetir(koloniId);
    final surecOncelikli = _surecKarariBastirirMi(surec);

    return {
      'anaKarar': surecOncelikli
          ? _surecAnaKararMap(surec!)
          : karar.toAnaKararMap(),
      // Genetik/seçilim çıktısı süreç kartı tarafından bastırılmaz.
      // Ana, oğul, bölme veya yavru-yok süreci aktif olsa bile donör/veto
      // değerlendirmesi kendi katmanında kalır. Aksi halde genetik kartına
      // “kovanı açma / müdahale etme” gibi süreç dili sızar.
      'secilim': karar.toSecilimMap(),
      'gercekDamizlik': karar.gercekDamizlik,
      'donorSkoru': karar.donorSkoru,
      'donorSirasi': karar.donorSirasi,
      'donorVeto': karar.donorVeto,
      // Aksiyon kartları genetik/performans kararının parçasıdır. Aktif süreç
      // bilgisi ayrı süreç kartında gösterilir; burada tekrar üretilmez.
      'aksiyonKartlari': karar.aksiyonKartlari,
      'profil': {
        ...karar.profil,
        'surecOncelikli': surecOncelikli,
        'dominantSurec': surec?.toMap(),
      },
      'biyoloji': biyoloji.toMap(),
    };
  }

  static Future<Map<String, dynamic>> kararAciklamaGetir(
      int koloniId,
      Map<String, dynamic> koloni, {
        List<Map<String, dynamic>>? siraliDonorler,
        bool forceRefresh = false,
        AppLocalizations? l,
      }) async {
    final surec = await _dominantSurecGetir(koloniId);
    final bool surecOncelikli = _surecKarariBastirirMi(surec);

    final sonuc = await KoloniKararMotoru.kararUret(
      koloniId,
      koloni,
      siraliDonorler: siraliDonorler,
      forceRefresh: forceRefresh,
    );

    final profil = sonuc.profil;
    final List<String> gerekceler = [];
    final List<String> riskler = [];
    final List<String> oneriler = [];

    void ekle(List<String> hedef, String? metin) {
      final temiz = (metin ?? '').trim();
      if (temiz.isEmpty) return;
      if (!hedef.contains(temiz)) hedef.add(temiz);
    }

    final int sonCita = _toInt(profil['sonCita']);
    final int maxCita = _toInt(profil['maxCita']);
    final int balCita = _toInt(profil['balCita']);
    final int anaYasi = _toInt(profil['anaYasi']);
    final int muayeneSayisi = _toInt(profil['muayeneSayisi']);
    final String trend = _metin(profil['trend'], 'Stabil');
    final String mizac = _metin(profil['mizac'], 'Bilinmiyor');
    final String vetoKod = _metin(profil['vetoKodu'], '');
    final String vetoReferansKoloniNo = _metin(profil['vetoReferansKoloniNo'], '');
    final String biyolojiBaslik = _metin(profil['biyolojiBaslik'], '');
    final String biyolojiMesaj = _metin(profil['biyolojiMesaj'], '');
    final String kisCikisYorum = _metin(profil['kisCikisYorum'], '');

    if (sonuc.donorVeto) {
      if (vetoKod == 'DOGRUDAN_OGUL' || vetoKod == 'KAYNAK_TIPI_OGUL') {
        ekle(gerekceler, l?.kararVetoDogrudan ?? 'Koloni oğul kökenli olduğu için temiz donör havuzuna alınmadı.');
      } else if (vetoKod == 'KENDISI_OGUL_ATTI') {
        ekle(gerekceler, l?.kararVetoKendisiOgulAtti ?? 'Koloni kendi geçmişinde oğul attığı için donör değerlendirmesinde veto aldı.');
      } else if (vetoKod == 'ATA_HATTA_OGUL' && vetoReferansKoloniNo.isNotEmpty) {
        ekle(gerekceler, l?.kararVetoAtaHattaRef(vetoReferansKoloniNo) ?? '$vetoReferansKoloniNo hattında oğul izi bulunduğu için temiz donör havuzuna alınmadı.');
      } else if (vetoKod == 'ATA_HATTA_OGUL') {
        ekle(gerekceler, l?.kararVetoAtaHatta ?? 'Atasal hatta oğul izi bulunduğu için temiz donör havuzuna alınmadı.');
      }
    } else if (sonuc.donorSirasi > 0) {
      ekle(gerekceler, l?.kararDonorSirasi(sonuc.donorSirasi) ?? 'Temiz donör havuzunda ${sonuc.donorSirasi}. sırada görünüyor.');
    }

    if (sonCita > 0) {
      ekle(gerekceler, l?.kararSonCitaMetni(sonCita) ?? 'Son muayenede koloni $sonCita çıta gücünde görünüyor.');
    }
    if (maxCita > 0) {
      ekle(gerekceler, l?.kararMaxCitaMetni(maxCita) ?? 'Bu sezon gördüğü en yüksek güç $maxCita çıta.');
    }
    if (balCita > 0) {
      ekle(gerekceler, l?.kararBalCitaMetni(balCita) ?? 'Bal taşıma sinyali $balCita ballı çıta ile görülüyor.');
    }

    if (trend == 'Yükselişte') {
      ekle(gerekceler, l?.kararTrendYukselis ?? 'Son muayenelerde gelişim yönü yukarı.');
    } else if (trend == 'Düşüşte') {
      ekle(riskler, l?.kararTrendDusus ?? 'Son muayenelerde güç kaybı eğilimi görülüyor.');
    } else {
      ekle(gerekceler, l?.kararTrendStabil ?? 'Gidişat stabil görünüyor.');
    }

    if (anaYasi >= 2) {
      ekle(riskler, l?.kararAnaYasiRisk(anaYasi) ?? 'Ana yaşı $anaYasi yıl olduğu için verim ve düzen düşüşü riski taşıyor.');
    }

    if (mizac == 'Saldırgan' || mizac == 'Sinirli') {
      ekle(riskler, l?.kararMizacRisk ?? 'Mizaç verisi saha yönetimini zorlaştırabilir.');
    }

    if (kisCikisYorum.isNotEmpty && !kisCikisYorum.toLowerCase().contains('yetersiz')) {
      ekle(gerekceler, kisCikisYorum);
    }

    if (profil['biyolojiVeriVarMi'] == true && biyolojiBaslik.isNotEmpty) {
      if (profil['biyolojiZamanKritik'] == true || profil['biyolojiMudahaleGerekli'] == true) {
        ekle(riskler, biyolojiBaslik);
        if (biyolojiMesaj.isNotEmpty) {
          ekle(riskler, biyolojiMesaj);
        }
      } else if (profil['biyolojiAnaUretimIcinUygun'] == true) {
        ekle(gerekceler, biyolojiBaslik);
      } else if (biyolojiMesaj.isNotEmpty) {
        ekle(gerekceler, biyolojiMesaj);
      }
    }

    if (muayeneSayisi < 3) {
      ekle(riskler, l?.kararAzVeriUyari ?? 'Karar az veriyle üretildiği için güven payı düşüktür.');
    }

    for (final kart in sonuc.aksiyonKartlari) {
      final baslik = _metin(kart['baslik'], '');
      final mesaj = _metin(kart['mesaj'], '');
      if (mesaj.isEmpty) continue;
      if (baslik == 'Ne yap') {
        ekle(oneriler, mesaj);
      } else if (baslik == 'Sahada Öncelik' || baslik == 'Biyolojik Not') {
        ekle(oneriler, mesaj);
      }
    }

    switch (sonuc.kararKodu) {
      case 'BOLME':
      case 'BOLME_ICIN_UYGUN':
        ekle(oneriler, l?.kararBolmePlan ?? 'Bölme yapacaksan koloniyi 6 çıtanın altına düşürmeden planla.');
        break;
      case 'DONOR_1':
      case 'DONOR_2':
      case 'DONOR_3':
      case 'SARTLI_DONOR':
        ekle(oneriler, l?.kararDonorOncelik ?? 'Ana üretiminde bu koloniyi aday havuzunda öncelikli düşün.');
        break;
      case 'ANA_DEGISIM':
      case 'ANA_DEGISIM_DUSUN':
        ekle(oneriler, l?.kararAnaDegisimPlan ?? 'Ana değişimini aktif dönemin sonuna yakın planlamak genelde daha güvenli olur.');
        break;
      case 'GUCLENDIR_VE_IZLE':
      case 'DESTEK_KOLONISI':
        ekle(oneriler, l?.kararGuclendir ?? 'Kapalı yavru, besleme ve düzenli muayene ile güçlenme yönünü izle.');
        break;
      case 'URETIM':
      case 'URETIM_IZLE':
      case 'URETIMDE_DEGERLENDIR':
        ekle(oneriler, l?.kararUretimTut ?? 'Üretimde tut; bal akımı yaklaşırken alan ve kat yönetimini öne al.');
        break;
      case 'PASIF_KAYIT':
        ekle(oneriler, l?.kararPasifKayitOner ?? 'Koloniyi aktif üretimden çok soy ve geçmiş kaydı olarak değerlendir.');
        break;
    }

    if (surecOncelikli && surec != null) {
      ekle(gerekceler, _surecNedeni(surec, l: l));
      if (surec.tip == 'kritik' || surec.tip == 'uyari') {
        ekle(riskler, surec.baslik);
      }
      ekle(oneriler, surec.mesaj);
    }

    final String ozet = surecOncelikli && surec != null
        ? surec.mesaj.trim()
        : (sonuc.kararMesaji.trim().isNotEmpty
        ? sonuc.kararMesaji.trim()
        : sonuc.secilimMesaji.trim());

    return {
      'karar': surecOncelikli && surec != null ? surec.baslik : sonuc.kararBaslik,
      'ozet': ozet,
      // Seçilim alanı süreç tarafından değiştirilmez; genetik kartı daima
      // genetik/seçilim sonucunu okur.
      'secilimBaslik': sonuc.secilimBaslik,
      'secilimMesaji': sonuc.secilimMesaji,
      'gerekceler': gerekceler,
      'riskler': riskler,
      'oneriler': oneriler,
    };
  }



  static Future<Map<String, dynamic>> orkestrasyonOzetiGetir(
      int koloniId,
      Map<String, dynamic> koloni, {
        Map<String, dynamic>? hazirKoloni,
        List<Map<String, dynamic>>? siraliDonorler,
        bool forceRefresh = false,
      }) async {
    final List<Map<String, dynamic>> sinyaller = <Map<String, dynamic>>[];

    final surec = await _dominantSurecGetir(koloniId);
    if (surec != null) {
      sinyaller.add(KararOrkestratoru.sinyal(
        kaynak: 'surec',
        kod: surec.kod,
        grup: surec.grup,
        baslik: surec.baslik,
        mesaj: surec.mesaj,
        oncelik: surec.oncelik,
        risk: surec.tip,
        kritikMi: surec.tip == 'kritik' || surec.oncelik >= 90,
        gridGoster: true,
        detayGoster: true,
        sessizlestirilebilir: false,
      ));
    }

    try {
      final yonetim = await yonetimDurumOzetiGetir(
        koloniId,
        hazirKoloni: hazirKoloni ?? koloni,
      );
      if (yonetim.isNotEmpty) {
        sinyaller.add(KararOrkestratoru.sinyal(
          kaynak: 'yonetim',
          kod: (yonetim['kod'] ?? '').toString(),
          grup: (yonetim['grup'] ?? '').toString(),
          baslik: (yonetim['baslik'] ?? '').toString(),
          mesaj: (yonetim['mesaj'] ?? yonetim['aciklama'] ?? '').toString(),
          oncelik: _toInt(yonetim['oncelik']),
          risk: (yonetim['risk'] ?? 'dusuk').toString(),
          gridGoster: yonetim['gridGosterilebilir'] != false,
          detayGoster: true,
        ));
      }
    } catch (_) {}

    try {
      final model = await KoloniBiyolojikModelServisi.modelGetir(
        koloniId,
        forceRefresh: forceRefresh,
      );

      final Map<String, dynamic> riskAnalizi =
      Map<String, dynamic>.from(model['riskAnalizi'] ?? const <String, dynamic>{});
      if (riskAnalizi.isNotEmpty) {
        sinyaller.add(KararOrkestratoru.sinyal(
          kaynak: 'risk',
          kod: (riskAnalizi['anaRisk'] ?? '').toString(),
          baslik: (riskAnalizi['anaRiskBaslik'] ?? 'Risk').toString(),
          mesaj: (riskAnalizi['kisaMesaj'] ?? '').toString(),
          oncelik: _riskOnceligi(riskAnalizi),
          risk: (riskAnalizi['genelRisk'] ?? 'dusuk').toString(),
          gridGoster: _toInt(riskAnalizi['genelRiskPuani']) >= 45,
          detayGoster: true,
        ));
      }

      final Map<String, dynamic> projeksiyon =
      Map<String, dynamic>.from(model['projeksiyon'] ?? const <String, dynamic>{});
      if (projeksiyon.isNotEmpty) {
        sinyaller.add(KararOrkestratoru.sinyal(
          kaynak: 'projeksiyon',
          kod: 'PROJEKSIYON',
          baslik: 'Biyolojik yön',
          mesaj: (projeksiyon['projeksiyonOzeti'] ?? '').toString(),
          oncelik: 55,
          risk: 'dusuk',
          gridGoster: false,
          detayGoster: true,
        ));
      }
    } catch (_) {}

    try {
      final karar = await KoloniKararMotoru.kararUret(
        koloniId,
        koloni,
        siraliDonorler: siraliDonorler,
        forceRefresh: forceRefresh,
      );

      sinyaller.add(KararOrkestratoru.sinyal(
        kaynak: 'genetik',
        kod: karar.kararKodu,
        baslik: karar.kararBaslik,
        mesaj: karar.kararMesaji,
        oncelik: karar.gercekDamizlik ? 68 : 60,
        risk: karar.donorVeto ? 'orta' : 'dusuk',
        gridGoster: true,
        detayGoster: true,
      ));
    } catch (_) {}

    return KararOrkestratoru.orkestreEt(sinyaller: sinyaller);
  }

  static int _riskOnceligi(Map<String, dynamic> riskAnalizi) {
    final int puan = _toInt(riskAnalizi['genelRiskPuani']);
    if (puan >= 70) return 88;
    if (puan >= 45) return 78;
    if (puan >= 20) return 58;
    return 40;
  }


  static String _orkestrasyonRenk(Map<String, dynamic> sinyal) {
    final risk = (sinyal['risk'] ?? '').toString().toLowerCase();
    final oncelik = _toInt(sinyal['oncelik']);
    if (risk.contains('kritik') || oncelik >= 90) return 'red';
    if (risk.contains('yüksek') || risk.contains('yuksek') || oncelik >= 80) {
      return 'orange';
    }
    if (risk.contains('orta') || oncelik >= 65) return 'amber';
    return 'green';
  }

  static String _orkestrasyonIkon(Map<String, dynamic> sinyal) {
    final kaynak = (sinyal['kaynak'] ?? '').toString().toLowerCase();
    final kod = (sinyal['kod'] ?? '').toString().toLowerCase();
    if (kaynak.contains('surec')) return 'timeline';
    if (kaynak.contains('risk')) return 'warning';
    if (kaynak.contains('projeksiyon')) return 'trending_up';
    if (kaynak.contains('genetik') || kod.contains('donor')) return 'emoji_events';
    return 'info';
  }

  static Future<Map<String, dynamic>> yonetimDurumOzetiGetir(
      int koloniId, {
        Map<String, dynamic>? hazirKoloni,
        AppLocalizations? l,
      }) async {
    final kararlar = await yonetimKararlariGetir(
      koloniId,
      hazirKoloni: hazirKoloni,
      l: l,
    );
    if (kararlar.isEmpty) {
      return const <String, dynamic>{};
    }
    final gridKararlari = kararlar
        .where((k) => k['gridGosterilebilir'] != false)
        .toList(growable: false);
    if (gridKararlari.isEmpty) {
      return const <String, dynamic>{};
    }
    final sirali = List<Map<String, dynamic>>.from(gridKararlari)
      ..sort((a, b) => _toInt(b['oncelik']).compareTo(_toInt(a['oncelik'])));
    return sirali.first;
  }

  static Future<List<Map<String, dynamic>>> yonetimKararlariGetir(
      int koloniId, {
        Map<String, dynamic>? hazirKoloni,
        AppLocalizations? l,
      }) async {
    final koloni = hazirKoloni ?? await VeritabaniServisi.koloniOzetiGetir(koloniId);
    if (koloni.isEmpty) return const <Map<String, dynamic>>[];

    final muayeneler = await VeritabaniServisi.muayeneleriGetir(koloniId);
    if (muayeneler.isEmpty) return const <Map<String, dynamic>>[];

    final sonMuayene = muayeneler.first;
    final oncekiMuayene = muayeneler.length >= 2 ? muayeneler[1] : null;
    final List<Map<String, dynamic>> kararlar = <Map<String, dynamic>>[];

    Map<String, dynamic>? aktifBalAkimi;
    try {
      final int arilikId = _toInt(koloni['arilikId']);
      aktifBalAkimi = await VeritabaniServisi.aktifBalAkimGetir(
        arilikId: arilikId > 0 ? arilikId : null,
      );
    } catch (_) {
      aktifBalAkimi = null;
    }

    final DateTime bugunHam = DateTime.now();
    final DateTime bugun = DateTime(bugunHam.year, bugunHam.month, bugunHam.day);
    final DateTime? balBas = aktifBalAkimi?['bas'] is DateTime
        ? _sadeceGun(aktifBalAkimi!['bas'] as DateTime)
        : null;
    final DateTime? balBit = aktifBalAkimi?['bit'] is DateTime
        ? _sadeceGun(aktifBalAkimi!['bit'] as DateTime)
        : null;
    final bool balAkimiAktif = balBas != null &&
        balBit != null &&
        !bugun.isBefore(balBas) &&
        !bugun.isAfter(balBit);
    final int? balAkiminaKalanGun = balBas == null ? null : balBas.difference(bugun).inDays;
    final bool balAkimiKesmePenceresi =
        balAkiminaKalanGun != null && balAkiminaKalanGun >= 0 && balAkiminaKalanGun <= 20;
    final bool bolmeAnaPenceresi =
        balAkiminaKalanGun != null && balAkiminaKalanGun >= 35 && balAkiminaKalanGun <= 45;
    final bool bolmeDikkatPenceresi =
        balAkiminaKalanGun != null && balAkiminaKalanGun >= 25 && balAkiminaKalanGun <= 34;
    final bool kisDonemi = bugun.month == 12 || bugun.month <= 2;
    final bool sonbaharKisHazirlik = bugun.month == 11 && bugun.day >= 15;

    final surecDurumu = await SurecMotoru.durumGetir(
      koloniId,
      hazirKoloni: koloni,
      hazirMuayeneler: muayeneler,
    );

    final kilit = BaglamMotoru.kararKilitDurumuGetir(
      surecDurumu.aktifSurecler,
      balAkimiAktif: balAkimiAktif,
      balAkiminaKalanGun: balAkiminaKalanGun,
      kisDonemi: kisDonemi,
    );

    if (kilit.aktif && kilit.eylemEngeli) {
      kararlar.add({
        'kod': kilit.kod,
        'kategori': 'kilit',
        'kisa': l?.kararKilitBekle ?? 'Bekle',
        'baslik': kilit.baslik,
        'mesaj': kilit.mesaj,
        'gerekce': l?.kararKilitGerekce ?? 'Bu pencere kapanmadan çelişen eylem önerilmez.',
        'oncelik': kilit.oncelik,
        'tip': 'uyari',
        'kararTipi': 'BEKLE',
        'bastirilabilir': false,
      });
    }

    final bool hasatSonrasiSurec = surecDurumu.aktifSurecler.any((s) {
      final grup = s.grup.toUpperCase();
      final kod = s.kod.toUpperCase();
      return grup.contains('HASAT') || kod.contains('HASAT');
    });

    final biyolojikModel = await KoloniBiyolojikModelServisi.modelGetir(koloniId);
    final aktivasyon = Map<String, dynamic>.from(
      biyolojikModel['citaAktivasyon'] ?? const <String, dynamic>{},
    );

    final bool suruplukKolonideVar =
        biyolojikModel['suruplukHacimKaplarMi'] == true ||
            ((biyolojikModel['suruplukHacimKaplarMi'] == null) &&
                _boolDeger(koloni['suruplukVarMi'], varsayilan: true) &&
                !_boolDeger(sonMuayene['suruplukKaldirildiMi']));
    final int katEsigiModel = _toInt(biyolojikModel['birinciKatVermeEsigi']);
    final int katliKabulEsigi = _toInt(biyolojikModel['katliKabulEsigi']);
    final int ucuncuKatVermeEsigi = _toInt(biyolojikModel['ucuncuKatVermeEsigi']);
    final int ucKatliKabulEsigi = _toInt(biyolojikModel['ucKatliKabulEsigi']);
    final int katEsigi = katEsigiModel > 0 ? katEsigiModel : (suruplukKolonideVar ? 9 : 10);
    final int ucuncuKatEsigi = ucuncuKatVermeEsigi > 0
        ? ucuncuKatVermeEsigi
        : (suruplukKolonideVar ? 19 : 20);
    final int ucKatliEsik = ucKatliKabulEsigi > 0
        ? ucKatliKabulEsigi
        : (suruplukKolonideVar ? 20 : 21);
    final int katliEsik = katliKabulEsigi > 0
        ? katliKabulEsigi
        : katEsigi + 1;
    final int fizikselCita = _toInt(
      biyolojikModel['fizikselToplamCita'] ?? aktivasyon['fizikselCita'],
    );
    final double aktivasyonOrani = _toDouble(
      aktivasyon['aktivasyonOrani'] ?? 1.0,
    ).clamp(0.0, 1.0).toDouble();
    final int islevselUretimCita = _toInt(
      biyolojikModel['islevselUretimCita'] ?? aktivasyon['islevselUretimCita'],
    );
    final bool riskliSisirme = biyolojikModel['riskliSisirme'] == true ||
        aktivasyon['riskliSisirme'] == true;
    final String modelSinifi = _metin(biyolojikModel['koloniSinifi'], '');
    final String koloniSinifi = modelSinifi.isNotEmpty
        ? modelSinifi
        : _koloniSinifiBelirle(
      fizikselCita: fizikselCita,
      islevselUretimCita: islevselUretimCita,
      aktivasyonOrani: aktivasyonOrani,
    );
    final bool zayifKoloni = koloniSinifi == 'ZAYIF';
    final bool gelisimKolonisi = koloniSinifi == 'GELISIM';
    final bool uretimKolonisi = koloniSinifi == 'URETIM';
    final bool hasatKolonisi = koloniSinifi == 'HASAT';
    final bool hasatBeklentisiVar = uretimKolonisi || hasatKolonisi;
    final String yavruDuzeni = _metin(sonMuayene['yavruDuzeni'], '').toLowerCase();
    final int yavruluCita = _toInt(sonMuayene['yavruluCita']);
    final int stokCita = _toInt(sonMuayene['bal_cita']) + _toInt(sonMuayene['balliCita']) + _toInt(sonMuayene['balliCerceve']);
    final bool yavruDuzeniStabil = yavruluCita > 0 &&
        !yavruDuzeni.contains('yok') &&
        !yavruDuzeni.contains('kambur') &&
        !yavruDuzeni.contains('dağınık') &&
        !yavruDuzeni.contains('daginik');

    final String kaynakTipi = _metin(koloni['kaynakTipi'], '').toLowerCase();
    final bool ogulKokenli = kaynakTipi.contains('oğul') || kaynakTipi.contains('ogul');
    final bool genetikVetoGorunuyor = ogulKokenli;
    final bool genetikDegerVarsayimi = !genetikVetoGorunuyor &&
        yavruDuzeniStabil &&
        islevselUretimCita >= 8 &&
        aktivasyonOrani >= 0.80;

    bool gucluTrend = false;
    if (oncekiMuayene != null) {
      final int oncekiCita = _toInt(oncekiMuayene['citaSayisi']);
      final int sonCita = _toInt(sonMuayene['citaSayisi']);
      gucluTrend = sonCita - oncekiCita >= 1;
    }
    if (islevselUretimCita >= 9 && aktivasyonOrani >= 0.85) {
      gucluTrend = true;
    }

    final bool gucDususu = oncekiMuayene != null &&
        _toInt(sonMuayene['citaSayisi']) < _toInt(oncekiMuayene['citaSayisi']);
    final bool genetikCogaltmaHedefi = genetikDegerVarsayimi &&
        gucluTrend &&
        !ogulKokenli &&
        !riskliSisirme;
    final bool bolmeToparlanmaHedefi = surecDurumu.aktifSurecler.any((s) {
      final kod = s.kod.toUpperCase();
      final grup = s.grup.toUpperCase();
      return kod.contains('BOLME') || grup.contains('BOLME');
    });
    final bool riskliAnaSureciHedefi = surecDurumu.aktifSurecler.any((s) {
      final kod = s.kod.toUpperCase();
      final grup = s.grup.toUpperCase();
      return kod.contains('ANASIZ') ||
          kod.contains('YAVRU_YOK') ||
          kod.contains('ANA_KAZANMA') ||
          grup.contains('ANASIZ') ||
          grup.contains('YAVRU_YOK');
    });

    final Map<String, dynamic> hedef = _sezonHedefiBelirle(
      genetikCogaltmaHedefi: genetikCogaltmaHedefi,
      bolmeToparlanmaHedefi: bolmeToparlanmaHedefi,
      riskliAnaSureciHedefi: riskliAnaSureciHedefi,
      balAkimiAktif: balAkimiAktif,
      balAkiminaKalanGun: balAkiminaKalanGun,
      kisDonemi: kisDonemi,
      sonbaharKisHazirlik: sonbaharKisHazirlik,
      hasatSonrasi: hasatSonrasiSurec,
      koloniSinifi: koloniSinifi,
      islevselUretimCita: islevselUretimCita,
      stokCita: stokCita,
      gucluTrend: gucluTrend,
      gucDususu: gucDususu,
      l: l,
    );

    if (hedef.isNotEmpty) {
      kararlar.add(hedef);
    }

    final List<Map<String, dynamic>> sapmaKararlari = _sapmaSenaryolariUret(
      surecler: surecDurumu.aktifSurecler,
      balAkiminaKalanGun: balAkiminaKalanGun,
      balAkimiAktif: balAkimiAktif,
      fizikselCita: fizikselCita,
      islevselUretimCita: islevselUretimCita,
      aktivasyonOrani: aktivasyonOrani,
      stokCita: stokCita,
      yavruDuzeniStabil: yavruDuzeniStabil,
      gucDususu: gucDususu,
      gucluTrend: gucluTrend,
      bolmeToparlanmaHedefi: bolmeToparlanmaHedefi,
      riskliAnaSureciHedefi: riskliAnaSureciHedefi,
      hasatSonrasi: hasatSonrasiSurec,
      l: l,
    );
    kararlar.addAll(sapmaKararlari);

    final Map<String, dynamic> genetikSkorSinyali = _genetikCogaltmaSkoruSinyali(
      genetikDegerVarsayimi: genetikDegerVarsayimi,
      genetikVetoGorunuyor: genetikVetoGorunuyor,
      gucluTrend: gucluTrend,
      yavruDuzeniStabil: yavruDuzeniStabil,
      islevselUretimCita: islevselUretimCita,
      aktivasyonOrani: aktivasyonOrani,
      kisDonemi: kisDonemi,
      stokCita: stokCita,
      riskliSisirme: riskliSisirme,
      gucDususu: gucDususu,
      bolmeToparlanmaHedefi: bolmeToparlanmaHedefi,
      riskliAnaSureciHedefi: riskliAnaSureciHedefi,
      hasatSonrasi: hasatSonrasiSurec,
      l: l,
    );
    if (genetikSkorSinyali.isNotEmpty && (hasatBeklentisiVar || genetikDegerVarsayimi)) {
      kararlar.add(genetikSkorSinyali);
    }

    // Besleme artık ayrı bir UI kararı gibi değil, yönetim karar listesinin
    // standart sinyali olarak üretilir. Böylece grid, özet kartı ve detay aynı
    // karar hattını okur; besleme ayrı bir ikinci gerçeklik oluşturmaz.
    try {
      final besleme = await BeslemeKararMotoru.kararGetir(koloniId);
      final beslemeKarari = _beslemeYonetimKarariUret(
        besleme,
        hasatBeklentisiVar: hasatBeklentisiVar,
        balAkimiAktif: balAkimiAktif,
        balAkimiKesmePenceresi: balAkimiKesmePenceresi,
        l: l,
      );
      if (beslemeKarari.isNotEmpty) {
        kararlar.add(beslemeKarari);
      }
    } catch (_) {
      // Besleme motoru hata verirse diğer yönetim kararları düşürülmez.
    }

    try {
      final varroa = varroaTakvimHatirlatmasiGetir(
        muayeneler,
        bugun: bugun,
        balAkimBaslangici: balBas,
        l: l,
      );
      final seviye = _metin(varroa['seviye'], 'bilgi').toLowerCase();
      final baslik = _metin(varroa['baslik'], 'Varroa takibi');
      final gerekce = _metin(varroa['gerekce'], '');
      final oneriler = (varroa['oneriler'] is List)
          ? (varroa['oneriler'] as List).map((e) => e.toString()).where((e) => e.trim().isNotEmpty).join(' ')
          : '';
      if (seviye == 'kritik' || seviye == 'risk') {
        final bool kalintiVeto = balAkimiAktif || balAkimiKesmePenceresi;
        // Gelişim/zayıf kolonide kalıntı riski uyarısı gösterilmez.
        // 8 çıta altındaki kolonide hasat beklentisi olmadığından
        // varroa mücadelesi gerekirse yapılabilir; kalıntı dili baskılanır.
        final bool gelisimKolonisindeKalintiDiliBastir =
            !hasatBeklentisiVar &&
                islevselUretimCita < 8;
        if (gelisimKolonisindeKalintiDiliBastir) {
          // Kullanıcıya karar/uyarı üretme; sistem iç risk hesabı çalışmaya devam eder.
        } else {
          kararlar.add({
            'kod': kalintiVeto ? 'VARROA_AKIM_DONEMI_VETO' : 'VARROA_RISK',
            'kategori': kalintiVeto ? 'veto' : 'yonetim',
            'kisa': kalintiVeto ? 'Varroa dikkat' : 'Varroa',
            'baslik': kalintiVeto ? 'Bal döneminde varroa mücadelesinde kalıntı riskine dikkat' : baslik,
            'mesaj': kalintiVeto ? 'Bal akımı/hasat döneminde kalıntı riski olan kimyasal mücadele önerilmez. Gerekiyorsa organik yöntemler değerlendirilir.' : (oneriler.isEmpty ? gerekce : '$gerekce $oneriler'),
            'gerekce': kalintiVeto ? '' : '',
            'oncelik': seviye == 'kritik' ? 87 : 73,
            'tip': seviye == 'kritik' ? 'uyari' : 'bilgi',
            'kararTipi': kalintiVeto ? 'VETO' : 'EYLEM',
            'bastirilabilir': !kalintiVeto,
          });
        }
      }
    } catch (_) {
      // Varroa takvim hatırlatması hata verirse yönetim kararlarını düşürme.
    }

    // Şurupluk kaldırma kullanıcıya yönetim kararı olarak gösterilmez.
    // Muayenede işaretlenen suruplukKaldirildiMi verisi biyolojik model,
    // hacim kapasitesi ve kat eşiği hesabında iç veri olarak kullanılmaya devam eder.

    final bool kuluclukKatEsiginde = fizikselCita == katEsigi;
    final bool katZatenVerilmis = fizikselCita >= katliEsik;
    final bool ucuncuKatEsiginde = fizikselCita == ucuncuKatEsigi;
    final bool ucuncuKatZatenVerilmis = fizikselCita >= ucKatliEsik;

    final bool kontrolluBolmeDegerlendir =
        hasatBeklentisiVar &&
            !genetikVetoGorunuyor &&
            genetikDegerVarsayimi &&
            gucluTrend &&
            yavruDuzeniStabil &&
            fizikselCita >= 8 &&
            islevselUretimCita >= 8 &&
            aktivasyonOrani >= 0.80 &&
            !riskliSisirme &&
            (bolmeAnaPenceresi || bolmeDikkatPenceresi);

    if (kontrolluBolmeDegerlendir) {
      kararlar.add({
        'kod': bolmeAnaPenceresi ? 'KONTROLLU_BOLME_ADAYI' : 'SINIRLI_BOLME_DEGERLENDIR',
        'kategori': 'eylem',
        'kisa': bolmeAnaPenceresi ? 'Bölme adayı' : 'Bölme dikkat',
        'baslik': bolmeAnaPenceresi
            ? 'Genetik çoğaltma / kontrollü bölme penceresi'
            : 'Sınırlı bölme değerlendirmesi',
        'mesaj': bolmeAnaPenceresi
            ? (l?.kararBolmeGucluMesaj(balAkiminaKalanGun!) ?? 'Koloni güçlü gelişim gösteriyor ve bal akımına yaklaşık $balAkiminaKalanGun gün var. Kat seviyesine yaklaşmış olsa da bu süre içinde oğul baskısı doğabilir; genetik değeri uygunsa kontrollü bölme değerlendirilebilir.')
            : (l?.kararBolmeSinirliMesaj(balAkiminaKalanGun!) ?? 'Koloni güçlü; ancak bal akımına yaklaşık $balAkiminaKalanGun gün kaldığı için bölme kararı sınırlı ve dikkatli düşünülmeli. Ana koloni bala yetişemeyecekse bölme yerine alan/oğul yönetimi öne alınır.'),
        'gerekce': l?.kararBolmeGerekce ?? 'Bölme kararı sadece çıta sayısı değildir: bal akımına kalan süre, gelişim yönü, yavru düzeni, işlevsel çıta ve genetik veto birlikte okundu.',
        'oncelik': bolmeAnaPenceresi ? 93 : 82,
        'tip': 'uyari',
      });
    }

    final bool katDegerlendir = hasatBeklentisiVar && kuluclukKatEsiginde &&
        !katZatenVerilmis &&
        aktivasyonOrani >= 0.95 &&
        islevselUretimCita >= katEsigi &&
        yavruDuzeniStabil &&
        !riskliSisirme &&
        !kilit.eylemEngeli &&
        !kilit.katEngeli;

    if (katDegerlendir) {
      final String esikMetni = suruplukKolonideVar
          ? (l?.kararKatEsikSurupluklu ?? 'Şurupluk + 9 çıta kapasitesi')
          : (l?.kararKatEsikSurupluksuz ?? 'Şurupluksuz 10 çıta kapasitesi');
      final int yuzde = (aktivasyonOrani * 100).round().clamp(0, 100).toInt();
      final String akimMetni = balAkimiAktif
          ? (l?.kararKatAkimAktif ?? 'Bal akımı aktif görünüyor.')
          : (balAkiminaKalanGun == null
          ? (l?.kararKatAkimKontrol ?? 'Bal akımı penceresi ayrıca kontrol edilmeli.')
          : (l?.kararKatAkimKalan(balAkiminaKalanGun) ?? 'Bal akımına yaklaşık $balAkiminaKalanGun gün var.'));

      kararlar.add({
        'kod': 'KAT_VER',
        'kategori': 'eylem',
        'kisa': 'Kat ver',
        'baslik': 'Kat / ballık ver',
        'mesaj': l?.kararKatMesaj(esikMetni, yuzde, akimMetni) ?? '$esikMetni dolmuş ve yaklaşık %$yuzde aktivasyon görülüyor. $akimMetni Bu eşik artık normal çıta ekleme değil, kat/ballık verme eşiğidir.',
        'gerekce': l?.kararKatGerekce ?? 'Şurupluk varsa kuluçkalık 9 çıta, şurupluk kaldırıldıysa 10 çıta kapasite kabul edilir.',
        'oncelik': 91,
        'tip': 'uyari',
      });
    }

    final bool ucuncuKatDegerlendir = hasatBeklentisiVar && ucuncuKatEsiginde &&
        !ucuncuKatZatenVerilmis &&
        aktivasyonOrani >= 0.95 &&
        islevselUretimCita >= ucuncuKatEsigi &&
        yavruDuzeniStabil &&
        !riskliSisirme &&
        !kilit.eylemEngeli &&
        !kilit.katEngeli;

    if (ucuncuKatDegerlendir) {
      final String esikMetni = suruplukKolonideVar
          ? (l?.kararUcuncuKatEsikSurupluklu ?? 'Şurupluk + 19 çıta kapasitesi')
          : (l?.kararUcuncuKatEsikSurupluksuz ?? 'Şurupluksuz 20 çıta kapasitesi');
      final int yuzde = (aktivasyonOrani * 100).round().clamp(0, 100).toInt();
      kararlar.add({
        'kod': 'UCUNCU_KAT_VER',
        'kategori': 'eylem',
        'kisa': '3. kat ver',
        'baslik': '3. kat / ikinci ballık ver',
        'mesaj': l?.kararUcuncuKatMesaj(esikMetni, yuzde) ?? '$esikMetni dolmuş ve yaklaşık %$yuzde aktivasyon görülüyor. Koloni ikinci üst hacmi doldurma eşiğine gelmiş; 3. kat/ikinci ballık değerlendirilmeli.',
        'gerekce': l?.kararUcuncuKatGerekce ?? 'Şurupluk varsa 19 çıta, şurupluk kaldırıldıysa 20 çıta 3. kat verme eşiğidir. Bir sonraki çıta artışı 3 katlı koloni olarak okunur.',
        'oncelik': 92,
        'tip': 'uyari',
      });
    }

    final bool sonMuayenedeCitaArtisiVar = oncekiMuayene != null &&
        _toInt(sonMuayene['citaSayisi']) > _toInt(oncekiMuayene['citaSayisi']);
    final bool alanAcmaUyarisiUygun =
        !kisDonemi &&
            !sonbaharKisHazirlik &&
            !hasatSonrasiSurec &&
            !sonMuayenedeCitaArtisiVar &&
            !kilit.eylemEngeli &&
            !kilit.katEngeli &&
            aktivasyonOrani >= 0.95 &&
            fizikselCita > 0;

    if (alanAcmaUyarisiUygun && !katDegerlendir && !ucuncuKatDegerlendir) {
      final int yuzde = (aktivasyonOrani * 100).round().clamp(0, 100).toInt();
      final bool kuluclukKatBandinda = hasatBeklentisiVar && fizikselCita >= katliEsik;
      final String baslik = kuluclukKatBandinda
          ? 'Alan ihtiyacı / ballık değerlendirme'
          : 'Alan ihtiyacı / çıta ekleme';
      final String mesaj = kuluclukKatBandinda
          ? (l?.kararAlanMesajKulucluk(yuzde) ?? 'Mevcut hacim yaklaşık %$yuzde aktive olmuş. Koloni sıkışmadan ballık/alan yönetimi değerlendirilebilir.')
          : (l?.kararAlanMesajCita(fizikselCita) ?? 'Mevcut $fizikselCita çıtanın tamamına yakını işlevsel kullanılıyor. Koloni sıkışmadan 1 çıta eklenmasi değerlendirilebilir.');
      final String gerekce = sonMuayenedeCitaArtisiVar
          ? ''
          : 'Aktivasyon oranı koloni gücü etiketi değildir; mevcut hacmin dolduğunu ve alan ihtiyacını gösterir.';

      kararlar.add({
        'kod': 'ALAN_CITA_EKLE',
        'kategori': 'eylem',
        'kisa': 'Alan aç',
        'baslik': baslik,
        'mesaj': mesaj,
        'gerekce': gerekce,
        'oncelik': gelisimKolonisi || zayifKoloni ? 68 : 74,
        'tip': 'bilgi',
      });
    }

    if (hasatSonrasiSurec && hasatBeklentisiVar) {
      kararlar.add({
        'kod': 'HASAT_SONRASI_BAKIM',
        'kategori': 'yonetim',
        'kisa': 'Bakım',
        'baslik': 'Hasat sonrası bakım yönü',
        'mesaj': l?.kararHasatSonrasiMesaj ?? 'Hasat sonrası koloni sıkışabilir; stok, alan ve varroa kontrolü yapılmalıdır.',
        'gerekce': l?.kararHasatSonrasiGerekce ?? 'Bal alımı sonrası aynı çıta düzeni artık üretim değil bakım kararıdır.',
        'oncelik': 58,
        'tip': 'bilgi',
      });
    }

    if (sonbaharKisHazirlik) {
      kararlar.add({
        'kod': 'KIS_HAZIRLIK',
        'kategori': 'yonetim',
        'kisa': 'Kış hazırlık',
        'baslik': 'Kışa hazırlık kontrolü',
        'mesaj': l?.kararKisHazirlikMesaj ?? 'Koloni kışa doğru yeterli stok, doğru hacim, düşük varroa baskısı ve uygun nüfusla hazırlanmalı.',
        'gerekce': l?.kararKisHazirlikGerekce ?? 'Kış başarısı genetik seçilim ve sürdürülebilir arılık yönetiminin temel ölçütlerinden biridir.',
        'oncelik': stokCita <= 1 ? 76 : 54,
        'tip': stokCita <= 1 ? 'uyari' : 'bilgi',
      });
    }

    if (kisDonemi) {
      kararlar.add(_kisDonemiKarari(
        stokCita: stokCita,
        fizikselCita: fizikselCita,
        islevselUretimCita: islevselUretimCita,
        gucDususu: gucDususu,
        yavruDuzeniStabil: yavruDuzeniStabil,
        l: l,
      ));
    }

    final uzlasmis = BaglamMotoru.kararCakismalariniUzlastir(kararlar, kilit);
    final double toplamHacimAktivasyonOrani = _toDouble(
      aktivasyon['toplamHacimAktivasyonOrani'] ??
          aktivasyon['toplamAktivasyonOrani'] ??
          aktivasyon['gosterimAktivasyonOrani'],
    ) > 0
        ? _toDouble(
      aktivasyon['toplamHacimAktivasyonOrani'] ??
          aktivasyon['toplamAktivasyonOrani'] ??
          aktivasyon['gosterimAktivasyonOrani'],
    ).clamp(0.0, 1.0).toDouble()
        : (fizikselCita > 0
        ? (_toDouble(aktivasyon['islevselCitaOrta'] ?? islevselUretimCita) / fizikselCita)
        .clamp(0.0, 1.0)
        .toDouble()
        : 1.0);
    final int toplamHacimAktivasyonYuzde =
    (toplamHacimAktivasyonOrani * 100).round().clamp(0, 100).toInt();
    final int yeniHacimAktivasyonYuzde =
    (aktivasyonOrani * 100).round().clamp(0, 100).toInt();
    return uzlasmis.map((karar) {
      return <String, dynamic>{
        ...karar,
        'fizikselCita': fizikselCita,
        'islevselUretimCita': islevselUretimCita,
        'koloniSinifi': koloniSinifi,
        'koloniSinifEtiketi': _koloniSinifEtiketi(koloniSinifi, l: l),
        // Grid ve kullanıcı arayüzü toplam hacim aktivasyonunu gösterir.
        'aktivasyonYuzde': toplamHacimAktivasyonYuzde,
        'toplamHacimAktivasyonOrani': toplamHacimAktivasyonOrani,
        'toplamHacimAktivasyonYuzde': toplamHacimAktivasyonYuzde,
        // İç motor anlamını korumak için yeni hacim oranı ayrıca taşınır.
        'yeniHacimAktivasyonYuzde': yeniHacimAktivasyonYuzde,
      };
    }).toList(growable: false);
  }




  static Map<String, dynamic> _beslemeYonetimKarariUret(
      BeslemeKararSonucu besleme, {
        required bool hasatBeklentisiVar,
        required bool balAkimiAktif,
        required bool balAkimiKesmePenceresi,
        AppLocalizations? l,
      }) {
    final String tip = besleme.tip.trim().isEmpty
        ? (l?.beslemeYonetimVarsayilanBaslik ?? 'Besleme Yönetimi')
        : besleme.tip.trim();
    final String tipNorm = tip.toLowerCase();
    final bool beslemeOnerilmez = tipNorm.contains('önerilmez') ||
        tipNorm.contains('onerilmez');
    final bool hasatVeto = beslemeOnerilmez ||
        (hasatBeklentisiVar && (balAkimiAktif || balAkimiKesmePenceresi));

    final String oncelik = besleme.oncelik.trim().toLowerCase();
    int oncelikPuani;
    if (hasatVeto) {
      oncelikPuani = 95;
    } else if (oncelik == 'kritik') {
      oncelikPuani = 88;
    } else if (oncelik == 'orta') {
      oncelikPuani = 61;
    } else {
      oncelikPuani = 36;
    }

    final bool dozVar = besleme.dozBandi.trim().isNotEmpty &&
        besleme.dozBandi.trim() != '-' &&
        besleme.dozBandi.trim() != '0 ml';
    final bool gerekceVar = besleme.gerekceler.any((g) => g.trim().isNotEmpty);
    final bool mesajVar = besleme.mesaj.trim().isNotEmpty;

    // Düşük öncelikli genel hatırlatma da bilinçli olarak korunur: sistem stok
    // ölçmediği için "besleme şart değil" demez; saha gözlemine bağlayan
    // düşük gürültülü yönetim notu üretir.
    if (!hasatVeto && !mesajVar && !gerekceVar && !dozVar) {
      return const <String, dynamic>{};
    }

    final List<String> detaylar = <String>[];
    if (mesajVar) detaylar.add(besleme.mesaj.trim());
    if (besleme.risk.trim().isNotEmpty) detaylar.add('Risk: ${besleme.risk.trim()}');
    if (dozVar) {
      detaylar.add(l?.beslemeDestekBandi(besleme.dozBandi.trim()) ?? 'Tahmini destek bandı: ${besleme.dozBandi.trim()}');
      if (besleme.tekrarAraligi.trim().isNotEmpty &&
          besleme.tekrarAraligi.trim() != '-') {
        detaylar.add(besleme.tekrarAraligi.trim());
      }
      if (besleme.dozNotu.trim().isNotEmpty && besleme.dozNotu.trim() != '-') {
        detaylar.add(besleme.dozNotu.trim());
      }
    }

    return <String, dynamic>{
      'kod': hasatVeto
          ? 'BESLEME_ONERILMEZ'
          : (dozVar ? 'BESLEME_YONETIM_DESTEGI' : 'BESLEME_YONETIM_TAKIP'),
      'kategori': hasatVeto ? 'veto' : 'yonetim',
      'katman': 'yonetim',
      'kisa': hasatVeto ? 'Besleme yok' : (dozVar ? 'Besleme' : 'Besleme izle'),
      'baslik': hasatVeto ? 'Besleme önerilmez' : tip,
      'mesaj': detaylar.isEmpty ? besleme.mesaj : detaylar.join(' '),
      'gerekce': besleme.gerekceler.join(' '),
      'risk': besleme.risk,
      'oncelik': oncelikPuani,
      'tip': hasatVeto ? 'uyari' : (oncelikPuani >= 60 ? 'bilgi' : 'not'),
      'kararTipi': hasatVeto ? 'VETO' : 'BILGI',
      'gridGosterilebilir': hasatVeto || oncelikPuani >= 60,
      'bastirilabilir': !hasatVeto,
      'dozBandi': besleme.dozBandi,
      'tekrarAraligi': besleme.tekrarAraligi,
      'dozNotu': besleme.dozNotu,
    };
  }




  static String _koloniSinifiBelirle({
    required int fizikselCita,
    required int islevselUretimCita,
    required double aktivasyonOrani,
  }) {
    final int referansCita = islevselUretimCita > 0 ? islevselUretimCita : fizikselCita;
    if (referansCita <= 3) return 'ZAYIF';
    if (referansCita <= 7) return 'GELISIM';
    if (referansCita <= 9) return 'URETIM';
    return 'HASAT';
  }

  static String _koloniSinifEtiketi(String sinif, {AppLocalizations? l}) {
    switch (sinif) {
      case 'ZAYIF':
        return l?.kararSinifiZayif ?? 'Zayıf';
      case 'GELISIM':
        return l?.kararSinifiGelisim ?? 'Gelişim';
      case 'URETIM':
        return l?.kararSinifiUretim ?? 'Üretim';
      case 'HASAT':
        return l?.kararSinifiHasat ?? 'Hasat';
      default:
        return l?.kararSinifiIzleme ?? 'İzleme';
    }
  }

  static Map<String, dynamic> _sezonHedefiBelirle({
    required bool genetikCogaltmaHedefi,
    required bool bolmeToparlanmaHedefi,
    required bool riskliAnaSureciHedefi,
    required bool balAkimiAktif,
    required int? balAkiminaKalanGun,
    required bool kisDonemi,
    required bool sonbaharKisHazirlik,
    required bool hasatSonrasi,
    required String koloniSinifi,
    required int islevselUretimCita,
    required int stokCita,
    required bool gucluTrend,
    required bool gucDususu,
    AppLocalizations? l,
  }) {
    String kod = '';
    String kisa = '';
    String baslik = '';
    String mesaj = '';
    int oncelik = 0;
    String tip = 'bilgi';
    String gerekce = '';

    final bool zayifKoloni = koloniSinifi == 'ZAYIF';
    final bool gelisimKolonisi = koloniSinifi == 'GELISIM';
    final bool hasatGucuVar = islevselUretimCita >= 8 &&
        (koloniSinifi == 'URETIM' || koloniSinifi == 'HASAT');

    if (riskliAnaSureciHedefi) {
      kod = 'RISKLI_ANA_SURECI';
      kisa = 'Ana süreci';
      baslik = l?.sezonHedefRiskliAnaBaslik ?? 'Ana/yavru netleşmeli';
      mesaj = l?.sezonHedefRiskliAnaMesaj ?? 'Ana ve yavru düzeni netleşmeden üretim, kat veya çoğaltma kararı öne alınmaz.';
      gerekce = l?.sezonHedefRiskliAnaGerekce ?? 'Yavru düzeni netleşmeden yapılan işlem koloni kaybı riskini artırır.';
      oncelik = 83;
      tip = 'uyari';
    } else if (bolmeToparlanmaHedefi) {
      kod = 'BOLME_SONRASI_TOPARLANMA';
      kisa = 'Toparlanma';
      baslik = l?.sezonHedefBolmeBaslik ?? 'Bölme toparlanıyor';
      mesaj = l?.sezonHedefBolmeMesaj ?? 'Bu koloni için öncelik ana düzeninin oturması ve nüfusun korunmasıdır.';
      gerekce = l?.sezonHedefBolmeGerekce ?? 'Yeni bölmelerin bu sezon ana hedefi bal değil, sağlıklı koloni düzenine geçmektir.';
      oncelik = 79;
      tip = 'uyari';
    } else if (kisDonemi) {
      kod = 'KIS_DONEMI';
      kisa = 'Kış';
      baslik = l?.sezonHedefKisBaslik ?? 'Kış kontrolü';
      mesaj = l?.sezonHedefKisMesaj ?? 'Kovan gereksiz açılmadan stok, nem ve dış uçuş durumu izlenmelidir.';
      gerekce = l?.sezonHedefKisGerekce ?? 'Kışta gereksiz müdahale salkımı ve ısı düzenini bozar.';
      oncelik = 78;
      tip = 'uyari';
    } else if (sonbaharKisHazirlik) {
      kod = 'KIS_HAZIRLIK';
      kisa = 'Kış hazırlık';
      baslik = l?.sezonHedefKisHazirlikBaslik ?? 'Kışa hazırlık';
      mesaj = l?.sezonHedefKisHazirlikMesaj ?? 'Stok, hacim ve varroa durumu kışa giriş için kontrol edilmelidir.';
      gerekce = l?.sezonHedefKisHazirlikGerekce ?? 'Kışa hazırlık vurgusu sonbahar döneminde anlamlıdır.';
      oncelik = 63;
    } else if (hasatSonrasi) {
      kod = 'HASAT_SONRASI_BAKIM';
      kisa = 'Bakım';
      baslik = l?.sezonHedefHasatSonrasiBaslik ?? 'Hasat sonrası bakım';
      mesaj = l?.sezonHedefHasatSonrasiMesaj ?? 'Hasat sonrası stok, alan ve varroa durumu kontrol edilmelidir.';
      gerekce = l?.sezonHedefHasatSonrasiGerekce ?? 'Bal alımı sonrası koloni düzeni değişir; bakım kararı üretim kararının önüne geçer.';
      oncelik = 62;
    } else if (balAkimiAktif) {
      if (hasatGucuVar) {
        kod = 'HASAT_KOLONISI';
        kisa = 'Hasat';
        baslik = l?.sezonHedefHasatKolonisiBaslik ?? 'Hasat kolonisi';
        mesaj = l?.sezonHedefHasatKolonisiMesaj ?? 'Koloni bal akımı içinde alan ve hasat yönünden izlenebilir.';
        gerekce = l?.sezonHedefHasatKolonisiGerekce ?? 'İşlevsel güç hasat değerlendirmesi için yeterli görünüyor.';
        oncelik = 70;
      } else if (zayifKoloni || gelisimKolonisi) {
        kod = 'AKIMDA_GELISTIRME';
        kisa = 'Gelişim';
        baslik = l?.sezonHedefGelisimKolonisiBaslik ?? 'Gelişim kolonisi';
        mesaj = l?.sezonHedefGelisimAkimMesaj ?? 'Hasat hedefi yok. Öncelik güçlenme, stok ve ana düzenidir.';
        gerekce = l?.sezonHedefGelisimAkimGerekce ?? 'İşlevsel çıta gücü hasat eşiğinin altında.';
        oncelik = 60;
      }
    } else if (genetikCogaltmaHedefi &&
        balAkiminaKalanGun != null &&
        balAkiminaKalanGun >= 35 &&
        balAkiminaKalanGun <= 45) {
      kod = 'GENETIK_COGALTMA_ADAYI';
      kisa = 'Çoğaltma';
      baslik = l?.sezonHedefGenetikCogaltmaBaslik ?? 'Kontrollü çoğaltma adayı';
      mesaj = l?.sezonHedefGenetikCogaltmaMesaj ?? 'Koloni güçlü ve düzenli ilerliyor; süre uygunsa kontrollü bölme değerlendirilebilir.';
      gerekce = l?.sezonHedefGenetikCogaltmaGerekce ?? 'Bal akımına kalan süre ana koloninin tekrar toparlanmasına izin verebilir.';
      oncelik = 87;
      tip = 'uyari';
    } else if (hasatGucuVar && balAkiminaKalanGun != null && balAkiminaKalanGun >= 0 && balAkiminaKalanGun <= 24) {
      kod = 'KISA_HAZIRLIK';
      kisa = 'Hazırlık';
      baslik = l?.sezonHedefKisaHazirlikBaslik ?? 'Bal akımı hazırlık';
      mesaj = l?.sezonHedefKisaHazirlikMesaj ?? 'Bal akımına kısa süre kaldığından koloninin gücünü korumak önemlidir. Hasat kalıntı güvenliği önemsenmelidir. Zaman zaman bal akım döneminde, bal tüketen nüfusu koloniden uzaklaştırmak için teknik bir koloni bölme işlemi yapılabilir. Bu uygulama bilgi olarak verilmiştir. Gerçekleştirebilmek bilgi ve tecrübe gerektirir.';
      gerekce = '';
      oncelik = 80;
      tip = 'uyari';
    } else if (zayifKoloni || gelisimKolonisi || stokCita <= 1 || gucDususu) {
      kod = zayifKoloni ? 'ZAYIF_DESTEK' : 'GELISIM_KOLONISI';
      kisa = zayifKoloni ? 'Destek' : 'Gelişim';
      baslik = zayifKoloni ? (l?.sezonHedefZayifDestekBaslik ?? 'Güçlendirme') : (l?.sezonHedefGelisimKolonisiBaslik ?? 'Gelişim kolonisi');
      mesaj = zayifKoloni
          ? (l?.sezonHedefZayifDestekMesaj ?? 'Öncelik stok, nüfus ve ana düzenini güvenli seviyeye çıkarmaktır.')
          : (l?.sezonHedefGelisimKolonisiMesaj ?? 'Gelişim aşamasındaki koloni. Hasat süreci dışında kabul edilmelidir.');
      gerekce = '';
      oncelik = zayifKoloni ? 72 : 52;
      tip = zayifKoloni ? 'uyari' : 'bilgi';
    } else if (gucluTrend && islevselUretimCita >= 8) {
      kod = 'BAL_ANA_KOLONI';
      kisa = 'Bala hazırla';
      baslik = l?.sezonHedefBalHazirlanBaslik ?? 'Bala hazırlanıyor';
      mesaj = l?.sezonHedefBalHazirlanMesaj ?? 'Koloni üretim gücüne yaklaşıyor; hedef oğul baskısı oluşturmadan bal akımına güçlü girmektir.';
      gerekce = l?.sezonHedefBalHazirlanGerekce ?? 'Gelişim yönü ve işlevsel çıta gücü üretim hedefini destekliyor.';
      oncelik = 58;
    }

    if (kod.isEmpty) {
      return const <String, dynamic>{};
    }

    return {
      'kod': kod,
      'kategori': 'hedef',
      'kisa': kisa,
      'baslik': baslik,
      'mesaj': mesaj,
      'gerekce': gerekce,
      'oncelik': oncelik,
      'tip': tip,
    };
  }

  static List<Map<String, dynamic>> _sapmaSenaryolariUret({
    required List<SurecUyarisi> surecler,
    required int? balAkiminaKalanGun,
    required bool balAkimiAktif,
    required int fizikselCita,
    required int islevselUretimCita,
    required double aktivasyonOrani,
    required int stokCita,
    required bool yavruDuzeniStabil,
    required bool gucDususu,
    required bool gucluTrend,
    required bool bolmeToparlanmaHedefi,
    required bool riskliAnaSureciHedefi,
    required bool hasatSonrasi,
    AppLocalizations? l,
  }) {
    final kararlar = <Map<String, dynamic>>[];
    final bool aktifOgulRiski = surecler.any((s) {
      final kod = s.kod.toUpperCase();
      final grup = s.grup.toUpperCase();
      return kod.contains('OGUL') || grup.contains('OGUL');
    });

    if (riskliAnaSureciHedefi && gucDususu) {
      kararlar.add({
        'kod': 'SAPMA_ANA_SURECI_ZAYIFLAMA',
        'kategori': 'sapma',
        'kisa': 'Sapma',
        'baslik': l?.sapmaAnaSureczyBaslik ?? 'Ana sürecinde zayıflama riski',
        'mesaj': l?.sapmaAnaSureczyMesaj ?? 'Ana/yavru süreci devam ederken koloni gücü düşüyorsa normal bekleme senaryosu zayıflama riskine döner. Bu aşamada üretim değil, ana durumunu netleştirme ve yaşatma hedefi öne çıkar.',
        'gerekce': l?.sapmaAnaSureczyGerekce ?? 'Beklenen akış: ana kazanma → yavru görülmesi → toparlanma. Sapma: süreç uzar ve nüfus düşerse ana kaybı, çiftleşme başarısızlığı veya dış tehdit olasılığı artar.',
        'oncelik': 89,
        'tip': 'uyari',
      });
    }

    if (bolmeToparlanmaHedefi && !yavruDuzeniStabil && gucDususu) {
      kararlar.add({
        'kod': 'SAPMA_BOLME_TUTMADI',
        'kategori': 'sapma',
        'kisa': 'Bölme riski',
        'baslik': l?.sapmaBolmeTutmadiBaslik ?? 'Bölme toparlanmıyor',
        'mesaj': l?.sapmaBolmeTutmadiMesaj ?? 'Bölme sonrası beklenen akış ana düzeninin oturması ve nüfusun korunmasıdır. Yavru düzeni yoksa ve güç düşüyorsa bu koloni için bal hedefi değil, ana tutma/yaşatma süreci öne çıkar.',
        'gerekce': l?.sapmaBolmeTutmadiGerekce ?? 'Bölme süreci sadece gün sayısıyla kapanmaz; yavru düzeni, işlevsel çıta ve yeniden büyüme görülmeden süreç tamamlanmış kabul edilmez.',
        'oncelik': 88,
        'tip': 'uyari',
      });
    }

    if (!balAkimiAktif &&
        balAkiminaKalanGun != null &&
        balAkiminaKalanGun >= 25 &&
        balAkiminaKalanGun <= 45 &&
        gucluTrend &&
        fizikselCita >= 8 &&
        aktivasyonOrani >= 0.80 &&
        !aktifOgulRiski) {
      kararlar.add({
        'kod': 'SAPMA_OGUL_RISKI_YUKSELIR',
        'kategori': 'uyari',
        'kisa': 'Oğul riski',
        'baslik': l?.sapmaOgulRiskiBaslik ?? 'Erken sıkışma oğul riski',
        'mesaj': l?.sapmaOgulRiskiMesaj ?? 'Koloni bal akımı başlamadan güçlü büyümeye devam ediyor. Bu güç yalnızca kat ile yönetilirse bal akımına kadar oğul baskısı doğabilir; genetik değeri uygunsa kontrollü bölme, değilse alan/oğul yönetimi düşünülmelidir.',
        'gerekce': l?.sapmaOgulRiskiGerekce ?? 'Beklenen hedef 11–12 çıtalık güçlü ama yönetilebilir koloniyle bal akımına girmektir. Bu eşiğin erken aşılması üretim değil oğul riski üretebilir.',
        'oncelik': 84,
        'tip': 'uyari',
      });
    }

    if (balAkimiAktif && islevselUretimCita >= 8 && stokCita <= 1) {
      kararlar.add({
        'kod': 'SAPMA_AKIMDA_ALAN_TAKIBI',
        'kategori': 'yonetim',
        'kisa': 'Alan izle',
        'baslik': l?.sapmaAkimAlanTakibiBaslik ?? 'Bal akımında alan izle',
        'mesaj': l?.sapmaAkimAlanTakibiMesaj ?? 'Bal akımı içinde davranış değişir; koloni yavru büyütmeden çok nektar depolamaya yönelebilir. Düşük görünen stok tek başına zayıflık sayılmaz, alan ve sırlanma birlikte izlenir.',
        'gerekce': l?.sapmaAkimAlanTakibiGerekce ?? 'Bal akımı döneminde yavru ve stok verileri normal dönem gibi okunmaz; nektar girişi, ballık alanı ve hasat zamanı birlikte değerlendirilir.',
        'oncelik': 60,
        'tip': 'bilgi',
        'kararTipi': 'BILGI',
      });
    }

    if (hasatSonrasi && stokCita <= 1) {
      kararlar.add({
        'kod': 'SAPMA_HASAT_SONRASI_STOK_RISKI',
        'kategori': 'sapma',
        'kisa': 'Stok riski',
        'baslik': l?.sapmaHasatStokRiskiBaslik ?? 'Hasat sonrası stok düşük',
        'mesaj': l?.sapmaHasatStokRiskiMesaj ?? 'Hasat sonrası beklenen akış stok, varroa ve hacim düzeninin toparlanmasıdır. Stok düşük görünüyorsa üretim dili kapanır; kışa güvenli giriş için stok ve sıkıştırma birlikte değerlendirilir.',
        'gerekce': l?.sapmaHasatStokRiskiGerekce ?? 'Hasat balı alındıktan sonra aynı çıta gücü üretim başarısı değil, kışa hazırlık riski olarak okunabilir.',
        'oncelik': 86,
        'tip': 'uyari',
        'kararTipi': 'UYARI',
      });
    }

    if (hasatSonrasi && fizikselCita >= 8 && islevselUretimCita <= 5) {
      kararlar.add({
        'kod': 'SAPMA_HASAT_SONRASI_HACIM_RISKI',
        'kategori': 'sapma',
        'kisa': 'Hacim riski',
        'baslik': l?.sapmaHasatHacimRiskiBaslik ?? 'Hasat sonrası hacim fazla olabilir',
        'mesaj': l?.sapmaHasatHacimRiskiMesaj ?? 'Fiziksel çıta alanı yüksek ama işlevsel güç düşükse koloni gereksiz hacimde kalabilir. Bu durumda alan daraltma, stok ve kış düzeni üretim kararlarının önüne geçer.',
        'gerekce': l?.sapmaHasatHacimRiskiGerekce ?? 'Hasat sonrası dönemde fazla boş hacim yağmacılık, nem ve ısı yönetimi riskini artırabilir.',
        'oncelik': 78,
        'tip': 'uyari',
        'kararTipi': 'UYARI',
      });
    }

    return kararlar;
  }

  static Map<String, dynamic> _genetikCogaltmaSkoruSinyali({
    required bool genetikDegerVarsayimi,
    required bool genetikVetoGorunuyor,
    required bool gucluTrend,
    required bool yavruDuzeniStabil,
    required int islevselUretimCita,
    required double aktivasyonOrani,
    required bool kisDonemi,
    required int stokCita,
    required bool riskliSisirme,
    required bool gucDususu,
    required bool bolmeToparlanmaHedefi,
    required bool riskliAnaSureciHedefi,
    required bool hasatSonrasi,
    AppLocalizations? l,
  }) {
    final skor = KoloniKararMotoru.genetikCogaltmaSkoruHesapla(
      yavruDuzeniStabil: yavruDuzeniStabil,
      gucluTrend: gucluTrend,
      genetikVeto: genetikVetoGorunuyor,
      riskliSisirme: riskliSisirme,
      gucDususu: gucDususu,
      bolmeToparlanmaHedefi: bolmeToparlanmaHedefi,
      riskliAnaSureciHedefi: riskliAnaSureciHedefi,
      hasatSonrasi: hasatSonrasi,
      kisDonemi: kisDonemi,
      islevselUretimCita: islevselUretimCita,
      aktivasyonOrani: aktivasyonOrani,
      stokCita: stokCita,
    );

    final int puan = _toInt(skor['puan']);
    final String bant = _metin(skor['bant'], 'dusuk');
    final bool veto = skor['veto'] == true;
    final List<String> riskler = (skor['riskler'] is List)
        ? (skor['riskler'] as List)
        .map((e) => e.toString())
        .where((e) => e.trim().isNotEmpty)
        .toList()
        : const <String>[];
    final String ozet = _metin(skor['ozet'], 'Genetik çoğaltma değeri izleniyor.');

    if (veto) {
      return {
        'kod': 'GENETIK_COGALTMA_VETO',
        'kategori': 'genetik',
        'kisa': 'Veto',
        'baslik': l?.genetikVetoBaslik ?? 'Genetik çoğaltma değeri: veto',
        'mesaj': l?.genetikVetoMesaj ?? 'Koloni çoğaltma havuzunda öne çıkarılmaz. Üretim değeri ayrı, genetik yayılım değeri ayrıdır.',
        'gerekce': ozet,
        'risk': riskler.join(' '),
        'oncelik': 66,
        'tip': 'uyari',
        'kararTipi': 'VETO',
        'puan': puan,
        'skorKalemleri': skor['kalemler'],
      };
    }

    if (!genetikDegerVarsayimi && puan < 68) {
      return const <String, dynamic>{};
    }

    final bool yuksek = bant == 'yüksek' || bant == 'yuksek' || puan >= 82;
    return {
      'kod': yuksek ? 'GENETIK_COGALTMA_DEGERI_YUKSEK' : 'GENETIK_COGALTMA_DEGERI_IZLE',
      'kategori': 'genetik',
      'kisa': yuksek ? 'Genetik iyi' : 'Genetik izle',
      'baslik': yuksek
          ? (l?.genetikYuksekBaslik ?? 'Genetik çoğaltma değeri yüksek')
          : (l?.genetikIzleBaslik ?? 'Genetik çoğaltma değeri izleme bandında'),
      'mesaj': ozet,
      'gerekce': l?.genetikSkorGerekce ?? 'Biyolojik güç, yavru düzeni, gelişim istikrarı ve riskler birlikte değerlendirilir.',
      'risk': riskler.join(' '),
      'oncelik': yuksek ? 70 : 50,
      'tip': yuksek ? 'bilgi' : 'notr',
      'kararTipi': 'GENETIK',
      'puan': puan,
      'skorKalemleri': skor['kalemler'],
    };
  }


  static Map<String, dynamic> _kisDonemiKarari({
    required int stokCita,
    required int fizikselCita,
    required int islevselUretimCita,
    required bool gucDususu,
    required bool yavruDuzeniStabil,
    AppLocalizations? l,
  }) {
    if (stokCita <= 1) {
      return {
        'kod': 'KIS_ACLIK_RISKI',
        'kategori': 'yonetim',
        'kisa': 'Açlık riski',
        'baslik': l?.kisAclikRiskiBaslik ?? 'Kış riski: stok yetersiz görünüyor',
        'mesaj': l?.kisAclikRiskiMesaj ?? 'Kış döneminde kovanı gereksiz açma önerilmez; ancak stok çok düşükse açlık riski önceliklidir. Hava ve saha koşulu uygunsa hızlı, sınırlı stok desteği/kek değerlendirilir.',
        'gerekce': l?.kisAclikRiskiGerekce ?? 'Kış yönetiminde temel kural minimum müdahaledir; fakat açlık riski minimum müdahale kuralından daha yüksek önceliklidir.',
        'oncelik': 91,
        'tip': 'uyari',
      };
    }

    if (fizikselCita >= 7 && islevselUretimCita <= 4) {
      return {
        'kod': 'KIS_HACIM_RISKI',
        'kategori': 'yonetim',
        'kisa': 'Hacim',
        'baslik': l?.kisHacimRiskiBaslik ?? 'Kış riski: boş hacim yüksek olabilir',
        'mesaj': l?.kisHacimRiskiMesaj ?? 'Fiziksel hacim yüksek ama işlevsel güç düşük görünüyorsa kış salkımı ısıyı korumakta zorlanabilir. Uygun zamanda hacim daraltma ve nem kontrolü değerlendirilir.',
        'gerekce': l?.kisHacimRiskiGerekce ?? 'Kış başarısı yalnızca stokla değil, koloni hacmi ile arı nüfusunun uyumuyla belirlenir.',
        'oncelik': 82,
        'tip': 'uyari',
      };
    }

    if (gucDususu) {
      return {
        'kod': 'KIS_ZAYIFLAMA_TAKIBI',
        'kategori': 'yonetim',
        'kisa': 'Zayıflama',
        'baslik': l?.kisZayiflamaTakibiBaslik ?? 'Kış riski: güç kaybı izlenmeli',
        'mesaj': l?.kisZayiflamaTakibiMesaj ?? 'Kış döneminde güç kaybı görülüyorsa kovanı açmadan dış gözlem, ağırlık, uçuş deliği ve nem kontrolü öne alınır. Uygun havada sınırlı kontrol yapılabilir.',
        'gerekce': l?.kisZayiflamaTakibiGerekce ?? 'Kışta gereksiz muayene salkımı ve ısı düzenini bozabilir.',
        'oncelik': 80,
        'tip': 'uyari',
      };
    }

    return {
      'kod': 'KIS_DIS_GOZLEM',
      'kategori': 'yonetim',
      'kisa': 'Dış gözlem',
      'baslik': l?.kisDisGozlemBaslik ?? 'Kış yönetimi: gereksiz açma yok',
      'mesaj': l?.kisDisGozlemMesaj ?? 'Koloni için ana yaklaşım kovanı gereksiz açmadan dış gözlem, ağırlık hissi, uçuş deliği, nem ve su girişi kontrolüdür.',
      'gerekce': l?.kisDisGozlemGerekce ?? 'Kış dönemi algoritması üretim değil yaşatma odaklıdır. İlkbahar çıkışı genetik istikrar skoruna veri sağlar.',
      'oncelik': 66,
      'tip': 'bilgi',
    };
  }

  static Future<SurecUyarisi?> _dominantSurecGetir(int koloniId) async {
    final surecDurumu = await SurecMotoru.durumGetir(koloniId);
    return BaglamMotoru.dominantSurecSec(surecDurumu.aktifSurecler);
  }

  static bool _surecKarariBastirirMi(SurecUyarisi? surec) {
    return BaglamMotoru.surecAnaKarariBastirirMi(surec);
  }

  static Map<String, String> _surecAnaKararMap(SurecUyarisi surec, {AppLocalizations? l}) {
    return {
      'kod': 'SUREC_${surec.kod}',
      'baslik': surec.baslik,
      'mesaj': surec.mesaj,
      'neden': _surecNedeni(surec, l: l),
      'tip': _surecTipiNormalizeEt(surec.tip),
    };
  }

  static List<Map<String, String>> _surecAksiyonKartlari(SurecUyarisi surec, {AppLocalizations? l}) {
    return [
      {
        'baslik': surec.baslik,
        'mesaj': surec.mesaj,
        'tip': _surecTipiNormalizeEt(surec.tip),
      },
      {
        'baslik': l?.kararNeden ?? 'Neden',
        'mesaj': _surecNedeni(surec, l: l),
        'tip': 'notr',
      },
    ];
  }

  static String _surecNedeni(SurecUyarisi surec, {AppLocalizations? l}) {
    final grup = surec.grup.trim().toUpperCase();

    switch (grup) {
      case 'ANASIZLIK':
        return l?.surecNedeniAnasizlik ?? 'Ana kazanma / anasızlık süreci biyolojik zamanlamaya bağlıdır. Bu pencere açıkken önce süreç yönetilir.';
      case 'OGUL':
        return l?.surecNedeniOgul ?? 'Ana memesi veya oğul belirtisi aktif saha riskidir. Önce oğul yönetimi yapılır.';
      case 'OGUL_SONRASI':
        return l?.surecNedeniOgulSonrasi ?? 'Oğul sonrası yeni ana ve artçı oğul riski önceliklidir. Süreç kapanmadan genel üretim veya donör dili öne çıkarılmaz.';
      case 'BOLME':
        return l?.surecNedenibolme ?? 'Bölme sonrası koloni düzeni ve ana süreci oturmadan genel performans dili ana karar olarak gösterilmez.';
      case 'HASAT':
        return l?.surecNedeniHasat ?? 'Bal alımı koloni düzenini değiştirir. Önce sıkışık düzen, stres yönetimi, besleme ihtiyacı ve varroa penceresi birlikte değerlendirilir.';
      case 'GELISIM':
        return l?.surecNedeniGelisim ?? 'Gelişim yavaşlığı açıklanması gereken saha durumudur. Önce neden aranır; sonra üretim veya genetik rol yeniden değerlendirilir.';
      default:
        return l?.surecNedeniVarsayilan ?? 'Aktif süreç varsa önce süreç yönetimi öne alınır.';
    }
  }

  static String _surecTipiNormalizeEt(String tip) {
    final temiz = tip.trim().toLowerCase();
    if (temiz == 'kritik') return 'negatif';
    if (temiz == 'uyari' || temiz == 'uyarı') return 'uyari';
    if (temiz == 'pozitif') return 'pozitif';
    return 'notr';
  }

  static Map<String, dynamic> varroaTakvimHatirlatmasiGetir(
      List<Map<String, dynamic>> muayeneler, {
        DateTime? bugun,
        DateTime? balAkimBaslangici,
        AppLocalizations? l,
      }) {
    final bugunTarih = _sadeceGun(bugun ?? DateTime.now());

    if (muayeneler.isEmpty) {
      return {
        'seviye': 'bilgi',
        'baslik': l?.varroaKayitYok ?? 'Varroa kaydı henüz yok.',
        'gerekce': l?.varroaKayitYokGerekce ?? 'Takvimsel varroa hatırlatmaları ilk muayene kayıtlarından sonra daha anlamlı hale gelir.',
        'oneriler': <String>[
          l?.varroaKayitYokOneri ?? 'Muayenelerde yapılan varroa mücadelesini düzenli kaydet.',
        ],
        'sonKayitTarihi': '',
        'sonYontem': '',
      };
    }

    final sirali = List<Map<String, dynamic>>.from(muayeneler)
      ..sort((a, b) => _guvenliTarih(b['tarih']).compareTo(_guvenliTarih(a['tarih'])));

    Map<String, dynamic>? sonMucadele;
    for (final m in sirali) {
      final secimler = VeritabaniServisi.varroaSecimleriniGetir(m);
      final yontem = secimler.isEmpty ? _metin(m['varroaMucadele'], 'Yok') : secimler.join(', ');
      if (yontem != 'Yok' && yontem != '-') {
        sonMucadele = m;
        break;
      }
    }

    final sonTarih = sonMucadele == null ? null : _guvenliTarih(sonMucadele['tarih']);
    final sonYontem = sonMucadele == null
        ? ''
        : (() {
      final secimler = VeritabaniServisi.varroaSecimleriniGetir(sonMucadele!);
      return secimler.isEmpty ? _metin(sonMucadele['varroaMucadele'], '') : secimler.join(', ');
    })();

    bool sonKayitVarMi(int gun) {
      if (sonTarih == null) return false;
      return bugunTarih.difference(sonTarih).inDays <= gun;
    }

    String tarihMetni(DateTime? dt) {
      if (dt == null) return '';
      final gun = dt.day.toString().padLeft(2, '0');
      final ay = dt.month.toString().padLeft(2, '0');
      final yil = dt.year.toString();
      return '$gun.$ay.$yil';
    }

    final ay = bugunTarih.month;
    String seviye = 'bilgi';
    String baslik = l?.varroaTakvimBaslik ?? 'Varroa takvimi izlenmeli.';
    String gerekce = l?.varroaTakvimGerekce ?? 'Mevsime uygun varroa kaydı ve takip disiplini korunmalı.';
    final oneriler = <String>[];

    final temizBalAkimBaslangici = balAkimBaslangici == null
        ? null
        : _sadeceGun(balAkimBaslangici);
    final sonGuvenliMudahaleTarihi = temizBalAkimBaslangici == null
        ? null
        : _sadeceGun(temizBalAkimBaslangici.subtract(const Duration(days: 30)));
    final balAkiminaKalanGun = temizBalAkimBaslangici == null
        ? null
        : temizBalAkimBaslangici.difference(bugunTarih).inDays;
    final sonMudahaleBalAkimOncesiZamanindaMi =
        sonTarih != null &&
            sonGuvenliMudahaleTarihi != null &&
            !sonTarih.isAfter(sonGuvenliMudahaleTarihi);

    if (ay == 2 || ay == 3) {
      if (sonKayitVarMi(45)) {
        seviye = 'iyi';
        baslik = l?.varroaIlkbaharKayitVar ?? 'Erken ilkbahar varroa kaydı var.';
        gerekce = l?.varroaIlkbaharKayitVarGerekce ?? 'Sezon başında yapılan mücadele kaydı görülüyor. Bu, ilkbahar gelişimine daha düşük baskıyla girmeyi destekler.';
        oneriler.add(l?.varroaIlkbaharKayitVarOneri ?? 'Mücadele etkisini sonraki muayenelerde takip et.');
      } else {
        seviye = 'risk';
        baslik = l?.varroaIlkbaharKontrolPlanla ?? 'İlkbahar varroa kontrolü planlanmalı.';
        gerekce = l?.varroaIlkbaharKontrolGerekce ?? 'Erken ilkbahar dönemi varroa baskısını sezon başında düşürmek için önemli bir penceredir.';
        oneriler.add(l?.varroaIlkbaharKontrolOneri ?? 'Kolonileri kontrol et; gerekirse erken ilkbahar müdahalesi planla.');
      }
    } else if (ay == 4 || ay == 5) {
      seviye = sonKayitVarMi(60) ? 'iyi' : 'bilgi';
      baslik = sonKayitVarMi(60)
          ? (l?.varroaBalOncesiKayitVar ?? 'Bal akımı öncesi varroa kaydı görünüyor.')
          : (l?.varroaBalOncesiPlanGozden ?? 'Bal akımı öncesi varroa planı gözden geçirilmeli.');
      gerekce = l?.varroaBalOncesiGerekce ?? 'Bal akımı dönemine girerken varroa planının tamamlanmış olması daha güvenlidir.';
      oneriler.add(l?.varroaBalOncesiOneri ?? 'Bal akımı içinde değil, öncesinde planlama yap.');
    } else if (ay == 6 || ay == 7) {
      seviye = 'bilgi';
      baslik = l?.varroaYazTakip ?? 'Yaz döneminde varroa takibi sürdürülmeli.';
      gerekce = l?.varroaYazTakipGerekce ?? 'Yaz ortasında amaç sürekli ilaçlama değil, düzenli izleme ve hasat sonrası döneme hazırlıktır.';
      oneriler.add(l?.varroaYazTakipOneri ?? 'Muayenelerde varroa kaydını ve koloni gidişatını düzenli izle.');
    } else if (ay == 8 || ay == 9) {
      if (sonKayitVarMi(45)) {
        seviye = 'iyi';
        baslik = l?.varroaKritikKayitVar ?? 'Kritik dönemde varroa mücadelesi kaydı var.';
        gerekce = l?.varroaKritikKayitVarGerekce ?? 'Yaz sonu–erken sonbahar, kış arısının oluştuğu ve varroa baskısının en kritik olduğu dönemdir.';
        oneriler.add(l?.varroaKritikKayitVarOneri ?? 'Hasat sonrası planı sürdür; etkinliği sonraki muayenede kontrol et.');
      } else {
        seviye = 'kritik';
        baslik = l?.varroaHasatSonrasiGecikiyor ?? 'Hasat sonrası varroa mücadelesi gecikiyor.';
        gerekce = l?.varroaHasatSonrasiGecikiyorGerekce ?? 'Yaz sonu–erken sonbaharda kayıt görünmüyor. Bu dönem kış arısının sağlığı açısından en kritik pencere kabul edilir.';
        oneriler.add(l?.varroaHasatSonrasiGecikiyorOneri1 ?? 'Bal sağımı sonrası mücadeleyi geciktirme.');
        oneriler.add(l?.varroaHasatSonrasiGecikiyorOneri2 ?? 'Sonraki muayenede uygulamayı mutlaka kaydet.');
      }
    } else if (ay == 10 || ay == 11) {
      if (sonKayitVarMi(60)) {
        seviye = 'iyi';
        baslik = l?.varroaKisaGirisKayitVar ?? 'Kışa giriş öncesi varroa kaydı var.';
        gerekce = l?.varroaKisaGirisKayitVarGerekce ?? 'Sonbahar sonunda kayıt görünmesi kışa daha düşük yükle girme açısından olumlu bir sinyaldir.';
        oneriler.add(l?.varroaKisaGirisKayitVarOneri ?? 'Kışa girişten önce son genel durumu bir kez daha kontrol et.');
      } else {
        seviye = 'risk';
        baslik = l?.varroaSonbaharKayitEksik ?? 'Sonbahar varroa kaydı eksik görünüyor.';
        gerekce = l?.varroaSonbaharKayitEksikGerekce ?? 'Kışa giriş öncesi dönemde mücadele kaydı görünmüyor. Sonbahar sonu kontrolü ihmal edilmemeli.';
        oneriler.add(l?.varroaSonbaharKayitEksikOneri ?? 'Yavru faaliyeti azaldıysa mücadele gerekliliğini değerlendir.');
      }
    } else {
      if (sonKayitVarMi(90)) {
        seviye = 'bilgi';
        baslik = l?.varroaKisSonbaharKayitVar ?? 'Sonbahar varroa kaydı görünüyor.';
        gerekce = l?.varroaKisSonbaharKayitVarGerekce ?? 'Kış döneminde esas amaç, sonbaharda düşürülmüş yükü koruyarak koloniyi gereksiz strese sokmamaktır.';
        oneriler.add(l?.varroaKisSonbaharKayitVarOneri ?? 'Kovanı gereksiz açmadan genel durumu izle.');
      } else {
        seviye = 'risk';
        baslik = l?.varroaKisGozden ?? 'Kış varroa durumu gözden geçirilmeli.';
        gerekce = l?.varroaKisGozdenGerekce ?? 'Kayıt uzun süredir yok. Yavru faaliyeti azaldıysa durum tekrar değerlendirilmelidir.';
        oneriler.add(l?.varroaKisGozdenOneri ?? 'Yavru durumu ve mevsim koşullarına göre kış kontrolü yap.');
      }
    }

    if (temizBalAkimBaslangici != null &&
        balAkiminaKalanGun != null &&
        balAkiminaKalanGun < 0) {
      if (seviye != 'kritik') {
        seviye = 'risk';
      }
      baslik = l?.varroaBalDonemiDikkat ?? 'Bal döneminde varroa kararı dikkat ister.';
      gerekce = l?.varroaBalDonemiGerekce ?? 'Bal akımı başladıktan sonra kalıntı riski olan kimyasal mücadele önerilmez.';
      oneriler
        ..clear()
        ..add(l?.varroaBalDonemiOneri1 ?? 'Gerekirse yalnızca bala kalıntı riski taşımayan, etikete ve mevzuata uygun yöntemleri değerlendir.')
        ..add(l?.varroaBalDonemiOneri2 ?? 'Kimyasal mücadeleyi hasat sonrasına planla.');
    } else if (temizBalAkimBaslangici != null && balAkiminaKalanGun != null && balAkiminaKalanGun >= 0) {
      final sonGunMetni = tarihMetni(sonGuvenliMudahaleTarihi);
      final balAkimMetni = tarihMetni(temizBalAkimBaslangici);

      if (balAkiminaKalanGun <= 30) {
        if (sonMudahaleBalAkimOncesiZamanindaMi) {
          if (seviye != 'kritik') {
            seviye = 'iyi';
          }
          baslik = l?.varroaBalOncesiTamamlandiBaslik ?? 'Bal akımı öncesi varroa planı tamamlanmış görünüyor.';
          gerekce = l != null
              ? l.varroaBalOncesiTamamlandiGerekce(balAkimMetni, sonGunMetni)
              : '$balAkimMetni tarihinde başlaması beklenen bal akımı öncesi en geç $sonGunMetni tarihine kadar mücadele tamamlanmalıydı. Kayıt buna uygun görünüyor.';
          ekOneri(oneriler, l?.varroaBalOncesiTamamlandiOneri ?? 'Bal akımı içinde yeni mücadele planlama.');
        } else {
          seviye = 'kritik';
          baslik = l?.varroaBalOncesiKapaniyorBaslik ?? 'Bal akımı öncesi mücadele penceresi kapanıyor.';
          gerekce = l != null
              ? l.varroaBalOncesiKapaniyorGerekce(balAkimMetni, sonGunMetni)
              : '$balAkimMetni tarihinde başlaması beklenen bal akımı öncesi kalıntı riskini azaltmak için mücadele en geç $sonGunMetni tarihine kadar tamamlanmış olmalı.';
          oneriler.insert(0, l?.varroaBalOncesiKapaniyorOneri1 ?? 'Bu aşamada bal akımı öncesi kimyasal mücadele planlarken kalıntı riskini dikkate al.');
          ekOneri(oneriler, l?.varroaBalOncesiKapaniyorOneri2 ?? 'Geciktiysen yeni kimyasal uygulamayı bal akımı sonrasına bırakman daha güvenli olabilir.');
        }
      } else if (balAkiminaKalanGun <= 45) {
        if (!sonMudahaleBalAkimOncesiZamanindaMi) {
          if (seviye != 'kritik') {
            seviye = 'risk';
          }
          baslik = l?.varroaBalOncesiSonPencereBaslik ?? 'Bal akımı öncesi son varroa penceresine giriliyor.';
          gerekce = l != null
              ? l.varroaBalOncesiSonPencereGerekce(balAkimMetni, sonGunMetni)
              : '$balAkimMetni tarihinde başlaması beklenen bal akımı için mücadele en geç $sonGunMetni tarihine kadar tamamlanmalı. Süre daralıyor.';
          oneriler.insert(0, l?.varroaBalOncesiSonPencereOneri ?? 'Mücadele gerekiyorsa son güvenli tarihe bırakmadan planla.');
        }
      } else if (!sonMudahaleBalAkimOncesiZamanindaMi) {
        ekOneri(oneriler, l != null
            ? l.varroaBalOncesiSonGunHatirla(sonGunMetni)
            : 'Bal akımı öncesi son güvenli mücadele tarihi: $sonGunMetni.');
      }
    }

    if (sonTarih != null && sonYontem.isNotEmpty) {
      ekOneri(oneriler, l != null
          ? l.varroaSonKayit(tarihMetni(sonTarih), sonYontem)
          : 'Son kayıt: ${tarihMetni(sonTarih)} / $sonYontem.');
    }

    return {
      'seviye': seviye,
      'baslik': baslik,
      'gerekce': gerekce,
      'oneriler': oneriler,
      'sonKayitTarihi': tarihMetni(sonTarih),
      'sonYontem': sonYontem,
    };
  }


  static void ekOneri(List<String> hedef, String metin) {
    final temiz = metin.trim();
    if (temiz.isEmpty) return;
    if (!hedef.contains(temiz)) {
      hedef.add(temiz);
    }
  }

  static DateTime _guvenliTarih(dynamic deger) {
    final metin = (deger ?? '').toString().trim();
    if (metin.isEmpty) return DateTime(1900);

    final iso = DateTime.tryParse(metin);
    if (iso != null) {
      return DateTime(iso.year, iso.month, iso.day);
    }

    final parcalar = metin.split('.');
    if (parcalar.length == 3) {
      final gun = int.tryParse(parcalar[0]) ?? 1;
      final ay = int.tryParse(parcalar[1]) ?? 1;
      final yil = int.tryParse(parcalar[2]) ?? 1900;
      return DateTime(yil, ay, gun);
    }

    return DateTime(1900);
  }

  static DateTime _sadeceGun(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  static bool _sonMuayenedeYavruGorulmediMi(Map<String, dynamic> muayene) {
    final String yavruDuzeni =
    _metin(muayene['yavruDuzeni'], '').trim().toLowerCase();
    final int yavruluCita = _toInt(muayene['yavruluCita']);
    final int gunlukKapaliYavruGoruldu =
    _toInt(muayene['gunlukKapaliYavruGoruldu']);

    if (gunlukKapaliYavruGoruldu == 1) return false;
    if (yavruDuzeni == 'yok' || yavruDuzeni.contains('yok')) return true;
    return yavruluCita <= 0 && yavruDuzeni.isEmpty;
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
    if (deger is num) return deger.toDouble();
    return double.tryParse(deger.toString()) ?? 0.0;
  }

  static bool _boolDeger(dynamic deger, {bool varsayilan = false}) {
    if (deger == null) return varsayilan;
    if (deger is bool) return deger;
    if (deger is int) return deger == 1;
    if (deger is double) return deger.round() == 1;
    final temiz = deger.toString().trim().toLowerCase();
    if (temiz == '1' || temiz == 'true' || temiz == 'evet' || temiz == 'var') return true;
    if (temiz == '0' || temiz == 'false' || temiz == 'hayır' || temiz == 'hayir' || temiz == 'yok') return false;
    return varsayilan;
  }

  static String _metin(dynamic deger, String varsayilan) {
    final metin = (deger ?? '').toString().trim();
    return metin.isEmpty ? varsayilan : metin;
  }
}