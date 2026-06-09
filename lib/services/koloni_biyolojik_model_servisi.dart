import 'dart:math' as math;

import 'package:itogena_v45/gen_l10n/app_localizations.dart';
import 'trend_servisi.dart';
import 'veritabani_servisi.dart';
import 'cita_aktivasyon_servisi.dart';
import 'sezon_biyoloji_matrisi.dart';
import 'demografi_motoru.dart';
import 'risk_motoru.dart';
import 'projeksiyon_motoru.dart';

class KoloniBiyolojikModelServisi {
  static const String kovanTipiLangstroth = 'Langstroth';
  static const String kovanTipiDadant = 'Dadant';

  static final Map<String, Future<Map<String, dynamic>>> _modelFutureCache = {};

  static String _cacheKey(int koloniId, AppLocalizations? l) =>
      '$koloniId:${l?.localeName ?? 'tr'}';

  /// Aynı koloni için besleme, performans ve biyolojik sekme aynı ağır hesabı
  /// tekrar tekrar çalıştırmasın diye servis seviyesinde tek hesap/çok tüketim
  /// cache'i kullanılır. Veri değiştiğinde ilgili koloni cache'i temizlenmelidir.
  static Future<Map<String, dynamic>> modelGetir(
      int koloniId, {
        bool forceRefresh = false,
        AppLocalizations? l,
      }) async {
    final key = _cacheKey(koloniId, l);
    if (forceRefresh) {
      _modelFutureCache.remove(key);
    }

    final future = _modelFutureCache[key] ??= _modelHesapla(koloniId, l: l);

    try {
      final sonuc = await future;
      return Map<String, dynamic>.from(sonuc);
    } catch (_) {
      if (identical(_modelFutureCache[key], future)) {
        _modelFutureCache.remove(key);
      }
      rethrow;
    }
  }

  static void cacheTemizle([int? koloniId]) {
    if (koloniId == null || koloniId <= 0) {
      _modelFutureCache.clear();
      return;
    }
    _modelFutureCache.removeWhere((k, _) => k.startsWith('$koloniId:'));
  }

  static void tumCacheTemizle() => cacheTemizle();

  static Future<Map<String, dynamic>> _modelHesapla(int koloniId, {AppLocalizations? l}) async {
    final koloni = await VeritabaniServisi.koloniOzetiGetir(koloniId);
    final muayeneler = await VeritabaniServisi.muayeneleriGetir(koloniId);
    final sonMuayene = muayeneler.isNotEmpty ? muayeneler.first : null;
    final oncekiMuayene = muayeneler.length >= 2 ? muayeneler[1] : null;
    Map<String, dynamic> trend = const <String, dynamic>{};
    try {
      trend = await TrendServisi.koloniTrendiGetir(koloniId);
    } catch (_) {
      trend = const <String, dynamic>{};
    }
    Map<String, dynamic> suruplukPenceresi = const <String, dynamic>{};
    try {
      suruplukPenceresi =
      await VeritabaniServisi.suruplukKaldirmaPenceresiGetir(koloniId);
    } catch (_) {
      suruplukPenceresi = const <String, dynamic>{};
    }

    final int? arilikId = _nullableInt(koloni['arilikId']);
    final DateTime modelTarihi = _tarih(sonMuayene?['tarih']) ?? _gun(DateTime.now());

    bool balAkimiAktif = false;
    try {
      final balAkimi = await VeritabaniServisi.aktifBalAkimGetir(
        arilikId: arilikId != null && arilikId > 0 ? arilikId : null,
      );
      final DateTime bugun = _gun(DateTime.now());
      final DateTime? bas = balAkimi?['bas'] as DateTime?;
      final DateTime? bit = balAkimi?['bit'] as DateTime?;
      if (bas != null && bit != null) {
        final DateTime basGun = _gun(bas);
        final DateTime bitGun = _gun(bit);
        balAkimiAktif = !bugun.isBefore(basGun) && !bugun.isAfter(bitGun);
      }
    } catch (_) {
      balAkimiAktif = false;
    }

    Map<String, dynamic> sezonBiyoloji = SezonBiyolojiMatrisi.varsayilanMap(modelTarihi);
    try {
      sezonBiyoloji = (await SezonBiyolojiMatrisi.bilgiGetir(
        tarih: modelTarihi,
        arilikId: arilikId != null && arilikId > 0 ? arilikId : null,
      )).toMap();
      balAkimiAktif = sezonBiyoloji['balAkimiAktif'] == true || balAkimiAktif;
    } catch (_) {
      sezonBiyoloji = SezonBiyolojiMatrisi.varsayilanMap(modelTarihi);
    }

    return modelOlustur(
      koloni: koloni,
      sonMuayene: sonMuayene,
      oncekiMuayene: oncekiMuayene,
      muayeneler: muayeneler,
      trend: trend,
      suruplukPenceresi: suruplukPenceresi,
      balAkimiAktif: balAkimiAktif,
      sezonBiyoloji: sezonBiyoloji,
      l: l,
    );
  }

