// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Itogena Apiary Management';

  @override
  String get girisYukleniyor => 'Preparing data...';

  @override
  String get girisSurumKontrol => 'Checking version...';

  @override
  String get girisYeniSurum => 'Checking for new version...';

  @override
  String get girisAnaSayfaAciliyor => 'Opening home page...';

  @override
  String get girisBaslatmaSorunu => 'A problem occurred during startup.';

  @override
  String girisBaslatmaHatasi(String hata) {
    return 'Startup error: $hata';
  }

  @override
  String get iptal => 'Cancel';

  @override
  String get tamam => 'OK';

  @override
  String get evet => 'Yes';

  @override
  String get hayir => 'No';

  @override
  String get sil => 'Delete';

  @override
  String get duzenle => 'Edit';

  @override
  String get kaydet => 'Save';

  @override
  String get ekle => 'Add';

  @override
  String get vazgec => 'Cancel';

  @override
  String get kapat => 'Close';

  @override
  String get geri => 'Back';

  @override
  String get onayla => 'Confirm';

  @override
  String get hata => 'Error';

  @override
  String get basarili => 'Success';

  @override
  String get uyari => 'Warning';

  @override
  String get bilgi => 'Info';

  @override
  String get yukleniyor => 'Loading...';

  @override
  String get bilinmiyor => 'Unknown';

  @override
  String get bulunamadi => 'Not found.';

  @override
  String get anaSayfa => 'Home';

  @override
  String get kovan => 'Hive';

  @override
  String get koloni => 'Colony';

  @override
  String get arilik => 'Apiary';

  @override
  String get proRozeti => 'PRO';

  @override
  String get proOzellik => 'This feature is available in the PRO version.';

  @override
  String get proYukselt => 'Upgrade to PRO';

  @override
  String get anaSayfaAsistan => 'Your apiary assistant';

  @override
  String get anaSayfaSlogan => 'Record your inspection, we handle the rest.';

  @override
  String get anaSayfaOzellik1Baslik => 'See inside the hive';

  @override
  String get anaSayfaOzellik1Aciklama =>
      'Which frame has brood, which has honey — visually.';

  @override
  String get anaSayfaOzellik2Baslik => 'Know what to do';

  @override
  String get anaSayfaOzellik2Aciklama =>
      'Donor candidate, queen replacement, split — the system tells you.';

  @override
  String get anaSayfaOzellik3Baslik => 'See risks ahead';

  @override
  String get anaSayfaOzellik3Aciklama =>
      'Varroa, bee-eater, robbing — season and colony read together.';

  @override
  String get anaSayfaOzellik4Baslik => 'Get your harvest estimate';

  @override
  String get anaSayfaOzellik4Aciklama =>
      'Estimated honey amount and economic value calculated per colony.';

  @override
  String get anaSayfaRehber => 'User Guide';

  @override
  String get menuArilikYonetimi => 'Apiary Management';

  @override
  String get menuArilikYonetimiAciklama => 'Add colonies, inspect, track';

  @override
  String get menuRaporlar => 'Reports';

  @override
  String get menuRaporlarAciklama =>
      'Apiary-wide statistics, economic value and donor list';

  @override
  String get menuSoyAgaci => 'Lineage Tree';

  @override
  String get menuSoyAgaciAciklama => 'Genetic lineage tracking of colonies';

  @override
  String get menuFormullerHesaplamalar => 'Formulas & Calculations';

  @override
  String get menuFormullerHesaplamalarAciklama =>
      'Syrup and oxalic acid helper screen';

  @override
  String get menuAyarlar => 'Settings';

  @override
  String get menuAyarlarAciklama =>
      'Calibration, honey flow, risk calendar and system preferences';

  @override
  String get karsilastirmaBaslik => 'COMPARATIVE ANALYSIS';

  @override
  String karsilastirmaHata(String hata) {
    return 'Comparison data could not be generated:\n$hata';
  }

  @override
  String get karsilastirmaKoloniBulunamadi => 'No colonies found to compare.';

  @override
  String get karsilastirmaAciklama =>
      'This screen shows two different things together: general performance and genetic selection. High performance alone does not mean donor eligibility. A colony may be strong but remain outside the clean donor pool due to genetic veto.';

  @override
  String karsilastirmaKovanNo(String kovanNo) {
    return 'Hive $kovanNo';
  }

  @override
  String karsilastirmaPerformans(String skor) {
    return 'Performance $skor';
  }

  @override
  String karsilastirmaTemizDonor(String sira) {
    return 'Clean donor #$sira';
  }

  @override
  String get karsilastirmaTemizHavuzda => 'Not leading in clean pool';

  @override
  String get karsilastirmaGenetikVeto => 'Genetic veto';

  @override
  String get karsilastirmaTablo => 'COMPARISON TABLE';

  @override
  String get karsilastirmaKriter => 'Criterion';

  @override
  String get karsilastirmaSistemYorumu => 'SYSTEM INTERPRETATION';

  @override
  String get karsilastirmaSistemYorumuLabel => 'System Interpretation';

  @override
  String get karsilastirmaBiyoloji => 'Biology';

  @override
  String get soyAgaciBaslik => 'LINEAGE TREE';

  @override
  String get soyAgaciBasitHat => 'SIMPLE LINE';

  @override
  String get soyAgaciDetayli => 'DETAILED';

  @override
  String soyAgaciHata(String hata) {
    return 'Lineage tree could not be loaded:\n$hata';
  }

  @override
  String get soyAgaciBulunamadi =>
      'No living lineage found.\nCheck source colony relationships.';

  @override
  String get soyAgaciBasitAciklama =>
      'This view shows living lineages in a simple format. Fully extinct lineages are hidden. Passive colonies appear only within a living lineage.';

  @override
  String get soyAgaciHatOzeti => 'Line Summary';

  @override
  String soyAgaciToplam(int sayi) {
    return 'Total $sayi';
  }

  @override
  String soyAgaciAktif(int sayi) {
    return 'Active $sayi';
  }

  @override
  String soyAgaciPasif(int sayi) {
    return 'Passive $sayi';
  }

  @override
  String get soyAgaciAktifDurum => 'ACTIVE';

  @override
  String get soyAgaciPasifDurum => 'passive';

  @override
  String get formullerBaslik => 'FORMULAS & CALCULATIONS';

  @override
  String get formullerSekmeSurup => 'SYRUP';

  @override
  String get formullerSekmeOksalik => 'OXALIC';

  @override
  String get formullerSekmeBiyoloji => 'BIOLOGY';

  @override
  String get formullerSekmeBalAkimi => 'HONEY FLOW';

  @override
  String get formullerSurupFormulu => 'Syrup Formula';

  @override
  String get formullerSurupAciklama =>
      'Enter the target syrup amount in kg and the system gives you kg of water and kg of sugar. If you use the same measuring container in the field, the 1:1 or 2:1 ratio is maintained in the same logic.';

  @override
  String get formullerSurupOrani => 'Syrup Ratio';

  @override
  String get formullerSurupOraniAciklama =>
      '1:1 is generally for stimulation syrup, 2:1 for stock/winter preparation. This screen is a ratio calculation helper, not a mandatory application order.';

  @override
  String get formullerHedefSerbet => 'Target Syrup';

  @override
  String get formullerHedefSerbetEtiket => 'Target syrup amount';

  @override
  String get formullerHedefSerbetYardim =>
      'Example: Required kg water and kg sugar for 10 kg target syrup is calculated.';

  @override
  String formullerSurupSonuc(String oran) {
    return '$oran Syrup Result';
  }

  @override
  String get formullerHedefSerbetSatir => 'Target Syrup';

  @override
  String get formullerSeker => 'Sugar';

  @override
  String get formullerSu => 'Water';

  @override
  String get formullerSahaKatsayisi => 'Field Factor';

  @override
  String get formullerSurupNot =>
      'Kg calculation is for target syrup weight. If working with volumetric containers, use the same container for ratio; 1:1 means equal containers, 2:1 means two containers of sugar and one of water.';

  @override
  String get formullerOksalikBaslik => 'Oxalic Acid Helper Calculation';

  @override
  String get formullerOksalikAciklama =>
      'This screen is only a calculation helper. For application decisions, the licensed product label, local regulations and veterinary/technical advisor instructions are authoritative.';

  @override
  String get formullerOksalikStandart => 'Standard Formula for 10–15 Hives';

  @override
  String get formullerUygulamaNotu => 'Application Note';

  @override
  String get formullerOksalikNot =>
      'Oxalic acid application is generally more meaningful during broodless or very low brood periods. For temperature, dose, application method and number of repetitions, follow the product label.';

  @override
  String get formullerGuvenlikUyarisi => 'Safety Warning';

  @override
  String get formullerOksalikGuvenlik =>
      'Use protective goggles, gloves and mask. Avoid inhaling acid fumes, skin and eye contact. Do not use unlicensed products, unclear doses or unlabeled mixtures. This screen is a helper calculation screen, not a treatment instruction.';

  @override
  String get formullerBiyolojikTakvim => 'Biological Calendar';

  @override
  String get formullerBiyolojikAciklama =>
      'This screen reads the queen rearing biology calendar through the central AriBiyolojiServisi. Colony detail, process warnings and formulas use the same date logic.';

  @override
  String get formullerAnaKazanmaSureci => 'Queen Rearing Process';

  @override
  String get formullerBaslangicTipi => 'Start type';

  @override
  String get formullerAnasizBirakildi => 'Left Queenless';

  @override
  String get formullerBolmeYapildi => 'Split Made';

  @override
  String get formullerHazirKapaliMeme => 'Ready Sealed Queen Cell';

  @override
  String get formullerHazirCiftlesmisAna => 'Ready Mated Queen';

  @override
  String get formullerBaslangicTarihi => 'Start date';

  @override
  String formullerTakvim(String tip) {
    return '$tip Calendar';
  }

  @override
  String get formullerSahaNotu => 'Field Note';

  @override
  String get formullerAnaKazanmaSahaNot =>
      'Day count includes the start day. If daily/sealed brood is seen, check the relevant box in the inspection screen and the queen rearing process closes.';

  @override
  String get formullerKapaliIsciYavrusu => 'Sealed Worker Brood Emergence';

  @override
  String get formullerKapaliIsciTarih => 'Date sealed worker brood was seen';

  @override
  String get formullerKapaliIsciSonuc => 'Sealed Worker Brood Emergence Window';

  @override
  String get formullerKapaliErkekYavrusu => 'Sealed Drone Brood Emergence';

  @override
  String get formullerKapaliErkekTarih => 'Date sealed drone brood was seen';

  @override
  String get formullerKapaliErkekSonuc => 'Sealed Drone Brood Emergence Window';

  @override
  String get formullerBalAkimiKarar => 'Honey Flow Decision';

  @override
  String get formullerBalAkimiAciklama =>
      'The system uses a 57-day field planning threshold to avoid entering the honey flow weak. 42 days is the biological duration from egg to forager; these two are not the same thing.';

  @override
  String get formullerBalAkimTarihi => 'Honey flow start date';

  @override
  String get formullerMevcutCita => 'Current frame count';

  @override
  String get formullerCitaOrnek => 'Example: 9';

  @override
  String get formullerTarihBekleniyor => 'Waiting for Date';

  @override
  String get formullerTarihBekleniyorAciklama =>
      'Select the honey flow start date first to generate a decision.';

  @override
  String get formullerKarar => 'Decision';

  @override
  String get formullerSonGuvenliBolme => 'Last safe split date';

  @override
  String get formullerPlanlamaEsigi => 'Planning threshold';

  @override
  String get formullerPlanlamaEsigiDeger => '57 days';

  @override
  String get formullerBiyolojikSure => 'Biological duration';

  @override
  String get formullerBiyolojikSureDeger => '42 days: egg to forager';

  @override
  String get formullerMevcutGuc => 'Current strength';

  @override
  String formullerMevcutGucDeger(int cita) {
    return '$cita frames';
  }

  @override
  String get formullerHedefAltSinir => 'Target lower limit';

  @override
  String get formullerEnFazlaAlinabilir => 'Max removable';

  @override
  String get formullerBolmePenceresiYok =>
      'No safe split window appears to be open at this strength.';

  @override
  String formullerBolmePenceresiVar(int max) {
    return 'If more than $max frames are removed, the colony may enter the honey flow weak.';
  }

  @override
  String get formullerKabulKontrol => 'Acceptance check window';

  @override
  String get formullerMemeKapanma => 'Estimated cell capping';

  @override
  String get formullerAnaCikisi => 'Estimated queen emergence';

  @override
  String get formullerCiftlesme => 'Mating flight window';

  @override
  String get formullerYumurtlamaKontrol => 'Laying check window';

  @override
  String get formullerKovanaDokunma => 'Hive disturbance window';

  @override
  String get formullerBaslangic => 'Start';

  @override
  String get formullerTahminiCikis => 'Estimated emergence';

  @override
  String get formullerUygulamaModeli => 'Drizzle';

  @override
  String raporListeHata(String hata) {
    return 'Report list could not be generated:\n$hata';
  }

  @override
  String get raporListeBos => 'No active colonies found for this list.';

  @override
  String raporListeAciklama(String arilik, int adet) {
    return 'This list is generated from active colonies in the $arilik apiary. Ranking is primarily by score. In case of tie, reproduction first, then production, then donor eligibility. Total $adet records.';
  }

  @override
  String get raporListeSira => 'RANK';

  @override
  String get raporListeKoloniNo => 'COLONY NO';

  @override
  String get raporListeDurum => 'STATUS';

  @override
  String raporListeSkorCita(int skor, int cita) {
    return 'Score $skor  •  $cita frames';
  }

  @override
  String muayeneDetayBaslik(String kovanNo) {
    return 'HIVE $kovanNo / INSPECTION';
  }

  @override
  String get muayeneDetayGenelBilgi => 'GENERAL INFO';

  @override
  String get muayeneDetayNotlar => 'NOTES';

  @override
  String get muayeneDetayTetikler => 'TRIGGERS';

  @override
  String get muayeneDetaySurec => 'PROCESS RECORDS';

  @override
  String get muayeneDetayTarih => 'Date';

  @override
  String get muayeneDetayCita => 'Frames';

  @override
  String get muayeneDetayYavruluCita => 'Brood Frames';

  @override
  String get muayeneDetayBalHasat => 'Honey/Harvest';

  @override
  String get muayeneDetayYavruDuzeni => 'Brood Pattern';

  @override
  String get muayeneDetayMizac => 'Temperament';

  @override
  String get muayeneDetayBesleme => 'Feeding';

  @override
  String get muayeneDetayVarroaMucadele => 'Varroa Treatment';

  @override
  String get muayeneDetayYok => 'None';

  @override
  String get muayeneDetayEvet => 'Yes';

  @override
  String get muayeneDetayKapaliMeme => 'Ready sealed queen cell';

  @override
  String get muayeneDetayHazirAna => 'Ready mated queen given';

  @override
  String get muayeneDetayKendiAnasi => 'Will raise own queen';

  @override
  String get muayeneDetayOgulBelirtisi => 'Swarm Sign';

  @override
  String get muayeneDetayOgulAtti => 'Swarmed';

  @override
  String get muayeneDetayBolmeYapildi => 'Split Made';

  @override
  String get muayeneDetayAnasizBirakildi => 'Left Queenless';

  @override
  String get muayeneDetayKovanSondu => 'Hive Died';

  @override
  String get muayeneDetayKapaliYavruAktarildi =>
      'Sealed Brood Frame Transferred';

  @override
  String get muayeneDetayAnaKazanmaYontemi => 'Queen Rearing Method';

  @override
  String get muayeneDetayDisaridanAna => 'Outside Mated Queen Given';

  @override
  String get muayeneDetayGunlukYavru => 'Daily / Sealed Brood Seen';

  @override
  String get muayeneDetaySuruplukKaldirildi => 'Feeder Removed';

  @override
  String get muayeneDetayDroneKesimi => 'Drone Comb Removal';

  @override
  String get muayeneDetayTimol => 'Thymol';

  @override
  String get muayeneDetayAmitraz => 'Amitraz';

  @override
  String get muayeneDetayFormik => 'Formic';

  @override
  String get muayeneDetayOksalik => 'Oxalic';

  @override
  String get muayeneDetayYavruYokAnaSureci =>
      'Brood pattern recorded as \"None\" in this inspection. In the context of active queen rearing/split/swarm, the system first interprets this through the biological day window; early period is considered normal waiting, delayed period is evaluated as queenlessness diagnosis.';

  @override
  String get muayeneDetayYavruYokBasit =>
      'Brood pattern recorded as \"None\" in this inspection. The system accepts brood frames as 0 in the biological model and reads the colony\'s recovery capacity with this information.';

  @override
  String get hatAnalizAppBarBaslik => 'Lineage Analysis';

  @override
  String get hatAnalizSayfaBasligi => 'LINEAGE-BASED SELECTION ANALYSIS';

  @override
  String get hatAnalizAciklama =>
      'This screen shows lineages with living continuity. The goal is to quickly see root lineages suitable for donor use and evaluate extinctions within living lineages without losing them.';

  @override
  String get hatAnalizUstAciklama =>
      'Only lineages with living continuity are shown on this screen. Completely closed lineages that left no active colonies are not included in the main list.';

  @override
  String get hatAnalizToplamYasayan => 'Total living lineages';

  @override
  String get hatAnalizFiltre => 'FILTER';

  @override
  String get hatAnalizBos => 'No living lineage found for this filter.';

  @override
  String get hatAnalizNeden => 'REASON / NOTE';

  @override
  String hatAnalizAktifHat(String kovan) {
    return 'Active Lineage: $kovan';
  }

  @override
  String hatAnalizAktifTemsilci(String kovan) {
    return 'Active Lineage Representative: $kovan';
  }

  @override
  String hatAnalizSonmusDurum(String karar, String kok) {
    return '$karar · Root $kok extinct';
  }

  @override
  String get hatAnalizAktifHatiAc => 'Open Active Lineage';

  @override
  String get hatAnalizAktifTemsilciAc => 'Open Active Representative';

  @override
  String get hatAnalizToplam => 'Total';

  @override
  String get hatAnalizAktif => 'Active';

  @override
  String get hatAnalizSonmus => 'Extinct';

  @override
  String get hatAnalizSonmeOrani => 'Extinction %';

  @override
  String get hatAnalizOrtMaksCita => 'Avg. Max Frames';

  @override
  String get hatAnalizOrtBalCita => 'Avg. Honey Frames';

  @override
  String get hatAnalizTumu => 'All';

  @override
  String get hatAnalizDonorHat => 'Donor Lineage';

  @override
  String get hatAnalizGucluUretim => 'Strong Production Line';

  @override
  String get hatAnalizOperasyonel => 'Operational Line';

  @override
  String get hatAnalizRiskli => 'At-Risk Line';

  @override
  String get hatAnalizTakip => 'Needs Monitoring';

  @override
  String get hatAnalizVeriYetersiz => 'Insufficient Data';

  @override
  String get hatAnalizSayacUretim => 'Production';

  @override
  String get hatAnalizSayacOperasyonel => 'Operational';

  @override
  String get hatAnalizSayacRiskli => 'At-Risk';

  @override
  String get hatAnalizSayacTakip => 'Monitor';

  @override
  String get hatAnalizSayacVeriAz => 'Low Data';

  @override
  String get karsilastirmaSecimMinKoloni =>
      'You must select at least 2 colonies for comparison.';

  @override
  String get karsilastirmaSecimMaxKoloni =>
      'You can select at most 3 colonies.';

  @override
  String get karsilastirmaSecimAciklama =>
      'Comparison is made with up to 3 colonies. The system tries to make the difference between general performance and genetic selection visible in the same table.';

  @override
  String get karsilastirmaSecimSkor => 'Score';

  @override
  String get karsilastirmaSecimSonCita => 'Last Frames';

  @override
  String get karsilastirmaSecimBal => 'Honey';

  @override
  String get karsilastirmaSecimBekle => 'Preparing...';

  @override
  String get karsilastirmaSecimButon => 'Compare';

  @override
  String get karsilastirmaPerformansBaslik => 'Comparative Analysis';

  @override
  String get karsilastirmaSistemYorumuPerf =>
      'SYSTEM INTERPRETATION (PERFORMANCE + SELECTION)';

  @override
  String get karsilastirmaDonorDurumu => 'Donor Status';

  @override
  String get karsilastirmaUreme => 'Reproduction';

  @override
  String get karsilastirmaUretim => 'Production';

  @override
  String get karsilastirmaDayaniklilik => 'Resilience';

  @override
  String get karsilastirmaKisCikisi => 'Winter Exit';

  @override
  String get karsilastirmaHatGucu => 'Line Strength';

  @override
  String get karsilastirmaDavranis => 'Behavior';

  @override
  String get karsilastirmaVeriGuveni => 'Data Confidence';

  @override
  String get karsilastirmaOgulDurumu => 'Swarm Status';
}
