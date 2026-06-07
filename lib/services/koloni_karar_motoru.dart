import 'package:itogena_v45/gen_l10n/app_localizations.dart';
import 'trend_servisi.dart';
import 'esik_servisi.dart';
import 'veritabani_servisi.dart';
import 'ari_biyoloji_servisi.dart';
import 'koloni_biyolojik_model_servisi.dart';
import 'performans_izleme_servisi.dart';

class KoloniKararSonucu {
  final int koloniId;
  final String kovanNo;

  final String kararKodu;
  final String kararBaslik;
  final String kararMesaji;
  final String kararNedeni;
  final String kararTipi;

  final String secilimKodu;
  final String secilimBaslik;
  final String secilimMesaji;

  final int donorSkoru;
  final int donorSirasi;
  final bool donorVeto;
  final bool gercekDamizlik;

  final List<Map<String, String>> aksiyonKartlari;

  final Map<String, dynamic> profil;

  const KoloniKararSonucu({
    required this.koloniId,
    required this.kovanNo,
    required this.kararKodu,
    required this.kararBaslik,
    required this.kararMesaji,
    required this.kararNedeni,
    required this.kararTipi,
    required this.secilimKodu,
    required this.secilimBaslik,
    required this.secilimMesaji,
    required this.donorSkoru,
    required this.donorSirasi,
    required this.donorVeto,
    required this.gercekDamizlik,
    required this.aksiyonKartlari,
    required this.profil,
  });

  Map<String, String> toAnaKararMap() {
    return {
      'kod': kararKodu,
      'baslik': kararBaslik,
      'mesaj': kararMesaji,
      'neden': kararNedeni,
      'tip': kararTipi,
    };
  }

  Map<String, String> toSecilimMap() {
    return {
      'kod': secilimKodu,
      'baslik': secilimBaslik,
      'mesaj': secilimMesaji,
    };
  }
}

class KoloniKararMotoru {
  static final Map<int, List<Map<String, dynamic>>> _donorListeCache = {};
  static final Map<int, Future<List<Map<String, dynamic>>>>
      _donorListeFutureCache = {};
  static final Map<int, Map<String, dynamic>> _arilikOzetCache = {};
  static final Map<int, Map<String, dynamic>> _koloniProfilCache = {};
  static final Map<int, Future<Map<String, dynamic>>> _koloniProfilFutureCache = {};
  static final Map<String, KoloniKararSonucu> _koloniKararCache = {};

  static void tumCacheTemizle() {
    _donorListeCache.clear();
    _donorListeFutureCache.clear();
    _arilikOzetCache.clear();
    _koloniProfilCache.clear();
    _koloniProfilFutureCache.clear();
    _koloniKararCache.clear();
  }

  static void arilikCacheTemizle(int? arilikId) {
    if (arilikId == null || arilikId <= 0) return;
    _donorListeCache.remove(arilikId);
    _donorListeFutureCache.remove(arilikId);
    _arilikOzetCache.remove(arilikId);
    _koloniProfilCache.clear();
    _koloniProfilFutureCache.clear();
    _koloniKararCache.removeWhere((key, value) {
      final profilArilikId = _nullableInt(value.profil['arilikId']);
      return profilArilikId == arilikId;
    });
  }


  static void koloniCacheTemizle(int koloniId) {
    if (koloniId <= 0) return;
    _koloniProfilCache.remove(koloniId);
    _koloniProfilFutureCache.remove(koloniId);
    _koloniKararCache.removeWhere((key, value) => value.koloniId == koloniId);
    // Tek bir koloninin muayenesi veya bilgisi değiştiğinde donör sırası ve
    // arılık özeti de etkilenebilir. Güvenli tarafta kalmak için arılık
    // düzeyindeki hesapları tamamen temizliyoruz.
    _donorListeCache.clear();
    _donorListeFutureCache.clear();
    _arilikOzetCache.clear();
  }

  static String _kararCacheKey(
      int koloniId,
      int? arilikId,
      int donorListeBoyutu,
      int donorSirasi,
      Map<String, dynamic> profil,
      ) {
    final int skor = _toInt(profil['skor']);
    final int sonCita = _toInt(profil['sonCita']);
    final int maxCita = _toInt(profil['maxCita']);
    final int muayeneSayisi = _toInt(profil['muayeneSayisi']);
    final int donorSkoru = _toInt(profil['donorSkoru']);
    final bool donorVeto = profil['donorVeto'] == true;

    final bool aktifMi = profil['aktifMi'] == true;
    final int kisCikisPuani = _toInt(profil['kisCikisPuani']);
    final String kisGirisTarih =
    (profil['kisGirisReferansTarih'] ?? '').toString();
    final String kisSonuTarih =
    (profil['kisSonuReferansTarih'] ?? '').toString();
    final String kararTarih = (profil['kararTarih'] ?? '').toString();
    final String bolmePenceresi = (profil['bolmePenceresi'] ?? '').toString();
    final String anaDegisimPenceresi =
    (profil['anaDegisimPenceresi'] ?? '').toString();
    final int momentumSkoru = _toInt(profil['momentumSkoru']);
    final String kovanTipi = (profil['kovanTipi'] ?? '').toString();
    final int surupluk = profil['suruplukVarMi'] == true ? 1 : 0;

    return [
      koloniId,
      arilikId ?? 0,
      donorListeBoyutu,
      donorSirasi,
      skor,
      sonCita,
      maxCita,
      muayeneSayisi,
      donorSkoru,
      donorVeto ? 1 : 0,
      aktifMi ? 1 : 0,
      kisCikisPuani,
      kisGirisTarih,
      kisSonuTarih,
      kararTarih,
      bolmePenceresi,
      anaDegisimPenceresi,
      momentumSkoru,
      kovanTipi,
      surupluk,
    ].join('|');
  }

  static Future<Map<String, dynamic>> arilikOzetGetir(int arilikId) async {
    final cached = _arilikOzetCache[arilikId];
    if (cached != null) return cached;

    final koloniler =
    await VeritabaniServisi.kovanlariAriligaGoreGetir(arilikId);
    final donorler = await donorAdaylariSiraliGetir(arilikId: arilikId);

    int toplamSkor = 0;
    int dikkat = 0;

    for (final koloni in koloniler) {
      final koloniId = _toInt(koloni['id']);
      toplamSkor += _toInt(koloni['skor']);

      if (koloniId > 0) {
        final sonuc = await kararUret(
          koloniId,
          koloni,
          siraliDonorler: donorler,
        );

        if (sonuc.kararKodu == 'ANA_DEGISIM_DUSUN' ||
            sonuc.kararKodu == 'GUCLENDIR_VE_IZLE' ||
            sonuc.kararKodu == 'VERI_YETERSIZ' ||
            sonuc.kararKodu == 'PASIF_KAYIT') {
          dikkat++;
        }
      }
    }

    final sonuc = <String, dynamic>{
      'toplam': koloniler.length,
      'donor': donorler.where((e) {
        final sira = _toInt(e['sira']);
        return sira >= 1 && sira <= 3;
      }).length,
      'dikkat': dikkat,
      'ortalamaSkor':
      koloniler.isEmpty ? 0 : (toplamSkor / koloniler.length).round(),
    };

    _arilikOzetCache[arilikId] = sonuc;
    return sonuc;
  }

  static Future<KoloniKararSonucu> kararUret(
      int koloniId,
      Map<String, dynamic> koloni, {
        List<Map<String, dynamic>>? siraliDonorler,
        bool forceRefresh = false,
        bool donorAnaliziBekle = true,
        AppLocalizations? l,
      }) async {
    final int? arilikId = _nullableInt(koloni['arilikId']);
    final List<Map<String, dynamic>> donorListesi = donorAnaliziBekle
        ? (siraliDonorler ?? await donorAdaylariSiraliGetir(arilikId: arilikId))
        : (siraliDonorler ?? const <Map<String, dynamic>>[]);

    Map<String, dynamic>? kendiSirasi;
    for (final item in donorListesi) {
      if (_toInt(item['koloniId']) == koloniId) {
        kendiSirasi = item;
        break;
      }
    }

    final int donorSirasi =
    kendiSirasi == null ? 0 : _toInt(kendiSirasi['sira']);

    final profil = await _koloniProfiliGetir(
      koloniId,
      koloni,
      forceRefresh: forceRefresh,
    );
    final cacheKey = _kararCacheKey(
      koloniId,
      arilikId,
      donorListesi.length,
      donorSirasi,
      profil,
    );

    if (!forceRefresh && _koloniKararCache.containsKey(cacheKey)) {
      return _koloniKararCache[cacheKey]!;
    }

    final sonuc = await _kararMantiginiCalistir(
      koloniId: koloniId,
      koloni: koloni,
      profil: profil,
      donorListesi: donorListesi,
      donorSirasi: donorSirasi,
      l: l,
    );

    _koloniKararCache[cacheKey] = sonuc;
    return sonuc;
  }