  static Map<String, dynamic> modelOlustur({
    required Map<String, dynamic> koloni,
    Map<String, dynamic>? sonMuayene,
    Map<String, dynamic>? oncekiMuayene,
    List<Map<String, dynamic>>? muayeneler,
    Map<String, dynamic>? trend,
    Map<String, dynamic>? suruplukPenceresi,
    bool balAkimiAktif = false,
    Map<String, dynamic>? sezonBiyoloji,
    AppLocalizations? l,
  }) {
    final String kovanTipi = normalizeKovanTipi(koloni['kovanTipi']);
    final bool suruplukKayittaVarMi = _toBool(koloni['suruplukVarMi']);
    // Eski kayıtların çoğunda suruplukVarMi alanı migration nedeniyle 0 gelir.
    // Bu 0 değeri her zaman "fiziksel şurupluk yok" anlamına gelmez.
    // İTOGENA görsel modelinde şurupluk, arıcı açıkça kaldırmadıkça varsayılan ekipman olarak modellenir.
    final bool suruplukVarMi = true;
    final bool suruplukKaldirmaPenceresiAktif =
        suruplukPenceresi?['aktif'] == true;
    final bool hamSuruplukKaldirildiMi = _toBool(
      sonMuayene?['suruplukKaldirildiMi'] ?? koloni['suruplukKaldirildiMi'],
    );
    // Şurupluk kaldırma kaydı fiziksel bir muayene bilgisidir.
    // Bal akımı penceresi yalnızca bu alanın ne zaman önerileceğini belirler;
    // kullanıcı muayenede şurupluğu kaldırdıysa biyolojik model bunu doğrudan
    // uygular. Sonraki muayenede alan yeniden işaretlenmezse model tekrar
    // mevcut son muayene verisine göre şurupluğu yerleşime alabilir.
    final bool suruplukKaldirildiMi = hamSuruplukKaldirildiMi;

    final int toplamCita = _pozitifInt(
      sonMuayene?['citaSayisi'] ?? koloni['sonCita'],
    );
    final int balliCita = _pozitifInt(
      sonMuayene?['bal_cita'] ?? koloni['bal_cita'],
    );
    final int yavruluCita = _pozitifInt(sonMuayene?['yavruluCita']);
    final String yavruDuzeni =
    (sonMuayene?['yavruDuzeni'] ?? '').toString().trim();
    final bool yavruYokMu = _yavruYokMu(
      yavruDuzeni: yavruDuzeni,
      yavruluCita: yavruluCita,
    );
    final String kaynakTipi =
    (koloni['kaynakTipi'] ?? '').toString().trim().toLowerCase();
    final Map<String, dynamic> sezonBiyolojiMap = sezonBiyoloji == null
        ? SezonBiyolojiMatrisi.varsayilanMap(_tarih(sonMuayene?['tarih']))
        : Map<String, dynamic>.from(sezonBiyoloji);
    final double sezonAktivasyonKatsayisi =
    _toDouble(sezonBiyolojiMap['aktivasyonKatsayisi']);

    final Map<String, dynamic> citaAktivasyon = CitaAktivasyonServisi.hesapla(
      sonMuayene: sonMuayene,
      oncekiMuayene: oncekiMuayene,
      trend: trend,
      suruplukPenceresi: suruplukPenceresi,
      balAkimiAktif: balAkimiAktif,
      sezonKatsayisi: sezonAktivasyonKatsayisi > 0 ? sezonAktivasyonKatsayisi : null,
    );
    final double islevselToplamCitaDouble =
    _toDouble(citaAktivasyon['islevselCitaOrta']);
    final int islevselToplamCita =
    math.max(0, islevselToplamCitaDouble.round());

    final Map<String, num> katsayi = _katsayilar(kovanTipi);
    // Kat/ballık hacim modeli şurupluk durumuna göre okunur.
    // Şurupluk mevcutsa alt kuluçkalık 9 çıta kabul edilir; şurupluk
    // kaldırıldıysa 10 çıtalık tam kuluçkalık kapasitesi kullanılır.
    // Bu bilgi kullanıcıya ayrıca karar olarak gösterilmez; biyolojik modelin
    // fiziksel kapasite ve kat eşiği hesabında iç veri olarak kullanılır.
    final bool suruplukHacimKaplarMi = suruplukVarMi && !suruplukKaldirildiMi;
    final int kuluclukKapasitesi = suruplukHacimKaplarMi ? 9 : 10;
    final int birinciKatVermeEsigi = kuluclukKapasitesi;
    final int katliKabulEsigi = kuluclukKapasitesi + 1;
    final int ucuncuKatVermeEsigi = kuluclukKapasitesi + 10;
    final int ucKatliKabulEsigi = kuluclukKapasitesi + 11;
    final bool katAtildi = toplamCita >= katliKabulEsigi;
    final bool ucKatliKoloni = toplamCita >= ucKatliKabulEsigi;
    final int tahminiKatSayisi = ucKatliKoloni ? 3 : (katAtildi ? 2 : 1);
    final int kuluclukCita =
    islevselToplamCita.clamp(0, kuluclukKapasitesi).toInt();
    final int fizikselKuluclukCita =
    toplamCita.clamp(0, kuluclukKapasitesi).toInt();
    final int ballikCita =
    katAtildi ? math.max(0, islevselToplamCita - kuluclukKapasitesi) : 0;
    final int fizikselBallikCita =
    katAtildi ? math.max(0, toplamCita - kuluclukKapasitesi) : 0;

    final int tahminiAriMin = (islevselToplamCita * katsayi['ariMin']!).round();
    final int tahminiAriMax = (islevselToplamCita * katsayi['ariMax']!).round();
    final int tahminiAriOrta = ((tahminiAriMin + tahminiAriMax) / 2).round();
    final int tahminiGozMin = (kuluclukCita * katsayi['gozMin']!).round();
    final int tahminiGozMax = (kuluclukCita * katsayi['gozMax']!).round();

    final int tahminiYavruCita = yavruYokMu
        ? 0
        : yavruluCita > 0
        ? yavruluCita.clamp(0, kuluclukCita).toInt()
        : _tahminiYavruCita(kuluclukCita, yavruDuzeni: yavruDuzeni);
    final int tahminiPolenCita =
    _tahminiPolenCita(kuluclukCita, tahminiYavruCita);
    final int tahminiStokCita = math.max(
      0,
      kuluclukCita - tahminiYavruCita - tahminiPolenCita,
    );

    final int tahminiYavruGozMin =
    (tahminiYavruCita * katsayi['yavruGozMin']!).round();
    final int tahminiYavruGozMax =
    (tahminiYavruCita * katsayi['yavruGozMax']!).round();
    final int tahminiYavruGozOrta =
    ((tahminiYavruGozMin + tahminiYavruGozMax) / 2).round();

    final double balKatsayiMin = katsayi['balKgMin']!.toDouble();
    final double balKatsayiMax = katsayi['balKgMax']!.toDouble();
    final hasatCitalari = _hasatAdayCitalari(
      kuluclukCita: kuluclukCita,
      kuluclukKapasitesi: kuluclukKapasitesi,
      ballikCita: ballikCita,
      balliCita: balliCita,
    );
    final hasatGuvenligi = _hasatGuvenligi(
      kuluclukCita: kuluclukCita,
      kuluclukKapasitesi: kuluclukKapasitesi,
      ballikCita: ballikCita,
      balliCita: balliCita,
      hasatAdaySayisi: hasatCitalari.length,
      l: l,
    );
    final int hasatEdilebilirCita = hasatCitalari.length;
    final double hasatPotansiyeliMinKg = hasatEdilebilirCita * balKatsayiMin;
    final double hasatPotansiyeliMaxKg = hasatEdilebilirCita * balKatsayiMax;

    final double birakilmasiGerekenBalMinKg =
    _birakilacakBalMinKg(kuluclukCita, kovanTipi);
    final double birakilmasiGerekenBalMaxKg =
    _birakilacakBalMaxKg(kuluclukCita, kovanTipi);

    final yerlesim = _yerlesimDizilimi(kuluclukCita);
    final yerlesimLoc = l != null ? yerlesim.map((t) => _citaTipLocalize(t, l)).toList() : yerlesim;
    final yerlesimSatirlari = _yerlesimSatirlari(yerlesimLoc, l: l);
    final yavruBlok = _yavruBlokAraligi(yerlesim, l: l);
    final anaBolgesi = _anaBolgesiMetni(kuluclukCita, yavruBlok, l: l);
    final gelisimAlani = _gelisimAlaniMetni(yerlesim, kuluclukKapasitesi, l: l);
    final kovanYerlesimi = _kovanYerlesimiOlustur(
      yerlesim: yerlesim,
      suruplukVarMi: suruplukVarMi,
      suruplukKaldirildiMi: suruplukKaldirildiMi,
      kuluclukKapasitesi: kuluclukKapasitesi,
      katAtildi: katAtildi,
      ucKatliKoloni: ucKatliKoloni,
      kuluclukCita: fizikselKuluclukCita,
      ballikCita: fizikselBallikCita,
      yavruBlok: yavruBlok,
      islevselToplamCita: islevselToplamCitaDouble,
      aktivasyonOrani: _toDouble(citaAktivasyon['aktivasyonOrani']),
      eklenenCita: _toInt(citaAktivasyon['eklenenCita']),
      katReorganizasyonModu: _toBool(citaAktivasyon['katGecisiVar']),
      l: l,
    );

    final double gunlukMomentum = _toDouble(trend?['gunlukMomentum']);
    final String momentumEtiketi =
    (trend?['momentumEtiketi'] ?? '').toString().trim();
    final Map<String, dynamic> demografi = DemografiMotoru.hesapla(
      tahminiAri: tahminiAriOrta,
      tahminiYavru: tahminiYavruGozOrta,
      kuluclukCita: kuluclukCita,
      ballikCita: ballikCita,
      gunlukMomentum: gunlukMomentum,
      momentumEtiketi: momentumEtiketi,
      kaynakTipi: kaynakTipi,
      yavruDuzeni: yavruDuzeni,
      sezonBiyoloji: sezonBiyolojiMap,
    );
    final Map<String, dynamic> kabiliyet = _kabiliyetOlustur(
      demografi: demografi,
      kuluclukCita: kuluclukCita,
      ballikCita: ballikCita,
      balliCita: balliCita,
      islevselToplamCita: islevselToplamCitaDouble,
      islevselUretimCita: _toInt(citaAktivasyon['islevselUretimCita']),
      aktivasyonOrani: _toDouble(citaAktivasyon['aktivasyonOrani']),
      riskliSisirme: _toBool(citaAktivasyon['riskliSisirme']),
      uretimGuvenliMi: _toBool(citaAktivasyon['uretimGuvenliMi']),
      balAkimiAktif: balAkimiAktif,
      sezonBiyoloji: sezonBiyolojiMap,
      gunlukMomentum: gunlukMomentum,
      momentumEtiketi: momentumEtiketi,
      yavruDuzeni: yavruDuzeni,
      l: l,
    );
    final Map<String, dynamic> yavrusuzlukAnalizi = _yavrusuzlukAnaliziOlustur(
      koloni: koloni,
      sonMuayene: sonMuayene,
      muayeneler: muayeneler ?? const <Map<String, dynamic>>[],
      toplamCita: toplamCita,
      kuluclukCita: kuluclukCita,
      yavruYokMu: yavruYokMu,
      balAkimiAktif: balAkimiAktif,
      balliCita: balliCita,
      gunlukMomentum: gunlukMomentum,
      momentumEtiketi: momentumEtiketi,
      kaynakTipi: kaynakTipi,
      l: l,
    );

    final Map<String, dynamic> koloniSinifi = _koloniSinifiBelirle(
      fizikselCita: toplamCita,
      islevselCita: islevselToplamCita,
      islevselUretimCita: _toInt(citaAktivasyon['islevselUretimCita']),
      aktivasyonOrani: _toDouble(citaAktivasyon['aktivasyonOrani']),
      balAkimiAktif: balAkimiAktif,
      hasatEdilebilirCita: hasatEdilebilirCita,
      l: l,
    );

    final Map<String, dynamic> riskAnalizi = RiskMotoru.hesapla(
      demografi: demografi,
      kabiliyet: kabiliyet,
      citaAktivasyon: citaAktivasyon,
      sezonBiyoloji: sezonBiyolojiMap,
      yavrusuzlukAnalizi: yavrusuzlukAnalizi,
      toplamCita: toplamCita,
      kuluclukCita: kuluclukCita,
      ballikCita: ballikCita,
      balliCita: balliCita,
      islevselToplamCita: islevselToplamCitaDouble,
      islevselUretimCita: _toInt(citaAktivasyon['islevselUretimCita']),
      aktivasyonOrani: _toDouble(citaAktivasyon['aktivasyonOrani']),
      balAkimiAktif: balAkimiAktif,
      yavruYokMu: yavruYokMu,
      riskliSisirme: _toBool(citaAktivasyon['riskliSisirme']),
      uretimGuvenliMi: _toBool(citaAktivasyon['uretimGuvenliMi']),
      hasatEdilebilirCita: hasatEdilebilirCita,
      tahminiStokCita: tahminiStokCita,
      koloniSinifi: (koloniSinifi['kod'] ?? '').toString(),
      gunlukMomentum: gunlukMomentum,
      momentumEtiketi: momentumEtiketi,
    );

    final Map<String, dynamic> projeksiyon = ProjeksiyonMotoru.hesapla(
      demografi: demografi,
      kabiliyet: kabiliyet,
      riskAnalizi: riskAnalizi,
      sezonBiyoloji: sezonBiyolojiMap,
      citaAktivasyon: citaAktivasyon,
      balAkimiAktif: balAkimiAktif,
      yavruYokMu: yavruYokMu,
      toplamCita: toplamCita,
      balliCita: balliCita,
      tahminiYavruCita: tahminiYavruCita,
      tahminiStokCita: tahminiStokCita,
      aktivasyonOrani: _toDouble(citaAktivasyon['aktivasyonOrani']),
      gunlukMomentum: gunlukMomentum,
      momentumEtiketi: momentumEtiketi,
    );

    final Map<String, dynamic> biyolojikProjeksiyon = _biyolojikProjeksiyonOlustur(
      demografi: demografi,
      kabiliyet: kabiliyet,
      kuluclukCita: kuluclukCita,
      ballikCita: ballikCita,
      balliCita: balliCita,
      islevselToplamCita: islevselToplamCitaDouble,
      islevselUretimCita: _toInt(citaAktivasyon['islevselUretimCita']),
      aktivasyonOrani: _toDouble(citaAktivasyon['aktivasyonOrani']),
      riskliSisirme: _toBool(citaAktivasyon['riskliSisirme']),
      uretimGuvenliMi: _toBool(citaAktivasyon['uretimGuvenliMi']),
      balAkimiAktif: balAkimiAktif,
      sezonBiyoloji: sezonBiyolojiMap,
      gunlukMomentum: gunlukMomentum,
      momentumEtiketi: momentumEtiketi,
      yavruYokMu: yavruYokMu,
      yavrusuzlukAnalizi: yavrusuzlukAnalizi,
      tahminiYavruCita: tahminiYavruCita,
      tahminiStokCita: tahminiStokCita,
      hasatEdilebilirCita: hasatEdilebilirCita,
      koloniSinifi: (koloniSinifi['kod'] ?? '').toString(),
      l: l,
    );

    final yorum = _yorumUret(
      toplamCita: toplamCita,
      kuluclukCita: kuluclukCita,
      ballikCita: ballikCita,
      kuluclukKapasitesi: kuluclukKapasitesi,
      balliCita: balliCita,
      hasatPotansiyeliMaxKg: hasatPotansiyeliMaxKg,
      kabiliyet: kabiliyet,
      yavruBlok: yavruBlok,
      yavrusuzlukAnalizi: yavrusuzlukAnalizi,
      l: l,
    );

    return {
      'kovanTipi': kovanTipi,
      'suruplukVarMi': suruplukVarMi,
      'suruplukKayittaVarMi': suruplukKayittaVarMi,
      'suruplukKaldirildiMi': suruplukKaldirildiMi,
      'suruplukKaldirmaPenceresiAktif': suruplukKaldirmaPenceresiAktif,
      'suruplukKaldirmaMesaji': (suruplukPenceresi?['mesaj'] ?? '').toString(),
      'suruplukKonumMetni': kovanYerlesimi['suruplukKonumMetni'],
      'suruplukHacimKaplarMi': suruplukHacimKaplarMi,
      'kuluclukKapasitesi': kuluclukKapasitesi,
      'birinciKatVermeEsigi': birinciKatVermeEsigi,
      'katliKabulEsigi': katliKabulEsigi,
      'ucuncuKatVermeEsigi': ucuncuKatVermeEsigi,
      'ucKatliKabulEsigi': ucKatliKabulEsigi,
      'tahminiKatSayisi': tahminiKatSayisi,
      'ucKatliKoloni': ucKatliKoloni,
      'toplamCita': toplamCita,
      'fizikselToplamCita': toplamCita,
      'islevselToplamCita': islevselToplamCita,
      'islevselToplamCitaOrta': citaAktivasyon['islevselCitaOrta'],
      'islevselCitaMin': citaAktivasyon['islevselCitaMin'],
      'islevselCitaMax': citaAktivasyon['islevselCitaMax'],
      'toplamHacimAktivasyonOrani': citaAktivasyon['toplamHacimAktivasyonOrani'],
      'toplamHacimAktivasyonYuzde': citaAktivasyon['toplamHacimAktivasyonYuzde'],
      'yeniHacimAktivasyonOrani': citaAktivasyon['yeniHacimAktivasyonOrani'],
      'yeniHacimAktivasyonYuzde': citaAktivasyon['yeniHacimAktivasyonYuzde'],
      'citaAktivasyon': citaAktivasyon,
      'hacimDegisimTipi': citaAktivasyon['hacimDegisimTipi'],
      'uretimGuvenliMi': citaAktivasyon['uretimGuvenliMi'],
      'balAkimiGenislemesi': citaAktivasyon['balAkimiGenislemesi'],
      'hasatKaynakliDusus': citaAktivasyon['hasatKaynakliDusus'],
      'riskliSisirme': citaAktivasyon['riskliSisirme'],
      'islevselUretimCita': citaAktivasyon['islevselUretimCita'],
      'balAkimiAktif': balAkimiAktif,
      'sezonBiyoloji': sezonBiyolojiMap,
      'sezonBiyolojiKodu': sezonBiyolojiMap['kod'],
      'sezonBiyolojiAdi': sezonBiyolojiMap['ad'],
      'sezonAktivasyonKatsayisi': sezonBiyolojiMap['aktivasyonKatsayisi'],
      'koloniSinifi': koloniSinifi['kod'],
      'koloniSinifEtiketi': koloniSinifi['etiket'],
      'koloniSinifAciklama': koloniSinifi['aciklama'],
      'koloniSinifReferansCita': koloniSinifi['referansCita'],
      'koloniSinifKaynak': koloniSinifi['kaynak'],
      'zayifKoloniMi': koloniSinifi['zayifKoloniMi'],
      'gelisimKolonisiMi': koloniSinifi['gelisimKolonisiMi'],
      'uretimKolonisiMi': koloniSinifi['uretimKolonisiMi'],
      'hasatKolonisiMi': koloniSinifi['hasatKolonisiMi'],
      'hasatBeklentisiVarMi': koloniSinifi['hasatBeklentisiVarMi'],
      'kuluclukCita': kuluclukCita,
      'fizikselKuluclukCita': fizikselKuluclukCita,
      'ballikCita': ballikCita,
      'fizikselBallikCita': fizikselBallikCita,
      'katAtildi': katAtildi,
      'tahminiAriMin': tahminiAriMin,
      'tahminiAriMax': tahminiAriMax,
      'tahminiAriOrta': tahminiAriOrta,
      'tahminiGozMin': tahminiGozMin,
      'tahminiGozMax': tahminiGozMax,
      'tahminiYavruCita': tahminiYavruCita,
      'tahminiYavruGozMin': tahminiYavruGozMin,
      'tahminiYavruGozMax': tahminiYavruGozMax,
      'tahminiYavruGozOrta': tahminiYavruGozOrta,
      'yavruYokMu': yavruYokMu,
      'yavrusuzlukAnalizi': yavrusuzlukAnalizi,
      'biyolojikCokusRiski': yavrusuzlukAnalizi['biyolojikCokusRiski'],
      'geriDonusKapasitesi': yavrusuzlukAnalizi['geriDonusKapasitesi'],
      'kaynakHarcamayaDegerMi': yavrusuzlukAnalizi['kaynakHarcamayaDegerMi'],
      'yavrusuzlukSahaMesaji': yavrusuzlukAnalizi['sahaMesaji'],
      'tahminiPolenCita': tahminiPolenCita,
      'tahminiStokCita': tahminiStokCita,
      'hasatEdilebilirCita': hasatEdilebilirCita,
      'hasatPotansiyeliMinKg': _yuvarla(hasatPotansiyeliMinKg),
      'hasatPotansiyeliMaxKg': _yuvarla(hasatPotansiyeliMaxKg),
      'birakilmasiGerekenBalMinKg': _yuvarla(birakilmasiGerekenBalMinKg),
      'birakilmasiGerekenBalMaxKg': _yuvarla(birakilmasiGerekenBalMaxKg),
      'anaBolgesi': anaBolgesi,
      'yavruBlok': yavruBlok,
      'gelisimAlani': gelisimAlani,
      'hasatAdayCitalari': hasatCitalari,
      'hasatAdayMetni': _hasatAdayMetni(hasatCitalari, l: l),
      'hasatGuvenligi': hasatGuvenligi['seviye'],
      'hasatGuvenligiMesaji': hasatGuvenligi['mesaj'],
      'hasatKuralMetni': hasatGuvenligi['kural'],
      'yerlesim': yerlesimLoc,
      'yerlesimSatirlari': yerlesimSatirlari,
      'yerlesimMetni': yerlesimLoc.join(' / '),
      'altKatYerlesim': kovanYerlesimi['altKatYerlesim'],
      'ustKatYerlesim': kovanYerlesimi['ustKatYerlesim'],
      'ucuncuKatYerlesim': kovanYerlesimi['ucuncuKatYerlesim'],
      'tacPozisyonlari': kovanYerlesimi['tacPozisyonlari'],
      'kovanGorselNotu': kovanYerlesimi['not'],
      'demografi': demografi,
      'kabiliyet': kabiliyet,
      'riskAnalizi': riskAnalizi,
      'genelRisk': riskAnalizi['genelRisk'],
      'riskFreni': riskAnalizi['riskFreni'],
      'anaRisk': riskAnalizi['anaRisk'],
      'anaRiskBaslik': riskAnalizi['anaRiskBaslik'],
      'riskKisaMesaj': riskAnalizi['kisaMesaj'],
      'projeksiyon': projeksiyon,
      'projeksiyonOzeti': projeksiyon['projeksiyonOzeti'],
      'gelisimProjeksiyonu': projeksiyon['gelisimYonu'],
      'toparlanmaProjeksiyonu': projeksiyon['toparlanmaYonu'],
      'uretimProjeksiyonu': projeksiyon['uretimYonu'],
      'yaslanmaProjeksiyonu': projeksiyon['yaslanmaYonu'],
      'kisProjeksiyonu': projeksiyon['kisYonu'],
      'alanProjeksiyonu': projeksiyon['alanYonu'],
      'biyolojikProjeksiyon': biyolojikProjeksiyon,
      'gelisimYonu': biyolojikProjeksiyon['gelisimYonu'],
      'uretimYonu': biyolojikProjeksiyon['uretimYonu'],
      'biyolojikMomentum': biyolojikProjeksiyon['biyolojikMomentum'],
      'alanBaskisi': biyolojikProjeksiyon['alanBaskisi'],
      'toparlanmaPotansiyeli': biyolojikProjeksiyon['toparlanmaPotansiyeli'],
      'cokusRiski': biyolojikProjeksiyon['cokusRiski'],
      'savunmaKirganligi': biyolojikProjeksiyon['savunmaKirganligi'],
      'hasatEgilimi': biyolojikProjeksiyon['hasatEgilimi'],
      'ilgincBilgiler': _ilgincBilgiler(
        tahminiGozMin: tahminiGozMin,
        tahminiGozMax: tahminiGozMax,
        tahminiAriMin: tahminiAriMin,
        tahminiAriMax: tahminiAriMax,
        tahminiYavruGozMin: tahminiYavruGozMin,
        tahminiYavruGozMax: tahminiYavruGozMax,
        hasatMin: hasatPotansiyeliMinKg,
        hasatMax: hasatPotansiyeliMaxKg,
        l: l,
      ),
      'yorum': yorum,
    };
  }



