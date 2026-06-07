// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'İtogena Arılık Yönetimi';

  @override
  String get girisYukleniyor => 'Veriler hazırlanıyor...';

  @override
  String get girisSurumKontrol => 'Sürüm kontrol ediliyor...';

  @override
  String get girisYeniSurum => 'Yeni sürüm denetleniyor...';

  @override
  String get girisAnaSayfaAciliyor => 'Ana sayfa açılıyor...';

  @override
  String get girisBaslatmaSorunu => 'Başlatma sırasında sorun oluştu.';

  @override
  String girisBaslatmaHatasi(String hata) {
    return 'Başlatma hatası: $hata';
  }

  @override
  String get iptal => 'İptal';

  @override
  String get tamam => 'Tamam';

  @override
  String get evet => 'Evet';

  @override
  String get hayir => 'Hayır';

  @override
  String get sil => 'Sil';

  @override
  String get duzenle => 'Düzenle';

  @override
  String get kaydet => 'Kaydet';

  @override
  String get ekle => 'Ekle';

  @override
  String get vazgec => 'Vazgeç';

  @override
  String get kapat => 'Kapat';

  @override
  String get geri => 'Geri';

  @override
  String get onayla => 'Onayla';

  @override
  String get hata => 'Hata';

  @override
  String get basarili => 'Başarılı';

  @override
  String get uyari => 'Uyarı';

  @override
  String get bilgi => 'Bilgi';

  @override
  String get yukleniyor => 'Yükleniyor...';

  @override
  String get bilinmiyor => 'Bilinmiyor';

  @override
  String get bulunamadi => 'Bulunamadı.';

  @override
  String get anaSayfa => 'Ana sayfa';

  @override
  String get kovan => 'Kovan';

  @override
  String get koloni => 'Koloni';

  @override
  String get arilik => 'Arılık';

  @override
  String get proRozeti => 'PRO';

  @override
  String get proOzellik => 'Bu özellik PRO sürümüne aittir.';

  @override
  String get proYukselt => 'PRO\'ya Yükselt';

  @override
  String get anaSayfaAsistan => 'Arılıktaki asistanınız';

  @override
  String get anaSayfaSlogan => 'Muayeneni kaydet, gerisini biz hallederiz.';

  @override
  String get anaSayfaOzellik1Baslik => 'Kovanın içini gör';

  @override
  String get anaSayfaOzellik1Aciklama =>
      'Hangi çıtada yavru var, hangi çıtada bal — görsel olarak.';

  @override
  String get anaSayfaOzellik2Baslik => 'Ne yapman gerektiğini öğren';

  @override
  String get anaSayfaOzellik2Aciklama =>
      'Donör adayı mı, ana değişimi mi, bölme mi — sistem söyler.';

  @override
  String get anaSayfaOzellik3Baslik => 'Riskleri önceden gör';

  @override
  String get anaSayfaOzellik3Aciklama =>
      'Varroa, arı kuşu, yağmacılık — sezon ve koloni birlikte okunur.';

  @override
  String get anaSayfaOzellik4Baslik => 'Hasat tahminini al';

  @override
  String get anaSayfaOzellik4Aciklama =>
      'Tahmini bal miktarı ve ekonomik değer koloniye göre hesaplanır.';

  @override
  String get anaSayfaRehber => 'Kullanıcı Rehberi';

  @override
  String get menuArilikYonetimi => 'Arılık Yönetimi';

  @override
  String get menuArilikYonetimiAciklama =>
      'Kolonilerini ekle, muayene yap, takip et';

  @override
  String get menuRaporlar => 'Raporlar';

  @override
  String get menuRaporlarAciklama =>
      'Arılık geneli istatistik, ekonomik değer ve donör listesi';

  @override
  String get menuSoyAgaci => 'Soy Ağacı';

  @override
  String get menuSoyAgaciAciklama => 'Kolonilerin genetik hat takibi';

  @override
  String get menuFormullerHesaplamalar => 'Formüller ve Hesaplamalar';

  @override
  String get menuFormullerHesaplamalarAciklama =>
      'Şurup ve oksalik asit yardımcı ekranı';

  @override
  String get menuAyarlar => 'Ayarlar';

  @override
  String get menuAyarlarAciklama =>
      'Kalibrasyon, bal akımı, risk takvimi ve sistem tercihleri';

  @override
  String get karsilastirmaBaslik => 'KARŞILAŞTIRMALI ANALİZ';

  @override
  String karsilastirmaHata(String hata) {
    return 'Karşılaştırma verisi üretilemedi:\n$hata';
  }

  @override
  String get karsilastirmaKoloniBulunamadi =>
      'Karşılaştırılacak koloni bulunamadı.';

  @override
  String get karsilastirmaAciklama =>
      'Bu ekran iki farklı şeyi birlikte gösterir: genel performans ve genetik seçilim. Yüksek performans tek başına donörlük anlamına gelmez. Bir koloni güçlü olsa bile genetik veto nedeniyle temiz donör havuzunun dışında kalabilir.';

  @override
  String karsilastirmaKovanNo(String kovanNo) {
    return 'Kovan $kovanNo';
  }

  @override
  String karsilastirmaPerformans(String skor) {
    return 'Performans $skor';
  }

  @override
  String karsilastirmaTemizDonor(String sira) {
    return 'Temiz donör #$sira';
  }

  @override
  String get karsilastirmaTemizHavuzda => 'Temiz havuzda önde değil';

  @override
  String get karsilastirmaGenetikVeto => 'Genetik veto';

  @override
  String get karsilastirmaTablo => 'KARŞILAŞTIRMA TABLOSU';

  @override
  String get karsilastirmaKriter => 'Kriter';

  @override
  String get karsilastirmaSistemYorumu => 'SİSTEM YORUMU';

  @override
  String get karsilastirmaSistemYorumuLabel => 'Sistem Yorumu';

  @override
  String get karsilastirmaBiyoloji => 'Biyoloji';

  @override
  String get soyAgaciBaslik => 'SOY AĞACI';

  @override
  String get soyAgaciBasitHat => 'BASİT HAT';

  @override
  String get soyAgaciDetayli => 'DETAYLI';

  @override
  String soyAgaciHata(String hata) {
    return 'Soy ağacı yüklenemedi:\n$hata';
  }

  @override
  String get soyAgaciBulunamadi =>
      'Yaşayan hat bulunamadı.\nKaynak koloni ilişkilerini kontrol et.';

  @override
  String get soyAgaciBasitAciklama =>
      'Bu görünüm yaşayan hatları sade biçimde gösterir. Tamamen sönmüş hatlar gizlenir. Pasif koloniler sadece yaşayan bir hattın içinde görünür.';

  @override
  String get soyAgaciHatOzeti => 'Hat Özeti';

  @override
  String soyAgaciToplam(int sayi) {
    return 'Toplam $sayi';
  }

  @override
  String soyAgaciAktif(int sayi) {
    return 'Aktif $sayi';
  }

  @override
  String soyAgaciPasif(int sayi) {
    return 'Pasif $sayi';
  }

  @override
  String get soyAgaciAktifDurum => 'AKTİF';

  @override
  String get soyAgaciPasifDurum => 'pasif';

  @override
  String get formullerBaslik => 'FORMÜLLER VE HESAPLAMALAR';

  @override
  String get formullerSekmeSurup => 'ŞURUP';

  @override
  String get formullerSekmeOksalik => 'OKSALİK';

  @override
  String get formullerSekmeBiyoloji => 'BİYOLOJİ';

  @override
  String get formullerSekmeBalAkimi => 'BAL AKIMI';

  @override
  String get formullerSurupFormulu => 'Şurup Formülü';

  @override
  String get formullerSurupAciklama =>
      'Hedef şerbet miktarını kg olarak girersen sistem kg su ve kg şeker verir. Sahada aynı ölçü kabını kullanıyorsan 1:1 veya 2:1 oranı aynı mantıkla korunur.';

  @override
  String get formullerSurupOrani => 'Şurup Oranı';

  @override
  String get formullerSurupOraniAciklama =>
      '1:1 genelde teşvik şurubu, 2:1 genelde stok / kış hazırlığı için kullanılır. Bu ekran zorunlu uygulama emri değil, oran hesabı yardımcısıdır.';

  @override
  String get formullerHedefSerbet => 'Hedef Şerbet';

  @override
  String get formullerHedefSerbetEtiket => 'Hedef şerbet miktarı';

  @override
  String get formullerHedefSerbetYardim =>
      'Örnek: 10 kg hedef şerbet için gerekli kg su ve kg şeker hesaplanır.';

  @override
  String formullerSurupSonuc(String oran) {
    return '$oran Şurup Sonucu';
  }

  @override
  String get formullerHedefSerbetSatir => 'Hedef Şerbet';

  @override
  String get formullerSeker => 'Şeker';

  @override
  String get formullerSu => 'Su';

  @override
  String get formullerSahaKatsayisi => 'Saha Katsayısı';

  @override
  String get formullerSurupNot =>
      'Kg hesabı hedef şerbet ağırlığı içindir. Hacimsel kapla çalışıyorsan aynı kapla oran kur; 1:1 için eşit kap, 2:1 için iki kap şeker bir kap su mantığı korunur.';

  @override
  String get formullerOksalikBaslik => 'Oksalik Asit Yardımcı Hesabı';

  @override
  String get formullerOksalikAciklama =>
      'Bu ekran yalnızca hesaplama yardımcısıdır. Uygulama kararı için ruhsatlı ürün etiketi, yerel mevzuat ve veteriner/teknik danışman talimatı esas alınır.';

  @override
  String get formullerOksalikStandart => '10–15 Kovan İçin Standart Formül';

  @override
  String get formullerUygulamaNotu => 'Uygulama Notu';

  @override
  String get formullerOksalikNot =>
      'Oksalik uygulaması genelde yavrusuz / yavru çok az dönemde daha anlamlıdır. Sıcaklık, doz, uygulama yöntemi ve tekrar sayısı için ürün etiketi esas alınmalıdır.';

  @override
  String get formullerGuvenlikUyarisi => 'Güvenlik Uyarısı';

  @override
  String get formullerOksalikGuvenlik =>
      'Koruyucu gözlük, eldiven ve maske kullan. Asit buharını soluma, cilt ve göz temasından kaçın. Ruhsatsız ürün, belirsiz doz veya etiketsiz karışım kullanma. Bu ekran tedavi talimatı değil, yardımcı hesaplama ekranıdır.';

  @override
  String get formullerBiyolojikTakvim => 'Biyolojik Takvim';

  @override
  String get formullerBiyolojikAciklama =>
      'Bu ekran ana kazanma biyoloji takvimini merkezi AriBiyolojiServisi üzerinden okur. Koloni detay, süreç uyarıları ve formüller aynı tarih mantığını kullanır.';

  @override
  String get formullerAnaKazanmaSureci => 'Ana Kazanma Süreci';

  @override
  String get formullerBaslangicTipi => 'Başlangıç tipi';

  @override
  String get formullerAnasizBirakildi => 'Anasız Bırakıldı';

  @override
  String get formullerBolmeYapildi => 'Bölme Yapıldı';

  @override
  String get formullerHazirKapaliMeme => 'Hazır Kapalı Ana Memesi';

  @override
  String get formullerHazirCiftlesmisAna => 'Hazır Çiftleşmiş Ana';

  @override
  String get formullerBaslangicTarihi => 'Başlangıç tarihi';

  @override
  String formullerTakvim(String tip) {
    return '$tip Takvimi';
  }

  @override
  String get formullerSahaNotu => 'Saha Notu';

  @override
  String get formullerAnaKazanmaSahaNot =>
      'Gün sayımı başlangıç günü dahil edilerek yapılır. Günlük / kapalı yavru görülürse muayene ekranındaki ilgili kutucuk işaretlenir ve ana kazanma süreci kapanır.';

  @override
  String get formullerKapaliIsciYavrusu => 'Kapalı İşçi Yavrusu Çıkışı';

  @override
  String get formullerKapaliIsciTarih => 'Kapalı işçi yavrusu görülen tarih';

  @override
  String get formullerKapaliIsciSonuc => 'Kapalı İşçi Yavrusu Çıkış Penceresi';

  @override
  String get formullerKapaliErkekYavrusu => 'Kapalı Erkek Yavrusu Çıkışı';

  @override
  String get formullerKapaliErkekTarih => 'Kapalı erkek yavrusu görülen tarih';

  @override
  String get formullerKapaliErkekSonuc =>
      'Kapalı Erkek Yavrusu Çıkış Penceresi';

  @override
  String get formullerBalAkimiKarar => 'Bal Akımı Kararı';

  @override
  String get formullerBalAkimiAciklama =>
      'Sistem, bal akımına zayıf girmemek için 57 günlük saha planlama eşiğini kullanır. 42 gün ise yumurtadan tarlacıya biyolojik süredir; bu ikisi aynı şey değildir.';

  @override
  String get formullerBalAkimTarihi => 'Bal akım başlangıç tarihi';

  @override
  String get formullerMevcutCita => 'Mevcut çıta sayısı';

  @override
  String get formullerCitaOrnek => 'Örnek: 9';

  @override
  String get formullerTarihBekleniyor => 'Tarih Bekleniyor';

  @override
  String get formullerTarihBekleniyorAciklama =>
      'Karar üretilebilmesi için önce bal akım başlangıç tarihini seç.';

  @override
  String get formullerKarar => 'Karar';

  @override
  String get formullerSonGuvenliBolme => 'Son güvenli bölme tarihi';

  @override
  String get formullerPlanlamaEsigi => 'Planlama eşiği';

  @override
  String get formullerPlanlamaEsigiDeger => '57 gün';

  @override
  String get formullerBiyolojikSure => 'Biyolojik süre';

  @override
  String get formullerBiyolojikSureDeger => '42 gün: yumurtadan tarlacıya';

  @override
  String get formullerMevcutGuc => 'Mevcut güç';

  @override
  String formullerMevcutGucDeger(int cita) {
    return '$cita çıta';
  }

  @override
  String get formullerHedefAltSinir => 'Hedef alt sınır';

  @override
  String get formullerEnFazlaAlinabilir => 'En fazla alınabilir';

  @override
  String get formullerBolmePenceresiYok =>
      'Bu güçte güvenli bölme penceresi açılmamış görünüyor.';

  @override
  String formullerBolmePenceresiVar(int max) {
    return '$max çıtadan fazla alınırsa koloni bal dönemine zayıf girebilir.';
  }

  @override
  String get formullerKabulKontrol => 'Kabul kontrol penceresi';

  @override
  String get formullerMemeKapanma => 'Tahmini meme kapanma';

  @override
  String get formullerAnaCikisi => 'Tahmini ana çıkışı';

  @override
  String get formullerCiftlesme => 'Çiftleşme uçuş penceresi';

  @override
  String get formullerYumurtlamaKontrol => 'Yumurtlama kontrol penceresi';

  @override
  String get formullerKovanaDokunma => 'Kovana dokunma penceresi';

  @override
  String get formullerBaslangic => 'Başlangıç';

  @override
  String get formullerTahminiCikis => 'Tahmini çıkış';

  @override
  String get formullerUygulamaModeli => 'Damlatma';

  @override
  String raporListeHata(String hata) {
    return 'Rapor listesi üretilemedi:\n$hata';
  }

  @override
  String get raporListeBos =>
      'Bu listede gösterilecek aktif koloni bulunamadı.';

  @override
  String raporListeAciklama(String arilik, int adet) {
    return 'Bu liste $arilik arılığındaki aktif kolonilerden üretilir. Sıralama ana eksende skora göre yapılır. Eşitlikte önce üreme, sonra üretim, sonra donörlük öne çıkar. Toplam $adet kayıt var.';
  }

  @override
  String get raporListeSira => 'SIRA';

  @override
  String get raporListeKoloniNo => 'KOLONİ NO';

  @override
  String get raporListeDurum => 'DURUM';

  @override
  String raporListeSkorCita(int skor, int cita) {
    return 'Skor $skor  •  $cita çıta';
  }

  @override
  String muayeneDetayBaslik(String kovanNo) {
    return 'KOVAN $kovanNo / MUAYENE';
  }

  @override
  String get muayeneDetayGenelBilgi => 'GENEL BİLGİ';

  @override
  String get muayeneDetayNotlar => 'NOTLAR';

  @override
  String get muayeneDetayTetikler => 'TETİKLER';

  @override
  String get muayeneDetaySurec => 'SÜREÇ KAYITLARI';

  @override
  String get muayeneDetayTarih => 'Tarih';

  @override
  String get muayeneDetayCita => 'Çıta';

  @override
  String get muayeneDetayYavruluCita => 'Yavrulu Çıta';

  @override
  String get muayeneDetayBalHasat => 'Bal/Hasat';

  @override
  String get muayeneDetayYavruDuzeni => 'Yavru Düzeni';

  @override
  String get muayeneDetayMizac => 'Mizaç';

  @override
  String get muayeneDetayBesleme => 'Besleme';

  @override
  String get muayeneDetayVarroaMucadele => 'Varroa Mücadelesi';

  @override
  String get muayeneDetayYok => 'Yok';

  @override
  String get muayeneDetayEvet => 'Evet';

  @override
  String get muayeneDetayKapaliMeme => 'Hazır kapalı ana memesi var';

  @override
  String get muayeneDetayHazirAna => 'Hazır çiftleşmiş ana verildi';

  @override
  String get muayeneDetayKendiAnasi => 'Kendi anasını yapacak';

  @override
  String get muayeneDetayOgulBelirtisi => 'Oğul Belirtisi';

  @override
  String get muayeneDetayOgulAtti => 'Oğul Attı';

  @override
  String get muayeneDetayBolmeYapildi => 'Bölme Yapıldı';

  @override
  String get muayeneDetayAnasizBirakildi => 'Anasız Bırakıldı';

  @override
  String get muayeneDetayKovanSondu => 'Kovan Söndü';

  @override
  String get muayeneDetayKapaliYavruAktarildi =>
      'Kapalı Yavrulu Çıta Aktarıldı';

  @override
  String get muayeneDetayAnaKazanmaYontemi => 'Ana Kazanma Yöntemi';

  @override
  String get muayeneDetayDisaridanAna => 'Dışarıdan Hazır Ana Verildi';

  @override
  String get muayeneDetayGunlukYavru => 'Günlük / Kapalı Yavru Görüldü';

  @override
  String get muayeneDetaySuruplukKaldirildi => 'Şurupluk Kaldırıldı';

  @override
  String get muayeneDetayDroneKesimi => 'Drone Kesimi';

  @override
  String get muayeneDetayTimol => 'Timol';

  @override
  String get muayeneDetayAmitraz => 'Amitraz';

  @override
  String get muayeneDetayFormik => 'Formik';

  @override
  String get muayeneDetayOksalik => 'Oksalik';

  @override
  String get muayeneDetayYavruYokAnaSureci =>
      'Bu muayenede yavru düzeni \"Yok\" kaydedilmiş. Aktif ana kazanma/bölme/oğul bağlamında sistem bunu önce biyolojik gün penceresine göre yorumlar; erken dönemde normal bekleme, gecikmiş dönemde yavrusuzluk tanısı olarak değerlendirir.';

  @override
  String get muayeneDetayYavruYokBasit =>
      'Bu muayenede yavru düzeni \"Yok\" kaydedilmiş. Sistem biyolojik modelde yavrulu çıtayı 0 kabul eder ve koloni geri dönüş kapasitesini bu bilgiyle okur.';

  @override
  String get hatAnalizAppBarBaslik => 'Hat Analizi';

  @override
  String get hatAnalizSayfaBasligi => 'HAT BAZLI SEÇİLİM ANALİZİ';

  @override
  String get hatAnalizAciklama =>
      'Bu ekran yaşayan devamı olan hatları gösterir. Amaç, donörlüğe uygun kök hatları hızlıca görmek ve yaşayan hat içindeki sönmeleri kaybetmeden değerlendirmektir.';

  @override
  String get hatAnalizUstAciklama =>
      'Bu ekranda yalnızca yaşayan devamı olan hatlar gösterilir. Tamamen kapanmış ve aktif koloni bırakmamış hatlar ana listede yer almaz.';

  @override
  String get hatAnalizToplamYasayan => 'Toplam yaşayan hat sayısı';

  @override
  String get hatAnalizFiltre => 'FİLTRE';

  @override
  String get hatAnalizBos => 'Bu filtrede gösterilecek yaşayan hat bulunamadı.';

  @override
  String get hatAnalizNeden => 'NEDEN / NOT';

  @override
  String hatAnalizAktifHat(String kovan) {
    return 'Aktif Hat: $kovan';
  }

  @override
  String hatAnalizAktifTemsilci(String kovan) {
    return 'Aktif Hat Temsilcisi: $kovan';
  }

  @override
  String hatAnalizSonmusDurum(String karar, String kok) {
    return '$karar · Kök $kok sönmüş';
  }

  @override
  String get hatAnalizAktifHatiAc => 'Aktif Hattı Aç';

  @override
  String get hatAnalizAktifTemsilciAc => 'Aktif Temsilciyi Aç';

  @override
  String get hatAnalizToplam => 'Toplam';

  @override
  String get hatAnalizAktif => 'Aktif';

  @override
  String get hatAnalizSonmus => 'Sönmüş';

  @override
  String get hatAnalizSonmeOrani => 'Sönme %';

  @override
  String get hatAnalizOrtMaksCita => 'Ort. Maks Çıta';

  @override
  String get hatAnalizOrtBalCita => 'Ort. Bal Çıtası';

  @override
  String get hatAnalizTumu => 'Tümü';

  @override
  String get hatAnalizDonorHat => 'Donör Hat';

  @override
  String get hatAnalizGucluUretim => 'Güçlü Üretim Hattı';

  @override
  String get hatAnalizOperasyonel => 'Operasyonel Hat';

  @override
  String get hatAnalizRiskli => 'Riskli Hat';

  @override
  String get hatAnalizTakip => 'Takip Edilmeli';

  @override
  String get hatAnalizVeriYetersiz => 'Veri Yetersiz';

  @override
  String get hatAnalizSayacUretim => 'Üretim Hattı';

  @override
  String get hatAnalizSayacOperasyonel => 'Operasyonel';

  @override
  String get hatAnalizSayacRiskli => 'Riskli';

  @override
  String get hatAnalizSayacTakip => 'Takip';

  @override
  String get hatAnalizSayacVeriAz => 'Veri Az';

  @override
  String get karsilastirmaSecimMinKoloni =>
      'Karşılaştırma için en az 2 koloni seçmelisin.';

  @override
  String get karsilastirmaSecimMaxKoloni => 'En fazla 3 koloni seçebilirsin.';

  @override
  String get karsilastirmaSecimAciklama =>
      'Karşılaştırma en fazla 3 koloni ile yapılır. Sistem genel performans ile genetik seçilim farkını aynı tabloda görünür hale getirmeye çalışır.';

  @override
  String get karsilastirmaSecimSkor => 'Skor';

  @override
  String get karsilastirmaSecimSonCita => 'Son Çıta';

  @override
  String get karsilastirmaSecimBal => 'Bal';

  @override
  String get karsilastirmaSecimBekle => 'Hazırlanıyor...';

  @override
  String get karsilastirmaSecimButon => 'Karşılaştır';

  @override
  String get karsilastirmaPerformansBaslik => 'Karşılaştırmalı Analiz';

  @override
  String get karsilastirmaSistemYorumuPerf =>
      'SİSTEM YORUMU (PERFORMANS + SEÇİLİM)';

  @override
  String get karsilastirmaDonorDurumu => 'Donör Durumu';

  @override
  String get karsilastirmaUreme => 'Üreme';

  @override
  String get karsilastirmaUretim => 'Üretim';

  @override
  String get karsilastirmaDayaniklilik => 'Dayanıklılık';

  @override
  String get karsilastirmaKisCikisi => 'Kış Çıkışı';

  @override
  String get karsilastirmaHatGucu => 'Hat Gücü';

  @override
  String get karsilastirmaDavranis => 'Davranış';

  @override
  String get karsilastirmaVeriGuveni => 'Veri Güveni';

  @override
  String get karsilastirmaOgulDurumu => 'Oğul Durumu';

  @override
  String get kolonilerBaslik => 'Koloniler';

  @override
  String get kolonilerDonorHazirlaniyor =>
      'Koloniler • Donör rozetleri hazırlanıyor';

  @override
  String kolonilerSeciliSayi(int sayi) {
    return '$sayi koloni seçildi';
  }

  @override
  String kolonilerAktifSekme(int sayi) {
    return 'AKTİF ($sayi)';
  }

  @override
  String kolonilerSonmusSekme(int sayi) {
    return 'SÖNMÜŞ ($sayi)';
  }

  @override
  String get kolonilerKarsilastirmaModuSadece =>
      'Karşılaştırma modu yalnızca aktif koloniler için kullanılabilir.';

  @override
  String get kolonilerDuzenleBaslik => 'Koloniyi Düzenle';

  @override
  String kolonilerDuzenleOnay(String kovanNo) {
    return '$kovanNo numaralı koloni için düzenleme ekranı açılsın mı?';
  }

  @override
  String get kolonilerDevamEt => 'Devam Et';

  @override
  String get kolonilerSilBaslik => 'Koloniyi Sil';

  @override
  String kolonilerSilOnay(String kovanNo) {
    return '$kovanNo numaralı koloni silinsin mi?\n\nBu işlem geri alınamaz. İlgili numara geçmişi ve olay kayıtları da silinir.';
  }

  @override
  String kolonilerSilindi(String kovanNo) {
    return '$kovanNo numaralı koloni silindi.';
  }

  @override
  String kolonilerSilHata(String hata) {
    return 'Koloni silinirken hata oluştu: $hata';
  }

  @override
  String get kolonilerAktifBos => 'Bu arılıkta aktif koloni kaydı yok.';

  @override
  String get kolonilerSonmusBos => 'Bu arılıkta sönmüş koloni kaydı yok.';

  @override
  String get kolonilerKovanAra => 'Kovan ara...';

  @override
  String get kolonilerAramaTemizle => 'Aramayı temizle';

  @override
  String get kolonilerFiltreYeniBolme => 'Yeni bölmeler';

  @override
  String get kolonilerFiltreYeniOgul => 'Yeni oğullar';

  @override
  String get kolonilerFiltreAlarm => 'Alarm';

  @override
  String get kolonilerFiltreYavruYok => 'Yavru yok';

  @override
  String get kolonilerFiltreHasat => 'Hasat adayı';

  @override
  String get kolonilerDonorRozetAciklama =>
      'Rozetler: 1/2/3 ilk donör adaylarını, D donör havuzundaki diğer adayları gösterir. Genetik veto varsa detay ekranında ayrıca açıklanır.';

  @override
  String get kolonilerKarsilastirmaModuBaslik => 'KARŞILAŞTIRMA MODU';

  @override
  String get kolonilerKarsilastirmaModuInfo =>
      'Karşılaştırmak istediğiniz 2 veya 3 aktif koloniye dokunun. Bu mod açıkken koloni detayı yerine seçim yapılır.';

  @override
  String kolonilerSeciliKoloniSayisi(int sayi) {
    return 'Seçili koloni: $sayi / 3';
  }

  @override
  String kolonilerKarsilastirButon(int sayi) {
    return 'Karşılaştır ($sayi)';
  }

  @override
  String get kolonilerPasif => 'PASİF';

  @override
  String get kolonilerSondu => 'SÖNDÜ';

  @override
  String kolonilerSonCita(int cita) {
    return '$cita çıta';
  }

  @override
  String get raporlarSayfaBaslik => 'RAPORLAR';

  @override
  String get raporlarArilikEtiketi => 'Arılık:';

  @override
  String get raporlarArilikBulunamadi => 'Kayıtlı arılık bulunamadı.';

  @override
  String get raporlarArilikSec => 'Rapor alınacak arılığı seç';

  @override
  String get raporlarGenelDurum => 'GENEL DURUM';

  @override
  String get raporlarAktifKovan => 'Aktif kovan';

  @override
  String get raporlarOrtaSkor => 'Orta skor';

  @override
  String get raporlarAriliCita => 'Arılı çıta';

  @override
  String get raporlarDonorler => 'DONÖRLER';

  @override
  String get raporlarHesaplaniyor => 'Hesaplanıyor';

  @override
  String get raporlarHenuzYok => 'Henüz yok';

  @override
  String get raporlarIlkUcGuclu => 'İLK 3 GÜÇLÜ';

  @override
  String get raporlarRaporSec => 'RAPOR SEÇ';

  @override
  String get raporlarListeLazyAciklama =>
      'Ağır liste hesapları ilk açılışta çalışmaz. Sadece görmek istediğin liste açıldığında yüklenir.';

  @override
  String get raporlarGucludenZayifaBaslik => 'Güçlüden Zayıfa';

  @override
  String get raporlarGucludenZayifaAlt =>
      'Tüm aktif koloniler yüksek skordan düşüğe sıralanır.';

  @override
  String get raporlarGucludenZayifaListeBaslik => 'GÜÇLÜDEN ZAYIFA';

  @override
  String get raporlarZayiftanGucluye => 'Zayıftan Güçlüye';

  @override
  String get raporlarZayiftanGucluAlt =>
      'Tüm aktif koloniler düşük skordan yükseğe sıralanır.';

  @override
  String get raporlarZayiftanGucluListeBaslik => 'ZAYIFTAN GÜÇLÜYE';

  @override
  String get raporlarDonorAdaylariBaslik => 'Donör Adayları';

  @override
  String get raporlarDonorAdaylariAlt =>
      '1. sıradan başlayarak donör havuzu listelenir.';

  @override
  String get raporlarDonorAdaylariListeBaslik => 'DONÖR ADAYLARI';

  @override
  String get raporlarGenetikVetoBaslik => 'Genetik Veto';

  @override
  String get raporlarGenetikVetoAlt =>
      'Donör dışı kalan veto kayıtları kendi içinde sıralanır.';

  @override
  String get raporlarGenetikVetoListeBaslik => 'GENETİK VETO';

  @override
  String get raporlarEkonomikDegerBaslik => 'Ekonomik Değer';

  @override
  String get raporlarEkonomikDegerAlt =>
      'Arılık ekonomik değeri ve bal potansiyeli ayrı ekranda hesaplanır.';

  @override
  String get raporlarIstatistikHesapla => 'Arılık istatistiklerini hesapla';

  @override
  String get raporlarIstatistikHesaplaniyor =>
      'Arılık istatistikleri hesaplanıyor...';

  @override
  String raporlarIstatistikHata(String hata) {
    return 'Arılık istatistikleri hesaplanamadı: $hata';
  }

  @override
  String get raporlarTekrarHesapla => 'Tekrar hesapla';

  @override
  String get raporlarArilikIstatistikleri => 'ARILIK İSTATİSTİKLERİ';

  @override
  String get raporlarToplamCita => 'Toplam çıta';

  @override
  String get raporlarBalTemasi => 'Bal temaslı';

  @override
  String get raporlarAktivasyonFarki => 'Aktivasyon';

  @override
  String get raporlarTahminiAri => 'Tahmini arı';

  @override
  String get raporlarGuclu => 'Güçlü';

  @override
  String get raporlarOrta => 'Orta';

  @override
  String get raporlarZayif => 'Zayıf';

  @override
  String ekDegerAppBarBaslik(String arilikAd) {
    return '$arilikAd EKONOMİK DEĞER';
  }

  @override
  String ekDegerHata(String hata) {
    return 'Ekonomik değer hesaplanamadı:\n$hata';
  }

  @override
  String get ekDegerKartBaslik => 'EKONOMİK DEĞER';

  @override
  String ekDegerTahminiToplam(String deger) {
    return 'Tahmini toplam değer: $deger TL';
  }

  @override
  String ekDegerAktivasyonluBalliCita(String cita) {
    return 'Aktivasyonlu ballı çıta: $cita çıta';
  }

  @override
  String ekDegerTahminiBalAraligi(
      String minKg, String maxKg, String minTL, String maxTL) {
    return 'Tahmini bal: $minKg–$maxKg kg / $minTL–$maxTL TL';
  }

  @override
  String get ekDegerHesapAciklama =>
      'Bu hesap biyolojik modelde bal/ballık pozisyonunda görünen çıtaları aktivasyon düzeyiyle okur; boş çıta, toplam fiziksel çıta veya boş kabarmış petek bal gibi sayılmaz.';

  @override
  String get ekDegerBalFiyati => 'Bal satış fiyatı (kg/TL)';

  @override
  String get ekDegerAriliCita => 'Arılı çıta değeri';

  @override
  String get ekDegerBosKovan => 'Boş kovan değeri';

  @override
  String get ekDegerBosKabarmisPetek => 'Boş kabarmış petek adedi';

  @override
  String get ekDegerBosKabarmisPetekBirim => 'Boş kabarmış petek birim değeri';

  @override
  String get koloniDetayMuayeneSil => 'Muayene Sil';

  @override
  String koloniDetayMuayeneSilOnay(String tarih) {
    return '$tarih tarihli muayene silinsin mi?\n\nBu işlem geri alınamaz.';
  }

  @override
  String get koloniDetayMuayeneSilindi => 'Muayene silindi.';

  @override
  String get koloniDetayNumaraDegistir => 'Koloni Numarasını Değiştir';

  @override
  String get koloniDetayNumaraAciklama =>
      'Bu işlem koloninin saha numarasını değiştirir. Soy bağı ve muayene geçmişi korunur.';

  @override
  String get koloniDetayYeniNumara => 'Yeni koloni / kovan numarası';

  @override
  String koloniDetayNumaraGuncellendi(String no) {
    return 'Koloni numarası $no olarak güncellendi.';
  }

  @override
  String koloniDetayAppBarBaslik(String no) {
    return 'KOVAN $no';
  }

  @override
  String get koloniDetayTabGenelDurum => 'GENEL DURUM';

  @override
  String get koloniDetayTabMuayeneler => 'MUAYENELER';

  @override
  String get koloniDetayTabBiyolojikModel => 'BİYOLOJİK MODEL';

  @override
  String get koloniDetayTabPerformans => 'PERFORMANS';

  @override
  String get koloniDetayMuayeneEkle => 'Muayene Ekle';

  @override
  String get koloniDetayOzetSurec => 'SÜREÇ';

  @override
  String get koloniDetayOzetBiyoloji => 'BİYOLOJİ';

  @override
  String get koloniDetayOzetYonetim => 'YÖNETİM';

  @override
  String get koloniDetayOzetGenetik => 'GENETİK';

  @override
  String get koloniDetayPerfVeriBulunamadi =>
      'Performans özeti verisi bulunamadı.';

  @override
  String get ayarlarBaslik => 'AYARLAR VE KALİBRASYON';

  @override
  String get ayarlarTabGenel => 'GENEL';

  @override
  String get ayarlarTabSistem => 'SİSTEM';

  @override
  String get ayarlarKaydediliyor => 'KAYDEDİLİYOR...';

  @override
  String get ayarlarKaydet => 'GENEL AYARLARI KAYDET';

  @override
  String ayarlarKaydedilemedi(String hata) {
    return 'Ayarlar kaydedilemedi: $hata';
  }

  @override
  String get ayarlarYedekHazir => 'Yedek hazırlandı. Güvenli bir yere kaydet.';

  @override
  String ayarlarYedekHata(String hata) {
    return 'Yedek alınırken hata oluştu: $hata';
  }

  @override
  String get ayarlarGeriYukleBaslik => 'YEDEKTEN GERİ YÜKLE';

  @override
  String get ayarlarGeriYukleButon => 'Yüklemeyi Başlat';

  @override
  String get ayarlarGeriYukleTamamlandi => 'Yedekten geri yükleme tamamlandı.';

  @override
  String ayarlarGeriYukleHata(String hata) {
    return 'Yedek yüklenirken hata oluştu: $hata';
  }

  @override
  String ayarlarGuncellemHata(String hata) {
    return 'Güncelleme kontrolü başarısız: $hata';
  }

  @override
  String get ayarlarKalibrasyonTamam =>
      'Arılık kalibrasyonu tanımlı. Sistem sezon ve bal akımı bağlamını kullanabilir.';

  @override
  String get ayarlarKalibrasyonEksik =>
      'Arılık kalibrasyonu eksik. Sezon ve bal akımı tanımları gözden geçirilmeli.';

  @override
  String get ayarlarTarihFormatNotu =>
      'Tarih gösterimi gün/ay formatındadır; kayıt formatı sistem içinde korunur.';

  @override
  String ayarlarBaslangicTarih(String tarih) {
    return 'Başlangıç: $tarih';
  }

  @override
  String ayarlarBitisTarih(String tarih) {
    return 'Bitiş: $tarih';
  }

  @override
  String get ayarlarDavranisTercihi => 'DAVRANIŞ TERCİHİ';

  @override
  String get ayarlarDavranisTercihiAciklama =>
      'Bu ayar yalnızca genetik seçilim ve donör filtresi tarafını etkiler. Çekirdek eşikleri değiştirmez.';

  @override
  String get ayarlarDavranisStandart => 'Standart';

  @override
  String get ayarlarDavranisStandartAciklama =>
      'Yönetilebilir koloniler önceliklidir. Hırçınlık seçilim tarafında daha belirgin eksidir.';

  @override
  String get ayarlarDavranisEsnek => 'Esnek';

  @override
  String get ayarlarDavranisEsnekAciklama =>
      'Güç ve verim öne çıkıyorsa davranış verisi seçilim tarafında daha yumuşak yorumlanır.';

  @override
  String get ayarlarKalibrasyonKapsami => 'KALİBRASYON KAPSAMI';

  @override
  String get ayarlarKalibrasyonKapsamiAciklama =>
      'Bal akımı ve genel risk takvimi bu kapsama göre kaydedilir. Tüm arılıklar seçilirse genel varsayılanlar güncellenir. Tek arılık seçilirse yalnızca o arılık için özel kalibrasyon oluşturulur.';

  @override
  String get ayarlarKalibrasyonLabel => 'Bu kalibrasyonu kullan';

  @override
  String get ayarlarKalibrasyonTumAriliklar => 'Tüm arılıklar için kullan';

  @override
  String ayarlarKalibrasyonYalnizca(String ad) {
    return 'Yalnızca $ad arılığı için kullan';
  }

  @override
  String get ayarlarKalibrasyonGenelAciklama =>
      'Şu anda genel varsayılan kalibrasyonu düzenliyorsun. Özel ayarı olmayan tüm arılıklar bunu kullanır.';

  @override
  String ayarlarKalibrasyonOzelAciklama(String kapsam) {
    return '$kapsam için özel kalibrasyon alanı açık. Burada yaptığın bal akımı ve risk takvimi değişiklikleri diğer arılıkları etkilemez.';
  }

  @override
  String get ayarlarBalAkimiBilgi =>
      'Bal akımı pencereleri biyolojik geri sayımların temel referansıdır. İlk pencere zorunlu, ikinci pencere ise sadece gerçekten ihtiyaç varsa açık tutulur.';

  @override
  String get ayarlarIkinciBalAkimi => '2. bal akımını kullan';

  @override
  String get ayarlarIkinciBalAkimiAciklama =>
      'Örn: Ağustos / Eylül çam balı. İhtiyacın yoksa kapalı bırak.';

  @override
  String get ayarlarRiskTakvimiBilgi =>
      'Genel risk takvimi koloniye özel karar üretmez. Arı kuşu, eşek arısı, yağmacılık, mum güvesi ve fare gibi dönemsel riskleri arılık ekranında hatırlatır. Tarihleri kendi bölgenin gerçek baskı dönemine göre daraltabilirsin.';

  @override
  String get ayarlarAriKusuDonemi => 'Arı Kuşu Risk Dönemi';

  @override
  String get ayarlarAriKusuAciklama =>
      'Varsayılan: Mayıs – Ağustos. Kendi bölgenin göç ve baskı dönemine göre daraltabilirsin.';

  @override
  String get ayarlarEsekArisiDonemi => 'Eşek Arısı / Sarıca Risk Dönemi';

  @override
  String get ayarlarEsekArisiAciklama =>
      'Varsayılan: Temmuz – Ekim. Baskının yoğunlaştığı döneme göre ayarla.';

  @override
  String get ayarlarYagmacilikDonemi => 'Yağmacılık Risk Dönemi';

  @override
  String get ayarlarYagmacilikAciklama =>
      'Varsayılan: Temmuz – Eylül. Hasat sonrası ve kurak dönem baskısına göre ayarla.';

  @override
  String get ayarlarMumGuvesiDonemi => 'Mum Güvesi Risk Dönemi';

  @override
  String get ayarlarMumGuvesiAciklama =>
      'Varsayılan: Haziran – Eylül. Sıcak dönem ve zayıf koloni riskine göre ayarla.';

  @override
  String get ayarlarFareDonemi => 'Fare Risk Dönemi';

  @override
  String get ayarlarFareAciklama =>
      'Varsayılan: Kasım – Şubat. Bu aralık yıl taşar; sistem bunu doğru yorumlar.';

  @override
  String get ayarlarKisDonemi => 'Kış / Dayanıklılık Dönemi';

  @override
  String get ayarlarKisAciklama =>
      'Varsayılan yapı 1 Eylül – 15 Marttır. Gerekirse sahana göre ince ayar yap.';

  @override
  String get ayarlarUretimDonemi => 'Aktif / Üretim Dönemi';

  @override
  String get ayarlarUretimAciklama =>
      'Varsayılan yapı 15 Mart – 31 Ağustostur. Gerekirse sahana göre ince ayar yap.';

  @override
  String get ayarlarBalAkimiAraligi1 => 'Bal Akımı Aralığı 1';

  @override
  String get ayarlarBalAkimiAraligi1Aciklama =>
      'İlk ana akım. Örn: Mayıs sonu / Haziran başı.';

  @override
  String get ayarlarBalAkimiAraligi2 => 'Bal Akımı Aralığı 2';

  @override
  String get ayarlarBalAkimiAraligi2Aciklama =>
      'İkinci akım. Örn: Ağustos / Eylül çam balı.';

  @override
  String get ayarlarRehberiAc => 'Kullanıcı rehberini aç';

  @override
  String get ayarlarSistemBilgi =>
      'Yedek alma ve geri yükleme akışı sistemde tutulur. Geri yükleme sonrası bakım adımı çalıştırılır ve karar önbelleği temizlenir.';

  @override
  String get ayarlarUygulamaKimligi => 'UYGULAMA KİMLİĞİ';

  @override
  String get ayarlarKimlikUygulama => 'Uygulama';

  @override
  String get ayarlarKimlikTanim => 'Tanım';

  @override
  String get ayarlarKimlikSurum => 'Sürüm';

  @override
  String get ayarlarKimlikYil => 'Yıl';

  @override
  String get ayarlarKimlikUretici => 'Üretici';

  @override
  String get ayarlarKimlikVeri => 'Veri';

  @override
  String get ayarlarKimlikSistemAmaci =>
      'Sistem amacı: basit saha verisini zaman, olay ve süreç mantığıyla okuyarak uygulanabilir koloni kararı üretmek.';

  @override
  String get ayarlarSurumYukleniyor => 'Yükleniyor';

  @override
  String get ayarlarYedekAl => 'Yedek Al';

  @override
  String get ayarlarYedekAlAciklama =>
      'Tüm veriyi JSON yedek dosyası olarak oluştur ve paylaş.';

  @override
  String get ayarlarYedekYukle => 'Yedekten Yükle';

  @override
  String get ayarlarYedekYukleAciklama =>
      'Daha önce aldığın JSON yedeğini seç ve mevcut verinin yerine yükle.';

  @override
  String get ayarlarGuncelleKontrol => 'Güncellemeyi Kontrol Et';

  @override
  String get ayarlarGuncelleKontrolAciklama =>
      'Yeni sürüm varsa önce yedek aldırır, ardından güvenli APK bağlantısını açar.';

  @override
  String get ayarlarYedekUyari =>
      'Yedekten yükleme mevcut veriyi tamamen değiştirir. Yüklemeden hemen önce yeni bir yedek almak en güvenli yaklaşımdır.';

  @override
  String get ayarlarGizlilik => 'Gizlilik Politikası';

  @override
  String get ayarlarGizlilikAciklama =>
      'Uygulama veri kullanımı ve gizlilik ilkelerini görüntüle.';

  @override
  String get ayarlarGelistirici => 'GELİŞTİRİCİ';

  @override
  String get ayarlarProMod => 'PRO mod (test)';

  @override
  String get ayarlarProModAciklama =>
      'PRO özellikleri kilit olmadan görüntüler.';

  @override
  String get ayarlarDilTest => 'Dil (test)';

  @override
  String get ayarlarDilAciklama =>
      'Yalnızca lokalizasyon sistemine taşınan metinleri etkiler.';

  @override
  String get ayarlarKaydedildi =>
      'Genel ayarlar tüm arılıklar için kaydedildi.';

  @override
  String ayarlarOzelKaydedildi(String kapsam) {
    return '$kapsam arılığı için özel kalibrasyon kaydedildi.';
  }

  @override
  String get ayarlarGeriYukleIcerik =>
      'Bu işlem mevcut veriyi seçtiğin yedek ile tamamen değiştirir. Devam etmeden önce güncel bir yedek alman önerilir. Şimdi yükleme başlasın mı?';

  @override
  String ayarlarUygulamaGuncel(String surum, String kod) {
    return 'Uygulama güncel. Mevcut sürüm: $surum ($kod)';
  }

  @override
  String get yeniKoloniBaslik => 'YENİ KOLONİ KAYDI';

  @override
  String get yeniKoloniDuzenle => 'KOLONİ DÜZENLE';

  @override
  String get yeniKoloniGecmisTarihBaslik => 'Geçmiş tarih seçildi';

  @override
  String get yeniKoloniGecmisTarihIcerik =>
      'Koloni başlangıç tarihini geriye çekiyorsun. Bu doğruysa devam et. Sistem, tarih arılık başlangıcı veya ilk muayene ile çelişirse kaydı engeller.';

  @override
  String get yeniKoloniEvetDegistir => 'Evet, değiştir';

  @override
  String get yeniKoloniKaynakBulunamadi =>
      'Seçilen kaynak koloni bu arılıkta bulunamadı. Lütfen listeden geçerli bir kaynak koloni seç.';

  @override
  String yeniKoloniKayitHata(String hata) {
    return 'Kayıt sırasında teknik sorun oluştu: $hata';
  }

  @override
  String get yeniKoloniBolumKaynakOlusumBilgisi => 'Kaynak ve Oluşum Bilgisi';

  @override
  String get yeniKoloniBolumSahaBilgileri => 'Temel Saha Bilgileri';

  @override
  String get yeniKoloniBolumNotlar => 'Notlar';

  @override
  String get yeniKoloniKaynakTipiLabel => 'Kaynak Tipi';

  @override
  String get yeniKoloniKaynakAnaHat => 'Ana Hat';

  @override
  String get yeniKoloniKaynakBolme => 'Bölme';

  @override
  String get yeniKoloniKaynakOgul => 'Oğul';

  @override
  String get yeniKoloniKaynakBilgiAnaHat =>
      'Ana Hat seçildi. Kaynak koloni istenmez. Sistem bu koloniyi yeni kök hat olarak başlatır.';

  @override
  String get yeniKoloniKaynakBilgiBolme =>
      'Önce kaynak koloniyi seç, sonra yeni kovan numarasını gir. Sistem soy bağını buna göre kurar.';

  @override
  String get yeniKoloniKaynakBilgiOgul =>
      'Önce oğulun çıktığı kaynak koloniyi seç, sonra yeni kovan numarasını gir. Oğul hazır analı kabul edilir; ayrıca ana kazanma yöntemi seçilmez.';

  @override
  String get yeniKoloniKaynakBilgiVarsayilan =>
      'Kaynak bilgisi sistem kimliği ve soy bağı için kullanılır.';

  @override
  String get yeniKoloniAnaKazanmaLabel => 'Ana Kazanma Yöntemi';

  @override
  String get yeniKoloniAnaKazanmaBilgiKapaliMeme =>
      'Takvim sıfırdan ana yapma gibi değil, kapalı meme aşamasından başlatılır. 5. gün meme bozma uyarısı verilmez.';

  @override
  String get yeniKoloniAnaKazanmaBilgiHazirAna =>
      'Meme takvimi çalışmaz. Sistem kabul ve yumurtlama kontrolü penceresine odaklanır.';

  @override
  String get yeniKoloniAnaKazanmaBilgiKendiAnasi =>
      'Takvim sıfırdan ana yapma süreciyle başlar. 5. gün kapalı meme kontrolü anlamlıdır.';

  @override
  String get yeniKoloniKaynakKoloniLabel => 'Kaynak Koloni';

  @override
  String get yeniKoloniDisKaynak => 'Dış Kaynak';

  @override
  String get yeniKoloniKaynakKoloniValidasyon => 'Kaynak koloni seçmelisin.';

  @override
  String get yeniKoloniKovanTipiLabel => 'Kovan Tipi';

  @override
  String get yeniKoloniSurupluk => 'Şurupluk';

  @override
  String get yeniKoloniSuruplukVar => 'Alt kat 9 çıta';

  @override
  String get yeniKoloniSuruplukYok => 'Alt kat 10 çıta';

  @override
  String get yeniKoloniSuruplukBilgiVar =>
      'Şurupluk varsa sistem alt kuluçkalığı 9 çıta kabul eder; üstündeki çıtaları kat/ballık alanı olarak yorumlar.';

  @override
  String get yeniKoloniSuruplukBilgiYok =>
      'Şurupluk yoksa sistem alt kuluçkalığı 10 çıta kabul eder; üstündeki çıtaları kat/ballık alanı olarak yorumlar.';

  @override
  String get yeniKoloniBaslangicTarihi => 'Koloni başlangıç tarihi';

  @override
  String get yeniKoloniKovanNoLabel => 'Kovan No / Saha Etiketi';

  @override
  String get yeniKoloniAnaAriYili => 'Ana Arı Yılı';

  @override
  String get yeniKoloniSahaSirasi => 'Saha Sırası';

  @override
  String get yeniKoloniIlkCitaSayisi => 'İlk Toplam Çıta Sayısı';

  @override
  String get yeniKoloniSahaBilgisiNot =>
      'Bu ekranda yalnızca saha bilgileri girilir. Sistem kimliği, ana soy hattı ve genetik hat kodu otomatik türetilir; koloni detayında bilgi olarak gösterilir.';

  @override
  String get yeniKoloniOzelNotlar => 'Özel Notlar';

  @override
  String get yeniKoloniAlanZorunlu => 'Bu alan zorunlu.';

  @override
  String get yeniKoloniSayiGir => 'Sayı gir.';

  @override
  String get yeniKoloniBilgileriKaydet => 'BİLGİLERİ KAYDET';

  @override
  String get arilikSecimBaslik => 'ARILIK SEÇİMİ';

  @override
  String get arilikSecimRaporBaslik => 'RAPOR İÇİN ARILIK SEÇ';

  @override
  String get arilikSecimBos => 'Henüz arılık eklenmemiş.';

  @override
  String get arilikSecimIlkEkle => 'İlk Arılığını Ekle';

  @override
  String get arilikSecimYeniEkleBaslik => 'Yeni Arılık Ekle';

  @override
  String get arilikSecimArilikAdi => 'Arılık adı';

  @override
  String get arilikSecimAdiHint => 'Örn: Uluköy';

  @override
  String get arilikSecimBaslangicTarihi => 'Arılık başlangıç tarihi';

  @override
  String get arilikSecimGecmisTarihMesaji =>
      'Arılık başlangıç tarihini geriye çekiyorsun. Bu doğruysa devam et. Sistem yine de koloni ve muayene tarihleriyle çakışırsa kaydı engeller.';

  @override
  String get arilikSecimDuzenleTarihMesaji =>
      'Arılık başlangıç tarihini geriye çekiyorsun. Bu doğruysa devam et. Sistem, bu tarih koloni veya muayene kayıtlarıyla çelişirse kaydı engeller.';

  @override
  String get arilikSecimKalibrasyon => 'Kalibrasyon';

  @override
  String get arilikSecimVarsayilanKal => 'Varsayılan kalibrasyonu kullan';

  @override
  String get arilikSecimVarsayilanKalAciklama =>
      'Yeni arılık özel ayar oluşturmaz; genel varsayılan bal akımı ve risk takvimini kullanır.';

  @override
  String get arilikSecimKopyalaKal => 'Mevcut bir arılıktan kopyala';

  @override
  String get arilikSecimKopyalaKalAciklama =>
      'Seçilen arılığın bal akımı ve genel risk takvimi yeni arılığa özel kalibrasyon olarak kopyalanır.';

  @override
  String get arilikSecimKopyalanacakArilik => 'Kopyalanacak arılık';

  @override
  String get arilikSecimKalibrasyonSecmelisin =>
      'Kalibrasyon kopyalanacak arılığı seçmelisin.';

  @override
  String arilikSecimKayitHata(String hata) {
    return 'Arılık kaydedilemedi: $hata';
  }

  @override
  String get arilikSecimDuzenleBaslik => 'Arılık Bilgilerini Düzenle';

  @override
  String get arilikSecimDuzenleKural =>
      'Kural: Arılık başlangıç tarihi, bu arılıktaki koloni ve muayene tarihlerinden sonra olamaz. Aynı tarih kabul edilir.';

  @override
  String arilikSecimGuncellenemedi(String hata) {
    return 'Arılık güncellenemedi: $hata';
  }

  @override
  String arilikSecimUyariGizlendi(String baslik) {
    return '$baslik bu arılıkta bu sezon gizlendi.';
  }

  @override
  String get arilikSecimSilBaslik => 'ARILIĞI SİL';

  @override
  String arilikSecimSilIcerik(String ad, int toplam, int aktif, int pasif) {
    return 'Bu işlem geri alınamaz.\n\nSilinecek arılık: $ad\nToplam koloni: $toplam\nAktif koloni: $aktif\nPasif / sönmüş koloni: $pasif\n\nBu arılığa bağlı koloniler, muayeneler, olay kayıtları, numara geçmişi ve arılık özel kalibrasyonları silinir.\n\nDevam etmeden önce güncel yedek aldığından emin ol.';
  }

  @override
  String arilikSecimSilindi(String ad) {
    return '$ad arılığı silindi.';
  }

  @override
  String arilikSecimSilinemedi(String hata) {
    return 'Arılık silinemedi: $hata';
  }

  @override
  String get arilikSecimSonOnayBaslik => 'SON ONAY';

  @override
  String get arilikSecimSonOnayIcerik =>
      'Silme işlemini kesinleştirmek için arılık adını birebir yaz.';

  @override
  String get arilikSecimAdiYaz => 'Arılık adını yaz';

  @override
  String get arilikSecimKaliciSilUyari =>
      'Bu işlem arılık verisini kalıcı olarak siler.';

  @override
  String get arilikSecimKaliciSil => 'Kalıcı Olarak Sil';

  @override
  String arilikSecimAktifToplam(int aktif, int toplam) {
    return 'Aktif $aktif / Toplam $toplam';
  }

  @override
  String arilikSecimUyariSayisi(int sayi) {
    return '$sayi aktif genel uyarı var';
  }

  @override
  String get arilikSecimDetaylariAc => 'Detayları göster';

  @override
  String get arilikSecimDetaylariKapat => 'Detayları kapat';

  @override
  String get arilikSecimBuSezonGosterme => 'Bu arılıkta bu sezon gösterme';

  @override
  String arilikSecimBaslangic(String tarih) {
    return 'Başlangıç: $tarih';
  }

  @override
  String get arilikSecimDuzenleTooltip => 'Arılığı düzenle';

  @override
  String get arilikSecimSilTooltip => 'Arılığı sil';

  @override
  String get arilikSecimGir => 'Arılığa gir';

  @override
  String get arilikSecimToplam => 'Toplam';

  @override
  String get arilikSecimAktif => 'Aktif';

  @override
  String get arilikSecimPasif => 'Pasif';

  @override
  String muayeneEkleAppBarBaslik(String tarih) {
    return '$tarih / Muayene Girişi';
  }

  @override
  String get muayeneEkleGecmisTarihIcerik =>
      'Muayene tarihini geriye çekiyorsun. Bu doğruysa devam et. Sistem, tarih koloni başlangıcı veya arılık başlangıcı ile çelişirse kaydı engeller.';

  @override
  String get muayeneEkleSesHata1 =>
      'Ses algılama başlatılamadı. Android mikrofon iznini kontrol et.';

  @override
  String get muayeneEkleSesHata2 => 'Bu cihazda sesle yazma kullanılamıyor.';

  @override
  String get muayeneEkleSesHata3 => 'Sesle not ekleme sırasında hata oluştu.';

  @override
  String muayeneEkleKayitHata(String hata) {
    return 'Teknik sorun oluştu: $hata';
  }

  @override
  String muayeneEkleKovanEtiket(String no) {
    return 'KOVAN: $no';
  }

  @override
  String muayeneEkleArilikEtiket(String ad) {
    return 'ARILIK: $ad';
  }

  @override
  String get muayeneEkleMuayeneTarihi => 'Muayene Tarihi';

  @override
  String get muayeneEkleToplam => 'Toplam';

  @override
  String get muayeneEkleYavrulu => 'Yavrulu';

  @override
  String get muayeneEkleBalHasat => 'Bal/Hasat';

  @override
  String muayeneEklePetekAktivasyonBaslik(int artis) {
    return 'Petek / Hacim Aktivasyonu (+$artis çıta)';
  }

  @override
  String muayeneEklePetekAktivasyonAniArtis(int artis) {
    return 'Son muayeneye göre $artis çıta artış var. Koloni 9–10 çıta seviyesine ulaşmadan hızlı genişletme yapıldıysa sıkışık düzen bozulabilir. Sistem bu yeni hacmi hemen tam işlevsel kapasite saymaz.';
  }

  @override
  String get muayeneEklePetekAktivasyonKatGecis =>
      'Koloni 9–10 çıta eşiğinden 11+ çıtaya geçtiği için sistem bunu kat/ballık geçişi olarak okur. Yeni üst hacim kademeli işlev kazanır.';

  @override
  String get muayeneEklePetekAktivasyonNormal =>
      'Yeni verilen çıta fiziksel olarak kaydedilir; biyolojik model bu çıtanın işlev kazanmasını zamana yayarak değerlendirir.';

  @override
  String get muayeneEklePetekDagilimBilgi =>
      'Eklenen peteklerin dağılımını gir. Temel ve kabarmış petek birlikte verilebilir; toplam artış sayısını geçmez.';

  @override
  String get muayeneEkleTemel => 'Temel';

  @override
  String get muayeneEkleKabarmis => 'Kabarmış';

  @override
  String muayeneEklePetekToplam(int toplam, int artis) {
    return 'Toplam: $toplam / $artis çıta';
  }

  @override
  String get muayeneEkleYavruDuzeniLabel => 'Yavru Düzeni';

  @override
  String get muayeneEkleKoloniMizaci => 'Koloni Mizacı';

  @override
  String get muayeneEkleBeslemeLabel => 'Besleme';

  @override
  String get muayeneEkleVarroaLabel => 'Varroa Mücadelesi';

  @override
  String get muayeneEkleOgulBelirtisiBaslik => 'Oğul Belirtisi';

  @override
  String get muayeneEkleOgulBelirtisiAciklama =>
      'Karar önerisi ve yakın izleme sinyali üretir.';

  @override
  String get muayeneEkleOgulAttiBaslik => 'Oğul Attı';

  @override
  String get muayeneEkleOgulAttiAciklama =>
      'Gerçekleşmiş olaydır. Skor ve hat pozisyonunu etkiler.';

  @override
  String get muayeneEkleAnaGorulmedi => 'Ana Görülmedi';

  @override
  String get muayeneEkleBolmeYapildiBaslik => 'Bölme Yapıldı';

  @override
  String get muayeneEkleBolmeYapildiAciklama =>
      'Çıta düşüşü performans kaybı değil, kontrollü çoğalma olarak yorumlanır.';

  @override
  String get muayeneEkleKovanSonduBaslik => 'Kovan Söndü';

  @override
  String get muayeneEkleKovanSonduAciklama =>
      'Koloninin aktif performans yerine yaşam döngüsü sonu olarak değerlendirilmesini sağlar.';

  @override
  String get muayeneEkleAnauretimBaslik => 'Ana Üretimi ve Zamanlama';

  @override
  String get muayeneEkleAnauretimBilgi =>
      'Biyolojik ana kazanma takvimi yalnızca gerçekten anasız bırakılan koloni için çalışır. Anaç kolonideki bölme işlemi ayrı olarak toparlanma süreci üretir.';

  @override
  String get muayeneEkleAnasizBirakildiBaslik => 'Koloni Anasız Bırakıldı';

  @override
  String get muayeneEkleAnasizBirakildiAciklama =>
      'Gün hesabı ve biyolojik pencere yorumu için kritik bilgidir.';

  @override
  String get muayeneEkleKaydet => 'KAYDET';

  @override
  String get muayeneEkleGuncelle => 'GÜNCELLE';

  @override
  String get muayeneEkleNotlarLabel => 'Notlar';

  @override
  String get muayeneEkleSesBasla => 'Sesle not ekle';

  @override
  String get muayeneEkleSesDurdur => 'Sesle yazmayı durdur';

  @override
  String get muayeneEkleSesHelper =>
      'Mikrofona dokunarak sesle not ekleyebilirsin.';

  @override
  String get muayeneEkleSesHelperAktif =>
      'Dinleniyor... Konuşman not alanına yazılıyor.';

  @override
  String get muayeneEkleOnYuklemeBilgi =>
      'Son muayene verileri ön yüklendi. Gerekli alanları güncelleyerek devam edebilirsin.';

  @override
  String get muayeneEkleBolmeBilgi =>
      'Yeni açılan kolonide Kaynak Koloni bilgisini girmen, soy takibi ve performans analizini güçlendirir.';

  @override
  String get muayeneEkleOgulAttiBilgi =>
      'Oğul attı, gerçekleşmiş olaydır. Seçilim ve hat değerlendirmesini etkiler.';

  @override
  String get muayeneEkleSuruplukEklendi => 'Şurupluk eklendi';

  @override
  String get muayeneEkleSuruplukEklendiAciklama =>
      'Bu koloni şurupluksuz. Muayenede şurupluk eklendiyse işaretle; aksi hâlde kaldırılmış sayılmaya devam eder.';

  @override
  String get muayeneEkleSuruplukKaldirildi => 'Şurupluk kaldırıldı';

  @override
  String get muayeneEkleSuruplukKaldirildiHasat =>
      'Bu kayıt hasat sonrası bakım olarak okunur; besleme seçimi yeniden kullanılabilir.';

  @override
  String get muayeneEkleSuruplukKaldirildiNormal =>
      'İşaretlersen biyolojik modelde şurupluk kalkar ve petek düzeni sola kayar.';

  @override
  String get muayeneEkleSuruplukVarsayilanMesaj =>
      'Bal akımı yaklaşıyor. Şeker kalıntısı riskini azaltmak için besleme sonlandırılmalı; şurupluk kaldırılıp yerine petek verilebilir.';

  @override
  String get muayeneEkleSuruplukHasatMesaj =>
      'Bal/hasat kaydı girildi. Hasat sonrası bakım döneminde besleme alanı yeniden açılır; şurupluk ihtiyaç varsa tekrar kullanılabilir. İkinci bal akımı penceresi açıldığında aynı şurupluk kaldırma ve besleme kesme döngüsü yeniden çalışır.';

  @override
  String get muayeneEkleSuruplukBildirilenKisit =>
      'Bal akımı yaklaştığı için besleme kısıtı başladı. Şeker kalıntısı riskini azaltmak için şurupluğu gerçekten kaldırdıysan işaretle.';

  @override
  String get muayeneEkleBeslemeSuruplukBilgi =>
      'Şurupluk kaldırıldı olarak işaretlendi. Aynı muayenede şeker bazlı besleme seçimi kapatıldı; bu kayıt hasat hazırlığı olarak okunur.';

  @override
  String get muayeneEkleHasatBakimBilgi =>
      'Bal/hasat kaydı girildiği için besleme alanı yeniden aktif. Bu dönem hasat sonrası bakım olarak okunur. İkinci bal akımı aktif olursa sistem yeniden besleme kesme ve şurupluk kaldırma uyarısına döner.';

  @override
  String get muayeneEkleGunlukYavruBaslik => 'Günlük / kapalı yavru görüldü';

  @override
  String get muayeneEkleGunlukYavruAciklama =>
      'Bölme, oğul, ana kazanma veya yavru yok takibinde kapanış işaretidir. İşaretlersen sistem yavru görülmeme penceresini kapatır ve koloniyi normal düzene alır.';

  @override
  String get muayeneEkleYavruYokErken =>
      'Yavru düzeni \"Yok\" olarak kaydedilecek. Aktif biyolojik süreçte erken pencere olabilir; bu aşamada yavru görülmemesi tek başına alarm değildir.';

  @override
  String get muayeneEkleYavruYokErkenVarsayilan =>
      'Gereksiz açma ve sert müdahale önerilmez.';

  @override
  String get muayeneEkleYavruYokTani =>
      'Yavru düzeni \"Yok\" olarak kaydedilecek. Sistem artık kısa tanı gözlemleriyle bal baskısı, geç çiftleşme, ana sorunu veya biyolojik zayıflama olasılıklarını ayıracak.';

  @override
  String get muayeneEkleYavruYokNormal =>
      'Yavru düzeni \"Yok\" olarak kaydedilecek. Sistem bunu normal koloni bağlamında ayrı okuyacak; yavrulu çıta sayısı 0 kabul edilir ve biyolojik model geri dönüş kapasitesini buna göre hesaplar.';

  @override
  String get muayeneEkleYavruYokTaniBaslik => 'Yavru Yok Kısa Tanı Gözlemleri';

  @override
  String get muayeneEkleYavruYokTaniAciklama =>
      'Bu alan teşhis seçtirmez. Sistem bu 4 basit gözlemi mevcut sezon, süreç penceresi ve koloni gücüyle birlikte okuyarak öneri üretir.';

  @override
  String get muayeneEkleTaniKoloniSakin => 'Koloni sakin mi?';

  @override
  String get muayeneEkleTaniKoloniSakinAciklama =>
      'Sakin koloni içeride yeni ana olma ihtimalini artırır. Huzursuz koloni anasızlık/stres şüphesini yükseltir.';

  @override
  String get muayeneEkleTaniPolen => 'Polen gelişi var mı?';

  @override
  String get muayeneEkleTaniPolenAciklama =>
      'Polen gelişi, yavru hazırlığı veya içeride ana varlığı ihtimalini destekler. Polen yokluğu biyolojik durgunluk riskini artırır.';

  @override
  String get muayeneEkleTaniBal => 'Bal / nektar gelişi güçlü mü?';

  @override
  String get muayeneEkleTaniBalAciklama =>
      'Güçlü akım yumurtlama alanını daraltabilir. Bu durumda yavru yokluğu doğrudan anasızlık anlamına gelmeyebilir.';

  @override
  String get muayeneEkleTaniErkek => 'Erkek yavru gözleri baskın mı?';

  @override
  String get muayeneEkleTaniErkekAciklama =>
      'Evet ise çiftleşememiş ana, başarısız ana veya yalancı ana riski artar. Bu cevap bekleme kararını sertleştirir.';

  @override
  String get muayeneEkleTaniEminDegil => 'Emin değilim';

  @override
  String get rehberBaslik => 'KULLANICI REHBERİ';

  @override
  String get rehberProOzellik => 'Özellik';

  @override
  String get rehberProUcretsiz => 'Ücretsiz';

  @override
  String get rehberProPRO => 'PRO';

  @override
  String get rehberProS1 => 'Sınırsız koloni kaydı';

  @override
  String get rehberProS2 => 'Muayene formu ve geçmiş';

  @override
  String get rehberProS3 => 'Kovan yerleşim görseli';

  @override
  String get rehberProS4 => 'Tahmini arı sayısı';

  @override
  String get rehberProS5 => 'Özet yorum (tek cümle)';

  @override
  String get rehberProS6 => 'Yönetim kararı detayı';

  @override
  String get rehberProS7 => 'Risk analizi (Varroa, arı kuşu…)';

  @override
  String get rehberProS8 => 'Hasat projeksiyonu ve miktar';

  @override
  String get rehberProS9 => 'Ekonomik değer tahmini';

  @override
  String get rehberProS10 => 'Demografi ve kabiliyet skorları';

  @override
  String get rehberProS11 => 'Koloni projeksiyonu';

  @override
  String get rehberProS12 => 'Performans raporları';

  @override
  String get rehberProS13 => 'Hat analizi';

  @override
  String get rehberProS14 => 'Koloni karşılaştırma';

  @override
  String get rehberProS15 => 'Soy ağacı';

  @override
  String get rehberProS16 => 'Formüller ve hesaplamalar';

  @override
  String get rehber1Baslik => '1. İTOGENA Ne Yapar?';

  @override
  String get rehber1Kutu =>
      'İTOGENA, basit saha verisini zaman, süreç, soy, performans ve arılık kalibrasyonu ile birlikte okuyarak uygulanabilir koloni kararı üretir. Amaç yalnızca kayıt tutmak değil; arıcıya neyi, neden ve ne zaman yapacağını anlaşılır biçimde göstermektir.';

  @override
  String get rehber1M1 =>
      'Sistem tetik → süreç → öneri → saha eylemi → yeni muayene → kapanış mantığıyla çalışır.';

  @override
  String get rehber1M2 =>
      'Koloni sınıfı tek biyolojik kaynaktan üretilir: işlevsel üretim çıtası 0–3 ise zayıf, 4–7 ise gelişim, 8–9 ise üretim, 10 ve üzeri ise hasat sınıfıdır.';

  @override
  String get rehber1M3 =>
      'Her süreç için ayrıca onay istemez; sonucu sonraki muayene verisinden anlamaya çalışır.';

  @override
  String get rehber1M4 =>
      'Koloni detay ekranı hızlı açılır; ağır analizler arka planda yüklenir.';

  @override
  String get rehber1M5 =>
      'Sistem fiziksel çıta ile işlevsel üretim kapasitesini ayrı okur. Hızlı genişleme, temel petek yüklenmesi veya hasat sonrası hacim değişimleri doğrudan güçlü koloni kabul edilmez.';

  @override
  String get rehber1M6 =>
      'Koloni detay genel durum ekranında dört ana başlık gösterilir: Süreç, Biyoloji, Yönetim ve Genetik.';

  @override
  String get rehber1M7 =>
      'Yönetim kartı besleme, kat, alan, varroa, kış ve hasat sonrası bakım kararlarını aynı yönetim listesinde standartlaştırır.';

  @override
  String get rehber1M8 =>
      'Muayene, koloni veya arılık verisi değiştiğinde tüm önbellekler birlikte temizlenir; eski kararın ekranda kalma riski azaltılır.';

  @override
  String get rehber2Baslik => '2. Ücretsiz ve PRO';

  @override
  String get rehber2Kutu =>
      'ITOGENA\'yı muayene kaydı ve temel koloni takibi için ücretsiz kullanabilirsin. Derin analiz, risk izleme, hasat tahmini ve raporlama PRO kapsamındadır.';

  @override
  String get rehber3Baslik => '3. Sistem Çıtadan Ne Anlar?';

  @override
  String get rehber3M1 =>
      'Çıta sayısı koloni gücünün temel saha göstergesidir; tek başına kesin karar değildir.';

  @override
  String get rehber3M2 =>
      'Son çıta mevcut canlı gücü, maksimum çıta sezon içi kapasiteyi, bal çıtası ise üretim dönemindeki verimi anlatır.';

  @override
  String get rehber3M3 =>
      'Kışta çıta gücü dayanıklılık için önemlidir; bal çıtası kış performansı gibi okunmaz.';

  @override
  String get rehber3M4 =>
      'Sistem çıta sayısını yalnızca sayı olarak değil, tahmini biyolojik kapasite olarak okur: arı nüfusu, göz kapasitesi, yavru/stok alanı, ana bölgesi ve hasat potansiyeli bu veriden türetilir.';

  @override
  String get rehber3M5 =>
      'Bu değerler kesin ölçüm değildir; iklim, flora, arı ırkı, sezon ve yönetim farkları sonucu değiştirebilir.';

  @override
  String get rehber3M6 =>
      'Langstroth varsayılan referanstır. Dadant seçilirse aynı biyolojik düzen korunur ancak çıta kapasitesi daha yüksek katsayıyla hesaplanır.';

  @override
  String get rehber3M7 =>
      'Şurupluk varsa alt kuluçkalık 9 çıta, yoksa 10 çıta kabul edilir. Bu sınırın üstündeki çıtalar kat/ballık alanı olarak yorumlanır.';

  @override
  String get rehber3bBaslik => '3B. İşlevsel Çıta ve Hacim Aktivasyonu';

  @override
  String get rehber3bM1 =>
      'İTOGENA fiziksel çıta ile işlevsel çıtayı ayrı okur. Kovandaki çıta sayısı fiziksel hacmi, koloninin gerçekten kullanabildiği alan ise işlevsel biyolojik kapasiteyi anlatır.';

  @override
  String get rehber3bM2 =>
      'Yeni verilen çıta hemen tam kapasite sayılmaz. Sistem temel petek veya kabarmış petek ayrımına, geçen gün sayısına, yavru düzenine, koloni gücüne ve bal akımı penceresine göre aktivasyon süresi hesaplar.';

  @override
  String get rehber3bM3 =>
      'Sistem sıkışık düzen varsayımıyla çalışır. Bir muayenede +1 çıta normal, +2 çıta kontrollü genişleme, +3 ve üzeri ise kat geçişi dışında uyarı sebebidir.';

  @override
  String get rehber3bM4 =>
      'Şurupluk + 9 çıta veya şurupluksuz 10 çıta %95 ve üzeri aktivasyona ulaşırsa sistem bunu \"Kat ver\" eşiği olarak okur.';

  @override
  String get rehber3bM5 =>
      'Şurupluk + 19 çıta veya şurupluksuz 20 çıta %95 ve üzeri aktivasyona ulaşırsa sistem \"3. kat ver\" uyarısı üretir.';

  @override
  String get rehber3bM6 =>
      'Hasat kaydıyla birlikte oluşan hızlı çıta düşüşü biyolojik çöküş sayılmaz; sistem bunu hasat kaynaklı hacim daralması olarak normalleştirir.';

  @override
  String get rehber3cBaslik => '3C. Sezon Biyoloji Matrisi';

  @override
  String get rehber3cM1 =>
      'İTOGENA sezonu yalnızca takvim adı olarak okumaz. Her sezon için yavru beklentisi, stok baskısı, polen/arı ekmeği beklentisi, ana amaç ve aktivasyon katsayısı birlikte değerlendirilir.';

  @override
  String get rehber3cM2 =>
      'Sistem kış, kış çıkışı, ilkbahar gelişimi, bal akımı öncesi, bal akımı, hasat sonrası, sonbahar hazırlık ve geç sonbahar evrelerini ayrı biyolojik davranışlar olarak ele alır.';

  @override
  String get rehber3cM3 =>
      'Bu matris koloniye doğrudan emir vermez; aktivasyon, kabiliyet, besleme, hasat ve bölme kararlarına biyolojik bağlam sağlar.';

  @override
  String get rehber3cM4 =>
      'Sezon bilgisi yerel bal akımı kalibrasyonu ile birlikte okunur. Bu nedenle aynı tarih her arılıkta aynı karar anlamına gelmeyebilir.';

  @override
  String get rehber3dBaslik => '3D. Koloni Gidişatı ve Normalize Momentum';

  @override
  String get rehber3dM1 =>
      'Koloni Gidişatı, koloninin yalnız bugünkü gücünü değil hangi yöne gittiğini anlatır. Momentum bu hesabın içinde yaşar.';

  @override
  String get rehber3dM2 =>
      'Momentum artık ham çıta artışı değildir. Hasat sonrası hızlı düşüş biyolojik çöküş sayılmaz; bölme sonrası düşüş işlem kaynaklı okunur; kat atılması ise fiziksel hacim artışı olduğu için aktivasyon tamamlanmadan tam büyüme kabul edilmez.';

  @override
  String get rehber3dM3 =>
      'Kat geçişi, riskli hızlı genişleme, düşük aktivasyon ve bal akımı içindeki sağlıklı üst hacim genişlemesi ayrı ayrı normalize edilir.';

  @override
  String get rehber3dM4 =>
      'Performans sekmesindeki Koloni Gidişatı; gelişim yönü, üretim yönü, alan baskısı, toparlanma potansiyeli, çöküş riski ve normalize momentumu birlikte okur.';

  @override
  String get rehber3eBaslik => '3E. Demografi Projeksiyonu';

  @override
  String get rehber3eM1 =>
      'Demografi projeksiyonu kesin arı sayımı yapmaz; çıta gücü, yavru yükü, sezon ve gelişim yönünden koloni içindeki iş gücü dağılımını tahmin eder.';

  @override
  String get rehber3eM2 =>
      'Sistem genç işçi, bakıcı arı, petek işleyici, iç işçi, bekçi, tarlacı ve erkek arı dağılımını saha kararı için ayrı ayrı okur.';

  @override
  String get rehber3eM3 =>
      'Genç işçi kapasitesi ham petek ve yavru bakım kararlarında; tarlacı kapasitesi bal akımı ve üretim kararlarında kullanılır.';

  @override
  String get rehber3eM4 =>
      'Demografi çıktısı \"kesin nüfus\" değildir; biyolojik olasılık ve saha projeksiyonudur.';

  @override
  String get rehber3fBaslik => '3F. İş Gücü ve Kabiliyet Projeksiyonu';

  @override
  String get rehber3fM1 =>
      'İTOGENA yalnızca kaç arı olduğunu değil, bu arıların hangi işi yapabilecek biyolojik kapasitede olduğunu yorumlamaya çalışır.';

  @override
  String get rehber3fM2 =>
      'Petek örme, yavru bakım, nektar toplama, bal işleme, savunma, toparlanma, kış dayanımı ve çiftleşme desteği ayrı iş gücü alanları olarak değerlendirilir.';

  @override
  String get rehber3fM3 =>
      'Aynı çıta sayısına sahip iki koloni farklı iş gücü kapasitesine sahip olabilir. Genç işçi oranı düşük koloniler geniş görünse bile hızlı petek işleme veya yavru büyütmede zorlanabilir.';

  @override
  String get rehber3fM4 =>
      'Bu projeksiyon kesin biyolojik ölçüm yapmaz; saha kararını destekleyen açıklanabilir biyolojik eğilim modeli üretir.';

  @override
  String get rehber3gBaslik => '3G. Risk Projeksiyonu ve Doğal Risk Frenleri';

  @override
  String get rehber3gM1 =>
      'Risk projeksiyonu koloniyi korkutucu uyarılarla yönetmez; sezonun doğal risk primini ve koloninin biyolojik kırılganlığını birlikte okuyarak dengeli karar freni üretir.';

  @override
  String get rehber3gM2 =>
      'Varroa, arı kuşu, eşek arısı, yağmacılık, nem/kış, aşırı genişleme, yavrusuzluk/yaşlanma ve bal kalitesi riski aynı merkezde değerlendirilir.';

  @override
  String get rehber3gM3 =>
      'Risk freni kararları doğrudan yasaklamaz. Genişletme, bölme, besleme, hasat ve müdahale önerilerini küçük katsayılarla temkinli hale getirir.';

  @override
  String get rehber3gM4 =>
      'Bu sistem kesin hastalık veya zararlı teşhisi koymaz; açıklanabilir risk eğilimi üretir.';

  @override
  String get rehber4Baslik => '4. Bölme Neden 9 Çıta Altında Önerilmez?';

  @override
  String get rehber4M1 =>
      '6 çıta biyolojik olarak mümkün olabilir; fakat güvenli saha önerisi değildir.';

  @override
  String get rehber4M2 =>
      'İTOGENA mümkün olanı değil, arıcıyı koloni kaybı riskinden koruyan doğru öneriyi verir.';

  @override
  String get rehber4M3 =>
      'Bölme önerisi için güvenli eşik 9 çıtadır. Ana koloni bölmeden sonra en az 5 çıta kalabilmeli, yeni bölme en az 4 çıta başlayabilmelidir.';

  @override
  String get rehber4M4 =>
      '6–8 çıta arası riskli kabul edilir; sistem bölme önermek yerine önce güçlendirmeyi söyler.';

  @override
  String get rehber4M5 => 'Kış döneminde bölme önerisi üretilmez.';

  @override
  String get rehber4M6 =>
      'Bölme kararı zaman bağlamıyla okunur. Bal akımına 57 günden fazla varsa güçlü kolonide bölme anlamlıdır; 57 günden az kaldıysa standart bölme üretim gücünü düşürebilir.';

  @override
  String get rehber5Baslik => '5. Donör Skoru ile Genel Skor Farkı Nedir?';

  @override
  String get rehber5M1 => 'Genel skor koloninin saha performansıdır.';

  @override
  String get rehber5M2 =>
      'Donör skoru ana üretimi ve genetik seçilim değeridir.';

  @override
  String get rehber5M3 =>
      '85 genel skor tek başına donörlük anlamına gelmez. Oğul izi/genetik filtre, soy devamlılığı, üreme gücü, dayanıklılık ve veri güveni ayrıca okunur.';

  @override
  String get rehber5M4 =>
      'Güçlü ama genetik filtreye takılan koloni üretimde veya kapalı yavru desteğinde değerlendirilebilir; ana üretim havuzuna alınmaz.';

  @override
  String get rehber6Baslik => '6. Oğul İzi ve Oğul Sonrası Süreç';

  @override
  String get rehber6M1 =>
      'Oğul sağlık problemi değildir; bu nedenle sağlık skorunu düşürmez.';

  @override
  String get rehber6M2 =>
      'Oğul kökeni veya oğul izi taşıyan koloni donör havuzuna girmez.';

  @override
  String get rehber6M3 =>
      'Oğul attı işaretlenirse koloni geçici olarak üretim/hasat kolonisi gibi okunmaz. 0–7. gün arası artçı oğul riski en yüksektir.';

  @override
  String get rehber6M4 =>
      '8–16. gün arası artçı oğul riski azalır. 17–30. gün yeni ana çıkışı, olgunlaşma ve çiftleşme penceresidir.';

  @override
  String get rehber6M5 =>
      '31–45. gün arası yumurtlama artık netleşmelidir. Hâlâ yavru yoksa sistem bunu ana başarısızlığı veya yalancı ana riski olarak değerlendirir.';

  @override
  String get rehber7Baslik => '7. Yavru Yok Alarmı ve Karar Önceliği';

  @override
  String get rehber7M1 =>
      'Yavru yok en kritik biyolojik alarmlardan biridir. Sistem önce bunun aktif bölme, oğul sonrası veya ana kazanma penceresinde normal bekleme olup olmadığını kontrol eder.';

  @override
  String get rehber7M2 =>
      'Bekleme penceresi aşılmışsa yavru yok; varroa, besleme ve hasat gibi rutin kararların önüne geçer. Grid kartta önce koloni devamlılığı konuşur.';

  @override
  String get rehber7M3 =>
      'Yalancı ana şüphesi, erkek yavru baskısı, ardışık yavrusuz kayıt ve güç düşüşü birlikte görülürse sistem bunu yüksek öncelikli ana problemi olarak ele alır.';

  @override
  String get rehber7M4 =>
      'Bal akımı içinde güçlü bal baskısı varsa yavru yokluğu hemen anasızlık sayılmaz; önce alan ve bal baskısı değerlendirilir.';

  @override
  String get rehber8Baslik => '8. Ana Kazanma Süreci Nasıl Okunur?';

  @override
  String get rehber8M1 =>
      'Ana kazanma süreci anasız bırakıldı, bölme, kapalı ana memesi veya hazır ana gibi tetiklerle başlar.';

  @override
  String get rehber8M2 =>
      'Kendi anasını yapacak kolonide 5. gün kapalı memeler bozulur; açık/kapanmamış kaliteli memeler bırakılır.';

  @override
  String get rehber8M3 =>
      'Hazır ana verilen kolonide süreç kabul ve yumurtlama kontrolüne göre okunur.';

  @override
  String get rehber8M4 =>
      'Günlük veya kapalı yavru görüldüğünde ana varlığı dolaylı kabul edilir ve ilgili ana kazanma süreci kapanabilir.';

  @override
  String get rehber9Baslik => '9. Bal Akımı 57/42 Gün Mantığı Nedir?';

  @override
  String get rehber9M1 =>
      '42 gün yumurtadan tarlacı arıya uzanan biyolojik süredir.';

  @override
  String get rehber9M2 =>
      '57 gün saha planlama eşiğidir: 42 günlük biyolojiye yaklaşık 15 gün güvenlik payı eklenir.';

  @override
  String get rehber9M3 =>
      'Karar motoru bölme önerisini bu 57 günlük saha penceresine göre ciddiye alır. Zaman uygun değilse güçlü koloni bile otomatik bölme adayı yapılmaz.';

  @override
  String get rehber9M4 =>
      'Bal akımına 24 gün veya daha az kaldığında alan, kat, kalıntı güvenliği ve oğul kontrolü öne çıkar.';

  @override
  String get rehber9M5 =>
      'Ana değişimi için en güçlü karar penceresi hasat sonrası / sonbahara giriş dönemidir.';

  @override
  String get rehber10Baslik => '10. Varroa Uyarıları Nasıl Çalışır?';

  @override
  String get rehber10M1 =>
      'Varroa uyarıları sezon ve bal akımı penceresiyle birlikte okunur.';

  @override
  String get rehber10M2 =>
      'Bal akımı öncesi ve sırasında kalıntı riski dikkate alınır.';

  @override
  String get rehber10M3 =>
      'Hasat sonrası / yaz sonu erken sonbahar dönemi kışı taşıyacak arıların sağlığı için kritik kabul edilir.';

  @override
  String get rehber10M4 =>
      'Oksalik, timol, amitraz, formik ve benzeri uygulamalarda ürün etiketi, ruhsat durumu ve yerel mevzuat esas alınmalıdır.';

  @override
  String get rehber11Baslik => '11. Veri Güveni Ne Demektir?';

  @override
  String get rehber11M1 =>
      'Tek muayeneli kolonide sistem karar verir ama veri güveni düşük der.';

  @override
  String get rehber11M2 =>
      '2–4 muayene izleme bandıdır. 5 ve üzeri muayene güvenilir değerlendirme başlangıcıdır.';

  @override
  String get rehber11M3 =>
      'Veri güveni, kararın neden güçlü veya sınırlı olduğunu açıklamak için gösterilir; kullanıcıyı kararsız bırakmak için değildir.';

  @override
  String get rehber12Baslik =>
      '12. Biyolojik Model ve Kabiliyet Analizi Nedir?';

  @override
  String get rehber12M1 =>
      'İTOGENA çıta sayısını yalnızca sayı olarak okumaz; standart koloni organizasyonu üzerinden tahmini kuluçkalık dizilimi, yavru bloğu, stok alanı ve hasat adayı dış çıtaları yorumlar.';

  @override
  String get rehber12M2 =>
      'Kovan tipi Langstroth veya Dadant olarak seçilebilir. Şurupluk varsa alt kuluçkalık 9 çıta, yoksa 10 çıta kabul edilir.';

  @override
  String get rehber12M3 =>
      'Temporal polyethism mantığıyla işçi arıların yaşa bağlı görev dağılımı tahmin edilir: bakıcı arı, petek örücü, iç işçi, tarlacı ve erkek arı yoğunluğu kabiliyet puanı olarak kullanılır.';

  @override
  String get rehber12M4 =>
      'Sistem \"şu çıtaları hasat et\" derken kesin hüküm vermez; yalnızca tahmini yerleşime göre yavrusuz ve sırlı olması halinde hasat için değerlendirilebilecek dış/ballık çıtaları işaret eder.';

  @override
  String get rehber13Baslik => '13. Kış Yönetimi Nasıl Çalışır?';

  @override
  String get rehber13M1 =>
      'Kış döneminde ana hedef üretim değil yaşatmadır. Sistem gereksiz kovan açmayı önleyecek şekilde dış gözlem, ağırlık hissi ve nem/su girişi kontrolünü öne alır.';

  @override
  String get rehber13M2 =>
      'Stok çok düşük görünüyorsa açlık riski minimum müdahale kuralından daha yüksek öncelik alır.';

  @override
  String get rehber13M3 =>
      'Fiziksel hacim yüksek ama işlevsel arı gücü düşükse sistem boş hacim ve ısı kaybı riskini belirtir.';

  @override
  String get rehber14Baslik => '14. Genetik Çoğaltma Değeri Nasıl Okunur?';

  @override
  String get rehber14M1 =>
      'Genetik çoğaltma değeri yalnızca bal veya çıta sayısı değildir. İşlevsel kapasite, yavru düzeni, gelişim yönü, aktivasyon, risk, stok/kış güvenliği ve oğul izi birlikte okunur.';

  @override
  String get rehber14M2 =>
      'Oğul kökeni veya oğul izi görülen koloniler üretimde değerli olabilir; ancak temiz genetik yayılım adayı olarak otomatik öne çıkarılmaz.';

  @override
  String get rehber14M3 =>
      'Bu skor kesin damızlık hükmü değildir; çoğaltmaya değer kolonileri izleme ve doğru zamanda kontrollü bölme kararını destekleyen stratejik sinyaldir.';

  @override
  String get rehber15Baslik => '15. Ekonomik Değer Neyi İfade Eder?';

  @override
  String get rehber15M1 =>
      'Ekonomik değer ekranı kesin gelir hesabı değil, yaklaşık arılık varlığı ve tahmini bal potansiyeli projeksiyonudur.';

  @override
  String get rehber15M2 =>
      'Aktif kovan sayısı, toplam arılı çıta, boş kovan, kabarmış petek ve tahmini hasat edilebilir bal potansiyeli birlikte okunur.';

  @override
  String get rehber15M3 =>
      'Kullanıcı bal kg satış fiyatını girer; sistem tahmini hasat potansiyelini bu fiyatla çarpar ve potansiyel değer bandı üretir.';

  @override
  String get rehber15M4 =>
      'Bal verimi flora, hava, hasat zamanı, bırakılacak stok ve arıcının yönetimine bağlı olarak değişir.';

  @override
  String get rehber16Baslik => '16. Besleme Karar Projeksiyonu Nasıl Çalışır?';

  @override
  String get rehber16M1 =>
      'Besleme önerileri kesin stok ölçümü değildir; çıta gücü, yavru alanı, sezon, aktif süreç, bal akımı penceresi ve kullanıcının muayene gözlemi birlikte değerlendirilir.';

  @override
  String get rehber16M2 =>
      'Sistem kesin reçete vermez; tahmini ml/L veya gram bandı üretir.';

  @override
  String get rehber16M3 =>
      '1:1 şurup daha çok gelişim desteği; 2:1 şurup stok tamamlama; polenli destek ise yalnızca polen baskısı sahada doğrulanırsa anlamlı kabul edilir.';

  @override
  String get rehber16M4 =>
      'Bal akımına 20 gün veya daha az kalmışsa ve koloni hasat hedefindeyse şeker bazlı besleme önerilmez.';

  @override
  String get rehber17Baslik => '17. İTOGENA Karar Sözlüğü';

  @override
  String get rehber17Kutu =>
      'Bu bölüm, ekranda görülen kavramların ne anlama geldiğini açıklar.';

  @override
  String get rehber17M1 =>
      'Koloni Gidişatı: Koloninin yalnız bugünkü gücünü değil, hangi yöne ilerlediğini anlatır.';

  @override
  String get rehber17M2 =>
      'Koloni Gücü: Son muayenedeki canlı arı ve çıta gücünü anlatır.';

  @override
  String get rehber17M3 =>
      'Koloni Sağlığı: Yavru düzeni, ana süreci, yavrusuzluk, varroa dönemi, davranış ve risk sinyallerinin birlikte okunmasıdır.';

  @override
  String get rehber17M4 =>
      'İşlevsel Çıta: Kovandaki fiziksel çıta sayısı değil, arının gerçekten kullandığı biyolojik kapasitedir.';

  @override
  String get rehber17M5 =>
      'Hacim Aktivasyonu: Verilen çıta veya katın koloni tarafından ne kadar kullanılır hale geldiğini anlatır.';

  @override
  String get rehber17M6 =>
      'Normalize Momentum: Kısa dönem çıta artışı veya düşüşünü ham şekilde okumaz. Hasat sonrası düşüş, bölme, kat geçişi ve riskli hızlı genişleme ayrılır.';

  @override
  String get rehber17M7 =>
      'Genetik Filtre: Koloninin üretimde değerli olabileceği halde ana üretme havuzuna alınmamasıdır.';

  @override
  String get rehber17M8 =>
      'Yönetim Kararı: Besleme, kat, alan, hasat sonrası bakım, varroa ve kış hazırlığı gibi arıcının sahada yapacağı işleri anlatır.';

  @override
  String get rehber17M9 =>
      'Süreç: Ana kazanma, bölme sonrası toparlanma, oğul sonrası veya yavru yok tanısı gibi zamana bağlı biyolojik/yönetim penceresidir.';

  @override
  String get rehber17M10 =>
      'Kilit / Bekle: Müdahale edilmemesi gereken hassas pencereyi anlatır.';

  @override
  String get rehber17M11 =>
      'Veri Güveni: Kararın kaç muayeneye dayandığını anlatır.';

  @override
  String get rehber18Baslik =>
      '18. Uygulama Hangi Konularda Kesin Hüküm Vermez?';

  @override
  String get rehber18U1 =>
      'İTOGENA veterinerlik, ruhsatlı ilaç kullanımı veya resmi mevzuat yerine geçmez.';

  @override
  String get rehber18U2 =>
      'Kimyasal mücadelede ürün etiketi, ruhsatlı kullanım talimatı, koruyucu ekipman ve yerel mevzuat esas alınmalıdır.';

  @override
  String get rehber18U3 =>
      'Hava, flora, yöresel nektar akımı, arıcı deneyimi ve koloni davranışı sahada ayrıca gözlenmelidir.';

  @override
  String get rehber18U4 =>
      'Sistem doğru kararı destekler; son sorumluluk sahadaki arıcıdadır.';

  @override
  String get rehber19Baslik => '19. Sesli Not';

  @override
  String get rehber19M1 =>
      'Not alanında mikrofon ikonuna basarak konuşarak not girebilirsiniz.';

  @override
  String get rehber19M2 =>
      'Konuşma otomatik olarak metne çevrilir ve not alanına eklenir.';

  @override
  String get rehber19U1 =>
      'Rüzgar, arı sesi, cihaz mikrofonu ve bazı cihazlarda internet bağlantısı algılamayı etkileyebilir.';

  @override
  String get rehber20Baslik => '20. Gizlilik Politikası';

  @override
  String get rehber20M1 =>
      'İTOGENA\'nın kişisel veri işleme, saklama ve kullanım politikasını aşağıdaki bağlantıdan okuyabilirsiniz.';

  @override
  String get rehber20Link => 'itogaciftligi.com/itogena-gizlilik-politikasi';

  @override
  String get kolonGridYavruYok => 'Yavru yok';

  @override
  String get kolonGridMemeKontrol => 'Meme kontrolü';

  @override
  String get kolonGridYalanciAna => 'Yalancı ana riski';

  @override
  String get kolonGridBeklemeSureci => 'Bekleme süreci';

  @override
  String get kolonGridSurecIzleniyor => 'Süreç izleniyor';

  @override
  String get kolonGridUcuncuKat => '3. kat ver';

  @override
  String get kolonGridAlanAc => 'Alan aç';

  @override
  String get kolonGridKatVer => 'Kat ver';

  @override
  String get kolonDetaySurecYok => 'Aktif süreç yok';

  @override
  String get kolonDetayKritikUyariYok => 'Kritik uyarı görünmüyor';

  @override
  String get kolonDetayNormalTakip => 'Normal takip';

  @override
  String get kolonDetaySurecTakibiGerekli => 'Süreç takibi gerekli.';

  @override
  String kolonDetayOncelik(int oncelik) {
    return 'Öncelik $oncelik/100';
  }

  @override
  String get kolonDetayDetaylariAc => 'Detayları aç';

  @override
  String get kolonDetayGereksizAcma => 'Koloniyi gereksiz açma';

  @override
  String get kolonDetayKoloniAcma => 'Koloniyi açma';

  @override
  String get kolonDetayMudahaleEtme => 'Müdahale etme';

  @override
  String get kolonDetayMemeSayisiKontrol => 'Meme sayısını kontrol et';

  @override
  String get kolonDetayBirlestir => 'Birleştirmeyi değerlendir';

  @override
  String get kolonDetayAlanKontrol => 'Alanı kontrol et';

  @override
  String get kolonDetayAnaKarar => 'Ana kararını değerlendir';

  @override
  String get kolonDetayTekrarKontrol => 'Tekrar kontrol et';

  @override
  String get kolonDetayBolmeNetlestir => 'Bölme kararını netleştir';

  @override
  String get kolonDetayKontrolEt => 'Kontrol et';

  @override
  String get kolonDetayYakinTakip => 'Yakından takip et';

  @override
  String get kolonDetayAktifSurecMetni => 'Aktif süreç';

  @override
  String get kolonDetayOkunamadi => 'Okunamadı';

  @override
  String get kolonDetayAktivasyonHata => 'Aktivasyon hesabı hatalı';

  @override
  String get kolonDetayBiyolojiYukleniyor => 'Hazırlanıyor';

  @override
  String get kolonDetayAktivasyonYukleniyor => 'Aktivasyon yükleniyor';

  @override
  String get kolonDetayArkaPlanda => 'Arka planda';

  @override
  String kolonDetayHacimYuzde(int yuzde) {
    return 'Hacim %$yuzde';
  }

  @override
  String kolonDetayHacimDetay(int fiziksel, String islevsel) {
    return '$fiziksel → $islevsel çıta';
  }

  @override
  String get kolonDetayIslevselOkunuyor => 'İşlevsel hacim okunuyor';

  @override
  String get kolonDetayAktivasyonAlanDolu => 'alan dolu';

  @override
  String get kolonDetayAktivasyonTamamlaniyor => 'tamamlanıyor';

  @override
  String get kolonDetayAktivasyonIyi => 'iyi';

  @override
  String get kolonDetayAktivasyonOrta => 'orta';

  @override
  String get kolonDetayAktivasyonDusuk => 'düşük';

  @override
  String get kolonDetayAktivasyonCokDusuk => 'çok düşük';

  @override
  String get kolonDetayYonetimDip => 'Yönetim';

  @override
  String get kolonDetayKararHatasi => 'Karar hatası';

  @override
  String get kolonDetayYonetimOkunamadi => 'Yönetim kararları okunamadı';

  @override
  String get kolonDetayYonetimYok => 'Yönetim yok';

  @override
  String get kolonDetayMudahaleYok => 'Öne çıkan saha müdahalesi görünmüyor';

  @override
  String get kolonDetayTakipDip => 'Takip';

  @override
  String get kolonDetayGenetikBekleniyor => 'Genetik bekleniyor';

  @override
  String get kolonDetaySecilimArkaPlanda =>
      'Seçilim bilgisi arka planda hazırlanıyor.';

  @override
  String get kolonDetaySecilimAyri => 'Seçilim ayrı okunacak';

  @override
  String get kolonDetaySecilimYukleniyor => 'Seçilim yükleniyor';

  @override
  String get kolonDetayDonorDisi => 'Donör dışı';

  @override
  String get kolonDetayOgulVeto => 'Oğul izi / veto';

  @override
  String get kolonDetayUretimDegerlendir => 'Üretimde değerlendir';

  @override
  String get kolonDetayVetoVar => 'Veto bilgisi var';

  @override
  String get kolonDetayDonorAdayi => 'Donör adayı';

  @override
  String get kolonDetaySoyTakibi => 'Soy takibi uygun';

  @override
  String get kolonDetayUretimKolonisi => 'Üretim kolonisi';

  @override
  String get kolonDetaySahaRolUretim => 'Saha rolü üretim';

  @override
  String get kolonDetayDestekKolonisi => 'Destek kolonisi';

  @override
  String get kolonDetayDestekRolu => 'Destek rolü';

  @override
  String get kolonDetayVetoBilgisi => 'Veto bilgisi';

  @override
  String get kolonDetayDonorBilgisi => 'Donör bilgisi';

  @override
  String get kolonDetayUretimRolu => 'Üretim rolü';

  @override
  String get kolonDetaySecilimDip => 'Seçilim';

  @override
  String get kolonDetayYonetimKararlari => 'Yönetim kararları';

  @override
  String get kolonDetayYonetimKarari => 'Yönetim kararı';

  @override
  String get kolonDetayGenetikDegerlendirme => 'Genetik değerlendirme';

  @override
  String get muayeneSecYavruYok => 'Yok';

  @override
  String get muayeneSecYavruBlok => 'Blok';

  @override
  String get muayeneSecYavruNormal => 'Normal';

  @override
  String get muayeneSecYavruDaginik => 'Dağınık';

  @override
  String get muayeneSecYavruKambur => 'Kambur';

  @override
  String get muayeneSecMizacSakin => 'Sakin';

  @override
  String get muayeneSecMizacSinirli => 'Sinirli';

  @override
  String get muayeneSecMizacSaldirgan => 'Saldırgan';

  @override
  String get muayeneSecBeslemeYok => 'Yok';

  @override
  String get muayeneSecBesleme11 => '1:1 Şurup';

  @override
  String get muayeneSecBesleme21 => '2:1 Şurup';

  @override
  String get muayeneSecBeslemeKek => 'Kek';

  @override
  String get muayeneSecBeslemeFondan => 'Fondan';

  @override
  String get muayeneSecVarroaYok => 'Yok';

  @override
  String get muayeneSecVarroaDrone => 'Drone Kesimi';

  @override
  String get muayeneSecVarroaBolme => 'Bölme';

  @override
  String get muayeneSecVarroaTimol => 'Timol';

  @override
  String get muayeneSecVarroaAmitraz => 'Amitraz';

  @override
  String get muayeneSecVarroaFormik => 'Formik';

  @override
  String get muayeneSecVarroaOksalik => 'Oksalik';

  @override
  String get srvKoloniAktifDegil => 'Bu koloni aktif değil';

  @override
  String get srvPasifKayit => 'Pasif kayıt';

  @override
  String get srvDonorHavuzunda => 'Donör havuzunda';

  @override
  String get srvBolmeUygun => 'Bu koloni bölme için uygun görünüyor';

  @override
  String get srvBolmeSinirinda => 'Bölme için güç sınırında';

  @override
  String get srvBolmeOnerilmez => 'Bölme önerilmez';

  @override
  String get srvBolmeZayif => 'Güç var; standart bölme zamanı zayıf';

  @override
  String get srvYakindanBak => 'Bu koloniye yakından bakmak gerekir';

  @override
  String get srvIzleyerek => 'İzleyerek karar ver';

  @override
  String get srvDestekUretim => 'Destek / üretim rolü';

  @override
  String get srvVeriGuveniDusuk => 'Veri güveni düşük';

  @override
  String get srvKararVarVeriDusuk => 'Karar var; veri güveni düşük';

  @override
  String get srvAnaKazanma => 'Ana Kazanma';

  @override
  String get srvBolmeSonrasi => 'Bölme Sonrası';

  @override
  String get srvKisYonetimi => 'Kış Yönetimi';

  @override
  String get srvBakimSureci => 'Bakım Süreci';

  @override
  String get srvGelisimDonemi => 'Gelişim Dönemi';

  @override
  String get srvUretimDonemi => 'Üretim Dönemi';

  @override
  String get srvHasatHazirlik => 'Hasat Hazırlığı';

  @override
  String get srvHasatSonrasiBakim => 'Hasat Sonrası Bakım';

  @override
  String get srvOgulSonrasi => 'Oğul Sonrası';

  @override
  String get srvVarroaYonetimi => 'Varroa Yönetimi';

  @override
  String get srvSahadaOncelik => 'Sahada Öncelik';

  @override
  String get srvBiyolojikNot => 'Biyolojik Not';

  @override
  String get trendVeriYok => 'Veri Yok';

  @override
  String get trendStabil => 'Stabil';

  @override
  String get trendYukselis => 'Yükseliş';

  @override
  String get trendDusus => 'Düşüş';

  @override
  String get trendSonmus => 'Sönmüş';

  @override
  String get trendKontrolluBolme => 'Kontrollü Bölme';

  @override
  String get trendBolmeSonrasiIzleme => 'Bölme Sonrası İzleme';

  @override
  String get trendGucluBiyolojikYon => 'Güçlü Biyolojik Yön';

  @override
  String get trendHasatSonrasiStabil => 'Hasat Sonrası Stabil';

  @override
  String get trendYavasGelisim => 'Yavaş Gelişim';

  @override
  String get trendHenuzMuayeneYok => 'Henüz muayene verisi bulunmuyor.';

  @override
  String get trendMomentumKovanSondu =>
      'Kovan sönmüş işaretlendi; momentum gerçek biyolojik kayıp olarak okunur.';

  @override
  String get trendMomentumBolme =>
      'Bölme kaydı nedeniyle çıta düşüşü biyolojik zayıflama sayılmadı.';

  @override
  String get trendMomentumHasat =>
      'Bal/hasat kaydı nedeniyle çıta düşüşü biyolojik momentum cezası sayılmadı.';

  @override
  String get trendMomentumFizikselDegismedi =>
      'Fiziksel hacim değişmedi; momentum nötr okundu.';

  @override
  String get trendMomentumHizliArtis =>
      'Hızlı hacim artışı aktivasyon tamamlanmadan gerçek büyüme sayılmadı.';

  @override
  String get trendMomentumKatGecisi =>
      'Kat/ballık geçişi fiziksel hacim artışı olarak görüldü; biyolojik momentum temkinli normalleştirildi.';

  @override
  String get trendMomentumDusukAktivasyon =>
      'Yeni hacmin aktivasyonu düşük olduğu için büyüme sinyali frenlendi.';

  @override
  String get trendMomentumBalAkimi =>
      'Bal akımı içinde sağlıklı üst hacim genişlemesi biyolojik üretim yönü olarak okundu.';

  @override
  String get trendMomentumNormalize =>
      'Fiziksel artış işlevsel kapasiteye göre normalize edildi.';

  @override
  String get surecOgulRiski => 'Oğul riski';

  @override
  String get surecOgulRiskiTakip => 'Oğul riski takibi';

  @override
  String get surecTekrarlayanOgul => 'Tekrarlayan oğul / nüfus kaybı riski';

  @override
  String get surecOgulSonrasiArtciYuksek => 'Oğul sonrası artçı riski yüksek';

  @override
  String get surecArtciOgulIzleniyor => 'Artçı oğul riski izleniyor';

  @override
  String get surecOgulSonrasiAnaCiftlesme =>
      'Oğul sonrası ana / çiftleşme süreci';

  @override
  String get surecOgulSonrasiYumurtlamaKontrol =>
      'Oğul sonrası yumurtlama kontrolü';

  @override
  String get surecBolmeSonrasiToparlanma => 'Bölme sonrası toparlanma';

  @override
  String get surecHasatSonrasiBakimGerekli => 'Hasat sonrası bakım gerekli';

  @override
  String get surecGelisimYavas => 'Gelişim yavaş görünüyor';

  @override
  String get surecMesajOgulRiski1 =>
      'Ana memesi görüldü. Bu sağlık sorunu değil, oğul davranışı ve koloni sıkışıklığı işaretidir. Koloniyi sakin biçimde kontrol et; gerekiyorsa bölme yap veya 1–2 kaliteli meme bırakıp fazlasını azalt.';

  @override
  String get surecMesajOgulRiski2 =>
      'İlk hafta artçı oğul riski yüksektir. Meme sayısını kontrol et; birden fazla güçlü meme bırakmak koloniyi tekrar bölebilir. Gerekiyorsa bölme veya fazla memeleri azaltma kararı ver.';

  @override
  String get surecMesajOgulRiskiTakip =>
      'Oğul belirtisi takip döneminde. Yeni meme, sıkışıklık veya huzursuzluk yoksa süreç kendiliğinden sönümlenir; gereksiz tekrar uyarı üretmez.';

  @override
  String get surecMesajTekrarlayanOgul =>
      'Oğul kaydı tekrar ediyor. Bu artık normal artçı takibi değil; koloni hızla nüfus kaybedebilir. Meme sayısı, kalan arı gücü, stok ve ana belirtisi birlikte okunmalı. Çok zayıfladıysa yoğun emek yerine birleştirme veya sınırlı destek daha doğru olabilir.';

  @override
  String get surecMesajArtciYuksek =>
      'Oğul sonrası ilk hafta artçı oğul riski yüksektir. Amaç koloniyi tekrar böldürmemektir. Kontrol gerekiyorsa kısa ve sakin yapılmalı; fazla meme bırakmak tekrar nüfus kaybı doğurabilir. Üretim/kat/hasat kararı geri plandadır.';

  @override
  String get surecMesajArtciIzleniyor =>
      'Artçı oğul riski devam eder ama ilk haftaya göre azalır. Yeni meme, huzursuzluk veya tekrar çıkış belirtisi yoksa ana sürecini bozmadan beklemek daha doğrudur. Günlük veya kapalı yavru görülürse süreç kapanır.';

  @override
  String get surecMesajAnaCiftlesme =>
      'Artçı riski büyük ölçüde kapanır. Bu dönem yeni ana çıkışı, olgunlaşma ve çiftleşme penceresidir. Yavru hâlâ görülmeyebilir; bu tek başına çöküş sayılmaz. Dış uçuş, polen gelişi ve sakinlik izlenir. Günlük veya kapalı yavru görülürse muayenede işaretle, süreç kapanır.';

  @override
  String get surecMesajYumurtlamaKontrol =>
      'Oğul sonrası 31–45. gün arası artık yumurtlama netleşmelidir. Günlük veya kapalı yavru görülürse süreç kapanır. Hâlâ yavru yoksa bu süreç normal bekleme olmaktan çıkar; ana başarısızlığı, çiftleşme kaybı veya yalancı ana riski yavru-yok tanısı ile öne alınır.';

  @override
  String get surecMesajBolmeErken =>
      'Koloniyi sıkışık tut ve besleme yap. Yeni düzen kurulana kadar destek gerekir.';

  @override
  String get surecMesajBolmeGecikti =>
      'Ana durumunu kontrol et. Toparlanma gecikmiş olabilir.';

  @override
  String get kabiliyetBiyolojikBaslik => 'Biyolojik Kabiliyet';

  @override
  String get kabiliyetBiyolojikMesaj =>
      'Petek örme kapasitesi güçlü görünüyor. Ham petek verilecekse yavru bloğu kesilmeden dıştan genişletme daha güvenlidir.';

  @override
  String get kabiliyetGenisletmeRiskiBaslik => 'Genişletme Riski';

  @override
  String get kabiliyetGenisletmeRiskiMesaj =>
      'Petek örme kapasitesi sınırlı görünüyor. Ham petek yerine kabarmış petek veya sıkı düzen daha güvenlidir.';

  @override
  String get kabiliyetBalAkimiBaslik => 'Bal Akımı Kapasitesi';

  @override
  String get kabiliyetBalAkimiMesaj =>
      'Tarlacı ve bal işleme kapasitesi güçlü görünüyor. Bal akımı döneminde alan, kat ve sırlanma takibi öne alınmalı.';

  @override
  String get kabiliyetBakiciDengeBaslik => 'Bakıcı Dengesi';

  @override
  String get kabiliyetBakiciDengeMesaj =>
      'Yavru bakım kapasitesi iyi fakat petek örme sınırlı. Yavru alanını bozmayacak kabarmış petek, ham petekten daha güvenli olur.';

  @override
  String get kabiliyetKisGuvenligiBaslik => 'Kış Güvenliği';

  @override
  String get kabiliyetKisGuvenligiMesaj =>
      'Kış dayanımı sınırlı görünüyor. Öncelik hasat veya genişletme değil stok güvenliği ve sıkı düzendir.';

  @override
  String get kabiliyetBiyolojikSahaNotBaslik => 'Biyolojik Saha Notu';

  @override
  String get kararAsBiyolojikYon => 'Biyolojik yön';

  @override
  String get perfKriterUreme => 'Üreme';

  @override
  String get perfKriterUretim => 'Üretim';

  @override
  String get perfKriterDayaniklilik => 'Dayanıklılık';

  @override
  String get perfKriterDavranis => 'Davranış';

  @override
  String get perfKriterHatGucu => 'Hat Gücü';

  @override
  String get perfKriterVeriGuveni => 'Veri Güveni';

  @override
  String get perfKriterBiyolojikDurum => 'Biyolojik Durum';

  @override
  String get perfKriterKoloniGidisati => 'Koloni Gidişatı';

  @override
  String get perfKriterHacimAktivasyonu => 'Hacim Aktivasyonu';

  @override
  String get perfKriterPetekOrme => 'Petek Örme Kapasitesi';

  @override
  String get perfKriterYavruBakim => 'Yavru Bakım Kapasitesi';

  @override
  String get perfKriterBalAkimi => 'Bal Akımı Kapasitesi';

  @override
  String get perfKriterKisGuvenligi => 'Kış Güvenliği';

  @override
  String get yorumVeriYok =>
      'Veri yok; karar yalnızca kimlik ve kaynak bilgisine göre sınırlıdır.';

  @override
  String get yorumVeriCokSinirli =>
      'Veri çok sınırlı; sistem karar verir ama güven düzeyi düşüktür.';

  @override
  String get yorumVeriIzlenmeli =>
      'Veri izlenmeli; karar var ama sonraki muayenelerle güçlenmelidir.';

  @override
  String get yorumVeriYeterli =>
      'Veri güveni yeterli; değerlendirme güvenilir banda girmiştir.';

  @override
  String get yorumYetersizVeri =>
      'Henüz değerlendirilebilir türeyen koloni verisi yok.';

  @override
  String get yorumKararYetersiz => 'Karar üretmek için yeterli veri yok.';

  @override
  String get soyDurumVeriYok => 'Veri Yok';

  @override
  String get soyDurumVeriYetersiz => 'Veri Yetersiz';

  @override
  String get soyDurumGucluSoy => 'Güçlü Soy';

  @override
  String get soyDurumOlumluSoy => 'Olumlu Soy';

  @override
  String get soyDurumZayifSoy => 'Zayıf Soy';

  @override
  String get soyDurumRiskliSoy => 'Riskli Soy';

  @override
  String get soyDurumNotr => 'Nötr';

  @override
  String get soyYorumTureyenYok =>
      'Bu koloniden türeyen kayıtlı koloni görünmüyor.';

  @override
  String get soyYorumVeriYetersiz =>
      'Türeyen koloniler var; ancak henüz en az 45 gün geçmiş yeterli veri oluşmamış.';

  @override
  String get hatKararVeriYetersiz => 'Veri Yetersiz';

  @override
  String get hatKararOperasyonel => 'Operasyonel Hat';

  @override
  String get hatKararRiskli => 'Riskli Hat';

  @override
  String get hatKararDonor => 'Donör Hat';

  @override
  String get hatKararGucluUretim => 'Güçlü Üretim Hattı';

  @override
  String get hatKararTakip => 'Takip Edilmeli';

  @override
  String get hatGerekceVeriYetersiz =>
      'Bu hat için güvenilir karar üretecek kadar yeterli koloni geçmişi oluşmamış.';

  @override
  String get hatGerekceOperasyonel =>
      'Bu hatta oğul kökeni veya gerçekleşmiş oğul olayı bulunduğu için donör hat olarak kabul edilmez.';

  @override
  String get hatGerekceRiskli =>
      'Bu hatta tekrar eden sönme veya yüksek sönme oranı görülüyor.';

  @override
  String get hatGereceDonor =>
      'Hat; gelişim, üretim ve dayanıklılık açısından güçlü ve dengeli görünüyor.';

  @override
  String get hatGerekceGucluUretim =>
      'Hat donör kadar temiz ve güçlü görünmese de üretim omurgası olarak değerlidir.';

  @override
  String get hatGerekceTakip =>
      'Hat tamamen zayıf görünmüyor; ancak çoğaltma kararı için daha net tekrar ve performans verisi gerekiyor.';

  @override
  String get hatNotVeriIhtiyac =>
      'En az iki koloni ve daha fazla saha tekrarına ihtiyaç var.';

  @override
  String get hatNotDonorOncelikli =>
      'Bu hat donör çoğaltma için öncelikli adaydır.';

  @override
  String get hatNotTekrarlayanSonme =>
      'Tekrarlayan sönmeler seçilim açısından güçlü negatif sinyaldir.';

  @override
  String get hatNotTekSonme =>
      'Tek sönme doğrudan eleme değildir, ama uyarı sinyalidir.';

  @override
  String get hatNotGelisimGuclu => 'Hat içinde gelişim gücü olumlu görünüyor.';

  @override
  String get hatNotBalPerformans =>
      'Ortalama bal performansı olumlu ayrışıyor.';

  @override
  String get hatNotIzlemeDEvam => 'Bu hat için izleme devam etmeli.';

  @override
  String get hatNotKisGuclu => 'Kıştan çıkış gücü olumlu görünüyor.';

  @override
  String get hatAksiyonVeriTopla => 'Bu hat için veri toplamaya devam et';

  @override
  String get hatAksiyonErkenKarar => 'Erken damızlık kararı verme';

  @override
  String get hatAksiyonAnaUretme => 'Bu hattan ana üretme';

  @override
  String get hatAksiyonSinirliUretim => 'Yeni bölme üretimini sınırlı tut';

  @override
  String get hatAksiyonUretimDestek =>
      'Üretim veya destek hattı olarak değerlendir';

  @override
  String get hatAksiyonBolmeYapma => 'Bu hattan bölme yapma';

  @override
  String get hatAksiyonDonorHavuzu => 'Donör havuzuna alma';

  @override
  String get hatAksiyonHatEleme =>
      'Hat elemesini veya ana yenilemeyi değerlendir';

  @override
  String get hatAksiyonAnaUret => 'Bu hattan ana üret';

  @override
  String get hatAksiyonTemizHat => 'Temiz çoğaltma hattı olarak koru';

  @override
  String get hatAksiyonDonorOncelik => 'Donör havuzunda önceliklendir';

  @override
  String get hatAksiyonUretimdeKor => 'Bu hattı üretimde koru';

  @override
  String get hatAksiyonSinirliKontrolluBolme =>
      'Sınırlı ve kontrollü bölme düşün';

  @override
  String get hatAksiyonUretimOmurgasi =>
      'Donör değil, üretim omurgası olarak değerlendir';

  @override
  String get hatAksiyonIzlemeDevam => 'İzlemeye devam et';

  @override
  String get hatAksiyonKarariErtele => 'Kararı ertele, veri biriktir';

  @override
  String get hatAksiyonMuayeneSiklik =>
      'Kritik kolonilerde muayene sıklığını artır';

  @override
  String get perfDurumGenetikFiltre => 'Genetik Filtre';

  @override
  String get perfDurumSartliDonor => 'Şartlı Donör';

  @override
  String get perfDurumGucluUretim => 'Güçlü Üretim';

  @override
  String get perfDurumIzlenmeli => 'İzlenmeli';

  @override
  String get perfDurumMudahale => 'Müdahale';

  @override
  String get raporDurumGenetikVeto => 'Genetik veto';

  @override
  String get raporDurumDonor1 => 'Donör 1';

  @override
  String get raporDurumDonor2 => 'Donör 2';

  @override
  String get raporDurumDonor3 => 'Donör 3';

  @override
  String get raporDurumCokZayif => 'Çok zayıf';

  @override
  String get raporDurumGelismekte => 'Gelişmekte';

  @override
  String get raporDurumGuclu => 'Güçlü';

  @override
  String get raporDurumCokGuclu => 'Çok güçlü';

  @override
  String get trendMomPatlaYici => 'Patlayıcı büyüme';

  @override
  String get trendMomGucluBuyume => 'Güçlü büyüme';

  @override
  String get trendMomSaglikliGelisim => 'Sağlıklı gelişim';

  @override
  String get trendMomYavasGelisim => 'Yavaş gelişim';

  @override
  String get trendMomDuraklama => 'Duraklama';

  @override
  String get trendAciklamaStabil => 'Koloni genel olarak stabil görünüyor.';

  @override
  String get trendAciklamaSonmus =>
      'Son muayenede kovanın söndüğü işaretlenmiş.';

  @override
  String get trendAciklamaBolme =>
      'Bölme işaretli olduğu için çıta değişimi doğrudan zayıflama olarak okunmadı.';

  @override
  String get trendAciklamaGucluYon =>
      'Koloni zamana göre güçlü biyolojik gelişim yönü gösteriyor.';

  @override
  String get trendAciklamaYukselis =>
      'Koloni zamana göre sağlıklı biyolojik gelişim yönünde.';

  @override
  String get trendAciklamaHasatStabil =>
      'Bal sinyali mevcut; küçük düşüşler üretim / hasat bağlamında okunuyor.';

  @override
  String get trendAciklamaDusus =>
      'Koloni zamana göre güç kaybı eğilimi gösteriyor.';

  @override
  String get trendAciklamaYavasGelisim =>
      'Koloni gelişiyor ancak momentum düşük.';

  @override
  String get trendNormBiyolojikDusus =>
      'Hasat/bölme kaydı olmadan belirgin çıta düşüşü biyolojik zayıflama şüphesiyle okundu.';

  @override
  String get trendNormKucukDusus =>
      'Küçük çıta düşüşü tam çöküş sayılmadan temkinli okundu.';

  @override
  String get biyoSinifZayif => 'Zayıf';

  @override
  String get biyoSinifGelisim => 'Gelişim';

  @override
  String get biyoSinifHasat => 'Hasat';

  @override
  String get biyoSinifAciklamaZayif =>
      'Öncelik yaşatma, sıkıştırma ve ölçülü destek.';

  @override
  String get biyoSinifAciklamaGelisim =>
      'Öncelik düzenli gelişim ve ana/yavru dengesinin korunması.';

  @override
  String get biyoSinifAciklamaUretim =>
      'Koloni üretim gücüne girmiştir; alan, oğul riski ve bal akımı birlikte izlenir.';

  @override
  String get biyoSinifAciklamaHasat =>
      'Koloni bal akımı ve hasat/alan yönetimi açısından güçlü banttadır.';

  @override
  String get biyoYerlesimYavruStok => 'Yavru/stok';

  @override
  String get biyoYerlesimBalliPolenli => 'Ballı/polenli';

  @override
  String get biyoYerlesimBalStogu => 'Bal stoğu';

  @override
  String get biyoYerlesimYavruPolenli => 'Yavru/polenli';

  @override
  String get biyoYerlesimYavru => 'Yavru';

  @override
  String get biyoYerlesimYavruluPolenli => 'Yavrulu/polenli';

  @override
  String get biyoYerlesimBalliPolenliGecis => 'Ballı/polenli geçiş alanı';

  @override
  String get biyoYerlesimBallikBalAlani => 'Ballık / bal alanı';

  @override
  String get biyoYerlesimYavruStokGecis => 'Yavru/stok geçiş alanı';

  @override
  String get biyoYavrusuzSahaNormal =>
      'Yavru verisi mevcut; biyolojik geri dönüş kapasitesi yavru üretimiyle destekleniyor.';

  @override
  String get biyoYavrusuzOneriNormal => 'Normal biyolojik model akışıyla izle.';

  @override
  String get biyoYavrusuzSahaBolme =>
      'Bu aşamada yavru görülmemesi normal olabilir. Koloni ana kazanma veya çiftleşme döneminde olabilir; gereksiz açma riski artırır.';

  @override
  String get biyoYavrusuzOneriBolme =>
      'Kovanı gereksiz açma; yumurtlama kontrol penceresini bekle.';

  @override
  String get biyoYavrusuzSahaBalBaskisi =>
      'Yavru yokluğu tek başına anasızlık anlamına gelmez. Bal akımı ve ballı çıta baskısı yumurtlama alanını daraltmış olabilir.';

  @override
  String get biyoYavrusuzOneriBalBaskisi =>
      'Önce alan ve bal baskısını değerlendir; erken ana müdahalesi yapma.';

  @override
  String get biyoYavrusuzSahaDusukKap =>
      'Koloni uzun süredir yeni işçi üretmiyor. Bu güç seviyesinde mevcut nüfus yaşlanıyor olabilir; yoğun emek ve kaynak harcamak verimli olmayabilir.';

  @override
  String get biyoYavrusuzOneriDusukKap =>
      'Güçlü koloniyle birleştirme veya sınırlı müdahale öncelikli değerlendirilmelidir.';

  @override
  String get biyoYavrusuzSahaGecikme =>
      'Yumurtlama beklenen döneme girilmiş. Yavru hâlâ yoksa geç çiftleşme, ana kaybı, bal baskısı veya zayıf koloni olasılıkları birlikte okunmalı.';

  @override
  String get biyoYavrusuzOneriGecikme =>
      '5–7 gün içinde tekrar kontrol et; koloni zayıflıyorsa beklemeyi uzatma.';

  @override
  String get biyoYavrusuzSahaIzlenmeli =>
      'Yavru yokluğu izlenmeli; mevcut gün aralığında tek başına kesin anasızlık kararı verilmemelidir.';

  @override
  String get biyoYavrusuzOneriIzlenmeli =>
      'Koloni davranışı, polen gelişi ve bir sonraki muayene ile birlikte değerlendir.';

  @override
  String get perfBiyolojiVeriYetersiz => 'Biyolojik veri yetersiz';

  @override
  String get perfBiyolojiZamanKritik => 'Zaman kritik';

  @override
  String get perfBiyolojiMudahaleGerekli => 'Müdahale gerekli';

  @override
  String get perfBiyolojiUygun => 'Uygun';

  @override
  String get perfBiyolojiDikkat => 'Dikkat';

  @override
  String get perfKabiliyetYeterli => 'Yeterli';

  @override
  String get perfKabiliyetSinirli => 'Sınırlı';

  @override
  String get perfKabiliyetVeriYok => 'Veri yok';

  @override
  String get perfDurum1DonorAdayi => '1. Donör Adayı';

  @override
  String get perfDurum2DonorAdayi => '2. Donör Adayı';

  @override
  String get perfDurum3DonorAdayi => '3. Donör Adayı';

  @override
  String get perfVeriGuveniGuvenilir => 'Güvenilir';

  @override
  String get perfVeriGuveniCokSinirli => 'Veri çok sınırlı';

  @override
  String get perfKisCikisVeriYetersiz => 'Kış çıkış verisi yetersiz.';

  @override
  String get aksiyonDurum => 'Durum';

  @override
  String get aksiyonNeYap => 'Ne yap';

  @override
  String get aksiyonNeden => 'Neden';

  @override
  String get aksiyonZamanBaglami => 'Zaman Bağlamı';

  @override
  String get perfYorumOrta => 'Orta';

  @override
  String get karsilastirmaGenetikSecilim => 'Genetik Seçilim';

  @override
  String get karsilastirmaKistanCikis => 'Kıştan Çıkış';

  @override
  String get karsilastirmaBiyolojiDurumu => 'Biyoloji Durumu';

  @override
  String get karsilastirmaMemeTakibi => 'Meme Takibi';

  @override
  String get karsilastirmaAnasizlikGun => 'Anasızlık (gün)';

  @override
  String get karsilastirmaHavuzaGiremez => 'Temiz donör havuzuna giremez';

  @override
  String get karsilastirmaMemeTakipYorum => 'Zamanlama ve meme gelişimi';

  @override
  String get fHesapSurupFormulBaslik => 'Şurup Formülü';

  @override
  String get fHesapSurupFormulAciklama =>
      'Hedef şerbet miktarını kg olarak girersen sistem kg su ve kg şeker verir. Sahada aynı ölçü kabını kullanıyorsan 1:1 veya 2:1 oranı aynı mantıkla korunur.';

  @override
  String get fHesapSurupOraniBolum => 'Şurup Oranı';

  @override
  String get fHesapSurupOraniAciklama =>
      '1:1 genelde teşvik şurubu, 2:1 genelde stok / kış hazırlığı için kullanılır. Bu ekran zorunlu uygulama emri değil, oran hesabı yardımcısıdır.';

  @override
  String get fHesapSurupHedefBolum => 'Hedef Şerbet';

  @override
  String get fHesapSurupHedefEtiket => 'Hedef şerbet miktarı';

  @override
  String get fHesapSurupHedefYardim =>
      'Örnek: 10 kg hedef şerbet için gerekli kg su ve kg şeker hesaplanır.';

  @override
  String get fHesapSurupSonucSuffix => 'Şurup Sonucu';

  @override
  String get fHesapSurupSekerSatir => 'Şeker';

  @override
  String get fHesapSurupSuSatir => 'Su';

  @override
  String get fHesapSurupKatsayiSatir => 'Saha Katsayısı';

  @override
  String get fHesapSurupNot =>
      'Kg hesabı hedef şerbet ağırlığı içindir. Hacimsel kapla çalışıyorsan aynı kapla oran kur; 1:1 için eşit kap, 2:1 için iki kap şeker bir kap su mantığı korunur.';

  @override
  String get fHesapOksalikBaslik => 'Oksalik Asit Yardımcı Hesabı';

  @override
  String get fHesapOksalikAciklama =>
      'Bu ekran yalnızca hesaplama yardımcısıdır. Uygulama kararı için ruhsatlı ürün etiketi, yerel mevzuat ve veteriner/teknik danışman talimatı esas alınır.';

  @override
  String get fHesapOksalikFormulBaslik => '10–15 Kovan İçin Standart Formül';

  @override
  String get fHesapOksalikTozAsitSatir => 'Toz oksalik asit';

  @override
  String get fHesapOksalikUygulamaSatir => 'Uygulama şekli';

  @override
  String get fHesapOksalikUygulamaDegeri => 'Damlatma';

  @override
  String get fHesapOksalikUygulamaNotu => 'Uygulama Notu';

  @override
  String get fHesapOksalikUygulamaNotMetni =>
      'Oksalik uygulaması genelde yavrusuz / yavru çok az dönemde daha anlamlıdır. Sıcaklık, doz, uygulama yöntemi ve tekrar sayısı için ürün etiketi esas alınmalıdır.';

  @override
  String get fHesapOksalikGuvenlikBaslik => 'Güvenlik Uyarısı';

  @override
  String get fHesapOksalikGuvenlikMetni =>
      'Koruyucu gözlük, eldiven ve maske kullan. Asit buharını soluma, cilt ve göz temasından kaçın. Ruhsatsız ürün, belirsiz doz veya etiketsiz karışım kullanma. Bu ekran tedavi talimatı değil, yardımcı hesaplama ekranıdır.';

  @override
  String get fHesapBiyolojiBaslik => 'Biyolojik Takvim';

  @override
  String get fHesapBiyolojiAciklama =>
      'Bu ekran ana kazanma biyoloji takvimini merkezi AriBiyolojiServisi üzerinden okur. Koloni detay, süreç uyarıları ve formüller aynı tarih mantığını kullanır.';

  @override
  String get fHesapBiyolojiAnaKazanmaBolum => 'Ana Kazanma Süreci';

  @override
  String get fHesapBiyolojiBaslangicTipi => 'Başlangıç tipi';

  @override
  String get fHesapBiyolojiAnasizBirakildi => 'Anasız Bırakıldı';

  @override
  String get fHesapBiyolojiBolmeYapildi => 'Bölme Yapıldı';

  @override
  String get fHesapBiyolojiKapaliMeme => 'Hazır Kapalı Ana Memesi';

  @override
  String get fHesapBiyolojiHazirAna => 'Hazır Çiftleşmiş Ana';

  @override
  String get fHesapBiyolojiBaslangicTarihi => 'Başlangıç tarihi';

  @override
  String get fHesapBiyolojiTakvimSuffix => 'Takvimi';

  @override
  String get fHesapBiyolojiSahaNotu => 'Saha Notu';

  @override
  String get fHesapBiyolojiSahaNotMetni =>
      'Gün sayımı başlangıç günü dahil edilerek yapılır. Günlük / kapalı yavru görülürse muayene ekranındaki ilgili kutucuk işaretlenir ve ana kazanma süreci kapanır.';

  @override
  String get fHesapBiyolojiIsciYavruBolum => 'Kapalı İşçi Yavrusu Çıkışı';

  @override
  String get fHesapBiyolojiIsciYavruTarihi =>
      'Kapalı işçi yavrusu görülen tarih';

  @override
  String get fHesapBiyolojiIsciYavruPencere =>
      'Kapalı İşçi Yavrusu Çıkış Penceresi';

  @override
  String get fHesapBiyolojiErkekYavruBolum => 'Kapalı Erkek Yavrusu Çıkışı';

  @override
  String get fHesapBiyolojiErkekYavruTarihi =>
      'Kapalı erkek yavrusu görülen tarih';

  @override
  String get fHesapBiyolojiErkekYavruPencere =>
      'Kapalı Erkek Yavrusu Çıkış Penceresi';

  @override
  String get fHesapBiyolojiBaslangicSatir => 'Başlangıç';

  @override
  String get fHesapBiyolojiTahminiCikis => 'Tahmini çıkış';

  @override
  String get fHesapBiyolojiKabulPencere => 'Kabul kontrol penceresi';

  @override
  String get fHesapBiyolojiMemePencere => 'Tahmini meme kapanma';

  @override
  String get fHesapBiyolojiAnaCikisi => 'Tahmini ana çıkışı';

  @override
  String get fHesapBiyolojiCiftlesmePencere => 'Çiftleşme uçuş penceresi';

  @override
  String get fHesapBiyolojiYumurtlamaPencere => 'Yumurtlama kontrol penceresi';

  @override
  String get fHesapBiyolojiDokunmaPencere => 'Kovana dokunma penceresi';

  @override
  String get fHesapBalAkimiBaslik => 'Bal Akımı Kararı';

  @override
  String get fHesapBalAkimiAciklama =>
      'Sistem, bal akımına zayıf girmemek için 57 günlük saha planlama eşiğini kullanır. 42 gün ise yumurtadan tarlacıya biyolojik süredir; bu ikisi aynı şey değildir.';

  @override
  String get fHesapBalAkimTarihi => 'Bal akım başlangıç tarihi';

  @override
  String get fHesapBalAkimCitaSayisi => 'Mevcut çıta sayısı';

  @override
  String get fHesapBalAkimCitaYardim => 'Örnek: 9';

  @override
  String get fHesapBalAkimTarihBekleniyor => 'Tarih Bekleniyor';

  @override
  String get fHesapBalAkimTarihBekleniyorMetni =>
      'Karar üretilebilmesi için önce bal akım başlangıç tarihini seç.';

  @override
  String get fHesapBalAkimKararBaslik => 'Karar';

  @override
  String get fHesapBalAkimSonTarih => 'Son güvenli bölme tarihi';

  @override
  String get fHesapBalAkimPlanlamaEsigi => 'Planlama eşiği';

  @override
  String get fHesapBalAkimPlanlamaEsigiDeger => '57 gün';

  @override
  String get fHesapBalAkimBiyolojikSure => 'Biyolojik süre';

  @override
  String get fHesapBalAkimBiyolojikSureDeger => '42 gün: yumurtadan tarlacıya';

  @override
  String get fHesapBalAkimMevcutGuc => 'Mevcut güç';

  @override
  String get fHesapBalAkimHedefAltSinir => 'Hedef alt sınır';

  @override
  String get fHesapBalAkimEnFazla => 'En fazla alınabilir';

  @override
  String get fHesapBalAkimKarar => 'Karar';

  @override
  String get fHesapBalAkimGucYetersiz =>
      'Bu güçte güvenli bölme penceresi açılmamış görünüyor.';

  @override
  String fHesapBalAkimMaxCitaUyari(String maxCita) {
    return '$maxCita çıtadan fazla alınırsa koloni bal dönemine zayıf girebilir.';
  }

  @override
  String get kolonilerCitaYok => '- çıta';

  @override
  String kolonilerIslevselCita(int islevsel) {
    return '$islevsel işl.';
  }

  @override
  String get kaynakAnaHat => 'Ana Hat';

  @override
  String get kaynakBolme => 'Bölme';

  @override
  String kaynakBolmeDen(String koloni) {
    return '$koloni koloniden bölme';
  }

  @override
  String get kaynakOgul => 'Oğul';

  @override
  String kaynakOgulDen(String koloni) {
    return '$koloni koloniden oğul';
  }

  @override
  String get kaynakDisKaynak => 'Dış kaynak';

  @override
  String get kararDonorDegil => 'Genetik seçilimde uygun değil.';

  @override
  String get kararYakinTakip => 'Yakın takip et.';

  @override
  String get yonetimKararUretilemediBaslik => 'Yönetim kararları üretilemedi';

  @override
  String get yonetimKararUretilemediOzet =>
      'Saha yönetimi karar hattı bu koloni için sonuç veremedi.';

  @override
  String get yonetimKararYokBaslik => 'Öne çıkan yönetim kararı yok';

  @override
  String get yonetimKararYokOzet =>
      'Süreç, biyolojik sınıf ve sezon birlikte okundu; şu an ayrı bir saha müdahalesi öne çıkmıyor.';

  @override
  String get yonetimKararYokDetay =>
      'Bu kart artık besleme motorunu ayrı bir gerçeklik olarak okumaz. Besleme, kat, alan, varroa, şurupluk, kış ve hasat sonrası kararları aynı yönetim listesinde değerlendirilir.';

  @override
  String biyolojikModelUretilemedi(String hata) {
    return 'Biyolojik model üretilemedi:\n$hata';
  }

  @override
  String get biyolojikModelVeriGerekli =>
      'Biyolojik model için önce muayene ve çıta verisi gerekir.';

  @override
  String get biyolojikDizilimBaslik => 'BİYOLOJİK DİZİLİM PROJEKSİYONU';

  @override
  String get biyolojikTahminiAriEtiket => 'Tahmini arı';

  @override
  String biyolojikMerkezYavruBloku(String blok) {
    return 'Merkez yavru bloğu: $blok. Bu blok korunmalı.';
  }

  @override
  String get biyolojikBalPotansiyeli => 'Bal potansiyeli';

  @override
  String get biyolojikBirakilacakStok => 'Bırakılacak stok';

  @override
  String get biyolojikHacimAktivasyonuEtiket => 'Hacim aktivasyonu';

  @override
  String get biyolojikTarlaciEtiket => 'Tarlacı';

  @override
  String get biyolojikBakiciEtiket => 'Bakıcı';

  @override
  String get biyolojikGencIsciEtiket => 'Genç işçi';

  @override
  String get biyolojikPetekOrme => 'Petek örme';

  @override
  String get biyolojikYavruBakim => 'Yavru bakımı';

  @override
  String get biyolojikNektarToplama => 'Nektar toplama';

  @override
  String get biyolojikBalIsleme => 'Bal işleme';

  @override
  String get hasatProjeksiyonBaslik => 'HASAT PROJEKSİYONU';

  @override
  String get hasatAdayYok =>
      'Hasat adayı çıta oluşmadı. Koloni gücü ve dış stok durumuna göre takip et.';

  @override
  String get hasatTahminiMiktarEtiket => 'Tahmini miktar';

  @override
  String get hasatTahminiDegerEtiket => 'Tahmini değer';

  @override
  String get hasatKuluckalikGuvenlik =>
      'Yalnızca yavrusuz ve sırlıysa değerlendir. Kuluçkalık güvenliği bozulmamalı.';

  @override
  String get hasatSuruplukKisit =>
      'Bal akımı yaklaştığı için besleme kısıtı başladı. Şurupluk kovandaysa görselde kalır; yalnızca muayenede kaldırıldı olarak işaretlenirse dizilimden çıkar.';

  @override
  String get katUcuncuBallik => '3. KAT / BALLIK';

  @override
  String get katUstBallik => 'ÜST KAT / BALLIK';

  @override
  String get katAltKuluckalik => 'ALT KAT / KULUÇKALIK';

  @override
  String get lejantBalStok => 'Bal/stok';

  @override
  String get lejantBalliPolenli => 'Ballı-polenli';

  @override
  String get lejantYavru => 'Yavru';

  @override
  String get lejantBosCerceve => 'Boş çerçeve';

  @override
  String get lejantGunlukDolum => 'Günlük dolum';

  @override
  String get lejantSurupluk => 'Şurupluk';

  @override
  String get hacimTipiKatGecisi =>
      'Kat geçişi; yeni hacim kademeli aktive ediliyor.';

  @override
  String get hacimTipiBallikUretim =>
      'Bal akımı içinde üretim genişlemesi kabul ediliyor.';

  @override
  String get hacimTipiRiskliGenisleme =>
      'Bal akımı dışında hızlı genişleme; temkinli okunmalı.';

  @override
  String get hacimTipiHasatDusus =>
      'Hasat kaynaklı düşüş; biyolojik zayıflama sayılmaz.';

  @override
  String get hacimTipiBiyolojikZayiflama =>
      'Hacim düşüşü biyolojik zayıflama açısından izlenmeli.';

  @override
  String get hacimTipiKuluckalikGenisleme =>
      'Kuluçkalık genişlemesi kontrollü okunuyor.';

  @override
  String get hacimTipiNormal => 'Hacim değişimi normal bantta.';

  @override
  String get hacimOkunamadi => 'Biyolojik durum okunamadı';

  @override
  String get hacimUretilemedi => 'Hacim aktivasyon hesabı üretilemedi.';

  @override
  String get hacimHazirlaniyor => 'Biyolojik durum hazırlanıyor';

  @override
  String get hacimBirlikte =>
      'Fiziksel çıta, işlevsel üretim çıtası ve toplam hacim aktivasyonu birlikte okunacak.';

  @override
  String get hacimArkaplan =>
      'Bu hesap ekranı bloke etmemek için ilk açılıştan sonra yüklenir.';

  @override
  String hacimToplamBaslik(int yuzde) {
    return 'Toplam hacim aktivasyonu: %$yuzde';
  }

  @override
  String get hacimBuyukBolumAktif =>
      'Sistem mevcut hacmin büyük bölümünü aktif üretim kapasitesi olarak okuyor.';

  @override
  String hacimFizikselIslevselOzet(
      int fiziksel, String islevsel, String yorum) {
    return '$fiziksel fiziksel çıta → yaklaşık $islevsel işlevsel üretim çıtası. $yorum';
  }

  @override
  String get hacimFizikselIslevselBirlikte =>
      'Fiziksel hacim ve işlevsel üretim kapasitesi birlikte okunuyor.';

  @override
  String get miniFiziksel => 'Fiziksel';

  @override
  String get miniIslevsel => 'İşlevsel';

  @override
  String get miniToplamHacim => 'Toplam hacim';

  @override
  String get miniEklenen => 'Eklenen';

  @override
  String get miniOnceki => 'Önceki';

  @override
  String get miniTemel => 'Temel';

  @override
  String get miniKabarmis => 'Kabarmış';

  @override
  String get miniPetek => 'Petek';

  @override
  String get miniKalan => 'Kalan';

  @override
  String get genetikDetayAyri => 'Genetik değerlendirme ayrı izleniyor';

  @override
  String get genetikSurecBilgisi =>
      'Aktif süreç bilgisi Süreç kartında gösterilir. Bu alan yalnızca donör, veto, üretim/destek rolü ve soy değerlendirmesi için kullanılır.';

  @override
  String get genetikHazirlaniyor =>
      'Genetik değerlendirme için süreçten bağımsız seçilim bilgisi hazırlanıyor.';

  @override
  String soyBirinciSatir(
      String kaynak, String anaYili, String sonCita, String maxCita) {
    return 'Kaynak: $kaynak • Ana: $anaYili • Son: $sonCita • Max: $maxCita';
  }

  @override
  String soyIkinciSatirSkor(
      String balCita, String muayeneSayisi, String tureyenSayisi, String skor) {
    return 'Bal: $balCita • Muayene: $muayeneSayisi • Türeyen: $tureyenSayisi • Skor: $skor';
  }

  @override
  String soyIkinciSatir(
      String balCita, String muayeneSayisi, String tureyenSayisi) {
    return 'Bal: $balCita • Muayene: $muayeneSayisi • Türeyen: $tureyenSayisi';
  }

  @override
  String get tetikOgulBelirtisi => 'Oğul Belirtisi';

  @override
  String get tetikBolmeYapildi => 'Bölme Yapıldı';

  @override
  String get tetikAnasizBirakildi => 'Anasız Bırakıldı';

  @override
  String get tetikOgulAtti => 'Oğul Attı';

  @override
  String get tetikKovanSondu => 'Kovan Söndü';

  @override
  String get tetikHasat => 'Hasat';

  @override
  String get tetikHazirAnaVerildi => 'Hazır Ana Verildi';

  @override
  String get tetikGunlukKapaliYavru => 'Günlük/Kapalı Yavru';

  @override
  String get tetikKapaliYavruluCita => 'Kapalı Yavrulu Çıta';

  @override
  String get uyariAriKusuBaslik => 'Arı kuşu baskısı görülebilir';

  @override
  String get uyariAriKusuMesaj =>
      'Uçuş hattını gözle. Yoğun geçiş varsa korkuluk veya görsel caydırıcı önlemler kullan.';

  @override
  String get uyariEsekArisiBaslik => 'Eşek arısı baskısı artabilir';

  @override
  String get uyariEsekArisiMesaj =>
      'Kovan girişlerini daralt, zayıf kolonileri koru. Yoğun baskıda tuzak kurulması değerlendirilebilir.';

  @override
  String get uyariYagmacilikBaslik => 'Yağmacılık riski artabilir';

  @override
  String get uyariYagmacilikMesaj =>
      'Kovan açma süresini kısa tut. Girişleri daralt, zayıf kolonileri koru.';

  @override
  String get uyariMumGuvesiBaslik => 'Mum güvesi riski artabilir';

  @override
  String get uyariMumGuvesiMesaj =>
      'Zayıf kolonide fazla petek bırakma. Boş petekleri korumalı sakla.';

  @override
  String get uariFareBaslik => 'Fare riski başlayabilir';

  @override
  String get uariFareMesaj =>
      'Kovan girişlerini daralt. Fare girişini engellemek için önlem al.';

  @override
  String uyariVarroaPlanBaslik(String etiket) {
    return '$etiket öncesi varroa mücadelesini planla';
  }

  @override
  String get uyariVarroaPlanMesaj =>
      'Bal akımı yaklaşmadan önce varroa durumunu değerlendir. Kimyasal uygulama yapılacaksa kalıntı riskini hesaba katarak erken planla.';

  @override
  String get uyariVarroaSonBaslik =>
      'Bal akımı öncesi varroa mücadelesi için son dönem';

  @override
  String uyariVarroaSonMesaj(
      String baslangicTarih, String etiket, String kalintiTarih) {
    return '$baslangicTarih tarihinde başlaması beklenen $etiket öncesi kalıntı riskini azaltmak için varroa mücadelesi mümkünse $kalintiTarih tarihine kadar tamamlanmış olmalı. Geciktiysen yeni kimyasal uygulamayı bal akımı sonrasına bırakman daha güvenli olabilir.';
  }

  @override
  String uyariBalBolmeErkenBaslik(String etiket) {
    return '$etiket yaklaşırken bölme kararına dikkat';
  }

  @override
  String get uyariBalBolmeErkenMesaj =>
      'Üretim hedefi korunacaksa bölme kararını dikkatli ver. Bal akımına güçlü işçi arı yetişmesi için zaman daralıyor.';

  @override
  String get uyariBalBolmeGecBaslik => 'Bölme yapılacaksa dikkat';

  @override
  String uyariBalBolmeGecMesaj(String kritikEsik) {
    return '$kritikEsik sonrası 42 günlük biyolojik eşik aşılmış olur. Bu tarihten sonra yapılan bölmeler bal verimini düşürebilir. Üretim hedefi korunacaksa bölme kararını ertele.';
  }

  @override
  String get kararVetoDogrudan =>
      'Koloni oğul kökenli olduğu için temiz donör havuzuna alınmadı.';

  @override
  String get kararVetoKendisiOgulAtti =>
      'Koloni kendi geçmişinde oğul attığı için donör değerlendirmesinde veto aldı.';

  @override
  String kararVetoAtaHattaRef(String referansNo) {
    return '$referansNo hattında oğul izi bulunduğu için temiz donör havuzuna alınmadı.';
  }

  @override
  String get kararVetoAtaHatta =>
      'Atasal hatta oğul izi bulunduğu için temiz donör havuzuna alınmadı.';

  @override
  String kararDonorSirasi(int sira) {
    return 'Temiz donör havuzunda $sira. sırada görünüyor.';
  }

  @override
  String kararSonCitaMetni(int cita) {
    return 'Son muayenede koloni $cita çıta gücünde görünüyor.';
  }

  @override
  String kararMaxCitaMetni(int cita) {
    return 'Bu sezon gördüğü en yüksek güç $cita çıta.';
  }

  @override
  String kararBalCitaMetni(int cita) {
    return 'Bal taşıma sinyali $cita ballı çıta ile görülüyor.';
  }

  @override
  String get kararTrendYukselis => 'Son muayenelerde gelişim yönü yukarı.';

  @override
  String get kararTrendDusus => 'Son muayenelerde güç kaybı eğilimi görülüyor.';

  @override
  String get kararTrendStabil => 'Gidişat stabil görünüyor.';

  @override
  String kararAnaYasiRisk(int yas) {
    return 'Ana yaşı $yas yıl olduğu için verim ve düzen düşüşü riski taşıyor.';
  }

  @override
  String get kararMizacRisk => 'Mizaç verisi saha yönetimini zorlaştırabilir.';

  @override
  String get kararAzVeriUyari =>
      'Karar az veriyle üretildiği için güven payı düşüktür.';

  @override
  String get kararBolmePlan =>
      'Bölme yapacaksan koloniyi 6 çıtanın altına düşürmeden planla.';

  @override
  String get kararDonorOncelik =>
      'Ana üretiminde bu koloniyi aday havuzunda öncelikli düşün.';

  @override
  String get kararAnaDegisimPlan =>
      'Ana değişimini aktif dönemin sonuna yakın planlamak genelde daha güvenli olur.';

  @override
  String get kararGuclendir =>
      'Kapalı yavru, besleme ve düzenli muayene ile güçlenme yönünü izle.';

  @override
  String get kararUretimTut =>
      'Üretimde tut; bal akımı yaklaşırken alan ve kat yönetimini öne al.';

  @override
  String get kararPasifKayitOner =>
      'Koloniyi aktif üretimden çok soy ve geçmiş kaydı olarak değerlendir.';

  @override
  String get kararNeden => 'Neden';

  @override
  String get kararKilitBekle => 'Bekle';

  @override
  String get kararKilitGerekce =>
      'Bu pencere kapanmadan çelişen eylem önerilmez.';

  @override
  String kararBolmeGucluMesaj(int gun) {
    return 'Koloni güçlü gelişim gösteriyor ve bal akımına yaklaşık $gun gün var. Kat seviyesine yaklaşmış olsa da bu süre içinde oğul baskısı doğabilir; genetik değeri uygunsa kontrollü bölme değerlendirilebilir.';
  }

  @override
  String kararBolmeSinirliMesaj(int gun) {
    return 'Koloni güçlü; ancak bal akımına yaklaşık $gun gün kaldığı için bölme kararı sınırlı ve dikkatli düşünülmeli. Ana koloni bala yetişemeyecekse bölme yerine alan/oğul yönetimi öne alınır.';
  }

  @override
  String get kararBolmeGerekce =>
      'Bölme kararı sadece çıta sayısı değildir: bal akımına kalan süre, gelişim yönü, yavru düzeni, işlevsel çıta ve genetik veto birlikte okundu.';

  @override
  String get kararKatEsikSurupluklu => 'Şurupluk + 9 çıta kapasitesi';

  @override
  String get kararKatEsikSurupluksuz => 'Şurupluksuz 10 çıta kapasitesi';

  @override
  String get kararKatAkimAktif => 'Bal akımı aktif görünüyor.';

  @override
  String get kararKatAkimKontrol =>
      'Bal akımı penceresi ayrıca kontrol edilmeli.';

  @override
  String kararKatAkimKalan(int gun) {
    return 'Bal akımına yaklaşık $gun gün var.';
  }

  @override
  String kararKatMesaj(String esik, int yuzde, String akim) {
    return '$esik dolmuş ve yaklaşık %$yuzde aktivasyon görülüyor. $akim Bu eşik artık normal çıta ekleme değil, kat/ballık verme eşiğidir.';
  }

  @override
  String get kararKatGerekce =>
      'Şurupluk varsa kuluçkalık 9 çıta, şurupluk kaldırıldıysa 10 çıta kapasite kabul edilir.';

  @override
  String get kararUcuncuKatEsikSurupluklu => 'Şurupluk + 19 çıta kapasitesi';

  @override
  String get kararUcuncuKatEsikSurupluksuz => 'Şurupluksuz 20 çıta kapasitesi';

  @override
  String kararUcuncuKatMesaj(String esik, int yuzde) {
    return '$esik dolmuş ve yaklaşık %$yuzde aktivasyon görülüyor. Koloni ikinci üst hacmi doldurma eşiğine gelmiş; 3. kat/ikinci ballık değerlendirilmeli.';
  }

  @override
  String get kararUcuncuKatGerekce =>
      'Şurupluk varsa 19 çıta, şurupluk kaldırıldıysa 20 çıta 3. kat verme eşiğidir. Bir sonraki çıta artışı 3 katlı koloni olarak okunur.';

  @override
  String kararAlanMesajKulucluk(int yuzde) {
    return 'Mevcut hacim yaklaşık %$yuzde aktive olmuş. Koloni sıkışmadan ballık/alan yönetimi değerlendirilebilir.';
  }

  @override
  String kararAlanMesajCita(int cita) {
    return 'Mevcut $cita çıtanın tamamına yakını işlevsel kullanılıyor. Koloni sıkışmadan 1 çıta eklenmasi değerlendirilebilir.';
  }

  @override
  String get kararHasatSonrasiMesaj =>
      'Hasat sonrası koloni sıkışabilir; stok, alan ve varroa kontrolü yapılmalıdır.';

  @override
  String get kararHasatSonrasiGerekce =>
      'Bal alımı sonrası aynı çıta düzeni artık üretim değil bakım kararıdır.';

  @override
  String get kararKisHazirlikMesaj =>
      'Koloni kışa doğru yeterli stok, doğru hacim, düşük varroa baskısı ve uygun nüfusla hazırlanmalı.';

  @override
  String get kararKisHazirlikGerekce =>
      'Kış başarısı genetik seçilim ve sürdürülebilir arılık yönetiminin temel ölçütlerinden biridir.';

  @override
  String get kararSinifiZayif => 'Zayıf';

  @override
  String get kararSinifiGelisim => 'Gelişim';

  @override
  String get kararSinifiUretim => 'Üretim';

  @override
  String get kararSinifiHasat => 'Hasat';

  @override
  String get kararSinifiIzleme => 'İzleme';

  @override
  String get surecNedeniAnasizlik =>
      'Ana kazanma / anasızlık süreci biyolojik zamanlamaya bağlıdır. Bu pencere açıkken önce süreç yönetilir.';

  @override
  String get surecNedeniOgul =>
      'Ana memesi veya oğul belirtisi aktif saha riskidir. Önce oğul yönetimi yapılır.';

  @override
  String get surecNedeniOgulSonrasi =>
      'Oğul sonrası yeni ana ve artçı oğul riski önceliklidir. Süreç kapanmadan genel üretim veya donör dili öne çıkarılmaz.';

  @override
  String get surecNedenibolme =>
      'Bölme sonrası koloni düzeni ve ana süreci oturmadan genel performans dili ana karar olarak gösterilmez.';

  @override
  String get surecNedeniHasat =>
      'Bal alımı koloni düzenini değiştirir. Önce sıkışık düzen, stres yönetimi, besleme ihtiyacı ve varroa penceresi birlikte değerlendirilir.';

  @override
  String get surecNedeniGelisim =>
      'Gelişim yavaşlığı açıklanması gereken saha durumudur. Önce neden aranır; sonra üretim veya genetik rol yeniden değerlendirilir.';

  @override
  String get surecNedeniVarsayilan =>
      'Aktif süreç varsa önce süreç yönetimi öne alınır.';

  @override
  String get sezonHedefRiskliAnaBaslik => 'Ana/yavru netleşmeli';

  @override
  String get sezonHedefRiskliAnaMesaj =>
      'Ana ve yavru düzeni netleşmeden üretim, kat veya çoğaltma kararı öne alınmaz.';

  @override
  String get sezonHedefRiskliAnaGerekce =>
      'Yavru düzeni netleşmeden yapılan işlem koloni kaybı riskini artırır.';

  @override
  String get sezonHedefBolmeBaslik => 'Bölme toparlanıyor';

  @override
  String get sezonHedefBolmeMesaj =>
      'Bu koloni için öncelik ana düzeninin oturması ve nüfusun korunmasıdır.';

  @override
  String get sezonHedefBolmeGerekce =>
      'Yeni bölmelerin bu sezon ana hedefi bal değil, sağlıklı koloni düzenine geçmektir.';

  @override
  String get sezonHedefKisBaslik => 'Kış kontrolü';

  @override
  String get sezonHedefKisMesaj =>
      'Kovan gereksiz açılmadan stok, nem ve dış uçuş durumu izlenmelidir.';

  @override
  String get sezonHedefKisGerekce =>
      'Kışta gereksiz müdahale salkımı ve ısı düzenini bozar.';

  @override
  String get sezonHedefKisHazirlikBaslik => 'Kışa hazırlık';

  @override
  String get sezonHedefKisHazirlikMesaj =>
      'Stok, hacim ve varroa durumu kışa giriş için kontrol edilmelidir.';

  @override
  String get sezonHedefKisHazirlikGerekce =>
      'Kışa hazırlık vurgusu sonbahar döneminde anlamlıdır.';

  @override
  String get sezonHedefHasatSonrasiBaslik => 'Hasat sonrası bakım';

  @override
  String get sezonHedefHasatSonrasiMesaj =>
      'Hasat sonrası stok, alan ve varroa durumu kontrol edilmelidir.';

  @override
  String get sezonHedefHasatSonrasiGerekce =>
      'Bal alımı sonrası koloni düzeni değişir; bakım kararı üretim kararının önüne geçer.';

  @override
  String get sezonHedefHasatKolonisiBaslik => 'Hasat kolonisi';

  @override
  String get sezonHedefHasatKolonisiMesaj =>
      'Koloni bal akımı içinde alan ve hasat yönünden izlenebilir.';

  @override
  String get sezonHedefHasatKolonisiGerekce =>
      'İşlevsel güç hasat değerlendirmesi için yeterli görünüyor.';

  @override
  String get sezonHedefGelisimAkimMesaj =>
      'Hasat hedefi yok. Öncelik güçlenme, stok ve ana düzenidir.';

  @override
  String get sezonHedefGelisimAkimGerekce =>
      'İşlevsel çıta gücü hasat eşiğinin altında.';

  @override
  String get sezonHedefGenetikCogaltmaBaslik => 'Kontrollü çoğaltma adayı';

  @override
  String get sezonHedefGenetikCogaltmaMesaj =>
      'Koloni güçlü ve düzenli ilerliyor; süre uygunsa kontrollü bölme değerlendirilebilir.';

  @override
  String get sezonHedefGenetikCogaltmaGerekce =>
      'Bal akımına kalan süre ana koloninin tekrar toparlanmasına izin verebilir.';

  @override
  String get sezonHedefKisaHazirlikBaslik => 'Bal akımı hazırlık';

  @override
  String get sezonHedefKisaHazirlikMesaj =>
      'Bal akımına kısa süre kaldığından koloninin gücünü korumak önemlidir. Hasat kalıntı güvenliği önemsenmelidir. Zaman zaman bal akım döneminde, bal tüketen nüfusu koloniden uzaklaştırmak için teknik bir koloni bölme işlemi yapılabilir. Bu uygulama bilgi olarak verilmiştir. Gerçekleştirebilmek bilgi ve tecrübe gerektirir.';

  @override
  String get sezonHedefZayifDestekBaslik => 'Güçlendirme';

  @override
  String get sezonHedefZayifDestekMesaj =>
      'Öncelik stok, nüfus ve ana düzenini güvenli seviyeye çıkarmaktır.';

  @override
  String get sezonHedefGelisimKolonisiBaslik => 'Gelişim kolonisi';

  @override
  String get sezonHedefGelisimKolonisiMesaj =>
      'Gelişim aşamasındaki koloni. Hasat süreci dışında kabul edilmelidir.';

  @override
  String get sezonHedefBalHazirlanBaslik => 'Bala hazırlanıyor';

  @override
  String get sezonHedefBalHazirlanMesaj =>
      'Koloni üretim gücüne yaklaşıyor; hedef oğul baskısı oluşturmadan bal akımına güçlü girmektir.';

  @override
  String get sezonHedefBalHazirlanGerekce =>
      'Gelişim yönü ve işlevsel çıta gücü üretim hedefini destekliyor.';

  @override
  String get kisAclikRiskiBaslik => 'Kış riski: stok yetersiz görünüyor';

  @override
  String get kisAclikRiskiMesaj =>
      'Kış döneminde kovanı gereksiz açma önerilmez; ancak stok çok düşükse açlık riski önceliklidir. Hava ve saha koşulu uygunsa hızlı, sınırlı stok desteği/kek değerlendirilir.';

  @override
  String get kisAclikRiskiGerekce =>
      'Kış yönetiminde temel kural minimum müdahaledir; fakat açlık riski minimum müdahale kuralından daha yüksek önceliklidir.';

  @override
  String get kisHacimRiskiBaslik => 'Kış riski: boş hacim yüksek olabilir';

  @override
  String get kisHacimRiskiMesaj =>
      'Fiziksel hacim yüksek ama işlevsel güç düşük görünüyorsa kış salkımı ısıyı korumakta zorlanabilir. Uygun zamanda hacim daraltma ve nem kontrolü değerlendirilir.';

  @override
  String get kisHacimRiskiGerekce =>
      'Kış başarısı yalnızca stokla değil, koloni hacmi ile arı nüfusunun uyumuyla belirlenir.';

  @override
  String get kisZayiflamaTakibiBaslik => 'Kış riski: güç kaybı izlenmeli';

  @override
  String get kisZayiflamaTakibiMesaj =>
      'Kış döneminde güç kaybı görülüyorsa kovanı açmadan dış gözlem, ağırlık, uçuş deliği ve nem kontrolü öne alınır. Uygun havada sınırlı kontrol yapılabilir.';

  @override
  String get kisZayiflamaTakibiGerekce =>
      'Kışta gereksiz muayene salkımı ve ısı düzenini bozabilir.';

  @override
  String get kisDisGozlemBaslik => 'Kış yönetimi: gereksiz açma yok';

  @override
  String get kisDisGozlemMesaj =>
      'Koloni için ana yaklaşım kovanı gereksiz açmadan dış gözlem, ağırlık hissi, uçuş deliği, nem ve su girişi kontrolüdür.';

  @override
  String get kisDisGozlemGerekce =>
      'Kış dönemi algoritması üretim değil yaşatma odaklıdır. İlkbahar çıkışı genetik istikrar skoruna veri sağlar.';

  @override
  String get sapmaAnaSureczyBaslik => 'Ana sürecinde zayıflama riski';

  @override
  String get sapmaAnaSureczyMesaj =>
      'Ana/yavru süreci devam ederken koloni gücü düşüyorsa normal bekleme senaryosu zayıflama riskine döner. Bu aşamada üretim değil, ana durumunu netleştirme ve yaşatma hedefi öne çıkar.';

  @override
  String get sapmaAnaSureczyGerekce =>
      'Beklenen akış: ana kazanma → yavru görülmesi → toparlanma. Sapma: süreç uzar ve nüfus düşerse ana kaybı, çiftleşme başarısızlığı veya dış tehdit olasılığı artar.';

  @override
  String get sapmaBolmeTutmadiBaslik => 'Bölme toparlanmıyor';

  @override
  String get sapmaBolmeTutmadiMesaj =>
      'Bölme sonrası beklenen akış ana düzeninin oturması ve nüfusun korunmasıdır. Yavru düzeni yoksa ve güç düşüyorsa bu koloni için bal hedefi değil, ana tutma/yaşatma süreci öne çıkar.';

  @override
  String get sapmaBolmeTutmadiGerekce =>
      'Bölme süreci sadece gün sayısıyla kapanmaz; yavru düzeni, işlevsel çıta ve yeniden büyüme görülmeden süreç tamamlanmış kabul edilmez.';

  @override
  String get sapmaOgulRiskiBaslik => 'Erken sıkışma oğul riski';

  @override
  String get sapmaOgulRiskiMesaj =>
      'Koloni bal akımı başlamadan güçlü büyümeye devam ediyor. Bu güç yalnızca kat ile yönetilirse bal akımına kadar oğul baskısı doğabilir; genetik değeri uygunsa kontrollü bölme, değilse alan/oğul yönetimi düşünülmelidir.';

  @override
  String get sapmaOgulRiskiGerekce =>
      'Beklenen hedef 11–12 çıtalık güçlü ama yönetilebilir koloniyle bal akımına girmektir. Bu eşiğin erken aşılması üretim değil oğul riski üretebilir.';

  @override
  String get sapmaAkimAlanTakibiBaslik => 'Bal akımında alan izle';

  @override
  String get sapmaAkimAlanTakibiMesaj =>
      'Bal akımı içinde davranış değişir; koloni yavru büyütmeden çok nektar depolamaya yönelebilir. Düşük görünen stok tek başına zayıflık sayılmaz, alan ve sırlanma birlikte izlenir.';

  @override
  String get sapmaAkimAlanTakibiGerekce =>
      'Bal akımı döneminde yavru ve stok verileri normal dönem gibi okunmaz; nektar girişi, ballık alanı ve hasat zamanı birlikte değerlendirilir.';

  @override
  String get sapmaHasatStokRiskiBaslik => 'Hasat sonrası stok düşük';

  @override
  String get sapmaHasatStokRiskiMesaj =>
      'Hasat sonrası beklenen akış stok, varroa ve hacim düzeninin toparlanmasıdır. Stok düşük görünüyorsa üretim dili kapanır; kışa güvenli giriş için stok ve sıkıştırma birlikte değerlendirilir.';

  @override
  String get sapmaHasatStokRiskiGerekce =>
      'Hasat balı alındıktan sonra aynı çıta gücü üretim başarısı değil, kışa hazırlık riski olarak okunabilir.';

  @override
  String get sapmaHasatHacimRiskiBaslik => 'Hasat sonrası hacim fazla olabilir';

  @override
  String get sapmaHasatHacimRiskiMesaj =>
      'Fiziksel çıta alanı yüksek ama işlevsel güç düşükse koloni gereksiz hacimde kalabilir. Bu durumda alan daraltma, stok ve kış düzeni üretim kararlarının önüne geçer.';

  @override
  String get sapmaHasatHacimRiskiGerekce =>
      'Hasat sonrası dönemde fazla boş hacim yağmacılık, nem ve ısı yönetimi riskini artırabilir.';

  @override
  String get genetikVetoBaslik => 'Genetik çoğaltma değeri: veto';

  @override
  String get genetikYuksekBaslik => 'Genetik çoğaltma değeri yüksek';

  @override
  String get genetikIzleBaslik => 'Genetik çoğaltma değeri izleme bandında';

  @override
  String get genetikVetoMesaj =>
      'Koloni çoğaltma havuzunda öne çıkarılmaz. Üretim değeri ayrı, genetik yayılım değeri ayrıdır.';

  @override
  String get genetikSkorGerekce =>
      'Biyolojik güç, yavru düzeni, gelişim istikrarı ve riskler birlikte değerlendirilir.';

  @override
  String get beslemeYonetimVarsayilanBaslik => 'Besleme Yönetimi';

  @override
  String beslemeDestekBandi(String bant) {
    return 'Tahmini destek bandı: $bant';
  }

  @override
  String get varroaTakvimBaslik => 'Varroa takvimi izlenmeli.';

  @override
  String get varroaTakvimGerekce =>
      'Mevsime uygun varroa kaydı ve takip disiplini korunmalı.';

  @override
  String get varroaKayitYok => 'Varroa kaydı henüz yok.';

  @override
  String get varroaKayitYokGerekce =>
      'Takvimsel varroa hatırlatmaları ilk muayene kayıtlarından sonra daha anlamlı hale gelir.';

  @override
  String get varroaKayitYokOneri =>
      'Muayenelerde yapılan varroa mücadelesini düzenli kaydet.';

  @override
  String get varroaIlkbaharKayitVar => 'Erken ilkbahar varroa kaydı var.';

  @override
  String get varroaIlkbaharKayitVarGerekce =>
      'Sezon başında yapılan mücadele kaydı görülüyor. Bu, ilkbahar gelişimine daha düşük baskıyla girmeyi destekler.';

  @override
  String get varroaIlkbaharKayitVarOneri =>
      'Mücadele etkisini sonraki muayenelerde takip et.';

  @override
  String get varroaIlkbaharKontrolPlanla =>
      'İlkbahar varroa kontrolü planlanmalı.';

  @override
  String get varroaIlkbaharKontrolGerekce =>
      'Erken ilkbahar dönemi varroa baskısını sezon başında düşürmek için önemli bir penceredir.';

  @override
  String get varroaIlkbaharKontrolOneri =>
      'Kolonileri kontrol et; gerekirse erken ilkbahar müdahalesi planla.';

  @override
  String get varroaBalOncesiKayitVar =>
      'Bal akımı öncesi varroa kaydı görünüyor.';

  @override
  String get varroaBalOncesiPlanGozden =>
      'Bal akımı öncesi varroa planı gözden geçirilmeli.';

  @override
  String get varroaBalOncesiGerekce =>
      'Bal akımı dönemine girerken varroa planının tamamlanmış olması daha güvenlidir.';

  @override
  String get varroaBalOncesiOneri =>
      'Bal akımı içinde değil, öncesinde planlama yap.';

  @override
  String get varroaYazTakip => 'Yaz döneminde varroa takibi sürdürülmeli.';

  @override
  String get varroaYazTakipGerekce =>
      'Yaz ortasında amaç sürekli ilaçlama değil, düzenli izleme ve hasat sonrası döneme hazırlıktır.';

  @override
  String get varroaYazTakipOneri =>
      'Muayenelerde varroa kaydını ve koloni gidişatını düzenli izle.';

  @override
  String get varroaKritikKayitVar =>
      'Kritik dönemde varroa mücadelesi kaydı var.';

  @override
  String get varroaKritikKayitVarGerekce =>
      'Yaz sonu–erken sonbahar, kış arısının oluştuğu ve varroa baskısının en kritik olduğu dönemdir.';

  @override
  String get varroaKritikKayitVarOneri =>
      'Hasat sonrası planı sürdür; etkinliği sonraki muayenede kontrol et.';

  @override
  String get varroaHasatSonrasiGecikiyor =>
      'Hasat sonrası varroa mücadelesi gecikiyor.';

  @override
  String get varroaHasatSonrasiGecikiyorGerekce =>
      'Yaz sonu–erken sonbaharda kayıt görünmüyor. Bu dönem kış arısının sağlığı açısından en kritik pencere kabul edilir.';

  @override
  String get varroaHasatSonrasiGecikiyorOneri1 =>
      'Bal sağımı sonrası mücadeleyi geciktirme.';

  @override
  String get varroaHasatSonrasiGecikiyorOneri2 =>
      'Sonraki muayenede uygulamayı mutlaka kaydet.';

  @override
  String get varroaKisaGirisKayitVar => 'Kışa giriş öncesi varroa kaydı var.';

  @override
  String get varroaKisaGirisKayitVarGerekce =>
      'Sonbahar sonunda kayıt görünmesi kışa daha düşük yükle girme açısından olumlu bir sinyaldir.';

  @override
  String get varroaKisaGirisKayitVarOneri =>
      'Kışa girişten önce son genel durumu bir kez daha kontrol et.';

  @override
  String get varroaSonbaharKayitEksik =>
      'Sonbahar varroa kaydı eksik görünüyor.';

  @override
  String get varroaSonbaharKayitEksikGerekce =>
      'Kışa giriş öncesi dönemde mücadele kaydı görünmüyor. Sonbahar sonu kontrolü ihmal edilmemeli.';

  @override
  String get varroaSonbaharKayitEksikOneri =>
      'Yavru faaliyeti azaldıysa mücadele gerekliliğini değerlendir.';

  @override
  String get varroaKisSonbaharKayitVar => 'Sonbahar varroa kaydı görünüyor.';

  @override
  String get varroaKisSonbaharKayitVarGerekce =>
      'Kış döneminde esas amaç, sonbaharda düşürülmüş yükü koruyarak koloniyi gereksiz strese sokmamaktır.';

  @override
  String get varroaKisSonbaharKayitVarOneri =>
      'Kovanı gereksiz açmadan genel durumu izle.';

  @override
  String get varroaKisGozden => 'Kış varroa durumu gözden geçirilmeli.';

  @override
  String get varroaKisGozdenGerekce =>
      'Kayıt uzun süredir yok. Yavru faaliyeti azaldıysa durum tekrar değerlendirilmelidir.';

  @override
  String get varroaKisGozdenOneri =>
      'Yavru durumu ve mevsim koşullarına göre kış kontrolü yap.';

  @override
  String get varroaBalDonemiDikkat =>
      'Bal döneminde varroa kararı dikkat ister.';

  @override
  String get varroaBalDonemiGerekce =>
      'Bal akımı başladıktan sonra kalıntı riski olan kimyasal mücadele önerilmez.';

  @override
  String get varroaBalDonemiOneri1 =>
      'Gerekirse yalnızca bala kalıntı riski taşımayan, etikete ve mevzuata uygun yöntemleri değerlendir.';

  @override
  String get varroaBalDonemiOneri2 =>
      'Kimyasal mücadeleyi hasat sonrasına planla.';

  @override
  String get varroaBalOncesiTamamlandiBaslik =>
      'Bal akımı öncesi varroa planı tamamlanmış görünüyor.';

  @override
  String varroaBalOncesiTamamlandiGerekce(
      String balAkimMetni, String sonGunMetni) {
    return '$balAkimMetni tarihinde başlaması beklenen bal akımı öncesi en geç $sonGunMetni tarihine kadar mücadele tamamlanmalıydı. Kayıt buna uygun görünüyor.';
  }

  @override
  String get varroaBalOncesiTamamlandiOneri =>
      'Bal akımı içinde yeni mücadele planlama.';

  @override
  String get varroaBalOncesiKapaniyorBaslik =>
      'Bal akımı öncesi mücadele penceresi kapanıyor.';

  @override
  String varroaBalOncesiKapaniyorGerekce(
      String balAkimMetni, String sonGunMetni) {
    return '$balAkimMetni tarihinde başlaması beklenen bal akımı öncesi kalıntı riskini azaltmak için mücadele en geç $sonGunMetni tarihine kadar tamamlanmış olmalı.';
  }

  @override
  String get varroaBalOncesiKapaniyorOneri1 =>
      'Bu aşamada bal akımı öncesi kimyasal mücadele planlarken kalıntı riskini dikkate al.';

  @override
  String get varroaBalOncesiKapaniyorOneri2 =>
      'Geciktiysen yeni kimyasal uygulamayı bal akımı sonrasına bırakman daha güvenli olabilir.';

  @override
  String get varroaBalOncesiSonPencereBaslik =>
      'Bal akımı öncesi son varroa penceresine giriliyor.';

  @override
  String varroaBalOncesiSonPencereGerekce(
      String balAkimMetni, String sonGunMetni) {
    return '$balAkimMetni tarihinde başlaması beklenen bal akımı için mücadele en geç $sonGunMetni tarihine kadar tamamlanmalı. Süre daralıyor.';
  }

  @override
  String get varroaBalOncesiSonPencereOneri =>
      'Mücadele gerekiyorsa son güvenli tarihe bırakmadan planla.';

  @override
  String varroaBalOncesiSonGunHatirla(String sonGunMetni) {
    return 'Bal akımı öncesi son güvenli mücadele tarihi: $sonGunMetni.';
  }

  @override
  String varroaSonKayit(String tarih, String yontem) {
    return 'Son kayıt: $tarih / $yontem.';
  }
}