  static Future<KoloniKararSonucu> _kararMantiginiCalistir({
    required int koloniId,
    required Map<String, dynamic> koloni,
    required Map<String, dynamic> profil,
    required List<Map<String, dynamic>> donorListesi,
    required int donorSirasi,
    AppLocalizations? l,
  }) async {
    final String kovanNo = (koloni['kovanNo'] ?? '-').toString();

    final bool donorVeto = profil['donorVeto'] == true;
    final bool aktifMi = profil['aktifMi'] == true;
    final bool kovanSondu = profil['kovanSondu'] == true;
    final bool dogrudanOgulKokenli = profil['dogrudanOgulKokenli'] == true;
    final bool kendisiOgulAtti = profil['kendisiOgulAtti'] == true;
    final bool kaynakTipiOgul = profil['kaynakTipiOgul'] == true;
    final bool ataHattaOgulAtti = profil['ataHattaOgulAtti'] == true;

    final int donorSkoru = _toInt(profil['donorSkoru']);
    final int skor = _toInt(profil['skor']);
    final int sonCita = _toInt(profil['sonCita']);
    final int maxCita = _toInt(profil['maxCita']);
    final int balCita = _toInt(profil['balCita']);
    final int anaYasi = _toInt(profil['anaYasi']);
    final int muayeneSayisi = _toInt(profil['muayeneSayisi']);

    final String mizac = (profil['mizac'] ?? 'Bilinmiyor').toString();
    final String trend = (profil['trend'] ?? 'Stabil').toString();
    final int momentumSkoru = _toInt(profil['momentumSkoru']);
    final bool gucluMomentum = momentumSkoru >= 70;
    final String davranisToleransi =
    (profil['davranisToleransi'] ?? 'standart').toString();

    final int donorHavuzuBoyutu = donorListesi.length;

    final esikler = await EsikServisi.tumEsikleriYukle();
    final int bolmeCita = esikler['bolme_adayi_min_cita'] ?? EsikServisi.bolmeAdayiMinCita;
    final int biyolojikBolmeAltCita = EsikServisi.bolmeBiyolojikMinCita;
    final int destekCita = esikler['destek_max_maks_cita'] ?? 4;
    final int uretimMinSkor = esikler['uretim_min_skor'] ?? 70;
    final int mudahaleMinSkor = esikler['mudahale_min_skor'] ?? 45;
    // Ürün standardı: ana değişim yaşı varsayılan olarak 2 yıldır.
    // Bu değer karar dilinde sade tutulur; gereksiz ayar karmaşası oluşturulmaz.
    const int anaDegisimYasi = 2;

    final biyoloji = await AriBiyolojiServisi.analizYap(koloniId);
    final int petekOrmePuani = _toInt(profil['petekOrmePuani']);
    final int yavruBakimPuani = _toInt(profil['yavruBakimPuani']);
    final int nektarToplamaPuani = _toInt(profil['nektarToplamaPuani']);
    final int balIslemePuani = _toInt(profil['balIslemePuani']);
    final int kisDayanimPuani = _toInt(profil['kisDayanimPuani']);
    final String temelSahaOnerisi =
        (profil['biyolojikTemelSahaOnerisi'] ?? '').toString().trim();

    final String sezonKodu = (profil['sezonKodu'] ?? 'uretim').toString();
    final bool uretimSezonu = sezonKodu == 'uretim';
    final String bolmePenceresi =
    (profil['bolmePenceresi'] ?? 'kapali').toString();
    final String bolmePencereMesaji =
    (profil['bolmePencereMesaji'] ?? '').toString();
    final String anaDegisimPenceresi =
    (profil['anaDegisimPenceresi'] ?? 'planla').toString();
    final String anaDegisimPencereMesaji =
    (profil['anaDegisimPencereMesaji'] ?? '').toString();

    final bool bolmeZamaniUygun = bolmePenceresi == 'uygun';
    final bool bolmeZamaniGec = bolmePenceresi == 'gec';
    final bool bolmeZamaniBalAkiminda = bolmePenceresi == 'bal_akiminda';
    final bool bolmeZamaniKapali =
        bolmePenceresi == 'kapali' || bolmePenceresi == 'hasat_sonrasi';

    final bool bolmeIcinUygun =
        uretimSezonu &&
            bolmeZamaniUygun &&
            sonCita >= bolmeCita &&
            maxCita >= bolmeCita &&
            trend != 'Düşüş';
    final bool bolmeRiskliBand =
        uretimSezonu &&
            bolmeZamaniUygun &&
            !bolmeIcinUygun &&
            sonCita >= biyolojikBolmeAltCita &&
            sonCita < bolmeCita;
    final bool bolmeGecKaldi =
        uretimSezonu && bolmeZamaniGec && sonCita >= biyolojikBolmeAltCita;
    final bool bolmeOzelStratejiNotu =
        uretimSezonu && bolmeZamaniBalAkiminda && sonCita >= bolmeCita;
    final bool anaDegisimZamaniUygun = anaDegisimPenceresi == 'uygun';

    final String veriGuveniEtiketi = _veriGuveniEtiketi(muayeneSayisi, l: l);
    final String veriGuveniNotu = _veriGuveniNotu(muayeneSayisi, l: l);

    late final String kararKodu;
    late final String kararBaslik;
    late final String kararMesaji;
    late final String kararNedeni;
    late final String kararTipi;

    late final String secilimKodu;
    late final String secilimBaslik;
    late final String secilimMesaji;

    if (!aktifMi) {
      kararKodu = 'PASIF_KAYIT';
      kararBaslik = l?.kararPasifBaslik ?? 'Bu koloni aktif değil';
      kararMesaji = l?.kararPasifMesaj ?? 'Aktif üretimde değerlendirme. Kayıt olarak tut, gerekiyorsa birleştirme planında düşün.';
      kararNedeni = aktifMi
          ? (l?.kararPasifNedenAktifGorunmuyor ?? 'Koloni aktif görünmüyor.')
          : (kovanSondu
          ? (l?.kararPasifNedenSonmugGorunuyor ?? 'Son muayene verisinde koloni sönmüş görünüyor.')
          : (l?.kararPasifNedenIsaretli ?? 'Koloni durumu pasif olarak işaretli.'));
      kararTipi = 'negatif';

      secilimKodu = 'PASIF_KAYIT';
      secilimBaslik = l?.kararPasifSecilimBaslik ?? 'Pasif kayıt';
      secilimMesaji = l?.kararPasifSecilimMesaj ?? 'Bu koloni aktif üretimde değildir. Soy ve geçmiş takibi için tutulur.';
    } else if (donorVeto) {
      final String vetoNedeni;
      if (dogrudanOgulKokenli || kaynakTipiOgul) {
        vetoNedeni = l?.kararVetoNedenDogrudanOgul ?? 'Kökeni oğul olduğu için temiz donör havuzuna alınmadı.';
      } else if (kendisiOgulAtti) {
        vetoNedeni = l?.kararVetoNedenKendisiOgul ?? 'Kendi geçmişinde oğul attığı için temiz donör havuzuna alınmadı.';
      } else if (ataHattaOgulAtti) {
        vetoNedeni = l?.kararVetoNedenAtaHatta ?? 'Atasal hatta oğul izi taşıdığı için temiz donör havuzuna alınmadı.';
      } else {
        vetoNedeni = l?.kararVetoNedenGenel ?? 'Temiz donör havuzuna alınmadı.';
      }

      if (bolmeIcinUygun) {
        kararKodu = 'BOLME_ICIN_UYGUN';
        kararBaslik = l?.kararVetoBolmeBaslik ?? 'Genetik veto var; güvenli bölme veya üretim için kullan';
        kararMesaji = l?.kararVetoBolmeMesaj ?? 'Ana üretme. 9 çıta ve üstü güçte olduğu için bölme, kapalı yavru desteği veya üretim için değerlendirilebilir.';
        kararNedeni = vetoNedeni;
        kararTipi = 'uyari';

        secilimKodu = 'OPERASYONEL_KULLAN';
        secilimBaslik = l?.kararVetoBolmeSecilimBaslik ?? 'Genetik veto / güçlü operasyonel kullanım';
        secilimMesaji = l?.kararVetoBolmeSecilimMesaj ?? 'Donör havuzunda değil. 9 çıta güvenli saha eşiğini geçtiği için yalnızca operasyonel bölme, destek ve üretim rolünde değerlendirilebilir.';
      } else if (skor >= uretimMinSkor ||
          balCita > 0 ||
          bolmeRiskliBand ||
          bolmeGecKaldi ||
          bolmeOzelStratejiNotu) {
        kararKodu = 'URETIMDE_DEGERLENDIR';
        kararBaslik = l?.kararVetoUretimBaslik ?? 'Genetik veto var; üretimde değerlendir';
        final String mesajBase = bolmeRiskliBand
            ? (l?.kararVetoUretimMesajRiskliBand ?? 'Ana üretme. 6–8 çıta arası bölme için riskli kabul edilir; sistem bölme önermiyor. Önce güçlendir, üretim ve destek rolünde değerlendir.')
            : (bolmeGecKaldi
            ? (gucluMomentum
                ? (l?.kararVetoUretimMesajGecGuclu ?? 'Ana üretme. Koloni güçlü üreme gelişimi gösteriyor; ancak bal akımına yakın dönemde standart bölme üretim gücünü düşürebilir. Saha baskısı oluşursa kontrollü bölme ayrıca değerlendirilebilir.')
                : (l?.kararVetoUretimMesajGec ?? 'Ana üretme. Koloni güçlü olabilir; ancak standart bölme için zaman geç kalmış görünüyor. Üretim gücünü koru.'))
            : (bolmeOzelStratejiNotu
            ? (l?.kararVetoUretimMesajOzelStrateji ?? 'Ana üretme. Bal akımı içinde standart bölme önerilmez. Yalnızca bilinçli üretim stratejisi olarak yavru azaltma bölmesi ayrıca değerlendirilebilir.')
            : (l?.kararVetoUretimMesajGenel ?? 'Ana üretme. Bal ve genel üretim odağında kullan. Donör değil ama çalışkan üretim kolonisi olarak değerlendirilebilir.')));
        kararMesaji = (bolmeGecKaldi && bolmePencereMesaji.isNotEmpty) ? '$mesajBase $bolmePencereMesaji' : mesajBase;
        kararNedeni = vetoNedeni;
        kararTipi = 'uyari';

        secilimKodu = 'OPERASYONEL_KULLAN';
        secilimBaslik = l?.kararVetoUretimSecilimBaslik ?? 'Genetik veto / üretim kolonisi';
        secilimMesaji = l?.kararVetoUretimSecilimMesaj ?? 'Temiz donör havuzunda değil. Buna rağmen üretim ve saha sürekliliği açısından kullanılabilir.';
      } else if (skor >= mudahaleMinSkor) {
        kararKodu = 'DESTEK_KOLONISI';
        kararBaslik = l?.kararVetoDestekBaslik ?? 'Genetik veto var; destekleyerek kullan';
        kararMesaji = l?.kararVetoDestekMesaj ?? 'Oğul izi olduğundan ana üretiminde kullanma. Gelişimine göre destek kolonisi veya üretim kolonisi olarak kullanılabilir.';
        kararNedeni = vetoNedeni;
        kararTipi = 'uyari';

        secilimKodu = 'OPERASYONEL_KULLAN';
        secilimBaslik = l?.kararVetoDestekSecilimBaslik ?? 'Genetik veto / destek kullanımı';
        secilimMesaji = l?.kararVetoDestekSecilimMesaj ?? 'Donör havuzunda değil. Güç durumuna göre destek veya üretim kolonisi olarak değerlendirilebilir.';
      } else {
        kararKodu = 'GUCLENDIR_VE_IZLE';
        kararBaslik = l?.kararVetoGuclenirBaslik ?? 'Genetik veto var; önce toparla ve izle';
        kararMesaji = l?.kararVetoGuclenirMesaj ?? 'Ana üretme. Önce gücünü toparla. Besleme, destek ve yakın muayene ile gelişimine bak; sonra saha rolünü netleştir.';
        kararNedeni = vetoNedeni;
        kararTipi = 'negatif';

        secilimKodu = 'OPERASYONEL_KULLAN';
        secilimBaslik = l?.kararVetoGuclenirSecilimBaslik ?? 'Genetik veto / önce toparlanmalı';
        secilimMesaji = l?.kararVetoGuclenirSecilimMesaj ?? 'Donör havuzunda değil. Önce güç kazanmalı; sonra yalnızca operasyonel rolü yeniden okunmalıdır.';
      }
    } else if (donorSirasi == 1) {
      final String davranisNotu = _davranisNotuMetni(
        mizac: mizac,
        davranisToleransi: davranisToleransi,
        l: l,
      );

      kararKodu = 'DONOR_1';
      kararBaslik = l?.kararDonor1Baslik ?? 'Bu koloni 1. donör adayı';
      kararMesaji = '${l?.kararDonor1MesajBase ?? 'Ana üretiminde öncelikli. Gücünü koru. Bölme veya başka kullanım kararını donör değerini bozmayacak şekilde düşün.'} $veriGuveniNotu';
      kararNedeni = '${l != null ? l.kararDonor1NedeniBase(donorSkoru) : 'Donör havuzundaki en güçlü koloni olarak öne çıkıyor. Donör skoru: $donorSkoru / 100.'}$davranisNotu';
      kararTipi = 'pozitif';

      secilimKodu = 'DAMIZLIK_ADAYI';
      secilimBaslik = l?.kararDonor1SecilimBaslik ?? 'Bu koloni 1. donör adayı';
      secilimMesaji = l?.kararDonor1SecilimMesaj ?? 'Bu koloni donör havuzunda ilk sırada yer alıyor ve ana üretimi için en güçlü aday kabul ediliyor.';
    } else if (donorSirasi == 2) {
      final String davranisNotu = _davranisNotuMetni(
        mizac: mizac,
        davranisToleransi: davranisToleransi,
        l: l,
      );

      kararKodu = 'DONOR_2';
      kararBaslik = l?.kararDonor2Baslik ?? 'Bu koloni 2. donör adayı';
      kararMesaji = '${l?.kararDonor2MesajBase ?? 'Ana üretiminde güçlü bir alternatif olarak değerlendir. İlk tercihin uygun değilse buna yönel.'} $veriGuveniNotu';
      kararNedeni = '${l != null ? l.kararDonor2NedeniBase(donorSkoru) : 'Donör havuzunda üst sırada yer alıyor. Donör skoru: $donorSkoru / 100.'}$davranisNotu';
      kararTipi = 'pozitif';

      secilimKodu = 'DAMIZLIK_ADAYI';
      secilimBaslik = l?.kararDonor2SecilimBaslik ?? 'Bu koloni 2. donör adayı';
      secilimMesaji = l?.kararDonor2SecilimMesaj ?? 'Bu koloni donör havuzunda üst sırada yer alıyor ve ana üretimi için güçlü alternatif kabul ediliyor.';
    } else if (donorSirasi == 3) {
      final String davranisNotu = _davranisNotuMetni(
        mizac: mizac,
        davranisToleransi: davranisToleransi,
        l: l,
      );

      kararKodu = 'DONOR_3';
      kararBaslik = l?.kararDonor3Baslik ?? 'Bu koloni 3. donör adayı';
      kararMesaji = '${l?.kararDonor3MesajBase ?? 'Ana üretiminde yedek güçlü aday olarak değerlendir. Üretimde de değerli kalabilir.'} $veriGuveniNotu';
      kararNedeni = '${l != null ? l.kararDonor3NedeniBase(donorSkoru) : 'Donör havuzunda ilk üç içinde yer alıyor. Donör skoru: $donorSkoru / 100.'}$davranisNotu';
      kararTipi = 'pozitif';

      secilimKodu = 'DAMIZLIK_ADAYI';
      secilimBaslik = l?.kararDonor3SecilimBaslik ?? 'Bu koloni 3. donör adayı';
      secilimMesaji = l?.kararDonor3SecilimMesaj ?? 'Bu koloni donör havuzunda ilk üç içinde yer alıyor ve ana üretimi için değerlendirilebilir.';
    } else if (donorHavuzuBoyutu > 0 && donorSkoru >= 60) {
      final String davranisNotu = _davranisNotuMetni(
        mizac: mizac,
        davranisToleransi: davranisToleransi,
        l: l,
      );

      kararKodu = 'SARTLI_DONOR';
      kararBaslik = l?.kararSartliDonorBaslik ?? 'Bu koloni donör havuzunda, ama ilk sıralarda değil';
      kararMesaji = '${l?.kararSartliDonorMesajBase ?? 'Üretimde değerlendir. Gelişimi sürerse ileride donör alternatifi olarak yeniden bak.'} $veriGuveniNotu';
      kararNedeni = '${l != null ? l.kararSartliDonorNedeniBase(donorSkoru) : 'Donör havuzuna girmiş olsa da şu an ilk üçte değil. Donör skoru: $donorSkoru / 100.'}$davranisNotu';
      kararTipi = 'notr';

      secilimKodu = 'SARTLI_DAMIZLIK';
      secilimBaslik = l?.kararSartliDonorSecilimBaslik ?? 'Donör havuzunda';
      secilimMesaji = l?.kararSartliDonorSecilimMesaj ?? 'Bu koloni donör havuzuna girmiş durumda; ancak şu an ilk sıradaki adaylardan biri değil.';
    } else if (anaYasi >= anaDegisimYasi &&
        (skor < uretimMinSkor || anaDegisimZamaniUygun)) {
      kararKodu = 'ANA_DEGISIM_DUSUN';
      kararBaslik = anaDegisimZamaniUygun
          ? (l?.kararAnaDegisimZamanBaslik ?? 'Bu koloni için ana değişimi zamanı uygun')
          : (l?.kararAnaDegisimPlanlaBaslik ?? 'Ana değişimini sezon planına al');
      final String anaDegisimMesajBase = anaDegisimZamaniUygun
          ? (l?.kararAnaDegisimZamanMesaj ?? 'Hasat sonrası pencere ana değişimi için uygundur. Üretimde kalacaksa genç ve güvenilir bir ana ile yenilemek doğru olabilir.')
          : (l?.kararAnaDegisimPlanMesajBase ?? 'Ana yaşı izlenmeli; ancak planlı ana değişimi için en güçlü pencere hasat sonrasıdır. Zorunlu sorun yoksa takvime al.');
      kararMesaji = (!anaDegisimZamaniUygun && anaDegisimPencereMesaji.isNotEmpty)
          ? '$anaDegisimMesajBase $anaDegisimPencereMesaji'
          : anaDegisimMesajBase;
      kararNedeni = l != null ? l.kararAnaDegisimNedeni(anaYasi) : 'Ana yaşı $anaYasi yıl görünüyor. Ürün standardında 2 yaş ana değişimi için dikkat eşiğidir.';
      kararTipi = 'uyari';

      secilimKodu = 'ANA_DEGISIM';
      secilimBaslik = anaDegisimZamaniUygun
          ? (l?.kararAnaDegisimZamanSecilimBaslik ?? 'Ana değişimi için uygun pencere')
          : (l?.kararAnaDegisimPlanSecilimBaslik ?? 'Ana değişimi planlanmalı');
      secilimMesaji = anaDegisimPencereMesaji.isNotEmpty
          ? anaDegisimPencereMesaji
          : (l?.kararAnaDegisimSecilimMesajVarsayilan ?? 'Koloni tamamen olumsuz değildir; ancak daha iyi verim için ana yenileme düşünülebilir.');
    } else if (bolmeIcinUygun) {
      kararKodu = 'BOLME_ICIN_UYGUN';
      kararBaslik = l?.kararBolmeUygunBaslik ?? 'Bu koloni bölme için uygun görünüyor';
      kararMesaji = l?.kararBolmeUygunMesaj ?? '9 çıta ve üstü güçte. Donör önceliğinde değilse güvenli bölme için değerlendirilebilir. Ana koloni en az 5 çıta kalmalı, yeni bölme en az 4 çıta başlamalı.';
      kararNedeni = l?.kararBolmeUygunNedeni ?? 'Koloni 9 çıta güvenli saha eşiğini karşılıyor, üretim sezonunda ve trend düşüşte değil.';
      kararTipi = 'pozitif';

      secilimKodu = 'BOLME_ADAYI';
      secilimBaslik = l?.kararBolmeUygunSecilimBaslik ?? 'Bölme için uygun';
      secilimMesaji = l?.kararBolmeUygunSecilimMesaj ?? '9 çıta güvenli saha eşiği karşılandığı için donör önceliğinde değilse bölme için değerlendirilebilir.';
    } else if (bolmeRiskliBand) {
      kararKodu = 'BOLME_RISKLI';
      kararBaslik = l?.kararBolmeRiskliBaslik ?? 'Bölme için güç sınırında';
      kararMesaji = l?.kararBolmeRiskliMesaj ?? '6–8 çıta arası biyolojik olarak mümkün görünse de ITOGENA bölme önermiyor. Önce güçlendir, 9 çıta ve üstünde yeniden değerlendir.';
      kararNedeni = l?.kararBolmeRiskliNedeni ?? 'Güvenli saha bölme eşiği 9 çıtadır. Daha düşük güçte hem ana koloni hem yeni bölme kaybedilebilir.';
      kararTipi = 'uyari';

      secilimKodu = 'BOLME_ONERILMEZ';
      secilimBaslik = l?.kararBolmeRiskliSecilimBaslik ?? 'Bölme önerilmez';
      secilimMesaji = l?.kararBolmeRiskliSecilimMesaj ?? 'Koloni güçlenene kadar üretim, destek veya takip rolünde tutulmalıdır.';
    } else if (bolmeGecKaldi && sonCita >= bolmeCita) {
      kararKodu = 'BOLME_ZAMANI_GECTI';
      kararBaslik = l?.kararBolmeZamaniGecBaslik ?? 'Güç var; standart bölme zamanı zayıf';
      kararMesaji = l?.kararBolmeZamaniGecMesaj ?? 'Koloni 9 çıta eşiğini karşılıyor; ancak bal akımına 57 günden az kaldığı için standart bölme üretim gücünü düşürebilir. Bu dönemde koloni gücünü koru.';
      kararNedeni = bolmePencereMesaji;
      kararTipi = 'uyari';

      secilimKodu = 'URETIMDE_TUT';
      secilimBaslik = l?.kararBolmeZamaniGecSecilimBaslik ?? 'Bölme yerine üretimde tut';
      secilimMesaji = l?.kararBolmeZamaniGecSecilimMesaj ?? 'Zaman penceresi nedeniyle bölme kararı güçlü görünmüyor; üretim gücü korunmalıdır.';
    } else if (bolmeOzelStratejiNotu) {
      kararKodu = 'BAL_AKIMI_OZEL_BOLME';
      kararBaslik = l?.kararBalAkimiOzelBolmeBaslik ?? 'Bal akımında standart bölme önerilmez';
      kararMesaji = l?.kararBalAkimiOzelBolmeMesaj ?? 'Koloni güçlü; fakat bal akımı içinde standart bölme önerisi verilmez. Yalnızca bilinçli üretim stratejisi olarak yavru azaltma bölmesi ayrıca değerlendirilebilir.';
      kararNedeni = bolmePencereMesaji;
      kararTipi = 'notr';

      secilimKodu = 'URETIM_STRATEJISI';
      secilimBaslik = l?.kararBalAkimiOzelBolmeSecilimBaslik ?? 'Özel üretim stratejisi';
      secilimMesaji = l?.kararBalAkimiOzelBolmeSecilimMesaj ?? 'Bu karar otomatik bölme önerisi değildir; arıcının hedeflediği üretim tekniğine bağlıdır.';
    } else if (bolmeZamaniKapali && sonCita >= bolmeCita) {
      kararKodu = 'URETIMDE_DEGERLENDIR';
      kararBaslik = l?.kararGucluKoloniBaslik ?? 'Güçlü koloni; bölme zamanı değil';
      kararMesaji = l?.kararGucluKoloniMesaj ?? 'Koloni güçlü görünüyor; ancak bu tarih aralığında standart bölme kararı ciddi görünmez. Gücü üretim, bakım veya sezon planında değerlendir.';
      kararNedeni = bolmePencereMesaji;
      kararTipi = 'notr';

      secilimKodu = 'SADIK_URETICI';
      secilimBaslik = l?.kararGucluKoloniSecilimBaslik ?? 'Üretimde değerlendir';
      secilimMesaji = l?.kararGucluKoloniSecilimMesaj ?? 'Koloni gücü değerli; zaman penceresi uygun olduğunda bölme yeniden okunabilir.';
    } else if (skor >= uretimMinSkor || balCita > 0) {
      kararKodu = 'URETIMDE_DEGERLENDIR';
      kararBaslik = l?.kararUretimdeBaslik ?? 'Bu koloni üretimde değerlendirilebilir';
      kararMesaji = l?.kararUretimMesaj ?? 'Bal ve genel üretim odağında kullan. Sezona göre destek veya üretim rolünde değerlendir.';
      kararNedeni = l?.kararUretimNedeni ?? 'Performansı üretim için yeterli görünüyor.';
      kararTipi = 'notr';

      secilimKodu = 'SADIK_URETICI';
      secilimBaslik = l?.kararUretimSecilimBaslik ?? 'Üretimde değerlendir';
      secilimMesaji = l?.kararUretimSecilimMesaj ?? 'Bu koloni üretim ve süreklilik açısından değerlidir; donör önceliğinde görünmüyor.';
    } else if (muayeneSayisi <= 1) {
      kararKodu = 'VERI_GUVENI_DUSUK';
      kararBaslik = l?.kararVeriGuveniDusukBaslik ?? 'Karar var; veri güveni düşük';
      kararMesaji = l?.kararVeriGuveniDusukMesaj ?? 'Mevcut kayda göre rolü izleme ve güçlendirme tarafında. Tek muayene kesin hüküm için zayıftır; ikinci ve üçüncü kayıtla karar netleşir.';
      kararNedeni = l?.kararVeriGuveniDusukNedeni ?? 'Sistem karar üretir, ancak muayene verisi etkili değerlendirme için henüz sınırlıdır.';
      kararTipi = 'notr';

      secilimKodu = 'VERI_GUVENI_DUSUK';
      secilimBaslik = l?.kararVeriGuveniDusukSecilimBaslik ?? 'Veri güveni düşük';
      secilimMesaji = l?.kararVeriGuveniDusukSecilimMesaj ?? 'Donör ya da üretim rolü tamamen kapatılmaz; ancak kararın güven düzeyi düşük olduğu açıkça izlenmelidir.';
    } else if (skor < mudahaleMinSkor ||
        sonCita <= destekCita ||
        trend == 'Düşüş') {
      kararKodu = 'GUCLENDIR_VE_IZLE';
      kararBaslik = l?.kararYakinTakipBaslik ?? 'Bu koloniye yakından bakmak gerekir';
      kararMesaji = l?.kararYakinTakipMesaj ?? 'Destek, besleme ve sık muayene ile gelişimi yeniden değerlendir.';
      kararNedeni = l?.kararYakinTakipNedeni ?? 'Güç veya gidişat istenen seviyede görünmüyor.';
      kararTipi = 'uyari';

      secilimKodu = 'IZLE';
      secilimBaslik = l?.kararYakinTakipSecilimBaslik ?? 'İzleyerek karar ver';
      secilimMesaji = l?.kararYakinTakipSecilimMesaj ?? 'Bu koloni için hüküm vermeden önce biraz daha veri ve gözlem gerekir.';
    } else {
      kararKodu = 'DESTEK_KOLONISI';
      kararBaslik = l?.kararDestekRolBaslik ?? 'Bu koloniyi destek rolünde değerlendir';
      kararMesaji = l?.kararDestekRolMesaj ?? 'Şu an için en doğru rol destek ve düzenli takip görünüyor. Güçlenirse sonraki değerlendirmede üretimde daha öne çıkabilir.';
      kararNedeni = l?.kararDestekRolNedeni ?? 'Donör havuzunda üst sırada değil, ama tamamen olumsuz da görünmüyor.';
      kararTipi = 'notr';

      secilimKodu = 'SADIK_URETICI';
      secilimBaslik = l?.kararDestekRolSecilimBaslik ?? 'Destek / üretim rolü';
      secilimMesaji = l?.kararDestekRolSecilimMesaj ?? 'Bu koloni destek ve süreklilik açısından değerlidir; donör önceliğinde görünmüyor.';
    }

    final List<Map<String, String>> aksiyonKartlari = [
      {
        'baslik': l?.kararKartDurum ?? 'Durum',
        'rol': 'durum',
        'mesaj': secilimBaslik,
        'tip': kararTipi,
      },
      {
        'baslik': l?.kararKartNeYap ?? 'Ne yap',
        'rol': 'ne_yap',
        'mesaj': kararMesaji,
        'tip': 'notr',
      },
      {
        'baslik': l?.kararNeden ?? 'Neden',
        'rol': 'neden',
        'mesaj': kararNedeni,
        'tip': 'notr',
      },
      {
        'baslik': l?.kararKartVeriGuveni ?? 'Veri Güveni',
        'rol': 'veri_guveni',
        'mesaj': '$veriGuveniEtiketi. $veriGuveniNotu',
        'tip': muayeneSayisi >= 5 ? 'pozitif' : 'uyari',
      },
      {
        'baslik': l?.kararKartZamanBaglami ?? 'Zaman Bağlamı',
        'rol': 'zaman_baglami',
        'mesaj': bolmePencereMesaji.isNotEmpty
            ? bolmePencereMesaji
            : (l?.kararKartZamanBaglamiVarsayilan ?? 'Karar mevcut sezon ve bal akımı takvimine göre okunur.'),
        'tip': bolmeZamaniUygun ? 'pozitif' : 'notr',
      },
    ];

    if (biyoloji.veriVarMi) {
      String biyolojiTip = 'notr';
      if (biyoloji.zamanKritik || biyoloji.mudahaleGerekli) {
        biyolojiTip = 'uyari';
      } else if (biyoloji.anaUretimIcinUygun) {
        biyolojiTip = 'pozitif';
      }

      aksiyonKartlari.add({
        'baslik': l?.kararKartBiyolojikDurum ?? 'Biyolojik Durum',
        'rol': 'biyolojik_durum',
        'mesaj': biyoloji.baslik,
        'tip': biyolojiTip,
      });
      aksiyonKartlari.add({
        'baslik': l?.kararKartBiyolojikNot ?? 'Biyolojik Not',
        'rol': 'biyolojik_not',
        'mesaj': biyoloji.mesaj,
        'tip': 'notr',
      });

      if (biyoloji.zamanKritik || biyoloji.mudahaleGerekli) {
        aksiyonKartlari.add({
          'baslik': l?.kararKartSahadaOncelik ?? 'Sahada Öncelik',
          'rol': 'sahada_oncelik',
          'mesaj': l?.kararKartBiyolojikOncelik ?? 'Bu koloni biyolojik zamanlama açısından öncelikli kontrol istemektedir.',
          'tip': 'uyari',
        });
      }
    }

    aksiyonKartlari.addAll(_biyolojikKabiliyetAksiyonlari(
      kritikBiyolojiAktif: biyoloji.zamanKritik || biyoloji.mudahaleGerekli,
      sezonKodu: sezonKodu,
      sonCita: sonCita,
      petekOrmePuani: petekOrmePuani,
      yavruBakimPuani: yavruBakimPuani,
      nektarToplamaPuani: nektarToplamaPuani,
      balIslemePuani: balIslemePuani,
      kisDayanimPuani: kisDayanimPuani,
      temelSahaOnerisi: temelSahaOnerisi,
      l: l,
    ));

    return KoloniKararSonucu(
      koloniId: koloniId,
      kovanNo: kovanNo,
      kararKodu: kararKodu,
      kararBaslik: kararBaslik,
      kararMesaji: kararMesaji,
      kararNedeni: kararNedeni,
      kararTipi: kararTipi,
      secilimKodu: secilimKodu,
      secilimBaslik: secilimBaslik,
      secilimMesaji: secilimMesaji,
      donorSkoru: donorSkoru,
      donorSirasi: donorSirasi,
      donorVeto: donorVeto,
      gercekDamizlik: secilimKodu == 'DAMIZLIK_ADAYI',
      aksiyonKartlari: aksiyonKartlari,
      profil: {
        ...profil,
        'biyolojiDurumKodu': biyoloji.durumKodu,
        'biyolojiBaslik': biyoloji.baslik,
        'biyolojiMesaj': biyoloji.mesaj,
        'biyolojiVeriVarMi': biyoloji.veriVarMi,
        'biyolojiZamanKritik': biyoloji.zamanKritik,
        'biyolojiMudahaleGerekli': biyoloji.mudahaleGerekli,
        'biyolojiMemeTakibiGecikmis': biyoloji.memeTakibiGecikmis,
        'biyolojiAnaUretimIcinUygun': biyoloji.anaUretimIcinUygun,
        'biyolojiMemeTakipDurumu': biyoloji.memeTakipDurumu,
        'biyolojiAnasizlikGunSayisi': biyoloji.anasizlikGunSayisi,
        'biyolojiAnaUretimGirisimVarMi': biyoloji.anaUretimGirisimVarMi,
        'biyolojiAnasizBirakildiMi': biyoloji.anasizBirakildiMi,
      },
    );
  }