  static Map<String, dynamic> _koloniSinifiBelirle({
    required int fizikselCita,
    required int islevselCita,
    required int islevselUretimCita,
    required double aktivasyonOrani,
    required bool balAkimiAktif,
    required int hasatEdilebilirCita,
    AppLocalizations? l,
  }) {
    final int referansCita = islevselUretimCita > 0
        ? islevselUretimCita
        : (islevselCita > 0 ? islevselCita : fizikselCita);
    final String kaynak = islevselUretimCita > 0
        ? 'islevsel_uretim_cita'
        : (islevselCita > 0 ? 'islevsel_toplam_cita' : 'fiziksel_cita');

    String kod;
    String etiket;
    String aciklama;

    if (referansCita <= 3) {
      kod = 'ZAYIF';
      etiket = l?.biyolSinifEtiketZayif ?? 'Zayıf';
      aciklama = l?.biyolSinifAciklamaZayif ?? 'Öncelik yaşatma, sıkıştırma ve ölçülü destek.';
    } else if (referansCita <= 7) {
      kod = 'GELISIM';
      etiket = l?.biyolSinifEtiketGelisim ?? 'Gelişim';
      aciklama = l?.biyolSinifAciklamaGelisim ?? 'Öncelik düzenli gelişim ve ana/yavru dengesinin korunması.';
    } else if (referansCita <= 9) {
      kod = 'URETIM';
      etiket = l?.biyolSinifEtiketUretim ?? 'Üretim';
      aciklama = l?.biyolSinifAciklamaUretim ?? 'Koloni üretim gücüne girmiştir; alan, oğul riski ve bal akımı birlikte izlenir.';
    } else {
      kod = 'HASAT';
      etiket = l?.biyolSinifEtiketHasat ?? 'Hasat';
      aciklama = l?.biyolSinifAciklamaHasat ?? 'Koloni bal akımı ve hasat/alan yönetimi açısından güçlü banttadır.';
    }

    final bool hasatBeklentisiVarMi = referansCita >= 8 &&
        (balAkimiAktif || hasatEdilebilirCita > 0 || fizikselCita >= 8) &&
        aktivasyonOrani >= 0.70;

    return {
      'kod': kod,
      'etiket': etiket,
      'aciklama': aciklama,
      'referansCita': referansCita,
      'kaynak': kaynak,
      'zayifKoloniMi': kod == 'ZAYIF',
      'gelisimKolonisiMi': kod == 'GELISIM',
      'uretimKolonisiMi': kod == 'URETIM',
      'hasatKolonisiMi': kod == 'HASAT',
      'hasatBeklentisiVarMi': hasatBeklentisiVarMi,
    };
  }

  static bool _yavruYokMu({
    required String yavruDuzeni,
    required int yavruluCita,
  }) {
    final d = yavruDuzeni.trim().toLowerCase();
    if (d == 'yok' || d.contains('yok')) return true;
    return yavruluCita <= 0 && d.isEmpty;
  }

  static Map<String, dynamic> _yavrusuzlukAnaliziOlustur({
    required Map<String, dynamic> koloni,
    required Map<String, dynamic>? sonMuayene,
    required List<Map<String, dynamic>> muayeneler,
    required int toplamCita,
    required int kuluclukCita,
    required bool yavruYokMu,
    required bool balAkimiAktif,
    required int balliCita,
    required double gunlukMomentum,
    required String momentumEtiketi,
    required String kaynakTipi,
    AppLocalizations? l,
  }) {
    final DateTime bugun = _gun(DateTime.now());
    final DateTime sonMuayeneTarihi =
        _tarih(sonMuayene?['tarih']) ?? bugun;
    final DateTime? koloniBaslangic = _tarih(koloni['olusturmaTarihi']);

    final List<Map<String, dynamic>> sirali = List<Map<String, dynamic>>.from(
      muayeneler,
    )..sort((a, b) {
      final at = _tarih(a['tarih']) ?? DateTime(1900);
      final bt = _tarih(b['tarih']) ?? DateTime(1900);
      return bt.compareTo(at);
    });

    int ardisikYavrusuzMuayene = 0;
    DateTime? sonYavruGorulenTarih;
    bool yeniYavruDestegiVarMi = false;

    for (final m in sirali) {
      final String duzen = (m['yavruDuzeni'] ?? '').toString().trim();
      final int yavrulu = _pozitifInt(m['yavruluCita']);
      final bool kayittaYavruYok = _yavruYokMu(
        yavruDuzeni: duzen,
        yavruluCita: yavrulu,
      );
      final bool kapaliYavruDestegi =
          _toBool(m['kapaliYavruluCitaAktarildi']) ||
              _toBool(m['gunlukKapaliYavruGoruldu']);
      if (kapaliYavruDestegi) yeniYavruDestegiVarMi = true;
      if (kayittaYavruYok) {
        ardisikYavrusuzMuayene++;
        continue;
      }
      sonYavruGorulenTarih = _tarih(m['tarih']);
      break;
    }

    final DateTime yavrusuzlukReferansi =
        sonYavruGorulenTarih ?? koloniBaslangic ?? sonMuayeneTarihi;
    final int yavrusuzGun =
    math.max(0, sonMuayeneTarihi.difference(_gun(yavrusuzlukReferansi)).inDays);

    final bool bolmeOgulKokenli = kaynakTipi.contains('bölme') ||
        kaynakTipi.contains('bolme') ||
        kaynakTipi.contains('oğul') ||
        kaynakTipi.contains('ogul');
    final bool kucukKoloni = toplamCita <= 4 || kuluclukCita <= 4;
    final bool cokKucukKoloni = toplamCita <= 3 || kuluclukCita <= 3;
    final bool trendZayif = gunlukMomentum < -0.02 ||
        momentumEtiketi.toLowerCase().contains('zayıf') ||
        momentumEtiketi.toLowerCase().contains('zayif') ||
        momentumEtiketi.toLowerCase().contains('düş') ||
        momentumEtiketi.toLowerCase().contains('dus');
    final bool balBaskisiOlabilir = balAkimiAktif &&
        toplamCita >= 6 &&
        balliCita >= math.max(2, (toplamCita * 0.35).round());

    int yasamGucu = 100;
    if (!yavruYokMu) yasamGucu += 5;
    if (yavruYokMu) yasamGucu -= 20;
    if (cokKucukKoloni) {
      yasamGucu -= 30;
    } else if (kucukKoloni) {
      yasamGucu -= 20;
    }
    if (yavrusuzGun >= 45) {
      yasamGucu -= 40;
    } else if (yavrusuzGun >= 35) {
      yasamGucu -= 25;
    } else if (yavrusuzGun >= 21) {
      yasamGucu -= 12;
    }
    if (ardisikYavrusuzMuayene >= 3) {
      yasamGucu -= 18;
    } else if (ardisikYavrusuzMuayene >= 2) {
      yasamGucu -= 10;
    }
    if (trendZayif) yasamGucu -= 15;
    if (!yeniYavruDestegiVarMi && yavrusuzGun >= 30) yasamGucu -= 10;
    if (balBaskisiOlabilir) yasamGucu += 10;
    if (bolmeOgulKokenli && yavrusuzGun <= 30) yasamGucu += 8;
    yasamGucu = yasamGucu.clamp(0, 100).toInt();

    final String geriDonusKapasitesi;
    final String biyolojikCokusRiski;
    final bool kaynakHarcamayaDegerMi;
    if (yasamGucu >= 70) {
      geriDonusKapasitesi = 'iyi';
      biyolojikCokusRiski = 'dusuk';
      kaynakHarcamayaDegerMi = true;
    } else if (yasamGucu >= 50) {
      geriDonusKapasitesi = 'sinirli';
      biyolojikCokusRiski = 'orta';
      kaynakHarcamayaDegerMi = true;
    } else if (yasamGucu >= 30) {
      geriDonusKapasitesi = 'dusuk';
      biyolojikCokusRiski = 'yuksek';
      kaynakHarcamayaDegerMi = false;
    } else {
      geriDonusKapasitesi = 'kritik';
      biyolojikCokusRiski = 'kritik';
      kaynakHarcamayaDegerMi = false;
    }

    String sahaMesaji = '';
    String oncelikliOneri = '';
    if (!yavruYokMu) {
      sahaMesaji = l?.biyolYavrusuzlukMesajNormal ?? 'Yavru verisi mevcut; biyolojik geri dönüş kapasitesi yavru üretimiyle destekleniyor.';
      oncelikliOneri = l?.biyolYavrusuzlukOneriNormal ?? 'Normal biyolojik model akışıyla izle.';
    } else if (bolmeOgulKokenli && yavrusuzGun <= 20) {
      sahaMesaji = l?.biyolYavrusuzlukMesajBolmeOgul ?? 'Bu aşamada yavru görülmemesi normal olabilir. Koloni ana kazanma veya çiftleşme döneminde olabilir; gereksiz açma riski artırır.';
      oncelikliOneri = l?.biyolYavrusuzlukOneriBolmeOgul ?? 'Kovanı gereksiz açma; yumurtlama kontrol penceresini bekle.';
    } else if (balBaskisiOlabilir) {
      sahaMesaji = l?.biyolYavrusuzlukMesajBalBaskisi ?? 'Yavru yokluğu tek başına anasızlık anlamına gelmez. Bal akımı ve ballı çıta baskısı yumurtlama alanını daraltmış olabilir.';
      oncelikliOneri = l?.biyolYavrusuzlukOneriBalBaskisi ?? 'Önce alan ve bal baskısını değerlendir; erken ana müdahalesi yapma.';
    } else if (geriDonusKapasitesi == 'dusuk' || geriDonusKapasitesi == 'kritik') {
      sahaMesaji = l?.biyolYavrusuzlukMesajDusukKapasite ?? 'Koloni uzun süredir yeni işçi üretmiyor. Bu güç seviyesinde mevcut nüfus yaşlanıyor olabilir; yoğun emek ve kaynak harcamak verimli olmayabilir.';
      oncelikliOneri = l?.biyolYavrusuzlukOneriDusukKapasite ?? 'Güçlü koloniyle birleştirme veya sınırlı müdahale öncelikli değerlendirilmelidir.';
    } else if (yavrusuzGun >= 31) {
      sahaMesaji = l?.biyolYavrusuzlukMesajGecYumurtlama ?? 'Yumurtlama beklenen döneme girilmiş. Yavru hâlâ yoksa geç çiftleşme, ana kaybı, bal baskısı veya zayıf koloni olasılıkları birlikte okunmalı.';
      oncelikliOneri = l?.biyolYavrusuzlukOneriGecYumurtlama ?? '5–7 gün içinde tekrar kontrol et; koloni zayıflıyorsa beklemeyi uzatma.';
    } else {
      sahaMesaji = l?.biyolYavrusuzlukMesajGenel ?? 'Yavru yokluğu izlenmeli; mevcut gün aralığında tek başına kesin anasızlık kararı verilmemelidir.';
      oncelikliOneri = l?.biyolYavrusuzlukOneriGenel ?? 'Koloni davranışı, polen gelişi ve bir sonraki muayene ile birlikte değerlendir.';
    }

    return {
      'yavruYokMu': yavruYokMu,
      'yavrusuzGun': yavrusuzGun,
      'ardisikYavrusuzMuayeneSayisi': ardisikYavrusuzMuayene,
      'sonYavruGorulenTarih': sonYavruGorulenTarih == null
          ? ''
          : '${sonYavruGorulenTarih.year.toString().padLeft(4, '0')}-${sonYavruGorulenTarih.month.toString().padLeft(2, '0')}-${sonYavruGorulenTarih.day.toString().padLeft(2, '0')}',
      'yeniYavruDestegiVarMi': yeniYavruDestegiVarMi,
      'bolmeOgulKokenli': bolmeOgulKokenli,
      'kucukKoloni': kucukKoloni,
      'trendZayif': trendZayif,
      'balBaskisiOlabilir': balBaskisiOlabilir,
      'yasamGucuSkoru': yasamGucu,
      'geriDonusKapasitesi': geriDonusKapasitesi,
      'biyolojikCokusRiski': biyolojikCokusRiski,
      'kaynakHarcamayaDegerMi': kaynakHarcamayaDegerMi,
      'sahaMesaji': sahaMesaji,
      'oncelikliOneri': oncelikliOneri,
    };
  }

