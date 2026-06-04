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
}