  static List<Map<String, String>> _biyolojikKabiliyetAksiyonlari({
    required bool kritikBiyolojiAktif,
    required String sezonKodu,
    required int sonCita,
    required int petekOrmePuani,
    required int yavruBakimPuani,
    required int nektarToplamaPuani,
    required int balIslemePuani,
    required int kisDayanimPuani,
    required String temelSahaOnerisi,
    AppLocalizations? l,
  }) {
    if (kritikBiyolojiAktif) return const <Map<String, String>>[];

    final List<Map<String, String>> kartlar = <Map<String, String>>[];
    final bool uretimSezonu = sezonKodu == 'uretim';

    void ekle({
      required String baslik,
      required String mesaj,
      String tip = 'notr',
    }) {
      if (mesaj.trim().isEmpty) return;
      if (kartlar.any((k) => k['baslik'] == baslik && k['mesaj'] == mesaj)) return;
      kartlar.add({
        'baslik': baslik,
        'mesaj': mesaj,
        'tip': tip,
      });
    }

    if (uretimSezonu && sonCita >= 5 && petekOrmePuani >= 75) {
      ekle(
        baslik: l?.biyoKabiliyetPetekOrmeBaslik ?? 'Biyolojik Kabiliyet',
        mesaj: l?.biyoKabiliyetPetekOrmeMesaj ?? 'Petek örme kapasitesi güçlü görünüyor. Ham petek verilecekse yavru bloğu kesilmeden dıştan genişletme daha güvenlidir.',
        tip: 'pozitif',
      );
    } else if (sonCita >= 6 && petekOrmePuani > 0 && petekOrmePuani < 55) {
      ekle(
        baslik: l?.biyoGenisletmeRiskiBaslik ?? 'Genişletme Riski',
        mesaj: l?.biyoGenisletmeRiskiMesaj ?? 'Petek örme kapasitesi sınırlı görünüyor. Ham petek yerine kabarmış petek veya sıkı düzen daha güvenlidir.',
        tip: 'uyari',
      );
    }

    if (uretimSezonu && nektarToplamaPuani >= 75 && balIslemePuani >= 65) {
      ekle(
        baslik: l?.biyoBalAkimiKapasitesiBaslik ?? 'Bal Akımı Kapasitesi',
        mesaj: l?.biyoBalAkimiKapasitesiMesaj ?? 'Tarlacı ve bal işleme kapasitesi güçlü görünüyor. Bal akımı döneminde alan, kat ve sırlanma takibi öne alınmalı.',
        tip: 'pozitif',
      );
    }

    if (yavruBakimPuani >= 70 && petekOrmePuani > 0 && petekOrmePuani < 55) {
      ekle(
        baslik: l?.biyoBakiciDengesiBaslik ?? 'Bakıcı Dengesi',
        mesaj: l?.biyoBakiciDengesiMesaj ?? 'Yavru bakım kapasitesi iyi fakat petek örme sınırlı. Yavru alanını bozmayacak kabarmış petek, ham petekten daha güvenli olur.',
        tip: 'uyari',
      );
    }

    if (sezonKodu != 'uretim' && kisDayanimPuani > 0 && kisDayanimPuani < 50) {
      ekle(
        baslik: l?.biyoKisGuvenligi ?? 'Kış Güvenliği',
        mesaj: l?.biyoKisGuvenligiMesaj ?? 'Kış dayanımı sınırlı görünüyor. Öncelik hasat veya genişletme değil stok güvenliği ve sıkı düzendir.',
        tip: 'uyari',
      );
    }

    if (kartlar.isEmpty && temelSahaOnerisi.isNotEmpty) {
      ekle(
        baslik: l?.biyoSahaNotu ?? 'Biyolojik Saha Notu',
        mesaj: temelSahaOnerisi,
        tip: 'notr',
      );
    }

    if (kartlar.length <= 2) return kartlar;
    return kartlar.take(2).toList(growable: false);
  }