  static DateTime? _tarih(dynamic deger) {
    if (deger == null) return null;
    if (deger is DateTime) return _gun(deger);
    final s = deger.toString().trim();
    if (s.isEmpty) return null;
    final dt = DateTime.tryParse(s);
    if (dt == null) return null;
    return _gun(dt);
  }

  static String normalizeKovanTipi(dynamic deger) {
    final temiz = (deger ?? '').toString().trim().toLowerCase();
    if (temiz.contains('dadant')) return kovanTipiDadant;
    return kovanTipiLangstroth;
  }

  static Map<String, num> _katsayilar(String kovanTipi) {
    if (kovanTipi == kovanTipiDadant) {
      return const {
        'ariMin': 2300,
        'ariMax': 2700,
        'gozMin': 8000,
        'gozMax': 9000,
        'yavruGozMin': 5000,
        'yavruGozMax': 6500,
        'balKgMin': 3.0,
        'balKgMax': 4.0,
      };
    }
    return const {
      'ariMin': 1800,
      'ariMax': 2200,
      'gozMin': 6000,
      'gozMax': 7000,
      'yavruGozMin': 3500,
      'yavruGozMax': 5000,
      'balKgMin': 2.0,
      'balKgMax': 2.5,
    };
  }

  static int _tahminiYavruCita(int kuluclukCita,
      {required String yavruDuzeni}) {
    final d = yavruDuzeni.toLowerCase();
    if (d == 'yok' || d.contains('yok')) return 0;
    int temel;
    if (kuluclukCita <= 0) {
      temel = 0;
    } else if (kuluclukCita <= 3) {
      temel = 1;
    } else if (kuluclukCita <= 5) {
      temel = 2;
    } else if (kuluclukCita <= 7) {
      temel = 3;
    } else if (kuluclukCita <= 8) {
      temel = 4;
    } else {
      temel = 5;
    }
    if (d.contains('blok')) temel += 1;
    if (d.contains('dağınık') || d.contains('daginik') || d.contains('kambur'))
      temel -= 1;
    return temel.clamp(0, kuluclukCita).toInt();
  }

  static int _tahminiPolenCita(int kuluclukCita, int yavruCita) {
    if (kuluclukCita <= 3) return 1;
    if (kuluclukCita <= 6) return 1;
    if (kuluclukCita <= 8) return 2;
    return math.max(1, math.min(2, kuluclukCita - yavruCita - 2));
  }

  static double _birakilacakBalMinKg(int kuluclukCita, String kovanTipi) {
    final double katsayi = kovanTipi == kovanTipiDadant ? 1.1 : 0.8;
    return math.max(2.5, kuluclukCita * katsayi);
  }

  static double _birakilacakBalMaxKg(int kuluclukCita, String kovanTipi) {
    final double katsayi = kovanTipi == kovanTipiDadant ? 1.5 : 1.1;
    return math.max(4.0, kuluclukCita * katsayi);
  }

  static List<String> _yerlesimDizilimi(int cita) {
    switch (cita) {
      case 0:
        return const <String>[];
      case 1:
        return const ['Yavru/stok'];
      case 2:
        return const ['Ballı/polenli', 'Yavru/stok'];
      case 3:
        return const ['Bal stoğu', 'Yavru', 'Ballı/polenli'];
      case 4:
        return const ['Bal stoğu', 'Yavru/polenli', 'Yavru', 'Bal stoğu'];
      case 5:
        return const [
          'Bal stoğu',
          'Ballı/polenli',
          'Yavru',
          'Ballı/polenli',
          'Bal stoğu'
        ];
      case 6:
        return const [
          'Bal stoğu',
          'Ballı/polenli',
          'Yavru',
          'Yavru',
          'Ballı/polenli',
          'Bal stoğu'
        ];
      case 7:
        return const [
          'Bal stoğu',
          'Ballı/polenli',
          'Yavru',
          'Yavru',
          'Yavru',
          'Ballı/polenli',
          'Bal stoğu'
        ];
      case 8:
        return const [
          'Bal stoğu',
          'Ballı/polenli',
          'Yavru',
          'Yavru',
          'Yavru',
          'Yavrulu/polenli',
          'Ballı/polenli',
          'Bal stoğu'
        ];
      case 9:
        return const [
          'Bal stoğu',
          'Ballı/polenli',
          'Yavru',
          'Yavru',
          'Yavru',
          'Yavru',
          'Yavrulu/polenli',
          'Ballı/polenli',
          'Bal stoğu'
        ];
      default:
        return const [
          'Bal stoğu',
          'Ballı/polenli',
          'Yavru',
          'Yavru',
          'Yavru',
          'Yavru',
          'Yavrulu/polenli',
          'Yavrulu/polenli',
          'Ballı/polenli',
          'Bal stoğu'
        ];
    }
  }

  static String _citaTipLocalize(String tip, AppLocalizations l) {
    switch (tip) {
      case 'Yavru/stok': return l.biyolCitaYavruStok;
      case 'Ballı/polenli': return l.biyolCitaBalliPolenli;
      case 'Bal stoğu': return l.biyolCitaBalStogu;
      case 'Yavru/polenli': return l.biyolCitaYavruPolenli;
      case 'Yavru': return l.biyolCitaYavru;
      case 'Yavrulu/polenli': return l.biyolCitaYavruluPolenli;
      case 'Yavru/stok geçiş alanı': return l.biyolCitaYavruStokGecis;
      case 'Ballı/polenli geçiş alanı': return l.biyolCitaBalliPolenliGecis;
      case 'Ballık / bal alanı': return l.biyolCitaBallikBal;
      case 'Ballık / aktivasyon sürecinde': return l.biyolCitaBallikAktivasyon;
      case 'Kapalı yavrulu çekim çıtası': return l.biyolCitaKapaliYavruluCekim;
      case 'Ballı/polenli çekim çıtası': return l.biyolCitaBalliPolenliCekim;
      default: return tip;
    }
  }

  static List<String> _yerlesimSatirlari(List<String> yerlesim, {AppLocalizations? l}) {
    return List<String>.generate(
      yerlesim.length,
      (i) => l != null
          ? l.biyolYerlesimSatiriFormat(i + 1, yerlesim[i])
          : '${i + 1}. çıta: ${yerlesim[i]}',
    );
  }

