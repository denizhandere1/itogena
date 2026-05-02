import 'trend_servisi.dart';
import 'esik_servisi.dart';
import 'veritabani_servisi.dart';
import 'ari_biyoloji_servisi.dart';

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
  static final Map<int, Map<String, dynamic>> _arilikOzetCache = {};
  static final Map<String, KoloniKararSonucu> _koloniKararCache = {};

  static void tumCacheTemizle() {
    _donorListeCache.clear();
    _arilikOzetCache.clear();
    _koloniKararCache.clear();
  }

  static void arilikCacheTemizle(int? arilikId) {
    if (arilikId == null || arilikId <= 0) return;
    _donorListeCache.remove(arilikId);
    _arilikOzetCache.remove(arilikId);
    _koloniKararCache.removeWhere((key, value) {
      final profilArilikId = _nullableInt(value.profil['arilikId']);
      return profilArilikId == arilikId;
    });
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
      }) async {
    final int? arilikId = _nullableInt(koloni['arilikId']);
    final List<Map<String, dynamic>> donorListesi =
        siraliDonorler ?? await donorAdaylariSiraliGetir(arilikId: arilikId);

    Map<String, dynamic>? kendiSirasi;
    for (final item in donorListesi) {
      if (_toInt(item['koloniId']) == koloniId) {
        kendiSirasi = item;
        break;
      }
    }

    final int donorSirasi =
    kendiSirasi == null ? 0 : _toInt(kendiSirasi['sira']);

    final profil = await _koloniProfiliOlustur(koloniId, koloni);
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
    final String davranisToleransi =
    (profil['davranisToleransi'] ?? 'standart').toString();

    final int donorHavuzuBoyutu = donorListesi.length;

    final esikler = await EsikServisi.tumEsikleriYukle();
    final int bolmeCita = esikler['bolme_adayi_min_cita'] ?? EsikServisi.bolmeAdayiMinCita;
    final int destekCita = esikler['destek_max_maks_cita'] ?? 4;
    final int uretimMinSkor = esikler['uretim_min_skor'] ?? 70;
    final int mudahaleMinSkor = esikler['mudahale_min_skor'] ?? 45;
    final int anaDegisimYasi = esikler['ana_degisim_sezon_esigi'] ?? 2;

    final biyoloji = await AriBiyolojiServisi.analizYap(koloniId);

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
      kararBaslik = 'Bu koloni aktif değil';
      kararMesaji =
      'Aktif üretimde değerlendirme. Kayıt olarak tut, gerekiyorsa birleştirme planında düşün.';
      kararNedeni = aktifMi
          ? 'Koloni aktif görünmüyor.'
          : (kovanSondu
          ? 'Son muayene verisinde koloni sönmüş görünüyor.'
          : 'Koloni durumu pasif olarak işaretli.');
      kararTipi = 'negatif';

      secilimKodu = 'PASIF_KAYIT';
      secilimBaslik = 'Pasif kayıt';
      secilimMesaji =
      'Bu koloni aktif üretimde değildir. Soy ve geçmiş takibi için tutulur.';
    } else if (donorVeto) {
      final String vetoNedeni;
      if (dogrudanOgulKokenli || kaynakTipiOgul) {
        vetoNedeni = 'Kökeni oğul olduğu için temiz donör havuzuna alınmadı.';
      } else if (kendisiOgulAtti) {
        vetoNedeni =
        'Kendi geçmişinde oğul attığı için temiz donör havuzuna alınmadı.';
      } else if (ataHattaOgulAtti) {
        vetoNedeni =
        'Atasal hatta oğul izi taşıdığı için temiz donör havuzuna alınmadı.';
      } else {
        vetoNedeni = 'Temiz donör havuzuna alınmadı.';
      }

      if (sonCita >= bolmeCita || maxCita >= bolmeCita) {
        kararKodu = 'BOLME_ICIN_UYGUN';
        kararBaslik = 'Genetik veto var; destekleyici veya üretim kolonisi olarak kullan';
        kararMesaji =
        'Ana üretme. Bu koloni güçlü ise bölme, kapalı yavru desteği veya üretim için değerlendirilebilir.';
        kararNedeni = vetoNedeni;
        kararTipi = 'uyari';

        secilimKodu = 'OPERASYONEL_KULLAN';
        secilimBaslik = 'Genetik veto / güçlü operasyonel kullanım';
        secilimMesaji =
        'Donör havuzunda değil. Buna rağmen güçlü koloni olarak bölme, destek ve yavru gücü açısından değerlidir.';
      } else if (skor >= uretimMinSkor || balCita > 0) {
        kararKodu = 'URETIMDE_DEGERLENDIR';
        kararBaslik = 'Genetik veto var; üretimde değerlendir';
        kararMesaji =
        'Ana üretme. Bal ve genel üretim odağında kullan. Donör değil ama çalışkan üretim kolonisi olarak değerlendirilebilir.';
        kararNedeni = vetoNedeni;
        kararTipi = 'uyari';

        secilimKodu = 'OPERASYONEL_KULLAN';
        secilimBaslik = 'Genetik veto / üretim kolonisi';
        secilimMesaji =
        'Temiz donör havuzunda değil. Buna rağmen üretim ve saha sürekliliği açısından kullanılabilir.';
      } else if (skor >= mudahaleMinSkor) {
        kararKodu = 'DESTEK_KOLONISI';
        kararBaslik = 'Genetik veto var; destekleyerek kullan';
        kararMesaji =
        'Oğul izi olduğundan ana üretiminde kullanma. Gelişimine göre destek kolonisi veya üretim kolonisi olarak kullanılabilir.';
        kararNedeni = vetoNedeni;
        kararTipi = 'uyari';

        secilimKodu = 'OPERASYONEL_KULLAN';
        secilimBaslik = 'Genetik veto / destek kullanımı';
        secilimMesaji =
        'Donör havuzunda değil. Güç durumuna göre destek veya üretim kolonisi olarak değerlendirilebilir.';
      } else {
        kararKodu = 'GUCLENDIR_VE_IZLE';
        kararBaslik = 'Genetik veto var; önce toparla ve izle';
        kararMesaji =
        'Ana üretme. Önce gücünü toparla. Besleme, destek ve yakın muayene ile gelişimine bak; sonra saha rolünü netleştir.';
        kararNedeni = vetoNedeni;
        kararTipi = 'negatif';

        secilimKodu = 'OPERASYONEL_KULLAN';
        secilimBaslik = 'Genetik veto / önce toparlanmalı';
        secilimMesaji =
        'Donör havuzunda değil. Önce güç kazanmalı; sonra yalnızca operasyonel rolü yeniden okunmalıdır.';
      }
    } else if (donorSirasi == 1) {
      final String davranisNotu = _davranisNotuMetni(
        mizac: mizac,
        davranisToleransi: davranisToleransi,
      );

      kararKodu = 'DONOR_1';
      kararBaslik = 'Bu koloni 1. donör adayı';
      kararMesaji =
      'Ana üretiminde öncelikli. Gücünü koru. Bölme veya başka kullanım kararını donör değerini bozmayacak şekilde düşün.';
      kararNedeni =
      'Donör havuzundaki en güçlü koloni olarak öne çıkıyor. Donör skoru: $donorSkoru / 100.$davranisNotu';
      kararTipi = 'pozitif';

      secilimKodu = 'DAMIZLIK_ADAYI';
      secilimBaslik = 'Bu koloni 1. donör adayı';
      secilimMesaji =
      'Bu koloni donör havuzunda ilk sırada yer alıyor ve ana üretimi için en güçlü aday kabul ediliyor.';
    } else if (donorSirasi == 2) {
      final String davranisNotu = _davranisNotuMetni(
        mizac: mizac,
        davranisToleransi: davranisToleransi,
      );

      kararKodu = 'DONOR_2';
      kararBaslik = 'Bu koloni 2. donör adayı';
      kararMesaji =
      'Ana üretiminde güçlü bir alternatif olarak değerlendir. İlk tercihin uygun değilse buna yönel.';
      kararNedeni =
      'Donör havuzunda üst sırada yer alıyor. Donör skoru: $donorSkoru / 100.$davranisNotu';
      kararTipi = 'pozitif';

      secilimKodu = 'DAMIZLIK_ADAYI';
      secilimBaslik = 'Bu koloni 2. donör adayı';
      secilimMesaji =
      'Bu koloni donör havuzunda üst sırada yer alıyor ve ana üretimi için güçlü alternatif kabul ediliyor.';
    } else if (donorSirasi == 3) {
      final String davranisNotu = _davranisNotuMetni(
        mizac: mizac,
        davranisToleransi: davranisToleransi,
      );

      kararKodu = 'DONOR_3';
      kararBaslik = 'Bu koloni 3. donör adayı';
      kararMesaji =
      'Ana üretiminde yedek güçlü aday olarak değerlendir. Üretimde de değerli kalabilir.';
      kararNedeni =
      'Donör havuzunda ilk üç içinde yer alıyor. Donör skoru: $donorSkoru / 100.$davranisNotu';
      kararTipi = 'pozitif';

      secilimKodu = 'DAMIZLIK_ADAYI';
      secilimBaslik = 'Bu koloni 3. donör adayı';
      secilimMesaji =
      'Bu koloni donör havuzunda ilk üç içinde yer alıyor ve ana üretimi için değerlendirilebilir.';
    } else if (donorHavuzuBoyutu > 0 && donorSkoru >= 60) {
      final String davranisNotu = _davranisNotuMetni(
        mizac: mizac,
        davranisToleransi: davranisToleransi,
      );

      kararKodu = 'SARTLI_DONOR';
      kararBaslik = 'Bu koloni donör havuzunda, ama ilk sıralarda değil';
      kararMesaji =
      'Üretimde değerlendir. Gelişimi sürerse ileride donör alternatifi olarak yeniden bak.';
      kararNedeni =
      'Donör havuzuna girmiş olsa da şu an ilk üçte değil. Donör skoru: $donorSkoru / 100.$davranisNotu';
      kararTipi = 'notr';

      secilimKodu = 'SARTLI_DAMIZLIK';
      secilimBaslik = 'Donör havuzunda';
      secilimMesaji =
      'Bu koloni donör havuzuna girmiş durumda; ancak şu an ilk sıradaki adaylardan biri değil.';
    } else if (anaYasi >= anaDegisimYasi && skor < uretimMinSkor) {
      kararKodu = 'ANA_DEGISIM_DUSUN';
      kararBaslik = 'Bu koloni için ana değişimini düşün';
      kararMesaji =
      'Üretimde kalacaksa genç ve güvenilir bir ana ile yenilemek daha doğru olabilir.';
      kararNedeni =
      'Ana yaşı ilerlemiş ve mevcut performans beklenen seviyenin altında.';
      kararTipi = 'uyari';

      secilimKodu = 'ANA_DEGISIM';
      secilimBaslik = 'Ana değişimi düşünülmeli';
      secilimMesaji =
      'Koloni tamamen olumsuz değildir; ancak daha iyi verim için ana yenileme düşünülebilir.';
    } else if (sonCita >= bolmeCita && maxCita >= bolmeCita) {
      kararKodu = 'BOLME_ICIN_UYGUN';
      kararBaslik = 'Bu koloni bölme için uygun görünüyor';
      kararMesaji =
      'Donör önceliğinde değilse bölme için değerlendirebilirsin. Yeni kolonilere güvenilir genç ana ver.';
      kararNedeni = 'Koloni gücü yüksek ve genişleme potansiyeli taşıyor.';
      kararTipi = 'pozitif';

      secilimKodu = 'BOLME_ADAYI';
      secilimBaslik = 'Bölme için uygun';
      secilimMesaji =
      'Donör önceliğinde değilse bölme için değerlendirilebilir.';
    } else if (skor >= uretimMinSkor || balCita > 0) {
      kararKodu = 'URETIMDE_DEGERLENDIR';
      kararBaslik = 'Bu koloni üretimde değerlendirilebilir';
      kararMesaji =
      'Bal ve genel üretim odağında kullan. Sezona göre destek veya üretim rolünde değerlendir.';
      kararNedeni = 'Performansı üretim için yeterli görünüyor.';
      kararTipi = 'notr';

      secilimKodu = 'SADIK_URETICI';
      secilimBaslik = 'Üretimde değerlendir';
      secilimMesaji =
      'Bu koloni üretim ve süreklilik açısından değerlidir; donör önceliğinde görünmüyor.';
    } else if (muayeneSayisi <= 1) {
      kararKodu = 'VERI_YETERSIZ';
      kararBaslik = 'Bu koloni için karar vermek erken';
      kararMesaji =
      'Biraz daha muayene verisi topla. Sonra donör veya operasyon rolünü yeniden değerlendir.';
      kararNedeni = 'Güvenilir karar için yeterli veri oluşmamış.';
      kararTipi = 'notr';

      secilimKodu = 'IZLE';
      secilimBaslik = 'İzleyerek karar ver';
      secilimMesaji =
      'Bu koloni için hüküm vermeden önce biraz daha veri ve gözlem gerekir.';
    } else if (skor < mudahaleMinSkor ||
        sonCita <= destekCita ||
        trend == 'Düşüş') {
      kararKodu = 'GUCLENDIR_VE_IZLE';
      kararBaslik = 'Bu koloniye yakından bakmak gerekir';
      kararMesaji =
      'Destek, besleme ve sık muayene ile gelişimi yeniden değerlendir.';
      kararNedeni = 'Güç veya gidişat istenen seviyede görünmüyor.';
      kararTipi = 'uyari';

      secilimKodu = 'IZLE';
      secilimBaslik = 'İzleyerek karar ver';
      secilimMesaji =
      'Bu koloni için hüküm vermeden önce biraz daha veri ve gözlem gerekir.';
    } else {
      kararKodu = 'DESTEK_KOLONISI';
      kararBaslik = 'Bu koloniyi destek rolünde değerlendir';
      kararMesaji =
      'Şu an için en doğru rol destek ve düzenli takip görünüyor. Güçlenirse sonraki değerlendirmede üretimde daha öne çıkabilir.';
      kararNedeni =
      'Donör havuzunda üst sırada değil, ama tamamen olumsuz da görünmüyor.';
      kararTipi = 'notr';

      secilimKodu = 'SADIK_URETICI';
      secilimBaslik = 'Destek / üretim rolü';
      secilimMesaji =
      'Bu koloni destek ve süreklilik açısından değerlidir; donör önceliğinde görünmüyor.';
    }

    final List<Map<String, String>> aksiyonKartlari = [
      {
        'baslik': 'Durum',
        'mesaj': secilimBaslik,
        'tip': kararTipi,
      },
      {
        'baslik': 'Ne yap',
        'mesaj': kararMesaji,
        'tip': 'notr',
      },
      {
        'baslik': 'Neden',
        'mesaj': kararNedeni,
        'tip': 'notr',
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
        'baslik': 'Biyolojik Durum',
        'mesaj': biyoloji.baslik,
        'tip': biyolojiTip,
      });
      aksiyonKartlari.add({
        'baslik': 'Biyolojik Not',
        'mesaj': biyoloji.mesaj,
        'tip': 'notr',
      });

      if (biyoloji.zamanKritik || biyoloji.mudahaleGerekli) {
        aksiyonKartlari.add({
          'baslik': 'Sahada Öncelik',
          'mesaj': 'Bu koloni biyolojik zamanlama açısından öncelikli kontrol istemektedir.',
          'tip': 'uyari',
        });
      }
    }

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

  static Future<List<Map<String, dynamic>>> donorAdaylariSiraliGetir({
    int? arilikId,
    bool forceRefresh = false,
  }) async {
    if (arilikId != null &&
        arilikId > 0 &&
        !forceRefresh &&
        _donorListeCache.containsKey(arilikId)) {
      return _donorListeCache[arilikId]!;
    }

    final List<Map<String, dynamic>> koloniler = arilikId != null
        ? await VeritabaniServisi.kovanlariAriligaGoreGetir(arilikId)
        : await VeritabaniServisi.kolonileriGetir();

    if (koloniler.isEmpty) return [];

    final List<Map<String, dynamic>> havuz = [];

    for (final koloni in koloniler) {
      final int koloniId = _toInt(koloni['id']);
      if (koloniId <= 0) continue;

      final profil = await _koloniProfiliOlustur(koloniId, koloni);
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

    if (arilikId != null && arilikId > 0) {
      _donorListeCache[arilikId] = havuz;
    }

    return havuz;
  }

  static Future<Map<String, dynamic>> _koloniProfiliOlustur(
      int koloniId,
      Map<String, dynamic> koloni,
      ) async {
    final muayeneler = await VeritabaniServisi.muayeneleriGetir(koloniId);
    final trendData = await TrendServisi.koloniTrendiGetir(koloniId);
    final hatSonme = await VeritabaniServisi.hatSonmeAnaliziGetir(koloniId);
    final ogulRisk = await VeritabaniServisi.ogulRiskOzetiGetir(koloniId);

    final String davranisToleransi = await VeritabaniServisi.ayarStringGetir(
      'davranis_toleransi',
      varsayilan: 'standart',
    );

    final Map<String, dynamic>? sonMuayene =
    muayeneler.isNotEmpty ? muayeneler.first : null;

    final bool aktifMi = await VeritabaniServisi.koloniAktifMi(koloniId);

    final int skor = _toInt(koloni['skor']);
    final int sonCita = _toInt(koloni['sonCita']);
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
      'maxCita': maxCita,
      'balCita': balCita,
      'anaYasi': anaYasi,
      'muayeneSayisi': muayeneSayisi,
      'mizac': mizac,
      'trend': trend,
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
      ...kisCikisBilgisi,
    };
  }

  static Future<Map<String, dynamic>> _kisCikisBilgisiHesapla(
      List<Map<String, dynamic>> muayeneler,
      ) async {
    if (muayeneler.isEmpty) {
      return {
        'kisCikisPuani': null,
        'kisCikisOrani': null,
        'kisCikisVeriYeterliMi': false,
        'kisCikisYorum': 'Kış çıkış verisi yetersiz.',
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
        'kisCikisYorum': 'Kış çıkış verisi yetersiz.',
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
      final String yorum = _kisCikisYorumuVer(oran);

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
      'kisCikisYorum': 'Kış çıkış verisi yetersiz.',
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

  static String _kisCikisYorumuVer(double oran) {
    if (oran >= 0.85) return 'Çok güçlü çıkış';
    if (oran >= 0.70) return 'Güçlü çıkış';
    if (oran >= 0.55) return 'Orta çıkış';
    if (oran >= 0.40) return 'Zayıf çıkış';
    return 'Riskli çıkış';
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

    final double ivme = _toDouble(trendData['duzeltilmisIvme']);
    final double trendPuani = _clampDouble(((ivme + 4) / 8) * 10, 0, 10);

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
    if (muayeneSayisi >= 4) return 5;
    if (muayeneSayisi >= 2) return 3;
    if (muayeneSayisi >= 1) return 1;
    return 0;
  }

  static String _davranisNotuMetni({
    required String mizac,
    required String davranisToleransi,
  }) {
    final m = mizac.toLowerCase().trim();

    if (m.contains('saldırgan') || m.contains('saldirgan')) {
      return davranisToleransi == 'esnek'
          ? ' Davranış açısından not düşülmüş durumda; ancak kullanıcı ayarı esnek olduğu için veto uygulanmadı.'
          : ' Davranış açısından dikkat notu bulunuyor.';
    }

    if (m.contains('sinirli')) {
      return ' Davranış açısından hafif bir dikkat notu bulunuyor.';
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