  static Future<List<Map<String, dynamic>>> donorAdaylariSiraliGetir({
    int? arilikId,
    bool forceRefresh = false,
  }) async {
    final int cacheKey = arilikId != null && arilikId > 0 ? arilikId : 0;

    if (!forceRefresh) {
      final cached = _donorListeCache[cacheKey];
      if (cached != null) return cached;

      final devamEden = _donorListeFutureCache[cacheKey];
      if (devamEden != null) return devamEden;
    } else {
      _donorListeCache.remove(cacheKey);
      _donorListeFutureCache.remove(cacheKey);
    }

    final future = PerformansIzlemeServisi.olc<List<Map<String, dynamic>>>(
      'donorAdaylariSiraliGetir(arilikId: ${arilikId ?? 0})',
      () => _donorAdaylariSiraliHesapla(arilikId: arilikId),
      yavasEsikMs: 500,
    );

    _donorListeFutureCache[cacheKey] = future;

    try {
      final sonuc = await future;
      _donorListeCache[cacheKey] = sonuc;
      return sonuc;
    } finally {
      _donorListeFutureCache.remove(cacheKey);
    }
  }

  static Future<List<Map<String, dynamic>>> _donorAdaylariSiraliHesapla({
    int? arilikId,
  }) async {
    final List<Map<String, dynamic>> koloniler = arilikId != null
        ? await VeritabaniServisi.kovanlariAriligaGoreGetir(arilikId)
        : await VeritabaniServisi.kolonileriGetir();

    if (koloniler.isEmpty) return [];

    final List<Map<String, dynamic>> havuz = [];

    // Profil üretimi pahalıdır. Her koloni için await döngüsü devam eder;
    // ancak profil/future cache sayesinde aynı hesap aynı turda veya ekranlar
    // arasında ikinci kez çalıştırılmaz.
    for (final koloni in koloniler) {
      final int koloniId = _toInt(koloni['id']);
      if (koloniId <= 0) continue;

      final profil = await _koloniProfiliGetir(koloniId, koloni);
      if (profil['aktifMi'] != true) continue;
      if (profil['donorVeto'] == true) continue;

      havuz.add({
        'koloniId': koloniId,
        'kovanNo': (koloni['kovanNo'] ?? '-').toString(),
        'donorSkoru': _toInt(profil['donorSkoru']),
        'mizac': (profil['mizac'] ?? '-').toString(),
        'skor': _toInt(profil['skor']),
        'sonCita': _toInt(profil['sonCita']),
        'maxCita': _toInt(profil['maxCita']),
      });
    }

    havuz.sort((a, b) {
      final skorKarsilastir =
      _toInt(b['donorSkoru']).compareTo(_toInt(a['donorSkoru']));
      if (skorKarsilastir != 0) return skorKarsilastir;

      final maxKarsilastir =
      _toInt(b['maxCita']).compareTo(_toInt(a['maxCita']));
      if (maxKarsilastir != 0) return maxKarsilastir;

      return _toInt(b['skor']).compareTo(_toInt(a['skor']));
    });

    for (int i = 0; i < havuz.length; i++) {
      havuz[i]['sira'] = i + 1;
    }

    return havuz;
  }