  static Map<String, dynamic> _kovanYerlesimiOlustur({
    required List<String> yerlesim,
    required bool suruplukVarMi,
    required bool suruplukKaldirildiMi,
    required int kuluclukKapasitesi,
    required bool katAtildi,
    required bool ucKatliKoloni,
    required int kuluclukCita,
    required int ballikCita,
    required String yavruBlok,
    required double islevselToplamCita,
    required double aktivasyonOrani,
    required int eklenenCita,
    required bool katReorganizasyonModu,
    AppLocalizations? l,
  }) {
    final List<int> tacPozisyonlari = _tacPozisyonlari(yavruBlok);

    double aktiflikHesapla(int globalNo) {
      return (islevselToplamCita - (globalNo - 1)).clamp(0.0, 1.0).toDouble();
    }

    Map<String, dynamic> citaMap({
      required String kat,
      required int no,
      required String tip,
      required double aktiflik,
      bool anaBolgesi = false,
      bool cekimGrubu = false,
    }) {
      return {
        'tur': 'cita',
        'kat': kat,
        'no': no,
        'tip': tip,
        'aktiflik': double.parse(aktiflik.clamp(0.0, 1.0).toStringAsFixed(2)),
        'aktivasyonSurecinde': aktiflik < 0.98,
        'anaBolgesi': anaBolgesi && aktiflik >= 0.5,
        'cekimGrubu': cekimGrubu,
      };
    }

    Map<String, dynamic> suruplukMap(String kat, int no) {
      return {
        'tur': 'surupluk',
        'kat': kat,
        'no': no,
        'tip': l?.biyolCitaSurupluk ?? 'Şurupluk',
        'aktiflik': 1.0,
        'aktivasyonSurecinde': false,
        'anaBolgesi': false,
        'cekimGrubu': false,
      };
    }

    // Görsel dizilim fiziksel çıta sayısına göre okunur. İşlevsel çıta sayısı
    // biyolojik kapasite hesabında kalır; fakat yeni verilen petek ekranda
    // "sonda yavru" gibi gösterilmez. Dış stok kalkanı korunur, yavru bloğu
    // merkezde kalır, yeni petek kendi hedef pozisyonunun rengiyle dolar.
    final List<String> fizikselAltYerlesim = _yerlesimDizilimi(kuluclukCita);

    String fizikselAltTipBelirle(int no) {
      final int indeks = no - 1;
      if (indeks >= 0 && indeks < fizikselAltYerlesim.length) {
        return fizikselAltYerlesim[indeks];
      }
      if (no <= kuluclukKapasitesi) {
        return 'Ballı/polenli geçiş alanı';
      }
      return 'Ballık / bal alanı';
    }

    String aktivasyonHedefTipi(int no, int altCitaSayisi) {
      if (altCitaSayisi <= 1) return l != null ? _citaTipLocalize('Yavru/stok geçiş alanı', l) : 'Yavru/stok geçiş alanı';
      if (no == 1 || no == altCitaSayisi) return l != null ? _citaTipLocalize('Bal stoğu', l) : 'Bal stoğu';
      final String fizikselTip = fizikselAltTipBelirle(no);
      final String t = fizikselTip.toLowerCase();
      if (t.contains('yavru') && !t.contains('polen')) {
        return l != null ? _citaTipLocalize('Ballı/polenli geçiş alanı', l) : 'Ballı/polenli geçiş alanı';
      }
      return l != null ? _citaTipLocalize(fizikselTip, l) : fizikselTip;
    }

    final altKat = <Map<String, dynamic>>[];
    final ustKat = <Map<String, dynamic>>[];
    final ucuncuKat = <Map<String, dynamic>>[];

    // 3 katlı kolonide ballık çıtalar iki kata bölünür:
    // 2. kat (ustKat): ilk 10 çıta, 3. kat (ucuncuKat): geri kalanlar
    const int ikincKatKapasitesi = 10;
    final int ustKatCita = ucKatliKoloni
        ? math.min(ballikCita, ikincKatKapasitesi)
        : ballikCita;
    final int ucuncuKatCita = ucKatliKoloni
        ? math.max(0, ballikCita - ikincKatKapasitesi)
        : 0;

    if (!katAtildi) {
      if (suruplukVarMi && !suruplukKaldirildiMi) {
        altKat.add(suruplukMap('alt', 0));
      }
      for (int no = 1; no <= kuluclukCita; no++) {
        final aktiflik = aktiflikHesapla(no);
        altKat.add(citaMap(
          kat: 'alt',
          no: no,
          tip: l != null ? _citaTipLocalize(fizikselAltTipBelirle(no), l) : fizikselAltTipBelirle(no),
          aktiflik: aktiflik,
          anaBolgesi: tacPozisyonlari.contains(no),
        ));
      }
    } else if (katReorganizasyonModu) {
      final int toplamFizikselCita = kuluclukCita + ballikCita;
      final int tamUstCitaSayisi = math.min(
        toplamFizikselCita,
        math.max(2, ballikCita),
      );
      // 3 katlı kolonide üst kat ikincKatKapasitesi ile sınırlanır; fazlası 3. kata alınır.
      final int ustCitaSayisi = ucKatliKoloni
          ? math.min(tamUstCitaSayisi, ikincKatKapasitesi)
          : tamUstCitaSayisi;
      final int ucuncuKatCitaReorg = ucKatliKoloni
          ? math.max(0, tamUstCitaSayisi - ikincKatKapasitesi)
          : 0;
      final int altCitaSayisi = math.min(
        kuluclukKapasitesi,
        math.max(0, toplamFizikselCita - tamUstCitaSayisi),
      );
      final int yeniAltPetekSayisi = math.min(
        eklenenCita > 0 ? eklenenCita : 3,
        math.max(0, altCitaSayisi),
      );
      final List<int> tercihliBosPozisyonlar = <int>[2, 7, 9, 8, 10];
      final Set<int> aktivasyonPozisyonlari = <int>{};
      for (final pozisyon in tercihliBosPozisyonlar) {
        if (pozisyon <= altCitaSayisi) {
          aktivasyonPozisyonlari.add(pozisyon);
        }
        if (aktivasyonPozisyonlari.length >= yeniAltPetekSayisi) {
          break;
        }
      }

      final double yeniPetekAktiflik = aktivasyonOrani.clamp(0.05, 0.95).toDouble();

      for (int no = 1; no <= altCitaSayisi; no++) {
        final bool yeniPetek = aktivasyonPozisyonlari.contains(no);
        altKat.add(citaMap(
          kat: 'alt',
          no: no,
          tip: yeniPetek
              ? '${aktivasyonHedefTipi(no, altCitaSayisi)} / ${l?.biyolCitaYeniPetekAktivasyon ?? 'yeni petek aktivasyonu'}'
              : l != null ? _citaTipLocalize(fizikselAltTipBelirle(no), l) : fizikselAltTipBelirle(no),
          aktiflik: yeniPetek ? yeniPetekAktiflik : 1.0,
          anaBolgesi: !yeniPetek && tacPozisyonlari.contains(no),
        ));
      }

      if (suruplukVarMi && !suruplukKaldirildiMi) {
        ustKat.add(suruplukMap('ust', 0));
      }

      if (ustCitaSayisi >= 1) {
        ustKat.add(citaMap(
          kat: 'ust',
          no: kuluclukKapasitesi + 1,
          tip: l != null ? _citaTipLocalize('Kapalı yavrulu çekim çıtası', l) : 'Kapalı yavrulu çekim çıtası',
          aktiflik: 1.0,
          cekimGrubu: true,
        ));
      }
      if (ustCitaSayisi >= 2) {
        ustKat.add(citaMap(
          kat: 'ust',
          no: kuluclukKapasitesi + 2,
          tip: l != null ? _citaTipLocalize('Ballı/polenli çekim çıtası', l) : 'Ballı/polenli çekim çıtası',
          aktiflik: 1.0,
          cekimGrubu: true,
        ));
      }
      for (int i = 2; i < ustCitaSayisi; i++) {
        final int globalNo = kuluclukKapasitesi + 1 + i;
        final aktiflik = aktiflikHesapla(globalNo);
        ustKat.add(citaMap(
          kat: 'ust',
          no: globalNo,
          tip: aktiflik >= 0.98
              ? l != null ? _citaTipLocalize('Ballık / bal alanı', l) : 'Ballık / bal alanı'
              : l != null ? _citaTipLocalize('Ballık / aktivasyon sürecinde', l) : 'Ballık / aktivasyon sürecinde',
          aktiflik: aktiflik,
        ));
      }

      for (int i = 0; i < ucuncuKatCitaReorg; i++) {
        final int globalNo = kuluclukKapasitesi + ikincKatKapasitesi + 1 + i;
        final aktiflik = aktiflikHesapla(globalNo);
        ucuncuKat.add(citaMap(
          kat: 'ucuncu',
          no: globalNo,
          tip: aktiflik >= 0.98
              ? l != null ? _citaTipLocalize('Ballık / bal alanı', l) : 'Ballık / bal alanı'
              : l != null ? _citaTipLocalize('Ballık / aktivasyon sürecinde', l) : 'Ballık / aktivasyon sürecinde',
          aktiflik: aktiflik,
        ));
      }
    } else {
      for (int no = 1; no <= kuluclukKapasitesi; no++) {
        final aktiflik = aktiflikHesapla(no);
        altKat.add(citaMap(
          kat: 'alt',
          no: no,
          tip: l != null ? _citaTipLocalize(fizikselAltTipBelirle(no), l) : fizikselAltTipBelirle(no),
          aktiflik: aktiflik,
          anaBolgesi: tacPozisyonlari.contains(no),
        ));
      }

      if (suruplukVarMi && !suruplukKaldirildiMi) {
        ustKat.add(suruplukMap('ust', 0));
      }

      for (int i = 0; i < ustKatCita; i++) {
        final int globalNo = kuluclukKapasitesi + 1 + i;
        final aktiflik = aktiflikHesapla(globalNo);
        ustKat.add(citaMap(
          kat: 'ust',
          no: globalNo,
          tip: aktiflik >= 0.98
              ? l != null ? _citaTipLocalize('Ballık / bal alanı', l) : 'Ballık / bal alanı'
              : l != null ? _citaTipLocalize('Ballık / aktivasyon sürecinde', l) : 'Ballık / aktivasyon sürecinde',
          aktiflik: aktiflik,
        ));
      }

      // 3. kat çıtaları
      for (int i = 0; i < ucuncuKatCita; i++) {
        final int globalNo = kuluclukKapasitesi + ikincKatKapasitesi + 1 + i;
        final aktiflik = aktiflikHesapla(globalNo);
        ucuncuKat.add(citaMap(
          kat: 'ucuncu',
          no: globalNo,
          tip: aktiflik >= 0.98
              ? l != null ? _citaTipLocalize('Ballık / bal alanı', l) : 'Ballık / bal alanı'
              : l != null ? _citaTipLocalize('Ballık / aktivasyon sürecinde', l) : 'Ballık / aktivasyon sürecinde',
          aktiflik: aktiflik,
        ));
      }
    }

    final String suruplukKonumMetni;
    if (!suruplukVarMi) {
      suruplukKonumMetni = '';
    } else if (suruplukKaldirildiMi) {
      suruplukKonumMetni =
      '';
    } else if (katAtildi && katReorganizasyonModu) {
      suruplukKonumMetni =
      '';
    } else if (katAtildi) {
      suruplukKonumMetni =
      '';
    } else {
      suruplukKonumMetni = '';
    }

    return {
      'altKatYerlesim': altKat,
      'ustKatYerlesim': ustKat,
      'ucuncuKatYerlesim': ucuncuKat,
      'tacPozisyonlari': tacPozisyonlari,
      'suruplukKonumMetni': suruplukKonumMetni,
      'not': katAtildi && katReorganizasyonModu
          ? l?.biyolKovanNotuKatGecisi ?? 'Bu bir biyolojik dizilim projeksiyonudur: kat geçişinde üst kata işlevli çekim grubu, alt kuluçkalığa ise yeni verilen peteklerin aktivasyon süreci modellenir.'
          : l?.biyolKovanNotuGenel ?? 'Dolu renkler işlevsel çıtayı; boş çerçeve ve alttan yukarı günlük dolum ise kovanda bulunan fakat biyolojik aktivasyonu süren yeni hacmi gösterir.',
    };
  }

  static List<int> _tacPozisyonlari(String yavruBlok) {
    final sayilar = RegExp(r'\d+')
        .allMatches(yavruBlok)
        .map((e) {
      return int.tryParse(e.group(0) ?? '') ?? 0;
    })
        .where((e) => e > 0)
        .toList(growable: false);

    if (sayilar.isEmpty) return const <int>[];
    final int bas = sayilar.first;
    final int bit = sayilar.length >= 2 ? sayilar.last : sayilar.first;
    final int merkez = ((bas + bit) / 2).round();
    final sonuc = <int>{merkez};
    if (bit - bas >= 3) {
      sonuc.add((merkez - 1).clamp(bas, bit).toInt());
      sonuc.add((merkez + 1).clamp(bas, bit).toInt());
    }
    return sonuc.toList()..sort();
  }

  static String _yavruBlokAraligi(List<String> yerlesim, {AppLocalizations? l}) {
    final indeksler = <int>[];
    for (int i = 0; i < yerlesim.length; i++) {
      if (yerlesim[i].toLowerCase().contains('yavru')) indeksler.add(i + 1);
    }
    final belirsiz = l?.biyolYavruBlokBelirsiz ?? 'Belirsiz';
    if (indeksler.isEmpty) return belirsiz;
    if (indeksler.length == 1) {
      return l != null ? l.biyolYavruBlok1Cita(indeksler.first) : '${indeksler.first}. çıta';
    }
    return l != null
        ? l.biyolYavruBlokAralik(indeksler.first, indeksler.last)
        : '${indeksler.first}–${indeksler.last}. çıtalar';
  }

  static String _anaBolgesiMetni(int kuluclukCita, String yavruBlok, {AppLocalizations? l}) {
    final belirsiz = l?.biyolYavruBlokBelirsiz ?? 'Belirsiz';
    if (kuluclukCita <= 0) return belirsiz;
    if (yavruBlok != belirsiz && yavruBlok != 'Belirsiz') {
      return l != null ? l.biyolAnaBolgeYavruBlok(yavruBlok) : '$yavruBlok çevresi';
    }
    if (kuluclukCita <= 3) return l?.biyolAnaBolgeMerkez ?? 'Merkez yavru çıtası';
    final int sol = (kuluclukCita / 2).floor();
    final int sag = math.min(kuluclukCita, sol + 1);
    return l != null
        ? l.biyolAnaBolgeAralik(sol, sag)
        : '$sol–$sag. çıtalar çevresi';
  }

  static String _gelisimAlaniMetni(List<String> yerlesim, int kapasite, {AppLocalizations? l}) {
    final belirsiz = l?.biyolYavruBlokBelirsiz ?? 'Belirsiz';
    if (yerlesim.isEmpty) return belirsiz;
    if (yerlesim.length >= kapasite) return '';
    final adaylar = <int>[];
    for (int i = 0; i < yerlesim.length; i++) {
      final s = yerlesim[i].toLowerCase();
      if (s.contains('polen') || s.contains('bal') || s.contains('pollen') || s.contains('honey')) {
        adaylar.add(i + 1);
      }
    }
    if (adaylar.isEmpty) {
      return l?.biyolGelisimAlaniAcik ?? 'Gelişim alanı merkez dışındaki boş/kabarmış petekle açılmalı.';
    }
    return l != null
        ? l.biyolGelisimAlaniMetin(adaylar.join(', '))
        : '${adaylar.join(', ')}. çıtaların dışından kontrollü genişletme yapılabilir.';
  }

  static List<int> _hasatAdayCitalari({
    required int kuluclukCita,
    required int kuluclukKapasitesi,
    required int ballikCita,
    required int balliCita,
  }) {
    if (balliCita <= 0 && ballikCita <= 0) return <int>[];

    // Katlı sistemde hasat önceliği ballıktır. Kuluçkalık koruma alanı kabul edilir.
    if (ballikCita > 0) {
      final int bas = kuluclukKapasitesi + 1;
      return List<int>.generate(ballikCita, (i) => bas + i);
    }

    // Kuluçkalıkta hasat ancak dış stok güvenliği varsa düşünülür.
    if (kuluclukCita <= 7) return <int>[];
    if (kuluclukCita == 8) return balliCita >= 1 ? <int>[8] : <int>[];
    if (kuluclukCita == 9) return balliCita >= 1 ? <int>[8, 9] : <int>[];
    return balliCita >= 1 ? <int>[9, 10] : <int>[];
  }

