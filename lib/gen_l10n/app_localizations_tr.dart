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
}