  static Future<Map<String, dynamic>> _koloniProfiliGetir(
    int koloniId,
    Map<String, dynamic> koloni, {
    bool forceRefresh = false,
  }) async {
    if (forceRefresh) {
      _koloniProfilCache.remove(koloniId);
      _koloniProfilFutureCache.remove(koloniId);
    }

    final cached = _koloniProfilCache[koloniId];
    if (!forceRefresh && cached != null) return cached;

    final devamEden = _koloniProfilFutureCache[koloniId];
    if (!forceRefresh && devamEden != null) return devamEden;

    final future = PerformansIzlemeServisi.olc<Map<String, dynamic>>(
      'koloniProfiliOlustur(koloniId: $koloniId)',
      () => _koloniProfiliOlustur(koloniId, koloni),
      yavasEsikMs: 300,
    );

    _koloniProfilFutureCache[koloniId] = future;

    try {
      final sonuc = await future;
      _koloniProfilCache[koloniId] = sonuc;
      return sonuc;
    } finally {
      _koloniProfilFutureCache.remove(koloniId);
    }
  }

  static Future<Map<String, dynamic>> _koloniProfiliOlustur(
      int koloniId,
      Map<String, dynamic> koloni,
      ) async {
    final muayeneler = await VeritabaniServisi.muayeneleriGetir(koloniId);
    final trendData = await TrendServisi.koloniTrendiGetir(koloniId);
    final biyolojikModel = await KoloniBiyolojikModelServisi.modelGetir(koloniId);
    final hatSonme = await VeritabaniServisi.hatSonmeAnaliziGetir(koloniId);
    final ogulRisk = await VeritabaniServisi.ogulRiskOzetiGetir(koloniId);

    final String davranisToleransi = await VeritabaniServisi.ayarStringGetir(
      'davranis_toleransi',
      varsayilan: 'standart',
    );

    final Map<String, dynamic>? sonMuayene =
    muayeneler.isNotEmpty ? muayeneler.first : null;

    final DateTime? sonMuayeneTarihi =
        sonMuayene == null ? null : _guvenliTarihParse(sonMuayene['tarih']);
    final String sezonKodu = await VeritabaniServisi.aktifSezonKoduGetir(
      sonMuayeneTarihi ?? DateTime.now(),
    );

    final bool aktifMi = await VeritabaniServisi.koloniAktifMi(koloniId);

    final int skor = _toInt(koloni['skor']);
    final int fizikselSonCita = _toInt(koloni['sonCita']);
    final int sonCita = _toInt(biyolojikModel['islevselToplamCita'] ?? koloni['sonCita']);
    final int maxCita = _toInt(koloni['maxCitaKapasiye']);
    final int balCita = _toInt(koloni['bal_cita']);

    final String anaYiliMetni = (koloni['anaYili'] ?? '').toString().trim();
    final int simdikiYil = DateTime.now().year;
    final int? anaYili = int.tryParse(anaYiliMetni);
    final int anaYasi = anaYili == null ? 0 : (simdikiYil - anaYili);

    final bool kovanSondu =
        sonMuayene != null && _toInt(sonMuayene['kovanSondu']) == 1;

    final bool dogrudanOgulKokenli =
        ogulRisk['dogrudanOgulKokenli'] == true;
    final bool kendisiOgulAtti = ogulRisk['kendisiOgulAtti'] == true;
    final bool ataHattaOgulAtti = ogulRisk['ataHattaOgulAtti'] == true;

    final String kaynakTipi = (koloni['kaynakTipi'] ?? '').toString().trim();
    final bool kaynakTipiOgul = _kaynakTipiOgulMu(kaynakTipi);

    final bool donorVeto = dogrudanOgulKokenli ||
        kendisiOgulAtti ||
        kaynakTipiOgul ||
        ataHattaOgulAtti;

    final String mizac =
    (sonMuayene?['mizac'] ?? 'Sakin').toString().trim().isEmpty
        ? 'Sakin'
        : (sonMuayene?['mizac'] ?? 'Sakin').toString().trim();

    final String trend = (trendData['trend'] ?? 'Stabil').toString();

    final int muayeneSayisi = muayeneler.length;
    final Map<String, dynamic> kisCikisBilgisi =
    await _kisCikisBilgisiHesapla(muayeneler);
    final Map<String, dynamic> zamanBaglami =
    await VeritabaniServisi.kararZamanBaglamiGetir(
      tarih: DateTime.now(),
      arilikId: _nullableInt(koloni['arilikId']),
    );

    final double uremePuani = _uremePuaniHesapla(
      maxCita: maxCita,
      trendData: trendData,
      muayeneler: muayeneler,
    );

    final double uretimPuaniH = _uretimPuaniHesapla(
      balCita: balCita,
      muayeneler: muayeneler,
      skor: skor,
    );

    final double dayaniklilikPuani = _dayaniklilikPuaniHesapla(
      skor: skor,
      sonCita: sonCita,
      maxCita: maxCita,
      trend: trend,
      kovanSondu: kovanSondu,
      anaYasi: anaYasi,
      kisCikisPuani: _nullableInt(kisCikisBilgisi['kisCikisPuani']),
    );

    final double soyPuani = _soyPuaniHesapla(
      hatSonme: hatSonme,
      ogulRisk: ogulRisk,
    );

    final double davranisPuani = _davranisPuaniHesapla(
      mizac: mizac,
      davranisToleransi: davranisToleransi,
    );

    final double veriGuveniPuaniH = _veriGuveniPuaniHesapla(muayeneSayisi);

    final int donorSkoru = donorVeto
        ? 0
        : (uremePuani +
        uretimPuaniH +
        dayaniklilikPuani +
        soyPuani +
        davranisPuani +
        veriGuveniPuaniH)
        .round();

    return {
      'arilikId': _nullableInt(koloni['arilikId']),
      'skor': skor,
      'sonCita': sonCita,
      'fizikselSonCita': fizikselSonCita,
      'islevselSonCita': sonCita,
      'maxCita': maxCita,
      'balCita': balCita,
      'anaYasi': anaYasi,
      'muayeneSayisi': muayeneSayisi,
      'mizac': mizac,
      'trend': trend,
      'gunlukMomentum': trendData['gunlukMomentum'],
      'momentumSkoru': trendData['momentumSkoru'],
      'momentumEtiketi': trendData['momentumEtiketi'],
      'momentumAciklama': trendData['momentumAciklama'],
      'momentumPencereleri': trendData['pencereler'],
      'kovanTipi': biyolojikModel['kovanTipi'],
      'suruplukVarMi': biyolojikModel['suruplukVarMi'],
      'kuluclukKapasitesi': biyolojikModel['kuluclukKapasitesi'],
      'citaAktivasyon': biyolojikModel['citaAktivasyon'],
      'hacimDegisimTipi': biyolojikModel['hacimDegisimTipi'],
      'uretimGuvenliMi': biyolojikModel['uretimGuvenliMi'],
      'balAkimiGenislemesi': biyolojikModel['balAkimiGenislemesi'],
      'hasatKaynakliDusus': biyolojikModel['hasatKaynakliDusus'],
      'riskliSisirme': biyolojikModel['riskliSisirme'],
      'islevselUretimCita': biyolojikModel['islevselUretimCita'],
      'islevselToplamCita': biyolojikModel['islevselToplamCita'],
      'fizikselToplamCita': biyolojikModel['fizikselToplamCita'],
      'tahminiAriMin': biyolojikModel['tahminiAriMin'],
      'tahminiAriMax': biyolojikModel['tahminiAriMax'],
      'hasatPotansiyeliMinKg': biyolojikModel['hasatPotansiyeliMinKg'],
      'hasatPotansiyeliMaxKg': biyolojikModel['hasatPotansiyeliMaxKg'],
      'birakilmasiGerekenBalMinKg': biyolojikModel['birakilmasiGerekenBalMinKg'],
      'birakilmasiGerekenBalMaxKg': biyolojikModel['birakilmasiGerekenBalMaxKg'],
      'biyolojikKabiliyet': biyolojikModel['kabiliyet'],
      'petekOrmePuani': _toInt((biyolojikModel['kabiliyet'] ?? const <String, dynamic>{})['petekOrmePuani']),
      'yavruBakimPuani': _toInt((biyolojikModel['kabiliyet'] ?? const <String, dynamic>{})['yavruBakimPuani']),
      'nektarToplamaPuani': _toInt((biyolojikModel['kabiliyet'] ?? const <String, dynamic>{})['nektarToplamaPuani']),
      'balIslemePuani': _toInt((biyolojikModel['kabiliyet'] ?? const <String, dynamic>{})['balIslemePuani']),
      'kisDayanimPuani': _toInt((biyolojikModel['kabiliyet'] ?? const <String, dynamic>{})['kisDayanimPuani']),
      'ciftlesmeDestegiPuani': _toInt((biyolojikModel['kabiliyet'] ?? const <String, dynamic>{})['ciftlesmeDestegiPuani']),
      'petekOrmeDurumu': ((biyolojikModel['kabiliyet'] ?? const <String, dynamic>{})['petekOrmeDurumu'] ?? '').toString(),
      'genisletmeGuvenligi': ((biyolojikModel['kabiliyet'] ?? const <String, dynamic>{})['genisletmeGuvenligi'] ?? '').toString(),
      'balAkimiKapasitesi': ((biyolojikModel['kabiliyet'] ?? const <String, dynamic>{})['balAkimiKapasitesi'] ?? '').toString(),
      'bakiciDengesi': ((biyolojikModel['kabiliyet'] ?? const <String, dynamic>{})['bakiciDengesi'] ?? '').toString(),
      'biyolojikTemelSahaOnerisi': ((biyolojikModel['kabiliyet'] ?? const <String, dynamic>{})['temelSahaOnerisi'] ?? '').toString(),
      'biyolojikKabiliyetOzeti': ((biyolojikModel['kabiliyet'] ?? const <String, dynamic>{})['ozet'] ?? '').toString(),
      'sezonKodu': sezonKodu,
      'davranisToleransi': davranisToleransi,
      'aktifMi': aktifMi,
      'kovanSondu': kovanSondu,
      'dogrudanOgulKokenli': dogrudanOgulKokenli,
      'kendisiOgulAtti': kendisiOgulAtti,
      'ataHattaOgulAtti': ataHattaOgulAtti,
      'kaynakTipiOgul': kaynakTipiOgul,
      'donorVeto': donorVeto,
      'vetoKodu': (ogulRisk['vetoKodu'] ?? '').toString(),
      'vetoReferansKoloniNo':
      (ogulRisk['vetoReferansKoloniNo'] ?? '').toString(),
      'soyZinciriMetni': (ogulRisk['soyZinciriMetni'] ?? '').toString(),
      'donorSkoru': donorSkoru,
      'uremePuani': uremePuani.round(),
      'uretimPuani': uretimPuaniH.round(),
      'dayaniklilikPuani': dayaniklilikPuani.round(),
      'soyPuani': soyPuani.round(),
      'davranisPuani': davranisPuani.round(),
      'veriGuveniPuani': veriGuveniPuaniH.round(),
      'veriGuveniEtiketi': _veriGuveniEtiketi(muayeneSayisi),
      'veriGuveniNotu': _veriGuveniNotu(muayeneSayisi),
      'kararTarih': (zamanBaglami['tarih'] ?? '').toString(),
      'bolmePenceresi': (zamanBaglami['bolmePenceresi'] ?? '').toString(),
      'bolmePencereMesaji':
      (zamanBaglami['bolmePencereMesaji'] ?? '').toString(),
      'anaDegisimPenceresi':
      (zamanBaglami['anaDegisimPenceresi'] ?? '').toString(),
      'anaDegisimPencereMesaji':
      (zamanBaglami['anaDegisimPencereMesaji'] ?? '').toString(),
      'balAkiminaKalanGun': zamanBaglami['balAkiminaKalanGun'],
      'balAkiminda': zamanBaglami['balAkiminda'] == true,
      'hasatSonrasi': zamanBaglami['hasatSonrasi'] == true,
      ...kisCikisBilgisi,
    };
  }