  static Map<String, String> _hasatGuvenligi({
    required int kuluclukCita,
    required int kuluclukKapasitesi,
    required int ballikCita,
    required int balliCita,
    required int hasatAdaySayisi,
    AppLocalizations? l,
  }) {
    if (kuluclukCita <= 0) {
      return {
        'seviye': 'veri_yok',
        'mesaj': l?.biyolHasatVeriYokMesaj ?? 'Hasat yorumu için çıta ve bal verisi gerekir.',
        'kural': l?.biyolHasatVeriYokKural ?? 'Ölçüm yoksa hasat kararı üretme.',
      };
    }

    if (ballikCita > 0) {
      return {
        'seviye': hasatAdaySayisi > 0 ? 'ballik_oncelikli' : 'izle',
        'mesaj': l?.biyolHasatBallikMesaj ?? 'Katlı sistemde hasat önceliği ballıktadır; kuluçkalık koruma alanı kabul edilir.',
        'kural': l?.biyolHasatBallikKural ?? 'Ballık hasadı yalnızca sırlı, yavrusuz ve olgun çıtalarda düşünülür.',
      };
    }

    if (kuluclukCita <= 7) {
      return {
        'seviye': 'onerilmez',
        'mesaj': l?.biyolHasatOnerilmezMesaj ?? '7 çıta ve altındaki kolonide hasat önerilmez; kuluçkalık güvenliği korunmalıdır.',
        'kural': l?.biyolHasatOnerilmezKural ?? 'Koloni hasatla 7 çıta altına düşürülmez.',
      };
    }

    if (kuluclukCita == 8) {
      return {
        'seviye': 'sinirli',
        'mesaj': l?.biyolHasat8CitaMesaj ?? '8 çıtalı kolonide yalnızca dış stok çıtası sırlı ve yavrusuzsa sınırlı hasat düşünülebilir.',
        'kural': l?.biyolHasat8CitaKural ?? '8. çıta dış stok bölgesi değilse alınmaz.',
      };
    }

    if (kuluclukCita == 9) {
      return {
        'seviye': 'kontrollu',
        'mesaj': l?.biyolHasat9CitaMesaj ?? '9 çıtalı kolonide 8–9. çıtalar dış stok bölgesi olarak kontrol edilebilir.',
        'kural': l?.biyolHasat9CitaKural ?? 'Yavru/polen alanı bozulmaz; yalnızca sırlı dış bal alınır.',
      };
    }

    return {
      'seviye': 'uygun_kontrol',
      'mesaj': l?.biyolHasat10CitaMesaj ?? '10 çıtalı kuluçkalıkta 9–10. çıtalar dış stok bölgesi olarak kontrol edilebilir.',
      'kural': l?.biyolHasat10CitaKural ?? 'Kuluçkalık stok güvenliği ve yavru bloğu korunmadan hasat yapılmaz.',
    };
  }

  static String _hasatAdayMetni(List<int> adaylar, {AppLocalizations? l}) {
    if (adaylar.isEmpty) return '';
    final metin = adaylar.join(', ');
    return l != null
        ? l.biyolHasatAdayMetni(metin)
        : '$metin sayılı çıtalar yavrusuz ve sırlıysa hasat için değerlendirilebilir.';
  }

  static Map<String, dynamic> _kabiliyetOlustur({
    required Map<String, dynamic> demografi,
    required int kuluclukCita,
    required int ballikCita,
    required int balliCita,
    required double islevselToplamCita,
    required int islevselUretimCita,
    required double aktivasyonOrani,
    required bool riskliSisirme,
    required bool uretimGuvenliMi,
    AppLocalizations? l,
    required bool balAkimiAktif,
    Map<String, dynamic>? sezonBiyoloji,
    required double gunlukMomentum,
    required String momentumEtiketi,
    required String yavruDuzeni,
  }) {
    final int toplam = _toInt(demografi['toplamAri']);
    final double biyolojikGucCita = islevselToplamCita > 0
        ? islevselToplamCita
        : (islevselUretimCita > 0
        ? islevselUretimCita.toDouble()
        : (kuluclukCita + ballikCita).toDouble());
    final double koloniGucuKatsayisi =
    _dokumanKoloniGucuKatsayisi(biyolojikGucCita);
    final double gencIsciKatsayisi = _dokumanGencIsciKatsayisi(
      demografi['gencIsciOran'],
    );
    final Map<String, dynamic> sezonBiyolojiMap = sezonBiyoloji == null
        ? const <String, dynamic>{}
        : Map<String, dynamic>.from(sezonBiyoloji);
    final double sezonKatsayisiHam = _toDouble(sezonBiyolojiMap['aktivasyonKatsayisi']);
    final double sezonKatsayisi = sezonKatsayisiHam > 0
        ? sezonKatsayisiHam.clamp(0.20, 1.50).toDouble()
        : (balAkimiAktif ? 1.50 : 1.00);
    final double riskFreni = _dokumanRiskFreni(
      aktivasyonOrani: aktivasyonOrani,
      riskliSisirme: riskliSisirme,
      uretimGuvenliMi: uretimGuvenliMi,
      yavruDuzeni: yavruDuzeni,
      kuluclukCita: kuluclukCita,
    );

    int scoreFrom(dynamic oran, double hedef) {
      final o = _toDouble(oran);
      return ((o / hedef) * 100).round().clamp(0, 100).toInt();
    }

    int sahaPuaniUygula(
        int bazPuan, {
          required double gucEtkisi,
          double gencIsciEtkisi = 0.0,
          double sezonEtkisi = 0.0,
          double riskEtkisi = 0.0,
        }) {
      final double guc = 1 + ((koloniGucuKatsayisi - 1) * gucEtkisi);
      final double genc = 1 + ((gencIsciKatsayisi - 1) * gencIsciEtkisi);
      final double sezon = 1 + ((sezonKatsayisi - 1) * sezonEtkisi);
      final double risk = 1 - ((1 - riskFreni) * riskEtkisi);
      return (bazPuan * guc * genc * sezon * risk)
          .round()
          .clamp(0, 100)
          .toInt();
    }

    final String duzen = yavruDuzeni.toLowerCase();
    final int petekBaz = (scoreFrom(demografi['petekOrucuOran'], 18) +
        (scoreFrom(demografi['gencIsciOran'], 48) * 0.15).round() +
        (gunlukMomentum >= 0.12 ? 12 : 0) +
        (duzen.contains('blok') ? 4 : 0))
        .clamp(0, 100)
        .toInt();
    final int yavruBakimBaz = (scoreFrom(demografi['bakiciOran'], 30) +
        (scoreFrom(demografi['gencIsciOran'], 48) * 0.10).round() +
        (duzen.contains('blok') ? 10 : 0))
        .clamp(0, 100)
        .toInt();
    final int nektarBaz = (scoreFrom(demografi['tarlaciOran'], 40) +
        (ballikCita > 0 ? 10 : 0) +
        (toplam >= 16000 ? 8 : 0))
        .clamp(0, 100)
        .toInt();

    final petek = sahaPuaniUygula(
      petekBaz,
      gucEtkisi: 0.55,
      gencIsciEtkisi: 0.35,
      sezonEtkisi: 0.35,
      riskEtkisi: 0.65,
    );
    final yavruBakim = sahaPuaniUygula(
      yavruBakimBaz,
      gucEtkisi: 0.35,
      gencIsciEtkisi: 0.45,
      sezonEtkisi: 0.15,
      riskEtkisi: 0.50,
    );
    final nektar = sahaPuaniUygula(
      nektarBaz,
      gucEtkisi: 0.60,
      gencIsciEtkisi: 0.10,
      sezonEtkisi: 0.55,
      riskEtkisi: 0.35,
    );
    final balIslemeBaz = ((scoreFrom(demografi['icIsciOran'], 20) + nektar) / 2)
        .round()
        .clamp(0, 100)
        .toInt();
    final balIsleme = sahaPuaniUygula(
      balIslemeBaz,
      gucEtkisi: 0.50,
      gencIsciEtkisi: 0.25,
      sezonEtkisi: 0.45,
      riskEtkisi: 0.45,
    );
    final kisBaz = ((toplam / 18000) * 55 +
        (balliCita * 8) +
        (kuluclukCita >= 6 ? 15 : 0))
        .round()
        .clamp(0, 100)
        .toInt();
    final kis = sahaPuaniUygula(
      kisBaz,
      gucEtkisi: 0.40,
      gencIsciEtkisi: 0.10,
      sezonEtkisi: 0.0,
      riskEtkisi: 0.30,
    );
    final ciftlesmeBaz =
    (scoreFrom(demografi['erkekOran'], 5) + (kuluclukCita >= 7 ? 10 : 0))
        .clamp(0, 100)
        .toInt();
    final ciftlesme = sahaPuaniUygula(
      ciftlesmeBaz,
      gucEtkisi: 0.25,
      gencIsciEtkisi: 0.0,
      sezonEtkisi: 0.0,
      riskEtkisi: 0.15,
    );

    return {
      'petekOrmePuani': petek,
      'yavruBakimPuani': yavruBakim,
      'nektarToplamaPuani': nektar,
      'balIslemePuani': balIsleme,
      'kisDayanimPuani': kis,
      'ciftlesmeDestegiPuani': ciftlesme,
      'petekOrmeDurumu': _kapasiteDurumu(petek, l: l),
      'yavruBakimDurumu': _kapasiteDurumu(yavruBakim, l: l),
      'nektarToplamaDurumu': _kapasiteDurumu(nektar, l: l),
      'balIslemeDurumu': _kapasiteDurumu(balIsleme, l: l),
      'kisDayanimDurumu': _kapasiteDurumu(kis, l: l),
      'biyolojikGucCita': _yuvarla(biyolojikGucCita),
      'koloniGucuKatsayisi': _yuvarla(koloniGucuKatsayisi),
      'gencIsciKatsayisi': _yuvarla(gencIsciKatsayisi),
      'sezonKatsayisi': _yuvarla(sezonKatsayisi),
      'riskFreni': _yuvarla(riskFreni),
      'genisletmeGuvenligi': _genisletmeGuvenligi(
        petek: petek,
        yavru: yavruBakim,
        kuluclukCita: kuluclukCita,
        ballikCita: ballikCita,
        l: l,
      ),
      'balAkimiKapasitesi': _balAkimiKapasitesi(
        nektar: nektar,
        balIsleme: balIsleme,
        ballikCita: ballikCita,
        l: l,
      ),
      'bakiciDengesi': _bakiciDengesi(
        yavru: yavruBakim,
        petek: petek,
        l: l,
      ),
      'hamPetekOnerisi': _hamPetekOnerisi(petek, kuluclukCita, l: l),
      'beslemeOnerisi': _beslemeOnerisi(petek, yavruBakim, nektar, gunlukMomentum, l: l),
      'temelSahaOnerisi': _temelSahaOnerisi(
        petek: petek,
        yavru: yavruBakim,
        nektar: nektar,
        balIsleme: balIsleme,
        kis: kis,
        kuluclukCita: kuluclukCita,
        ballikCita: ballikCita,
        l: l,
      ),
      'ozet': _kabiliyetOzeti(petek, yavruBakim, nektar, balIsleme, kis, l: l),
    };
  }


