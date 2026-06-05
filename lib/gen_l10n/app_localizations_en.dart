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

  @override
  String get kolonilerBaslik => 'Colonies';

  @override
  String get kolonilerDonorHazirlaniyor => 'Colonies • Preparing donor badges';

  @override
  String kolonilerSeciliSayi(int sayi) {
    return '$sayi colonies selected';
  }

  @override
  String kolonilerAktifSekme(int sayi) {
    return 'ACTIVE ($sayi)';
  }

  @override
  String kolonilerSonmusSekme(int sayi) {
    return 'EXTINCT ($sayi)';
  }

  @override
  String get kolonilerKarsilastirmaModuSadece =>
      'Comparison mode is only available for active colonies.';

  @override
  String get kolonilerDuzenleBaslik => 'Edit Colony';

  @override
  String kolonilerDuzenleOnay(String kovanNo) {
    return 'Open editing screen for colony $kovanNo?';
  }

  @override
  String get kolonilerDevamEt => 'Continue';

  @override
  String get kolonilerSilBaslik => 'Delete Colony';

  @override
  String kolonilerSilOnay(String kovanNo) {
    return 'Delete colony $kovanNo?\n\nThis action cannot be undone. Related number history and event records will also be deleted.';
  }

  @override
  String kolonilerSilindi(String kovanNo) {
    return 'Colony $kovanNo deleted.';
  }

  @override
  String kolonilerSilHata(String hata) {
    return 'Error occurred while deleting colony: $hata';
  }

  @override
  String get kolonilerAktifBos => 'No active colony records in this apiary.';

  @override
  String get kolonilerSonmusBos => 'No extinct colony records in this apiary.';

  @override
  String get kolonilerKovanAra => 'Search hive...';

  @override
  String get kolonilerAramaTemizle => 'Clear search';

  @override
  String get kolonilerFiltreYeniBolme => 'New splits';

  @override
  String get kolonilerFiltreYeniOgul => 'New swarms';

  @override
  String get kolonilerFiltreAlarm => 'Alarm';

  @override
  String get kolonilerFiltreYavruYok => 'No brood';

  @override
  String get kolonilerFiltreHasat => 'Harvest candidate';

  @override
  String get kolonilerDonorRozetAciklama =>
      'Badges: 1/2/3 show top donor candidates, D shows other candidates in donor pool. If genetic veto exists, it is explained separately in the detail screen.';

  @override
  String get kolonilerKarsilastirmaModuBaslik => 'COMPARISON MODE';

  @override
  String get kolonilerKarsilastirmaModuInfo =>
      'Tap 2 or 3 active colonies you want to compare. While this mode is on, selection is made instead of colony detail.';

  @override
  String kolonilerSeciliKoloniSayisi(int sayi) {
    return 'Selected colonies: $sayi / 3';
  }

  @override
  String kolonilerKarsilastirButon(int sayi) {
    return 'Compare ($sayi)';
  }

  @override
  String get kolonilerPasif => 'PASSIVE';

  @override
  String get kolonilerSondu => 'EXTINCT';

  @override
  String kolonilerSonCita(int cita) {
    return '$cita frames';
  }

  @override
  String get raporlarSayfaBaslik => 'REPORTS';

  @override
  String get raporlarArilikEtiketi => 'Apiary:';

  @override
  String get raporlarArilikBulunamadi => 'No registered apiary found.';

  @override
  String get raporlarArilikSec => 'Select the apiary to report on';

  @override
  String get raporlarGenelDurum => 'GENERAL STATUS';

  @override
  String get raporlarAktifKovan => 'Active hives';

  @override
  String get raporlarOrtaSkor => 'Avg. score';

  @override
  String get raporlarAriliCita => 'Bee frames';

  @override
  String get raporlarDonorler => 'DONORS';

  @override
  String get raporlarHesaplaniyor => 'Calculating';

  @override
  String get raporlarHenuzYok => 'None yet';

  @override
  String get raporlarIlkUcGuclu => 'TOP 3 STRONG';

  @override
  String get raporlarRaporSec => 'SELECT REPORT';

  @override
  String get raporlarListeLazyAciklama =>
      'Heavy list calculations don\'t run on first open. Only loaded when you open the list you want to see.';

  @override
  String get raporlarGucludenZayifaBaslik => 'Strongest to Weakest';

  @override
  String get raporlarGucludenZayifaAlt =>
      'All active colonies sorted from highest to lowest score.';

  @override
  String get raporlarGucludenZayifaListeBaslik => 'STRONGEST TO WEAKEST';

  @override
  String get raporlarZayiftanGucluye => 'Weakest to Strongest';

  @override
  String get raporlarZayiftanGucluAlt =>
      'All active colonies sorted from lowest to highest score.';

  @override
  String get raporlarZayiftanGucluListeBaslik => 'WEAKEST TO STRONGEST';

  @override
  String get raporlarDonorAdaylariBaslik => 'Donor Candidates';

  @override
  String get raporlarDonorAdaylariAlt =>
      'Donor pool listed starting from rank 1.';

  @override
  String get raporlarDonorAdaylariListeBaslik => 'DONOR CANDIDATES';

  @override
  String get raporlarGenetikVetoBaslik => 'Genetic Veto';

  @override
  String get raporlarGenetikVetoAlt =>
      'Veto records excluded from donor pool, sorted within themselves.';

  @override
  String get raporlarGenetikVetoListeBaslik => 'GENETIC VETO';

  @override
  String get raporlarEkonomikDegerBaslik => 'Economic Value';

  @override
  String get raporlarEkonomikDegerAlt =>
      'Apiary economic value and honey potential calculated on a separate screen.';

  @override
  String get raporlarIstatistikHesapla => 'Calculate apiary statistics';

  @override
  String get raporlarIstatistikHesaplaniyor =>
      'Calculating apiary statistics...';

  @override
  String raporlarIstatistikHata(String hata) {
    return 'Apiary statistics could not be calculated: $hata';
  }

  @override
  String get raporlarTekrarHesapla => 'Recalculate';

  @override
  String get raporlarArilikIstatistikleri => 'APIARY STATISTICS';

  @override
  String get raporlarToplamCita => 'Total frames';

  @override
  String get raporlarBalTemasi => 'Honey contact';

  @override
  String get raporlarAktivasyonFarki => 'Activation';

  @override
  String get raporlarTahminiAri => 'Est. bees';

  @override
  String get raporlarGuclu => 'Strong';

  @override
  String get raporlarOrta => 'Medium';

  @override
  String get raporlarZayif => 'Weak';

  @override
  String ekDegerAppBarBaslik(String arilikAd) {
    return '$arilikAd ECONOMIC VALUE';
  }

  @override
  String ekDegerHata(String hata) {
    return 'Economic value could not be calculated:\n$hata';
  }

  @override
  String get ekDegerKartBaslik => 'ECONOMIC VALUE';

  @override
  String ekDegerTahminiToplam(String deger) {
    return 'Estimated total value: $deger TL';
  }

  @override
  String ekDegerAktivasyonluBalliCita(String cita) {
    return 'Activation-weighted honey frames: $cita frames';
  }

  @override
  String ekDegerTahminiBalAraligi(
      String minKg, String maxKg, String minTL, String maxTL) {
    return 'Est. honey: $minKg–$maxKg kg / $minTL–$maxTL TL';
  }

  @override
  String get ekDegerHesapAciklama =>
      'This calculation reads frames in honey/honey position in the biological model at activation level; empty frames, total physical frames or empty drawn combs are not counted as honey.';

  @override
  String get ekDegerBalFiyati => 'Honey sale price (kg/TL)';

  @override
  String get ekDegerAriliCita => 'Bee frame value';

  @override
  String get ekDegerBosKovan => 'Empty hive value';

  @override
  String get ekDegerBosKabarmisPetek => 'Empty drawn comb count';

  @override
  String get ekDegerBosKabarmisPetekBirim => 'Empty drawn comb unit value';

  @override
  String get koloniDetayMuayeneSil => 'Delete Inspection';

  @override
  String koloniDetayMuayeneSilOnay(String tarih) {
    return 'Delete inspection dated $tarih?\n\nThis action cannot be undone.';
  }

  @override
  String get koloniDetayMuayeneSilindi => 'Inspection deleted.';

  @override
  String get koloniDetayNumaraDegistir => 'Change Colony Number';

  @override
  String get koloniDetayNumaraAciklama =>
      'This changes the colony\'s field number. Lineage and inspection history are preserved.';

  @override
  String get koloniDetayYeniNumara => 'New colony / hive number';

  @override
  String koloniDetayNumaraGuncellendi(String no) {
    return 'Colony number updated to $no.';
  }

  @override
  String koloniDetayAppBarBaslik(String no) {
    return 'HIVE $no';
  }

  @override
  String get koloniDetayTabGenelDurum => 'GENERAL STATUS';

  @override
  String get koloniDetayTabMuayeneler => 'INSPECTIONS';

  @override
  String get koloniDetayTabBiyolojikModel => 'BIOLOGICAL MODEL';

  @override
  String get koloniDetayTabPerformans => 'PERFORMANCE';

  @override
  String get koloniDetayMuayeneEkle => 'Add Inspection';

  @override
  String get koloniDetayOzetSurec => 'PROCESS';

  @override
  String get koloniDetayOzetBiyoloji => 'BIOLOGY';

  @override
  String get koloniDetayOzetYonetim => 'MANAGEMENT';

  @override
  String get koloniDetayOzetGenetik => 'GENETIC';

  @override
  String get koloniDetayPerfVeriBulunamadi =>
      'Performance summary data not found.';

  @override
  String get ayarlarBaslik => 'SETTINGS & CALIBRATION';

  @override
  String get ayarlarTabGenel => 'GENERAL';

  @override
  String get ayarlarTabSistem => 'SYSTEM';

  @override
  String get ayarlarKaydediliyor => 'SAVING...';

  @override
  String get ayarlarKaydet => 'SAVE GENERAL SETTINGS';

  @override
  String ayarlarKaydedilemedi(String hata) {
    return 'Settings could not be saved: $hata';
  }

  @override
  String get ayarlarYedekHazir => 'Backup ready. Save it to a safe location.';

  @override
  String ayarlarYedekHata(String hata) {
    return 'Error occurred while taking backup: $hata';
  }

  @override
  String get ayarlarGeriYukleBaslik => 'RESTORE FROM BACKUP';

  @override
  String get ayarlarGeriYukleButon => 'Start Loading';

  @override
  String get ayarlarGeriYukleTamamlandi => 'Restore from backup completed.';

  @override
  String ayarlarGeriYukleHata(String hata) {
    return 'Error occurred while loading backup: $hata';
  }

  @override
  String ayarlarGuncellemHata(String hata) {
    return 'Update check failed: $hata';
  }

  @override
  String get ayarlarKalibrasyonTamam =>
      'Apiary calibration defined. System can use season and honey flow context.';

  @override
  String get ayarlarKalibrasyonEksik =>
      'Apiary calibration missing. Season and honey flow definitions should be reviewed.';

  @override
  String get ayarlarTarihFormatNotu =>
      'Date display is in day/month format; storage format is maintained internally.';

  @override
  String ayarlarBaslangicTarih(String tarih) {
    return 'Start: $tarih';
  }

  @override
  String ayarlarBitisTarih(String tarih) {
    return 'End: $tarih';
  }

  @override
  String get ayarlarDavranisTercihi => 'BEHAVIOR PREFERENCE';

  @override
  String get ayarlarDavranisTercihiAciklama =>
      'This setting only affects the genetic selection and donor filter side. It does not change core thresholds.';

  @override
  String get ayarlarDavranisStandart => 'Standard';

  @override
  String get ayarlarDavranisStandartAciklama =>
      'Manageable colonies are prioritized. Aggression is a more significant negative on the selection side.';

  @override
  String get ayarlarDavranisEsnek => 'Flexible';

  @override
  String get ayarlarDavranisEsnekAciklama =>
      'If strength and yield stand out, behavior data is interpreted more leniently on the selection side.';

  @override
  String get ayarlarKalibrasyonKapsami => 'CALIBRATION SCOPE';

  @override
  String get ayarlarKalibrasyonKapsamiAciklama =>
      'Honey flow and general risk calendar are saved according to this scope. If all apiaries selected, general defaults are updated. If one apiary selected, only custom calibration for that apiary is created.';

  @override
  String get ayarlarKalibrasyonLabel => 'Use this calibration';

  @override
  String get ayarlarKalibrasyonTumAriliklar => 'Use for all apiaries';

  @override
  String ayarlarKalibrasyonYalnizca(String ad) {
    return 'Use only for $ad apiary';
  }

  @override
  String get ayarlarKalibrasyonGenelAciklama =>
      'You are currently editing the general default calibration. All apiaries without custom settings use this.';

  @override
  String ayarlarKalibrasyonOzelAciklama(String kapsam) {
    return 'Custom calibration area open for $kapsam. Honey flow and risk calendar changes here do not affect other apiaries.';
  }

  @override
  String get ayarlarBalAkimiBilgi =>
      'Honey flow windows are the main reference for biological countdowns. First window is mandatory, second window is kept open only when truly needed.';

  @override
  String get ayarlarIkinciBalAkimi => 'Use 2nd honey flow';

  @override
  String get ayarlarIkinciBalAkimiAciklama =>
      'E.g.: August / September pine honey. Leave off if not needed.';

  @override
  String get ayarlarRiskTakvimiBilgi =>
      'The general risk calendar does not produce colony-specific decisions. It reminds about seasonal risks like bee-eater, hornet, robbing, wax moth and mouse on the apiary screen. You can narrow dates according to actual pressure periods in your region.';

  @override
  String get ayarlarAriKusuDonemi => 'Bee-eater Risk Period';

  @override
  String get ayarlarAriKusuAciklama =>
      'Default: May – August. You can narrow it according to migration and pressure periods in your region.';

  @override
  String get ayarlarEsekArisiDonemi => 'Hornet / Wasp Risk Period';

  @override
  String get ayarlarEsekArisiAciklama =>
      'Default: July – October. Adjust according to when pressure intensifies.';

  @override
  String get ayarlarYagmacilikDonemi => 'Robbing Risk Period';

  @override
  String get ayarlarYagmacilikAciklama =>
      'Default: July – September. Adjust according to post-harvest and drought period pressure.';

  @override
  String get ayarlarMumGuvesiDonemi => 'Wax Moth Risk Period';

  @override
  String get ayarlarMumGuvesiAciklama =>
      'Default: June – September. Adjust according to hot period and weak colony risk.';

  @override
  String get ayarlarFareDonemi => 'Mouse Risk Period';

  @override
  String get ayarlarFareAciklama =>
      'Default: November – February. This range crosses year-end; the system interprets this correctly.';

  @override
  String get ayarlarKisDonemi => 'Winter / Resilience Period';

  @override
  String get ayarlarKisAciklama =>
      'Default structure is September 1 – March 15. Fine-tune according to your field if needed.';

  @override
  String get ayarlarUretimDonemi => 'Active / Production Period';

  @override
  String get ayarlarUretimAciklama =>
      'Default structure is March 15 – August 31. Fine-tune according to your field if needed.';

  @override
  String get ayarlarBalAkimiAraligi1 => 'Honey Flow Period 1';

  @override
  String get ayarlarBalAkimiAraligi1Aciklama =>
      'First main flow. E.g.: late May / early June.';

  @override
  String get ayarlarBalAkimiAraligi2 => 'Honey Flow Period 2';

  @override
  String get ayarlarBalAkimiAraligi2Aciklama =>
      'Second flow. E.g.: August / September pine honey.';

  @override
  String get ayarlarRehberiAc => 'Open user guide';

  @override
  String get ayarlarSistemBilgi =>
      'Backup and restore flow is maintained in the system. After restore, a maintenance step is run and decision cache is cleared.';

  @override
  String get ayarlarUygulamaKimligi => 'APPLICATION IDENTITY';

  @override
  String get ayarlarKimlikUygulama => 'Application';

  @override
  String get ayarlarKimlikTanim => 'Description';

  @override
  String get ayarlarKimlikSurum => 'Version';

  @override
  String get ayarlarKimlikYil => 'Year';

  @override
  String get ayarlarKimlikUretici => 'Producer';

  @override
  String get ayarlarKimlikVeri => 'Data';

  @override
  String get ayarlarKimlikSistemAmaci =>
      'System purpose: reading simple field data through time, event and process logic to produce actionable colony decisions.';

  @override
  String get ayarlarSurumYukleniyor => 'Loading';

  @override
  String get ayarlarYedekAl => 'Take Backup';

  @override
  String get ayarlarYedekAlAciklama =>
      'Create and share all data as a JSON backup file.';

  @override
  String get ayarlarYedekYukle => 'Restore from Backup';

  @override
  String get ayarlarYedekYukleAciklama =>
      'Select a previously taken JSON backup and load it in place of current data.';

  @override
  String get ayarlarGuncelleKontrol => 'Check for Updates';

  @override
  String get ayarlarGuncelleKontrolAciklama =>
      'If a new version is available, first prompts for backup, then opens the secure APK link.';

  @override
  String get ayarlarYedekUyari =>
      'Restoring from backup completely replaces current data. Taking a new backup immediately before loading is the safest approach.';

  @override
  String get ayarlarGizlilik => 'Privacy Policy';

  @override
  String get ayarlarGizlilikAciklama =>
      'View app data usage and privacy principles.';

  @override
  String get ayarlarGelistirici => 'DEVELOPER';

  @override
  String get ayarlarProMod => 'PRO mode (test)';

  @override
  String get ayarlarProModAciklama => 'Displays PRO features without lock.';

  @override
  String get ayarlarDilTest => 'Language (test)';

  @override
  String get ayarlarDilAciklama =>
      'Only affects texts that have been migrated to the localization system.';

  @override
  String get ayarlarKaydedildi => 'General settings saved for all apiaries.';

  @override
  String ayarlarOzelKaydedildi(String kapsam) {
    return 'Custom calibration saved for $kapsam apiary.';
  }

  @override
  String get ayarlarGeriYukleIcerik =>
      'This operation completely replaces current data with the selected backup. It is recommended to take a current backup before proceeding. Start loading now?';

  @override
  String ayarlarUygulamaGuncel(String surum, String kod) {
    return 'App is up to date. Current version: $surum ($kod)';
  }

  @override
  String get yeniKoloniBaslik => 'NEW COLONY RECORD';

  @override
  String get yeniKoloniDuzenle => 'EDIT COLONY';

  @override
  String get yeniKoloniGecmisTarihBaslik => 'Past date selected';

  @override
  String get yeniKoloniGecmisTarihIcerik =>
      'You are moving the colony start date backwards. If this is correct, continue. The system will block the record if the date conflicts with the apiary start or first inspection.';

  @override
  String get yeniKoloniEvetDegistir => 'Yes, change';

  @override
  String get yeniKoloniKaynakBulunamadi =>
      'Selected source colony not found in this apiary. Please select a valid source colony from the list.';

  @override
  String yeniKoloniKayitHata(String hata) {
    return 'Technical problem occurred during save: $hata';
  }

  @override
  String get yeniKoloniBolumKaynakOlusumBilgisi =>
      'Source and Origin Information';

  @override
  String get yeniKoloniBolumSahaBilgileri => 'Basic Field Information';

  @override
  String get yeniKoloniBolumNotlar => 'Notes';

  @override
  String get yeniKoloniKaynakTipiLabel => 'Source Type';

  @override
  String get yeniKoloniKaynakAnaHat => 'Mother Line';

  @override
  String get yeniKoloniKaynakBolme => 'Split';

  @override
  String get yeniKoloniKaynakOgul => 'Swarm';

  @override
  String get yeniKoloniKaynakBilgiAnaHat =>
      'Mother Line selected. Source colony not required. The system starts this colony as a new root line.';

  @override
  String get yeniKoloniKaynakBilgiBolme =>
      'First select the source colony, then enter the new hive number. The system builds lineage based on this.';

  @override
  String get yeniKoloniKaynakBilgiOgul =>
      'First select the source colony the swarm came from, then enter the new hive number. Swarm is accepted as already queenright; queen rearing method is not selected separately.';

  @override
  String get yeniKoloniKaynakBilgiVarsayilan =>
      'Source information is used for system identity and lineage.';

  @override
  String get yeniKoloniAnaKazanmaLabel => 'Queen Rearing Method';

  @override
  String get yeniKoloniAnaKazanmaBilgiKapaliMeme =>
      'Calendar starts from the sealed cell stage, not from scratch. Day 5 sealed cell break warning is not given.';

  @override
  String get yeniKoloniAnaKazanmaBilgiHazirAna =>
      'Cell calendar does not run. System focuses on acceptance and laying check window.';

  @override
  String get yeniKoloniAnaKazanmaBilgiKendiAnasi =>
      'Calendar starts with the queen rearing process from scratch. Day 5 sealed cell check is meaningful.';

  @override
  String get yeniKoloniKaynakKoloniLabel => 'Source Colony';

  @override
  String get yeniKoloniDisKaynak => 'External Source';

  @override
  String get yeniKoloniKaynakKoloniValidasyon =>
      'You must select a source colony.';

  @override
  String get yeniKoloniKovanTipiLabel => 'Hive Type';

  @override
  String get yeniKoloniSurupluk => 'Feeder';

  @override
  String get yeniKoloniSuruplukVar => 'Lower box 9 frames';

  @override
  String get yeniKoloniSuruplukYok => 'Lower box 10 frames';

  @override
  String get yeniKoloniSuruplukBilgiVar =>
      'If feeder is present, system accepts lower brood box as 9 frames; interprets frames above as super/honey area.';

  @override
  String get yeniKoloniSuruplukBilgiYok =>
      'If no feeder, system accepts lower brood box as 10 frames; interprets frames above as super/honey area.';

  @override
  String get yeniKoloniBaslangicTarihi => 'Colony start date';

  @override
  String get yeniKoloniKovanNoLabel => 'Hive No / Field Label';

  @override
  String get yeniKoloniAnaAriYili => 'Queen Year';

  @override
  String get yeniKoloniSahaSirasi => 'Field Order';

  @override
  String get yeniKoloniIlkCitaSayisi => 'Initial Total Frame Count';

  @override
  String get yeniKoloniSahaBilgisiNot =>
      'Only field information is entered on this screen. System identity, queen lineage and genetic line code are automatically derived; displayed as information in colony detail.';

  @override
  String get yeniKoloniOzelNotlar => 'Special Notes';

  @override
  String get yeniKoloniAlanZorunlu => 'This field is required.';

  @override
  String get yeniKoloniSayiGir => 'Enter a number.';

  @override
  String get yeniKoloniBilgileriKaydet => 'SAVE INFORMATION';

  @override
  String get arilikSecimBaslik => 'APIARY SELECTION';

  @override
  String get arilikSecimRaporBaslik => 'SELECT APIARY FOR REPORT';

  @override
  String get arilikSecimBos => 'No apiary added yet.';

  @override
  String get arilikSecimIlkEkle => 'Add Your First Apiary';

  @override
  String get arilikSecimYeniEkleBaslik => 'Add New Apiary';

  @override
  String get arilikSecimArilikAdi => 'Apiary name';

  @override
  String get arilikSecimAdiHint => 'E.g.: Hillside';

  @override
  String get arilikSecimBaslangicTarihi => 'Apiary start date';

  @override
  String get arilikSecimGecmisTarihMesaji =>
      'You are moving the apiary start date backwards. If this is correct, continue. The system will still block the record if it conflicts with colony and inspection dates.';

  @override
  String get arilikSecimDuzenleTarihMesaji =>
      'You are moving the apiary start date backwards. If this is correct, continue. The system will block the record if this date conflicts with colony or inspection records.';

  @override
  String get arilikSecimKalibrasyon => 'Calibration';

  @override
  String get arilikSecimVarsayilanKal => 'Use default calibration';

  @override
  String get arilikSecimVarsayilanKalAciklama =>
      'New apiary won\'t create custom settings; uses general default honey flow and risk calendar.';

  @override
  String get arilikSecimKopyalaKal => 'Copy from an existing apiary';

  @override
  String get arilikSecimKopyalaKalAciklama =>
      'The selected apiary\'s honey flow and general risk calendar are copied as custom calibration for the new apiary.';

  @override
  String get arilikSecimKopyalanacakArilik => 'Apiary to copy from';

  @override
  String get arilikSecimKalibrasyonSecmelisin =>
      'You must select an apiary to copy calibration from.';

  @override
  String arilikSecimKayitHata(String hata) {
    return 'Apiary could not be saved: $hata';
  }

  @override
  String get arilikSecimDuzenleBaslik => 'Edit Apiary Information';

  @override
  String get arilikSecimDuzenleKural =>
      'Rule: The apiary start date cannot be later than colony and inspection dates in this apiary. The same date is accepted.';

  @override
  String arilikSecimGuncellenemedi(String hata) {
    return 'Apiary could not be updated: $hata';
  }

  @override
  String arilikSecimUyariGizlendi(String baslik) {
    return '$baslik hidden for this apiary this season.';
  }

  @override
  String get arilikSecimSilBaslik => 'DELETE APIARY';

  @override
  String arilikSecimSilIcerik(String ad, int toplam, int aktif, int pasif) {
    return 'This action cannot be undone.\n\nApiary to delete: $ad\nTotal colonies: $toplam\nActive colonies: $aktif\nPassive / extinct colonies: $pasif\n\nColonies, inspections, event records, number history and apiary-specific calibrations linked to this apiary will be deleted.\n\nMake sure you have taken a current backup before proceeding.';
  }

  @override
  String arilikSecimSilindi(String ad) {
    return '$ad apiary deleted.';
  }

  @override
  String arilikSecimSilinemedi(String hata) {
    return 'Apiary could not be deleted: $hata';
  }

  @override
  String get arilikSecimSonOnayBaslik => 'FINAL CONFIRMATION';

  @override
  String get arilikSecimSonOnayIcerik =>
      'Write the apiary name exactly to confirm deletion.';

  @override
  String get arilikSecimAdiYaz => 'Write apiary name';

  @override
  String get arilikSecimKaliciSilUyari =>
      'This operation permanently deletes the apiary data.';

  @override
  String get arilikSecimKaliciSil => 'Delete Permanently';

  @override
  String arilikSecimAktifToplam(int aktif, int toplam) {
    return 'Active $aktif / Total $toplam';
  }

  @override
  String arilikSecimUyariSayisi(int sayi) {
    return '$sayi active general warning(s)';
  }

  @override
  String get arilikSecimDetaylariAc => 'Show details';

  @override
  String get arilikSecimDetaylariKapat => 'Hide details';

  @override
  String get arilikSecimBuSezonGosterme =>
      'Don\'t show for this apiary this season';

  @override
  String arilikSecimBaslangic(String tarih) {
    return 'Start: $tarih';
  }

  @override
  String get arilikSecimDuzenleTooltip => 'Edit apiary';

  @override
  String get arilikSecimSilTooltip => 'Delete apiary';

  @override
  String get arilikSecimGir => 'Enter apiary';

  @override
  String get arilikSecimToplam => 'Total';

  @override
  String get arilikSecimAktif => 'Active';

  @override
  String get arilikSecimPasif => 'Passive';

  @override
  String muayeneEkleAppBarBaslik(String tarih) {
    return '$tarih / Inspection Entry';
  }

  @override
  String get muayeneEkleGecmisTarihIcerik =>
      'You are moving the inspection date backwards. If this is correct, continue. The system will block the record if the date conflicts with colony or apiary start.';

  @override
  String get muayeneEkleSesHata1 =>
      'Speech recognition could not start. Check Android microphone permission.';

  @override
  String get muayeneEkleSesHata2 =>
      'Speech-to-text is not available on this device.';

  @override
  String get muayeneEkleSesHata3 =>
      'An error occurred while adding voice note.';

  @override
  String muayeneEkleKayitHata(String hata) {
    return 'Technical problem occurred: $hata';
  }

  @override
  String muayeneEkleKovanEtiket(String no) {
    return 'HIVE: $no';
  }

  @override
  String muayeneEkleArilikEtiket(String ad) {
    return 'APIARY: $ad';
  }

  @override
  String get muayeneEkleMuayeneTarihi => 'Inspection Date';

  @override
  String get muayeneEkleToplam => 'Total';

  @override
  String get muayeneEkleYavrulu => 'Brood';

  @override
  String get muayeneEkleBalHasat => 'Honey/Harvest';

  @override
  String muayeneEklePetekAktivasyonBaslik(int artis) {
    return 'Frame / Volume Activation (+$artis frames)';
  }

  @override
  String muayeneEklePetekAktivasyonAniArtis(int artis) {
    return 'There is an increase of $artis frames since the last inspection. If rapid expansion was done before the colony reached 9–10 frames, the compact pattern may break. The system does not count this new volume as fully functional capacity immediately.';
  }

  @override
  String get muayeneEklePetekAktivasyonKatGecis =>
      'Since the colony passed from the 9–10 frame threshold to 11+ frames, the system reads this as a box/super transition. The new upper volume gains function gradually.';

  @override
  String get muayeneEklePetekAktivasyonNormal =>
      'The newly added frame is recorded physically; the biological model evaluates the function gain of this frame spread over time.';

  @override
  String get muayeneEklePetekDagilimBilgi =>
      'Enter the distribution of added frames. Foundation and drawn comb can be given together; total does not exceed the increase count.';

  @override
  String get muayeneEkleTemel => 'Foundation';

  @override
  String get muayeneEkleKabarmis => 'Drawn';

  @override
  String muayeneEklePetekToplam(int toplam, int artis) {
    return 'Total: $toplam / $artis frames';
  }

  @override
  String get muayeneEkleYavruDuzeniLabel => 'Brood Pattern';

  @override
  String get muayeneEkleKoloniMizaci => 'Colony Temperament';

  @override
  String get muayeneEkleBeslemeLabel => 'Feeding';

  @override
  String get muayeneEkleVarroaLabel => 'Varroa Treatment';

  @override
  String get muayeneEkleOgulBelirtisiBaslik => 'Swarm Sign';

  @override
  String get muayeneEkleOgulBelirtisiAciklama =>
      'Produces decision suggestion and close monitoring signal.';

  @override
  String get muayeneEkleOgulAttiBaslik => 'Swarmed';

  @override
  String get muayeneEkleOgulAttiAciklama =>
      'This is a confirmed event. Affects score and lineage position.';

  @override
  String get muayeneEkleAnaGorulmedi => 'Queen Not Seen';

  @override
  String get muayeneEkleBolmeYapildiBaslik => 'Split Made';

  @override
  String get muayeneEkleBolmeYapildiAciklama =>
      'Frame drop is interpreted as controlled multiplication, not performance loss.';

  @override
  String get muayeneEkleKovanSonduBaslik => 'Hive Died';

  @override
  String get muayeneEkleKovanSonduAciklama =>
      'Causes the colony to be evaluated as end of life cycle rather than active performance.';

  @override
  String get muayeneEkleAnauretimBaslik => 'Queen Rearing & Timing';

  @override
  String get muayeneEkleAnauretimBilgi =>
      'The biological queen rearing calendar only runs for colonies that are truly left queenless. The split operation on the donor colony separately produces a recovery process.';

  @override
  String get muayeneEkleAnasizBirakildiBaslik => 'Colony Left Queenless';

  @override
  String get muayeneEkleAnasizBirakildiAciklama =>
      'Critical information for day counting and biological window interpretation.';

  @override
  String get muayeneEkleKaydet => 'SAVE';

  @override
  String get muayeneEkleGuncelle => 'UPDATE';

  @override
  String get muayeneEkleNotlarLabel => 'Notes';

  @override
  String get muayeneEkleSesBasla => 'Add voice note';

  @override
  String get muayeneEkleSesDurdur => 'Stop voice recording';

  @override
  String get muayeneEkleSesHelper => 'Tap the microphone to add a voice note.';

  @override
  String get muayeneEkleSesHelperAktif =>
      'Listening... Your speech is being written to the notes field.';

  @override
  String get muayeneEkleOnYuklemeBilgi =>
      'Last inspection data pre-loaded. You can update the required fields and continue.';

  @override
  String get muayeneEkleBolmeBilgi =>
      'Entering the Source Colony information for the newly opened colony strengthens lineage tracking and performance analysis.';

  @override
  String get muayeneEkleOgulAttiBilgi =>
      'Swarm has occurred, this is a confirmed event. Affects selection and lineage evaluation.';

  @override
  String get muayeneEkleSuruplukEklendi => 'Feeder added';

  @override
  String get muayeneEkleSuruplukEklendiAciklama =>
      'This colony has no feeder. If a feeder was added during inspection, mark it; otherwise it continues to be counted as removed.';

  @override
  String get muayeneEkleSuruplukKaldirildi => 'Feeder removed';

  @override
  String get muayeneEkleSuruplukKaldirildiHasat =>
      'This record is read as post-harvest care; feeding selection can be used again.';

  @override
  String get muayeneEkleSuruplukKaldirildiNormal =>
      'If marked, the feeder is removed in the biological model and frame layout shifts left.';

  @override
  String get muayeneEkleSuruplukVarsayilanMesaj =>
      'Honey flow is approaching. Feeding should be stopped to reduce sugar residue risk; feeder can be removed and frames given instead.';

  @override
  String get muayeneEkleSuruplukHasatMesaj =>
      'Honey/harvest record entered. Feeding area will reopen in the post-harvest care period; feeder can be used again if needed. When the second honey flow window opens, the same feeder removal and feeding stop cycle will run again.';

  @override
  String get muayeneEkleSuruplukBildirilenKisit =>
      'Feeding restriction started because honey flow is approaching. If you actually removed the feeder to reduce sugar residue risk, mark it.';

  @override
  String get muayeneEkleBeslemeSuruplukBilgi =>
      'Feeder marked as removed. Sugar-based feeding selection was disabled in the same inspection; this record is read as harvest preparation.';

  @override
  String get muayeneEkleHasatBakimBilgi =>
      'Feeding area reactivated because honey/harvest was entered. This period is read as post-harvest care. If the second honey flow becomes active, the system will return to feeding stop and feeder removal warnings.';

  @override
  String get muayeneEkleGunlukYavruBaslik => 'Daily / sealed brood seen';

  @override
  String get muayeneEkleGunlukYavruAciklama =>
      'This is the closing marker in split, swarm, queen rearing or no-brood monitoring. If marked, the system closes the no-brood window and returns the colony to normal status.';

  @override
  String get muayeneEkleYavruYokErken =>
      'Brood pattern will be recorded as \"None\". Active biological process may be in early window; absence of brood at this stage is not an alarm by itself.';

  @override
  String get muayeneEkleYavruYokErkenVarsayilan =>
      'Unnecessary opening and harsh intervention is not recommended.';

  @override
  String get muayeneEkleYavruYokTani =>
      'Brood pattern will be recorded as \"None\". The system will now use 4 short diagnostic observations together with current season, process window and colony strength to differentiate honey pressure, late mating, queen problem or biological weakening.';

  @override
  String get muayeneEkleYavruYokNormal =>
      'Brood pattern will be recorded as \"None\". The system will read this separately in normal colony context; brood frame count will be 0 and the biological model will calculate recovery capacity accordingly.';

  @override
  String get muayeneEkleYavruYokTaniBaslik =>
      'No-Brood Short Diagnostic Observations';

  @override
  String get muayeneEkleYavruYokTaniAciklama =>
      'This section does not select a diagnosis. The system reads these 4 simple observations together with current season, process window and colony strength to produce recommendations.';

  @override
  String get muayeneEkleTaniKoloniSakin => 'Is the colony calm?';

  @override
  String get muayeneEkleTaniKoloniSakinAciklama =>
      'A calm colony increases the probability of a new queen inside. A restless colony raises suspicion of queenlessness/stress.';

  @override
  String get muayeneEkleTaniPolen => 'Is there pollen coming in?';

  @override
  String get muayeneEkleTaniPolenAciklama =>
      'Pollen input supports the probability of brood preparation or queen presence inside. Absence of pollen increases the risk of biological stagnation.';

  @override
  String get muayeneEkleTaniBal => 'Is honey / nectar flow strong?';

  @override
  String get muayeneEkleTaniBalAciklama =>
      'Strong flow can narrow the laying area. In this case, absence of brood may not directly mean queenlessness.';

  @override
  String get muayeneEkleTaniErkek => 'Are drone brood cells dominant?';

  @override
  String get muayeneEkleTaniErkekAciklama =>
      'If yes, the risk of unmated queen, failed queen or laying worker increases. This answer hardens the waiting decision.';

  @override
  String get muayeneEkleTaniEminDegil => 'Not sure';

  @override
  String get rehberBaslik => 'USER GUIDE';

  @override
  String get rehberProOzellik => 'Feature';

  @override
  String get rehberProUcretsiz => 'Free';

  @override
  String get rehberProPRO => 'PRO';

  @override
  String get rehberProS1 => 'Unlimited colony records';

  @override
  String get rehberProS2 => 'Inspection form and history';

  @override
  String get rehberProS3 => 'Hive layout visual';

  @override
  String get rehberProS4 => 'Estimated bee count';

  @override
  String get rehberProS5 => 'Summary comment (one sentence)';

  @override
  String get rehberProS6 => 'Management decision detail';

  @override
  String get rehberProS7 => 'Risk analysis (Varroa, bee-eater…)';

  @override
  String get rehberProS8 => 'Harvest projection and quantity';

  @override
  String get rehberProS9 => 'Economic value estimate';

  @override
  String get rehberProS10 => 'Demographics and capability scores';

  @override
  String get rehberProS11 => 'Colony projection';

  @override
  String get rehberProS12 => 'Performance reports';

  @override
  String get rehberProS13 => 'Line analysis';

  @override
  String get rehberProS14 => 'Colony comparison';

  @override
  String get rehberProS15 => 'Lineage tree';

  @override
  String get rehberProS16 => 'Formulas and calculations';

  @override
  String get rehber1Baslik => '1. What Does İTOGENA Do?';

  @override
  String get rehber1Kutu =>
      'İTOGENA reads simple field data together with time, process, lineage, performance and apiary calibration to produce actionable colony decisions. The goal is not merely record-keeping; it is to clearly show the beekeeper what to do, why, and when.';

  @override
  String get rehber1M1 =>
      'The system works on a trigger → process → suggestion → field action → new inspection → closure logic.';

  @override
  String get rehber1M2 =>
      'Colony class is derived from a single biological source: if functional production frames are 0–3 it is weak, 4–7 is development, 8–9 is production, and 10 or above is harvest class.';

  @override
  String get rehber1M3 =>
      'It does not ask for additional confirmation for each process; it tries to understand the outcome from the next inspection data.';

  @override
  String get rehber1M4 =>
      'The colony detail screen opens quickly; heavy analyses are loaded in the background.';

  @override
  String get rehber1M5 =>
      'The system reads physical frames and functional production capacity separately. Rapid expansion, foundation frame loading, or post-harvest volume changes are not automatically treated as a strong colony.';

  @override
  String get rehber1M6 =>
      'The colony detail general status screen shows four main headings: Process, Biology, Management and Genetics.';

  @override
  String get rehber1M7 =>
      'The management card standardises feeding, super, space, varroa, winter and post-harvest care decisions in the same management list.';

  @override
  String get rehber1M8 =>
      'When inspection, colony or apiary data changes, all caches are cleared together; the risk of an old decision remaining on screen is reduced.';

  @override
  String get rehber2Baslik => '2. Free and PRO';

  @override
  String get rehber2Kutu =>
      'You can use ITOGENA for free for inspection records and basic colony tracking. Deep analysis, risk monitoring, harvest estimation and reporting are PRO features.';

  @override
  String get rehber3Baslik => '3. What Does the System Read from Frames?';

  @override
  String get rehber3M1 =>
      'Frame count is the primary field indicator of colony strength; it is not a definitive decision on its own.';

  @override
  String get rehber3M2 =>
      'The last frame reflects current live strength, the maximum frame indicates in-season capacity, and honey frames reflect productivity during the production period.';

  @override
  String get rehber3M3 =>
      'In winter, frame strength matters for resilience; honey frames are not read as winter performance.';

  @override
  String get rehber3M4 =>
      'The system reads frame count not just as a number but as estimated biological capacity: bee population, cell capacity, brood/stock area, queen zone and harvest potential are all derived from this data.';

  @override
  String get rehber3M5 =>
      'These values are not precise measurements; climate, flora, bee breed, season and management differences can change the outcome.';

  @override
  String get rehber3M6 =>
      'Langstroth is the default reference. If Dadant is selected, the same biological layout is maintained but frame capacity is calculated with a higher coefficient.';

  @override
  String get rehber3M7 =>
      'If a feeder is present, the lower brood box is assumed to be 9 frames; without a feeder, 10 frames. Frames above this limit are interpreted as super/honey space.';

  @override
  String get rehber3bBaslik => '3B. Functional Frames and Volume Activation';

  @override
  String get rehber3bM1 =>
      'İTOGENA reads physical frames and functional frames separately. The number of frames in the hive represents physical volume, while the space the colony can actually use represents functional biological capacity.';

  @override
  String get rehber3bM2 =>
      'A newly added frame is not immediately counted as full capacity. The system calculates an activation period based on whether it is a foundation or drawn comb, the number of days elapsed, brood layout, colony strength and the honey flow window.';

  @override
  String get rehber3bM3 =>
      'The system operates on a tight-layout assumption. In a single inspection +1 frame is normal, +2 frames is controlled expansion, and +3 or more is a cause for concern unless it is a super transition.';

  @override
  String get rehber3bM4 =>
      'If feeder + 9 frames or feeder-free 10 frames reach 95% or more activation, the system reads this as the \"Add super\" threshold.';

  @override
  String get rehber3bM5 =>
      'If feeder + 19 frames or feeder-free 20 frames reach 95% or more activation, the system generates an \"Add 3rd super\" alert.';

  @override
  String get rehber3bM6 =>
      'A rapid frame drop coinciding with a harvest record is not counted as biological collapse; the system normalises this as harvest-induced volume contraction.';

  @override
  String get rehber3cBaslik => '3C. Season Biology Matrix';

  @override
  String get rehber3cM1 =>
      'İTOGENA does not read season as just a calendar name. For each season, brood expectation, stock pressure, pollen/bee bread expectation, queen purpose and activation coefficient are evaluated together.';

  @override
  String get rehber3cM2 =>
      'The system treats winter, winter emergence, spring development, pre-honey flow, honey flow, post-harvest, autumn preparation and late autumn as separate biological behaviours.';

  @override
  String get rehber3cM3 =>
      'This matrix does not give direct orders to the colony; it provides biological context for activation, capability, feeding, harvest and split decisions.';

  @override
  String get rehber3cM4 =>
      'Season data is read together with local honey flow calibration. Therefore the same date may not mean the same decision at every apiary.';

  @override
  String get rehber3dBaslik => '3D. Colony Trend and Normalised Momentum';

  @override
  String get rehber3dM1 =>
      'Colony Trend describes not just today\'s strength but which direction the colony is heading. Momentum lives within this calculation.';

  @override
  String get rehber3dM2 =>
      'Momentum is no longer a raw frame increase. A rapid post-harvest drop is not counted as biological collapse; a post-split drop is read as process-related; and adding a super is not counted as full growth until activation is complete, as it is a physical volume increase.';

  @override
  String get rehber3dM3 =>
      'Super transition, risky rapid expansion, low activation and healthy upper-volume expansion within the honey flow are each normalised separately.';

  @override
  String get rehber3dM4 =>
      'Colony Trend in the performance tab reads development direction, production direction, space pressure, recovery potential, collapse risk and normalised momentum together.';

  @override
  String get rehber3eBaslik => '3E. Demography Projection';

  @override
  String get rehber3eM1 =>
      'The demography projection does not perform an exact bee count; it estimates the workforce distribution within the colony from frame strength, brood load, season and development direction.';

  @override
  String get rehber3eM2 =>
      'The system reads young worker, nurse bee, comb processor, house bee, guard, forager and drone distribution separately for field decisions.';

  @override
  String get rehber3eM3 =>
      'Young worker capacity is used in raw comb and brood care decisions; forager capacity is used in honey flow and production decisions.';

  @override
  String get rehber3eM4 =>
      'Demographic output is not an \"exact population\"; it is biological probability and a field projection.';

  @override
  String get rehber3fBaslik => '3F. Workforce and Capability Projection';

  @override
  String get rehber3fM1 =>
      'İTOGENA tries to interpret not just how many bees there are, but the biological capacity those bees have to perform specific tasks.';

  @override
  String get rehber3fM2 =>
      'Comb drawing, brood care, nectar collection, honey processing, defence, recovery, winter hardiness and mating support are evaluated as separate workforce areas.';

  @override
  String get rehber3fM3 =>
      'Two colonies with the same frame count can have different workforce capacities. Colonies with a low young-worker ratio may struggle with rapid comb processing or rearing brood even if they appear large.';

  @override
  String get rehber3fM4 =>
      'This projection does not perform exact biological measurement; it produces an explainable biological trend model that supports field decisions.';

  @override
  String get rehber3gBaslik => '3G. Risk Projection and Natural Risk Brakes';

  @override
  String get rehber3gM1 =>
      'The risk projection does not manage the colony with alarming warnings; it produces a balanced decision brake by reading the season\'s natural risk premium and the colony\'s biological vulnerability together.';

  @override
  String get rehber3gM2 =>
      'Varroa, bee-eater, hornet, robbing, moisture/winter, over-expansion, broodlessness/ageing and honey quality risks are all assessed in the same centre.';

  @override
  String get rehber3gM3 =>
      'Risk brakes do not directly prohibit decisions. They make expansion, split, feeding, harvest and intervention suggestions more cautious through small coefficients.';

  @override
  String get rehber3gM4 =>
      'This system does not make a definitive disease or pest diagnosis; it produces an explainable risk trend.';

  @override
  String get rehber4Baslik =>
      '4. Why Is Splitting Not Recommended Below 9 Frames?';

  @override
  String get rehber4M1 =>
      '6 frames may be biologically possible; but it is not a safe field recommendation.';

  @override
  String get rehber4M2 =>
      'İTOGENA gives not what is possible, but the right recommendation that protects the beekeeper from colony loss risk.';

  @override
  String get rehber4M3 =>
      'The safe threshold for a split recommendation is 9 frames. The parent colony should be able to retain at least 5 frames after splitting, and the new split should be able to start with at least 4 frames.';

  @override
  String get rehber4M4 =>
      'The 6–8 frame range is considered risky; rather than recommending a split, the system first advises strengthening.';

  @override
  String get rehber4M5 =>
      'No split recommendation is made during the winter period.';

  @override
  String get rehber4M6 =>
      'The split decision is read in time context. If there are more than 57 days until the honey flow, splitting a strong colony is meaningful; if fewer than 57 days remain, a standard split may reduce production strength.';

  @override
  String get rehber5Baslik =>
      '5. What Is the Difference Between Donor Score and General Score?';

  @override
  String get rehber5M1 => 'General score is the colony\'s field performance.';

  @override
  String get rehber5M2 =>
      'Donor score is the queen-rearing and genetic selection value.';

  @override
  String get rehber5M3 =>
      'A general score of 85 alone does not mean donor eligibility. Swarm trace/genetic filter, lineage continuity, reproductive strength, hardiness and data confidence are also read.';

  @override
  String get rehber5M4 =>
      'A strong colony caught by the genetic filter can be evaluated in production or closed-brood support; it is not placed in the queen-rearing pool.';

  @override
  String get rehber6Baslik => '6. Swarm Trace and Post-Swarm Process';

  @override
  String get rehber6M1 =>
      'Swarming is not a health problem; therefore it does not reduce the health score.';

  @override
  String get rehber6M2 =>
      'A colony with swarm origin or swarm trace does not enter the donor pool.';

  @override
  String get rehber6M3 =>
      'If marked as swarmed, the colony is not temporarily read as a production/harvest colony. The after-swarm risk is highest in days 0–7.';

  @override
  String get rehber6M4 =>
      'After-swarm risk decreases in days 8–16. Days 17–30 are the new queen emergence, maturation and mating window.';

  @override
  String get rehber6M5 =>
      'By days 31–45, laying should now be evident. If there is still no brood, the system evaluates this as queen failure or laying-worker risk.';

  @override
  String get rehber7Baslik => '7. No-Brood Alarm and Decision Priority';

  @override
  String get rehber7M1 =>
      'No brood is one of the most critical biological alarms. The system first checks whether this is a normal wait within an active split, post-swarm or queen-rearing window.';

  @override
  String get rehber7M2 =>
      'If the waiting window has passed, no brood takes priority over routine decisions like varroa, feeding and harvest. On the grid card, colony continuity is discussed first.';

  @override
  String get rehber7M3 =>
      'If laying-worker suspicion, drone brood pressure, consecutive broodless records and strength decline are seen together, the system treats this as a high-priority queen problem.';

  @override
  String get rehber7M4 =>
      'If there is strong honey pressure within the honey flow, broodlessness is not immediately counted as queenlessness; space and honey pressure are evaluated first.';

  @override
  String get rehber8Baslik => '8. How Is the Queen-Rearing Process Read?';

  @override
  String get rehber8M1 =>
      'The queen-rearing process begins with triggers such as left queenless, split, sealed queen cell or a mated queen introduced.';

  @override
  String get rehber8M2 =>
      'In a colony that will raise its own queen, sealed cells are destroyed on day 5; open/unsealed quality cells are left.';

  @override
  String get rehber8M3 =>
      'In a colony where a mated queen has been introduced, the process is read according to acceptance and laying check.';

  @override
  String get rehber8M4 =>
      'When daily or capped brood is seen, queen presence is indirectly accepted and the relevant queen-rearing process can close.';

  @override
  String get rehber9Baslik => '9. What Is the 57/42-Day Honey Flow Logic?';

  @override
  String get rehber9M1 =>
      '42 days is the biological period from egg to forager bee.';

  @override
  String get rehber9M2 =>
      '57 days is the field planning threshold: approximately 15 days of safety margin is added to the 42-day biology.';

  @override
  String get rehber9M3 =>
      'The decision engine takes split recommendations seriously according to this 57-day field window. If timing is not right, even a strong colony is not automatically made a split candidate.';

  @override
  String get rehber9M4 =>
      'When 24 days or fewer remain to the honey flow, space, super, residue safety and swarm control come to the fore.';

  @override
  String get rehber9M5 =>
      'The strongest decision window for queen replacement is the post-harvest / autumn entry period.';

  @override
  String get rehber10Baslik => '10. How Do Varroa Alerts Work?';

  @override
  String get rehber10M1 =>
      'Varroa alerts are read together with the season and honey flow window.';

  @override
  String get rehber10M2 =>
      'Residue risk is taken into account before and during the honey flow.';

  @override
  String get rehber10M3 =>
      'The post-harvest / late-summer early-autumn period is considered critical for the health of bees that will carry through winter.';

  @override
  String get rehber10M4 =>
      'For oxalic, thymol, amitraz, formic and similar applications, the product label, licensed use instructions and local regulations must be followed.';

  @override
  String get rehber11Baslik => '11. What Does Data Confidence Mean?';

  @override
  String get rehber11M1 =>
      'With a single-inspection colony, the system makes a decision but states that data confidence is low.';

  @override
  String get rehber11M2 =>
      '2–4 inspections is the monitoring band. 5 or more inspections is the start of reliable evaluation.';

  @override
  String get rehber11M3 =>
      'Data confidence is shown to explain why a decision is strong or limited; it is not meant to leave the user undecided.';

  @override
  String get rehber12Baslik =>
      '12. What Is the Biological Model and Capability Analysis?';

  @override
  String get rehber12M1 =>
      'İTOGENA does not read frame count just as a number; it interprets the estimated brood-box layout, brood block, stock area and harvest-candidate outer frames from standard colony organisation.';

  @override
  String get rehber12M2 =>
      'Hive type can be selected as Langstroth or Dadant. If a feeder is present, the lower brood box is 9 frames; without a feeder, 10 frames.';

  @override
  String get rehber12M3 =>
      'Using temporal polyethism logic, the age-related task distribution of worker bees is estimated: nurse bee, comb builder, house bee, forager and drone density are used as capability scores.';

  @override
  String get rehber12M4 =>
      'When the system says \"harvest these frames\" it does not make a definitive judgement; it only points to outer/super frames that, based on the estimated layout, could be considered for harvest if they are brood-free and capped.';

  @override
  String get rehber13Baslik => '13. How Does Winter Management Work?';

  @override
  String get rehber13M1 =>
      'In winter the primary goal is survival, not production. The system prioritises external observation, weight feel and moisture/water entry check in a way that prevents unnecessary hive opening.';

  @override
  String get rehber13M2 =>
      'If stock appears very low, starvation risk takes higher priority than the minimum-intervention rule.';

  @override
  String get rehber13M3 =>
      'If physical volume is high but functional bee strength is low, the system flags the risk of empty volume and heat loss.';

  @override
  String get rehber14Baslik => '14. How Is Genetic Multiplication Value Read?';

  @override
  String get rehber14M1 =>
      'Genetic multiplication value is not just honey or frame count. Functional capacity, brood layout, development direction, activation, risk, stock/winter safety and swarm trace are all read together.';

  @override
  String get rehber14M2 =>
      'Colonies with swarm origin or swarm trace may be valuable in production; but they are not automatically highlighted as clean genetic propagation candidates.';

  @override
  String get rehber14M3 =>
      'This score is not a definitive breeding verdict; it is a strategic signal that supports monitoring colonies worth multiplying and making controlled split decisions at the right time.';

  @override
  String get rehber15Baslik => '15. What Does Economic Value Represent?';

  @override
  String get rehber15M1 =>
      'The economic value screen is not a precise income calculation, but an approximate apiary asset and estimated honey potential projection.';

  @override
  String get rehber15M2 =>
      'Active hive count, total framed bees, empty hives, drawn combs and estimated harvestable honey potential are all read together.';

  @override
  String get rehber15M3 =>
      'The user enters the honey kg sale price; the system multiplies the estimated harvest potential by this price and produces a potential value band.';

  @override
  String get rehber15M4 =>
      'Honey yield varies depending on flora, weather, harvest timing, remaining stock and the beekeeper\'s management.';

  @override
  String get rehber16Baslik =>
      '16. How Does the Feeding Decision Projection Work?';

  @override
  String get rehber16M1 =>
      'Feeding suggestions are not precise stock measurements; frame strength, brood area, season, active process, honey flow window and the user\'s inspection observation are evaluated together.';

  @override
  String get rehber16M2 =>
      'The system does not give a precise prescription; it produces an estimated ml/L or gram band.';

  @override
  String get rehber16M3 =>
      '1:1 syrup is mostly for development support; 2:1 syrup for stock replenishment; pollen supplement is considered meaningful only if pollen pressure is confirmed in the field.';

  @override
  String get rehber16M4 =>
      'If 20 days or fewer remain to the honey flow and the colony is targeting harvest, sugar-based feeding is not recommended.';

  @override
  String get rehber17Baslik => '17. İTOGENA Decision Glossary';

  @override
  String get rehber17Kutu =>
      'This section explains what the terms seen on screen mean.';

  @override
  String get rehber17M1 =>
      'Colony Trend: Describes not just today\'s strength, but which direction the colony is progressing.';

  @override
  String get rehber17M2 =>
      'Colony Strength: Reflects the live bee and frame strength at the last inspection.';

  @override
  String get rehber17M3 =>
      'Colony Health: The combined reading of brood layout, queen process, broodlessness, varroa period, behaviour and risk signals.';

  @override
  String get rehber17M4 =>
      'Functional Frame: Not the physical frame count in the hive, but the biological capacity the bees are actually using.';

  @override
  String get rehber17M5 =>
      'Volume Activation: Describes how much of a given frame or super the colony has made usable.';

  @override
  String get rehber17M6 =>
      'Normalised Momentum: Does not read short-term frame increase or decrease in raw form. Post-harvest drop, split, super transition and risky rapid expansion are separated.';

  @override
  String get rehber17M7 =>
      'Genetic Filter: The colony may be valuable in production yet is not placed in the queen-rearing pool.';

  @override
  String get rehber17M8 =>
      'Management Decision: The actions the beekeeper will take in the field, such as feeding, super, space, post-harvest care, varroa and winter preparation.';

  @override
  String get rehber17M9 =>
      'Process: A time-bound biological/management window such as queen rearing, post-split recovery, post-swarm or no-brood diagnosis.';

  @override
  String get rehber17M10 =>
      'Lock / Wait: Describes a sensitive window where intervention should not occur.';

  @override
  String get rehber17M11 =>
      'Data Confidence: Describes how many inspections the decision is based on.';

  @override
  String get rehber18Baslik =>
      '18. On Which Topics Does the App Not Give a Definitive Verdict?';

  @override
  String get rehber18U1 =>
      'İTOGENA is not a substitute for veterinary advice, licensed medication use or official regulations.';

  @override
  String get rehber18U2 =>
      'For chemical treatments, the product label, licensed use instructions, protective equipment and local regulations must be followed.';

  @override
  String get rehber18U3 =>
      'Weather, flora, local nectar flow, beekeeper experience and colony behaviour must be observed separately in the field.';

  @override
  String get rehber18U4 =>
      'The system supports the right decision; final responsibility lies with the beekeeper in the field.';

  @override
  String get rehber19Baslik => '19. Voice Note';

  @override
  String get rehber19M1 =>
      'You can add a voice note by pressing the microphone icon in the notes field and speaking.';

  @override
  String get rehber19M2 =>
      'Your speech is automatically converted to text and added to the notes field.';

  @override
  String get rehber19U1 =>
      'Wind, bee noise, the device microphone and internet connection on some devices may affect recognition.';

  @override
  String get rehber20Baslik => '20. Privacy Policy';

  @override
  String get rehber20M1 =>
      'You can read İTOGENA\'s personal data processing, storage and usage policy at the link below.';

  @override
  String get rehber20Link => 'itogaciftligi.com/itogena-gizlilik-politikasi';

  @override
  String get kolonGridYavruYok => 'No brood';

  @override
  String get kolonGridMemeKontrol => 'Cell check';

  @override
  String get kolonGridYalanciAna => 'Laying worker risk';

  @override
  String get kolonGridBeklemeSureci => 'Waiting period';

  @override
  String get kolonGridSurecIzleniyor => 'Process monitored';

  @override
  String get kolonGridUcuncuKat => 'Add 3rd super';

  @override
  String get kolonGridAlanAc => 'Open space';

  @override
  String get kolonGridKatVer => 'Add super';

  @override
  String get kolonDetaySurecYok => 'No active process';

  @override
  String get kolonDetayKritikUyariYok => 'No critical alert';

  @override
  String get kolonDetayNormalTakip => 'Normal monitoring';

  @override
  String get kolonDetaySurecTakibiGerekli => 'Process tracking required.';

  @override
  String kolonDetayOncelik(int oncelik) {
    return 'Priority $oncelik/100';
  }

  @override
  String get kolonDetayDetaylariAc => 'Open details';

  @override
  String get kolonDetayGereksizAcma => 'Avoid unnecessary opening';

  @override
  String get kolonDetayKoloniAcma => 'Do not open colony';

  @override
  String get kolonDetayMudahaleEtme => 'Do not intervene';

  @override
  String get kolonDetayMemeSayisiKontrol => 'Check cell count';

  @override
  String get kolonDetayBirlestir => 'Consider merging';

  @override
  String get kolonDetayAlanKontrol => 'Check space';

  @override
  String get kolonDetayAnaKarar => 'Evaluate queen decision';

  @override
  String get kolonDetayTekrarKontrol => 'Check again';

  @override
  String get kolonDetayBolmeNetlestir => 'Confirm split decision';

  @override
  String get kolonDetayKontrolEt => 'Check';

  @override
  String get kolonDetayYakinTakip => 'Monitor closely';

  @override
  String get kolonDetayAktifSurecMetni => 'Active process';

  @override
  String get kolonDetayOkunamadi => 'Read error';

  @override
  String get kolonDetayAktivasyonHata => 'Activation calculation error';

  @override
  String get kolonDetayBiyolojiYukleniyor => 'Loading';

  @override
  String get kolonDetayAktivasyonYukleniyor => 'Activation loading';

  @override
  String get kolonDetayArkaPlanda => 'In background';

  @override
  String kolonDetayHacimYuzde(int yuzde) {
    return 'Volume %$yuzde';
  }

  @override
  String kolonDetayHacimDetay(int fiziksel, String islevsel) {
    return '$fiziksel → $islevsel frames';
  }

  @override
  String get kolonDetayIslevselOkunuyor => 'Functional volume reading';

  @override
  String get kolonDetayAktivasyonAlanDolu => 'full';

  @override
  String get kolonDetayAktivasyonTamamlaniyor => 'completing';

  @override
  String get kolonDetayAktivasyonIyi => 'good';

  @override
  String get kolonDetayAktivasyonOrta => 'medium';

  @override
  String get kolonDetayAktivasyonDusuk => 'low';

  @override
  String get kolonDetayAktivasyonCokDusuk => 'very low';

  @override
  String get kolonDetayYonetimDip => 'Management';

  @override
  String get kolonDetayKararHatasi => 'Decision error';

  @override
  String get kolonDetayYonetimOkunamadi => 'Management decisions unavailable';

  @override
  String get kolonDetayYonetimYok => 'No management';

  @override
  String get kolonDetayMudahaleYok => 'No prominent field action needed';

  @override
  String get kolonDetayTakipDip => 'Monitor';

  @override
  String get kolonDetayGenetikBekleniyor => 'Genetics pending';

  @override
  String get kolonDetaySecilimArkaPlanda =>
      'Selection data loading in background.';

  @override
  String get kolonDetaySecilimAyri => 'Selection read separately';

  @override
  String get kolonDetaySecilimYukleniyor => 'Selection loading';

  @override
  String get kolonDetayDonorDisi => 'Non-donor';

  @override
  String get kolonDetayOgulVeto => 'Swarm trace / veto';

  @override
  String get kolonDetayUretimDegerlendir => 'Evaluate for production';

  @override
  String get kolonDetayVetoVar => 'Veto info available';

  @override
  String get kolonDetayDonorAdayi => 'Donor candidate';

  @override
  String get kolonDetaySoyTakibi => 'Lineage tracking suitable';

  @override
  String get kolonDetayUretimKolonisi => 'Production colony';

  @override
  String get kolonDetaySahaRolUretim => 'Field role: production';

  @override
  String get kolonDetayDestekKolonisi => 'Support colony';

  @override
  String get kolonDetayDestekRolu => 'Support role';

  @override
  String get kolonDetayVetoBilgisi => 'Veto info';

  @override
  String get kolonDetayDonorBilgisi => 'Donor info';

  @override
  String get kolonDetayUretimRolu => 'Production role';

  @override
  String get kolonDetaySecilimDip => 'Selection';

  @override
  String get kolonDetayYonetimKararlari => 'Management decisions';

  @override
  String get kolonDetayYonetimKarari => 'Management decision';

  @override
  String get kolonDetayGenetikDegerlendirme => 'Genetic evaluation';

  @override
  String get muayeneSecYavruYok => 'None';

  @override
  String get muayeneSecYavruBlok => 'Block';

  @override
  String get muayeneSecYavruNormal => 'Normal';

  @override
  String get muayeneSecYavruDaginik => 'Scattered';

  @override
  String get muayeneSecYavruKambur => 'Humpback';

  @override
  String get muayeneSecMizacSakin => 'Calm';

  @override
  String get muayeneSecMizacSinirli => 'Nervous';

  @override
  String get muayeneSecMizacSaldirgan => 'Aggressive';

  @override
  String get muayeneSecBeslemeYok => 'None';

  @override
  String get muayeneSecBesleme11 => '1:1 Syrup';

  @override
  String get muayeneSecBesleme21 => '2:1 Syrup';

  @override
  String get muayeneSecBeslemeKek => 'Cake';

  @override
  String get muayeneSecBeslemeFondan => 'Fondant';

  @override
  String get muayeneSecVarroaYok => 'None';

  @override
  String get muayeneSecVarroaDrone => 'Drone Removal';

  @override
  String get muayeneSecVarroaBolme => 'Split';

  @override
  String get muayeneSecVarroaTimol => 'Thymol';

  @override
  String get muayeneSecVarroaAmitraz => 'Amitraz';

  @override
  String get muayeneSecVarroaFormik => 'Formic';

  @override
  String get muayeneSecVarroaOksalik => 'Oxalic';

  @override
  String get srvKoloniAktifDegil => 'Colony inactive';

  @override
  String get srvPasifKayit => 'Passive record';

  @override
  String get srvDonorHavuzunda => 'In donor pool';

  @override
  String get srvBolmeUygun => 'Colony suitable for splitting';

  @override
  String get srvBolmeSinirinda => 'On strength limit for split';

  @override
  String get srvBolmeOnerilmez => 'Split not recommended';

  @override
  String get srvBolmeZayif => 'Strong colony; split timing poor';

  @override
  String get srvYakindanBak => 'Colony needs close attention';

  @override
  String get srvIzleyerek => 'Monitor and decide';

  @override
  String get srvDestekUretim => 'Support / production role';

  @override
  String get srvVeriGuveniDusuk => 'Low data confidence';

  @override
  String get srvKararVarVeriDusuk => 'Decision made; low data confidence';

  @override
  String get srvAnaKazanma => 'Queen Rearing';

  @override
  String get srvBolmeSonrasi => 'Post-Split';

  @override
  String get srvKisYonetimi => 'Winter Management';

  @override
  String get srvBakimSureci => 'Care Process';

  @override
  String get srvGelisimDonemi => 'Development Period';

  @override
  String get srvUretimDonemi => 'Production Period';

  @override
  String get srvHasatHazirlik => 'Harvest Preparation';

  @override
  String get srvHasatSonrasiBakim => 'Post-Harvest Care';

  @override
  String get srvOgulSonrasi => 'Post-Swarm';

  @override
  String get srvVarroaYonetimi => 'Varroa Management';

  @override
  String get srvSahadaOncelik => 'Field Priority';

  @override
  String get srvBiyolojikNot => 'Biological Note';

  @override
  String get trendVeriYok => 'No Data';

  @override
  String get trendStabil => 'Stable';

  @override
  String get trendYukselis => 'Rising';

  @override
  String get trendDusus => 'Declining';

  @override
  String get trendSonmus => 'Extinct';

  @override
  String get trendKontrolluBolme => 'Controlled Split';

  @override
  String get trendBolmeSonrasiIzleme => 'Post-Split Monitoring';

  @override
  String get trendGucluBiyolojikYon => 'Strong Biological Direction';

  @override
  String get trendHasatSonrasiStabil => 'Post-Harvest Stable';

  @override
  String get trendYavasGelisim => 'Slow Development';

  @override
  String get trendHenuzMuayeneYok => 'No inspection data yet.';

  @override
  String get trendMomentumKovanSondu =>
      'Hive marked extinct; momentum read as actual biological loss.';

  @override
  String get trendMomentumBolme =>
      'Frame drop not counted as biological weakening due to split record.';

  @override
  String get trendMomentumHasat =>
      'Frame drop not counted as biological momentum penalty due to honey/harvest record.';

  @override
  String get trendMomentumFizikselDegismedi =>
      'Physical volume unchanged; momentum read as neutral.';

  @override
  String get trendMomentumHizliArtis =>
      'Rapid volume increase not counted as true growth until activation completes.';

  @override
  String get trendMomentumKatGecisi =>
      'Super/honey transition seen as physical volume increase; biological momentum normalised cautiously.';

  @override
  String get trendMomentumDusukAktivasyon =>
      'Growth signal braked because new volume activation is low.';

  @override
  String get trendMomentumBalAkimi =>
      'Healthy upper-volume expansion within honey flow read as biological production direction.';

  @override
  String get trendMomentumNormalize =>
      'Physical increase normalised according to functional capacity.';

  @override
  String get surecOgulRiski => 'Swarm risk';

  @override
  String get surecOgulRiskiTakip => 'Swarm risk monitoring';

  @override
  String get surecTekrarlayanOgul => 'Recurring swarm / population loss risk';

  @override
  String get surecOgulSonrasiArtciYuksek => 'Post-swarm after-swarm risk high';

  @override
  String get surecArtciOgulIzleniyor => 'After-swarm risk monitored';

  @override
  String get surecOgulSonrasiAnaCiftlesme =>
      'Post-swarm queen / mating process';

  @override
  String get surecOgulSonrasiYumurtlamaKontrol => 'Post-swarm laying check';

  @override
  String get surecBolmeSonrasiToparlanma => 'Post-split recovery';

  @override
  String get surecHasatSonrasiBakimGerekli => 'Post-harvest care required';

  @override
  String get surecGelisimYavas => 'Development appears slow';

  @override
  String get surecMesajOgulRiski1 =>
      'Queen cell seen. This is not a health problem but swarm behaviour and colony crowding. Check the colony calmly; if necessary, split or leave 1–2 quality cells and reduce the rest.';

  @override
  String get surecMesajOgulRiski2 =>
      'After-swarm risk is high in the first week. Check the cell count; leaving more than one strong cell can split the colony again. Decide on splitting or reducing excess cells if necessary.';

  @override
  String get surecMesajOgulRiskiTakip =>
      'Swarm sign is in the monitoring period. If there is no new cell, crowding or restlessness, the process will resolve on its own; no unnecessary repeat alerts are generated.';

  @override
  String get surecMesajTekrarlayanOgul =>
      'Swarm records are repeating. This is no longer normal after-swarm monitoring; the colony may lose population rapidly. Cell count, remaining bee strength, stock and queen signs should be read together. If severely weakened, merging or limited support may be more appropriate than intensive labour.';

  @override
  String get surecMesajArtciYuksek =>
      'After-swarm risk is highest in the first week. The goal is not to let the colony swarm again. If inspection is needed, keep it short and calm; leaving too many cells can cause population loss again. Production/super/harvest decisions are secondary.';

  @override
  String get surecMesajArtciIzleniyor =>
      'After-swarm risk continues but decreases compared to the first week. If there is no new cell, restlessness or repeat exit sign, waiting without disturbing the queen process is more appropriate. If daily or sealed brood is seen, the process closes.';

  @override
  String get surecMesajAnaCiftlesme =>
      'After-swarm risk largely closes. This is the new queen emergence, maturation and mating window. Brood may still not be visible; this alone is not collapse. External flight, pollen input and calmness are monitored. If daily or sealed brood is seen, mark it in inspection and the process closes.';

  @override
  String get surecMesajYumurtlamaKontrol =>
      'By days 31–45 post-swarm, laying should now be evident. If daily or sealed brood is seen, the process closes. If still no brood, this is no longer normal waiting; queen failure, mating loss or laying-worker risk is elevated via the no-brood diagnosis.';

  @override
  String get surecMesajBolmeErken =>
      'Keep the colony compact and feed. Support is needed until the new order is established.';

  @override
  String get surecMesajBolmeGecikti =>
      'Check queen status. Recovery may be delayed.';

  @override
  String get kabiliyetBiyolojikBaslik => 'Biological Capability';

  @override
  String get kabiliyetBiyolojikMesaj =>
      'Comb-drawing capacity appears strong. If foundation is to be given, outer expansion without cutting the brood block is safer.';

  @override
  String get kabiliyetGenisletmeRiskiBaslik => 'Expansion Risk';

  @override
  String get kabiliyetGenisletmeRiskiMesaj =>
      'Comb-drawing capacity appears limited. Drawn comb or compact layout is safer than foundation.';

  @override
  String get kabiliyetBalAkimiBaslik => 'Honey Flow Capacity';

  @override
  String get kabiliyetBalAkimiMesaj =>
      'Forager and honey-processing capacity appears strong. Space, super and capping monitoring should be prioritised during the honey flow.';

  @override
  String get kabiliyetBakiciDengeBaslik => 'Nurse Balance';

  @override
  String get kabiliyetBakiciDengeMesaj =>
      'Brood-care capacity is good but comb drawing is limited. Drawn comb that doesn\'t disrupt the brood area is safer than foundation.';

  @override
  String get kabiliyetKisGuvenligiBaslik => 'Winter Safety';

  @override
  String get kabiliyetKisGuvenligiMesaj =>
      'Winter hardiness appears limited. Priority is stock safety and compact layout, not harvest or expansion.';

  @override
  String get kabiliyetBiyolojikSahaNotBaslik => 'Biological Field Note';

  @override
  String get kararAsBiyolojikYon => 'Biological direction';

  @override
  String get perfKriterUreme => 'Reproduction';

  @override
  String get perfKriterUretim => 'Production';

  @override
  String get perfKriterDayaniklilik => 'Resilience';

  @override
  String get perfKriterDavranis => 'Behaviour';

  @override
  String get perfKriterHatGucu => 'Line Strength';

  @override
  String get perfKriterVeriGuveni => 'Data Confidence';

  @override
  String get perfKriterBiyolojikDurum => 'Biological Status';

  @override
  String get perfKriterKoloniGidisati => 'Colony Trend';

  @override
  String get perfKriterHacimAktivasyonu => 'Volume Activation';

  @override
  String get perfKriterPetekOrme => 'Comb Drawing Capacity';

  @override
  String get perfKriterYavruBakim => 'Brood Care Capacity';

  @override
  String get perfKriterBalAkimi => 'Honey Flow Capacity';

  @override
  String get perfKriterKisGuvenligi => 'Winter Safety';

  @override
  String get yorumVeriYok =>
      'No data; decision is limited to identity and source information only.';

  @override
  String get yorumVeriCokSinirli =>
      'Data very limited; system makes a decision but confidence level is low.';

  @override
  String get yorumVeriIzlenmeli =>
      'Data should be monitored; decision exists but should be strengthened with future inspections.';

  @override
  String get yorumVeriYeterli =>
      'Data confidence sufficient; evaluation has entered the reliable band.';

  @override
  String get yorumYetersizVeri => 'No evaluable offspring colony data yet.';

  @override
  String get yorumKararYetersiz => 'Insufficient data to produce a decision.';

  @override
  String get soyDurumVeriYok => 'No Data';

  @override
  String get soyDurumVeriYetersiz => 'Insufficient Data';

  @override
  String get soyDurumGucluSoy => 'Strong Lineage';

  @override
  String get soyDurumOlumluSoy => 'Positive Lineage';

  @override
  String get soyDurumZayifSoy => 'Weak Lineage';

  @override
  String get soyDurumRiskliSoy => 'At-Risk Lineage';

  @override
  String get soyDurumNotr => 'Neutral';

  @override
  String get soyYorumTureyenYok =>
      'No registered offspring colony visible from this colony.';

  @override
  String get soyYorumVeriYetersiz =>
      'Offspring colonies exist; however sufficient data of at least 45 days has not yet accumulated.';

  @override
  String get hatKararVeriYetersiz => 'Insufficient Data';

  @override
  String get hatKararOperasyonel => 'Operational Line';

  @override
  String get hatKararRiskli => 'At-Risk Line';

  @override
  String get hatKararDonor => 'Donor Line';

  @override
  String get hatKararGucluUretim => 'Strong Production Line';

  @override
  String get hatKararTakip => 'Needs Monitoring';

  @override
  String get hatGerekceVeriYetersiz =>
      'Insufficient colony history has accumulated to produce a reliable decision for this line.';

  @override
  String get hatGerekceOperasyonel =>
      'This line is not accepted as a donor line because it contains swarm origin or a confirmed swarm event.';

  @override
  String get hatGerekceRiskli =>
      'Recurring extinction or high extinction rate is observed in this line.';

  @override
  String get hatGereceDonor =>
      'The line appears strong and balanced in terms of development, production and hardiness.';

  @override
  String get hatGerekceGucluUretim =>
      'The line may not be as clean and strong as a donor but is valuable as a production backbone.';

  @override
  String get hatGerekceTakip =>
      'The line does not appear entirely weak; however more clear repeats and performance data are needed before a multiplication decision.';

  @override
  String get hatNotVeriIhtiyac =>
      'At least two colonies and more field repetitions are needed.';

  @override
  String get hatNotDonorOncelikli =>
      'This line is the primary candidate for donor multiplication.';

  @override
  String get hatNotTekrarlayanSonme =>
      'Recurring extinctions are a strong negative signal from a selection perspective.';

  @override
  String get hatNotTekSonme =>
      'A single extinction is not direct elimination, but is a warning signal.';

  @override
  String get hatNotGelisimGuclu =>
      'Development strength within the line appears positive.';

  @override
  String get hatNotBalPerformans =>
      'Average honey performance is positively differentiated.';

  @override
  String get hatNotIzlemeDEvam => 'Monitoring for this line should continue.';

  @override
  String get hatNotKisGuclu => 'Winter exit strength appears positive.';

  @override
  String get hatAksiyonVeriTopla => 'Continue collecting data for this line';

  @override
  String get hatAksiyonErkenKarar => 'Do not make early breeding decisions';

  @override
  String get hatAksiyonAnaUretme => 'Do not rear queens from this line';

  @override
  String get hatAksiyonSinirliUretim => 'Keep new split production limited';

  @override
  String get hatAksiyonUretimDestek => 'Evaluate as production or support line';

  @override
  String get hatAksiyonBolmeYapma => 'Do not split from this line';

  @override
  String get hatAksiyonDonorHavuzu => 'Do not admit to donor pool';

  @override
  String get hatAksiyonHatEleme => 'Consider line culling or queen replacement';

  @override
  String get hatAksiyonAnaUret => 'Rear queens from this line';

  @override
  String get hatAksiyonTemizHat => 'Maintain as a clean multiplication line';

  @override
  String get hatAksiyonDonorOncelik => 'Prioritise in donor pool';

  @override
  String get hatAksiyonUretimdeKor => 'Keep this line in production';

  @override
  String get hatAksiyonSinirliKontrolluBolme =>
      'Consider limited and controlled splitting';

  @override
  String get hatAksiyonUretimOmurgasi =>
      'Evaluate as production backbone, not donor';

  @override
  String get hatAksiyonIzlemeDevam => 'Continue monitoring';

  @override
  String get hatAksiyonKarariErtele => 'Defer decision, accumulate data';

  @override
  String get hatAksiyonMuayeneSiklik =>
      'Increase inspection frequency for critical colonies';

  @override
  String get perfDurumGenetikFiltre => 'Genetic Filter';

  @override
  String get perfDurumSartliDonor => 'Conditional Donor';

  @override
  String get perfDurumGucluUretim => 'Strong Production';

  @override
  String get perfDurumIzlenmeli => 'Needs Monitoring';

  @override
  String get perfDurumMudahale => 'Intervention';

  @override
  String get raporDurumGenetikVeto => 'Genetic Veto';

  @override
  String get raporDurumDonor1 => 'Donor 1';

  @override
  String get raporDurumDonor2 => 'Donor 2';

  @override
  String get raporDurumDonor3 => 'Donor 3';

  @override
  String get raporDurumCokZayif => 'Very Weak';

  @override
  String get raporDurumGelismekte => 'Developing';

  @override
  String get raporDurumGuclu => 'Strong';

  @override
  String get raporDurumCokGuclu => 'Very Strong';
}