  static Future<Map<String, dynamic>> _kisCikisBilgisiHesapla(
      List<Map<String, dynamic>> muayeneler, {
      AppLocalizations? l,
      }) async {
    final String veriYetersizMesaj = l?.perfKisCikisVeriYetersiz ?? 'Kış çıkış verisi yetersiz.';
    if (muayeneler.isEmpty) {
      return {
        'kisCikisPuani': null,
        'kisCikisOrani': null,
        'kisCikisVeriYeterliMi': false,
        'kisCikisYorum': veriYetersizMesaj,
        'kisGirisReferansTarih': null,
        'kisGirisReferansCita': null,
        'kisSonuReferansTarih': null,
        'kisSonuReferansCita': null,
      };
    }

    final String kisBaslangic = await VeritabaniServisi.ayarStringGetir(
      'season_kis_baslangic',
      varsayilan: '09-01',
    );
    final String kisBitis = await VeritabaniServisi.ayarStringGetir(
      'season_kis_bitis',
      varsayilan: '02-28',
    );
    final String uretimBitis = await VeritabaniServisi.ayarStringGetir(
      'season_uretim_bitis',
      varsayilan: '08-31',
    );

    final List<Map<String, dynamic>> sirali =
    List<Map<String, dynamic>>.from(muayeneler)
      ..sort((a, b) {
        final at = _guvenliTarihParse(a['tarih']);
        final bt = _guvenliTarihParse(b['tarih']);
        if (at == null && bt == null) return 0;
        if (at == null) return 1;
        if (bt == null) return -1;
        return at.compareTo(bt);
      });

    final DateTime? enErken = _guvenliTarihParse(sirali.first['tarih']);
    final DateTime? enGec = _guvenliTarihParse(sirali.last['tarih']);

    if (enErken == null || enGec == null) {
      return {
        'kisCikisPuani': null,
        'kisCikisOrani': null,
        'kisCikisVeriYeterliMi': false,
        'kisCikisYorum': veriYetersizMesaj,
        'kisGirisReferansTarih': null,
        'kisGirisReferansCita': null,
        'kisSonuReferansTarih': null,
        'kisSonuReferansCita': null,
      };
    }

    final bool kisYilTasmasi =
        _mmDdSirasi(kisBaslangic) > _mmDdSirasi(kisBitis);

    for (int hedefYil = enGec.year + 1;
    hedefYil >= enErken.year - 1;
    hedefYil--) {
      final int uretimBitisYili = kisYilTasmasi ? hedefYil - 1 : hedefYil;

      final DateTime uretimBitisTarihi =
      _ayGunToDate(uretimBitisYili, uretimBitis);
      final DateTime kisBitisTarihi = _ayGunToDate(hedefYil, kisBitis);

      final Map<String, dynamic>? giris = _hedefTariheEnYakinGuvenilirMuayene(
        sirali,
        uretimBitisTarihi,
        pencereGun: 21,
      );
      final Map<String, dynamic>? cikis = _hedefTariheEnYakinGuvenilirMuayene(
        sirali,
        kisBitisTarihi,
        pencereGun: 21,
      );

      if (giris == null || cikis == null) continue;

      final int girisCita = _toInt(giris['citaSayisi']);
      final int cikisCita = _toInt(cikis['citaSayisi']);

      if (girisCita <= 0 || cikisCita <= 0) continue;

      final double oran = cikisCita / girisCita;
      final int puan = _kisCikisPuaniVer(oran);
      final String yorum = _kisCikisYorumuVer(oran, l: l);

      return {
        'kisCikisPuani': puan,
        'kisCikisOrani': oran,
        'kisCikisVeriYeterliMi': true,
        'kisCikisYorum': yorum,
        'kisGirisReferansTarih': (giris['tarih'] ?? '').toString(),
        'kisGirisReferansCita': girisCita,
        'kisSonuReferansTarih': (cikis['tarih'] ?? '').toString(),
        'kisSonuReferansCita': cikisCita,
      };
    }

    return {
      'kisCikisPuani': null,
      'kisCikisOrani': null,
      'kisCikisVeriYeterliMi': false,
      'kisCikisYorum': veriYetersizMesaj,
      'kisGirisReferansTarih': null,
      'kisGirisReferansCita': null,
      'kisSonuReferansTarih': null,
      'kisSonuReferansCita': null,
    };
  }