  static Map<String, dynamic> _biyolojikProjeksiyonOlustur({
    required Map<String, dynamic> demografi,
    required Map<String, dynamic> kabiliyet,
    required int kuluclukCita,
    required int ballikCita,
    required int balliCita,
    required double islevselToplamCita,
    required int islevselUretimCita,
    required double aktivasyonOrani,
    required bool riskliSisirme,
    required bool uretimGuvenliMi,
    required bool balAkimiAktif,
    Map<String, dynamic>? sezonBiyoloji,
    required double gunlukMomentum,
    required String momentumEtiketi,
    required bool yavruYokMu,
    required Map<String, dynamic> yavrusuzlukAnalizi,
    required int tahminiYavruCita,
    required int tahminiStokCita,
    required int hasatEdilebilirCita,
    required String koloniSinifi,
    AppLocalizations? l,
  }) {
    final double biyolojikGucCita = islevselToplamCita > 0
        ? islevselToplamCita
        : (islevselUretimCita > 0
        ? islevselUretimCita.toDouble()
        : (kuluclukCita + ballikCita).toDouble());
    final double koloniGucuKatsayisi =
    _dokumanKoloniGucuKatsayisi(biyolojikGucCita);
    final double gencIsciKatsayisi = _dokumanGencIsciKatsayisi(
      demografi['gencIsciOran'],
    );
    final double riskFreni = _toDouble(kabiliyet['riskFreni']) > 0
        ? _toDouble(kabiliyet['riskFreni'])
        : _dokumanRiskFreni(
      aktivasyonOrani: aktivasyonOrani,
      riskliSisirme: riskliSisirme,
      uretimGuvenliMi: uretimGuvenliMi,
      yavruDuzeni: '',
      kuluclukCita: kuluclukCita,
    );

    final int petek = _toInt(kabiliyet['petekOrmePuani']);
    final int yavruBakim = _toInt(kabiliyet['yavruBakimPuani']);
    final int nektar = _toInt(kabiliyet['nektarToplamaPuani']);
    final int balIsleme = _toInt(kabiliyet['balIslemePuani']);
    final int kisDayanim = _toInt(kabiliyet['kisDayanimPuani']);
    final int gencIsciAri = _toInt(demografi['gencIsciAri']);
    final int tarlaciAri = _toInt(demografi['tarlaciAri']);
    final int toplamAri = _toInt(demografi['toplamAri']);
    final String geriDonus =
    (yavrusuzlukAnalizi['geriDonusKapasitesi'] ?? '').toString();
    final String cokusRiskiMevcut =
    (yavrusuzlukAnalizi['biyolojikCokusRiski'] ?? '').toString();
    final bool kaynakDegerli = yavrusuzlukAnalizi['kaynakHarcamayaDegerMi'] != false;

    int sinirla(num deger) => deger.round().clamp(0, 100).toInt();

    final int isGucuSkoru = sinirla(
      (petek * 0.22) +
          (yavruBakim * 0.26) +
          (nektar * 0.18) +
          (balIsleme * 0.18) +
          (kisDayanim * 0.16),
    );
    final int gencIsciSkoru = sinirla(
      50 + ((gencIsciKatsayisi - 1.0) * 85) + (gencIsciAri / 500),
    );
    final int biyolojikGucSkoru = sinirla(
      (biyolojikGucCita / 10.0) * 75 + ((koloniGucuKatsayisi - 1.0) * 35),
    );
    final int momentumSkoru = sinirla(
      50 + (gunlukMomentum * 210),
    );
    final int aktivasyonSkoru = sinirla(aktivasyonOrani * 100);
    final int riskSkoru = sinirla(riskFreni * 100);
    final int yavruDestekSkoru = yavruYokMu
        ? 18
        : sinirla(35 + (tahminiYavruCita * 9) + (yavruBakim * 0.25));

    int gelisimSkoru = sinirla(
      (isGucuSkoru * 0.24) +
          (biyolojikGucSkoru * 0.22) +
          (gencIsciSkoru * 0.18) +
          (momentumSkoru * 0.18) +
          (yavruDestekSkoru * 0.18),
    );
    int alanDoldurmaSkoru = sinirla(
      (aktivasyonSkoru * 0.45) +
          (petek * 0.20) +
          (biyolojikGucSkoru * 0.25) +
          (balAkimiAktif ? 10 : 0),
    );
    int toparlanmaSkoru = sinirla(
      (yavruBakim * 0.25) +
          (gencIsciSkoru * 0.20) +
          (momentumSkoru * 0.20) +
          (riskSkoru * 0.20) +
          (kaynakDegerli ? 15 : 0),
    );
    int cokusSkoru = sinirla(
      (100 - riskSkoru) * 0.32 +
          (yavruYokMu ? 28 : 0) +
          (gunlukMomentum < -0.02 ? 18 : 0) +
          (biyolojikGucCita <= 4 ? 14 : 0) +
          (aktivasyonOrani < 0.45 ? 10 : 0),
    );
    int savunmaSkoru = sinirla(
      100 -
          ((biyolojikGucCita <= 4 ? 28 : 0) +
              (riskliSisirme ? 18 : 0) +
              (aktivasyonOrani < 0.65 ? 12 : 0) +
              (tahminiStokCita <= 1 ? 10 : 0)),
    );
    int hasatSkoru = sinirla(
      (nektar * 0.28) +
          (balIsleme * 0.30) +
          (biyolojikGucSkoru * 0.18) +
          (balliCita * 6) +
          (hasatEdilebilirCita * 10) +
          (balAkimiAktif ? 12 : 0),
    );

    if (!uretimGuvenliMi) {
      gelisimSkoru = sinirla(gelisimSkoru - 8);
      alanDoldurmaSkoru = sinirla(alanDoldurmaSkoru - 10);
      hasatSkoru = sinirla(hasatSkoru - 8);
    }
    if (cokusRiskiMevcut == 'yuksek') cokusSkoru = math.max(cokusSkoru, 70);
    if (cokusRiskiMevcut == 'kritik') cokusSkoru = math.max(cokusSkoru, 86);
    if (geriDonus == 'iyi') toparlanmaSkoru = math.max(toparlanmaSkoru, 70);
    if (geriDonus == 'sinirli') toparlanmaSkoru = math.max(toparlanmaSkoru, 52);
    if (geriDonus == 'dusuk' || geriDonus == 'kritik') {
      toparlanmaSkoru = math.min(toparlanmaSkoru, 45);
    }

    String seviye(int skor) {
      if (skor >= 75) return l?.biyolSeviyeYuksek ?? 'yüksek';
      if (skor >= 55) return l?.biyolSeviyeOrta ?? 'orta';
      if (skor >= 40) return l?.biyolSeviyeSinirli ?? 'sınırlı';
      return l?.biyolSeviyeDusuk ?? 'düşük';
    }

    String riskSeviyesi(int skor) {
      if (skor >= 80) return l?.biyolRiskKritik ?? 'kritik';
      if (skor >= 60) return l?.biyolRiskYuksek ?? 'yüksek';
      if (skor >= 35) return l?.biyolRiskOrta ?? 'orta';
      return l?.biyolRiskDusuk ?? 'düşük';
    }

    final String gelisimYonu = gelisimSkoru >= 72 && gunlukMomentum >= 0.02
        ? (l?.biyolGelisimGuclu ?? 'gelişim yönü güçlü')
        : (gelisimSkoru >= 55
        ? (l?.biyolGelisimDengeli ?? 'gelişim yönü dengeli')
        : (cokusSkoru >= 60
        ? (l?.biyolGelisimBaskili ?? 'gelişim baskılanıyor')
        : (l?.biyolGelisimSinirli ?? 'gelişim sınırlı')));
    final String uretimYonu = balAkimiAktif && hasatSkoru >= 65
        ? (l?.biyolUretimBalaYoneliyor ?? 'bala yöneliyor')
        : (yavruBakim >= nektar && tahminiYavruCita > 0
        ? (l?.biyolUretimYavruDuzeni ?? 'yavru düzenini güçlendiriyor')
        : (tahminiStokCita <= 1
        ? (l?.biyolUretimStokIhtiyac ?? 'stok desteğine ihtiyaç duyabilir')
        : (l?.biyolUretimDengeli ?? 'dengeli saha düzeninde')));
    final String biyolojikMomentum = momentumSkoru >= 72
        ? (l?.biyolMomentumIvmeleniyor ?? 'ivmeleniyor')
        : (momentumSkoru >= 52
        ? (l?.biyolMomentumDengede ?? 'dengede')
        : (momentumSkoru >= 38 ? (l?.biyolMomentumYavasliyor ?? 'yavaşlıyor') : (l?.biyolMomentumKiriliyor ?? 'kırılıyor')));
    final String alanBaskisi = alanDoldurmaSkoru >= 78
        ? (l?.biyolAlanBaskisiYuksek ?? 'alan baskısı yüksek')
        : (alanDoldurmaSkoru >= 58
        ? (l?.biyolAlanKullanimDengeli ?? 'alan kullanımı dengeli')
        : (l?.biyolAlanBosHacim ?? 'boş hacim taşıyor'));
    final String toparlanmaPotansiyeli = seviye(toparlanmaSkoru);
    final String cokusRiski = riskSeviyesi(cokusSkoru);
    final String savunmaKirganligi = savunmaSkoru >= 70
        ? (l?.biyolRiskDusuk ?? 'düşük')
        : (savunmaSkoru >= 50 ? (l?.biyolRiskOrta ?? 'orta') : (l?.biyolRiskYuksek ?? 'yüksek'));
    final String hasatEgilimi = hasatSkoru >= 75 && biyolojikGucCita >= 8
        ? (l?.biyolSeviyeYuksek ?? 'yüksek')
        : (hasatSkoru >= 55 && biyolojikGucCita >= 7 ? (l?.biyolSeviyeOrta ?? 'orta') : (l?.biyolSeviyeDusuk ?? 'düşük'));

    final int yediGunSkoru = sinirla(
      (isGucuSkoru * 0.28) +
          (yavruDestekSkoru * 0.22) +
          (momentumSkoru * 0.25) +
          (riskSkoru * 0.25),
    );
    final int ondortGunSkoru = sinirla(
      (yediGunSkoru * 0.55) +
          (toparlanmaSkoru * 0.20) +
          (aktivasyonSkoru * 0.15) +
          (biyolojikGucSkoru * 0.10),
    );

    String yonEtiketi(int skor) {
      if (skor >= 75) return l?.biyolYonOlumlu ?? 'olumlu güçlenme beklenir';
      if (skor >= 55) return l?.biyolYonKontrollu ?? 'kontrollü gelişim beklenir';
      if (skor >= 40) return l?.biyolYonTemkinli ?? 'temkinli izleme gerekir';
      return l?.biyolYonZayiflama ?? 'zayıflama riski izlenmeli';
    }

    String oncelikliRisk = '';
    if (cokusSkoru >= 70) {
      oncelikliRisk = l?.biyolOncelikliRiskCokus ?? 'biyolojik çöküş riski';
    } else if (riskliSisirme || aktivasyonOrani < 0.65) {
      oncelikliRisk = l?.biyolOncelikliRiskHacim ?? 'hacim aktivasyonu tamamlanmamış';
    } else if (yavruYokMu) {
      oncelikliRisk = l?.biyolOncelikliRiskYavru ?? 'yavru düzeni belirsiz';
    } else if (balAkimiAktif && hasatSkoru < 55) {
      oncelikliRisk = l?.biyolOncelikliRiskBalAkim ?? 'bal akımına üretim kapasitesi sınırlı';
    } else if (tahminiStokCita <= 1 && !balAkimiAktif) {
      oncelikliRisk = l?.biyolOncelikliRiskStok ?? 'stok güvenliği sınırlı';
    }

    final String sahaOzeti = oncelikliRisk.isNotEmpty
        ? (l != null ? l.biyolSahaOzetiRiskle(gelisimYonu, oncelikliRisk) : '$gelisimYonu; öncelikli risk: $oncelikliRisk.')
        : (l != null ? l.biyolSahaOzetiNormal(gelisimYonu, uretimYonu) : '$gelisimYonu; $uretimYonu.');

    return {
      'gelisimYonu': gelisimYonu,
      'uretimYonu': uretimYonu,
      'biyolojikMomentum': biyolojikMomentum,
      'alanBaskisi': alanBaskisi,
      'toparlanmaPotansiyeli': toparlanmaPotansiyeli,
      'cokusRiski': cokusRiski,
      'savunmaKirganligi': savunmaKirganligi,
      'hasatEgilimi': hasatEgilimi,
      'yediGunlukYon': yonEtiketi(yediGunSkoru),
      'ondortGunlukYon': yonEtiketi(ondortGunSkoru),
      'oncelikliRisk': oncelikliRisk,
      'sahaOzeti': sahaOzeti,
      'koloniSinifi': koloniSinifi,
      'isGucuSkoru': isGucuSkoru,
      'gencIsciSkoru': gencIsciSkoru,
      'biyolojikGucSkoru': biyolojikGucSkoru,
      'momentumSkoru': momentumSkoru,
      'aktivasyonSkoru': aktivasyonSkoru,
      'riskSkoru': riskSkoru,
      'yavruDestekSkoru': yavruDestekSkoru,
      'gelisimSkoru': gelisimSkoru,
      'alanDoldurmaSkoru': alanDoldurmaSkoru,
      'toparlanmaSkoru': toparlanmaSkoru,
      'cokusSkoru': cokusSkoru,
      'savunmaSkoru': savunmaSkoru,
      'hasatSkoru': hasatSkoru,
      'yediGunSkoru': yediGunSkoru,
      'ondortGunSkoru': ondortGunSkoru,
      'toplamAri': toplamAri,
      'gencIsciAri': gencIsciAri,
      'tarlaciAri': tarlaciAri,
      'dokumanReferansi': 'Projeksiyon = iş gücü + yavru desteği + pozitif trend - risk.',
    };
  }

  static double _dokumanKoloniGucuKatsayisi(double islevselCita) {
    if (islevselCita <= 2) return 0.45;
    if (islevselCita <= 4) return 0.70;
    if (islevselCita <= 6) return 1.00;
    if (islevselCita <= 8) return 1.20;
    if (islevselCita <= 10) return 1.35;
    return 1.45;
  }

  static double _dokumanGencIsciKatsayisi(dynamic gencIsciOran) {
    final double oran = _toDouble(gencIsciOran);
    if (oran < 35) return 0.70;
    if (oran >= 48) return 1.20;
    return 1.00;
  }