  static Map<String, dynamic>? _hedefTariheEnYakinGuvenilirMuayene(
      List<Map<String, dynamic>> muayeneler,
      DateTime hedefTarih, {
        int pencereGun = 21,
      }) {
    Map<String, dynamic>? enIyi;
    int? enIyiFarkGun;
    bool? enIyiOnceMi;

    for (final m in muayeneler) {
      final DateTime? tarih = _guvenliTarihParse(m['tarih']);
      if (tarih == null) continue;
      if (_toInt(m['kovanSondu']) == 1) continue;

      final int cita = _toInt(m['citaSayisi']);
      if (cita <= 0) continue;

      final int fark = tarih.difference(hedefTarih).inDays.abs();
      if (fark > pencereGun) continue;

      final bool onceMi =
          tarih.isBefore(hedefTarih) || tarih.isAtSameMomentAs(hedefTarih);

      if (enIyi == null) {
        enIyi = m;
        enIyiFarkGun = fark;
        enIyiOnceMi = onceMi;
        continue;
      }

      if (fark < (enIyiFarkGun ?? 99999)) {
        enIyi = m;
        enIyiFarkGun = fark;
        enIyiOnceMi = onceMi;
        continue;
      }

      if (fark == enIyiFarkGun) {
        if (onceMi && (enIyiOnceMi == false)) {
          enIyi = m;
          enIyiFarkGun = fark;
          enIyiOnceMi = onceMi;
        }
      }
    }

    return enIyi;
  }

  static int _kisCikisPuaniVer(double oran) {
    if (oran >= 0.85) return 4;
    if (oran >= 0.70) return 3;
    if (oran >= 0.55) return 2;
    if (oran >= 0.40) return 1;
    return 0;
  }

  static String _kisCikisYorumuVer(double oran, {AppLocalizations? l}) {
    if (oran >= 0.85) return l?.kisYorumCokGuclu ?? 'Çok güçlü çıkış';
    if (oran >= 0.70) return l?.kisYorumGuclu ?? 'Güçlü çıkış';
    if (oran >= 0.55) return l?.kisYorumOrta ?? 'Orta çıkış';
    if (oran >= 0.40) return l?.kisYorumZayif ?? 'Zayıf çıkış';
    return l?.kisYorumRiskli ?? 'Riskli çıkış';
  }

  static int _mmDdSirasi(String mmDd) {
    final parts = mmDd.split('-');
    final ay = int.tryParse(parts.first) ?? 1;
    final gun = int.tryParse(parts.last) ?? 1;
    return ay * 100 + gun;
  }

  static DateTime _ayGunToDate(int yil, String mmDd) {
    final parts = mmDd.split('-');
    final ay = int.tryParse(parts.first) ?? 1;
    final gun = int.tryParse(parts.last) ?? 1;
    return DateTime(yil, ay, gun);
  }

  static DateTime? _guvenliTarihParse(dynamic deger) {
    final metin = (deger ?? '').toString().trim();
    if (metin.isEmpty) return null;

    final dogrudan = DateTime.tryParse(metin);
    if (dogrudan != null) {
      return DateTime(dogrudan.year, dogrudan.month, dogrudan.day);
    }

    if (metin.contains('.')) {
      final parcalar = metin.split('.');
      if (parcalar.length == 3) {
        final gun = int.tryParse(parcalar[0]);
        final ay = int.tryParse(parcalar[1]);
        final yil = int.tryParse(parcalar[2]);
        if (gun != null && ay != null && yil != null) {
          return DateTime(yil, ay, gun);
        }
      }
    }

    return null;
  }

  static bool _kaynakTipiOgulMu(String kaynakTipi) {
    final temiz = kaynakTipi.toLowerCase().trim();
    return temiz.contains('oğul') || temiz.contains('ogul');
  }

  static double _uremePuaniHesapla({
    required int maxCita,
    required Map<String, dynamic> trendData,
    required List<Map<String, dynamic>> muayeneler,
  }) {
    final double maxCitaPuani = _oranPuani(
      deger: maxCita.toDouble(),
      hedef: 24,
      maxPuan: 15,
    );

    final double momentumSkoru = _toDouble(trendData['momentumSkoru']);
    final double trendPuani = _clampDouble((momentumSkoru / 100) * 10, 0, 10);

    int enYuksekYavrulu = 0;
    for (final m in muayeneler) {
      final y = _toInt(m['yavruluCita']);
      if (y > enYuksekYavrulu) enYuksekYavrulu = y;
    }

    final double yavruPuani = _oranPuani(
      deger: enYuksekYavrulu.toDouble(),
      hedef: 10,
      maxPuan: 5,
    );

    return maxCitaPuani + trendPuani + yavruPuani;
  }

  static double _uretimPuaniHesapla({
    required int balCita,
    required List<Map<String, dynamic>> muayeneler,
    required int skor,
  }) {
    final double balPuani = _oranPuani(
      deger: balCita.toDouble(),
      hedef: 10,
      maxPuan: 15,
    );

    int balKaydiSayisi = 0;
    for (final m in muayeneler.take(8)) {
      if (_toInt(m['bal_cita']) > 0) {
        balKaydiSayisi++;
      }
    }

    final double sureklilikPuani =
    skor >= 70 ? 5 : _clampDouble((balKaydiSayisi / 3) * 5, 0, 5);

    return balPuani + sureklilikPuani;
  }

  static double _dayaniklilikPuaniHesapla({
    required int skor,
    required int sonCita,
    required int maxCita,
    required String trend,
    required bool kovanSondu,
    required int anaYasi,
    required int? kisCikisPuani,
  }) {
    final double skorPuani = _clampDouble((skor / 100) * 8, 0, 8);

    final double oran = maxCita <= 0 ? 0 : sonCita / maxCita;
    final double korumaPuani = _clampDouble((oran / 0.65) * 4, 0, 4);

    double stabilitePuani = 4;
    if (kovanSondu) {
      stabilitePuani = 0;
    } else if (trend == 'Düşüş') {
      stabilitePuani = 1.5;
    }
    if (anaYasi >= 3 && skor < 70) {
      stabilitePuani -= 1;
    }
    stabilitePuani = _clampDouble(stabilitePuani, 0, 4);

    final double altToplam = skorPuani + korumaPuani + stabilitePuani;

    if (kisCikisPuani == null) {
      return _clampDouble((altToplam / 16) * 20, 0, 20);
    }

    return altToplam + _clampDouble(kisCikisPuani.toDouble(), 0, 4);
  }