  static double _dokumanRiskFreni({
    required double aktivasyonOrani,
    required bool riskliSisirme,
    required bool uretimGuvenliMi,
    required String yavruDuzeni,
    required int kuluclukCita,
  }) {
    final String duzen = yavruDuzeni.toLowerCase();
    if (riskliSisirme || aktivasyonOrani < 0.35) return 0.55;
    if (!uretimGuvenliMi || duzen.contains('dağınık') || duzen.contains('daginik') || duzen.contains('kambur')) {
      return 0.75;
    }
    if (kuluclukCita <= 4 || aktivasyonOrani < 0.70) return 0.90;
    return 1.00;
  }

  static String _kapasiteDurumu(int puan, {AppLocalizations? l}) {
    if (puan >= 75) return l?.biyolKapasiteGuclu ?? 'güçlü';
    if (puan >= 55) return l?.biyolKapasiteOrta ?? 'orta';
    if (puan >= 40) return l?.biyolKapasiteSinirli ?? 'sınırlı';
    return l?.biyolKapasiteZayif ?? 'zayıf';
  }

  static String _genisletmeGuvenligi({
    required int petek,
    required int yavru,
    required int kuluclukCita,
    required int ballikCita,
    AppLocalizations? l,
  }) {
    if (kuluclukCita < 5) {
      return l?.biyolGenisletmeErken ?? 'genişletme erken; önce sıkı düzen ve yavru ısısı korunmalı';
    }
    if (petek >= 75 && yavru >= 60) {
      return ballikCita > 0
          ? (l?.biyolGenisletmeGucluBallik ?? 'ballık yönetimi sürdürülebilir; yavru bloğu kesilmeden alan verilebilir')
          : (l?.biyolGenisletmeGuclu ?? 'kontrollü genişletme güvenli görünüyor');
    }
    if (petek >= 55 && yavru >= 55) {
      return l?.biyolGenisletmeSinirli ?? 'sınırlı genişletme yapılabilir; kabarmış petek ham petekten daha güvenli olabilir';
    }
    if (yavru >= 70 && petek < 55) {
      return l?.biyolGenisletmeYavruBaski ?? 'yavru bakım baskısı var; ham petek yerine kabarmış petek tercih edilmeli';
    }
    return l?.biyolGenisletmeRiskli ?? 'aşırı genişletme riskli; önce iş gücü ve stok dengesi izlenmeli';
  }

  static String _balAkimiKapasitesi({
    required int nektar,
    required int balIsleme,
    required int ballikCita,
    AppLocalizations? l,
  }) {
    if (nektar >= 75 && balIsleme >= 65) {
      return ballikCita > 0
          ? (l?.biyolBalAkimiGucluBallik ?? 'bal akımı güçlü değerlendirilebilir; ballıkta sırlanma takibi öne alınmalı')
          : (l?.biyolBalAkimiGuclu ?? 'nektar kapasitesi güçlü; sıkışma başlamadan kat hazırlığı izlenmeli');
    }
    if (nektar >= 55 && balIsleme >= 55) {
      return l?.biyolBalAkimiSinirli ?? 'bal akımı sınırlı değerlendirilebilir; alan ve sırlanma birlikte izlenmeli';
    }
    return l?.biyolBalAkimiZayif ?? 'bal akımı kapasitesi sınırlı; üretimden önce koloni organizasyonu güçlenmeli';
  }

  static String _bakiciDengesi({
    required int yavru,
    required int petek,
    AppLocalizations? l,
  }) {
    if (yavru >= 75 && petek >= 60) {
      return l?.biyolBakiciGuclu ?? 'bakıcı arı dengesi güçlü; yavru alanı korunarak büyütme yapılabilir';
    }
    if (yavru >= 70 && petek < 55) {
      return l?.biyolBakiciPetekSinirli ?? 'bakıcı kapasitesi var fakat petek örme sınırlı; kabarmış petek daha güvenli';
    }
    if (yavru < 50) {
      return l?.biyolBakiciSinirli ?? 'bakıcı kapasitesi sınırlı; aşırı yavru yükü veya sert genişletme risklidir';
    }
    return l?.biyolBakiciOrta ?? 'bakıcı dengesi orta bantta; genişletme kontrollü yapılmalı';
  }

  static String _hamPetekOnerisi(int petekPuani, int kuluclukCita, {AppLocalizations? l}) {
    if (petekPuani >= 75 && kuluclukCita >= 5) {
      return l?.biyolHamPetekGuclu ?? 'Yeterli genç işçi kapasitesi görünüyor; ham petek verilecekse yavru bloğunun dışına verilebilir.';
    }
    if (petekPuani >= 55) {
      return l?.biyolHamPetekSinirli ?? 'Ham petek sınırlı verilebilir; kabarmış petek daha güvenli olur.';
    }
    return l?.biyolHamPetekDusuk ?? 'Ham petek için genç işçi kapasitesi sınırlı; önce kabarmış petek veya sıkı düzen daha güvenli.';
  }

  static String _beslemeOnerisi(
      int petek, int yavru, int nektar, double momentum, {AppLocalizations? l}) {
    if (nektar >= 75 && momentum >= 0.07)
      return l?.biyolBeslemeNektarIyi ?? 'Nektar toplama kapasitesi iyi; bal akımında gereksiz şurup vermekten kaçın.';
    if (yavru >= 70 && momentum >= 0.07)
      return l?.biyolBeslemeYavruIyi ?? 'Yavru bakım kapasitesi iyi; polen/stok zayıfsa destek besleme düşünülebilir.';
    if (petek >= 70)
      return l?.biyolBeslemePetekVar ?? 'Petek örme kapasitesi var; akım yoksa hafif destek büyümeyi koruyabilir.';
    return l?.biyolBeslemeKontrollu ?? 'Besleme kararı stok, hava ve süreç durumuna göre kontrollü verilmelidir.';
  }

  static String _temelSahaOnerisi({
    required int petek,
    required int yavru,
    required int nektar,
    required int balIsleme,
    required int kis,
    required int kuluclukCita,
    required int ballikCita,
    AppLocalizations? l,
  }) {
    if (kis < 45)
      return l?.biyolSahaStokOnceligi ?? 'Öncelik hasat değil stok güvenliği ve kış dayanımıdır.';
    if (kuluclukCita < 5 && yavru < 60)
      return l?.biyolSahaYavruOnceligi ?? 'Öncelik genişletme değil yavru alanını ve ısı düzenini korumaktır.';
    if (petek >= 75 && yavru >= 65 && kuluclukCita >= 5)
      return l?.biyolSahaHamPetek ?? 'Ham petek verilebilir; yavru bloğu kesilmeden dıştan genişlet.';
    if (nektar >= 75 && balIsleme >= 65)
      return ballikCita > 0
          ? (l?.biyolSahaBalAkimiBallik ?? 'Bal akımı değerlendirilebilir; ballıkta sırlanma takibi yap.')
          : (l?.biyolSahaBalAkimiKat ?? 'Nektar kapasitesi güçlü; sıkışma artarsa kat hazırlığını değerlendir.');
    if (yavru >= 75 && petek < 55)
      return l?.biyolSahaYavruPetekSinirli ?? 'Yavru bakım güçlü ama petek örme sınırlı; kabarmış petek ham petekten daha güvenli.';
    return l?.biyolSahaKontrolluBuyut ?? 'Koloniyi kontrollü büyüt; karar için son muayene, stok ve süreç durumunu birlikte oku.';
  }

  static String _kabiliyetOzeti(
      int petek, int yavru, int nektar, int balIsleme, int kis, {AppLocalizations? l}) {
    final liste = <String>[];
    if (petek >= 70) liste.add(l?.biyolKabiliyetPetekGuclu ?? 'petek örme güçlü');
    if (yavru >= 70) liste.add(l?.biyolKabiliyetYavruGuclu ?? 'yavru bakımı güçlü');
    if (nektar >= 70) liste.add(l?.biyolKabiliyetNektarGuclu ?? 'nektar toplama güçlü');
    if (balIsleme >= 70) liste.add(l?.biyolKabiliyetBalIslemeGuclu ?? 'bal işleme güçlü');
    if (kis < 50) liste.add(l?.biyolKabiliyetKisDikkat ?? 'kış stok/dayanım dikkat ister');
    if (liste.isEmpty)
      return l?.biyolKabiliyetOrta ?? 'Kabiliyetler orta bantta; aşırı genişletme veya ağır işlem yerine kontrollü ilerle.';
    return liste.join(', ') + '.';
  }

  static List<String> _ilgincBilgiler({
    required int tahminiGozMin,
    required int tahminiGozMax,
    required int tahminiAriMin,
    required int tahminiAriMax,
    required int tahminiYavruGozMin,
    required int tahminiYavruGozMax,
    required double hasatMin,
    required double hasatMax,
    AppLocalizations? l,
  }) {
    return <String>[
      l != null
          ? l.biyolIlgincGozKapasitesi(tahminiGozMin, tahminiGozMax)
          : 'Bu kolonide tahmini $tahminiGozMin–$tahminiGozMax petek gözü kapasitesi bulunur.',
      l != null
          ? l.biyolIlgincAriNufusu(tahminiAriMin, tahminiAriMax)
          : 'Tahmini arı nüfusu $tahminiAriMin–$tahminiAriMax aralığındadır.',
      l != null
          ? l.biyolIlgincYavruAlani(tahminiYavruGozMin, tahminiYavruGozMax)
          : 'Yavru alanı tahmini $tahminiYavruGozMin–$tahminiYavruGozMax göz kapasitesindedir.',
      if (hasatMax > 0)
        l != null
            ? l.biyolIlgincHasatPotansiyeli(_yuvarla(hasatMin).toString(), _yuvarla(hasatMax).toString())
            : 'Sırlı ve yavrusuz çıtalar uygunsa tahmini hasat potansiyeli ${_yuvarla(hasatMin)}–${_yuvarla(hasatMax)} kg bandındadır.',
      l?.biyolIlgincUyari ?? 'Bu veriler kesin sayım değil; standart biyolojik koloni modeliyle üretilen saha projeksiyonudur.',
    ];
  }

  static String _yorumUret({
    required int toplamCita,
    required int kuluclukCita,
    required int ballikCita,
    required int kuluclukKapasitesi,
    required int balliCita,
    required double hasatPotansiyeliMaxKg,
    required Map<String, dynamic> kabiliyet,
    required String yavruBlok,
    Map<String, dynamic>? yavrusuzlukAnalizi,
    AppLocalizations? l,
  }) {
    if (toplamCita <= 0) {
      return l?.biyolYorumVeriYok ?? 'Model için çıta verisi yok. İlk muayene sonrası tahmini biyolojik düzen okunabilir.';
    }
    final String yavrusuzlukMesaji =
    (yavrusuzlukAnalizi?['sahaMesaji'] ?? '').toString().trim();
    final String geriDonusKapasitesi =
    (yavrusuzlukAnalizi?['geriDonusKapasitesi'] ?? '').toString().trim();
    if (yavrusuzlukMesaji.isNotEmpty &&
        (geriDonusKapasitesi == 'dusuk' || geriDonusKapasitesi == 'kritik')) {
      return yavrusuzlukMesaji;
    }
    if (ballikCita > 0) {
      return l != null
          ? l.biyolYorumBallikAlan(kuluclukKapasitesi, ballikCita, yavruBlok)
          : 'Alt kuluçkalık $kuluclukKapasitesi çıta kabul edildi. Üstteki $ballikCita çıta ballık/kat alanı olarak yorumlandı. Merkez yavru bloğu ($yavruBlok) korunmalı.';
    }
    if (kuluclukCita <= 4) {
      return l?.biyolYorumKucukKoloni ?? 'Küçük koloni. Merkez yavru bloğu ve ısı düzeni korunmalı; gereksiz hacim bırakılmamalı.';
    }
    if (kuluclukCita < kuluclukKapasitesi) {
      final suffix = l != null
          ? l.biyolYorumGelisimSuffix(yavruBlok)
          : 'Merkez yavru bloğu ($yavruBlok) korunmalı.';
      return '${kabiliyet['hamPetekOnerisi']} $suffix';
    }
    final prefix = l?.biyolYorumDoluPrefix ?? 'Kuluçkalık dolu kabul edilir. Kat, sıkışıklık ve oğul baskısı birlikte izlenmeli.';
    return '$prefix ${kabiliyet['ozet']}';
  }

  static int? _nullableInt(dynamic deger) {
    if (deger == null) return null;
    if (deger is int) return deger;
    if (deger is double) return deger.round();
    return int.tryParse(deger.toString());
  }

  static DateTime _gun(DateTime t) => DateTime(t.year, t.month, t.day);

  static bool _toBool(dynamic deger) {
    if (deger == true) return true;
    if (deger is int) return deger == 1;
    final s = (deger ?? '').toString().trim().toLowerCase();
    return s == '1' || s == 'true' || s == 'evet' || s == 'var';
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
    if (deger is num) return deger.toDouble();
    return double.tryParse(deger.toString()) ?? 0.0;
  }

  static double _yuvarla(double v) => double.parse(v.toStringAsFixed(1));
}