  static double _soyPuaniHesapla({
    required Map<String, dynamic> hatSonme,
    required Map<String, dynamic> ogulRisk,
  }) {
    final double sonmeOrani = _toDouble(hatSonme['sonmeOrani']);
    double temel = 10 - _clampDouble(sonmeOrani / 10, 0, 10);

    if (ogulRisk['ataHattaOgulAtti'] == true) {
      temel -= 3;
    }

    final bool zincirAcik = (hatSonme['hatToplamKoloni'] != null);
    final double zincirPuani = zincirAcik ? 5 : 2;

    return _clampDouble(temel, 0, 10) + zincirPuani;
  }

  static double _davranisPuaniHesapla({
    required String mizac,
    required String davranisToleransi,
  }) {
    final String m = mizac.toLowerCase().trim();
    final bool esnek = davranisToleransi == 'esnek';

    if (esnek) {
      if (m.contains('saldırgan') || m.contains('saldirgan')) return 6;
      if (m.contains('sinirli')) return 8;
      return 10;
    }

    if (m.contains('saldırgan') || m.contains('saldirgan')) return 2;
    if (m.contains('sinirli')) return 6;
    return 10;
  }

  static double _veriGuveniPuaniHesapla(int muayeneSayisi) {
    if (muayeneSayisi >= 5) return 5;
    if (muayeneSayisi >= 2) return 3;
    if (muayeneSayisi >= 1) return 1;
    return 0;
  }

  static String _veriGuveniEtiketi(int muayeneSayisi, {AppLocalizations? l}) {
    if (muayeneSayisi <= 0) return l?.veriGuveniYok ?? 'Veri yok';
    if (muayeneSayisi == 1) return l?.veriGuveniCokSinirli ?? 'Veri çok sınırlı';
    if (muayeneSayisi <= 4) return l?.veriGuveniIzlenmeli ?? 'Veri izlenmeli';
    return l?.veriGuveniYeterli ?? 'Veri güveni yeterli';
  }

  static String _veriGuveniNotu(int muayeneSayisi, {AppLocalizations? l}) {
    if (muayeneSayisi <= 0) {
      return l?.veriGuveniNotYok ?? 'Kayıt yoksa sistem yalnızca kimlik ve kaynak bilgisine göre sınırlı yorum yapabilir.';
    }
    if (muayeneSayisi == 1) {
      return l?.veriGuveniNotTek ?? 'Tek muayene karar üretir ama güven zayıftır; donör ve ana değişim kararlarında temkinli okunmalıdır.';
    }
    if (muayeneSayisi <= 4) {
      return l?.veriGuveniNotAz ?? '2–4 muayene izleme bandıdır; karar var ama sonraki kayıtlarla güçlenmelidir.';
    }
    return l?.veriGuveniNotYeterli ?? '5 ve üzeri muayene ile değerlendirme güvenilir banda girmiştir.';
  }

  static String _davranisNotuMetni({
    required String mizac,
    required String davranisToleransi,
    AppLocalizations? l,
  }) {
    final m = mizac.toLowerCase().trim();

    if (m.contains('saldırgan') || m.contains('saldirgan')) {
      return davranisToleransi == 'esnek'
          ? (l?.davranisNotuSaldirganEsnek ?? ' Davranış açısından not düşülmüş durumda; ancak kullanıcı ayarı esnek olduğu için veto uygulanmadı.')
          : (l?.davranisNotuSaldirgan ?? ' Davranış açısından dikkat notu bulunuyor.');
    }

    if (m.contains('sinirli')) {
      return l?.davranisNotuSinirli ?? ' Davranış açısından hafif bir dikkat notu bulunuyor.';
    }

    return '';
  }

  static double _oranPuani({
    required double deger,
    required double hedef,
    required double maxPuan,
  }) {
    if (hedef <= 0) return 0;
    return _clampDouble((deger / hedef) * maxPuan, 0, maxPuan);
  }

  static double _clampDouble(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }


  /// Hafif genetik çoğaltma skoru.
  /// Ayrı bir servis değildir; KoloniKararMotoru içinde genetik/seçilim
  /// değerlendirmesinin yardımcı hesabı olarak çalışır. Operasyon kararı vermez.
  static Map<String, dynamic> genetikCogaltmaSkoruHesapla({
    required bool yavruDuzeniStabil,
    required bool gucluTrend,
    required bool genetikVeto,
    required bool riskliSisirme,
    required bool gucDususu,
    required bool bolmeToparlanmaHedefi,
    required bool riskliAnaSureciHedefi,
    required bool hasatSonrasi,
    required bool kisDonemi,
    required int islevselUretimCita,
    required double aktivasyonOrani,
    required int stokCita,
  }) {
    final kalemler = <String, int>{};
    final riskler = <String>[];

    if (genetikVeto) {
      return {
        'puan': 0,
        'bant': 'veto',
        'veto': true,
        'kalemler': kalemler,
        'riskler': ['Oğul kökeni/izi genetik yayılım için veto kabul edildi.'],
        'ozet': 'Üretim değeri ayrı tutulur; genetik çoğaltma kararı veto edilir.',
      };
    }

    if (islevselUretimCita >= 10) {
      kalemler['biyolojikKapasite'] = 22;
    } else if (islevselUretimCita >= 8) {
      kalemler['biyolojikKapasite'] = 18;
    } else if (islevselUretimCita >= 6) {
      kalemler['biyolojikKapasite'] = 10;
    } else {
      kalemler['biyolojikKapasite'] = 0;
      riskler.add('İşlevsel çıta kapasitesi çoğaltma için düşük.');
    }

    if (yavruDuzeniStabil) {
      kalemler['yavruIstikrari'] = 22;
    } else {
      kalemler['yavruIstikrari'] = 0;
      riskler.add('Yavru düzeni netleşmeden genetik yayılım öne çıkarılmaz.');
    }

    if (gucluTrend && !gucDususu) {
      kalemler['gelisimIstikrari'] = 20;
    } else if (!gucDususu) {
      kalemler['gelisimIstikrari'] = 10;
    } else {
      kalemler['gelisimIstikrari'] = 0;
      riskler.add('Son kayıtta güç düşüşü var; çoğaltma yerine neden analizi gerekir.');
    }

    if (aktivasyonOrani >= 0.90) {
      kalemler['aktivasyonKalitesi'] = 14;
    } else if (aktivasyonOrani >= 0.80) {
      kalemler['aktivasyonKalitesi'] = 10;
    } else if (aktivasyonOrani >= 0.65) {
      kalemler['aktivasyonKalitesi'] = 5;
    } else {
      kalemler['aktivasyonKalitesi'] = 0;
      riskler.add('Aktivasyon düşük; fiziksel çıta genetik kapasite gibi okunmamalı.');
    }

    if (kisDonemi || hasatSonrasi) {
      if (stokCita >= 3) {
        kalemler['kisStokGuvenligi'] = 12;
      } else if (stokCita >= 2) {
        kalemler['kisStokGuvenligi'] = 7;
      } else {
        kalemler['kisStokGuvenligi'] = 0;
        riskler.add('Kış/hasat sonrası stok güvenliği zayıf.');
      }
    } else {
      kalemler['kisStokGuvenligi'] = stokCita >= 2 ? 8 : 4;
    }

    int surecGuvenligi = 10;
    if (riskliAnaSureciHedefi) {
      surecGuvenligi -= 8;
      riskler.add('Ana/yavru süreci açık; genetik karar izleme bandına çekilir.');
    }
    if (bolmeToparlanmaHedefi && !yavruDuzeniStabil) {
      surecGuvenligi -= 5;
      riskler.add('Bölme toparlanması tamamlanmadan yeni çoğaltma hedefi açılmaz.');
    }
    if (riskliSisirme) {
      surecGuvenligi -= 6;
      riskler.add('Riskli şişirme var; fiziksel genişleme genetik başarı sayılmaz.');
    }
    kalemler['surecGuvenligi'] = surecGuvenligi.clamp(0, 10).toInt();

    final puan = kalemler.values.fold<int>(0, (a, b) => a + b).clamp(0, 100).toInt();
    final String bant;
    if (puan >= 82 && riskler.length <= 1) {
      bant = 'yüksek';
    } else if (puan >= 68) {
      bant = 'izle';
    } else {
      bant = 'dusuk';
    }

    return {
      'puan': puan,
      'bant': bant,
      'veto': false,
      'kalemler': kalemler,
      'riskler': riskler,
      'ozet': _genetikCogaltmaSkoruOzetUret(bant, puan, riskler),
    };
  }

  static String _genetikCogaltmaSkoruOzetUret(
    String bant,
    int puan,
    List<String> riskler,
  ) {
    if (bant == 'yüksek') {
      return 'Biyolojik kapasite, yavru düzeni, istikrar ve süreç güvenliği çoğaltma için güçlü sinyal veriyor.';
    }
    if (bant == 'izle') {
      return 'Olumlu genetik sinyaller var; karar için istikrar, süreç kapanışı ve sezon penceresi birlikte izlenmeli.';
    }
    if (riskler.isNotEmpty) {
      return 'Çoğaltma değeri düşük/temkinli: ${riskler.first}';
    }
    return 'Çoğaltma değeri şu aşamada öncelikli değil.';
  }

  static int _toInt(dynamic deger) {
    if (deger == null) return 0;
    if (deger is int) return deger;
    if (deger is double) return deger.round();
    return int.tryParse(deger.toString()) ?? 0;
  }

  static int? _nullableInt(dynamic deger) {
    if (deger == null) return null;
    if (deger is int) return deger;
    return int.tryParse(deger.toString());
  }

  static double _toDouble(dynamic deger) {
    if (deger == null) return 0.0;
    if (deger is double) return deger;
    if (deger is int) return deger.toDouble();
    return double.tryParse(deger.toString()) ?? 0.0;
  }
}
