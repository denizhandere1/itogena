import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In tr, this message translates to:
  /// **'İtogena Arılık Yönetimi'**
  String get appTitle;

  /// No description provided for @girisYukleniyor.
  ///
  /// In tr, this message translates to:
  /// **'Veriler hazırlanıyor...'**
  String get girisYukleniyor;

  /// No description provided for @girisSurumKontrol.
  ///
  /// In tr, this message translates to:
  /// **'Sürüm kontrol ediliyor...'**
  String get girisSurumKontrol;

  /// No description provided for @girisYeniSurum.
  ///
  /// In tr, this message translates to:
  /// **'Yeni sürüm denetleniyor...'**
  String get girisYeniSurum;

  /// No description provided for @girisAnaSayfaAciliyor.
  ///
  /// In tr, this message translates to:
  /// **'Ana sayfa açılıyor...'**
  String get girisAnaSayfaAciliyor;

  /// No description provided for @girisBaslatmaSorunu.
  ///
  /// In tr, this message translates to:
  /// **'Başlatma sırasında sorun oluştu.'**
  String get girisBaslatmaSorunu;

  /// No description provided for @girisBaslatmaHatasi.
  ///
  /// In tr, this message translates to:
  /// **'Başlatma hatası: {hata}'**
  String girisBaslatmaHatasi(String hata);

  /// No description provided for @iptal.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get iptal;

  /// No description provided for @tamam.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get tamam;

  /// No description provided for @evet.
  ///
  /// In tr, this message translates to:
  /// **'Evet'**
  String get evet;

  /// No description provided for @hayir.
  ///
  /// In tr, this message translates to:
  /// **'Hayır'**
  String get hayir;

  /// No description provided for @sil.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get sil;

  /// No description provided for @duzenle.
  ///
  /// In tr, this message translates to:
  /// **'Düzenle'**
  String get duzenle;

  /// No description provided for @kaydet.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get kaydet;

  /// No description provided for @ekle.
  ///
  /// In tr, this message translates to:
  /// **'Ekle'**
  String get ekle;

  /// No description provided for @vazgec.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get vazgec;

  /// No description provided for @kapat.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get kapat;

  /// No description provided for @geri.
  ///
  /// In tr, this message translates to:
  /// **'Geri'**
  String get geri;

  /// No description provided for @onayla.
  ///
  /// In tr, this message translates to:
  /// **'Onayla'**
  String get onayla;

  /// No description provided for @hata.
  ///
  /// In tr, this message translates to:
  /// **'Hata'**
  String get hata;

  /// No description provided for @basarili.
  ///
  /// In tr, this message translates to:
  /// **'Başarılı'**
  String get basarili;

  /// No description provided for @uyari.
  ///
  /// In tr, this message translates to:
  /// **'Uyarı'**
  String get uyari;

  /// No description provided for @bilgi.
  ///
  /// In tr, this message translates to:
  /// **'Bilgi'**
  String get bilgi;

  /// No description provided for @yukleniyor.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor...'**
  String get yukleniyor;

  /// No description provided for @bilinmiyor.
  ///
  /// In tr, this message translates to:
  /// **'Bilinmiyor'**
  String get bilinmiyor;

  /// No description provided for @bulunamadi.
  ///
  /// In tr, this message translates to:
  /// **'Bulunamadı.'**
  String get bulunamadi;

  /// No description provided for @anaSayfa.
  ///
  /// In tr, this message translates to:
  /// **'Ana sayfa'**
  String get anaSayfa;

  /// No description provided for @kovan.
  ///
  /// In tr, this message translates to:
  /// **'Kovan'**
  String get kovan;

  /// No description provided for @koloni.
  ///
  /// In tr, this message translates to:
  /// **'Koloni'**
  String get koloni;

  /// No description provided for @arilik.
  ///
  /// In tr, this message translates to:
  /// **'Arılık'**
  String get arilik;

  /// No description provided for @proRozeti.
  ///
  /// In tr, this message translates to:
  /// **'PRO'**
  String get proRozeti;

  /// No description provided for @proOzellik.
  ///
  /// In tr, this message translates to:
  /// **'Bu özellik PRO sürümüne aittir.'**
  String get proOzellik;

  /// No description provided for @proYukselt.
  ///
  /// In tr, this message translates to:
  /// **'PRO\'ya Yükselt'**
  String get proYukselt;

  /// No description provided for @anaSayfaAsistan.
  ///
  /// In tr, this message translates to:
  /// **'Arılıktaki asistanınız'**
  String get anaSayfaAsistan;

  /// No description provided for @anaSayfaSlogan.
  ///
  /// In tr, this message translates to:
  /// **'Muayeneni kaydet, gerisini biz hallederiz.'**
  String get anaSayfaSlogan;

  /// No description provided for @anaSayfaOzellik1Baslik.
  ///
  /// In tr, this message translates to:
  /// **'Kovanın içini gör'**
  String get anaSayfaOzellik1Baslik;

  /// No description provided for @anaSayfaOzellik1Aciklama.
  ///
  /// In tr, this message translates to:
  /// **'Hangi çıtada yavru var, hangi çıtada bal — görsel olarak.'**
  String get anaSayfaOzellik1Aciklama;

  /// No description provided for @anaSayfaOzellik2Baslik.
  ///
  /// In tr, this message translates to:
  /// **'Ne yapman gerektiğini öğren'**
  String get anaSayfaOzellik2Baslik;

  /// No description provided for @anaSayfaOzellik2Aciklama.
  ///
  /// In tr, this message translates to:
  /// **'Donör adayı mı, ana değişimi mi, bölme mi — sistem söyler.'**
  String get anaSayfaOzellik2Aciklama;

  /// No description provided for @anaSayfaOzellik3Baslik.
  ///
  /// In tr, this message translates to:
  /// **'Riskleri önceden gör'**
  String get anaSayfaOzellik3Baslik;

  /// No description provided for @anaSayfaOzellik3Aciklama.
  ///
  /// In tr, this message translates to:
  /// **'Varroa, arı kuşu, yağmacılık — sezon ve koloni birlikte okunur.'**
  String get anaSayfaOzellik3Aciklama;

  /// No description provided for @anaSayfaOzellik4Baslik.
  ///
  /// In tr, this message translates to:
  /// **'Hasat tahminini al'**
  String get anaSayfaOzellik4Baslik;

  /// No description provided for @anaSayfaOzellik4Aciklama.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini bal miktarı ve ekonomik değer koloniye göre hesaplanır.'**
  String get anaSayfaOzellik4Aciklama;

  /// No description provided for @anaSayfaRehber.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı Rehberi'**
  String get anaSayfaRehber;

  /// No description provided for @menuArilikYonetimi.
  ///
  /// In tr, this message translates to:
  /// **'Arılık Yönetimi'**
  String get menuArilikYonetimi;

  /// No description provided for @menuArilikYonetimiAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Kolonilerini ekle, muayene yap, takip et'**
  String get menuArilikYonetimiAciklama;

  /// No description provided for @menuRaporlar.
  ///
  /// In tr, this message translates to:
  /// **'Raporlar'**
  String get menuRaporlar;

  /// No description provided for @menuRaporlarAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Arılık geneli istatistik, ekonomik değer ve donör listesi'**
  String get menuRaporlarAciklama;

  /// No description provided for @menuSoyAgaci.
  ///
  /// In tr, this message translates to:
  /// **'Soy Ağacı'**
  String get menuSoyAgaci;

  /// No description provided for @menuSoyAgaciAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Kolonilerin genetik hat takibi'**
  String get menuSoyAgaciAciklama;

  /// No description provided for @menuFormullerHesaplamalar.
  ///
  /// In tr, this message translates to:
  /// **'Formüller ve Hesaplamalar'**
  String get menuFormullerHesaplamalar;

  /// No description provided for @menuFormullerHesaplamalarAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Şurup ve oksalik asit yardımcı ekranı'**
  String get menuFormullerHesaplamalarAciklama;

  /// No description provided for @menuAyarlar.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get menuAyarlar;

  /// No description provided for @menuAyarlarAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Kalibrasyon, bal akımı, risk takvimi ve sistem tercihleri'**
  String get menuAyarlarAciklama;

  /// No description provided for @karsilastirmaBaslik.
  ///
  /// In tr, this message translates to:
  /// **'KARŞILAŞTIRMALI ANALİZ'**
  String get karsilastirmaBaslik;

  /// No description provided for @karsilastirmaHata.
  ///
  /// In tr, this message translates to:
  /// **'Karşılaştırma verisi üretilemedi:\n{hata}'**
  String karsilastirmaHata(String hata);

  /// No description provided for @karsilastirmaKoloniBulunamadi.
  ///
  /// In tr, this message translates to:
  /// **'Karşılaştırılacak koloni bulunamadı.'**
  String get karsilastirmaKoloniBulunamadi;

  /// No description provided for @karsilastirmaAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Bu ekran iki farklı şeyi birlikte gösterir: genel performans ve genetik seçilim. Yüksek performans tek başına donörlük anlamına gelmez. Bir koloni güçlü olsa bile genetik veto nedeniyle temiz donör havuzunun dışında kalabilir.'**
  String get karsilastirmaAciklama;

  /// No description provided for @karsilastirmaKovanNo.
  ///
  /// In tr, this message translates to:
  /// **'Kovan {kovanNo}'**
  String karsilastirmaKovanNo(String kovanNo);

  /// No description provided for @karsilastirmaPerformans.
  ///
  /// In tr, this message translates to:
  /// **'Performans {skor}'**
  String karsilastirmaPerformans(String skor);

  /// No description provided for @karsilastirmaTemizDonor.
  ///
  /// In tr, this message translates to:
  /// **'Temiz donör #{sira}'**
  String karsilastirmaTemizDonor(String sira);

  /// No description provided for @karsilastirmaTemizHavuzda.
  ///
  /// In tr, this message translates to:
  /// **'Temiz havuzda önde değil'**
  String get karsilastirmaTemizHavuzda;

  /// No description provided for @karsilastirmaGenetikVeto.
  ///
  /// In tr, this message translates to:
  /// **'Genetik veto'**
  String get karsilastirmaGenetikVeto;

  /// No description provided for @karsilastirmaTablo.
  ///
  /// In tr, this message translates to:
  /// **'KARŞILAŞTIRMA TABLOSU'**
  String get karsilastirmaTablo;

  /// No description provided for @karsilastirmaKriter.
  ///
  /// In tr, this message translates to:
  /// **'Kriter'**
  String get karsilastirmaKriter;

  /// No description provided for @karsilastirmaSistemYorumu.
  ///
  /// In tr, this message translates to:
  /// **'SİSTEM YORUMU'**
  String get karsilastirmaSistemYorumu;

  /// No description provided for @karsilastirmaSistemYorumuLabel.
  ///
  /// In tr, this message translates to:
  /// **'Sistem Yorumu'**
  String get karsilastirmaSistemYorumuLabel;

  /// No description provided for @karsilastirmaBiyoloji.
  ///
  /// In tr, this message translates to:
  /// **'Biyoloji'**
  String get karsilastirmaBiyoloji;

  /// No description provided for @soyAgaciBaslik.
  ///
  /// In tr, this message translates to:
  /// **'SOY AĞACI'**
  String get soyAgaciBaslik;

  /// No description provided for @soyAgaciBasitHat.
  ///
  /// In tr, this message translates to:
  /// **'BASİT HAT'**
  String get soyAgaciBasitHat;

  /// No description provided for @soyAgaciDetayli.
  ///
  /// In tr, this message translates to:
  /// **'DETAYLI'**
  String get soyAgaciDetayli;

  /// No description provided for @soyAgaciHata.
  ///
  /// In tr, this message translates to:
  /// **'Soy ağacı yüklenemedi:\n{hata}'**
  String soyAgaciHata(String hata);

  /// No description provided for @soyAgaciBulunamadi.
  ///
  /// In tr, this message translates to:
  /// **'Yaşayan hat bulunamadı.\nKaynak koloni ilişkilerini kontrol et.'**
  String get soyAgaciBulunamadi;

  /// No description provided for @soyAgaciBasitAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Bu görünüm yaşayan hatları sade biçimde gösterir. Tamamen sönmüş hatlar gizlenir. Pasif koloniler sadece yaşayan bir hattın içinde görünür.'**
  String get soyAgaciBasitAciklama;

  /// No description provided for @soyAgaciHatOzeti.
  ///
  /// In tr, this message translates to:
  /// **'Hat Özeti'**
  String get soyAgaciHatOzeti;

  /// No description provided for @soyAgaciToplam.
  ///
  /// In tr, this message translates to:
  /// **'Toplam {sayi}'**
  String soyAgaciToplam(int sayi);

  /// No description provided for @soyAgaciAktif.
  ///
  /// In tr, this message translates to:
  /// **'Aktif {sayi}'**
  String soyAgaciAktif(int sayi);

  /// No description provided for @soyAgaciPasif.
  ///
  /// In tr, this message translates to:
  /// **'Pasif {sayi}'**
  String soyAgaciPasif(int sayi);

  /// No description provided for @soyAgaciAktifDurum.
  ///
  /// In tr, this message translates to:
  /// **'AKTİF'**
  String get soyAgaciAktifDurum;

  /// No description provided for @soyAgaciPasifDurum.
  ///
  /// In tr, this message translates to:
  /// **'pasif'**
  String get soyAgaciPasifDurum;

  /// No description provided for @formullerBaslik.
  ///
  /// In tr, this message translates to:
  /// **'FORMÜLLER VE HESAPLAMALAR'**
  String get formullerBaslik;

  /// No description provided for @formullerSekmeSurup.
  ///
  /// In tr, this message translates to:
  /// **'ŞURUP'**
  String get formullerSekmeSurup;

  /// No description provided for @formullerSekmeOksalik.
  ///
  /// In tr, this message translates to:
  /// **'OKSALİK'**
  String get formullerSekmeOksalik;

  /// No description provided for @formullerSekmeBiyoloji.
  ///
  /// In tr, this message translates to:
  /// **'BİYOLOJİ'**
  String get formullerSekmeBiyoloji;

  /// No description provided for @formullerSekmeBalAkimi.
  ///
  /// In tr, this message translates to:
  /// **'BAL AKIMI'**
  String get formullerSekmeBalAkimi;

  /// No description provided for @formullerSurupFormulu.
  ///
  /// In tr, this message translates to:
  /// **'Şurup Formülü'**
  String get formullerSurupFormulu;

  /// No description provided for @formullerSurupAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Hedef şerbet miktarını kg olarak girersen sistem kg su ve kg şeker verir. Sahada aynı ölçü kabını kullanıyorsan 1:1 veya 2:1 oranı aynı mantıkla korunur.'**
  String get formullerSurupAciklama;

  /// No description provided for @formullerSurupOrani.
  ///
  /// In tr, this message translates to:
  /// **'Şurup Oranı'**
  String get formullerSurupOrani;

  /// No description provided for @formullerSurupOraniAciklama.
  ///
  /// In tr, this message translates to:
  /// **'1:1 genelde teşvik şurubu, 2:1 genelde stok / kış hazırlığı için kullanılır. Bu ekran zorunlu uygulama emri değil, oran hesabı yardımcısıdır.'**
  String get formullerSurupOraniAciklama;

  /// No description provided for @formullerHedefSerbet.
  ///
  /// In tr, this message translates to:
  /// **'Hedef Şerbet'**
  String get formullerHedefSerbet;

  /// No description provided for @formullerHedefSerbetEtiket.
  ///
  /// In tr, this message translates to:
  /// **'Hedef şerbet miktarı'**
  String get formullerHedefSerbetEtiket;

  /// No description provided for @formullerHedefSerbetYardim.
  ///
  /// In tr, this message translates to:
  /// **'Örnek: 10 kg hedef şerbet için gerekli kg su ve kg şeker hesaplanır.'**
  String get formullerHedefSerbetYardim;

  /// No description provided for @formullerSurupSonuc.
  ///
  /// In tr, this message translates to:
  /// **'{oran} Şurup Sonucu'**
  String formullerSurupSonuc(String oran);

  /// No description provided for @formullerHedefSerbetSatir.
  ///
  /// In tr, this message translates to:
  /// **'Hedef Şerbet'**
  String get formullerHedefSerbetSatir;

  /// No description provided for @formullerSeker.
  ///
  /// In tr, this message translates to:
  /// **'Şeker'**
  String get formullerSeker;

  /// No description provided for @formullerSu.
  ///
  /// In tr, this message translates to:
  /// **'Su'**
  String get formullerSu;

  /// No description provided for @formullerSahaKatsayisi.
  ///
  /// In tr, this message translates to:
  /// **'Saha Katsayısı'**
  String get formullerSahaKatsayisi;

  /// No description provided for @formullerSurupNot.
  ///
  /// In tr, this message translates to:
  /// **'Kg hesabı hedef şerbet ağırlığı içindir. Hacimsel kapla çalışıyorsan aynı kapla oran kur; 1:1 için eşit kap, 2:1 için iki kap şeker bir kap su mantığı korunur.'**
  String get formullerSurupNot;

  /// No description provided for @formullerOksalikBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Oksalik Asit Yardımcı Hesabı'**
  String get formullerOksalikBaslik;

  /// No description provided for @formullerOksalikAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Bu ekran yalnızca hesaplama yardımcısıdır. Uygulama kararı için ruhsatlı ürün etiketi, yerel mevzuat ve veteriner/teknik danışman talimatı esas alınır.'**
  String get formullerOksalikAciklama;

  /// No description provided for @formullerOksalikStandart.
  ///
  /// In tr, this message translates to:
  /// **'10–15 Kovan İçin Standart Formül'**
  String get formullerOksalikStandart;

  /// No description provided for @formullerUygulamaNotu.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Notu'**
  String get formullerUygulamaNotu;

  /// No description provided for @formullerOksalikNot.
  ///
  /// In tr, this message translates to:
  /// **'Oksalik uygulaması genelde yavrusuz / yavru çok az dönemde daha anlamlıdır. Sıcaklık, doz, uygulama yöntemi ve tekrar sayısı için ürün etiketi esas alınmalıdır.'**
  String get formullerOksalikNot;

  /// No description provided for @formullerGuvenlikUyarisi.
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik Uyarısı'**
  String get formullerGuvenlikUyarisi;

  /// No description provided for @formullerOksalikGuvenlik.
  ///
  /// In tr, this message translates to:
  /// **'Koruyucu gözlük, eldiven ve maske kullan. Asit buharını soluma, cilt ve göz temasından kaçın. Ruhsatsız ürün, belirsiz doz veya etiketsiz karışım kullanma. Bu ekran tedavi talimatı değil, yardımcı hesaplama ekranıdır.'**
  String get formullerOksalikGuvenlik;

  /// No description provided for @formullerBiyolojikTakvim.
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik Takvim'**
  String get formullerBiyolojikTakvim;

  /// No description provided for @formullerBiyolojikAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Bu ekran ana kazanma biyoloji takvimini merkezi AriBiyolojiServisi üzerinden okur. Koloni detay, süreç uyarıları ve formüller aynı tarih mantığını kullanır.'**
  String get formullerBiyolojikAciklama;

  /// No description provided for @formullerAnaKazanmaSureci.
  ///
  /// In tr, this message translates to:
  /// **'Ana Kazanma Süreci'**
  String get formullerAnaKazanmaSureci;

  /// No description provided for @formullerBaslangicTipi.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç tipi'**
  String get formullerBaslangicTipi;

  /// No description provided for @formullerAnasizBirakildi.
  ///
  /// In tr, this message translates to:
  /// **'Anasız Bırakıldı'**
  String get formullerAnasizBirakildi;

  /// No description provided for @formullerBolmeYapildi.
  ///
  /// In tr, this message translates to:
  /// **'Bölme Yapıldı'**
  String get formullerBolmeYapildi;

  /// No description provided for @formullerHazirKapaliMeme.
  ///
  /// In tr, this message translates to:
  /// **'Hazır Kapalı Ana Memesi'**
  String get formullerHazirKapaliMeme;

  /// No description provided for @formullerHazirCiftlesmisAna.
  ///
  /// In tr, this message translates to:
  /// **'Hazır Çiftleşmiş Ana'**
  String get formullerHazirCiftlesmisAna;

  /// No description provided for @formullerBaslangicTarihi.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç tarihi'**
  String get formullerBaslangicTarihi;

  /// No description provided for @formullerTakvim.
  ///
  /// In tr, this message translates to:
  /// **'{tip} Takvimi'**
  String formullerTakvim(String tip);

  /// No description provided for @formullerSahaNotu.
  ///
  /// In tr, this message translates to:
  /// **'Saha Notu'**
  String get formullerSahaNotu;

  /// No description provided for @formullerAnaKazanmaSahaNot.
  ///
  /// In tr, this message translates to:
  /// **'Gün sayımı başlangıç günü dahil edilerek yapılır. Günlük / kapalı yavru görülürse muayene ekranındaki ilgili kutucuk işaretlenir ve ana kazanma süreci kapanır.'**
  String get formullerAnaKazanmaSahaNot;

  /// No description provided for @formullerKapaliIsciYavrusu.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı İşçi Yavrusu Çıkışı'**
  String get formullerKapaliIsciYavrusu;

  /// No description provided for @formullerKapaliIsciTarih.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı işçi yavrusu görülen tarih'**
  String get formullerKapaliIsciTarih;

  /// No description provided for @formullerKapaliIsciSonuc.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı İşçi Yavrusu Çıkış Penceresi'**
  String get formullerKapaliIsciSonuc;

  /// No description provided for @formullerKapaliErkekYavrusu.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı Erkek Yavrusu Çıkışı'**
  String get formullerKapaliErkekYavrusu;

  /// No description provided for @formullerKapaliErkekTarih.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı erkek yavrusu görülen tarih'**
  String get formullerKapaliErkekTarih;

  /// No description provided for @formullerKapaliErkekSonuc.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı Erkek Yavrusu Çıkış Penceresi'**
  String get formullerKapaliErkekSonuc;

  /// No description provided for @formullerBalAkimiKarar.
  ///
  /// In tr, this message translates to:
  /// **'Bal Akımı Kararı'**
  String get formullerBalAkimiKarar;

  /// No description provided for @formullerBalAkimiAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Sistem, bal akımına zayıf girmemek için 57 günlük saha planlama eşiğini kullanır. 42 gün ise yumurtadan tarlacıya biyolojik süredir; bu ikisi aynı şey değildir.'**
  String get formullerBalAkimiAciklama;

  /// No description provided for @formullerBalAkimTarihi.
  ///
  /// In tr, this message translates to:
  /// **'Bal akım başlangıç tarihi'**
  String get formullerBalAkimTarihi;

  /// No description provided for @formullerMevcutCita.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut çıta sayısı'**
  String get formullerMevcutCita;

  /// No description provided for @formullerCitaOrnek.
  ///
  /// In tr, this message translates to:
  /// **'Örnek: 9'**
  String get formullerCitaOrnek;

  /// No description provided for @formullerTarihBekleniyor.
  ///
  /// In tr, this message translates to:
  /// **'Tarih Bekleniyor'**
  String get formullerTarihBekleniyor;

  /// No description provided for @formullerTarihBekleniyorAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Karar üretilebilmesi için önce bal akım başlangıç tarihini seç.'**
  String get formullerTarihBekleniyorAciklama;

  /// No description provided for @formullerKarar.
  ///
  /// In tr, this message translates to:
  /// **'Karar'**
  String get formullerKarar;

  /// No description provided for @formullerSonGuvenliBolme.
  ///
  /// In tr, this message translates to:
  /// **'Son güvenli bölme tarihi'**
  String get formullerSonGuvenliBolme;

  /// No description provided for @formullerPlanlamaEsigi.
  ///
  /// In tr, this message translates to:
  /// **'Planlama eşiği'**
  String get formullerPlanlamaEsigi;

  /// No description provided for @formullerPlanlamaEsigiDeger.
  ///
  /// In tr, this message translates to:
  /// **'57 gün'**
  String get formullerPlanlamaEsigiDeger;

  /// No description provided for @formullerBiyolojikSure.
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik süre'**
  String get formullerBiyolojikSure;

  /// No description provided for @formullerBiyolojikSureDeger.
  ///
  /// In tr, this message translates to:
  /// **'42 gün: yumurtadan tarlacıya'**
  String get formullerBiyolojikSureDeger;

  /// No description provided for @formullerMevcutGuc.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut güç'**
  String get formullerMevcutGuc;

  /// No description provided for @formullerMevcutGucDeger.
  ///
  /// In tr, this message translates to:
  /// **'{cita} çıta'**
  String formullerMevcutGucDeger(int cita);

  /// No description provided for @formullerHedefAltSinir.
  ///
  /// In tr, this message translates to:
  /// **'Hedef alt sınır'**
  String get formullerHedefAltSinir;

  /// No description provided for @formullerEnFazlaAlinabilir.
  ///
  /// In tr, this message translates to:
  /// **'En fazla alınabilir'**
  String get formullerEnFazlaAlinabilir;

  /// No description provided for @formullerBolmePenceresiYok.
  ///
  /// In tr, this message translates to:
  /// **'Bu güçte güvenli bölme penceresi açılmamış görünüyor.'**
  String get formullerBolmePenceresiYok;

  /// No description provided for @formullerBolmePenceresiVar.
  ///
  /// In tr, this message translates to:
  /// **'{max} çıtadan fazla alınırsa koloni bal dönemine zayıf girebilir.'**
  String formullerBolmePenceresiVar(int max);

  /// No description provided for @formullerKabulKontrol.
  ///
  /// In tr, this message translates to:
  /// **'Kabul kontrol penceresi'**
  String get formullerKabulKontrol;

  /// No description provided for @formullerMemeKapanma.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini meme kapanma'**
  String get formullerMemeKapanma;

  /// No description provided for @formullerAnaCikisi.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini ana çıkışı'**
  String get formullerAnaCikisi;

  /// No description provided for @formullerCiftlesme.
  ///
  /// In tr, this message translates to:
  /// **'Çiftleşme uçuş penceresi'**
  String get formullerCiftlesme;

  /// No description provided for @formullerYumurtlamaKontrol.
  ///
  /// In tr, this message translates to:
  /// **'Yumurtlama kontrol penceresi'**
  String get formullerYumurtlamaKontrol;

  /// No description provided for @formullerKovanaDokunma.
  ///
  /// In tr, this message translates to:
  /// **'Kovana dokunma penceresi'**
  String get formullerKovanaDokunma;

  /// No description provided for @formullerBaslangic.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç'**
  String get formullerBaslangic;

  /// No description provided for @formullerTahminiCikis.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini çıkış'**
  String get formullerTahminiCikis;

  /// No description provided for @formullerUygulamaModeli.
  ///
  /// In tr, this message translates to:
  /// **'Damlatma'**
  String get formullerUygulamaModeli;

  /// No description provided for @raporListeHata.
  ///
  /// In tr, this message translates to:
  /// **'Rapor listesi üretilemedi:\n{hata}'**
  String raporListeHata(String hata);

  /// No description provided for @raporListeBos.
  ///
  /// In tr, this message translates to:
  /// **'Bu listede gösterilecek aktif koloni bulunamadı.'**
  String get raporListeBos;

  /// No description provided for @raporListeAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Bu liste {arilik} arılığındaki aktif kolonilerden üretilir. Sıralama ana eksende skora göre yapılır. Eşitlikte önce üreme, sonra üretim, sonra donörlük öne çıkar. Toplam {adet} kayıt var.'**
  String raporListeAciklama(String arilik, int adet);

  /// No description provided for @raporListeSira.
  ///
  /// In tr, this message translates to:
  /// **'SIRA'**
  String get raporListeSira;

  /// No description provided for @raporListeKoloniNo.
  ///
  /// In tr, this message translates to:
  /// **'KOLONİ NO'**
  String get raporListeKoloniNo;

  /// No description provided for @raporListeDurum.
  ///
  /// In tr, this message translates to:
  /// **'DURUM'**
  String get raporListeDurum;

  /// No description provided for @raporListeSkorCita.
  ///
  /// In tr, this message translates to:
  /// **'Skor {skor}  •  {cita} çıta'**
  String raporListeSkorCita(int skor, int cita);

  /// No description provided for @muayeneDetayBaslik.
  ///
  /// In tr, this message translates to:
  /// **'KOVAN {kovanNo} / MUAYENE'**
  String muayeneDetayBaslik(String kovanNo);

  /// No description provided for @muayeneDetayGenelBilgi.
  ///
  /// In tr, this message translates to:
  /// **'GENEL BİLGİ'**
  String get muayeneDetayGenelBilgi;

  /// No description provided for @muayeneDetayNotlar.
  ///
  /// In tr, this message translates to:
  /// **'NOTLAR'**
  String get muayeneDetayNotlar;

  /// No description provided for @muayeneDetayTetikler.
  ///
  /// In tr, this message translates to:
  /// **'TETİKLER'**
  String get muayeneDetayTetikler;

  /// No description provided for @muayeneDetaySurec.
  ///
  /// In tr, this message translates to:
  /// **'SÜREÇ KAYITLARI'**
  String get muayeneDetaySurec;

  /// No description provided for @muayeneDetayTarih.
  ///
  /// In tr, this message translates to:
  /// **'Tarih'**
  String get muayeneDetayTarih;

  /// No description provided for @muayeneDetayCita.
  ///
  /// In tr, this message translates to:
  /// **'Çıta'**
  String get muayeneDetayCita;

  /// No description provided for @muayeneDetayYavruluCita.
  ///
  /// In tr, this message translates to:
  /// **'Yavrulu Çıta'**
  String get muayeneDetayYavruluCita;

  /// No description provided for @muayeneDetayBalHasat.
  ///
  /// In tr, this message translates to:
  /// **'Bal/Hasat'**
  String get muayeneDetayBalHasat;

  /// No description provided for @muayeneDetayYavruDuzeni.
  ///
  /// In tr, this message translates to:
  /// **'Yavru Düzeni'**
  String get muayeneDetayYavruDuzeni;

  /// No description provided for @muayeneDetayMizac.
  ///
  /// In tr, this message translates to:
  /// **'Mizaç'**
  String get muayeneDetayMizac;

  /// No description provided for @muayeneDetayBesleme.
  ///
  /// In tr, this message translates to:
  /// **'Besleme'**
  String get muayeneDetayBesleme;

  /// No description provided for @muayeneDetayVarroaMucadele.
  ///
  /// In tr, this message translates to:
  /// **'Varroa Mücadelesi'**
  String get muayeneDetayVarroaMucadele;

  /// No description provided for @muayeneDetayYok.
  ///
  /// In tr, this message translates to:
  /// **'Yok'**
  String get muayeneDetayYok;

  /// No description provided for @muayeneDetayEvet.
  ///
  /// In tr, this message translates to:
  /// **'Evet'**
  String get muayeneDetayEvet;

  /// No description provided for @muayeneDetayKapaliMeme.
  ///
  /// In tr, this message translates to:
  /// **'Hazır kapalı ana memesi var'**
  String get muayeneDetayKapaliMeme;

  /// No description provided for @muayeneDetayHazirAna.
  ///
  /// In tr, this message translates to:
  /// **'Hazır çiftleşmiş ana verildi'**
  String get muayeneDetayHazirAna;

  /// No description provided for @muayeneDetayKendiAnasi.
  ///
  /// In tr, this message translates to:
  /// **'Kendi anasını yapacak'**
  String get muayeneDetayKendiAnasi;

  /// No description provided for @muayeneDetayOgulBelirtisi.
  ///
  /// In tr, this message translates to:
  /// **'Oğul Belirtisi'**
  String get muayeneDetayOgulBelirtisi;

  /// No description provided for @muayeneDetayOgulAtti.
  ///
  /// In tr, this message translates to:
  /// **'Oğul Attı'**
  String get muayeneDetayOgulAtti;

  /// No description provided for @muayeneDetayBolmeYapildi.
  ///
  /// In tr, this message translates to:
  /// **'Bölme Yapıldı'**
  String get muayeneDetayBolmeYapildi;

  /// No description provided for @muayeneDetayAnasizBirakildi.
  ///
  /// In tr, this message translates to:
  /// **'Anasız Bırakıldı'**
  String get muayeneDetayAnasizBirakildi;

  /// No description provided for @muayeneDetayKovanSondu.
  ///
  /// In tr, this message translates to:
  /// **'Kovan Söndü'**
  String get muayeneDetayKovanSondu;

  /// No description provided for @muayeneDetayKapaliYavruAktarildi.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı Yavrulu Çıta Aktarıldı'**
  String get muayeneDetayKapaliYavruAktarildi;

  /// No description provided for @muayeneDetayAnaKazanmaYontemi.
  ///
  /// In tr, this message translates to:
  /// **'Ana Kazanma Yöntemi'**
  String get muayeneDetayAnaKazanmaYontemi;

  /// No description provided for @muayeneDetayDisaridanAna.
  ///
  /// In tr, this message translates to:
  /// **'Dışarıdan Hazır Ana Verildi'**
  String get muayeneDetayDisaridanAna;

  /// No description provided for @muayeneDetayGunlukYavru.
  ///
  /// In tr, this message translates to:
  /// **'Günlük / Kapalı Yavru Görüldü'**
  String get muayeneDetayGunlukYavru;

  /// No description provided for @muayeneDetaySuruplukKaldirildi.
  ///
  /// In tr, this message translates to:
  /// **'Şurupluk Kaldırıldı'**
  String get muayeneDetaySuruplukKaldirildi;

  /// No description provided for @muayeneDetayDroneKesimi.
  ///
  /// In tr, this message translates to:
  /// **'Drone Kesimi'**
  String get muayeneDetayDroneKesimi;

  /// No description provided for @muayeneDetayTimol.
  ///
  /// In tr, this message translates to:
  /// **'Timol'**
  String get muayeneDetayTimol;

  /// No description provided for @muayeneDetayAmitraz.
  ///
  /// In tr, this message translates to:
  /// **'Amitraz'**
  String get muayeneDetayAmitraz;

  /// No description provided for @muayeneDetayFormik.
  ///
  /// In tr, this message translates to:
  /// **'Formik'**
  String get muayeneDetayFormik;

  /// No description provided for @muayeneDetayOksalik.
  ///
  /// In tr, this message translates to:
  /// **'Oksalik'**
  String get muayeneDetayOksalik;

  /// No description provided for @muayeneDetayYavruYokAnaSureci.
  ///
  /// In tr, this message translates to:
  /// **'Bu muayenede yavru düzeni \"Yok\" kaydedilmiş. Aktif ana kazanma/bölme/oğul bağlamında sistem bunu önce biyolojik gün penceresine göre yorumlar; erken dönemde normal bekleme, gecikmiş dönemde yavrusuzluk tanısı olarak değerlendirir.'**
  String get muayeneDetayYavruYokAnaSureci;

  /// No description provided for @muayeneDetayYavruYokBasit.
  ///
  /// In tr, this message translates to:
  /// **'Bu muayenede yavru düzeni \"Yok\" kaydedilmiş. Sistem biyolojik modelde yavrulu çıtayı 0 kabul eder ve koloni geri dönüş kapasitesini bu bilgiyle okur.'**
  String get muayeneDetayYavruYokBasit;

  /// No description provided for @hatAnalizAppBarBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Hat Analizi'**
  String get hatAnalizAppBarBaslik;

  /// No description provided for @hatAnalizSayfaBasligi.
  ///
  /// In tr, this message translates to:
  /// **'HAT BAZLI SEÇİLİM ANALİZİ'**
  String get hatAnalizSayfaBasligi;

  /// No description provided for @hatAnalizAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Bu ekran yaşayan devamı olan hatları gösterir. Amaç, donörlüğe uygun kök hatları hızlıca görmek ve yaşayan hat içindeki sönmeleri kaybetmeden değerlendirmektir.'**
  String get hatAnalizAciklama;

  /// No description provided for @hatAnalizUstAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Bu ekranda yalnızca yaşayan devamı olan hatlar gösterilir. Tamamen kapanmış ve aktif koloni bırakmamış hatlar ana listede yer almaz.'**
  String get hatAnalizUstAciklama;

  /// No description provided for @hatAnalizToplamYasayan.
  ///
  /// In tr, this message translates to:
  /// **'Toplam yaşayan hat sayısı'**
  String get hatAnalizToplamYasayan;

  /// No description provided for @hatAnalizFiltre.
  ///
  /// In tr, this message translates to:
  /// **'FİLTRE'**
  String get hatAnalizFiltre;

  /// No description provided for @hatAnalizBos.
  ///
  /// In tr, this message translates to:
  /// **'Bu filtrede gösterilecek yaşayan hat bulunamadı.'**
  String get hatAnalizBos;

  /// No description provided for @hatAnalizNeden.
  ///
  /// In tr, this message translates to:
  /// **'NEDEN / NOT'**
  String get hatAnalizNeden;

  /// No description provided for @hatAnalizAktifHat.
  ///
  /// In tr, this message translates to:
  /// **'Aktif Hat: {kovan}'**
  String hatAnalizAktifHat(String kovan);

  /// No description provided for @hatAnalizAktifTemsilci.
  ///
  /// In tr, this message translates to:
  /// **'Aktif Hat Temsilcisi: {kovan}'**
  String hatAnalizAktifTemsilci(String kovan);

  /// No description provided for @hatAnalizSonmusDurum.
  ///
  /// In tr, this message translates to:
  /// **'{karar} · Kök {kok} sönmüş'**
  String hatAnalizSonmusDurum(String karar, String kok);

  /// No description provided for @hatAnalizAktifHatiAc.
  ///
  /// In tr, this message translates to:
  /// **'Aktif Hattı Aç'**
  String get hatAnalizAktifHatiAc;

  /// No description provided for @hatAnalizAktifTemsilciAc.
  ///
  /// In tr, this message translates to:
  /// **'Aktif Temsilciyi Aç'**
  String get hatAnalizAktifTemsilciAc;

  /// No description provided for @hatAnalizToplam.
  ///
  /// In tr, this message translates to:
  /// **'Toplam'**
  String get hatAnalizToplam;

  /// No description provided for @hatAnalizAktif.
  ///
  /// In tr, this message translates to:
  /// **'Aktif'**
  String get hatAnalizAktif;

  /// No description provided for @hatAnalizSonmus.
  ///
  /// In tr, this message translates to:
  /// **'Sönmüş'**
  String get hatAnalizSonmus;

  /// No description provided for @hatAnalizSonmeOrani.
  ///
  /// In tr, this message translates to:
  /// **'Sönme %'**
  String get hatAnalizSonmeOrani;

  /// No description provided for @hatAnalizOrtMaksCita.
  ///
  /// In tr, this message translates to:
  /// **'Ort. Maks Çıta'**
  String get hatAnalizOrtMaksCita;

  /// No description provided for @hatAnalizOrtBalCita.
  ///
  /// In tr, this message translates to:
  /// **'Ort. Bal Çıtası'**
  String get hatAnalizOrtBalCita;

  /// No description provided for @hatAnalizTumu.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get hatAnalizTumu;

  /// No description provided for @hatAnalizDonorHat.
  ///
  /// In tr, this message translates to:
  /// **'Donör Hat'**
  String get hatAnalizDonorHat;

  /// No description provided for @hatAnalizGucluUretim.
  ///
  /// In tr, this message translates to:
  /// **'Güçlü Üretim Hattı'**
  String get hatAnalizGucluUretim;

  /// No description provided for @hatAnalizOperasyonel.
  ///
  /// In tr, this message translates to:
  /// **'Operasyonel Hat'**
  String get hatAnalizOperasyonel;

  /// No description provided for @hatAnalizRiskli.
  ///
  /// In tr, this message translates to:
  /// **'Riskli Hat'**
  String get hatAnalizRiskli;

  /// No description provided for @hatAnalizTakip.
  ///
  /// In tr, this message translates to:
  /// **'Takip Edilmeli'**
  String get hatAnalizTakip;

  /// No description provided for @hatAnalizVeriYetersiz.
  ///
  /// In tr, this message translates to:
  /// **'Veri Yetersiz'**
  String get hatAnalizVeriYetersiz;

  /// No description provided for @hatAnalizSayacUretim.
  ///
  /// In tr, this message translates to:
  /// **'Üretim Hattı'**
  String get hatAnalizSayacUretim;

  /// No description provided for @hatAnalizSayacOperasyonel.
  ///
  /// In tr, this message translates to:
  /// **'Operasyonel'**
  String get hatAnalizSayacOperasyonel;

  /// No description provided for @hatAnalizSayacRiskli.
  ///
  /// In tr, this message translates to:
  /// **'Riskli'**
  String get hatAnalizSayacRiskli;

  /// No description provided for @hatAnalizSayacTakip.
  ///
  /// In tr, this message translates to:
  /// **'Takip'**
  String get hatAnalizSayacTakip;

  /// No description provided for @hatAnalizSayacVeriAz.
  ///
  /// In tr, this message translates to:
  /// **'Veri Az'**
  String get hatAnalizSayacVeriAz;

  /// No description provided for @karsilastirmaSecimMinKoloni.
  ///
  /// In tr, this message translates to:
  /// **'Karşılaştırma için en az 2 koloni seçmelisin.'**
  String get karsilastirmaSecimMinKoloni;

  /// No description provided for @karsilastirmaSecimMaxKoloni.
  ///
  /// In tr, this message translates to:
  /// **'En fazla 3 koloni seçebilirsin.'**
  String get karsilastirmaSecimMaxKoloni;

  /// No description provided for @karsilastirmaSecimAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Karşılaştırma en fazla 3 koloni ile yapılır. Sistem genel performans ile genetik seçilim farkını aynı tabloda görünür hale getirmeye çalışır.'**
  String get karsilastirmaSecimAciklama;

  /// No description provided for @karsilastirmaSecimSkor.
  ///
  /// In tr, this message translates to:
  /// **'Skor'**
  String get karsilastirmaSecimSkor;

  /// No description provided for @karsilastirmaSecimSonCita.
  ///
  /// In tr, this message translates to:
  /// **'Son Çıta'**
  String get karsilastirmaSecimSonCita;

  /// No description provided for @karsilastirmaSecimBal.
  ///
  /// In tr, this message translates to:
  /// **'Bal'**
  String get karsilastirmaSecimBal;

  /// No description provided for @karsilastirmaSecimBekle.
  ///
  /// In tr, this message translates to:
  /// **'Hazırlanıyor...'**
  String get karsilastirmaSecimBekle;

  /// No description provided for @karsilastirmaSecimButon.
  ///
  /// In tr, this message translates to:
  /// **'Karşılaştır'**
  String get karsilastirmaSecimButon;

  /// No description provided for @karsilastirmaPerformansBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Karşılaştırmalı Analiz'**
  String get karsilastirmaPerformansBaslik;

  /// No description provided for @karsilastirmaSistemYorumuPerf.
  ///
  /// In tr, this message translates to:
  /// **'SİSTEM YORUMU (PERFORMANS + SEÇİLİM)'**
  String get karsilastirmaSistemYorumuPerf;

  /// No description provided for @karsilastirmaDonorDurumu.
  ///
  /// In tr, this message translates to:
  /// **'Donör Durumu'**
  String get karsilastirmaDonorDurumu;

  /// No description provided for @karsilastirmaUreme.
  ///
  /// In tr, this message translates to:
  /// **'Üreme'**
  String get karsilastirmaUreme;

  /// No description provided for @karsilastirmaUretim.
  ///
  /// In tr, this message translates to:
  /// **'Üretim'**
  String get karsilastirmaUretim;

  /// No description provided for @karsilastirmaDayaniklilik.
  ///
  /// In tr, this message translates to:
  /// **'Dayanıklılık'**
  String get karsilastirmaDayaniklilik;

  /// No description provided for @karsilastirmaKisCikisi.
  ///
  /// In tr, this message translates to:
  /// **'Kış Çıkışı'**
  String get karsilastirmaKisCikisi;

  /// No description provided for @karsilastirmaHatGucu.
  ///
  /// In tr, this message translates to:
  /// **'Hat Gücü'**
  String get karsilastirmaHatGucu;

  /// No description provided for @karsilastirmaDavranis.
  ///
  /// In tr, this message translates to:
  /// **'Davranış'**
  String get karsilastirmaDavranis;

  /// No description provided for @karsilastirmaVeriGuveni.
  ///
  /// In tr, this message translates to:
  /// **'Veri Güveni'**
  String get karsilastirmaVeriGuveni;

  /// No description provided for @karsilastirmaOgulDurumu.
  ///
  /// In tr, this message translates to:
  /// **'Oğul Durumu'**
  String get karsilastirmaOgulDurumu;

  /// No description provided for @kolonilerBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Koloniler'**
  String get kolonilerBaslik;

  /// No description provided for @kolonilerDonorHazirlaniyor.
  ///
  /// In tr, this message translates to:
  /// **'Koloniler • Donör rozetleri hazırlanıyor'**
  String get kolonilerDonorHazirlaniyor;

  /// No description provided for @kolonilerSeciliSayi.
  ///
  /// In tr, this message translates to:
  /// **'{sayi} koloni seçildi'**
  String kolonilerSeciliSayi(int sayi);

  /// No description provided for @kolonilerAktifSekme.
  ///
  /// In tr, this message translates to:
  /// **'AKTİF ({sayi})'**
  String kolonilerAktifSekme(int sayi);

  /// No description provided for @kolonilerSonmusSekme.
  ///
  /// In tr, this message translates to:
  /// **'SÖNMÜŞ ({sayi})'**
  String kolonilerSonmusSekme(int sayi);

  /// No description provided for @kolonilerKarsilastirmaModuSadece.
  ///
  /// In tr, this message translates to:
  /// **'Karşılaştırma modu yalnızca aktif koloniler için kullanılabilir.'**
  String get kolonilerKarsilastirmaModuSadece;

  /// No description provided for @kolonilerDuzenleBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Koloniyi Düzenle'**
  String get kolonilerDuzenleBaslik;

  /// No description provided for @kolonilerDuzenleOnay.
  ///
  /// In tr, this message translates to:
  /// **'{kovanNo} numaralı koloni için düzenleme ekranı açılsın mı?'**
  String kolonilerDuzenleOnay(String kovanNo);

  /// No description provided for @kolonilerDevamEt.
  ///
  /// In tr, this message translates to:
  /// **'Devam Et'**
  String get kolonilerDevamEt;

  /// No description provided for @kolonilerSilBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Koloniyi Sil'**
  String get kolonilerSilBaslik;

  /// No description provided for @kolonilerSilOnay.
  ///
  /// In tr, this message translates to:
  /// **'{kovanNo} numaralı koloni silinsin mi?\n\nBu işlem geri alınamaz. İlgili numara geçmişi ve olay kayıtları da silinir.'**
  String kolonilerSilOnay(String kovanNo);

  /// No description provided for @kolonilerSilindi.
  ///
  /// In tr, this message translates to:
  /// **'{kovanNo} numaralı koloni silindi.'**
  String kolonilerSilindi(String kovanNo);

  /// No description provided for @kolonilerSilHata.
  ///
  /// In tr, this message translates to:
  /// **'Koloni silinirken hata oluştu: {hata}'**
  String kolonilerSilHata(String hata);

  /// No description provided for @kolonilerAktifBos.
  ///
  /// In tr, this message translates to:
  /// **'Bu arılıkta aktif koloni kaydı yok.'**
  String get kolonilerAktifBos;

  /// No description provided for @kolonilerSonmusBos.
  ///
  /// In tr, this message translates to:
  /// **'Bu arılıkta sönmüş koloni kaydı yok.'**
  String get kolonilerSonmusBos;

  /// No description provided for @kolonilerKovanAra.
  ///
  /// In tr, this message translates to:
  /// **'Kovan ara...'**
  String get kolonilerKovanAra;

  /// No description provided for @kolonilerAramaTemizle.
  ///
  /// In tr, this message translates to:
  /// **'Aramayı temizle'**
  String get kolonilerAramaTemizle;

  /// No description provided for @kolonilerFiltreYeniBolme.
  ///
  /// In tr, this message translates to:
  /// **'Yeni bölmeler'**
  String get kolonilerFiltreYeniBolme;

  /// No description provided for @kolonilerFiltreYeniOgul.
  ///
  /// In tr, this message translates to:
  /// **'Yeni oğullar'**
  String get kolonilerFiltreYeniOgul;

  /// No description provided for @kolonilerFiltreAlarm.
  ///
  /// In tr, this message translates to:
  /// **'Alarm'**
  String get kolonilerFiltreAlarm;

  /// No description provided for @kolonilerFiltreYavruYok.
  ///
  /// In tr, this message translates to:
  /// **'Yavru yok'**
  String get kolonilerFiltreYavruYok;

  /// No description provided for @kolonilerFiltreHasat.
  ///
  /// In tr, this message translates to:
  /// **'Hasat adayı'**
  String get kolonilerFiltreHasat;

  /// No description provided for @kolonilerDonorRozetAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Rozetler: 1/2/3 ilk donör adaylarını, D donör havuzundaki diğer adayları gösterir. Genetik veto varsa detay ekranında ayrıca açıklanır.'**
  String get kolonilerDonorRozetAciklama;

  /// No description provided for @kolonilerKarsilastirmaModuBaslik.
  ///
  /// In tr, this message translates to:
  /// **'KARŞILAŞTIRMA MODU'**
  String get kolonilerKarsilastirmaModuBaslik;

  /// No description provided for @kolonilerKarsilastirmaModuInfo.
  ///
  /// In tr, this message translates to:
  /// **'Karşılaştırmak istediğiniz 2 veya 3 aktif koloniye dokunun. Bu mod açıkken koloni detayı yerine seçim yapılır.'**
  String get kolonilerKarsilastirmaModuInfo;

  /// No description provided for @kolonilerSeciliKoloniSayisi.
  ///
  /// In tr, this message translates to:
  /// **'Seçili koloni: {sayi} / 3'**
  String kolonilerSeciliKoloniSayisi(int sayi);

  /// No description provided for @kolonilerKarsilastirButon.
  ///
  /// In tr, this message translates to:
  /// **'Karşılaştır ({sayi})'**
  String kolonilerKarsilastirButon(int sayi);

  /// No description provided for @kolonilerPasif.
  ///
  /// In tr, this message translates to:
  /// **'PASİF'**
  String get kolonilerPasif;

  /// No description provided for @kolonilerSondu.
  ///
  /// In tr, this message translates to:
  /// **'SÖNDÜ'**
  String get kolonilerSondu;

  /// No description provided for @kolonilerSonCita.
  ///
  /// In tr, this message translates to:
  /// **'{cita} çıta'**
  String kolonilerSonCita(int cita);

  /// No description provided for @raporlarSayfaBaslik.
  ///
  /// In tr, this message translates to:
  /// **'RAPORLAR'**
  String get raporlarSayfaBaslik;

  /// No description provided for @raporlarArilikEtiketi.
  ///
  /// In tr, this message translates to:
  /// **'Arılık:'**
  String get raporlarArilikEtiketi;

  /// No description provided for @raporlarArilikBulunamadi.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı arılık bulunamadı.'**
  String get raporlarArilikBulunamadi;

  /// No description provided for @raporlarArilikSec.
  ///
  /// In tr, this message translates to:
  /// **'Rapor alınacak arılığı seç'**
  String get raporlarArilikSec;

  /// No description provided for @raporlarGenelDurum.
  ///
  /// In tr, this message translates to:
  /// **'GENEL DURUM'**
  String get raporlarGenelDurum;

  /// No description provided for @raporlarAktifKovan.
  ///
  /// In tr, this message translates to:
  /// **'Aktif kovan'**
  String get raporlarAktifKovan;

  /// No description provided for @raporlarOrtaSkor.
  ///
  /// In tr, this message translates to:
  /// **'Orta skor'**
  String get raporlarOrtaSkor;

  /// No description provided for @raporlarAriliCita.
  ///
  /// In tr, this message translates to:
  /// **'Arılı çıta'**
  String get raporlarAriliCita;

  /// No description provided for @raporlarDonorler.
  ///
  /// In tr, this message translates to:
  /// **'DONÖRLER'**
  String get raporlarDonorler;

  /// No description provided for @raporlarHesaplaniyor.
  ///
  /// In tr, this message translates to:
  /// **'Hesaplanıyor'**
  String get raporlarHesaplaniyor;

  /// No description provided for @raporlarHenuzYok.
  ///
  /// In tr, this message translates to:
  /// **'Henüz yok'**
  String get raporlarHenuzYok;

  /// No description provided for @raporlarIlkUcGuclu.
  ///
  /// In tr, this message translates to:
  /// **'İLK 3 GÜÇLÜ'**
  String get raporlarIlkUcGuclu;

  /// No description provided for @raporlarRaporSec.
  ///
  /// In tr, this message translates to:
  /// **'RAPOR SEÇ'**
  String get raporlarRaporSec;

  /// No description provided for @raporlarListeLazyAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Ağır liste hesapları ilk açılışta çalışmaz. Sadece görmek istediğin liste açıldığında yüklenir.'**
  String get raporlarListeLazyAciklama;

  /// No description provided for @raporlarGucludenZayifaBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Güçlüden Zayıfa'**
  String get raporlarGucludenZayifaBaslik;

  /// No description provided for @raporlarGucludenZayifaAlt.
  ///
  /// In tr, this message translates to:
  /// **'Tüm aktif koloniler yüksek skordan düşüğe sıralanır.'**
  String get raporlarGucludenZayifaAlt;

  /// No description provided for @raporlarGucludenZayifaListeBaslik.
  ///
  /// In tr, this message translates to:
  /// **'GÜÇLÜDEN ZAYIFA'**
  String get raporlarGucludenZayifaListeBaslik;

  /// No description provided for @raporlarZayiftanGucluye.
  ///
  /// In tr, this message translates to:
  /// **'Zayıftan Güçlüye'**
  String get raporlarZayiftanGucluye;

  /// No description provided for @raporlarZayiftanGucluAlt.
  ///
  /// In tr, this message translates to:
  /// **'Tüm aktif koloniler düşük skordan yükseğe sıralanır.'**
  String get raporlarZayiftanGucluAlt;

  /// No description provided for @raporlarZayiftanGucluListeBaslik.
  ///
  /// In tr, this message translates to:
  /// **'ZAYIFTAN GÜÇLÜYE'**
  String get raporlarZayiftanGucluListeBaslik;

  /// No description provided for @raporlarDonorAdaylariBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Donör Adayları'**
  String get raporlarDonorAdaylariBaslik;

  /// No description provided for @raporlarDonorAdaylariAlt.
  ///
  /// In tr, this message translates to:
  /// **'1. sıradan başlayarak donör havuzu listelenir.'**
  String get raporlarDonorAdaylariAlt;

  /// No description provided for @raporlarDonorAdaylariListeBaslik.
  ///
  /// In tr, this message translates to:
  /// **'DONÖR ADAYLARI'**
  String get raporlarDonorAdaylariListeBaslik;

  /// No description provided for @raporlarGenetikVetoBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Genetik Veto'**
  String get raporlarGenetikVetoBaslik;

  /// No description provided for @raporlarGenetikVetoAlt.
  ///
  /// In tr, this message translates to:
  /// **'Donör dışı kalan veto kayıtları kendi içinde sıralanır.'**
  String get raporlarGenetikVetoAlt;

  /// No description provided for @raporlarGenetikVetoListeBaslik.
  ///
  /// In tr, this message translates to:
  /// **'GENETİK VETO'**
  String get raporlarGenetikVetoListeBaslik;

  /// No description provided for @raporlarEkonomikDegerBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Ekonomik Değer'**
  String get raporlarEkonomikDegerBaslik;

  /// No description provided for @raporlarEkonomikDegerAlt.
  ///
  /// In tr, this message translates to:
  /// **'Arılık ekonomik değeri ve bal potansiyeli ayrı ekranda hesaplanır.'**
  String get raporlarEkonomikDegerAlt;

  /// No description provided for @raporlarIstatistikHesapla.
  ///
  /// In tr, this message translates to:
  /// **'Arılık istatistiklerini hesapla'**
  String get raporlarIstatistikHesapla;

  /// No description provided for @raporlarIstatistikHesaplaniyor.
  ///
  /// In tr, this message translates to:
  /// **'Arılık istatistikleri hesaplanıyor...'**
  String get raporlarIstatistikHesaplaniyor;

  /// No description provided for @raporlarIstatistikHata.
  ///
  /// In tr, this message translates to:
  /// **'Arılık istatistikleri hesaplanamadı: {hata}'**
  String raporlarIstatistikHata(String hata);

  /// No description provided for @raporlarTekrarHesapla.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar hesapla'**
  String get raporlarTekrarHesapla;

  /// No description provided for @raporlarArilikIstatistikleri.
  ///
  /// In tr, this message translates to:
  /// **'ARILIK İSTATİSTİKLERİ'**
  String get raporlarArilikIstatistikleri;

  /// No description provided for @raporlarToplamCita.
  ///
  /// In tr, this message translates to:
  /// **'Toplam çıta'**
  String get raporlarToplamCita;

  /// No description provided for @raporlarBalTemasi.
  ///
  /// In tr, this message translates to:
  /// **'Bal temaslı'**
  String get raporlarBalTemasi;

  /// No description provided for @raporlarAktivasyonFarki.
  ///
  /// In tr, this message translates to:
  /// **'Aktivasyon'**
  String get raporlarAktivasyonFarki;

  /// No description provided for @raporlarTahminiAri.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini arı'**
  String get raporlarTahminiAri;

  /// No description provided for @raporlarGuclu.
  ///
  /// In tr, this message translates to:
  /// **'Güçlü'**
  String get raporlarGuclu;

  /// No description provided for @raporlarOrta.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get raporlarOrta;

  /// No description provided for @raporlarZayif.
  ///
  /// In tr, this message translates to:
  /// **'Zayıf'**
  String get raporlarZayif;

  /// No description provided for @ekDegerAppBarBaslik.
  ///
  /// In tr, this message translates to:
  /// **'{arilikAd} EKONOMİK DEĞER'**
  String ekDegerAppBarBaslik(String arilikAd);

  /// No description provided for @ekDegerHata.
  ///
  /// In tr, this message translates to:
  /// **'Ekonomik değer hesaplanamadı:\n{hata}'**
  String ekDegerHata(String hata);

  /// No description provided for @ekDegerKartBaslik.
  ///
  /// In tr, this message translates to:
  /// **'EKONOMİK DEĞER'**
  String get ekDegerKartBaslik;

  /// No description provided for @ekDegerTahminiToplam.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini toplam değer: {deger} TL'**
  String ekDegerTahminiToplam(String deger);

  /// No description provided for @ekDegerAktivasyonluBalliCita.
  ///
  /// In tr, this message translates to:
  /// **'Aktivasyonlu ballı çıta: {cita} çıta'**
  String ekDegerAktivasyonluBalliCita(String cita);

  /// No description provided for @ekDegerTahminiBalAraligi.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini bal: {minKg}–{maxKg} kg / {minTL}–{maxTL} TL'**
  String ekDegerTahminiBalAraligi(
      String minKg, String maxKg, String minTL, String maxTL);

  /// No description provided for @ekDegerHesapAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Bu hesap biyolojik modelde bal/ballık pozisyonunda görünen çıtaları aktivasyon düzeyiyle okur; boş çıta, toplam fiziksel çıta veya boş kabarmış petek bal gibi sayılmaz.'**
  String get ekDegerHesapAciklama;

  /// No description provided for @ekDegerBalFiyati.
  ///
  /// In tr, this message translates to:
  /// **'Bal satış fiyatı (kg/TL)'**
  String get ekDegerBalFiyati;

  /// No description provided for @ekDegerAriliCita.
  ///
  /// In tr, this message translates to:
  /// **'Arılı çıta değeri'**
  String get ekDegerAriliCita;

  /// No description provided for @ekDegerBosKovan.
  ///
  /// In tr, this message translates to:
  /// **'Boş kovan değeri'**
  String get ekDegerBosKovan;

  /// No description provided for @ekDegerBosKabarmisPetek.
  ///
  /// In tr, this message translates to:
  /// **'Boş kabarmış petek adedi'**
  String get ekDegerBosKabarmisPetek;

  /// No description provided for @ekDegerBosKabarmisPetekBirim.
  ///
  /// In tr, this message translates to:
  /// **'Boş kabarmış petek birim değeri'**
  String get ekDegerBosKabarmisPetekBirim;

  /// No description provided for @koloniDetayMuayeneSil.
  ///
  /// In tr, this message translates to:
  /// **'Muayene Sil'**
  String get koloniDetayMuayeneSil;

  /// No description provided for @koloniDetayMuayeneSilOnay.
  ///
  /// In tr, this message translates to:
  /// **'{tarih} tarihli muayene silinsin mi?\n\nBu işlem geri alınamaz.'**
  String koloniDetayMuayeneSilOnay(String tarih);

  /// No description provided for @koloniDetayMuayeneSilindi.
  ///
  /// In tr, this message translates to:
  /// **'Muayene silindi.'**
  String get koloniDetayMuayeneSilindi;

  /// No description provided for @koloniDetayNumaraDegistir.
  ///
  /// In tr, this message translates to:
  /// **'Koloni Numarasını Değiştir'**
  String get koloniDetayNumaraDegistir;

  /// No description provided for @koloniDetayNumaraAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem koloninin saha numarasını değiştirir. Soy bağı ve muayene geçmişi korunur.'**
  String get koloniDetayNumaraAciklama;

  /// No description provided for @koloniDetayYeniNumara.
  ///
  /// In tr, this message translates to:
  /// **'Yeni koloni / kovan numarası'**
  String get koloniDetayYeniNumara;

  /// No description provided for @koloniDetayNumaraGuncellendi.
  ///
  /// In tr, this message translates to:
  /// **'Koloni numarası {no} olarak güncellendi.'**
  String koloniDetayNumaraGuncellendi(String no);

  /// No description provided for @koloniDetayAppBarBaslik.
  ///
  /// In tr, this message translates to:
  /// **'KOVAN {no}'**
  String koloniDetayAppBarBaslik(String no);

  /// No description provided for @koloniDetayTabGenelDurum.
  ///
  /// In tr, this message translates to:
  /// **'GENEL DURUM'**
  String get koloniDetayTabGenelDurum;

  /// No description provided for @koloniDetayTabMuayeneler.
  ///
  /// In tr, this message translates to:
  /// **'MUAYENELER'**
  String get koloniDetayTabMuayeneler;

  /// No description provided for @koloniDetayTabBiyolojikModel.
  ///
  /// In tr, this message translates to:
  /// **'BİYOLOJİK MODEL'**
  String get koloniDetayTabBiyolojikModel;

  /// No description provided for @koloniDetayTabPerformans.
  ///
  /// In tr, this message translates to:
  /// **'PERFORMANS'**
  String get koloniDetayTabPerformans;

  /// No description provided for @koloniDetayMuayeneEkle.
  ///
  /// In tr, this message translates to:
  /// **'Muayene Ekle'**
  String get koloniDetayMuayeneEkle;

  /// No description provided for @koloniDetayOzetSurec.
  ///
  /// In tr, this message translates to:
  /// **'SÜREÇ'**
  String get koloniDetayOzetSurec;

  /// No description provided for @koloniDetayOzetBiyoloji.
  ///
  /// In tr, this message translates to:
  /// **'BİYOLOJİ'**
  String get koloniDetayOzetBiyoloji;

  /// No description provided for @koloniDetayOzetYonetim.
  ///
  /// In tr, this message translates to:
  /// **'YÖNETİM'**
  String get koloniDetayOzetYonetim;

  /// No description provided for @koloniDetayOzetGenetik.
  ///
  /// In tr, this message translates to:
  /// **'GENETİK'**
  String get koloniDetayOzetGenetik;

  /// No description provided for @koloniDetayPerfVeriBulunamadi.
  ///
  /// In tr, this message translates to:
  /// **'Performans özeti verisi bulunamadı.'**
  String get koloniDetayPerfVeriBulunamadi;

  /// No description provided for @ayarlarBaslik.
  ///
  /// In tr, this message translates to:
  /// **'AYARLAR VE KALİBRASYON'**
  String get ayarlarBaslik;

  /// No description provided for @ayarlarTabGenel.
  ///
  /// In tr, this message translates to:
  /// **'GENEL'**
  String get ayarlarTabGenel;

  /// No description provided for @ayarlarTabSistem.
  ///
  /// In tr, this message translates to:
  /// **'SİSTEM'**
  String get ayarlarTabSistem;

  /// No description provided for @ayarlarKaydediliyor.
  ///
  /// In tr, this message translates to:
  /// **'KAYDEDİLİYOR...'**
  String get ayarlarKaydediliyor;

  /// No description provided for @ayarlarKaydet.
  ///
  /// In tr, this message translates to:
  /// **'GENEL AYARLARI KAYDET'**
  String get ayarlarKaydet;

  /// No description provided for @ayarlarKaydedilemedi.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar kaydedilemedi: {hata}'**
  String ayarlarKaydedilemedi(String hata);

  /// No description provided for @ayarlarYedekHazir.
  ///
  /// In tr, this message translates to:
  /// **'Yedek hazırlandı. Güvenli bir yere kaydet.'**
  String get ayarlarYedekHazir;

  /// No description provided for @ayarlarYedekHata.
  ///
  /// In tr, this message translates to:
  /// **'Yedek alınırken hata oluştu: {hata}'**
  String ayarlarYedekHata(String hata);

  /// No description provided for @ayarlarGeriYukleBaslik.
  ///
  /// In tr, this message translates to:
  /// **'YEDEKTEN GERİ YÜKLE'**
  String get ayarlarGeriYukleBaslik;

  /// No description provided for @ayarlarGeriYukleButon.
  ///
  /// In tr, this message translates to:
  /// **'Yüklemeyi Başlat'**
  String get ayarlarGeriYukleButon;

  /// No description provided for @ayarlarGeriYukleTamamlandi.
  ///
  /// In tr, this message translates to:
  /// **'Yedekten geri yükleme tamamlandı.'**
  String get ayarlarGeriYukleTamamlandi;

  /// No description provided for @ayarlarGeriYukleHata.
  ///
  /// In tr, this message translates to:
  /// **'Yedek yüklenirken hata oluştu: {hata}'**
  String ayarlarGeriYukleHata(String hata);

  /// No description provided for @ayarlarGuncellemHata.
  ///
  /// In tr, this message translates to:
  /// **'Güncelleme kontrolü başarısız: {hata}'**
  String ayarlarGuncellemHata(String hata);

  /// No description provided for @ayarlarKalibrasyonTamam.
  ///
  /// In tr, this message translates to:
  /// **'Arılık kalibrasyonu tanımlı. Sistem sezon ve bal akımı bağlamını kullanabilir.'**
  String get ayarlarKalibrasyonTamam;

  /// No description provided for @ayarlarKalibrasyonEksik.
  ///
  /// In tr, this message translates to:
  /// **'Arılık kalibrasyonu eksik. Sezon ve bal akımı tanımları gözden geçirilmeli.'**
  String get ayarlarKalibrasyonEksik;

  /// No description provided for @ayarlarTarihFormatNotu.
  ///
  /// In tr, this message translates to:
  /// **'Tarih gösterimi gün/ay formatındadır; kayıt formatı sistem içinde korunur.'**
  String get ayarlarTarihFormatNotu;

  /// No description provided for @ayarlarBaslangicTarih.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç: {tarih}'**
  String ayarlarBaslangicTarih(String tarih);

  /// No description provided for @ayarlarBitisTarih.
  ///
  /// In tr, this message translates to:
  /// **'Bitiş: {tarih}'**
  String ayarlarBitisTarih(String tarih);

  /// No description provided for @ayarlarDavranisTercihi.
  ///
  /// In tr, this message translates to:
  /// **'DAVRANIŞ TERCİHİ'**
  String get ayarlarDavranisTercihi;

  /// No description provided for @ayarlarDavranisTercihiAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Bu ayar yalnızca genetik seçilim ve donör filtresi tarafını etkiler. Çekirdek eşikleri değiştirmez.'**
  String get ayarlarDavranisTercihiAciklama;

  /// No description provided for @ayarlarDavranisStandart.
  ///
  /// In tr, this message translates to:
  /// **'Standart'**
  String get ayarlarDavranisStandart;

  /// No description provided for @ayarlarDavranisStandartAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Yönetilebilir koloniler önceliklidir. Hırçınlık seçilim tarafında daha belirgin eksidir.'**
  String get ayarlarDavranisStandartAciklama;

  /// No description provided for @ayarlarDavranisEsnek.
  ///
  /// In tr, this message translates to:
  /// **'Esnek'**
  String get ayarlarDavranisEsnek;

  /// No description provided for @ayarlarDavranisEsnekAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Güç ve verim öne çıkıyorsa davranış verisi seçilim tarafında daha yumuşak yorumlanır.'**
  String get ayarlarDavranisEsnekAciklama;

  /// No description provided for @ayarlarKalibrasyonKapsami.
  ///
  /// In tr, this message translates to:
  /// **'KALİBRASYON KAPSAMI'**
  String get ayarlarKalibrasyonKapsami;

  /// No description provided for @ayarlarKalibrasyonKapsamiAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı ve genel risk takvimi bu kapsama göre kaydedilir. Tüm arılıklar seçilirse genel varsayılanlar güncellenir. Tek arılık seçilirse yalnızca o arılık için özel kalibrasyon oluşturulur.'**
  String get ayarlarKalibrasyonKapsamiAciklama;

  /// No description provided for @ayarlarKalibrasyonLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bu kalibrasyonu kullan'**
  String get ayarlarKalibrasyonLabel;

  /// No description provided for @ayarlarKalibrasyonTumAriliklar.
  ///
  /// In tr, this message translates to:
  /// **'Tüm arılıklar için kullan'**
  String get ayarlarKalibrasyonTumAriliklar;

  /// No description provided for @ayarlarKalibrasyonYalnizca.
  ///
  /// In tr, this message translates to:
  /// **'Yalnızca {ad} arılığı için kullan'**
  String ayarlarKalibrasyonYalnizca(String ad);

  /// No description provided for @ayarlarKalibrasyonGenelAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Şu anda genel varsayılan kalibrasyonu düzenliyorsun. Özel ayarı olmayan tüm arılıklar bunu kullanır.'**
  String get ayarlarKalibrasyonGenelAciklama;

  /// No description provided for @ayarlarKalibrasyonOzelAciklama.
  ///
  /// In tr, this message translates to:
  /// **'{kapsam} için özel kalibrasyon alanı açık. Burada yaptığın bal akımı ve risk takvimi değişiklikleri diğer arılıkları etkilemez.'**
  String ayarlarKalibrasyonOzelAciklama(String kapsam);

  /// No description provided for @ayarlarBalAkimiBilgi.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı pencereleri biyolojik geri sayımların temel referansıdır. İlk pencere zorunlu, ikinci pencere ise sadece gerçekten ihtiyaç varsa açık tutulur.'**
  String get ayarlarBalAkimiBilgi;

  /// No description provided for @ayarlarIkinciBalAkimi.
  ///
  /// In tr, this message translates to:
  /// **'2. bal akımını kullan'**
  String get ayarlarIkinciBalAkimi;

  /// No description provided for @ayarlarIkinciBalAkimiAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Ağustos / Eylül çam balı. İhtiyacın yoksa kapalı bırak.'**
  String get ayarlarIkinciBalAkimiAciklama;

  /// No description provided for @ayarlarRiskTakvimiBilgi.
  ///
  /// In tr, this message translates to:
  /// **'Genel risk takvimi koloniye özel karar üretmez. Arı kuşu, eşek arısı, yağmacılık, mum güvesi ve fare gibi dönemsel riskleri arılık ekranında hatırlatır. Tarihleri kendi bölgenin gerçek baskı dönemine göre daraltabilirsin.'**
  String get ayarlarRiskTakvimiBilgi;

  /// No description provided for @ayarlarAriKusuDonemi.
  ///
  /// In tr, this message translates to:
  /// **'Arı Kuşu Risk Dönemi'**
  String get ayarlarAriKusuDonemi;

  /// No description provided for @ayarlarAriKusuAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Varsayılan: Mayıs – Ağustos. Kendi bölgenin göç ve baskı dönemine göre daraltabilirsin.'**
  String get ayarlarAriKusuAciklama;

  /// No description provided for @ayarlarEsekArisiDonemi.
  ///
  /// In tr, this message translates to:
  /// **'Eşek Arısı / Sarıca Risk Dönemi'**
  String get ayarlarEsekArisiDonemi;

  /// No description provided for @ayarlarEsekArisiAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Varsayılan: Temmuz – Ekim. Baskının yoğunlaştığı döneme göre ayarla.'**
  String get ayarlarEsekArisiAciklama;

  /// No description provided for @ayarlarYagmacilikDonemi.
  ///
  /// In tr, this message translates to:
  /// **'Yağmacılık Risk Dönemi'**
  String get ayarlarYagmacilikDonemi;

  /// No description provided for @ayarlarYagmacilikAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Varsayılan: Temmuz – Eylül. Hasat sonrası ve kurak dönem baskısına göre ayarla.'**
  String get ayarlarYagmacilikAciklama;

  /// No description provided for @ayarlarMumGuvesiDonemi.
  ///
  /// In tr, this message translates to:
  /// **'Mum Güvesi Risk Dönemi'**
  String get ayarlarMumGuvesiDonemi;

  /// No description provided for @ayarlarMumGuvesiAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Varsayılan: Haziran – Eylül. Sıcak dönem ve zayıf koloni riskine göre ayarla.'**
  String get ayarlarMumGuvesiAciklama;

  /// No description provided for @ayarlarFareDonemi.
  ///
  /// In tr, this message translates to:
  /// **'Fare Risk Dönemi'**
  String get ayarlarFareDonemi;

  /// No description provided for @ayarlarFareAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Varsayılan: Kasım – Şubat. Bu aralık yıl taşar; sistem bunu doğru yorumlar.'**
  String get ayarlarFareAciklama;

  /// No description provided for @ayarlarKisDonemi.
  ///
  /// In tr, this message translates to:
  /// **'Kış / Dayanıklılık Dönemi'**
  String get ayarlarKisDonemi;

  /// No description provided for @ayarlarKisAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Varsayılan yapı 1 Eylül – 15 Marttır. Gerekirse sahana göre ince ayar yap.'**
  String get ayarlarKisAciklama;

  /// No description provided for @ayarlarUretimDonemi.
  ///
  /// In tr, this message translates to:
  /// **'Aktif / Üretim Dönemi'**
  String get ayarlarUretimDonemi;

  /// No description provided for @ayarlarUretimAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Varsayılan yapı 15 Mart – 31 Ağustostur. Gerekirse sahana göre ince ayar yap.'**
  String get ayarlarUretimAciklama;

  /// No description provided for @ayarlarBalAkimiAraligi1.
  ///
  /// In tr, this message translates to:
  /// **'Bal Akımı Aralığı 1'**
  String get ayarlarBalAkimiAraligi1;

  /// No description provided for @ayarlarBalAkimiAraligi1Aciklama.
  ///
  /// In tr, this message translates to:
  /// **'İlk ana akım. Örn: Mayıs sonu / Haziran başı.'**
  String get ayarlarBalAkimiAraligi1Aciklama;

  /// No description provided for @ayarlarBalAkimiAraligi2.
  ///
  /// In tr, this message translates to:
  /// **'Bal Akımı Aralığı 2'**
  String get ayarlarBalAkimiAraligi2;

  /// No description provided for @ayarlarBalAkimiAraligi2Aciklama.
  ///
  /// In tr, this message translates to:
  /// **'İkinci akım. Örn: Ağustos / Eylül çam balı.'**
  String get ayarlarBalAkimiAraligi2Aciklama;

  /// No description provided for @ayarlarRehberiAc.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı rehberini aç'**
  String get ayarlarRehberiAc;

  /// No description provided for @ayarlarSistemBilgi.
  ///
  /// In tr, this message translates to:
  /// **'Yedek alma ve geri yükleme akışı sistemde tutulur. Geri yükleme sonrası bakım adımı çalıştırılır ve karar önbelleği temizlenir.'**
  String get ayarlarSistemBilgi;

  /// No description provided for @ayarlarUygulamaKimligi.
  ///
  /// In tr, this message translates to:
  /// **'UYGULAMA KİMLİĞİ'**
  String get ayarlarUygulamaKimligi;

  /// No description provided for @ayarlarKimlikUygulama.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama'**
  String get ayarlarKimlikUygulama;

  /// No description provided for @ayarlarKimlikTanim.
  ///
  /// In tr, this message translates to:
  /// **'Tanım'**
  String get ayarlarKimlikTanim;

  /// No description provided for @ayarlarKimlikSurum.
  ///
  /// In tr, this message translates to:
  /// **'Sürüm'**
  String get ayarlarKimlikSurum;

  /// No description provided for @ayarlarKimlikYil.
  ///
  /// In tr, this message translates to:
  /// **'Yıl'**
  String get ayarlarKimlikYil;

  /// No description provided for @ayarlarKimlikUretici.
  ///
  /// In tr, this message translates to:
  /// **'Üretici'**
  String get ayarlarKimlikUretici;

  /// No description provided for @ayarlarKimlikVeri.
  ///
  /// In tr, this message translates to:
  /// **'Veri'**
  String get ayarlarKimlikVeri;

  /// No description provided for @ayarlarKimlikSistemAmaci.
  ///
  /// In tr, this message translates to:
  /// **'Sistem amacı: basit saha verisini zaman, olay ve süreç mantığıyla okuyarak uygulanabilir koloni kararı üretmek.'**
  String get ayarlarKimlikSistemAmaci;

  /// No description provided for @ayarlarSurumYukleniyor.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor'**
  String get ayarlarSurumYukleniyor;

  /// No description provided for @ayarlarYedekAl.
  ///
  /// In tr, this message translates to:
  /// **'Yedek Al'**
  String get ayarlarYedekAl;

  /// No description provided for @ayarlarYedekAlAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Tüm veriyi JSON yedek dosyası olarak oluştur ve paylaş.'**
  String get ayarlarYedekAlAciklama;

  /// No description provided for @ayarlarYedekYukle.
  ///
  /// In tr, this message translates to:
  /// **'Yedekten Yükle'**
  String get ayarlarYedekYukle;

  /// No description provided for @ayarlarYedekYukleAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Daha önce aldığın JSON yedeğini seç ve mevcut verinin yerine yükle.'**
  String get ayarlarYedekYukleAciklama;

  /// No description provided for @ayarlarGuncelleKontrol.
  ///
  /// In tr, this message translates to:
  /// **'Güncellemeyi Kontrol Et'**
  String get ayarlarGuncelleKontrol;

  /// No description provided for @ayarlarGuncelleKontrolAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Yeni sürüm varsa önce yedek aldırır, ardından güvenli APK bağlantısını açar.'**
  String get ayarlarGuncelleKontrolAciklama;

  /// No description provided for @ayarlarYedekUyari.
  ///
  /// In tr, this message translates to:
  /// **'Yedekten yükleme mevcut veriyi tamamen değiştirir. Yüklemeden hemen önce yeni bir yedek almak en güvenli yaklaşımdır.'**
  String get ayarlarYedekUyari;

  /// No description provided for @ayarlarGizlilik.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik Politikası'**
  String get ayarlarGizlilik;

  /// No description provided for @ayarlarGizlilikAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama veri kullanımı ve gizlilik ilkelerini görüntüle.'**
  String get ayarlarGizlilikAciklama;

  /// No description provided for @ayarlarGelistirici.
  ///
  /// In tr, this message translates to:
  /// **'GELİŞTİRİCİ'**
  String get ayarlarGelistirici;

  /// No description provided for @ayarlarProMod.
  ///
  /// In tr, this message translates to:
  /// **'PRO mod (test)'**
  String get ayarlarProMod;

  /// No description provided for @ayarlarProModAciklama.
  ///
  /// In tr, this message translates to:
  /// **'PRO özellikleri kilit olmadan görüntüler.'**
  String get ayarlarProModAciklama;

  /// No description provided for @ayarlarDilTest.
  ///
  /// In tr, this message translates to:
  /// **'Dil (test)'**
  String get ayarlarDilTest;

  /// No description provided for @ayarlarDilAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Yalnızca lokalizasyon sistemine taşınan metinleri etkiler.'**
  String get ayarlarDilAciklama;

  /// No description provided for @ayarlarKaydedildi.
  ///
  /// In tr, this message translates to:
  /// **'Genel ayarlar tüm arılıklar için kaydedildi.'**
  String get ayarlarKaydedildi;

  /// No description provided for @ayarlarOzelKaydedildi.
  ///
  /// In tr, this message translates to:
  /// **'{kapsam} arılığı için özel kalibrasyon kaydedildi.'**
  String ayarlarOzelKaydedildi(String kapsam);

  /// No description provided for @ayarlarGeriYukleIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem mevcut veriyi seçtiğin yedek ile tamamen değiştirir. Devam etmeden önce güncel bir yedek alman önerilir. Şimdi yükleme başlasın mı?'**
  String get ayarlarGeriYukleIcerik;

  /// No description provided for @ayarlarUygulamaGuncel.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama güncel. Mevcut sürüm: {surum} ({kod})'**
  String ayarlarUygulamaGuncel(String surum, String kod);

  /// No description provided for @yeniKoloniBaslik.
  ///
  /// In tr, this message translates to:
  /// **'YENİ KOLONİ KAYDI'**
  String get yeniKoloniBaslik;

  /// No description provided for @yeniKoloniDuzenle.
  ///
  /// In tr, this message translates to:
  /// **'KOLONİ DÜZENLE'**
  String get yeniKoloniDuzenle;

  /// No description provided for @yeniKoloniGecmisTarihBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş tarih seçildi'**
  String get yeniKoloniGecmisTarihBaslik;

  /// No description provided for @yeniKoloniGecmisTarihIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Koloni başlangıç tarihini geriye çekiyorsun. Bu doğruysa devam et. Sistem, tarih arılık başlangıcı veya ilk muayene ile çelişirse kaydı engeller.'**
  String get yeniKoloniGecmisTarihIcerik;

  /// No description provided for @yeniKoloniEvetDegistir.
  ///
  /// In tr, this message translates to:
  /// **'Evet, değiştir'**
  String get yeniKoloniEvetDegistir;

  /// No description provided for @yeniKoloniKaynakBulunamadi.
  ///
  /// In tr, this message translates to:
  /// **'Seçilen kaynak koloni bu arılıkta bulunamadı. Lütfen listeden geçerli bir kaynak koloni seç.'**
  String get yeniKoloniKaynakBulunamadi;

  /// No description provided for @yeniKoloniKayitHata.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt sırasında teknik sorun oluştu: {hata}'**
  String yeniKoloniKayitHata(String hata);

  /// No description provided for @yeniKoloniBolumKaynakOlusumBilgisi.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak ve Oluşum Bilgisi'**
  String get yeniKoloniBolumKaynakOlusumBilgisi;

  /// No description provided for @yeniKoloniBolumSahaBilgileri.
  ///
  /// In tr, this message translates to:
  /// **'Temel Saha Bilgileri'**
  String get yeniKoloniBolumSahaBilgileri;

  /// No description provided for @yeniKoloniBolumNotlar.
  ///
  /// In tr, this message translates to:
  /// **'Notlar'**
  String get yeniKoloniBolumNotlar;

  /// No description provided for @yeniKoloniKaynakTipiLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak Tipi'**
  String get yeniKoloniKaynakTipiLabel;

  /// No description provided for @yeniKoloniKaynakAnaHat.
  ///
  /// In tr, this message translates to:
  /// **'Ana Hat'**
  String get yeniKoloniKaynakAnaHat;

  /// No description provided for @yeniKoloniKaynakBolme.
  ///
  /// In tr, this message translates to:
  /// **'Bölme'**
  String get yeniKoloniKaynakBolme;

  /// No description provided for @yeniKoloniKaynakOgul.
  ///
  /// In tr, this message translates to:
  /// **'Oğul'**
  String get yeniKoloniKaynakOgul;

  /// No description provided for @yeniKoloniKaynakBilgiAnaHat.
  ///
  /// In tr, this message translates to:
  /// **'Ana Hat seçildi. Kaynak koloni istenmez. Sistem bu koloniyi yeni kök hat olarak başlatır.'**
  String get yeniKoloniKaynakBilgiAnaHat;

  /// No description provided for @yeniKoloniKaynakBilgiBolme.
  ///
  /// In tr, this message translates to:
  /// **'Önce kaynak koloniyi seç, sonra yeni kovan numarasını gir. Sistem soy bağını buna göre kurar.'**
  String get yeniKoloniKaynakBilgiBolme;

  /// No description provided for @yeniKoloniKaynakBilgiOgul.
  ///
  /// In tr, this message translates to:
  /// **'Önce oğulun çıktığı kaynak koloniyi seç, sonra yeni kovan numarasını gir. Oğul hazır analı kabul edilir; ayrıca ana kazanma yöntemi seçilmez.'**
  String get yeniKoloniKaynakBilgiOgul;

  /// No description provided for @yeniKoloniKaynakBilgiVarsayilan.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak bilgisi sistem kimliği ve soy bağı için kullanılır.'**
  String get yeniKoloniKaynakBilgiVarsayilan;

  /// No description provided for @yeniKoloniAnaKazanmaLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ana Kazanma Yöntemi'**
  String get yeniKoloniAnaKazanmaLabel;

  /// No description provided for @yeniKoloniAnaKazanmaBilgiKapaliMeme.
  ///
  /// In tr, this message translates to:
  /// **'Takvim sıfırdan ana yapma gibi değil, kapalı meme aşamasından başlatılır. 5. gün meme bozma uyarısı verilmez.'**
  String get yeniKoloniAnaKazanmaBilgiKapaliMeme;

  /// No description provided for @yeniKoloniAnaKazanmaBilgiHazirAna.
  ///
  /// In tr, this message translates to:
  /// **'Meme takvimi çalışmaz. Sistem kabul ve yumurtlama kontrolü penceresine odaklanır.'**
  String get yeniKoloniAnaKazanmaBilgiHazirAna;

  /// No description provided for @yeniKoloniAnaKazanmaBilgiKendiAnasi.
  ///
  /// In tr, this message translates to:
  /// **'Takvim sıfırdan ana yapma süreciyle başlar. 5. gün kapalı meme kontrolü anlamlıdır.'**
  String get yeniKoloniAnaKazanmaBilgiKendiAnasi;

  /// No description provided for @yeniKoloniKaynakKoloniLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak Koloni'**
  String get yeniKoloniKaynakKoloniLabel;

  /// No description provided for @yeniKoloniDisKaynak.
  ///
  /// In tr, this message translates to:
  /// **'Dış Kaynak'**
  String get yeniKoloniDisKaynak;

  /// No description provided for @yeniKoloniKaynakKoloniValidasyon.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak koloni seçmelisin.'**
  String get yeniKoloniKaynakKoloniValidasyon;

  /// No description provided for @yeniKoloniKovanTipiLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kovan Tipi'**
  String get yeniKoloniKovanTipiLabel;

  /// No description provided for @yeniKoloniSurupluk.
  ///
  /// In tr, this message translates to:
  /// **'Şurupluk'**
  String get yeniKoloniSurupluk;

  /// No description provided for @yeniKoloniSuruplukVar.
  ///
  /// In tr, this message translates to:
  /// **'Alt kat 9 çıta'**
  String get yeniKoloniSuruplukVar;

  /// No description provided for @yeniKoloniSuruplukYok.
  ///
  /// In tr, this message translates to:
  /// **'Alt kat 10 çıta'**
  String get yeniKoloniSuruplukYok;

  /// No description provided for @yeniKoloniSuruplukBilgiVar.
  ///
  /// In tr, this message translates to:
  /// **'Şurupluk varsa sistem alt kuluçkalığı 9 çıta kabul eder; üstündeki çıtaları kat/ballık alanı olarak yorumlar.'**
  String get yeniKoloniSuruplukBilgiVar;

  /// No description provided for @yeniKoloniSuruplukBilgiYok.
  ///
  /// In tr, this message translates to:
  /// **'Şurupluk yoksa sistem alt kuluçkalığı 10 çıta kabul eder; üstündeki çıtaları kat/ballık alanı olarak yorumlar.'**
  String get yeniKoloniSuruplukBilgiYok;

  /// No description provided for @yeniKoloniBaslangicTarihi.
  ///
  /// In tr, this message translates to:
  /// **'Koloni başlangıç tarihi'**
  String get yeniKoloniBaslangicTarihi;

  /// No description provided for @yeniKoloniKovanNoLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kovan No / Saha Etiketi'**
  String get yeniKoloniKovanNoLabel;

  /// No description provided for @yeniKoloniAnaAriYili.
  ///
  /// In tr, this message translates to:
  /// **'Ana Arı Yılı'**
  String get yeniKoloniAnaAriYili;

  /// No description provided for @yeniKoloniSahaSirasi.
  ///
  /// In tr, this message translates to:
  /// **'Saha Sırası'**
  String get yeniKoloniSahaSirasi;

  /// No description provided for @yeniKoloniIlkCitaSayisi.
  ///
  /// In tr, this message translates to:
  /// **'İlk Toplam Çıta Sayısı'**
  String get yeniKoloniIlkCitaSayisi;

  /// No description provided for @yeniKoloniSahaBilgisiNot.
  ///
  /// In tr, this message translates to:
  /// **'Bu ekranda yalnızca saha bilgileri girilir. Sistem kimliği, ana soy hattı ve genetik hat kodu otomatik türetilir; koloni detayında bilgi olarak gösterilir.'**
  String get yeniKoloniSahaBilgisiNot;

  /// No description provided for @yeniKoloniOzelNotlar.
  ///
  /// In tr, this message translates to:
  /// **'Özel Notlar'**
  String get yeniKoloniOzelNotlar;

  /// No description provided for @yeniKoloniAlanZorunlu.
  ///
  /// In tr, this message translates to:
  /// **'Bu alan zorunlu.'**
  String get yeniKoloniAlanZorunlu;

  /// No description provided for @yeniKoloniSayiGir.
  ///
  /// In tr, this message translates to:
  /// **'Sayı gir.'**
  String get yeniKoloniSayiGir;

  /// No description provided for @yeniKoloniBilgileriKaydet.
  ///
  /// In tr, this message translates to:
  /// **'BİLGİLERİ KAYDET'**
  String get yeniKoloniBilgileriKaydet;

  /// No description provided for @arilikSecimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'ARILIK SEÇİMİ'**
  String get arilikSecimBaslik;

  /// No description provided for @arilikSecimRaporBaslik.
  ///
  /// In tr, this message translates to:
  /// **'RAPOR İÇİN ARILIK SEÇ'**
  String get arilikSecimRaporBaslik;

  /// No description provided for @arilikSecimBos.
  ///
  /// In tr, this message translates to:
  /// **'Henüz arılık eklenmemiş.'**
  String get arilikSecimBos;

  /// No description provided for @arilikSecimIlkEkle.
  ///
  /// In tr, this message translates to:
  /// **'İlk Arılığını Ekle'**
  String get arilikSecimIlkEkle;

  /// No description provided for @arilikSecimYeniEkleBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Arılık Ekle'**
  String get arilikSecimYeniEkleBaslik;

  /// No description provided for @arilikSecimArilikAdi.
  ///
  /// In tr, this message translates to:
  /// **'Arılık adı'**
  String get arilikSecimArilikAdi;

  /// No description provided for @arilikSecimAdiHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Uluköy'**
  String get arilikSecimAdiHint;

  /// No description provided for @arilikSecimBaslangicTarihi.
  ///
  /// In tr, this message translates to:
  /// **'Arılık başlangıç tarihi'**
  String get arilikSecimBaslangicTarihi;

  /// No description provided for @arilikSecimGecmisTarihMesaji.
  ///
  /// In tr, this message translates to:
  /// **'Arılık başlangıç tarihini geriye çekiyorsun. Bu doğruysa devam et. Sistem yine de koloni ve muayene tarihleriyle çakışırsa kaydı engeller.'**
  String get arilikSecimGecmisTarihMesaji;

  /// No description provided for @arilikSecimDuzenleTarihMesaji.
  ///
  /// In tr, this message translates to:
  /// **'Arılık başlangıç tarihini geriye çekiyorsun. Bu doğruysa devam et. Sistem, bu tarih koloni veya muayene kayıtlarıyla çelişirse kaydı engeller.'**
  String get arilikSecimDuzenleTarihMesaji;

  /// No description provided for @arilikSecimKalibrasyon.
  ///
  /// In tr, this message translates to:
  /// **'Kalibrasyon'**
  String get arilikSecimKalibrasyon;

  /// No description provided for @arilikSecimVarsayilanKal.
  ///
  /// In tr, this message translates to:
  /// **'Varsayılan kalibrasyonu kullan'**
  String get arilikSecimVarsayilanKal;

  /// No description provided for @arilikSecimVarsayilanKalAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Yeni arılık özel ayar oluşturmaz; genel varsayılan bal akımı ve risk takvimini kullanır.'**
  String get arilikSecimVarsayilanKalAciklama;

  /// No description provided for @arilikSecimKopyalaKal.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut bir arılıktan kopyala'**
  String get arilikSecimKopyalaKal;

  /// No description provided for @arilikSecimKopyalaKalAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Seçilen arılığın bal akımı ve genel risk takvimi yeni arılığa özel kalibrasyon olarak kopyalanır.'**
  String get arilikSecimKopyalaKalAciklama;

  /// No description provided for @arilikSecimKopyalanacakArilik.
  ///
  /// In tr, this message translates to:
  /// **'Kopyalanacak arılık'**
  String get arilikSecimKopyalanacakArilik;

  /// No description provided for @arilikSecimKalibrasyonSecmelisin.
  ///
  /// In tr, this message translates to:
  /// **'Kalibrasyon kopyalanacak arılığı seçmelisin.'**
  String get arilikSecimKalibrasyonSecmelisin;

  /// No description provided for @arilikSecimKayitHata.
  ///
  /// In tr, this message translates to:
  /// **'Arılık kaydedilemedi: {hata}'**
  String arilikSecimKayitHata(String hata);

  /// No description provided for @arilikSecimDuzenleBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Arılık Bilgilerini Düzenle'**
  String get arilikSecimDuzenleBaslik;

  /// No description provided for @arilikSecimDuzenleKural.
  ///
  /// In tr, this message translates to:
  /// **'Kural: Arılık başlangıç tarihi, bu arılıktaki koloni ve muayene tarihlerinden sonra olamaz. Aynı tarih kabul edilir.'**
  String get arilikSecimDuzenleKural;

  /// No description provided for @arilikSecimGuncellenemedi.
  ///
  /// In tr, this message translates to:
  /// **'Arılık güncellenemedi: {hata}'**
  String arilikSecimGuncellenemedi(String hata);

  /// No description provided for @arilikSecimUyariGizlendi.
  ///
  /// In tr, this message translates to:
  /// **'{baslik} bu arılıkta bu sezon gizlendi.'**
  String arilikSecimUyariGizlendi(String baslik);

  /// No description provided for @arilikSecimSilBaslik.
  ///
  /// In tr, this message translates to:
  /// **'ARILIĞI SİL'**
  String get arilikSecimSilBaslik;

  /// No description provided for @arilikSecimSilIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem geri alınamaz.\n\nSilinecek arılık: {ad}\nToplam koloni: {toplam}\nAktif koloni: {aktif}\nPasif / sönmüş koloni: {pasif}\n\nBu arılığa bağlı koloniler, muayeneler, olay kayıtları, numara geçmişi ve arılık özel kalibrasyonları silinir.\n\nDevam etmeden önce güncel yedek aldığından emin ol.'**
  String arilikSecimSilIcerik(String ad, int toplam, int aktif, int pasif);

  /// No description provided for @arilikSecimSilindi.
  ///
  /// In tr, this message translates to:
  /// **'{ad} arılığı silindi.'**
  String arilikSecimSilindi(String ad);

  /// No description provided for @arilikSecimSilinemedi.
  ///
  /// In tr, this message translates to:
  /// **'Arılık silinemedi: {hata}'**
  String arilikSecimSilinemedi(String hata);

  /// No description provided for @arilikSecimSonOnayBaslik.
  ///
  /// In tr, this message translates to:
  /// **'SON ONAY'**
  String get arilikSecimSonOnayBaslik;

  /// No description provided for @arilikSecimSonOnayIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Silme işlemini kesinleştirmek için arılık adını birebir yaz.'**
  String get arilikSecimSonOnayIcerik;

  /// No description provided for @arilikSecimAdiYaz.
  ///
  /// In tr, this message translates to:
  /// **'Arılık adını yaz'**
  String get arilikSecimAdiYaz;

  /// No description provided for @arilikSecimKaliciSilUyari.
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem arılık verisini kalıcı olarak siler.'**
  String get arilikSecimKaliciSilUyari;

  /// No description provided for @arilikSecimKaliciSil.
  ///
  /// In tr, this message translates to:
  /// **'Kalıcı Olarak Sil'**
  String get arilikSecimKaliciSil;

  /// No description provided for @arilikSecimAktifToplam.
  ///
  /// In tr, this message translates to:
  /// **'Aktif {aktif} / Toplam {toplam}'**
  String arilikSecimAktifToplam(int aktif, int toplam);

  /// No description provided for @arilikSecimUyariSayisi.
  ///
  /// In tr, this message translates to:
  /// **'{sayi} aktif genel uyarı var'**
  String arilikSecimUyariSayisi(int sayi);

  /// No description provided for @arilikSecimDetaylariAc.
  ///
  /// In tr, this message translates to:
  /// **'Detayları göster'**
  String get arilikSecimDetaylariAc;

  /// No description provided for @arilikSecimDetaylariKapat.
  ///
  /// In tr, this message translates to:
  /// **'Detayları kapat'**
  String get arilikSecimDetaylariKapat;

  /// No description provided for @arilikSecimBuSezonGosterme.
  ///
  /// In tr, this message translates to:
  /// **'Bu arılıkta bu sezon gösterme'**
  String get arilikSecimBuSezonGosterme;

  /// No description provided for @arilikSecimBaslangic.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç: {tarih}'**
  String arilikSecimBaslangic(String tarih);

  /// No description provided for @arilikSecimDuzenleTooltip.
  ///
  /// In tr, this message translates to:
  /// **'Arılığı düzenle'**
  String get arilikSecimDuzenleTooltip;

  /// No description provided for @arilikSecimSilTooltip.
  ///
  /// In tr, this message translates to:
  /// **'Arılığı sil'**
  String get arilikSecimSilTooltip;

  /// No description provided for @arilikSecimGir.
  ///
  /// In tr, this message translates to:
  /// **'Arılığa gir'**
  String get arilikSecimGir;

  /// No description provided for @arilikSecimToplam.
  ///
  /// In tr, this message translates to:
  /// **'Toplam'**
  String get arilikSecimToplam;

  /// No description provided for @arilikSecimAktif.
  ///
  /// In tr, this message translates to:
  /// **'Aktif'**
  String get arilikSecimAktif;

  /// No description provided for @arilikSecimPasif.
  ///
  /// In tr, this message translates to:
  /// **'Pasif'**
  String get arilikSecimPasif;

  /// No description provided for @muayeneEkleAppBarBaslik.
  ///
  /// In tr, this message translates to:
  /// **'{tarih} / Muayene Girişi'**
  String muayeneEkleAppBarBaslik(String tarih);

  /// No description provided for @muayeneEkleGecmisTarihIcerik.
  ///
  /// In tr, this message translates to:
  /// **'Muayene tarihini geriye çekiyorsun. Bu doğruysa devam et. Sistem, tarih koloni başlangıcı veya arılık başlangıcı ile çelişirse kaydı engeller.'**
  String get muayeneEkleGecmisTarihIcerik;

  /// No description provided for @muayeneEkleSesHata1.
  ///
  /// In tr, this message translates to:
  /// **'Ses algılama başlatılamadı. Android mikrofon iznini kontrol et.'**
  String get muayeneEkleSesHata1;

  /// No description provided for @muayeneEkleSesHata2.
  ///
  /// In tr, this message translates to:
  /// **'Bu cihazda sesle yazma kullanılamıyor.'**
  String get muayeneEkleSesHata2;

  /// No description provided for @muayeneEkleSesHata3.
  ///
  /// In tr, this message translates to:
  /// **'Sesle not ekleme sırasında hata oluştu.'**
  String get muayeneEkleSesHata3;

  /// No description provided for @muayeneEkleKayitHata.
  ///
  /// In tr, this message translates to:
  /// **'Teknik sorun oluştu: {hata}'**
  String muayeneEkleKayitHata(String hata);

  /// No description provided for @muayeneEkleKovanEtiket.
  ///
  /// In tr, this message translates to:
  /// **'KOVAN: {no}'**
  String muayeneEkleKovanEtiket(String no);

  /// No description provided for @muayeneEkleArilikEtiket.
  ///
  /// In tr, this message translates to:
  /// **'ARILIK: {ad}'**
  String muayeneEkleArilikEtiket(String ad);

  /// No description provided for @muayeneEkleMuayeneTarihi.
  ///
  /// In tr, this message translates to:
  /// **'Muayene Tarihi'**
  String get muayeneEkleMuayeneTarihi;

  /// No description provided for @muayeneEkleToplam.
  ///
  /// In tr, this message translates to:
  /// **'Toplam'**
  String get muayeneEkleToplam;

  /// No description provided for @muayeneEkleYavrulu.
  ///
  /// In tr, this message translates to:
  /// **'Yavrulu'**
  String get muayeneEkleYavrulu;

  /// No description provided for @muayeneEkleBalHasat.
  ///
  /// In tr, this message translates to:
  /// **'Bal/Hasat'**
  String get muayeneEkleBalHasat;

  /// No description provided for @muayeneEklePetekAktivasyonBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Petek / Hacim Aktivasyonu (+{artis} çıta)'**
  String muayeneEklePetekAktivasyonBaslik(int artis);

  /// No description provided for @muayeneEklePetekAktivasyonAniArtis.
  ///
  /// In tr, this message translates to:
  /// **'Son muayeneye göre {artis} çıta artış var. Koloni 9–10 çıta seviyesine ulaşmadan hızlı genişletme yapıldıysa sıkışık düzen bozulabilir. Sistem bu yeni hacmi hemen tam işlevsel kapasite saymaz.'**
  String muayeneEklePetekAktivasyonAniArtis(int artis);

  /// No description provided for @muayeneEklePetekAktivasyonKatGecis.
  ///
  /// In tr, this message translates to:
  /// **'Koloni 9–10 çıta eşiğinden 11+ çıtaya geçtiği için sistem bunu kat/ballık geçişi olarak okur. Yeni üst hacim kademeli işlev kazanır.'**
  String get muayeneEklePetekAktivasyonKatGecis;

  /// No description provided for @muayeneEklePetekAktivasyonNormal.
  ///
  /// In tr, this message translates to:
  /// **'Yeni verilen çıta fiziksel olarak kaydedilir; biyolojik model bu çıtanın işlev kazanmasını zamana yayarak değerlendirir.'**
  String get muayeneEklePetekAktivasyonNormal;

  /// No description provided for @muayeneEklePetekDagilimBilgi.
  ///
  /// In tr, this message translates to:
  /// **'Eklenen peteklerin dağılımını gir. Temel ve kabarmış petek birlikte verilebilir; toplam artış sayısını geçmez.'**
  String get muayeneEklePetekDagilimBilgi;

  /// No description provided for @muayeneEkleTemel.
  ///
  /// In tr, this message translates to:
  /// **'Temel'**
  String get muayeneEkleTemel;

  /// No description provided for @muayeneEkleKabarmis.
  ///
  /// In tr, this message translates to:
  /// **'Kabarmış'**
  String get muayeneEkleKabarmis;

  /// No description provided for @muayeneEklePetekToplam.
  ///
  /// In tr, this message translates to:
  /// **'Toplam: {toplam} / {artis} çıta'**
  String muayeneEklePetekToplam(int toplam, int artis);

  /// No description provided for @muayeneEkleYavruDuzeniLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yavru Düzeni'**
  String get muayeneEkleYavruDuzeniLabel;

  /// No description provided for @muayeneEkleKoloniMizaci.
  ///
  /// In tr, this message translates to:
  /// **'Koloni Mizacı'**
  String get muayeneEkleKoloniMizaci;

  /// No description provided for @muayeneEkleBeslemeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Besleme'**
  String get muayeneEkleBeslemeLabel;

  /// No description provided for @muayeneEkleVarroaLabel.
  ///
  /// In tr, this message translates to:
  /// **'Varroa Mücadelesi'**
  String get muayeneEkleVarroaLabel;

  /// No description provided for @muayeneEkleOgulBelirtisiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Oğul Belirtisi'**
  String get muayeneEkleOgulBelirtisiBaslik;

  /// No description provided for @muayeneEkleOgulBelirtisiAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Karar önerisi ve yakın izleme sinyali üretir.'**
  String get muayeneEkleOgulBelirtisiAciklama;

  /// No description provided for @muayeneEkleOgulAttiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Oğul Attı'**
  String get muayeneEkleOgulAttiBaslik;

  /// No description provided for @muayeneEkleOgulAttiAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Gerçekleşmiş olaydır. Skor ve hat pozisyonunu etkiler.'**
  String get muayeneEkleOgulAttiAciklama;

  /// No description provided for @muayeneEkleAnaGorulmedi.
  ///
  /// In tr, this message translates to:
  /// **'Ana Görülmedi'**
  String get muayeneEkleAnaGorulmedi;

  /// No description provided for @muayeneEkleBolmeYapildiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bölme Yapıldı'**
  String get muayeneEkleBolmeYapildiBaslik;

  /// No description provided for @muayeneEkleBolmeYapildiAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Çıta düşüşü performans kaybı değil, kontrollü çoğalma olarak yorumlanır.'**
  String get muayeneEkleBolmeYapildiAciklama;

  /// No description provided for @muayeneEkleKovanSonduBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kovan Söndü'**
  String get muayeneEkleKovanSonduBaslik;

  /// No description provided for @muayeneEkleKovanSonduAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Koloninin aktif performans yerine yaşam döngüsü sonu olarak değerlendirilmesini sağlar.'**
  String get muayeneEkleKovanSonduAciklama;

  /// No description provided for @muayeneEkleAnauretimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Ana Üretimi ve Zamanlama'**
  String get muayeneEkleAnauretimBaslik;

  /// No description provided for @muayeneEkleAnauretimBilgi.
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik ana kazanma takvimi yalnızca gerçekten anasız bırakılan koloni için çalışır. Anaç kolonideki bölme işlemi ayrı olarak toparlanma süreci üretir.'**
  String get muayeneEkleAnauretimBilgi;

  /// No description provided for @muayeneEkleAnasizBirakildiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Koloni Anasız Bırakıldı'**
  String get muayeneEkleAnasizBirakildiBaslik;

  /// No description provided for @muayeneEkleAnasizBirakildiAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Gün hesabı ve biyolojik pencere yorumu için kritik bilgidir.'**
  String get muayeneEkleAnasizBirakildiAciklama;

  /// No description provided for @muayeneEkleKaydet.
  ///
  /// In tr, this message translates to:
  /// **'KAYDET'**
  String get muayeneEkleKaydet;

  /// No description provided for @muayeneEkleGuncelle.
  ///
  /// In tr, this message translates to:
  /// **'GÜNCELLE'**
  String get muayeneEkleGuncelle;

  /// No description provided for @muayeneEkleNotlarLabel.
  ///
  /// In tr, this message translates to:
  /// **'Notlar'**
  String get muayeneEkleNotlarLabel;

  /// No description provided for @muayeneEkleSesBasla.
  ///
  /// In tr, this message translates to:
  /// **'Sesle not ekle'**
  String get muayeneEkleSesBasla;

  /// No description provided for @muayeneEkleSesDurdur.
  ///
  /// In tr, this message translates to:
  /// **'Sesle yazmayı durdur'**
  String get muayeneEkleSesDurdur;

  /// No description provided for @muayeneEkleSesHelper.
  ///
  /// In tr, this message translates to:
  /// **'Mikrofona dokunarak sesle not ekleyebilirsin.'**
  String get muayeneEkleSesHelper;

  /// No description provided for @muayeneEkleSesHelperAktif.
  ///
  /// In tr, this message translates to:
  /// **'Dinleniyor... Konuşman not alanına yazılıyor.'**
  String get muayeneEkleSesHelperAktif;

  /// No description provided for @muayeneEkleOnYuklemeBilgi.
  ///
  /// In tr, this message translates to:
  /// **'Son muayene verileri ön yüklendi. Gerekli alanları güncelleyerek devam edebilirsin.'**
  String get muayeneEkleOnYuklemeBilgi;

  /// No description provided for @muayeneEkleBolmeBilgi.
  ///
  /// In tr, this message translates to:
  /// **'Yeni açılan kolonide Kaynak Koloni bilgisini girmen, soy takibi ve performans analizini güçlendirir.'**
  String get muayeneEkleBolmeBilgi;

  /// No description provided for @muayeneEkleOgulAttiBilgi.
  ///
  /// In tr, this message translates to:
  /// **'Oğul attı, gerçekleşmiş olaydır. Seçilim ve hat değerlendirmesini etkiler.'**
  String get muayeneEkleOgulAttiBilgi;

  /// No description provided for @muayeneEkleSuruplukEklendi.
  ///
  /// In tr, this message translates to:
  /// **'Şurupluk eklendi'**
  String get muayeneEkleSuruplukEklendi;

  /// No description provided for @muayeneEkleSuruplukEklendiAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni şurupluksuz. Muayenede şurupluk eklendiyse işaretle; aksi hâlde kaldırılmış sayılmaya devam eder.'**
  String get muayeneEkleSuruplukEklendiAciklama;

  /// No description provided for @muayeneEkleSuruplukKaldirildi.
  ///
  /// In tr, this message translates to:
  /// **'Şurupluk kaldırıldı'**
  String get muayeneEkleSuruplukKaldirildi;

  /// No description provided for @muayeneEkleSuruplukKaldirildiHasat.
  ///
  /// In tr, this message translates to:
  /// **'Bu kayıt hasat sonrası bakım olarak okunur; besleme seçimi yeniden kullanılabilir.'**
  String get muayeneEkleSuruplukKaldirildiHasat;

  /// No description provided for @muayeneEkleSuruplukKaldirildiNormal.
  ///
  /// In tr, this message translates to:
  /// **'İşaretlersen biyolojik modelde şurupluk kalkar ve petek düzeni sola kayar.'**
  String get muayeneEkleSuruplukKaldirildiNormal;

  /// No description provided for @muayeneEkleSuruplukVarsayilanMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı yaklaşıyor. Şeker kalıntısı riskini azaltmak için besleme sonlandırılmalı; şurupluk kaldırılıp yerine petek verilebilir.'**
  String get muayeneEkleSuruplukVarsayilanMesaj;

  /// No description provided for @muayeneEkleSuruplukHasatMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Bal/hasat kaydı girildi. Hasat sonrası bakım döneminde besleme alanı yeniden açılır; şurupluk ihtiyaç varsa tekrar kullanılabilir. İkinci bal akımı penceresi açıldığında aynı şurupluk kaldırma ve besleme kesme döngüsü yeniden çalışır.'**
  String get muayeneEkleSuruplukHasatMesaj;

  /// No description provided for @muayeneEkleSuruplukBildirilenKisit.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı yaklaştığı için besleme kısıtı başladı. Şeker kalıntısı riskini azaltmak için şurupluğu gerçekten kaldırdıysan işaretle.'**
  String get muayeneEkleSuruplukBildirilenKisit;

  /// No description provided for @muayeneEkleBeslemeSuruplukBilgi.
  ///
  /// In tr, this message translates to:
  /// **'Şurupluk kaldırıldı olarak işaretlendi. Aynı muayenede şeker bazlı besleme seçimi kapatıldı; bu kayıt hasat hazırlığı olarak okunur.'**
  String get muayeneEkleBeslemeSuruplukBilgi;

  /// No description provided for @muayeneEkleHasatBakimBilgi.
  ///
  /// In tr, this message translates to:
  /// **'Bal/hasat kaydı girildiği için besleme alanı yeniden aktif. Bu dönem hasat sonrası bakım olarak okunur. İkinci bal akımı aktif olursa sistem yeniden besleme kesme ve şurupluk kaldırma uyarısına döner.'**
  String get muayeneEkleHasatBakimBilgi;

  /// No description provided for @muayeneEkleGunlukYavruBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Günlük / kapalı yavru görüldü'**
  String get muayeneEkleGunlukYavruBaslik;

  /// No description provided for @muayeneEkleGunlukYavruAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Bölme, oğul, ana kazanma veya yavru yok takibinde kapanış işaretidir. İşaretlersen sistem yavru görülmeme penceresini kapatır ve koloniyi normal düzene alır.'**
  String get muayeneEkleGunlukYavruAciklama;

  /// No description provided for @muayeneEkleYavruYokErken.
  ///
  /// In tr, this message translates to:
  /// **'Yavru düzeni \"Yok\" olarak kaydedilecek. Aktif biyolojik süreçte erken pencere olabilir; bu aşamada yavru görülmemesi tek başına alarm değildir.'**
  String get muayeneEkleYavruYokErken;

  /// No description provided for @muayeneEkleYavruYokErkenVarsayilan.
  ///
  /// In tr, this message translates to:
  /// **'Gereksiz açma ve sert müdahale önerilmez.'**
  String get muayeneEkleYavruYokErkenVarsayilan;

  /// No description provided for @muayeneEkleYavruYokTani.
  ///
  /// In tr, this message translates to:
  /// **'Yavru düzeni \"Yok\" olarak kaydedilecek. Sistem artık kısa tanı gözlemleriyle bal baskısı, geç çiftleşme, ana sorunu veya biyolojik zayıflama olasılıklarını ayıracak.'**
  String get muayeneEkleYavruYokTani;

  /// No description provided for @muayeneEkleYavruYokNormal.
  ///
  /// In tr, this message translates to:
  /// **'Yavru düzeni \"Yok\" olarak kaydedilecek. Sistem bunu normal koloni bağlamında ayrı okuyacak; yavrulu çıta sayısı 0 kabul edilir ve biyolojik model geri dönüş kapasitesini buna göre hesaplar.'**
  String get muayeneEkleYavruYokNormal;

  /// No description provided for @muayeneEkleYavruYokTaniBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Yavru Yok Kısa Tanı Gözlemleri'**
  String get muayeneEkleYavruYokTaniBaslik;

  /// No description provided for @muayeneEkleYavruYokTaniAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Bu alan teşhis seçtirmez. Sistem bu 4 basit gözlemi mevcut sezon, süreç penceresi ve koloni gücüyle birlikte okuyarak öneri üretir.'**
  String get muayeneEkleYavruYokTaniAciklama;

  /// No description provided for @muayeneEkleTaniKoloniSakin.
  ///
  /// In tr, this message translates to:
  /// **'Koloni sakin mi?'**
  String get muayeneEkleTaniKoloniSakin;

  /// No description provided for @muayeneEkleTaniKoloniSakinAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Sakin koloni içeride yeni ana olma ihtimalini artırır. Huzursuz koloni anasızlık/stres şüphesini yükseltir.'**
  String get muayeneEkleTaniKoloniSakinAciklama;

  /// No description provided for @muayeneEkleTaniPolen.
  ///
  /// In tr, this message translates to:
  /// **'Polen gelişi var mı?'**
  String get muayeneEkleTaniPolen;

  /// No description provided for @muayeneEkleTaniPolenAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Polen gelişi, yavru hazırlığı veya içeride ana varlığı ihtimalini destekler. Polen yokluğu biyolojik durgunluk riskini artırır.'**
  String get muayeneEkleTaniPolenAciklama;

  /// No description provided for @muayeneEkleTaniBal.
  ///
  /// In tr, this message translates to:
  /// **'Bal / nektar gelişi güçlü mü?'**
  String get muayeneEkleTaniBal;

  /// No description provided for @muayeneEkleTaniBalAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Güçlü akım yumurtlama alanını daraltabilir. Bu durumda yavru yokluğu doğrudan anasızlık anlamına gelmeyebilir.'**
  String get muayeneEkleTaniBalAciklama;

  /// No description provided for @muayeneEkleTaniErkek.
  ///
  /// In tr, this message translates to:
  /// **'Erkek yavru gözleri baskın mı?'**
  String get muayeneEkleTaniErkek;

  /// No description provided for @muayeneEkleTaniErkekAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Evet ise çiftleşememiş ana, başarısız ana veya yalancı ana riski artar. Bu cevap bekleme kararını sertleştirir.'**
  String get muayeneEkleTaniErkekAciklama;

  /// No description provided for @muayeneEkleTaniEminDegil.
  ///
  /// In tr, this message translates to:
  /// **'Emin değilim'**
  String get muayeneEkleTaniEminDegil;

  /// No description provided for @rehberBaslik.
  ///
  /// In tr, this message translates to:
  /// **'KULLANICI REHBERİ'**
  String get rehberBaslik;

  /// No description provided for @rehberProOzellik.
  ///
  /// In tr, this message translates to:
  /// **'Özellik'**
  String get rehberProOzellik;

  /// No description provided for @rehberProUcretsiz.
  ///
  /// In tr, this message translates to:
  /// **'Ücretsiz'**
  String get rehberProUcretsiz;

  /// No description provided for @rehberProPRO.
  ///
  /// In tr, this message translates to:
  /// **'PRO'**
  String get rehberProPRO;

  /// No description provided for @rehberProS1.
  ///
  /// In tr, this message translates to:
  /// **'Sınırsız koloni kaydı'**
  String get rehberProS1;

  /// No description provided for @rehberProS2.
  ///
  /// In tr, this message translates to:
  /// **'Muayene formu ve geçmiş'**
  String get rehberProS2;

  /// No description provided for @rehberProS3.
  ///
  /// In tr, this message translates to:
  /// **'Kovan yerleşim görseli'**
  String get rehberProS3;

  /// No description provided for @rehberProS4.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini arı sayısı'**
  String get rehberProS4;

  /// No description provided for @rehberProS5.
  ///
  /// In tr, this message translates to:
  /// **'Özet yorum (tek cümle)'**
  String get rehberProS5;

  /// No description provided for @rehberProS6.
  ///
  /// In tr, this message translates to:
  /// **'Yönetim kararı detayı'**
  String get rehberProS6;

  /// No description provided for @rehberProS7.
  ///
  /// In tr, this message translates to:
  /// **'Risk analizi (Varroa, arı kuşu…)'**
  String get rehberProS7;

  /// No description provided for @rehberProS8.
  ///
  /// In tr, this message translates to:
  /// **'Hasat projeksiyonu ve miktar'**
  String get rehberProS8;

  /// No description provided for @rehberProS9.
  ///
  /// In tr, this message translates to:
  /// **'Ekonomik değer tahmini'**
  String get rehberProS9;

  /// No description provided for @rehberProS10.
  ///
  /// In tr, this message translates to:
  /// **'Demografi ve kabiliyet skorları'**
  String get rehberProS10;

  /// No description provided for @rehberProS11.
  ///
  /// In tr, this message translates to:
  /// **'Koloni projeksiyonu'**
  String get rehberProS11;

  /// No description provided for @rehberProS12.
  ///
  /// In tr, this message translates to:
  /// **'Performans raporları'**
  String get rehberProS12;

  /// No description provided for @rehberProS13.
  ///
  /// In tr, this message translates to:
  /// **'Hat analizi'**
  String get rehberProS13;

  /// No description provided for @rehberProS14.
  ///
  /// In tr, this message translates to:
  /// **'Koloni karşılaştırma'**
  String get rehberProS14;

  /// No description provided for @rehberProS15.
  ///
  /// In tr, this message translates to:
  /// **'Soy ağacı'**
  String get rehberProS15;

  /// No description provided for @rehberProS16.
  ///
  /// In tr, this message translates to:
  /// **'Formüller ve hesaplamalar'**
  String get rehberProS16;

  /// No description provided for @rehber1Baslik.
  ///
  /// In tr, this message translates to:
  /// **'1. İTOGENA Ne Yapar?'**
  String get rehber1Baslik;

  /// No description provided for @rehber1Kutu.
  ///
  /// In tr, this message translates to:
  /// **'İTOGENA, basit saha verisini zaman, süreç, soy, performans ve arılık kalibrasyonu ile birlikte okuyarak uygulanabilir koloni kararı üretir. Amaç yalnızca kayıt tutmak değil; arıcıya neyi, neden ve ne zaman yapacağını anlaşılır biçimde göstermektir.'**
  String get rehber1Kutu;

  /// No description provided for @rehber1M1.
  ///
  /// In tr, this message translates to:
  /// **'Sistem tetik → süreç → öneri → saha eylemi → yeni muayene → kapanış mantığıyla çalışır.'**
  String get rehber1M1;

  /// No description provided for @rehber1M2.
  ///
  /// In tr, this message translates to:
  /// **'Koloni sınıfı tek biyolojik kaynaktan üretilir: işlevsel üretim çıtası 0–3 ise zayıf, 4–7 ise gelişim, 8–9 ise üretim, 10 ve üzeri ise hasat sınıfıdır.'**
  String get rehber1M2;

  /// No description provided for @rehber1M3.
  ///
  /// In tr, this message translates to:
  /// **'Her süreç için ayrıca onay istemez; sonucu sonraki muayene verisinden anlamaya çalışır.'**
  String get rehber1M3;

  /// No description provided for @rehber1M4.
  ///
  /// In tr, this message translates to:
  /// **'Koloni detay ekranı hızlı açılır; ağır analizler arka planda yüklenir.'**
  String get rehber1M4;

  /// No description provided for @rehber1M5.
  ///
  /// In tr, this message translates to:
  /// **'Sistem fiziksel çıta ile işlevsel üretim kapasitesini ayrı okur. Hızlı genişleme, temel petek yüklenmesi veya hasat sonrası hacim değişimleri doğrudan güçlü koloni kabul edilmez.'**
  String get rehber1M5;

  /// No description provided for @rehber1M6.
  ///
  /// In tr, this message translates to:
  /// **'Koloni detay genel durum ekranında dört ana başlık gösterilir: Süreç, Biyoloji, Yönetim ve Genetik.'**
  String get rehber1M6;

  /// No description provided for @rehber1M7.
  ///
  /// In tr, this message translates to:
  /// **'Yönetim kartı besleme, kat, alan, varroa, kış ve hasat sonrası bakım kararlarını aynı yönetim listesinde standartlaştırır.'**
  String get rehber1M7;

  /// No description provided for @rehber1M8.
  ///
  /// In tr, this message translates to:
  /// **'Muayene, koloni veya arılık verisi değiştiğinde tüm önbellekler birlikte temizlenir; eski kararın ekranda kalma riski azaltılır.'**
  String get rehber1M8;

  /// No description provided for @rehber2Baslik.
  ///
  /// In tr, this message translates to:
  /// **'2. Ücretsiz ve PRO'**
  String get rehber2Baslik;

  /// No description provided for @rehber2Kutu.
  ///
  /// In tr, this message translates to:
  /// **'ITOGENA\'yı muayene kaydı ve temel koloni takibi için ücretsiz kullanabilirsin. Derin analiz, risk izleme, hasat tahmini ve raporlama PRO kapsamındadır.'**
  String get rehber2Kutu;

  /// No description provided for @rehber3Baslik.
  ///
  /// In tr, this message translates to:
  /// **'3. Sistem Çıtadan Ne Anlar?'**
  String get rehber3Baslik;

  /// No description provided for @rehber3M1.
  ///
  /// In tr, this message translates to:
  /// **'Çıta sayısı koloni gücünün temel saha göstergesidir; tek başına kesin karar değildir.'**
  String get rehber3M1;

  /// No description provided for @rehber3M2.
  ///
  /// In tr, this message translates to:
  /// **'Son çıta mevcut canlı gücü, maksimum çıta sezon içi kapasiteyi, bal çıtası ise üretim dönemindeki verimi anlatır.'**
  String get rehber3M2;

  /// No description provided for @rehber3M3.
  ///
  /// In tr, this message translates to:
  /// **'Kışta çıta gücü dayanıklılık için önemlidir; bal çıtası kış performansı gibi okunmaz.'**
  String get rehber3M3;

  /// No description provided for @rehber3M4.
  ///
  /// In tr, this message translates to:
  /// **'Sistem çıta sayısını yalnızca sayı olarak değil, tahmini biyolojik kapasite olarak okur: arı nüfusu, göz kapasitesi, yavru/stok alanı, ana bölgesi ve hasat potansiyeli bu veriden türetilir.'**
  String get rehber3M4;

  /// No description provided for @rehber3M5.
  ///
  /// In tr, this message translates to:
  /// **'Bu değerler kesin ölçüm değildir; iklim, flora, arı ırkı, sezon ve yönetim farkları sonucu değiştirebilir.'**
  String get rehber3M5;

  /// No description provided for @rehber3M6.
  ///
  /// In tr, this message translates to:
  /// **'Langstroth varsayılan referanstır. Dadant seçilirse aynı biyolojik düzen korunur ancak çıta kapasitesi daha yüksek katsayıyla hesaplanır.'**
  String get rehber3M6;

  /// No description provided for @rehber3M7.
  ///
  /// In tr, this message translates to:
  /// **'Şurupluk varsa alt kuluçkalık 9 çıta, yoksa 10 çıta kabul edilir. Bu sınırın üstündeki çıtalar kat/ballık alanı olarak yorumlanır.'**
  String get rehber3M7;

  /// No description provided for @rehber3bBaslik.
  ///
  /// In tr, this message translates to:
  /// **'3B. İşlevsel Çıta ve Hacim Aktivasyonu'**
  String get rehber3bBaslik;

  /// No description provided for @rehber3bM1.
  ///
  /// In tr, this message translates to:
  /// **'İTOGENA fiziksel çıta ile işlevsel çıtayı ayrı okur. Kovandaki çıta sayısı fiziksel hacmi, koloninin gerçekten kullanabildiği alan ise işlevsel biyolojik kapasiteyi anlatır.'**
  String get rehber3bM1;

  /// No description provided for @rehber3bM2.
  ///
  /// In tr, this message translates to:
  /// **'Yeni verilen çıta hemen tam kapasite sayılmaz. Sistem temel petek veya kabarmış petek ayrımına, geçen gün sayısına, yavru düzenine, koloni gücüne ve bal akımı penceresine göre aktivasyon süresi hesaplar.'**
  String get rehber3bM2;

  /// No description provided for @rehber3bM3.
  ///
  /// In tr, this message translates to:
  /// **'Sistem sıkışık düzen varsayımıyla çalışır. Bir muayenede +1 çıta normal, +2 çıta kontrollü genişleme, +3 ve üzeri ise kat geçişi dışında uyarı sebebidir.'**
  String get rehber3bM3;

  /// No description provided for @rehber3bM4.
  ///
  /// In tr, this message translates to:
  /// **'Şurupluk + 9 çıta veya şurupluksuz 10 çıta %95 ve üzeri aktivasyona ulaşırsa sistem bunu \"Kat ver\" eşiği olarak okur.'**
  String get rehber3bM4;

  /// No description provided for @rehber3bM5.
  ///
  /// In tr, this message translates to:
  /// **'Şurupluk + 19 çıta veya şurupluksuz 20 çıta %95 ve üzeri aktivasyona ulaşırsa sistem \"3. kat ver\" uyarısı üretir.'**
  String get rehber3bM5;

  /// No description provided for @rehber3bM6.
  ///
  /// In tr, this message translates to:
  /// **'Hasat kaydıyla birlikte oluşan hızlı çıta düşüşü biyolojik çöküş sayılmaz; sistem bunu hasat kaynaklı hacim daralması olarak normalleştirir.'**
  String get rehber3bM6;

  /// No description provided for @rehber3cBaslik.
  ///
  /// In tr, this message translates to:
  /// **'3C. Sezon Biyoloji Matrisi'**
  String get rehber3cBaslik;

  /// No description provided for @rehber3cM1.
  ///
  /// In tr, this message translates to:
  /// **'İTOGENA sezonu yalnızca takvim adı olarak okumaz. Her sezon için yavru beklentisi, stok baskısı, polen/arı ekmeği beklentisi, ana amaç ve aktivasyon katsayısı birlikte değerlendirilir.'**
  String get rehber3cM1;

  /// No description provided for @rehber3cM2.
  ///
  /// In tr, this message translates to:
  /// **'Sistem kış, kış çıkışı, ilkbahar gelişimi, bal akımı öncesi, bal akımı, hasat sonrası, sonbahar hazırlık ve geç sonbahar evrelerini ayrı biyolojik davranışlar olarak ele alır.'**
  String get rehber3cM2;

  /// No description provided for @rehber3cM3.
  ///
  /// In tr, this message translates to:
  /// **'Bu matris koloniye doğrudan emir vermez; aktivasyon, kabiliyet, besleme, hasat ve bölme kararlarına biyolojik bağlam sağlar.'**
  String get rehber3cM3;

  /// No description provided for @rehber3cM4.
  ///
  /// In tr, this message translates to:
  /// **'Sezon bilgisi yerel bal akımı kalibrasyonu ile birlikte okunur. Bu nedenle aynı tarih her arılıkta aynı karar anlamına gelmeyebilir.'**
  String get rehber3cM4;

  /// No description provided for @rehber3dBaslik.
  ///
  /// In tr, this message translates to:
  /// **'3D. Koloni Gidişatı ve Normalize Momentum'**
  String get rehber3dBaslik;

  /// No description provided for @rehber3dM1.
  ///
  /// In tr, this message translates to:
  /// **'Koloni Gidişatı, koloninin yalnız bugünkü gücünü değil hangi yöne gittiğini anlatır. Momentum bu hesabın içinde yaşar.'**
  String get rehber3dM1;

  /// No description provided for @rehber3dM2.
  ///
  /// In tr, this message translates to:
  /// **'Momentum artık ham çıta artışı değildir. Hasat sonrası hızlı düşüş biyolojik çöküş sayılmaz; bölme sonrası düşüş işlem kaynaklı okunur; kat atılması ise fiziksel hacim artışı olduğu için aktivasyon tamamlanmadan tam büyüme kabul edilmez.'**
  String get rehber3dM2;

  /// No description provided for @rehber3dM3.
  ///
  /// In tr, this message translates to:
  /// **'Kat geçişi, riskli hızlı genişleme, düşük aktivasyon ve bal akımı içindeki sağlıklı üst hacim genişlemesi ayrı ayrı normalize edilir.'**
  String get rehber3dM3;

  /// No description provided for @rehber3dM4.
  ///
  /// In tr, this message translates to:
  /// **'Performans sekmesindeki Koloni Gidişatı; gelişim yönü, üretim yönü, alan baskısı, toparlanma potansiyeli, çöküş riski ve normalize momentumu birlikte okur.'**
  String get rehber3dM4;

  /// No description provided for @rehber3eBaslik.
  ///
  /// In tr, this message translates to:
  /// **'3E. Demografi Projeksiyonu'**
  String get rehber3eBaslik;

  /// No description provided for @rehber3eM1.
  ///
  /// In tr, this message translates to:
  /// **'Demografi projeksiyonu kesin arı sayımı yapmaz; çıta gücü, yavru yükü, sezon ve gelişim yönünden koloni içindeki iş gücü dağılımını tahmin eder.'**
  String get rehber3eM1;

  /// No description provided for @rehber3eM2.
  ///
  /// In tr, this message translates to:
  /// **'Sistem genç işçi, bakıcı arı, petek işleyici, iç işçi, bekçi, tarlacı ve erkek arı dağılımını saha kararı için ayrı ayrı okur.'**
  String get rehber3eM2;

  /// No description provided for @rehber3eM3.
  ///
  /// In tr, this message translates to:
  /// **'Genç işçi kapasitesi ham petek ve yavru bakım kararlarında; tarlacı kapasitesi bal akımı ve üretim kararlarında kullanılır.'**
  String get rehber3eM3;

  /// No description provided for @rehber3eM4.
  ///
  /// In tr, this message translates to:
  /// **'Demografi çıktısı \"kesin nüfus\" değildir; biyolojik olasılık ve saha projeksiyonudur.'**
  String get rehber3eM4;

  /// No description provided for @rehber3fBaslik.
  ///
  /// In tr, this message translates to:
  /// **'3F. İş Gücü ve Kabiliyet Projeksiyonu'**
  String get rehber3fBaslik;

  /// No description provided for @rehber3fM1.
  ///
  /// In tr, this message translates to:
  /// **'İTOGENA yalnızca kaç arı olduğunu değil, bu arıların hangi işi yapabilecek biyolojik kapasitede olduğunu yorumlamaya çalışır.'**
  String get rehber3fM1;

  /// No description provided for @rehber3fM2.
  ///
  /// In tr, this message translates to:
  /// **'Petek örme, yavru bakım, nektar toplama, bal işleme, savunma, toparlanma, kış dayanımı ve çiftleşme desteği ayrı iş gücü alanları olarak değerlendirilir.'**
  String get rehber3fM2;

  /// No description provided for @rehber3fM3.
  ///
  /// In tr, this message translates to:
  /// **'Aynı çıta sayısına sahip iki koloni farklı iş gücü kapasitesine sahip olabilir. Genç işçi oranı düşük koloniler geniş görünse bile hızlı petek işleme veya yavru büyütmede zorlanabilir.'**
  String get rehber3fM3;

  /// No description provided for @rehber3fM4.
  ///
  /// In tr, this message translates to:
  /// **'Bu projeksiyon kesin biyolojik ölçüm yapmaz; saha kararını destekleyen açıklanabilir biyolojik eğilim modeli üretir.'**
  String get rehber3fM4;

  /// No description provided for @rehber3gBaslik.
  ///
  /// In tr, this message translates to:
  /// **'3G. Risk Projeksiyonu ve Doğal Risk Frenleri'**
  String get rehber3gBaslik;

  /// No description provided for @rehber3gM1.
  ///
  /// In tr, this message translates to:
  /// **'Risk projeksiyonu koloniyi korkutucu uyarılarla yönetmez; sezonun doğal risk primini ve koloninin biyolojik kırılganlığını birlikte okuyarak dengeli karar freni üretir.'**
  String get rehber3gM1;

  /// No description provided for @rehber3gM2.
  ///
  /// In tr, this message translates to:
  /// **'Varroa, arı kuşu, eşek arısı, yağmacılık, nem/kış, aşırı genişleme, yavrusuzluk/yaşlanma ve bal kalitesi riski aynı merkezde değerlendirilir.'**
  String get rehber3gM2;

  /// No description provided for @rehber3gM3.
  ///
  /// In tr, this message translates to:
  /// **'Risk freni kararları doğrudan yasaklamaz. Genişletme, bölme, besleme, hasat ve müdahale önerilerini küçük katsayılarla temkinli hale getirir.'**
  String get rehber3gM3;

  /// No description provided for @rehber3gM4.
  ///
  /// In tr, this message translates to:
  /// **'Bu sistem kesin hastalık veya zararlı teşhisi koymaz; açıklanabilir risk eğilimi üretir.'**
  String get rehber3gM4;

  /// No description provided for @rehber4Baslik.
  ///
  /// In tr, this message translates to:
  /// **'4. Bölme Neden 9 Çıta Altında Önerilmez?'**
  String get rehber4Baslik;

  /// No description provided for @rehber4M1.
  ///
  /// In tr, this message translates to:
  /// **'6 çıta biyolojik olarak mümkün olabilir; fakat güvenli saha önerisi değildir.'**
  String get rehber4M1;

  /// No description provided for @rehber4M2.
  ///
  /// In tr, this message translates to:
  /// **'İTOGENA mümkün olanı değil, arıcıyı koloni kaybı riskinden koruyan doğru öneriyi verir.'**
  String get rehber4M2;

  /// No description provided for @rehber4M3.
  ///
  /// In tr, this message translates to:
  /// **'Bölme önerisi için güvenli eşik 9 çıtadır. Ana koloni bölmeden sonra en az 5 çıta kalabilmeli, yeni bölme en az 4 çıta başlayabilmelidir.'**
  String get rehber4M3;

  /// No description provided for @rehber4M4.
  ///
  /// In tr, this message translates to:
  /// **'6–8 çıta arası riskli kabul edilir; sistem bölme önermek yerine önce güçlendirmeyi söyler.'**
  String get rehber4M4;

  /// No description provided for @rehber4M5.
  ///
  /// In tr, this message translates to:
  /// **'Kış döneminde bölme önerisi üretilmez.'**
  String get rehber4M5;

  /// No description provided for @rehber4M6.
  ///
  /// In tr, this message translates to:
  /// **'Bölme kararı zaman bağlamıyla okunur. Bal akımına 57 günden fazla varsa güçlü kolonide bölme anlamlıdır; 57 günden az kaldıysa standart bölme üretim gücünü düşürebilir.'**
  String get rehber4M6;

  /// No description provided for @rehber5Baslik.
  ///
  /// In tr, this message translates to:
  /// **'5. Donör Skoru ile Genel Skor Farkı Nedir?'**
  String get rehber5Baslik;

  /// No description provided for @rehber5M1.
  ///
  /// In tr, this message translates to:
  /// **'Genel skor koloninin saha performansıdır.'**
  String get rehber5M1;

  /// No description provided for @rehber5M2.
  ///
  /// In tr, this message translates to:
  /// **'Donör skoru ana üretimi ve genetik seçilim değeridir.'**
  String get rehber5M2;

  /// No description provided for @rehber5M3.
  ///
  /// In tr, this message translates to:
  /// **'85 genel skor tek başına donörlük anlamına gelmez. Oğul izi/genetik filtre, soy devamlılığı, üreme gücü, dayanıklılık ve veri güveni ayrıca okunur.'**
  String get rehber5M3;

  /// No description provided for @rehber5M4.
  ///
  /// In tr, this message translates to:
  /// **'Güçlü ama genetik filtreye takılan koloni üretimde veya kapalı yavru desteğinde değerlendirilebilir; ana üretim havuzuna alınmaz.'**
  String get rehber5M4;

  /// No description provided for @rehber6Baslik.
  ///
  /// In tr, this message translates to:
  /// **'6. Oğul İzi ve Oğul Sonrası Süreç'**
  String get rehber6Baslik;

  /// No description provided for @rehber6M1.
  ///
  /// In tr, this message translates to:
  /// **'Oğul sağlık problemi değildir; bu nedenle sağlık skorunu düşürmez.'**
  String get rehber6M1;

  /// No description provided for @rehber6M2.
  ///
  /// In tr, this message translates to:
  /// **'Oğul kökeni veya oğul izi taşıyan koloni donör havuzuna girmez.'**
  String get rehber6M2;

  /// No description provided for @rehber6M3.
  ///
  /// In tr, this message translates to:
  /// **'Oğul attı işaretlenirse koloni geçici olarak üretim/hasat kolonisi gibi okunmaz. 0–7. gün arası artçı oğul riski en yüksektir.'**
  String get rehber6M3;

  /// No description provided for @rehber6M4.
  ///
  /// In tr, this message translates to:
  /// **'8–16. gün arası artçı oğul riski azalır. 17–30. gün yeni ana çıkışı, olgunlaşma ve çiftleşme penceresidir.'**
  String get rehber6M4;

  /// No description provided for @rehber6M5.
  ///
  /// In tr, this message translates to:
  /// **'31–45. gün arası yumurtlama artık netleşmelidir. Hâlâ yavru yoksa sistem bunu ana başarısızlığı veya yalancı ana riski olarak değerlendirir.'**
  String get rehber6M5;

  /// No description provided for @rehber7Baslik.
  ///
  /// In tr, this message translates to:
  /// **'7. Yavru Yok Alarmı ve Karar Önceliği'**
  String get rehber7Baslik;

  /// No description provided for @rehber7M1.
  ///
  /// In tr, this message translates to:
  /// **'Yavru yok en kritik biyolojik alarmlardan biridir. Sistem önce bunun aktif bölme, oğul sonrası veya ana kazanma penceresinde normal bekleme olup olmadığını kontrol eder.'**
  String get rehber7M1;

  /// No description provided for @rehber7M2.
  ///
  /// In tr, this message translates to:
  /// **'Bekleme penceresi aşılmışsa yavru yok; varroa, besleme ve hasat gibi rutin kararların önüne geçer. Grid kartta önce koloni devamlılığı konuşur.'**
  String get rehber7M2;

  /// No description provided for @rehber7M3.
  ///
  /// In tr, this message translates to:
  /// **'Yalancı ana şüphesi, erkek yavru baskısı, ardışık yavrusuz kayıt ve güç düşüşü birlikte görülürse sistem bunu yüksek öncelikli ana problemi olarak ele alır.'**
  String get rehber7M3;

  /// No description provided for @rehber7M4.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı içinde güçlü bal baskısı varsa yavru yokluğu hemen anasızlık sayılmaz; önce alan ve bal baskısı değerlendirilir.'**
  String get rehber7M4;

  /// No description provided for @rehber8Baslik.
  ///
  /// In tr, this message translates to:
  /// **'8. Ana Kazanma Süreci Nasıl Okunur?'**
  String get rehber8Baslik;

  /// No description provided for @rehber8M1.
  ///
  /// In tr, this message translates to:
  /// **'Ana kazanma süreci anasız bırakıldı, bölme, kapalı ana memesi veya hazır ana gibi tetiklerle başlar.'**
  String get rehber8M1;

  /// No description provided for @rehber8M2.
  ///
  /// In tr, this message translates to:
  /// **'Kendi anasını yapacak kolonide 5. gün kapalı memeler bozulur; açık/kapanmamış kaliteli memeler bırakılır.'**
  String get rehber8M2;

  /// No description provided for @rehber8M3.
  ///
  /// In tr, this message translates to:
  /// **'Hazır ana verilen kolonide süreç kabul ve yumurtlama kontrolüne göre okunur.'**
  String get rehber8M3;

  /// No description provided for @rehber8M4.
  ///
  /// In tr, this message translates to:
  /// **'Günlük veya kapalı yavru görüldüğünde ana varlığı dolaylı kabul edilir ve ilgili ana kazanma süreci kapanabilir.'**
  String get rehber8M4;

  /// No description provided for @rehber9Baslik.
  ///
  /// In tr, this message translates to:
  /// **'9. Bal Akımı 57/42 Gün Mantığı Nedir?'**
  String get rehber9Baslik;

  /// No description provided for @rehber9M1.
  ///
  /// In tr, this message translates to:
  /// **'42 gün yumurtadan tarlacı arıya uzanan biyolojik süredir.'**
  String get rehber9M1;

  /// No description provided for @rehber9M2.
  ///
  /// In tr, this message translates to:
  /// **'57 gün saha planlama eşiğidir: 42 günlük biyolojiye yaklaşık 15 gün güvenlik payı eklenir.'**
  String get rehber9M2;

  /// No description provided for @rehber9M3.
  ///
  /// In tr, this message translates to:
  /// **'Karar motoru bölme önerisini bu 57 günlük saha penceresine göre ciddiye alır. Zaman uygun değilse güçlü koloni bile otomatik bölme adayı yapılmaz.'**
  String get rehber9M3;

  /// No description provided for @rehber9M4.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımına 24 gün veya daha az kaldığında alan, kat, kalıntı güvenliği ve oğul kontrolü öne çıkar.'**
  String get rehber9M4;

  /// No description provided for @rehber9M5.
  ///
  /// In tr, this message translates to:
  /// **'Ana değişimi için en güçlü karar penceresi hasat sonrası / sonbahara giriş dönemidir.'**
  String get rehber9M5;

  /// No description provided for @rehber10Baslik.
  ///
  /// In tr, this message translates to:
  /// **'10. Varroa Uyarıları Nasıl Çalışır?'**
  String get rehber10Baslik;

  /// No description provided for @rehber10M1.
  ///
  /// In tr, this message translates to:
  /// **'Varroa uyarıları sezon ve bal akımı penceresiyle birlikte okunur.'**
  String get rehber10M1;

  /// No description provided for @rehber10M2.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı öncesi ve sırasında kalıntı riski dikkate alınır.'**
  String get rehber10M2;

  /// No description provided for @rehber10M3.
  ///
  /// In tr, this message translates to:
  /// **'Hasat sonrası / yaz sonu erken sonbahar dönemi kışı taşıyacak arıların sağlığı için kritik kabul edilir.'**
  String get rehber10M3;

  /// No description provided for @rehber10M4.
  ///
  /// In tr, this message translates to:
  /// **'Oksalik, timol, amitraz, formik ve benzeri uygulamalarda ürün etiketi, ruhsat durumu ve yerel mevzuat esas alınmalıdır.'**
  String get rehber10M4;

  /// No description provided for @rehber11Baslik.
  ///
  /// In tr, this message translates to:
  /// **'11. Veri Güveni Ne Demektir?'**
  String get rehber11Baslik;

  /// No description provided for @rehber11M1.
  ///
  /// In tr, this message translates to:
  /// **'Tek muayeneli kolonide sistem karar verir ama veri güveni düşük der.'**
  String get rehber11M1;

  /// No description provided for @rehber11M2.
  ///
  /// In tr, this message translates to:
  /// **'2–4 muayene izleme bandıdır. 5 ve üzeri muayene güvenilir değerlendirme başlangıcıdır.'**
  String get rehber11M2;

  /// No description provided for @rehber11M3.
  ///
  /// In tr, this message translates to:
  /// **'Veri güveni, kararın neden güçlü veya sınırlı olduğunu açıklamak için gösterilir; kullanıcıyı kararsız bırakmak için değildir.'**
  String get rehber11M3;

  /// No description provided for @rehber12Baslik.
  ///
  /// In tr, this message translates to:
  /// **'12. Biyolojik Model ve Kabiliyet Analizi Nedir?'**
  String get rehber12Baslik;

  /// No description provided for @rehber12M1.
  ///
  /// In tr, this message translates to:
  /// **'İTOGENA çıta sayısını yalnızca sayı olarak okumaz; standart koloni organizasyonu üzerinden tahmini kuluçkalık dizilimi, yavru bloğu, stok alanı ve hasat adayı dış çıtaları yorumlar.'**
  String get rehber12M1;

  /// No description provided for @rehber12M2.
  ///
  /// In tr, this message translates to:
  /// **'Kovan tipi Langstroth veya Dadant olarak seçilebilir. Şurupluk varsa alt kuluçkalık 9 çıta, yoksa 10 çıta kabul edilir.'**
  String get rehber12M2;

  /// No description provided for @rehber12M3.
  ///
  /// In tr, this message translates to:
  /// **'Temporal polyethism mantığıyla işçi arıların yaşa bağlı görev dağılımı tahmin edilir: bakıcı arı, petek örücü, iç işçi, tarlacı ve erkek arı yoğunluğu kabiliyet puanı olarak kullanılır.'**
  String get rehber12M3;

  /// No description provided for @rehber12M4.
  ///
  /// In tr, this message translates to:
  /// **'Sistem \"şu çıtaları hasat et\" derken kesin hüküm vermez; yalnızca tahmini yerleşime göre yavrusuz ve sırlı olması halinde hasat için değerlendirilebilecek dış/ballık çıtaları işaret eder.'**
  String get rehber12M4;

  /// No description provided for @rehber13Baslik.
  ///
  /// In tr, this message translates to:
  /// **'13. Kış Yönetimi Nasıl Çalışır?'**
  String get rehber13Baslik;

  /// No description provided for @rehber13M1.
  ///
  /// In tr, this message translates to:
  /// **'Kış döneminde ana hedef üretim değil yaşatmadır. Sistem gereksiz kovan açmayı önleyecek şekilde dış gözlem, ağırlık hissi ve nem/su girişi kontrolünü öne alır.'**
  String get rehber13M1;

  /// No description provided for @rehber13M2.
  ///
  /// In tr, this message translates to:
  /// **'Stok çok düşük görünüyorsa açlık riski minimum müdahale kuralından daha yüksek öncelik alır.'**
  String get rehber13M2;

  /// No description provided for @rehber13M3.
  ///
  /// In tr, this message translates to:
  /// **'Fiziksel hacim yüksek ama işlevsel arı gücü düşükse sistem boş hacim ve ısı kaybı riskini belirtir.'**
  String get rehber13M3;

  /// No description provided for @rehber14Baslik.
  ///
  /// In tr, this message translates to:
  /// **'14. Genetik Çoğaltma Değeri Nasıl Okunur?'**
  String get rehber14Baslik;

  /// No description provided for @rehber14M1.
  ///
  /// In tr, this message translates to:
  /// **'Genetik çoğaltma değeri yalnızca bal veya çıta sayısı değildir. İşlevsel kapasite, yavru düzeni, gelişim yönü, aktivasyon, risk, stok/kış güvenliği ve oğul izi birlikte okunur.'**
  String get rehber14M1;

  /// No description provided for @rehber14M2.
  ///
  /// In tr, this message translates to:
  /// **'Oğul kökeni veya oğul izi görülen koloniler üretimde değerli olabilir; ancak temiz genetik yayılım adayı olarak otomatik öne çıkarılmaz.'**
  String get rehber14M2;

  /// No description provided for @rehber14M3.
  ///
  /// In tr, this message translates to:
  /// **'Bu skor kesin damızlık hükmü değildir; çoğaltmaya değer kolonileri izleme ve doğru zamanda kontrollü bölme kararını destekleyen stratejik sinyaldir.'**
  String get rehber14M3;

  /// No description provided for @rehber15Baslik.
  ///
  /// In tr, this message translates to:
  /// **'15. Ekonomik Değer Neyi İfade Eder?'**
  String get rehber15Baslik;

  /// No description provided for @rehber15M1.
  ///
  /// In tr, this message translates to:
  /// **'Ekonomik değer ekranı kesin gelir hesabı değil, yaklaşık arılık varlığı ve tahmini bal potansiyeli projeksiyonudur.'**
  String get rehber15M1;

  /// No description provided for @rehber15M2.
  ///
  /// In tr, this message translates to:
  /// **'Aktif kovan sayısı, toplam arılı çıta, boş kovan, kabarmış petek ve tahmini hasat edilebilir bal potansiyeli birlikte okunur.'**
  String get rehber15M2;

  /// No description provided for @rehber15M3.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı bal kg satış fiyatını girer; sistem tahmini hasat potansiyelini bu fiyatla çarpar ve potansiyel değer bandı üretir.'**
  String get rehber15M3;

  /// No description provided for @rehber15M4.
  ///
  /// In tr, this message translates to:
  /// **'Bal verimi flora, hava, hasat zamanı, bırakılacak stok ve arıcının yönetimine bağlı olarak değişir.'**
  String get rehber15M4;

  /// No description provided for @rehber16Baslik.
  ///
  /// In tr, this message translates to:
  /// **'16. Besleme Karar Projeksiyonu Nasıl Çalışır?'**
  String get rehber16Baslik;

  /// No description provided for @rehber16M1.
  ///
  /// In tr, this message translates to:
  /// **'Besleme önerileri kesin stok ölçümü değildir; çıta gücü, yavru alanı, sezon, aktif süreç, bal akımı penceresi ve kullanıcının muayene gözlemi birlikte değerlendirilir.'**
  String get rehber16M1;

  /// No description provided for @rehber16M2.
  ///
  /// In tr, this message translates to:
  /// **'Sistem kesin reçete vermez; tahmini ml/L veya gram bandı üretir.'**
  String get rehber16M2;

  /// No description provided for @rehber16M3.
  ///
  /// In tr, this message translates to:
  /// **'1:1 şurup daha çok gelişim desteği; 2:1 şurup stok tamamlama; polenli destek ise yalnızca polen baskısı sahada doğrulanırsa anlamlı kabul edilir.'**
  String get rehber16M3;

  /// No description provided for @rehber16M4.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımına 20 gün veya daha az kalmışsa ve koloni hasat hedefindeyse şeker bazlı besleme önerilmez.'**
  String get rehber16M4;

  /// No description provided for @rehber17Baslik.
  ///
  /// In tr, this message translates to:
  /// **'17. İTOGENA Karar Sözlüğü'**
  String get rehber17Baslik;

  /// No description provided for @rehber17Kutu.
  ///
  /// In tr, this message translates to:
  /// **'Bu bölüm, ekranda görülen kavramların ne anlama geldiğini açıklar.'**
  String get rehber17Kutu;

  /// No description provided for @rehber17M1.
  ///
  /// In tr, this message translates to:
  /// **'Koloni Gidişatı: Koloninin yalnız bugünkü gücünü değil, hangi yöne ilerlediğini anlatır.'**
  String get rehber17M1;

  /// No description provided for @rehber17M2.
  ///
  /// In tr, this message translates to:
  /// **'Koloni Gücü: Son muayenedeki canlı arı ve çıta gücünü anlatır.'**
  String get rehber17M2;

  /// No description provided for @rehber17M3.
  ///
  /// In tr, this message translates to:
  /// **'Koloni Sağlığı: Yavru düzeni, ana süreci, yavrusuzluk, varroa dönemi, davranış ve risk sinyallerinin birlikte okunmasıdır.'**
  String get rehber17M3;

  /// No description provided for @rehber17M4.
  ///
  /// In tr, this message translates to:
  /// **'İşlevsel Çıta: Kovandaki fiziksel çıta sayısı değil, arının gerçekten kullandığı biyolojik kapasitedir.'**
  String get rehber17M4;

  /// No description provided for @rehber17M5.
  ///
  /// In tr, this message translates to:
  /// **'Hacim Aktivasyonu: Verilen çıta veya katın koloni tarafından ne kadar kullanılır hale geldiğini anlatır.'**
  String get rehber17M5;

  /// No description provided for @rehber17M6.
  ///
  /// In tr, this message translates to:
  /// **'Normalize Momentum: Kısa dönem çıta artışı veya düşüşünü ham şekilde okumaz. Hasat sonrası düşüş, bölme, kat geçişi ve riskli hızlı genişleme ayrılır.'**
  String get rehber17M6;

  /// No description provided for @rehber17M7.
  ///
  /// In tr, this message translates to:
  /// **'Genetik Filtre: Koloninin üretimde değerli olabileceği halde ana üretme havuzuna alınmamasıdır.'**
  String get rehber17M7;

  /// No description provided for @rehber17M8.
  ///
  /// In tr, this message translates to:
  /// **'Yönetim Kararı: Besleme, kat, alan, hasat sonrası bakım, varroa ve kış hazırlığı gibi arıcının sahada yapacağı işleri anlatır.'**
  String get rehber17M8;

  /// No description provided for @rehber17M9.
  ///
  /// In tr, this message translates to:
  /// **'Süreç: Ana kazanma, bölme sonrası toparlanma, oğul sonrası veya yavru yok tanısı gibi zamana bağlı biyolojik/yönetim penceresidir.'**
  String get rehber17M9;

  /// No description provided for @rehber17M10.
  ///
  /// In tr, this message translates to:
  /// **'Kilit / Bekle: Müdahale edilmemesi gereken hassas pencereyi anlatır.'**
  String get rehber17M10;

  /// No description provided for @rehber17M11.
  ///
  /// In tr, this message translates to:
  /// **'Veri Güveni: Kararın kaç muayeneye dayandığını anlatır.'**
  String get rehber17M11;

  /// No description provided for @rehber18Baslik.
  ///
  /// In tr, this message translates to:
  /// **'18. Uygulama Hangi Konularda Kesin Hüküm Vermez?'**
  String get rehber18Baslik;

  /// No description provided for @rehber18U1.
  ///
  /// In tr, this message translates to:
  /// **'İTOGENA veterinerlik, ruhsatlı ilaç kullanımı veya resmi mevzuat yerine geçmez.'**
  String get rehber18U1;

  /// No description provided for @rehber18U2.
  ///
  /// In tr, this message translates to:
  /// **'Kimyasal mücadelede ürün etiketi, ruhsatlı kullanım talimatı, koruyucu ekipman ve yerel mevzuat esas alınmalıdır.'**
  String get rehber18U2;

  /// No description provided for @rehber18U3.
  ///
  /// In tr, this message translates to:
  /// **'Hava, flora, yöresel nektar akımı, arıcı deneyimi ve koloni davranışı sahada ayrıca gözlenmelidir.'**
  String get rehber18U3;

  /// No description provided for @rehber18U4.
  ///
  /// In tr, this message translates to:
  /// **'Sistem doğru kararı destekler; son sorumluluk sahadaki arıcıdadır.'**
  String get rehber18U4;

  /// No description provided for @rehber19Baslik.
  ///
  /// In tr, this message translates to:
  /// **'19. Sesli Not'**
  String get rehber19Baslik;

  /// No description provided for @rehber19M1.
  ///
  /// In tr, this message translates to:
  /// **'Not alanında mikrofon ikonuna basarak konuşarak not girebilirsiniz.'**
  String get rehber19M1;

  /// No description provided for @rehber19M2.
  ///
  /// In tr, this message translates to:
  /// **'Konuşma otomatik olarak metne çevrilir ve not alanına eklenir.'**
  String get rehber19M2;

  /// No description provided for @rehber19U1.
  ///
  /// In tr, this message translates to:
  /// **'Rüzgar, arı sesi, cihaz mikrofonu ve bazı cihazlarda internet bağlantısı algılamayı etkileyebilir.'**
  String get rehber19U1;

  /// No description provided for @rehber20Baslik.
  ///
  /// In tr, this message translates to:
  /// **'20. Gizlilik Politikası'**
  String get rehber20Baslik;

  /// No description provided for @rehber20M1.
  ///
  /// In tr, this message translates to:
  /// **'İTOGENA\'nın kişisel veri işleme, saklama ve kullanım politikasını aşağıdaki bağlantıdan okuyabilirsiniz.'**
  String get rehber20M1;

  /// No description provided for @rehber20Link.
  ///
  /// In tr, this message translates to:
  /// **'itogaciftligi.com/itogena-gizlilik-politikasi'**
  String get rehber20Link;

  /// No description provided for @kolonGridYavruYok.
  ///
  /// In tr, this message translates to:
  /// **'Yavru yok'**
  String get kolonGridYavruYok;

  /// No description provided for @kolonGridMemeKontrol.
  ///
  /// In tr, this message translates to:
  /// **'Meme kontrolü'**
  String get kolonGridMemeKontrol;

  /// No description provided for @kolonGridYalanciAna.
  ///
  /// In tr, this message translates to:
  /// **'Yalancı ana riski'**
  String get kolonGridYalanciAna;

  /// No description provided for @kolonGridBeklemeSureci.
  ///
  /// In tr, this message translates to:
  /// **'Bekleme süreci'**
  String get kolonGridBeklemeSureci;

  /// No description provided for @kolonGridSurecIzleniyor.
  ///
  /// In tr, this message translates to:
  /// **'Süreç izleniyor'**
  String get kolonGridSurecIzleniyor;

  /// No description provided for @kolonGridUcuncuKat.
  ///
  /// In tr, this message translates to:
  /// **'3. kat ver'**
  String get kolonGridUcuncuKat;

  /// No description provided for @kolonGridAlanAc.
  ///
  /// In tr, this message translates to:
  /// **'Alan aç'**
  String get kolonGridAlanAc;

  /// No description provided for @kolonGridKatVer.
  ///
  /// In tr, this message translates to:
  /// **'Kat ver'**
  String get kolonGridKatVer;

  /// No description provided for @kolonDetaySurecYok.
  ///
  /// In tr, this message translates to:
  /// **'Aktif süreç yok'**
  String get kolonDetaySurecYok;

  /// No description provided for @kolonDetayKritikUyariYok.
  ///
  /// In tr, this message translates to:
  /// **'Kritik uyarı görünmüyor'**
  String get kolonDetayKritikUyariYok;

  /// No description provided for @kolonDetayNormalTakip.
  ///
  /// In tr, this message translates to:
  /// **'Normal takip'**
  String get kolonDetayNormalTakip;

  /// No description provided for @kolonDetaySurecTakibiGerekli.
  ///
  /// In tr, this message translates to:
  /// **'Süreç takibi gerekli.'**
  String get kolonDetaySurecTakibiGerekli;

  /// No description provided for @kolonDetayOncelik.
  ///
  /// In tr, this message translates to:
  /// **'Öncelik {oncelik}/100'**
  String kolonDetayOncelik(int oncelik);

  /// No description provided for @kolonDetayDetaylariAc.
  ///
  /// In tr, this message translates to:
  /// **'Detayları aç'**
  String get kolonDetayDetaylariAc;

  /// No description provided for @kolonDetayGereksizAcma.
  ///
  /// In tr, this message translates to:
  /// **'Koloniyi gereksiz açma'**
  String get kolonDetayGereksizAcma;

  /// No description provided for @kolonDetayKoloniAcma.
  ///
  /// In tr, this message translates to:
  /// **'Koloniyi açma'**
  String get kolonDetayKoloniAcma;

  /// No description provided for @kolonDetayMudahaleEtme.
  ///
  /// In tr, this message translates to:
  /// **'Müdahale etme'**
  String get kolonDetayMudahaleEtme;

  /// No description provided for @kolonDetayMemeSayisiKontrol.
  ///
  /// In tr, this message translates to:
  /// **'Meme sayısını kontrol et'**
  String get kolonDetayMemeSayisiKontrol;

  /// No description provided for @kolonDetayBirlestir.
  ///
  /// In tr, this message translates to:
  /// **'Birleştirmeyi değerlendir'**
  String get kolonDetayBirlestir;

  /// No description provided for @kolonDetayAlanKontrol.
  ///
  /// In tr, this message translates to:
  /// **'Alanı kontrol et'**
  String get kolonDetayAlanKontrol;

  /// No description provided for @kolonDetayAnaKarar.
  ///
  /// In tr, this message translates to:
  /// **'Ana kararını değerlendir'**
  String get kolonDetayAnaKarar;

  /// No description provided for @kolonDetayTekrarKontrol.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar kontrol et'**
  String get kolonDetayTekrarKontrol;

  /// No description provided for @kolonDetayBolmeNetlestir.
  ///
  /// In tr, this message translates to:
  /// **'Bölme kararını netleştir'**
  String get kolonDetayBolmeNetlestir;

  /// No description provided for @kolonDetayKontrolEt.
  ///
  /// In tr, this message translates to:
  /// **'Kontrol et'**
  String get kolonDetayKontrolEt;

  /// No description provided for @kolonDetayYakinTakip.
  ///
  /// In tr, this message translates to:
  /// **'Yakından takip et'**
  String get kolonDetayYakinTakip;

  /// No description provided for @kolonDetayAktifSurecMetni.
  ///
  /// In tr, this message translates to:
  /// **'Aktif süreç'**
  String get kolonDetayAktifSurecMetni;

  /// No description provided for @kolonDetayOkunamadi.
  ///
  /// In tr, this message translates to:
  /// **'Okunamadı'**
  String get kolonDetayOkunamadi;

  /// No description provided for @kolonDetayAktivasyonHata.
  ///
  /// In tr, this message translates to:
  /// **'Aktivasyon hesabı hatalı'**
  String get kolonDetayAktivasyonHata;

  /// No description provided for @kolonDetayBiyolojiYukleniyor.
  ///
  /// In tr, this message translates to:
  /// **'Hazırlanıyor'**
  String get kolonDetayBiyolojiYukleniyor;

  /// No description provided for @kolonDetayAktivasyonYukleniyor.
  ///
  /// In tr, this message translates to:
  /// **'Aktivasyon yükleniyor'**
  String get kolonDetayAktivasyonYukleniyor;

  /// No description provided for @kolonDetayArkaPlanda.
  ///
  /// In tr, this message translates to:
  /// **'Arka planda'**
  String get kolonDetayArkaPlanda;

  /// No description provided for @kolonDetayHacimYuzde.
  ///
  /// In tr, this message translates to:
  /// **'Hacim %{yuzde}'**
  String kolonDetayHacimYuzde(int yuzde);

  /// No description provided for @kolonDetayHacimDetay.
  ///
  /// In tr, this message translates to:
  /// **'{fiziksel} → {islevsel} çıta'**
  String kolonDetayHacimDetay(int fiziksel, String islevsel);

  /// No description provided for @kolonDetayIslevselOkunuyor.
  ///
  /// In tr, this message translates to:
  /// **'İşlevsel hacim okunuyor'**
  String get kolonDetayIslevselOkunuyor;

  /// No description provided for @kolonDetayAktivasyonAlanDolu.
  ///
  /// In tr, this message translates to:
  /// **'alan dolu'**
  String get kolonDetayAktivasyonAlanDolu;

  /// No description provided for @kolonDetayAktivasyonTamamlaniyor.
  ///
  /// In tr, this message translates to:
  /// **'tamamlanıyor'**
  String get kolonDetayAktivasyonTamamlaniyor;

  /// No description provided for @kolonDetayAktivasyonIyi.
  ///
  /// In tr, this message translates to:
  /// **'iyi'**
  String get kolonDetayAktivasyonIyi;

  /// No description provided for @kolonDetayAktivasyonOrta.
  ///
  /// In tr, this message translates to:
  /// **'orta'**
  String get kolonDetayAktivasyonOrta;

  /// No description provided for @kolonDetayAktivasyonDusuk.
  ///
  /// In tr, this message translates to:
  /// **'düşük'**
  String get kolonDetayAktivasyonDusuk;

  /// No description provided for @kolonDetayAktivasyonCokDusuk.
  ///
  /// In tr, this message translates to:
  /// **'çok düşük'**
  String get kolonDetayAktivasyonCokDusuk;

  /// No description provided for @kolonDetayYonetimDip.
  ///
  /// In tr, this message translates to:
  /// **'Yönetim'**
  String get kolonDetayYonetimDip;

  /// No description provided for @kolonDetayKararHatasi.
  ///
  /// In tr, this message translates to:
  /// **'Karar hatası'**
  String get kolonDetayKararHatasi;

  /// No description provided for @kolonDetayYonetimOkunamadi.
  ///
  /// In tr, this message translates to:
  /// **'Yönetim kararları okunamadı'**
  String get kolonDetayYonetimOkunamadi;

  /// No description provided for @kolonDetayYonetimYok.
  ///
  /// In tr, this message translates to:
  /// **'Yönetim yok'**
  String get kolonDetayYonetimYok;

  /// No description provided for @kolonDetayMudahaleYok.
  ///
  /// In tr, this message translates to:
  /// **'Öne çıkan saha müdahalesi görünmüyor'**
  String get kolonDetayMudahaleYok;

  /// No description provided for @kolonDetayTakipDip.
  ///
  /// In tr, this message translates to:
  /// **'Takip'**
  String get kolonDetayTakipDip;

  /// No description provided for @kolonDetayGenetikBekleniyor.
  ///
  /// In tr, this message translates to:
  /// **'Genetik bekleniyor'**
  String get kolonDetayGenetikBekleniyor;

  /// No description provided for @kolonDetaySecilimArkaPlanda.
  ///
  /// In tr, this message translates to:
  /// **'Seçilim bilgisi arka planda hazırlanıyor.'**
  String get kolonDetaySecilimArkaPlanda;

  /// No description provided for @kolonDetaySecilimAyri.
  ///
  /// In tr, this message translates to:
  /// **'Seçilim ayrı okunacak'**
  String get kolonDetaySecilimAyri;

  /// No description provided for @kolonDetaySecilimYukleniyor.
  ///
  /// In tr, this message translates to:
  /// **'Seçilim yükleniyor'**
  String get kolonDetaySecilimYukleniyor;

  /// No description provided for @kolonDetayDonorDisi.
  ///
  /// In tr, this message translates to:
  /// **'Donör dışı'**
  String get kolonDetayDonorDisi;

  /// No description provided for @kolonDetayOgulVeto.
  ///
  /// In tr, this message translates to:
  /// **'Oğul izi / veto'**
  String get kolonDetayOgulVeto;

  /// No description provided for @kolonDetayUretimDegerlendir.
  ///
  /// In tr, this message translates to:
  /// **'Üretimde değerlendir'**
  String get kolonDetayUretimDegerlendir;

  /// No description provided for @kolonDetayVetoVar.
  ///
  /// In tr, this message translates to:
  /// **'Veto bilgisi var'**
  String get kolonDetayVetoVar;

  /// No description provided for @kolonDetayDonorAdayi.
  ///
  /// In tr, this message translates to:
  /// **'Donör adayı'**
  String get kolonDetayDonorAdayi;

  /// No description provided for @kolonDetaySoyTakibi.
  ///
  /// In tr, this message translates to:
  /// **'Soy takibi uygun'**
  String get kolonDetaySoyTakibi;

  /// No description provided for @kolonDetayUretimKolonisi.
  ///
  /// In tr, this message translates to:
  /// **'Üretim kolonisi'**
  String get kolonDetayUretimKolonisi;

  /// No description provided for @kolonDetaySahaRolUretim.
  ///
  /// In tr, this message translates to:
  /// **'Saha rolü üretim'**
  String get kolonDetaySahaRolUretim;

  /// No description provided for @kolonDetayDestekKolonisi.
  ///
  /// In tr, this message translates to:
  /// **'Destek kolonisi'**
  String get kolonDetayDestekKolonisi;

  /// No description provided for @kolonDetayDestekRolu.
  ///
  /// In tr, this message translates to:
  /// **'Destek rolü'**
  String get kolonDetayDestekRolu;

  /// No description provided for @kolonDetayVetoBilgisi.
  ///
  /// In tr, this message translates to:
  /// **'Veto bilgisi'**
  String get kolonDetayVetoBilgisi;

  /// No description provided for @kolonDetayDonorBilgisi.
  ///
  /// In tr, this message translates to:
  /// **'Donör bilgisi'**
  String get kolonDetayDonorBilgisi;

  /// No description provided for @kolonDetayUretimRolu.
  ///
  /// In tr, this message translates to:
  /// **'Üretim rolü'**
  String get kolonDetayUretimRolu;

  /// No description provided for @kolonDetaySecilimDip.
  ///
  /// In tr, this message translates to:
  /// **'Seçilim'**
  String get kolonDetaySecilimDip;

  /// No description provided for @kolonDetayYonetimKararlari.
  ///
  /// In tr, this message translates to:
  /// **'Yönetim kararları'**
  String get kolonDetayYonetimKararlari;

  /// No description provided for @kolonDetayYonetimKarari.
  ///
  /// In tr, this message translates to:
  /// **'Yönetim kararı'**
  String get kolonDetayYonetimKarari;

  /// No description provided for @kolonDetayGenetikDegerlendirme.
  ///
  /// In tr, this message translates to:
  /// **'Genetik değerlendirme'**
  String get kolonDetayGenetikDegerlendirme;

  /// No description provided for @muayeneSecYavruYok.
  ///
  /// In tr, this message translates to:
  /// **'Yok'**
  String get muayeneSecYavruYok;

  /// No description provided for @muayeneSecYavruBlok.
  ///
  /// In tr, this message translates to:
  /// **'Blok'**
  String get muayeneSecYavruBlok;

  /// No description provided for @muayeneSecYavruNormal.
  ///
  /// In tr, this message translates to:
  /// **'Normal'**
  String get muayeneSecYavruNormal;

  /// No description provided for @muayeneSecYavruDaginik.
  ///
  /// In tr, this message translates to:
  /// **'Dağınık'**
  String get muayeneSecYavruDaginik;

  /// No description provided for @muayeneSecYavruKambur.
  ///
  /// In tr, this message translates to:
  /// **'Kambur'**
  String get muayeneSecYavruKambur;

  /// No description provided for @muayeneSecMizacSakin.
  ///
  /// In tr, this message translates to:
  /// **'Sakin'**
  String get muayeneSecMizacSakin;

  /// No description provided for @muayeneSecMizacSinirli.
  ///
  /// In tr, this message translates to:
  /// **'Sinirli'**
  String get muayeneSecMizacSinirli;

  /// No description provided for @muayeneSecMizacSaldirgan.
  ///
  /// In tr, this message translates to:
  /// **'Saldırgan'**
  String get muayeneSecMizacSaldirgan;

  /// No description provided for @muayeneSecBeslemeYok.
  ///
  /// In tr, this message translates to:
  /// **'Yok'**
  String get muayeneSecBeslemeYok;

  /// No description provided for @muayeneSecBesleme11.
  ///
  /// In tr, this message translates to:
  /// **'1:1 Şurup'**
  String get muayeneSecBesleme11;

  /// No description provided for @muayeneSecBesleme21.
  ///
  /// In tr, this message translates to:
  /// **'2:1 Şurup'**
  String get muayeneSecBesleme21;

  /// No description provided for @muayeneSecBeslemeKek.
  ///
  /// In tr, this message translates to:
  /// **'Kek'**
  String get muayeneSecBeslemeKek;

  /// No description provided for @muayeneSecBeslemeFondan.
  ///
  /// In tr, this message translates to:
  /// **'Fondan'**
  String get muayeneSecBeslemeFondan;

  /// No description provided for @muayeneSecVarroaYok.
  ///
  /// In tr, this message translates to:
  /// **'Yok'**
  String get muayeneSecVarroaYok;

  /// No description provided for @muayeneSecVarroaDrone.
  ///
  /// In tr, this message translates to:
  /// **'Drone Kesimi'**
  String get muayeneSecVarroaDrone;

  /// No description provided for @muayeneSecVarroaBolme.
  ///
  /// In tr, this message translates to:
  /// **'Bölme'**
  String get muayeneSecVarroaBolme;

  /// No description provided for @muayeneSecVarroaTimol.
  ///
  /// In tr, this message translates to:
  /// **'Timol'**
  String get muayeneSecVarroaTimol;

  /// No description provided for @muayeneSecVarroaAmitraz.
  ///
  /// In tr, this message translates to:
  /// **'Amitraz'**
  String get muayeneSecVarroaAmitraz;

  /// No description provided for @muayeneSecVarroaFormik.
  ///
  /// In tr, this message translates to:
  /// **'Formik'**
  String get muayeneSecVarroaFormik;

  /// No description provided for @muayeneSecVarroaOksalik.
  ///
  /// In tr, this message translates to:
  /// **'Oksalik'**
  String get muayeneSecVarroaOksalik;

  /// No description provided for @srvKoloniAktifDegil.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni aktif değil'**
  String get srvKoloniAktifDegil;

  /// No description provided for @srvPasifKayit.
  ///
  /// In tr, this message translates to:
  /// **'Pasif kayıt'**
  String get srvPasifKayit;

  /// No description provided for @srvDonorHavuzunda.
  ///
  /// In tr, this message translates to:
  /// **'Donör havuzunda'**
  String get srvDonorHavuzunda;

  /// No description provided for @srvBolmeUygun.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni bölme için uygun görünüyor'**
  String get srvBolmeUygun;

  /// No description provided for @srvBolmeSinirinda.
  ///
  /// In tr, this message translates to:
  /// **'Bölme için güç sınırında'**
  String get srvBolmeSinirinda;

  /// No description provided for @srvBolmeOnerilmez.
  ///
  /// In tr, this message translates to:
  /// **'Bölme önerilmez'**
  String get srvBolmeOnerilmez;

  /// No description provided for @srvBolmeZayif.
  ///
  /// In tr, this message translates to:
  /// **'Güç var; standart bölme zamanı zayıf'**
  String get srvBolmeZayif;

  /// No description provided for @srvYakindanBak.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloniye yakından bakmak gerekir'**
  String get srvYakindanBak;

  /// No description provided for @srvIzleyerek.
  ///
  /// In tr, this message translates to:
  /// **'İzleyerek karar ver'**
  String get srvIzleyerek;

  /// No description provided for @srvDestekUretim.
  ///
  /// In tr, this message translates to:
  /// **'Destek / üretim rolü'**
  String get srvDestekUretim;

  /// No description provided for @srvVeriGuveniDusuk.
  ///
  /// In tr, this message translates to:
  /// **'Veri güveni düşük'**
  String get srvVeriGuveniDusuk;

  /// No description provided for @srvKararVarVeriDusuk.
  ///
  /// In tr, this message translates to:
  /// **'Karar var; veri güveni düşük'**
  String get srvKararVarVeriDusuk;

  /// No description provided for @srvAnaKazanma.
  ///
  /// In tr, this message translates to:
  /// **'Ana Kazanma'**
  String get srvAnaKazanma;

  /// No description provided for @srvBolmeSonrasi.
  ///
  /// In tr, this message translates to:
  /// **'Bölme Sonrası'**
  String get srvBolmeSonrasi;

  /// No description provided for @srvKisYonetimi.
  ///
  /// In tr, this message translates to:
  /// **'Kış Yönetimi'**
  String get srvKisYonetimi;

  /// No description provided for @srvBakimSureci.
  ///
  /// In tr, this message translates to:
  /// **'Bakım Süreci'**
  String get srvBakimSureci;

  /// No description provided for @srvGelisimDonemi.
  ///
  /// In tr, this message translates to:
  /// **'Gelişim Dönemi'**
  String get srvGelisimDonemi;

  /// No description provided for @srvUretimDonemi.
  ///
  /// In tr, this message translates to:
  /// **'Üretim Dönemi'**
  String get srvUretimDonemi;

  /// No description provided for @srvHasatHazirlik.
  ///
  /// In tr, this message translates to:
  /// **'Hasat Hazırlığı'**
  String get srvHasatHazirlik;

  /// No description provided for @srvHasatSonrasiBakim.
  ///
  /// In tr, this message translates to:
  /// **'Hasat Sonrası Bakım'**
  String get srvHasatSonrasiBakim;

  /// No description provided for @srvOgulSonrasi.
  ///
  /// In tr, this message translates to:
  /// **'Oğul Sonrası'**
  String get srvOgulSonrasi;

  /// No description provided for @srvVarroaYonetimi.
  ///
  /// In tr, this message translates to:
  /// **'Varroa Yönetimi'**
  String get srvVarroaYonetimi;

  /// No description provided for @srvSahadaOncelik.
  ///
  /// In tr, this message translates to:
  /// **'Sahada Öncelik'**
  String get srvSahadaOncelik;

  /// No description provided for @srvBiyolojikNot.
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik Not'**
  String get srvBiyolojikNot;

  /// No description provided for @trendVeriYok.
  ///
  /// In tr, this message translates to:
  /// **'Veri Yok'**
  String get trendVeriYok;

  /// No description provided for @trendStabil.
  ///
  /// In tr, this message translates to:
  /// **'Stabil'**
  String get trendStabil;

  /// No description provided for @trendYukselis.
  ///
  /// In tr, this message translates to:
  /// **'Yükseliş'**
  String get trendYukselis;

  /// No description provided for @trendDusus.
  ///
  /// In tr, this message translates to:
  /// **'Düşüş'**
  String get trendDusus;

  /// No description provided for @trendSonmus.
  ///
  /// In tr, this message translates to:
  /// **'Sönmüş'**
  String get trendSonmus;

  /// No description provided for @trendKontrolluBolme.
  ///
  /// In tr, this message translates to:
  /// **'Kontrollü Bölme'**
  String get trendKontrolluBolme;

  /// No description provided for @trendBolmeSonrasiIzleme.
  ///
  /// In tr, this message translates to:
  /// **'Bölme Sonrası İzleme'**
  String get trendBolmeSonrasiIzleme;

  /// No description provided for @trendGucluBiyolojikYon.
  ///
  /// In tr, this message translates to:
  /// **'Güçlü Biyolojik Yön'**
  String get trendGucluBiyolojikYon;

  /// No description provided for @trendHasatSonrasiStabil.
  ///
  /// In tr, this message translates to:
  /// **'Hasat Sonrası Stabil'**
  String get trendHasatSonrasiStabil;

  /// No description provided for @trendYavasGelisim.
  ///
  /// In tr, this message translates to:
  /// **'Yavaş Gelişim'**
  String get trendYavasGelisim;

  /// No description provided for @trendHenuzMuayeneYok.
  ///
  /// In tr, this message translates to:
  /// **'Henüz muayene verisi bulunmuyor.'**
  String get trendHenuzMuayeneYok;

  /// No description provided for @trendMomentumKovanSondu.
  ///
  /// In tr, this message translates to:
  /// **'Kovan sönmüş işaretlendi; momentum gerçek biyolojik kayıp olarak okunur.'**
  String get trendMomentumKovanSondu;

  /// No description provided for @trendMomentumBolme.
  ///
  /// In tr, this message translates to:
  /// **'Bölme kaydı nedeniyle çıta düşüşü biyolojik zayıflama sayılmadı.'**
  String get trendMomentumBolme;

  /// No description provided for @trendMomentumHasat.
  ///
  /// In tr, this message translates to:
  /// **'Bal/hasat kaydı nedeniyle çıta düşüşü biyolojik momentum cezası sayılmadı.'**
  String get trendMomentumHasat;

  /// No description provided for @trendMomentumFizikselDegismedi.
  ///
  /// In tr, this message translates to:
  /// **'Fiziksel hacim değişmedi; momentum nötr okundu.'**
  String get trendMomentumFizikselDegismedi;

  /// No description provided for @trendMomentumHizliArtis.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı hacim artışı aktivasyon tamamlanmadan gerçek büyüme sayılmadı.'**
  String get trendMomentumHizliArtis;

  /// No description provided for @trendMomentumKatGecisi.
  ///
  /// In tr, this message translates to:
  /// **'Kat/ballık geçişi fiziksel hacim artışı olarak görüldü; biyolojik momentum temkinli normalleştirildi.'**
  String get trendMomentumKatGecisi;

  /// No description provided for @trendMomentumDusukAktivasyon.
  ///
  /// In tr, this message translates to:
  /// **'Yeni hacmin aktivasyonu düşük olduğu için büyüme sinyali frenlendi.'**
  String get trendMomentumDusukAktivasyon;

  /// No description provided for @trendMomentumBalAkimi.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı içinde sağlıklı üst hacim genişlemesi biyolojik üretim yönü olarak okundu.'**
  String get trendMomentumBalAkimi;

  /// No description provided for @trendMomentumNormalize.
  ///
  /// In tr, this message translates to:
  /// **'Fiziksel artış işlevsel kapasiteye göre normalize edildi.'**
  String get trendMomentumNormalize;

  /// No description provided for @surecOgulRiski.
  ///
  /// In tr, this message translates to:
  /// **'Oğul riski'**
  String get surecOgulRiski;

  /// No description provided for @surecOgulRiskiTakip.
  ///
  /// In tr, this message translates to:
  /// **'Oğul riski takibi'**
  String get surecOgulRiskiTakip;

  /// No description provided for @surecTekrarlayanOgul.
  ///
  /// In tr, this message translates to:
  /// **'Tekrarlayan oğul / nüfus kaybı riski'**
  String get surecTekrarlayanOgul;

  /// No description provided for @surecOgulSonrasiArtciYuksek.
  ///
  /// In tr, this message translates to:
  /// **'Oğul sonrası artçı riski yüksek'**
  String get surecOgulSonrasiArtciYuksek;

  /// No description provided for @surecArtciOgulIzleniyor.
  ///
  /// In tr, this message translates to:
  /// **'Artçı oğul riski izleniyor'**
  String get surecArtciOgulIzleniyor;

  /// No description provided for @surecOgulSonrasiAnaCiftlesme.
  ///
  /// In tr, this message translates to:
  /// **'Oğul sonrası ana / çiftleşme süreci'**
  String get surecOgulSonrasiAnaCiftlesme;

  /// No description provided for @surecOgulSonrasiYumurtlamaKontrol.
  ///
  /// In tr, this message translates to:
  /// **'Oğul sonrası yumurtlama kontrolü'**
  String get surecOgulSonrasiYumurtlamaKontrol;

  /// No description provided for @surecBolmeSonrasiToparlanma.
  ///
  /// In tr, this message translates to:
  /// **'Bölme sonrası toparlanma'**
  String get surecBolmeSonrasiToparlanma;

  /// No description provided for @surecHasatSonrasiBakimGerekli.
  ///
  /// In tr, this message translates to:
  /// **'Hasat sonrası bakım gerekli'**
  String get surecHasatSonrasiBakimGerekli;

  /// No description provided for @surecGelisimYavas.
  ///
  /// In tr, this message translates to:
  /// **'Gelişim yavaş görünüyor'**
  String get surecGelisimYavas;

  /// No description provided for @surecMesajOgulRiski1.
  ///
  /// In tr, this message translates to:
  /// **'Ana memesi görüldü. Bu sağlık sorunu değil, oğul davranışı ve koloni sıkışıklığı işaretidir. Koloniyi sakin biçimde kontrol et; gerekiyorsa bölme yap veya 1–2 kaliteli meme bırakıp fazlasını azalt.'**
  String get surecMesajOgulRiski1;

  /// No description provided for @surecMesajOgulRiski2.
  ///
  /// In tr, this message translates to:
  /// **'İlk hafta artçı oğul riski yüksektir. Meme sayısını kontrol et; birden fazla güçlü meme bırakmak koloniyi tekrar bölebilir. Gerekiyorsa bölme veya fazla memeleri azaltma kararı ver.'**
  String get surecMesajOgulRiski2;

  /// No description provided for @surecMesajOgulRiskiTakip.
  ///
  /// In tr, this message translates to:
  /// **'Oğul belirtisi takip döneminde. Yeni meme, sıkışıklık veya huzursuzluk yoksa süreç kendiliğinden sönümlenir; gereksiz tekrar uyarı üretmez.'**
  String get surecMesajOgulRiskiTakip;

  /// No description provided for @surecMesajTekrarlayanOgul.
  ///
  /// In tr, this message translates to:
  /// **'Oğul kaydı tekrar ediyor. Bu artık normal artçı takibi değil; koloni hızla nüfus kaybedebilir. Meme sayısı, kalan arı gücü, stok ve ana belirtisi birlikte okunmalı. Çok zayıfladıysa yoğun emek yerine birleştirme veya sınırlı destek daha doğru olabilir.'**
  String get surecMesajTekrarlayanOgul;

  /// No description provided for @surecMesajArtciYuksek.
  ///
  /// In tr, this message translates to:
  /// **'Oğul sonrası ilk hafta artçı oğul riski yüksektir. Amaç koloniyi tekrar böldürmemektir. Kontrol gerekiyorsa kısa ve sakin yapılmalı; fazla meme bırakmak tekrar nüfus kaybı doğurabilir. Üretim/kat/hasat kararı geri plandadır.'**
  String get surecMesajArtciYuksek;

  /// No description provided for @surecMesajArtciIzleniyor.
  ///
  /// In tr, this message translates to:
  /// **'Artçı oğul riski devam eder ama ilk haftaya göre azalır. Yeni meme, huzursuzluk veya tekrar çıkış belirtisi yoksa ana sürecini bozmadan beklemek daha doğrudur. Günlük veya kapalı yavru görülürse süreç kapanır.'**
  String get surecMesajArtciIzleniyor;

  /// No description provided for @surecMesajAnaCiftlesme.
  ///
  /// In tr, this message translates to:
  /// **'Artçı riski büyük ölçüde kapanır. Bu dönem yeni ana çıkışı, olgunlaşma ve çiftleşme penceresidir. Yavru hâlâ görülmeyebilir; bu tek başına çöküş sayılmaz. Dış uçuş, polen gelişi ve sakinlik izlenir. Günlük veya kapalı yavru görülürse muayenede işaretle, süreç kapanır.'**
  String get surecMesajAnaCiftlesme;

  /// No description provided for @surecMesajYumurtlamaKontrol.
  ///
  /// In tr, this message translates to:
  /// **'Oğul sonrası 31–45. gün arası artık yumurtlama netleşmelidir. Günlük veya kapalı yavru görülürse süreç kapanır. Hâlâ yavru yoksa bu süreç normal bekleme olmaktan çıkar; ana başarısızlığı, çiftleşme kaybı veya yalancı ana riski yavru-yok tanısı ile öne alınır.'**
  String get surecMesajYumurtlamaKontrol;

  /// No description provided for @surecMesajBolmeErken.
  ///
  /// In tr, this message translates to:
  /// **'Koloniyi sıkışık tut ve besleme yap. Yeni düzen kurulana kadar destek gerekir.'**
  String get surecMesajBolmeErken;

  /// No description provided for @surecMesajBolmeGecikti.
  ///
  /// In tr, this message translates to:
  /// **'Ana durumunu kontrol et. Toparlanma gecikmiş olabilir.'**
  String get surecMesajBolmeGecikti;

  /// No description provided for @kabiliyetBiyolojikBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik Kabiliyet'**
  String get kabiliyetBiyolojikBaslik;

  /// No description provided for @kabiliyetBiyolojikMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Petek örme kapasitesi güçlü görünüyor. Ham petek verilecekse yavru bloğu kesilmeden dıştan genişletme daha güvenlidir.'**
  String get kabiliyetBiyolojikMesaj;

  /// No description provided for @kabiliyetGenisletmeRiskiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Genişletme Riski'**
  String get kabiliyetGenisletmeRiskiBaslik;

  /// No description provided for @kabiliyetGenisletmeRiskiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Petek örme kapasitesi sınırlı görünüyor. Ham petek yerine kabarmış petek veya sıkı düzen daha güvenlidir.'**
  String get kabiliyetGenisletmeRiskiMesaj;

  /// No description provided for @kabiliyetBalAkimiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bal Akımı Kapasitesi'**
  String get kabiliyetBalAkimiBaslik;

  /// No description provided for @kabiliyetBalAkimiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Tarlacı ve bal işleme kapasitesi güçlü görünüyor. Bal akımı döneminde alan, kat ve sırlanma takibi öne alınmalı.'**
  String get kabiliyetBalAkimiMesaj;

  /// No description provided for @kabiliyetBakiciDengeBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bakıcı Dengesi'**
  String get kabiliyetBakiciDengeBaslik;

  /// No description provided for @kabiliyetBakiciDengeMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Yavru bakım kapasitesi iyi fakat petek örme sınırlı. Yavru alanını bozmayacak kabarmış petek, ham petekten daha güvenli olur.'**
  String get kabiliyetBakiciDengeMesaj;

  /// No description provided for @kabiliyetKisGuvenligiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kış Güvenliği'**
  String get kabiliyetKisGuvenligiBaslik;

  /// No description provided for @kabiliyetKisGuvenligiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Kış dayanımı sınırlı görünüyor. Öncelik hasat veya genişletme değil stok güvenliği ve sıkı düzendir.'**
  String get kabiliyetKisGuvenligiMesaj;

  /// No description provided for @kabiliyetBiyolojikSahaNotBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik Saha Notu'**
  String get kabiliyetBiyolojikSahaNotBaslik;

  /// No description provided for @kararAsBiyolojikYon.
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik yön'**
  String get kararAsBiyolojikYon;

  /// No description provided for @perfKriterUreme.
  ///
  /// In tr, this message translates to:
  /// **'Üreme'**
  String get perfKriterUreme;

  /// No description provided for @perfKriterUretim.
  ///
  /// In tr, this message translates to:
  /// **'Üretim'**
  String get perfKriterUretim;

  /// No description provided for @perfKriterDayaniklilik.
  ///
  /// In tr, this message translates to:
  /// **'Dayanıklılık'**
  String get perfKriterDayaniklilik;

  /// No description provided for @perfKriterDavranis.
  ///
  /// In tr, this message translates to:
  /// **'Davranış'**
  String get perfKriterDavranis;

  /// No description provided for @perfKriterHatGucu.
  ///
  /// In tr, this message translates to:
  /// **'Hat Gücü'**
  String get perfKriterHatGucu;

  /// No description provided for @perfKriterVeriGuveni.
  ///
  /// In tr, this message translates to:
  /// **'Veri Güveni'**
  String get perfKriterVeriGuveni;

  /// No description provided for @perfKriterBiyolojikDurum.
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik Durum'**
  String get perfKriterBiyolojikDurum;

  /// No description provided for @perfKriterKoloniGidisati.
  ///
  /// In tr, this message translates to:
  /// **'Koloni Gidişatı'**
  String get perfKriterKoloniGidisati;

  /// No description provided for @perfKriterHacimAktivasyonu.
  ///
  /// In tr, this message translates to:
  /// **'Hacim Aktivasyonu'**
  String get perfKriterHacimAktivasyonu;

  /// No description provided for @perfKriterPetekOrme.
  ///
  /// In tr, this message translates to:
  /// **'Petek Örme Kapasitesi'**
  String get perfKriterPetekOrme;

  /// No description provided for @perfKriterYavruBakim.
  ///
  /// In tr, this message translates to:
  /// **'Yavru Bakım Kapasitesi'**
  String get perfKriterYavruBakim;

  /// No description provided for @perfKriterBalAkimi.
  ///
  /// In tr, this message translates to:
  /// **'Bal Akımı Kapasitesi'**
  String get perfKriterBalAkimi;

  /// No description provided for @perfKriterKisGuvenligi.
  ///
  /// In tr, this message translates to:
  /// **'Kış Güvenliği'**
  String get perfKriterKisGuvenligi;

  /// No description provided for @yorumVeriYok.
  ///
  /// In tr, this message translates to:
  /// **'Veri yok; karar yalnızca kimlik ve kaynak bilgisine göre sınırlıdır.'**
  String get yorumVeriYok;

  /// No description provided for @yorumVeriCokSinirli.
  ///
  /// In tr, this message translates to:
  /// **'Veri çok sınırlı; sistem karar verir ama güven düzeyi düşüktür.'**
  String get yorumVeriCokSinirli;

  /// No description provided for @yorumVeriIzlenmeli.
  ///
  /// In tr, this message translates to:
  /// **'Veri izlenmeli; karar var ama sonraki muayenelerle güçlenmelidir.'**
  String get yorumVeriIzlenmeli;

  /// No description provided for @yorumVeriYeterli.
  ///
  /// In tr, this message translates to:
  /// **'Veri güveni yeterli; değerlendirme güvenilir banda girmiştir.'**
  String get yorumVeriYeterli;

  /// No description provided for @yorumYetersizVeri.
  ///
  /// In tr, this message translates to:
  /// **'Henüz değerlendirilebilir türeyen koloni verisi yok.'**
  String get yorumYetersizVeri;

  /// No description provided for @yorumKararYetersiz.
  ///
  /// In tr, this message translates to:
  /// **'Karar üretmek için yeterli veri yok.'**
  String get yorumKararYetersiz;

  /// No description provided for @soyDurumVeriYok.
  ///
  /// In tr, this message translates to:
  /// **'Veri Yok'**
  String get soyDurumVeriYok;

  /// No description provided for @soyDurumVeriYetersiz.
  ///
  /// In tr, this message translates to:
  /// **'Veri Yetersiz'**
  String get soyDurumVeriYetersiz;

  /// No description provided for @soyDurumGucluSoy.
  ///
  /// In tr, this message translates to:
  /// **'Güçlü Soy'**
  String get soyDurumGucluSoy;

  /// No description provided for @soyDurumOlumluSoy.
  ///
  /// In tr, this message translates to:
  /// **'Olumlu Soy'**
  String get soyDurumOlumluSoy;

  /// No description provided for @soyDurumZayifSoy.
  ///
  /// In tr, this message translates to:
  /// **'Zayıf Soy'**
  String get soyDurumZayifSoy;

  /// No description provided for @soyDurumRiskliSoy.
  ///
  /// In tr, this message translates to:
  /// **'Riskli Soy'**
  String get soyDurumRiskliSoy;

  /// No description provided for @soyDurumNotr.
  ///
  /// In tr, this message translates to:
  /// **'Nötr'**
  String get soyDurumNotr;

  /// No description provided for @soyYorumTureyenYok.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloniden türeyen kayıtlı koloni görünmüyor.'**
  String get soyYorumTureyenYok;

  /// No description provided for @soyYorumVeriYetersiz.
  ///
  /// In tr, this message translates to:
  /// **'Türeyen koloniler var; ancak henüz en az 45 gün geçmiş yeterli veri oluşmamış.'**
  String get soyYorumVeriYetersiz;

  /// No description provided for @hatKararVeriYetersiz.
  ///
  /// In tr, this message translates to:
  /// **'Veri Yetersiz'**
  String get hatKararVeriYetersiz;

  /// No description provided for @hatKararOperasyonel.
  ///
  /// In tr, this message translates to:
  /// **'Operasyonel Hat'**
  String get hatKararOperasyonel;

  /// No description provided for @hatKararRiskli.
  ///
  /// In tr, this message translates to:
  /// **'Riskli Hat'**
  String get hatKararRiskli;

  /// No description provided for @hatKararDonor.
  ///
  /// In tr, this message translates to:
  /// **'Donör Hat'**
  String get hatKararDonor;

  /// No description provided for @hatKararGucluUretim.
  ///
  /// In tr, this message translates to:
  /// **'Güçlü Üretim Hattı'**
  String get hatKararGucluUretim;

  /// No description provided for @hatKararTakip.
  ///
  /// In tr, this message translates to:
  /// **'Takip Edilmeli'**
  String get hatKararTakip;

  /// No description provided for @hatGerekceVeriYetersiz.
  ///
  /// In tr, this message translates to:
  /// **'Bu hat için güvenilir karar üretecek kadar yeterli koloni geçmişi oluşmamış.'**
  String get hatGerekceVeriYetersiz;

  /// No description provided for @hatGerekceOperasyonel.
  ///
  /// In tr, this message translates to:
  /// **'Bu hatta oğul kökeni veya gerçekleşmiş oğul olayı bulunduğu için donör hat olarak kabul edilmez.'**
  String get hatGerekceOperasyonel;

  /// No description provided for @hatGerekceRiskli.
  ///
  /// In tr, this message translates to:
  /// **'Bu hatta tekrar eden sönme veya yüksek sönme oranı görülüyor.'**
  String get hatGerekceRiskli;

  /// No description provided for @hatGereceDonor.
  ///
  /// In tr, this message translates to:
  /// **'Hat; gelişim, üretim ve dayanıklılık açısından güçlü ve dengeli görünüyor.'**
  String get hatGereceDonor;

  /// No description provided for @hatGerekceGucluUretim.
  ///
  /// In tr, this message translates to:
  /// **'Hat donör kadar temiz ve güçlü görünmese de üretim omurgası olarak değerlidir.'**
  String get hatGerekceGucluUretim;

  /// No description provided for @hatGerekceTakip.
  ///
  /// In tr, this message translates to:
  /// **'Hat tamamen zayıf görünmüyor; ancak çoğaltma kararı için daha net tekrar ve performans verisi gerekiyor.'**
  String get hatGerekceTakip;

  /// No description provided for @hatNotVeriIhtiyac.
  ///
  /// In tr, this message translates to:
  /// **'En az iki koloni ve daha fazla saha tekrarına ihtiyaç var.'**
  String get hatNotVeriIhtiyac;

  /// No description provided for @hatNotDonorOncelikli.
  ///
  /// In tr, this message translates to:
  /// **'Bu hat donör çoğaltma için öncelikli adaydır.'**
  String get hatNotDonorOncelikli;

  /// No description provided for @hatNotTekrarlayanSonme.
  ///
  /// In tr, this message translates to:
  /// **'Tekrarlayan sönmeler seçilim açısından güçlü negatif sinyaldir.'**
  String get hatNotTekrarlayanSonme;

  /// No description provided for @hatNotTekSonme.
  ///
  /// In tr, this message translates to:
  /// **'Tek sönme doğrudan eleme değildir, ama uyarı sinyalidir.'**
  String get hatNotTekSonme;

  /// No description provided for @hatNotGelisimGuclu.
  ///
  /// In tr, this message translates to:
  /// **'Hat içinde gelişim gücü olumlu görünüyor.'**
  String get hatNotGelisimGuclu;

  /// No description provided for @hatNotBalPerformans.
  ///
  /// In tr, this message translates to:
  /// **'Ortalama bal performansı olumlu ayrışıyor.'**
  String get hatNotBalPerformans;

  /// No description provided for @hatNotIzlemeDEvam.
  ///
  /// In tr, this message translates to:
  /// **'Bu hat için izleme devam etmeli.'**
  String get hatNotIzlemeDEvam;

  /// No description provided for @hatNotKisGuclu.
  ///
  /// In tr, this message translates to:
  /// **'Kıştan çıkış gücü olumlu görünüyor.'**
  String get hatNotKisGuclu;

  /// No description provided for @hatAksiyonVeriTopla.
  ///
  /// In tr, this message translates to:
  /// **'Bu hat için veri toplamaya devam et'**
  String get hatAksiyonVeriTopla;

  /// No description provided for @hatAksiyonErkenKarar.
  ///
  /// In tr, this message translates to:
  /// **'Erken damızlık kararı verme'**
  String get hatAksiyonErkenKarar;

  /// No description provided for @hatAksiyonAnaUretme.
  ///
  /// In tr, this message translates to:
  /// **'Bu hattan ana üretme'**
  String get hatAksiyonAnaUretme;

  /// No description provided for @hatAksiyonSinirliUretim.
  ///
  /// In tr, this message translates to:
  /// **'Yeni bölme üretimini sınırlı tut'**
  String get hatAksiyonSinirliUretim;

  /// No description provided for @hatAksiyonUretimDestek.
  ///
  /// In tr, this message translates to:
  /// **'Üretim veya destek hattı olarak değerlendir'**
  String get hatAksiyonUretimDestek;

  /// No description provided for @hatAksiyonBolmeYapma.
  ///
  /// In tr, this message translates to:
  /// **'Bu hattan bölme yapma'**
  String get hatAksiyonBolmeYapma;

  /// No description provided for @hatAksiyonDonorHavuzu.
  ///
  /// In tr, this message translates to:
  /// **'Donör havuzuna alma'**
  String get hatAksiyonDonorHavuzu;

  /// No description provided for @hatAksiyonHatEleme.
  ///
  /// In tr, this message translates to:
  /// **'Hat elemesini veya ana yenilemeyi değerlendir'**
  String get hatAksiyonHatEleme;

  /// No description provided for @hatAksiyonAnaUret.
  ///
  /// In tr, this message translates to:
  /// **'Bu hattan ana üret'**
  String get hatAksiyonAnaUret;

  /// No description provided for @hatAksiyonTemizHat.
  ///
  /// In tr, this message translates to:
  /// **'Temiz çoğaltma hattı olarak koru'**
  String get hatAksiyonTemizHat;

  /// No description provided for @hatAksiyonDonorOncelik.
  ///
  /// In tr, this message translates to:
  /// **'Donör havuzunda önceliklendir'**
  String get hatAksiyonDonorOncelik;

  /// No description provided for @hatAksiyonUretimdeKor.
  ///
  /// In tr, this message translates to:
  /// **'Bu hattı üretimde koru'**
  String get hatAksiyonUretimdeKor;

  /// No description provided for @hatAksiyonSinirliKontrolluBolme.
  ///
  /// In tr, this message translates to:
  /// **'Sınırlı ve kontrollü bölme düşün'**
  String get hatAksiyonSinirliKontrolluBolme;

  /// No description provided for @hatAksiyonUretimOmurgasi.
  ///
  /// In tr, this message translates to:
  /// **'Donör değil, üretim omurgası olarak değerlendir'**
  String get hatAksiyonUretimOmurgasi;

  /// No description provided for @hatAksiyonIzlemeDevam.
  ///
  /// In tr, this message translates to:
  /// **'İzlemeye devam et'**
  String get hatAksiyonIzlemeDevam;

  /// No description provided for @hatAksiyonKarariErtele.
  ///
  /// In tr, this message translates to:
  /// **'Kararı ertele, veri biriktir'**
  String get hatAksiyonKarariErtele;

  /// No description provided for @hatAksiyonMuayeneSiklik.
  ///
  /// In tr, this message translates to:
  /// **'Kritik kolonilerde muayene sıklığını artır'**
  String get hatAksiyonMuayeneSiklik;

  /// No description provided for @perfDurumGenetikFiltre.
  ///
  /// In tr, this message translates to:
  /// **'Genetik Filtre'**
  String get perfDurumGenetikFiltre;

  /// No description provided for @perfDurumSartliDonor.
  ///
  /// In tr, this message translates to:
  /// **'Şartlı Donör'**
  String get perfDurumSartliDonor;

  /// No description provided for @perfDurumGucluUretim.
  ///
  /// In tr, this message translates to:
  /// **'Güçlü Üretim'**
  String get perfDurumGucluUretim;

  /// No description provided for @perfDurumIzlenmeli.
  ///
  /// In tr, this message translates to:
  /// **'İzlenmeli'**
  String get perfDurumIzlenmeli;

  /// No description provided for @perfDurumMudahale.
  ///
  /// In tr, this message translates to:
  /// **'Müdahale'**
  String get perfDurumMudahale;

  /// No description provided for @raporDurumGenetikVeto.
  ///
  /// In tr, this message translates to:
  /// **'Genetik veto'**
  String get raporDurumGenetikVeto;

  /// No description provided for @raporDurumDonor1.
  ///
  /// In tr, this message translates to:
  /// **'Donör 1'**
  String get raporDurumDonor1;

  /// No description provided for @raporDurumDonor2.
  ///
  /// In tr, this message translates to:
  /// **'Donör 2'**
  String get raporDurumDonor2;

  /// No description provided for @raporDurumDonor3.
  ///
  /// In tr, this message translates to:
  /// **'Donör 3'**
  String get raporDurumDonor3;

  /// No description provided for @raporDurumCokZayif.
  ///
  /// In tr, this message translates to:
  /// **'Çok zayıf'**
  String get raporDurumCokZayif;

  /// No description provided for @raporDurumGelismekte.
  ///
  /// In tr, this message translates to:
  /// **'Gelişmekte'**
  String get raporDurumGelismekte;

  /// No description provided for @raporDurumGuclu.
  ///
  /// In tr, this message translates to:
  /// **'Güçlü'**
  String get raporDurumGuclu;

  /// No description provided for @raporDurumCokGuclu.
  ///
  /// In tr, this message translates to:
  /// **'Çok güçlü'**
  String get raporDurumCokGuclu;

  /// No description provided for @trendMomPatlaYici.
  ///
  /// In tr, this message translates to:
  /// **'Patlayıcı büyüme'**
  String get trendMomPatlaYici;

  /// No description provided for @trendMomGucluBuyume.
  ///
  /// In tr, this message translates to:
  /// **'Güçlü büyüme'**
  String get trendMomGucluBuyume;

  /// No description provided for @trendMomSaglikliGelisim.
  ///
  /// In tr, this message translates to:
  /// **'Sağlıklı gelişim'**
  String get trendMomSaglikliGelisim;

  /// No description provided for @trendMomYavasGelisim.
  ///
  /// In tr, this message translates to:
  /// **'Yavaş gelişim'**
  String get trendMomYavasGelisim;

  /// No description provided for @trendMomDuraklama.
  ///
  /// In tr, this message translates to:
  /// **'Duraklama'**
  String get trendMomDuraklama;

  /// No description provided for @trendAciklamaStabil.
  ///
  /// In tr, this message translates to:
  /// **'Koloni genel olarak stabil görünüyor.'**
  String get trendAciklamaStabil;

  /// No description provided for @trendAciklamaSonmus.
  ///
  /// In tr, this message translates to:
  /// **'Son muayenede kovanın söndüğü işaretlenmiş.'**
  String get trendAciklamaSonmus;

  /// No description provided for @trendAciklamaBolme.
  ///
  /// In tr, this message translates to:
  /// **'Bölme işaretli olduğu için çıta değişimi doğrudan zayıflama olarak okunmadı.'**
  String get trendAciklamaBolme;

  /// No description provided for @trendAciklamaGucluYon.
  ///
  /// In tr, this message translates to:
  /// **'Koloni zamana göre güçlü biyolojik gelişim yönü gösteriyor.'**
  String get trendAciklamaGucluYon;

  /// No description provided for @trendAciklamaYukselis.
  ///
  /// In tr, this message translates to:
  /// **'Koloni zamana göre sağlıklı biyolojik gelişim yönünde.'**
  String get trendAciklamaYukselis;

  /// No description provided for @trendAciklamaHasatStabil.
  ///
  /// In tr, this message translates to:
  /// **'Bal sinyali mevcut; küçük düşüşler üretim / hasat bağlamında okunuyor.'**
  String get trendAciklamaHasatStabil;

  /// No description provided for @trendAciklamaDusus.
  ///
  /// In tr, this message translates to:
  /// **'Koloni zamana göre güç kaybı eğilimi gösteriyor.'**
  String get trendAciklamaDusus;

  /// No description provided for @trendAciklamaYavasGelisim.
  ///
  /// In tr, this message translates to:
  /// **'Koloni gelişiyor ancak momentum düşük.'**
  String get trendAciklamaYavasGelisim;

  /// No description provided for @trendNormBiyolojikDusus.
  ///
  /// In tr, this message translates to:
  /// **'Hasat/bölme kaydı olmadan belirgin çıta düşüşü biyolojik zayıflama şüphesiyle okundu.'**
  String get trendNormBiyolojikDusus;

  /// No description provided for @trendNormKucukDusus.
  ///
  /// In tr, this message translates to:
  /// **'Küçük çıta düşüşü tam çöküş sayılmadan temkinli okundu.'**
  String get trendNormKucukDusus;

  /// No description provided for @biyoSinifZayif.
  ///
  /// In tr, this message translates to:
  /// **'Zayıf'**
  String get biyoSinifZayif;

  /// No description provided for @biyoSinifGelisim.
  ///
  /// In tr, this message translates to:
  /// **'Gelişim'**
  String get biyoSinifGelisim;

  /// No description provided for @biyoSinifHasat.
  ///
  /// In tr, this message translates to:
  /// **'Hasat'**
  String get biyoSinifHasat;

  /// No description provided for @biyoSinifAciklamaZayif.
  ///
  /// In tr, this message translates to:
  /// **'Öncelik yaşatma, sıkıştırma ve ölçülü destek.'**
  String get biyoSinifAciklamaZayif;

  /// No description provided for @biyoSinifAciklamaGelisim.
  ///
  /// In tr, this message translates to:
  /// **'Öncelik düzenli gelişim ve ana/yavru dengesinin korunması.'**
  String get biyoSinifAciklamaGelisim;

  /// No description provided for @biyoSinifAciklamaUretim.
  ///
  /// In tr, this message translates to:
  /// **'Koloni üretim gücüne girmiştir; alan, oğul riski ve bal akımı birlikte izlenir.'**
  String get biyoSinifAciklamaUretim;

  /// No description provided for @biyoSinifAciklamaHasat.
  ///
  /// In tr, this message translates to:
  /// **'Koloni bal akımı ve hasat/alan yönetimi açısından güçlü banttadır.'**
  String get biyoSinifAciklamaHasat;

  /// No description provided for @biyoYerlesimYavruStok.
  ///
  /// In tr, this message translates to:
  /// **'Yavru/stok'**
  String get biyoYerlesimYavruStok;

  /// No description provided for @biyoYerlesimBalliPolenli.
  ///
  /// In tr, this message translates to:
  /// **'Ballı/polenli'**
  String get biyoYerlesimBalliPolenli;

  /// No description provided for @biyoYerlesimBalStogu.
  ///
  /// In tr, this message translates to:
  /// **'Bal stoğu'**
  String get biyoYerlesimBalStogu;

  /// No description provided for @biyoYerlesimYavruPolenli.
  ///
  /// In tr, this message translates to:
  /// **'Yavru/polenli'**
  String get biyoYerlesimYavruPolenli;

  /// No description provided for @biyoYerlesimYavru.
  ///
  /// In tr, this message translates to:
  /// **'Yavru'**
  String get biyoYerlesimYavru;

  /// No description provided for @biyoYerlesimYavruluPolenli.
  ///
  /// In tr, this message translates to:
  /// **'Yavrulu/polenli'**
  String get biyoYerlesimYavruluPolenli;

  /// No description provided for @biyoYerlesimBalliPolenliGecis.
  ///
  /// In tr, this message translates to:
  /// **'Ballı/polenli geçiş alanı'**
  String get biyoYerlesimBalliPolenliGecis;

  /// No description provided for @biyoYerlesimBallikBalAlani.
  ///
  /// In tr, this message translates to:
  /// **'Ballık / bal alanı'**
  String get biyoYerlesimBallikBalAlani;

  /// No description provided for @biyoYerlesimYavruStokGecis.
  ///
  /// In tr, this message translates to:
  /// **'Yavru/stok geçiş alanı'**
  String get biyoYerlesimYavruStokGecis;

  /// No description provided for @biyoYavrusuzSahaNormal.
  ///
  /// In tr, this message translates to:
  /// **'Yavru verisi mevcut; biyolojik geri dönüş kapasitesi yavru üretimiyle destekleniyor.'**
  String get biyoYavrusuzSahaNormal;

  /// No description provided for @biyoYavrusuzOneriNormal.
  ///
  /// In tr, this message translates to:
  /// **'Normal biyolojik model akışıyla izle.'**
  String get biyoYavrusuzOneriNormal;

  /// No description provided for @biyoYavrusuzSahaBolme.
  ///
  /// In tr, this message translates to:
  /// **'Bu aşamada yavru görülmemesi normal olabilir. Koloni ana kazanma veya çiftleşme döneminde olabilir; gereksiz açma riski artırır.'**
  String get biyoYavrusuzSahaBolme;

  /// No description provided for @biyoYavrusuzOneriBolme.
  ///
  /// In tr, this message translates to:
  /// **'Kovanı gereksiz açma; yumurtlama kontrol penceresini bekle.'**
  String get biyoYavrusuzOneriBolme;

  /// No description provided for @biyoYavrusuzSahaBalBaskisi.
  ///
  /// In tr, this message translates to:
  /// **'Yavru yokluğu tek başına anasızlık anlamına gelmez. Bal akımı ve ballı çıta baskısı yumurtlama alanını daraltmış olabilir.'**
  String get biyoYavrusuzSahaBalBaskisi;

  /// No description provided for @biyoYavrusuzOneriBalBaskisi.
  ///
  /// In tr, this message translates to:
  /// **'Önce alan ve bal baskısını değerlendir; erken ana müdahalesi yapma.'**
  String get biyoYavrusuzOneriBalBaskisi;

  /// No description provided for @biyoYavrusuzSahaDusukKap.
  ///
  /// In tr, this message translates to:
  /// **'Koloni uzun süredir yeni işçi üretmiyor. Bu güç seviyesinde mevcut nüfus yaşlanıyor olabilir; yoğun emek ve kaynak harcamak verimli olmayabilir.'**
  String get biyoYavrusuzSahaDusukKap;

  /// No description provided for @biyoYavrusuzOneriDusukKap.
  ///
  /// In tr, this message translates to:
  /// **'Güçlü koloniyle birleştirme veya sınırlı müdahale öncelikli değerlendirilmelidir.'**
  String get biyoYavrusuzOneriDusukKap;

  /// No description provided for @biyoYavrusuzSahaGecikme.
  ///
  /// In tr, this message translates to:
  /// **'Yumurtlama beklenen döneme girilmiş. Yavru hâlâ yoksa geç çiftleşme, ana kaybı, bal baskısı veya zayıf koloni olasılıkları birlikte okunmalı.'**
  String get biyoYavrusuzSahaGecikme;

  /// No description provided for @biyoYavrusuzOneriGecikme.
  ///
  /// In tr, this message translates to:
  /// **'5–7 gün içinde tekrar kontrol et; koloni zayıflıyorsa beklemeyi uzatma.'**
  String get biyoYavrusuzOneriGecikme;

  /// No description provided for @biyoYavrusuzSahaIzlenmeli.
  ///
  /// In tr, this message translates to:
  /// **'Yavru yokluğu izlenmeli; mevcut gün aralığında tek başına kesin anasızlık kararı verilmemelidir.'**
  String get biyoYavrusuzSahaIzlenmeli;

  /// No description provided for @biyoYavrusuzOneriIzlenmeli.
  ///
  /// In tr, this message translates to:
  /// **'Koloni davranışı, polen gelişi ve bir sonraki muayene ile birlikte değerlendir.'**
  String get biyoYavrusuzOneriIzlenmeli;

  /// No description provided for @perfBiyolojiVeriYetersiz.
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik veri yetersiz'**
  String get perfBiyolojiVeriYetersiz;

  /// No description provided for @perfBiyolojiZamanKritik.
  ///
  /// In tr, this message translates to:
  /// **'Zaman kritik'**
  String get perfBiyolojiZamanKritik;

  /// No description provided for @perfBiyolojiMudahaleGerekli.
  ///
  /// In tr, this message translates to:
  /// **'Müdahale gerekli'**
  String get perfBiyolojiMudahaleGerekli;

  /// No description provided for @perfBiyolojiUygun.
  ///
  /// In tr, this message translates to:
  /// **'Uygun'**
  String get perfBiyolojiUygun;

  /// No description provided for @perfBiyolojiDikkat.
  ///
  /// In tr, this message translates to:
  /// **'Dikkat'**
  String get perfBiyolojiDikkat;

  /// No description provided for @perfKabiliyetYeterli.
  ///
  /// In tr, this message translates to:
  /// **'Yeterli'**
  String get perfKabiliyetYeterli;

  /// No description provided for @perfKabiliyetSinirli.
  ///
  /// In tr, this message translates to:
  /// **'Sınırlı'**
  String get perfKabiliyetSinirli;

  /// No description provided for @perfKabiliyetVeriYok.
  ///
  /// In tr, this message translates to:
  /// **'Veri yok'**
  String get perfKabiliyetVeriYok;

  /// No description provided for @perfDurum1DonorAdayi.
  ///
  /// In tr, this message translates to:
  /// **'1. Donör Adayı'**
  String get perfDurum1DonorAdayi;

  /// No description provided for @perfDurum2DonorAdayi.
  ///
  /// In tr, this message translates to:
  /// **'2. Donör Adayı'**
  String get perfDurum2DonorAdayi;

  /// No description provided for @perfDurum3DonorAdayi.
  ///
  /// In tr, this message translates to:
  /// **'3. Donör Adayı'**
  String get perfDurum3DonorAdayi;

  /// No description provided for @perfVeriGuveniGuvenilir.
  ///
  /// In tr, this message translates to:
  /// **'Güvenilir'**
  String get perfVeriGuveniGuvenilir;

  /// No description provided for @perfVeriGuveniCokSinirli.
  ///
  /// In tr, this message translates to:
  /// **'Veri çok sınırlı'**
  String get perfVeriGuveniCokSinirli;

  /// No description provided for @perfKisCikisVeriYetersiz.
  ///
  /// In tr, this message translates to:
  /// **'Kış çıkış verisi yetersiz.'**
  String get perfKisCikisVeriYetersiz;

  /// No description provided for @aksiyonDurum.
  ///
  /// In tr, this message translates to:
  /// **'Durum'**
  String get aksiyonDurum;

  /// No description provided for @aksiyonNeYap.
  ///
  /// In tr, this message translates to:
  /// **'Ne yap'**
  String get aksiyonNeYap;

  /// No description provided for @aksiyonNeden.
  ///
  /// In tr, this message translates to:
  /// **'Neden'**
  String get aksiyonNeden;

  /// No description provided for @aksiyonZamanBaglami.
  ///
  /// In tr, this message translates to:
  /// **'Zaman Bağlamı'**
  String get aksiyonZamanBaglami;

  /// No description provided for @perfYorumOrta.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get perfYorumOrta;

  /// No description provided for @karsilastirmaGenetikSecilim.
  ///
  /// In tr, this message translates to:
  /// **'Genetik Seçilim'**
  String get karsilastirmaGenetikSecilim;

  /// No description provided for @karsilastirmaKistanCikis.
  ///
  /// In tr, this message translates to:
  /// **'Kıştan Çıkış'**
  String get karsilastirmaKistanCikis;

  /// No description provided for @karsilastirmaBiyolojiDurumu.
  ///
  /// In tr, this message translates to:
  /// **'Biyoloji Durumu'**
  String get karsilastirmaBiyolojiDurumu;

  /// No description provided for @karsilastirmaMemeTakibi.
  ///
  /// In tr, this message translates to:
  /// **'Meme Takibi'**
  String get karsilastirmaMemeTakibi;

  /// No description provided for @karsilastirmaAnasizlikGun.
  ///
  /// In tr, this message translates to:
  /// **'Anasızlık (gün)'**
  String get karsilastirmaAnasizlikGun;

  /// No description provided for @karsilastirmaHavuzaGiremez.
  ///
  /// In tr, this message translates to:
  /// **'Temiz donör havuzuna giremez'**
  String get karsilastirmaHavuzaGiremez;

  /// No description provided for @karsilastirmaMemeTakipYorum.
  ///
  /// In tr, this message translates to:
  /// **'Zamanlama ve meme gelişimi'**
  String get karsilastirmaMemeTakipYorum;

  /// No description provided for @fHesapSurupFormulBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Şurup Formülü'**
  String get fHesapSurupFormulBaslik;

  /// No description provided for @fHesapSurupFormulAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Hedef şerbet miktarını kg olarak girersen sistem kg su ve kg şeker verir. Sahada aynı ölçü kabını kullanıyorsan 1:1 veya 2:1 oranı aynı mantıkla korunur.'**
  String get fHesapSurupFormulAciklama;

  /// No description provided for @fHesapSurupOraniBolum.
  ///
  /// In tr, this message translates to:
  /// **'Şurup Oranı'**
  String get fHesapSurupOraniBolum;

  /// No description provided for @fHesapSurupOraniAciklama.
  ///
  /// In tr, this message translates to:
  /// **'1:1 genelde teşvik şurubu, 2:1 genelde stok / kış hazırlığı için kullanılır. Bu ekran zorunlu uygulama emri değil, oran hesabı yardımcısıdır.'**
  String get fHesapSurupOraniAciklama;

  /// No description provided for @fHesapSurupHedefBolum.
  ///
  /// In tr, this message translates to:
  /// **'Hedef Şerbet'**
  String get fHesapSurupHedefBolum;

  /// No description provided for @fHesapSurupHedefEtiket.
  ///
  /// In tr, this message translates to:
  /// **'Hedef şerbet miktarı'**
  String get fHesapSurupHedefEtiket;

  /// No description provided for @fHesapSurupHedefYardim.
  ///
  /// In tr, this message translates to:
  /// **'Örnek: 10 kg hedef şerbet için gerekli kg su ve kg şeker hesaplanır.'**
  String get fHesapSurupHedefYardim;

  /// No description provided for @fHesapSurupSonucSuffix.
  ///
  /// In tr, this message translates to:
  /// **'Şurup Sonucu'**
  String get fHesapSurupSonucSuffix;

  /// No description provided for @fHesapSurupSekerSatir.
  ///
  /// In tr, this message translates to:
  /// **'Şeker'**
  String get fHesapSurupSekerSatir;

  /// No description provided for @fHesapSurupSuSatir.
  ///
  /// In tr, this message translates to:
  /// **'Su'**
  String get fHesapSurupSuSatir;

  /// No description provided for @fHesapSurupKatsayiSatir.
  ///
  /// In tr, this message translates to:
  /// **'Saha Katsayısı'**
  String get fHesapSurupKatsayiSatir;

  /// No description provided for @fHesapSurupNot.
  ///
  /// In tr, this message translates to:
  /// **'Kg hesabı hedef şerbet ağırlığı içindir. Hacimsel kapla çalışıyorsan aynı kapla oran kur; 1:1 için eşit kap, 2:1 için iki kap şeker bir kap su mantığı korunur.'**
  String get fHesapSurupNot;

  /// No description provided for @fHesapOksalikBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Oksalik Asit Yardımcı Hesabı'**
  String get fHesapOksalikBaslik;

  /// No description provided for @fHesapOksalikAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Bu ekran yalnızca hesaplama yardımcısıdır. Uygulama kararı için ruhsatlı ürün etiketi, yerel mevzuat ve veteriner/teknik danışman talimatı esas alınır.'**
  String get fHesapOksalikAciklama;

  /// No description provided for @fHesapOksalikFormulBaslik.
  ///
  /// In tr, this message translates to:
  /// **'10–15 Kovan İçin Standart Formül'**
  String get fHesapOksalikFormulBaslik;

  /// No description provided for @fHesapOksalikTozAsitSatir.
  ///
  /// In tr, this message translates to:
  /// **'Toz oksalik asit'**
  String get fHesapOksalikTozAsitSatir;

  /// No description provided for @fHesapOksalikUygulamaSatir.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama şekli'**
  String get fHesapOksalikUygulamaSatir;

  /// No description provided for @fHesapOksalikUygulamaDegeri.
  ///
  /// In tr, this message translates to:
  /// **'Damlatma'**
  String get fHesapOksalikUygulamaDegeri;

  /// No description provided for @fHesapOksalikUygulamaNotu.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Notu'**
  String get fHesapOksalikUygulamaNotu;

  /// No description provided for @fHesapOksalikUygulamaNotMetni.
  ///
  /// In tr, this message translates to:
  /// **'Oksalik uygulaması genelde yavrusuz / yavru çok az dönemde daha anlamlıdır. Sıcaklık, doz, uygulama yöntemi ve tekrar sayısı için ürün etiketi esas alınmalıdır.'**
  String get fHesapOksalikUygulamaNotMetni;

  /// No description provided for @fHesapOksalikGuvenlikBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik Uyarısı'**
  String get fHesapOksalikGuvenlikBaslik;

  /// No description provided for @fHesapOksalikGuvenlikMetni.
  ///
  /// In tr, this message translates to:
  /// **'Koruyucu gözlük, eldiven ve maske kullan. Asit buharını soluma, cilt ve göz temasından kaçın. Ruhsatsız ürün, belirsiz doz veya etiketsiz karışım kullanma. Bu ekran tedavi talimatı değil, yardımcı hesaplama ekranıdır.'**
  String get fHesapOksalikGuvenlikMetni;

  /// No description provided for @fHesapBiyolojiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik Takvim'**
  String get fHesapBiyolojiBaslik;

  /// No description provided for @fHesapBiyolojiAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Bu ekran ana kazanma biyoloji takvimini merkezi AriBiyolojiServisi üzerinden okur. Koloni detay, süreç uyarıları ve formüller aynı tarih mantığını kullanır.'**
  String get fHesapBiyolojiAciklama;

  /// No description provided for @fHesapBiyolojiAnaKazanmaBolum.
  ///
  /// In tr, this message translates to:
  /// **'Ana Kazanma Süreci'**
  String get fHesapBiyolojiAnaKazanmaBolum;

  /// No description provided for @fHesapBiyolojiBaslangicTipi.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç tipi'**
  String get fHesapBiyolojiBaslangicTipi;

  /// No description provided for @fHesapBiyolojiAnasizBirakildi.
  ///
  /// In tr, this message translates to:
  /// **'Anasız Bırakıldı'**
  String get fHesapBiyolojiAnasizBirakildi;

  /// No description provided for @fHesapBiyolojiBolmeYapildi.
  ///
  /// In tr, this message translates to:
  /// **'Bölme Yapıldı'**
  String get fHesapBiyolojiBolmeYapildi;

  /// No description provided for @fHesapBiyolojiKapaliMeme.
  ///
  /// In tr, this message translates to:
  /// **'Hazır Kapalı Ana Memesi'**
  String get fHesapBiyolojiKapaliMeme;

  /// No description provided for @fHesapBiyolojiHazirAna.
  ///
  /// In tr, this message translates to:
  /// **'Hazır Çiftleşmiş Ana'**
  String get fHesapBiyolojiHazirAna;

  /// No description provided for @fHesapBiyolojiBaslangicTarihi.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç tarihi'**
  String get fHesapBiyolojiBaslangicTarihi;

  /// No description provided for @fHesapBiyolojiTakvimSuffix.
  ///
  /// In tr, this message translates to:
  /// **'Takvimi'**
  String get fHesapBiyolojiTakvimSuffix;

  /// No description provided for @fHesapBiyolojiSahaNotu.
  ///
  /// In tr, this message translates to:
  /// **'Saha Notu'**
  String get fHesapBiyolojiSahaNotu;

  /// No description provided for @fHesapBiyolojiSahaNotMetni.
  ///
  /// In tr, this message translates to:
  /// **'Gün sayımı başlangıç günü dahil edilerek yapılır. Günlük / kapalı yavru görülürse muayene ekranındaki ilgili kutucuk işaretlenir ve ana kazanma süreci kapanır.'**
  String get fHesapBiyolojiSahaNotMetni;

  /// No description provided for @fHesapBiyolojiIsciYavruBolum.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı İşçi Yavrusu Çıkışı'**
  String get fHesapBiyolojiIsciYavruBolum;

  /// No description provided for @fHesapBiyolojiIsciYavruTarihi.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı işçi yavrusu görülen tarih'**
  String get fHesapBiyolojiIsciYavruTarihi;

  /// No description provided for @fHesapBiyolojiIsciYavruPencere.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı İşçi Yavrusu Çıkış Penceresi'**
  String get fHesapBiyolojiIsciYavruPencere;

  /// No description provided for @fHesapBiyolojiErkekYavruBolum.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı Erkek Yavrusu Çıkışı'**
  String get fHesapBiyolojiErkekYavruBolum;

  /// No description provided for @fHesapBiyolojiErkekYavruTarihi.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı erkek yavrusu görülen tarih'**
  String get fHesapBiyolojiErkekYavruTarihi;

  /// No description provided for @fHesapBiyolojiErkekYavruPencere.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı Erkek Yavrusu Çıkış Penceresi'**
  String get fHesapBiyolojiErkekYavruPencere;

  /// No description provided for @fHesapBiyolojiBaslangicSatir.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç'**
  String get fHesapBiyolojiBaslangicSatir;

  /// No description provided for @fHesapBiyolojiTahminiCikis.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini çıkış'**
  String get fHesapBiyolojiTahminiCikis;

  /// No description provided for @fHesapBiyolojiKabulPencere.
  ///
  /// In tr, this message translates to:
  /// **'Kabul kontrol penceresi'**
  String get fHesapBiyolojiKabulPencere;

  /// No description provided for @fHesapBiyolojiMemePencere.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini meme kapanma'**
  String get fHesapBiyolojiMemePencere;

  /// No description provided for @fHesapBiyolojiAnaCikisi.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini ana çıkışı'**
  String get fHesapBiyolojiAnaCikisi;

  /// No description provided for @fHesapBiyolojiCiftlesmePencere.
  ///
  /// In tr, this message translates to:
  /// **'Çiftleşme uçuş penceresi'**
  String get fHesapBiyolojiCiftlesmePencere;

  /// No description provided for @fHesapBiyolojiYumurtlamaPencere.
  ///
  /// In tr, this message translates to:
  /// **'Yumurtlama kontrol penceresi'**
  String get fHesapBiyolojiYumurtlamaPencere;

  /// No description provided for @fHesapBiyolojiDokunmaPencere.
  ///
  /// In tr, this message translates to:
  /// **'Kovana dokunma penceresi'**
  String get fHesapBiyolojiDokunmaPencere;

  /// No description provided for @fHesapBalAkimiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bal Akımı Kararı'**
  String get fHesapBalAkimiBaslik;

  /// No description provided for @fHesapBalAkimiAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Sistem, bal akımına zayıf girmemek için 57 günlük saha planlama eşiğini kullanır. 42 gün ise yumurtadan tarlacıya biyolojik süredir; bu ikisi aynı şey değildir.'**
  String get fHesapBalAkimiAciklama;

  /// No description provided for @fHesapBalAkimTarihi.
  ///
  /// In tr, this message translates to:
  /// **'Bal akım başlangıç tarihi'**
  String get fHesapBalAkimTarihi;

  /// No description provided for @fHesapBalAkimCitaSayisi.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut çıta sayısı'**
  String get fHesapBalAkimCitaSayisi;

  /// No description provided for @fHesapBalAkimCitaYardim.
  ///
  /// In tr, this message translates to:
  /// **'Örnek: 9'**
  String get fHesapBalAkimCitaYardim;

  /// No description provided for @fHesapBalAkimTarihBekleniyor.
  ///
  /// In tr, this message translates to:
  /// **'Tarih Bekleniyor'**
  String get fHesapBalAkimTarihBekleniyor;

  /// No description provided for @fHesapBalAkimTarihBekleniyorMetni.
  ///
  /// In tr, this message translates to:
  /// **'Karar üretilebilmesi için önce bal akım başlangıç tarihini seç.'**
  String get fHesapBalAkimTarihBekleniyorMetni;

  /// No description provided for @fHesapBalAkimKararBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Karar'**
  String get fHesapBalAkimKararBaslik;

  /// No description provided for @fHesapBalAkimSonTarih.
  ///
  /// In tr, this message translates to:
  /// **'Son güvenli bölme tarihi'**
  String get fHesapBalAkimSonTarih;

  /// No description provided for @fHesapBalAkimPlanlamaEsigi.
  ///
  /// In tr, this message translates to:
  /// **'Planlama eşiği'**
  String get fHesapBalAkimPlanlamaEsigi;

  /// No description provided for @fHesapBalAkimPlanlamaEsigiDeger.
  ///
  /// In tr, this message translates to:
  /// **'57 gün'**
  String get fHesapBalAkimPlanlamaEsigiDeger;

  /// No description provided for @fHesapBalAkimBiyolojikSure.
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik süre'**
  String get fHesapBalAkimBiyolojikSure;

  /// No description provided for @fHesapBalAkimBiyolojikSureDeger.
  ///
  /// In tr, this message translates to:
  /// **'42 gün: yumurtadan tarlacıya'**
  String get fHesapBalAkimBiyolojikSureDeger;

  /// No description provided for @fHesapBalAkimMevcutGuc.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut güç'**
  String get fHesapBalAkimMevcutGuc;

  /// No description provided for @fHesapBalAkimHedefAltSinir.
  ///
  /// In tr, this message translates to:
  /// **'Hedef alt sınır'**
  String get fHesapBalAkimHedefAltSinir;

  /// No description provided for @fHesapBalAkimEnFazla.
  ///
  /// In tr, this message translates to:
  /// **'En fazla alınabilir'**
  String get fHesapBalAkimEnFazla;

  /// No description provided for @fHesapBalAkimKarar.
  ///
  /// In tr, this message translates to:
  /// **'Karar'**
  String get fHesapBalAkimKarar;

  /// No description provided for @fHesapBalAkimGucYetersiz.
  ///
  /// In tr, this message translates to:
  /// **'Bu güçte güvenli bölme penceresi açılmamış görünüyor.'**
  String get fHesapBalAkimGucYetersiz;

  /// No description provided for @fHesapBalAkimMaxCitaUyari.
  ///
  /// In tr, this message translates to:
  /// **'{maxCita} çıtadan fazla alınırsa koloni bal dönemine zayıf girebilir.'**
  String fHesapBalAkimMaxCitaUyari(String maxCita);

  /// No description provided for @kolonilerCitaYok.
  ///
  /// In tr, this message translates to:
  /// **'- çıta'**
  String get kolonilerCitaYok;

  /// No description provided for @kolonilerIslevselCita.
  ///
  /// In tr, this message translates to:
  /// **'{islevsel} işl.'**
  String kolonilerIslevselCita(int islevsel);

  /// No description provided for @kaynakAnaHat.
  ///
  /// In tr, this message translates to:
  /// **'Ana Hat'**
  String get kaynakAnaHat;

  /// No description provided for @kaynakBolme.
  ///
  /// In tr, this message translates to:
  /// **'Bölme'**
  String get kaynakBolme;

  /// No description provided for @kaynakBolmeDen.
  ///
  /// In tr, this message translates to:
  /// **'{koloni} koloniden bölme'**
  String kaynakBolmeDen(String koloni);

  /// No description provided for @kaynakOgul.
  ///
  /// In tr, this message translates to:
  /// **'Oğul'**
  String get kaynakOgul;

  /// No description provided for @kaynakOgulDen.
  ///
  /// In tr, this message translates to:
  /// **'{koloni} koloniden oğul'**
  String kaynakOgulDen(String koloni);

  /// No description provided for @kaynakDisKaynak.
  ///
  /// In tr, this message translates to:
  /// **'Dış kaynak'**
  String get kaynakDisKaynak;

  /// No description provided for @kararDonorDegil.
  ///
  /// In tr, this message translates to:
  /// **'Genetik seçilimde uygun değil.'**
  String get kararDonorDegil;

  /// No description provided for @kararYakinTakip.
  ///
  /// In tr, this message translates to:
  /// **'Yakın takip et.'**
  String get kararYakinTakip;

  /// No description provided for @yonetimKararUretilemediBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Yönetim kararları üretilemedi'**
  String get yonetimKararUretilemediBaslik;

  /// No description provided for @yonetimKararUretilemediOzet.
  ///
  /// In tr, this message translates to:
  /// **'Saha yönetimi karar hattı bu koloni için sonuç veremedi.'**
  String get yonetimKararUretilemediOzet;

  /// No description provided for @yonetimKararYokBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Öne çıkan yönetim kararı yok'**
  String get yonetimKararYokBaslik;

  /// No description provided for @yonetimKararYokOzet.
  ///
  /// In tr, this message translates to:
  /// **'Süreç, biyolojik sınıf ve sezon birlikte okundu; şu an ayrı bir saha müdahalesi öne çıkmıyor.'**
  String get yonetimKararYokOzet;

  /// No description provided for @yonetimKararYokDetay.
  ///
  /// In tr, this message translates to:
  /// **'Bu kart artık besleme motorunu ayrı bir gerçeklik olarak okumaz. Besleme, kat, alan, varroa, şurupluk, kış ve hasat sonrası kararları aynı yönetim listesinde değerlendirilir.'**
  String get yonetimKararYokDetay;

  /// No description provided for @biyolojikModelUretilemedi.
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik model üretilemedi:\n{hata}'**
  String biyolojikModelUretilemedi(String hata);

  /// No description provided for @biyolojikModelVeriGerekli.
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik model için önce muayene ve çıta verisi gerekir.'**
  String get biyolojikModelVeriGerekli;

  /// No description provided for @biyolojikDizilimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'BİYOLOJİK DİZİLİM PROJEKSİYONU'**
  String get biyolojikDizilimBaslik;

  /// No description provided for @biyolojikTahminiAriEtiket.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini arı'**
  String get biyolojikTahminiAriEtiket;

  /// No description provided for @biyolojikMerkezYavruBloku.
  ///
  /// In tr, this message translates to:
  /// **'Merkez yavru bloğu: {blok}. Bu blok korunmalı.'**
  String biyolojikMerkezYavruBloku(String blok);

  /// No description provided for @biyolojikBalPotansiyeli.
  ///
  /// In tr, this message translates to:
  /// **'Bal potansiyeli'**
  String get biyolojikBalPotansiyeli;

  /// No description provided for @biyolojikBirakilacakStok.
  ///
  /// In tr, this message translates to:
  /// **'Bırakılacak stok'**
  String get biyolojikBirakilacakStok;

  /// No description provided for @biyolojikHacimAktivasyonuEtiket.
  ///
  /// In tr, this message translates to:
  /// **'Hacim aktivasyonu'**
  String get biyolojikHacimAktivasyonuEtiket;

  /// No description provided for @biyolojikTarlaciEtiket.
  ///
  /// In tr, this message translates to:
  /// **'Tarlacı'**
  String get biyolojikTarlaciEtiket;

  /// No description provided for @biyolojikBakiciEtiket.
  ///
  /// In tr, this message translates to:
  /// **'Bakıcı'**
  String get biyolojikBakiciEtiket;

  /// No description provided for @biyolojikGencIsciEtiket.
  ///
  /// In tr, this message translates to:
  /// **'Genç işçi'**
  String get biyolojikGencIsciEtiket;

  /// No description provided for @biyolojikPetekOrme.
  ///
  /// In tr, this message translates to:
  /// **'Petek örme'**
  String get biyolojikPetekOrme;

  /// No description provided for @biyolojikYavruBakim.
  ///
  /// In tr, this message translates to:
  /// **'Yavru bakımı'**
  String get biyolojikYavruBakim;

  /// No description provided for @biyolojikNektarToplama.
  ///
  /// In tr, this message translates to:
  /// **'Nektar toplama'**
  String get biyolojikNektarToplama;

  /// No description provided for @biyolojikBalIsleme.
  ///
  /// In tr, this message translates to:
  /// **'Bal işleme'**
  String get biyolojikBalIsleme;

  /// No description provided for @hasatProjeksiyonBaslik.
  ///
  /// In tr, this message translates to:
  /// **'HASAT PROJEKSİYONU'**
  String get hasatProjeksiyonBaslik;

  /// No description provided for @hasatAdayYok.
  ///
  /// In tr, this message translates to:
  /// **'Hasat adayı çıta oluşmadı. Koloni gücü ve dış stok durumuna göre takip et.'**
  String get hasatAdayYok;

  /// No description provided for @hasatTahminiMiktarEtiket.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini miktar'**
  String get hasatTahminiMiktarEtiket;

  /// No description provided for @hasatTahminiDegerEtiket.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini değer'**
  String get hasatTahminiDegerEtiket;

  /// No description provided for @hasatKuluckalikGuvenlik.
  ///
  /// In tr, this message translates to:
  /// **'Yalnızca yavrusuz ve sırlıysa değerlendir. Kuluçkalık güvenliği bozulmamalı.'**
  String get hasatKuluckalikGuvenlik;

  /// No description provided for @hasatSuruplukKisit.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı yaklaştığı için besleme kısıtı başladı. Şurupluk kovandaysa görselde kalır; yalnızca muayenede kaldırıldı olarak işaretlenirse dizilimden çıkar.'**
  String get hasatSuruplukKisit;

  /// No description provided for @katUcuncuBallik.
  ///
  /// In tr, this message translates to:
  /// **'3. KAT / BALLIK'**
  String get katUcuncuBallik;

  /// No description provided for @katUstBallik.
  ///
  /// In tr, this message translates to:
  /// **'ÜST KAT / BALLIK'**
  String get katUstBallik;

  /// No description provided for @katAltKuluckalik.
  ///
  /// In tr, this message translates to:
  /// **'ALT KAT / KULUÇKALIK'**
  String get katAltKuluckalik;

  /// No description provided for @lejantBalStok.
  ///
  /// In tr, this message translates to:
  /// **'Bal/stok'**
  String get lejantBalStok;

  /// No description provided for @lejantBalliPolenli.
  ///
  /// In tr, this message translates to:
  /// **'Ballı-polenli'**
  String get lejantBalliPolenli;

  /// No description provided for @lejantYavru.
  ///
  /// In tr, this message translates to:
  /// **'Yavru'**
  String get lejantYavru;

  /// No description provided for @lejantBosCerceve.
  ///
  /// In tr, this message translates to:
  /// **'Boş çerçeve'**
  String get lejantBosCerceve;

  /// No description provided for @lejantGunlukDolum.
  ///
  /// In tr, this message translates to:
  /// **'Günlük dolum'**
  String get lejantGunlukDolum;

  /// No description provided for @lejantSurupluk.
  ///
  /// In tr, this message translates to:
  /// **'Şurupluk'**
  String get lejantSurupluk;

  /// No description provided for @hacimTipiKatGecisi.
  ///
  /// In tr, this message translates to:
  /// **'Kat geçişi; yeni hacim kademeli aktive ediliyor.'**
  String get hacimTipiKatGecisi;

  /// No description provided for @hacimTipiBallikUretim.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı içinde üretim genişlemesi kabul ediliyor.'**
  String get hacimTipiBallikUretim;

  /// No description provided for @hacimTipiRiskliGenisleme.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı dışında hızlı genişleme; temkinli okunmalı.'**
  String get hacimTipiRiskliGenisleme;

  /// No description provided for @hacimTipiHasatDusus.
  ///
  /// In tr, this message translates to:
  /// **'Hasat kaynaklı düşüş; biyolojik zayıflama sayılmaz.'**
  String get hacimTipiHasatDusus;

  /// No description provided for @hacimTipiBiyolojikZayiflama.
  ///
  /// In tr, this message translates to:
  /// **'Hacim düşüşü biyolojik zayıflama açısından izlenmeli.'**
  String get hacimTipiBiyolojikZayiflama;

  /// No description provided for @hacimTipiKuluckalikGenisleme.
  ///
  /// In tr, this message translates to:
  /// **'Kuluçkalık genişlemesi kontrollü okunuyor.'**
  String get hacimTipiKuluckalikGenisleme;

  /// No description provided for @hacimTipiNormal.
  ///
  /// In tr, this message translates to:
  /// **'Hacim değişimi normal bantta.'**
  String get hacimTipiNormal;

  /// No description provided for @hacimOkunamadi.
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik durum okunamadı'**
  String get hacimOkunamadi;

  /// No description provided for @hacimUretilemedi.
  ///
  /// In tr, this message translates to:
  /// **'Hacim aktivasyon hesabı üretilemedi.'**
  String get hacimUretilemedi;

  /// No description provided for @hacimHazirlaniyor.
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik durum hazırlanıyor'**
  String get hacimHazirlaniyor;

  /// No description provided for @hacimBirlikte.
  ///
  /// In tr, this message translates to:
  /// **'Fiziksel çıta, işlevsel üretim çıtası ve toplam hacim aktivasyonu birlikte okunacak.'**
  String get hacimBirlikte;

  /// No description provided for @hacimArkaplan.
  ///
  /// In tr, this message translates to:
  /// **'Bu hesap ekranı bloke etmemek için ilk açılıştan sonra yüklenir.'**
  String get hacimArkaplan;

  /// No description provided for @hacimToplamBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Toplam hacim aktivasyonu: %{yuzde}'**
  String hacimToplamBaslik(int yuzde);

  /// No description provided for @hacimBuyukBolumAktif.
  ///
  /// In tr, this message translates to:
  /// **'Sistem mevcut hacmin büyük bölümünü aktif üretim kapasitesi olarak okuyor.'**
  String get hacimBuyukBolumAktif;

  /// No description provided for @hacimFizikselIslevselOzet.
  ///
  /// In tr, this message translates to:
  /// **'{fiziksel} fiziksel çıta → yaklaşık {islevsel} işlevsel üretim çıtası. {yorum}'**
  String hacimFizikselIslevselOzet(int fiziksel, String islevsel, String yorum);

  /// No description provided for @hacimFizikselIslevselBirlikte.
  ///
  /// In tr, this message translates to:
  /// **'Fiziksel hacim ve işlevsel üretim kapasitesi birlikte okunuyor.'**
  String get hacimFizikselIslevselBirlikte;

  /// No description provided for @miniFiziksel.
  ///
  /// In tr, this message translates to:
  /// **'Fiziksel'**
  String get miniFiziksel;

  /// No description provided for @miniIslevsel.
  ///
  /// In tr, this message translates to:
  /// **'İşlevsel'**
  String get miniIslevsel;

  /// No description provided for @miniToplamHacim.
  ///
  /// In tr, this message translates to:
  /// **'Toplam hacim'**
  String get miniToplamHacim;

  /// No description provided for @miniEklenen.
  ///
  /// In tr, this message translates to:
  /// **'Eklenen'**
  String get miniEklenen;

  /// No description provided for @miniOnceki.
  ///
  /// In tr, this message translates to:
  /// **'Önceki'**
  String get miniOnceki;

  /// No description provided for @miniTemel.
  ///
  /// In tr, this message translates to:
  /// **'Temel'**
  String get miniTemel;

  /// No description provided for @miniKabarmis.
  ///
  /// In tr, this message translates to:
  /// **'Kabarmış'**
  String get miniKabarmis;

  /// No description provided for @miniPetek.
  ///
  /// In tr, this message translates to:
  /// **'Petek'**
  String get miniPetek;

  /// No description provided for @miniKalan.
  ///
  /// In tr, this message translates to:
  /// **'Kalan'**
  String get miniKalan;

  /// No description provided for @genetikDetayAyri.
  ///
  /// In tr, this message translates to:
  /// **'Genetik değerlendirme ayrı izleniyor'**
  String get genetikDetayAyri;

  /// No description provided for @genetikSurecBilgisi.
  ///
  /// In tr, this message translates to:
  /// **'Aktif süreç bilgisi Süreç kartında gösterilir. Bu alan yalnızca donör, veto, üretim/destek rolü ve soy değerlendirmesi için kullanılır.'**
  String get genetikSurecBilgisi;

  /// No description provided for @genetikHazirlaniyor.
  ///
  /// In tr, this message translates to:
  /// **'Genetik değerlendirme için süreçten bağımsız seçilim bilgisi hazırlanıyor.'**
  String get genetikHazirlaniyor;

  /// No description provided for @soyBirinciSatir.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak: {kaynak} • Ana: {anaYili} • Son: {sonCita} • Max: {maxCita}'**
  String soyBirinciSatir(
      String kaynak, String anaYili, String sonCita, String maxCita);

  /// No description provided for @soyIkinciSatirSkor.
  ///
  /// In tr, this message translates to:
  /// **'Bal: {balCita} • Muayene: {muayeneSayisi} • Türeyen: {tureyenSayisi} • Skor: {skor}'**
  String soyIkinciSatirSkor(
      String balCita, String muayeneSayisi, String tureyenSayisi, String skor);

  /// No description provided for @soyIkinciSatir.
  ///
  /// In tr, this message translates to:
  /// **'Bal: {balCita} • Muayene: {muayeneSayisi} • Türeyen: {tureyenSayisi}'**
  String soyIkinciSatir(
      String balCita, String muayeneSayisi, String tureyenSayisi);

  /// No description provided for @tetikOgulBelirtisi.
  ///
  /// In tr, this message translates to:
  /// **'Oğul Belirtisi'**
  String get tetikOgulBelirtisi;

  /// No description provided for @tetikBolmeYapildi.
  ///
  /// In tr, this message translates to:
  /// **'Bölme Yapıldı'**
  String get tetikBolmeYapildi;

  /// No description provided for @tetikAnasizBirakildi.
  ///
  /// In tr, this message translates to:
  /// **'Anasız Bırakıldı'**
  String get tetikAnasizBirakildi;

  /// No description provided for @tetikOgulAtti.
  ///
  /// In tr, this message translates to:
  /// **'Oğul Attı'**
  String get tetikOgulAtti;

  /// No description provided for @tetikKovanSondu.
  ///
  /// In tr, this message translates to:
  /// **'Kovan Söndü'**
  String get tetikKovanSondu;

  /// No description provided for @tetikHasat.
  ///
  /// In tr, this message translates to:
  /// **'Hasat'**
  String get tetikHasat;

  /// No description provided for @tetikHazirAnaVerildi.
  ///
  /// In tr, this message translates to:
  /// **'Hazır Ana Verildi'**
  String get tetikHazirAnaVerildi;

  /// No description provided for @tetikGunlukKapaliYavru.
  ///
  /// In tr, this message translates to:
  /// **'Günlük/Kapalı Yavru'**
  String get tetikGunlukKapaliYavru;

  /// No description provided for @tetikKapaliYavruluCita.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı Yavrulu Çıta'**
  String get tetikKapaliYavruluCita;

  /// No description provided for @uyariAriKusuBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Arı kuşu baskısı görülebilir'**
  String get uyariAriKusuBaslik;

  /// No description provided for @uyariAriKusuMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Uçuş hattını gözle. Yoğun geçiş varsa korkuluk veya görsel caydırıcı önlemler kullan.'**
  String get uyariAriKusuMesaj;

  /// No description provided for @uyariEsekArisiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Eşek arısı baskısı artabilir'**
  String get uyariEsekArisiBaslik;

  /// No description provided for @uyariEsekArisiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Kovan girişlerini daralt, zayıf kolonileri koru. Yoğun baskıda tuzak kurulması değerlendirilebilir.'**
  String get uyariEsekArisiMesaj;

  /// No description provided for @uyariYagmacilikBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Yağmacılık riski artabilir'**
  String get uyariYagmacilikBaslik;

  /// No description provided for @uyariYagmacilikMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Kovan açma süresini kısa tut. Girişleri daralt, zayıf kolonileri koru.'**
  String get uyariYagmacilikMesaj;

  /// No description provided for @uyariMumGuvesiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Mum güvesi riski artabilir'**
  String get uyariMumGuvesiBaslik;

  /// No description provided for @uyariMumGuvesiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Zayıf kolonide fazla petek bırakma. Boş petekleri korumalı sakla.'**
  String get uyariMumGuvesiMesaj;

  /// No description provided for @uariFareBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Fare riski başlayabilir'**
  String get uariFareBaslik;

  /// No description provided for @uariFareMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Kovan girişlerini daralt. Fare girişini engellemek için önlem al.'**
  String get uariFareMesaj;

  /// No description provided for @uyariVarroaPlanBaslik.
  ///
  /// In tr, this message translates to:
  /// **'{etiket} öncesi varroa mücadelesini planla'**
  String uyariVarroaPlanBaslik(String etiket);

  /// No description provided for @uyariVarroaPlanMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı yaklaşmadan önce varroa durumunu değerlendir. Kimyasal uygulama yapılacaksa kalıntı riskini hesaba katarak erken planla.'**
  String get uyariVarroaPlanMesaj;

  /// No description provided for @uyariVarroaSonBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı öncesi varroa mücadelesi için son dönem'**
  String get uyariVarroaSonBaslik;

  /// No description provided for @uyariVarroaSonMesaj.
  ///
  /// In tr, this message translates to:
  /// **'{baslangicTarih} tarihinde başlaması beklenen {etiket} öncesi kalıntı riskini azaltmak için varroa mücadelesi mümkünse {kalintiTarih} tarihine kadar tamamlanmış olmalı. Geciktiysen yeni kimyasal uygulamayı bal akımı sonrasına bırakman daha güvenli olabilir.'**
  String uyariVarroaSonMesaj(
      String baslangicTarih, String etiket, String kalintiTarih);

  /// No description provided for @uyariBalBolmeErkenBaslik.
  ///
  /// In tr, this message translates to:
  /// **'{etiket} yaklaşırken bölme kararına dikkat'**
  String uyariBalBolmeErkenBaslik(String etiket);

  /// No description provided for @uyariBalBolmeErkenMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Üretim hedefi korunacaksa bölme kararını dikkatli ver. Bal akımına güçlü işçi arı yetişmesi için zaman daralıyor.'**
  String get uyariBalBolmeErkenMesaj;

  /// No description provided for @uyariBalBolmeGecBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bölme yapılacaksa dikkat'**
  String get uyariBalBolmeGecBaslik;

  /// No description provided for @uyariBalBolmeGecMesaj.
  ///
  /// In tr, this message translates to:
  /// **'{kritikEsik} sonrası 42 günlük biyolojik eşik aşılmış olur. Bu tarihten sonra yapılan bölmeler bal verimini düşürebilir. Üretim hedefi korunacaksa bölme kararını ertele.'**
  String uyariBalBolmeGecMesaj(String kritikEsik);

  /// No description provided for @kararVetoDogrudan.
  ///
  /// In tr, this message translates to:
  /// **'Koloni oğul kökenli olduğu için temiz donör havuzuna alınmadı.'**
  String get kararVetoDogrudan;

  /// No description provided for @kararVetoKendisiOgulAtti.
  ///
  /// In tr, this message translates to:
  /// **'Koloni kendi geçmişinde oğul attığı için donör değerlendirmesinde veto aldı.'**
  String get kararVetoKendisiOgulAtti;

  /// No description provided for @kararVetoAtaHattaRef.
  ///
  /// In tr, this message translates to:
  /// **'{referansNo} hattında oğul izi bulunduğu için temiz donör havuzuna alınmadı.'**
  String kararVetoAtaHattaRef(String referansNo);

  /// No description provided for @kararVetoAtaHatta.
  ///
  /// In tr, this message translates to:
  /// **'Atasal hatta oğul izi bulunduğu için temiz donör havuzuna alınmadı.'**
  String get kararVetoAtaHatta;

  /// No description provided for @kararDonorSirasi.
  ///
  /// In tr, this message translates to:
  /// **'Temiz donör havuzunda {sira}. sırada görünüyor.'**
  String kararDonorSirasi(int sira);

  /// No description provided for @kararSonCitaMetni.
  ///
  /// In tr, this message translates to:
  /// **'Son muayenede koloni {cita} çıta gücünde görünüyor.'**
  String kararSonCitaMetni(int cita);

  /// No description provided for @kararMaxCitaMetni.
  ///
  /// In tr, this message translates to:
  /// **'Bu sezon gördüğü en yüksek güç {cita} çıta.'**
  String kararMaxCitaMetni(int cita);

  /// No description provided for @kararBalCitaMetni.
  ///
  /// In tr, this message translates to:
  /// **'Bal taşıma sinyali {cita} ballı çıta ile görülüyor.'**
  String kararBalCitaMetni(int cita);

  /// No description provided for @kararTrendYukselis.
  ///
  /// In tr, this message translates to:
  /// **'Son muayenelerde gelişim yönü yukarı.'**
  String get kararTrendYukselis;

  /// No description provided for @kararTrendDusus.
  ///
  /// In tr, this message translates to:
  /// **'Son muayenelerde güç kaybı eğilimi görülüyor.'**
  String get kararTrendDusus;

  /// No description provided for @kararTrendStabil.
  ///
  /// In tr, this message translates to:
  /// **'Gidişat stabil görünüyor.'**
  String get kararTrendStabil;

  /// No description provided for @kararAnaYasiRisk.
  ///
  /// In tr, this message translates to:
  /// **'Ana yaşı {yas} yıl olduğu için verim ve düzen düşüşü riski taşıyor.'**
  String kararAnaYasiRisk(int yas);

  /// No description provided for @kararMizacRisk.
  ///
  /// In tr, this message translates to:
  /// **'Mizaç verisi saha yönetimini zorlaştırabilir.'**
  String get kararMizacRisk;

  /// No description provided for @kararAzVeriUyari.
  ///
  /// In tr, this message translates to:
  /// **'Karar az veriyle üretildiği için güven payı düşüktür.'**
  String get kararAzVeriUyari;

  /// No description provided for @kararBolmePlan.
  ///
  /// In tr, this message translates to:
  /// **'Bölme yapacaksan koloniyi 6 çıtanın altına düşürmeden planla.'**
  String get kararBolmePlan;

  /// No description provided for @kararDonorOncelik.
  ///
  /// In tr, this message translates to:
  /// **'Ana üretiminde bu koloniyi aday havuzunda öncelikli düşün.'**
  String get kararDonorOncelik;

  /// No description provided for @kararAnaDegisimPlan.
  ///
  /// In tr, this message translates to:
  /// **'Ana değişimini aktif dönemin sonuna yakın planlamak genelde daha güvenli olur.'**
  String get kararAnaDegisimPlan;

  /// No description provided for @kararGuclendir.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı yavru, besleme ve düzenli muayene ile güçlenme yönünü izle.'**
  String get kararGuclendir;

  /// No description provided for @kararUretimTut.
  ///
  /// In tr, this message translates to:
  /// **'Üretimde tut; bal akımı yaklaşırken alan ve kat yönetimini öne al.'**
  String get kararUretimTut;

  /// No description provided for @kararPasifKayitOner.
  ///
  /// In tr, this message translates to:
  /// **'Koloniyi aktif üretimden çok soy ve geçmiş kaydı olarak değerlendir.'**
  String get kararPasifKayitOner;

  /// No description provided for @kararNeden.
  ///
  /// In tr, this message translates to:
  /// **'Neden'**
  String get kararNeden;

  /// No description provided for @kararKilitBekle.
  ///
  /// In tr, this message translates to:
  /// **'Bekle'**
  String get kararKilitBekle;

  /// No description provided for @kararKilitGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Bu pencere kapanmadan çelişen eylem önerilmez.'**
  String get kararKilitGerekce;

  /// No description provided for @kararBolmeGucluMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Koloni güçlü gelişim gösteriyor ve bal akımına yaklaşık {gun} gün var. Kat seviyesine yaklaşmış olsa da bu süre içinde oğul baskısı doğabilir; genetik değeri uygunsa kontrollü bölme değerlendirilebilir.'**
  String kararBolmeGucluMesaj(int gun);

  /// No description provided for @kararBolmeSinirliMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Koloni güçlü; ancak bal akımına yaklaşık {gun} gün kaldığı için bölme kararı sınırlı ve dikkatli düşünülmeli. Ana koloni bala yetişemeyecekse bölme yerine alan/oğul yönetimi öne alınır.'**
  String kararBolmeSinirliMesaj(int gun);

  /// No description provided for @kararBolmeGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Bölme kararı sadece çıta sayısı değildir: bal akımına kalan süre, gelişim yönü, yavru düzeni, işlevsel çıta ve genetik veto birlikte okundu.'**
  String get kararBolmeGerekce;

  /// No description provided for @kararKatEsikSurupluklu.
  ///
  /// In tr, this message translates to:
  /// **'Şurupluk + 9 çıta kapasitesi'**
  String get kararKatEsikSurupluklu;

  /// No description provided for @kararKatEsikSurupluksuz.
  ///
  /// In tr, this message translates to:
  /// **'Şurupluksuz 10 çıta kapasitesi'**
  String get kararKatEsikSurupluksuz;

  /// No description provided for @kararKatAkimAktif.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı aktif görünüyor.'**
  String get kararKatAkimAktif;

  /// No description provided for @kararKatAkimKontrol.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı penceresi ayrıca kontrol edilmeli.'**
  String get kararKatAkimKontrol;

  /// No description provided for @kararKatAkimKalan.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımına yaklaşık {gun} gün var.'**
  String kararKatAkimKalan(int gun);

  /// No description provided for @kararKatMesaj.
  ///
  /// In tr, this message translates to:
  /// **'{esik} dolmuş ve yaklaşık %{yuzde} aktivasyon görülüyor. {akim} Bu eşik artık normal çıta ekleme değil, kat/ballık verme eşiğidir.'**
  String kararKatMesaj(String esik, int yuzde, String akim);

  /// No description provided for @kararKatGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Şurupluk varsa kuluçkalık 9 çıta, şurupluk kaldırıldıysa 10 çıta kapasite kabul edilir.'**
  String get kararKatGerekce;

  /// No description provided for @kararUcuncuKatEsikSurupluklu.
  ///
  /// In tr, this message translates to:
  /// **'Şurupluk + 19 çıta kapasitesi'**
  String get kararUcuncuKatEsikSurupluklu;

  /// No description provided for @kararUcuncuKatEsikSurupluksuz.
  ///
  /// In tr, this message translates to:
  /// **'Şurupluksuz 20 çıta kapasitesi'**
  String get kararUcuncuKatEsikSurupluksuz;

  /// No description provided for @kararUcuncuKatMesaj.
  ///
  /// In tr, this message translates to:
  /// **'{esik} dolmuş ve yaklaşık %{yuzde} aktivasyon görülüyor. Koloni ikinci üst hacmi doldurma eşiğine gelmiş; 3. kat/ikinci ballık değerlendirilmeli.'**
  String kararUcuncuKatMesaj(String esik, int yuzde);

  /// No description provided for @kararUcuncuKatGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Şurupluk varsa 19 çıta, şurupluk kaldırıldıysa 20 çıta 3. kat verme eşiğidir. Bir sonraki çıta artışı 3 katlı koloni olarak okunur.'**
  String get kararUcuncuKatGerekce;

  /// No description provided for @kararAlanMesajKulucluk.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut hacim yaklaşık %{yuzde} aktive olmuş. Koloni sıkışmadan ballık/alan yönetimi değerlendirilebilir.'**
  String kararAlanMesajKulucluk(int yuzde);

  /// No description provided for @kararAlanMesajCita.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut {cita} çıtanın tamamına yakını işlevsel kullanılıyor. Koloni sıkışmadan 1 çıta eklenmasi değerlendirilebilir.'**
  String kararAlanMesajCita(int cita);

  /// No description provided for @kararHasatSonrasiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Hasat sonrası koloni sıkışabilir; stok, alan ve varroa kontrolü yapılmalıdır.'**
  String get kararHasatSonrasiMesaj;

  /// No description provided for @kararHasatSonrasiGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Bal alımı sonrası aynı çıta düzeni artık üretim değil bakım kararıdır.'**
  String get kararHasatSonrasiGerekce;

  /// No description provided for @kararKisHazirlikMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Koloni kışa doğru yeterli stok, doğru hacim, düşük varroa baskısı ve uygun nüfusla hazırlanmalı.'**
  String get kararKisHazirlikMesaj;

  /// No description provided for @kararKisHazirlikGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Kış başarısı genetik seçilim ve sürdürülebilir arılık yönetiminin temel ölçütlerinden biridir.'**
  String get kararKisHazirlikGerekce;

  /// No description provided for @kararSinifiZayif.
  ///
  /// In tr, this message translates to:
  /// **'Zayıf'**
  String get kararSinifiZayif;

  /// No description provided for @kararSinifiGelisim.
  ///
  /// In tr, this message translates to:
  /// **'Gelişim'**
  String get kararSinifiGelisim;

  /// No description provided for @kararSinifiUretim.
  ///
  /// In tr, this message translates to:
  /// **'Üretim'**
  String get kararSinifiUretim;

  /// No description provided for @kararSinifiHasat.
  ///
  /// In tr, this message translates to:
  /// **'Hasat'**
  String get kararSinifiHasat;

  /// No description provided for @kararSinifiIzleme.
  ///
  /// In tr, this message translates to:
  /// **'İzleme'**
  String get kararSinifiIzleme;

  /// No description provided for @surecNedeniAnasizlik.
  ///
  /// In tr, this message translates to:
  /// **'Ana kazanma / anasızlık süreci biyolojik zamanlamaya bağlıdır. Bu pencere açıkken önce süreç yönetilir.'**
  String get surecNedeniAnasizlik;

  /// No description provided for @surecNedeniOgul.
  ///
  /// In tr, this message translates to:
  /// **'Ana memesi veya oğul belirtisi aktif saha riskidir. Önce oğul yönetimi yapılır.'**
  String get surecNedeniOgul;

  /// No description provided for @surecNedeniOgulSonrasi.
  ///
  /// In tr, this message translates to:
  /// **'Oğul sonrası yeni ana ve artçı oğul riski önceliklidir. Süreç kapanmadan genel üretim veya donör dili öne çıkarılmaz.'**
  String get surecNedeniOgulSonrasi;

  /// No description provided for @surecNedenibolme.
  ///
  /// In tr, this message translates to:
  /// **'Bölme sonrası koloni düzeni ve ana süreci oturmadan genel performans dili ana karar olarak gösterilmez.'**
  String get surecNedenibolme;

  /// No description provided for @surecNedeniHasat.
  ///
  /// In tr, this message translates to:
  /// **'Bal alımı koloni düzenini değiştirir. Önce sıkışık düzen, stres yönetimi, besleme ihtiyacı ve varroa penceresi birlikte değerlendirilir.'**
  String get surecNedeniHasat;

  /// No description provided for @surecNedeniGelisim.
  ///
  /// In tr, this message translates to:
  /// **'Gelişim yavaşlığı açıklanması gereken saha durumudur. Önce neden aranır; sonra üretim veya genetik rol yeniden değerlendirilir.'**
  String get surecNedeniGelisim;

  /// No description provided for @surecNedeniVarsayilan.
  ///
  /// In tr, this message translates to:
  /// **'Aktif süreç varsa önce süreç yönetimi öne alınır.'**
  String get surecNedeniVarsayilan;

  /// No description provided for @sezonHedefRiskliAnaBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Ana/yavru netleşmeli'**
  String get sezonHedefRiskliAnaBaslik;

  /// No description provided for @sezonHedefRiskliAnaMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Ana ve yavru düzeni netleşmeden üretim, kat veya çoğaltma kararı öne alınmaz.'**
  String get sezonHedefRiskliAnaMesaj;

  /// No description provided for @sezonHedefRiskliAnaGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Yavru düzeni netleşmeden yapılan işlem koloni kaybı riskini artırır.'**
  String get sezonHedefRiskliAnaGerekce;

  /// No description provided for @sezonHedefBolmeBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bölme toparlanıyor'**
  String get sezonHedefBolmeBaslik;

  /// No description provided for @sezonHedefBolmeMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni için öncelik ana düzeninin oturması ve nüfusun korunmasıdır.'**
  String get sezonHedefBolmeMesaj;

  /// No description provided for @sezonHedefBolmeGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Yeni bölmelerin bu sezon ana hedefi bal değil, sağlıklı koloni düzenine geçmektir.'**
  String get sezonHedefBolmeGerekce;

  /// No description provided for @sezonHedefKisBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kış kontrolü'**
  String get sezonHedefKisBaslik;

  /// No description provided for @sezonHedefKisMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Kovan gereksiz açılmadan stok, nem ve dış uçuş durumu izlenmelidir.'**
  String get sezonHedefKisMesaj;

  /// No description provided for @sezonHedefKisGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Kışta gereksiz müdahale salkımı ve ısı düzenini bozar.'**
  String get sezonHedefKisGerekce;

  /// No description provided for @sezonHedefKisHazirlikBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kışa hazırlık'**
  String get sezonHedefKisHazirlikBaslik;

  /// No description provided for @sezonHedefKisHazirlikMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Stok, hacim ve varroa durumu kışa giriş için kontrol edilmelidir.'**
  String get sezonHedefKisHazirlikMesaj;

  /// No description provided for @sezonHedefKisHazirlikGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Kışa hazırlık vurgusu sonbahar döneminde anlamlıdır.'**
  String get sezonHedefKisHazirlikGerekce;

  /// No description provided for @sezonHedefHasatSonrasiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Hasat sonrası bakım'**
  String get sezonHedefHasatSonrasiBaslik;

  /// No description provided for @sezonHedefHasatSonrasiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Hasat sonrası stok, alan ve varroa durumu kontrol edilmelidir.'**
  String get sezonHedefHasatSonrasiMesaj;

  /// No description provided for @sezonHedefHasatSonrasiGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Bal alımı sonrası koloni düzeni değişir; bakım kararı üretim kararının önüne geçer.'**
  String get sezonHedefHasatSonrasiGerekce;

  /// No description provided for @sezonHedefHasatKolonisiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Hasat kolonisi'**
  String get sezonHedefHasatKolonisiBaslik;

  /// No description provided for @sezonHedefHasatKolonisiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Koloni bal akımı içinde alan ve hasat yönünden izlenebilir.'**
  String get sezonHedefHasatKolonisiMesaj;

  /// No description provided for @sezonHedefHasatKolonisiGerekce.
  ///
  /// In tr, this message translates to:
  /// **'İşlevsel güç hasat değerlendirmesi için yeterli görünüyor.'**
  String get sezonHedefHasatKolonisiGerekce;

  /// No description provided for @sezonHedefGelisimAkimMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Hasat hedefi yok. Öncelik güçlenme, stok ve ana düzenidir.'**
  String get sezonHedefGelisimAkimMesaj;

  /// No description provided for @sezonHedefGelisimAkimGerekce.
  ///
  /// In tr, this message translates to:
  /// **'İşlevsel çıta gücü hasat eşiğinin altında.'**
  String get sezonHedefGelisimAkimGerekce;

  /// No description provided for @sezonHedefGenetikCogaltmaBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kontrollü çoğaltma adayı'**
  String get sezonHedefGenetikCogaltmaBaslik;

  /// No description provided for @sezonHedefGenetikCogaltmaMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Koloni güçlü ve düzenli ilerliyor; süre uygunsa kontrollü bölme değerlendirilebilir.'**
  String get sezonHedefGenetikCogaltmaMesaj;

  /// No description provided for @sezonHedefGenetikCogaltmaGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımına kalan süre ana koloninin tekrar toparlanmasına izin verebilir.'**
  String get sezonHedefGenetikCogaltmaGerekce;

  /// No description provided for @sezonHedefKisaHazirlikBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı hazırlık'**
  String get sezonHedefKisaHazirlikBaslik;

  /// No description provided for @sezonHedefKisaHazirlikMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımına kısa süre kaldığından koloninin gücünü korumak önemlidir. Hasat kalıntı güvenliği önemsenmelidir. Zaman zaman bal akım döneminde, bal tüketen nüfusu koloniden uzaklaştırmak için teknik bir koloni bölme işlemi yapılabilir. Bu uygulama bilgi olarak verilmiştir. Gerçekleştirebilmek bilgi ve tecrübe gerektirir.'**
  String get sezonHedefKisaHazirlikMesaj;

  /// No description provided for @sezonHedefZayifDestekBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Güçlendirme'**
  String get sezonHedefZayifDestekBaslik;

  /// No description provided for @sezonHedefZayifDestekMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Öncelik stok, nüfus ve ana düzenini güvenli seviyeye çıkarmaktır.'**
  String get sezonHedefZayifDestekMesaj;

  /// No description provided for @sezonHedefGelisimKolonisiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Gelişim kolonisi'**
  String get sezonHedefGelisimKolonisiBaslik;

  /// No description provided for @sezonHedefGelisimKolonisiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Gelişim aşamasındaki koloni. Hasat süreci dışında kabul edilmelidir.'**
  String get sezonHedefGelisimKolonisiMesaj;

  /// No description provided for @sezonHedefBalHazirlanBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bala hazırlanıyor'**
  String get sezonHedefBalHazirlanBaslik;

  /// No description provided for @sezonHedefBalHazirlanMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Koloni üretim gücüne yaklaşıyor; hedef oğul baskısı oluşturmadan bal akımına güçlü girmektir.'**
  String get sezonHedefBalHazirlanMesaj;

  /// No description provided for @sezonHedefBalHazirlanGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Gelişim yönü ve işlevsel çıta gücü üretim hedefini destekliyor.'**
  String get sezonHedefBalHazirlanGerekce;

  /// No description provided for @kisAclikRiskiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kış riski: stok yetersiz görünüyor'**
  String get kisAclikRiskiBaslik;

  /// No description provided for @kisAclikRiskiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Kış döneminde kovanı gereksiz açma önerilmez; ancak stok çok düşükse açlık riski önceliklidir. Hava ve saha koşulu uygunsa hızlı, sınırlı stok desteği/kek değerlendirilir.'**
  String get kisAclikRiskiMesaj;

  /// No description provided for @kisAclikRiskiGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Kış yönetiminde temel kural minimum müdahaledir; fakat açlık riski minimum müdahale kuralından daha yüksek önceliklidir.'**
  String get kisAclikRiskiGerekce;

  /// No description provided for @kisHacimRiskiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kış riski: boş hacim yüksek olabilir'**
  String get kisHacimRiskiBaslik;

  /// No description provided for @kisHacimRiskiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Fiziksel hacim yüksek ama işlevsel güç düşük görünüyorsa kış salkımı ısıyı korumakta zorlanabilir. Uygun zamanda hacim daraltma ve nem kontrolü değerlendirilir.'**
  String get kisHacimRiskiMesaj;

  /// No description provided for @kisHacimRiskiGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Kış başarısı yalnızca stokla değil, koloni hacmi ile arı nüfusunun uyumuyla belirlenir.'**
  String get kisHacimRiskiGerekce;

  /// No description provided for @kisZayiflamaTakibiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kış riski: güç kaybı izlenmeli'**
  String get kisZayiflamaTakibiBaslik;

  /// No description provided for @kisZayiflamaTakibiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Kış döneminde güç kaybı görülüyorsa kovanı açmadan dış gözlem, ağırlık, uçuş deliği ve nem kontrolü öne alınır. Uygun havada sınırlı kontrol yapılabilir.'**
  String get kisZayiflamaTakibiMesaj;

  /// No description provided for @kisZayiflamaTakibiGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Kışta gereksiz muayene salkımı ve ısı düzenini bozabilir.'**
  String get kisZayiflamaTakibiGerekce;

  /// No description provided for @kisDisGozlemBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kış yönetimi: gereksiz açma yok'**
  String get kisDisGozlemBaslik;

  /// No description provided for @kisDisGozlemMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Koloni için ana yaklaşım kovanı gereksiz açmadan dış gözlem, ağırlık hissi, uçuş deliği, nem ve su girişi kontrolüdür.'**
  String get kisDisGozlemMesaj;

  /// No description provided for @kisDisGozlemGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Kış dönemi algoritması üretim değil yaşatma odaklıdır. İlkbahar çıkışı genetik istikrar skoruna veri sağlar.'**
  String get kisDisGozlemGerekce;

  /// No description provided for @sapmaAnaSureczyBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Ana sürecinde zayıflama riski'**
  String get sapmaAnaSureczyBaslik;

  /// No description provided for @sapmaAnaSureczyMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Ana/yavru süreci devam ederken koloni gücü düşüyorsa normal bekleme senaryosu zayıflama riskine döner. Bu aşamada üretim değil, ana durumunu netleştirme ve yaşatma hedefi öne çıkar.'**
  String get sapmaAnaSureczyMesaj;

  /// No description provided for @sapmaAnaSureczyGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Beklenen akış: ana kazanma → yavru görülmesi → toparlanma. Sapma: süreç uzar ve nüfus düşerse ana kaybı, çiftleşme başarısızlığı veya dış tehdit olasılığı artar.'**
  String get sapmaAnaSureczyGerekce;

  /// No description provided for @sapmaBolmeTutmadiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bölme toparlanmıyor'**
  String get sapmaBolmeTutmadiBaslik;

  /// No description provided for @sapmaBolmeTutmadiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Bölme sonrası beklenen akış ana düzeninin oturması ve nüfusun korunmasıdır. Yavru düzeni yoksa ve güç düşüyorsa bu koloni için bal hedefi değil, ana tutma/yaşatma süreci öne çıkar.'**
  String get sapmaBolmeTutmadiMesaj;

  /// No description provided for @sapmaBolmeTutmadiGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Bölme süreci sadece gün sayısıyla kapanmaz; yavru düzeni, işlevsel çıta ve yeniden büyüme görülmeden süreç tamamlanmış kabul edilmez.'**
  String get sapmaBolmeTutmadiGerekce;

  /// No description provided for @sapmaOgulRiskiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Erken sıkışma oğul riski'**
  String get sapmaOgulRiskiBaslik;

  /// No description provided for @sapmaOgulRiskiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Koloni bal akımı başlamadan güçlü büyümeye devam ediyor. Bu güç yalnızca kat ile yönetilirse bal akımına kadar oğul baskısı doğabilir; genetik değeri uygunsa kontrollü bölme, değilse alan/oğul yönetimi düşünülmelidir.'**
  String get sapmaOgulRiskiMesaj;

  /// No description provided for @sapmaOgulRiskiGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Beklenen hedef 11–12 çıtalık güçlü ama yönetilebilir koloniyle bal akımına girmektir. Bu eşiğin erken aşılması üretim değil oğul riski üretebilir.'**
  String get sapmaOgulRiskiGerekce;

  /// No description provided for @sapmaAkimAlanTakibiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımında alan izle'**
  String get sapmaAkimAlanTakibiBaslik;

  /// No description provided for @sapmaAkimAlanTakibiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı içinde davranış değişir; koloni yavru büyütmeden çok nektar depolamaya yönelebilir. Düşük görünen stok tek başına zayıflık sayılmaz, alan ve sırlanma birlikte izlenir.'**
  String get sapmaAkimAlanTakibiMesaj;

  /// No description provided for @sapmaAkimAlanTakibiGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı döneminde yavru ve stok verileri normal dönem gibi okunmaz; nektar girişi, ballık alanı ve hasat zamanı birlikte değerlendirilir.'**
  String get sapmaAkimAlanTakibiGerekce;

  /// No description provided for @sapmaHasatStokRiskiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Hasat sonrası stok düşük'**
  String get sapmaHasatStokRiskiBaslik;

  /// No description provided for @sapmaHasatStokRiskiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Hasat sonrası beklenen akış stok, varroa ve hacim düzeninin toparlanmasıdır. Stok düşük görünüyorsa üretim dili kapanır; kışa güvenli giriş için stok ve sıkıştırma birlikte değerlendirilir.'**
  String get sapmaHasatStokRiskiMesaj;

  /// No description provided for @sapmaHasatStokRiskiGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Hasat balı alındıktan sonra aynı çıta gücü üretim başarısı değil, kışa hazırlık riski olarak okunabilir.'**
  String get sapmaHasatStokRiskiGerekce;

  /// No description provided for @sapmaHasatHacimRiskiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Hasat sonrası hacim fazla olabilir'**
  String get sapmaHasatHacimRiskiBaslik;

  /// No description provided for @sapmaHasatHacimRiskiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Fiziksel çıta alanı yüksek ama işlevsel güç düşükse koloni gereksiz hacimde kalabilir. Bu durumda alan daraltma, stok ve kış düzeni üretim kararlarının önüne geçer.'**
  String get sapmaHasatHacimRiskiMesaj;

  /// No description provided for @sapmaHasatHacimRiskiGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Hasat sonrası dönemde fazla boş hacim yağmacılık, nem ve ısı yönetimi riskini artırabilir.'**
  String get sapmaHasatHacimRiskiGerekce;

  /// No description provided for @genetikVetoBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Genetik çoğaltma değeri: veto'**
  String get genetikVetoBaslik;

  /// No description provided for @genetikYuksekBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Genetik çoğaltma değeri yüksek'**
  String get genetikYuksekBaslik;

  /// No description provided for @genetikIzleBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Genetik çoğaltma değeri izleme bandında'**
  String get genetikIzleBaslik;

  /// No description provided for @genetikVetoMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Koloni çoğaltma havuzunda öne çıkarılmaz. Üretim değeri ayrı, genetik yayılım değeri ayrıdır.'**
  String get genetikVetoMesaj;

  /// No description provided for @genetikSkorGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik güç, yavru düzeni, gelişim istikrarı ve riskler birlikte değerlendirilir.'**
  String get genetikSkorGerekce;

  /// No description provided for @beslemeYonetimVarsayilanBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Besleme Yönetimi'**
  String get beslemeYonetimVarsayilanBaslik;

  /// No description provided for @beslemeDestekBandi.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini destek bandı: {bant}'**
  String beslemeDestekBandi(String bant);

  /// No description provided for @varroaTakvimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Varroa takvimi izlenmeli.'**
  String get varroaTakvimBaslik;

  /// No description provided for @varroaTakvimGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Mevsime uygun varroa kaydı ve takip disiplini korunmalı.'**
  String get varroaTakvimGerekce;

  /// No description provided for @varroaKayitYok.
  ///
  /// In tr, this message translates to:
  /// **'Varroa kaydı henüz yok.'**
  String get varroaKayitYok;

  /// No description provided for @varroaKayitYokGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Takvimsel varroa hatırlatmaları ilk muayene kayıtlarından sonra daha anlamlı hale gelir.'**
  String get varroaKayitYokGerekce;

  /// No description provided for @varroaKayitYokOneri.
  ///
  /// In tr, this message translates to:
  /// **'Muayenelerde yapılan varroa mücadelesini düzenli kaydet.'**
  String get varroaKayitYokOneri;

  /// No description provided for @varroaIlkbaharKayitVar.
  ///
  /// In tr, this message translates to:
  /// **'Erken ilkbahar varroa kaydı var.'**
  String get varroaIlkbaharKayitVar;

  /// No description provided for @varroaIlkbaharKayitVarGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Sezon başında yapılan mücadele kaydı görülüyor. Bu, ilkbahar gelişimine daha düşük baskıyla girmeyi destekler.'**
  String get varroaIlkbaharKayitVarGerekce;

  /// No description provided for @varroaIlkbaharKayitVarOneri.
  ///
  /// In tr, this message translates to:
  /// **'Mücadele etkisini sonraki muayenelerde takip et.'**
  String get varroaIlkbaharKayitVarOneri;

  /// No description provided for @varroaIlkbaharKontrolPlanla.
  ///
  /// In tr, this message translates to:
  /// **'İlkbahar varroa kontrolü planlanmalı.'**
  String get varroaIlkbaharKontrolPlanla;

  /// No description provided for @varroaIlkbaharKontrolGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Erken ilkbahar dönemi varroa baskısını sezon başında düşürmek için önemli bir penceredir.'**
  String get varroaIlkbaharKontrolGerekce;

  /// No description provided for @varroaIlkbaharKontrolOneri.
  ///
  /// In tr, this message translates to:
  /// **'Kolonileri kontrol et; gerekirse erken ilkbahar müdahalesi planla.'**
  String get varroaIlkbaharKontrolOneri;

  /// No description provided for @varroaBalOncesiKayitVar.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı öncesi varroa kaydı görünüyor.'**
  String get varroaBalOncesiKayitVar;

  /// No description provided for @varroaBalOncesiPlanGozden.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı öncesi varroa planı gözden geçirilmeli.'**
  String get varroaBalOncesiPlanGozden;

  /// No description provided for @varroaBalOncesiGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı dönemine girerken varroa planının tamamlanmış olması daha güvenlidir.'**
  String get varroaBalOncesiGerekce;

  /// No description provided for @varroaBalOncesiOneri.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı içinde değil, öncesinde planlama yap.'**
  String get varroaBalOncesiOneri;

  /// No description provided for @varroaYazTakip.
  ///
  /// In tr, this message translates to:
  /// **'Yaz döneminde varroa takibi sürdürülmeli.'**
  String get varroaYazTakip;

  /// No description provided for @varroaYazTakipGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Yaz ortasında amaç sürekli ilaçlama değil, düzenli izleme ve hasat sonrası döneme hazırlıktır.'**
  String get varroaYazTakipGerekce;

  /// No description provided for @varroaYazTakipOneri.
  ///
  /// In tr, this message translates to:
  /// **'Muayenelerde varroa kaydını ve koloni gidişatını düzenli izle.'**
  String get varroaYazTakipOneri;

  /// No description provided for @varroaKritikKayitVar.
  ///
  /// In tr, this message translates to:
  /// **'Kritik dönemde varroa mücadelesi kaydı var.'**
  String get varroaKritikKayitVar;

  /// No description provided for @varroaKritikKayitVarGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Yaz sonu–erken sonbahar, kış arısının oluştuğu ve varroa baskısının en kritik olduğu dönemdir.'**
  String get varroaKritikKayitVarGerekce;

  /// No description provided for @varroaKritikKayitVarOneri.
  ///
  /// In tr, this message translates to:
  /// **'Hasat sonrası planı sürdür; etkinliği sonraki muayenede kontrol et.'**
  String get varroaKritikKayitVarOneri;

  /// No description provided for @varroaHasatSonrasiGecikiyor.
  ///
  /// In tr, this message translates to:
  /// **'Hasat sonrası varroa mücadelesi gecikiyor.'**
  String get varroaHasatSonrasiGecikiyor;

  /// No description provided for @varroaHasatSonrasiGecikiyorGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Yaz sonu–erken sonbaharda kayıt görünmüyor. Bu dönem kış arısının sağlığı açısından en kritik pencere kabul edilir.'**
  String get varroaHasatSonrasiGecikiyorGerekce;

  /// No description provided for @varroaHasatSonrasiGecikiyorOneri1.
  ///
  /// In tr, this message translates to:
  /// **'Bal sağımı sonrası mücadeleyi geciktirme.'**
  String get varroaHasatSonrasiGecikiyorOneri1;

  /// No description provided for @varroaHasatSonrasiGecikiyorOneri2.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki muayenede uygulamayı mutlaka kaydet.'**
  String get varroaHasatSonrasiGecikiyorOneri2;

  /// No description provided for @varroaKisaGirisKayitVar.
  ///
  /// In tr, this message translates to:
  /// **'Kışa giriş öncesi varroa kaydı var.'**
  String get varroaKisaGirisKayitVar;

  /// No description provided for @varroaKisaGirisKayitVarGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Sonbahar sonunda kayıt görünmesi kışa daha düşük yükle girme açısından olumlu bir sinyaldir.'**
  String get varroaKisaGirisKayitVarGerekce;

  /// No description provided for @varroaKisaGirisKayitVarOneri.
  ///
  /// In tr, this message translates to:
  /// **'Kışa girişten önce son genel durumu bir kez daha kontrol et.'**
  String get varroaKisaGirisKayitVarOneri;

  /// No description provided for @varroaSonbaharKayitEksik.
  ///
  /// In tr, this message translates to:
  /// **'Sonbahar varroa kaydı eksik görünüyor.'**
  String get varroaSonbaharKayitEksik;

  /// No description provided for @varroaSonbaharKayitEksikGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Kışa giriş öncesi dönemde mücadele kaydı görünmüyor. Sonbahar sonu kontrolü ihmal edilmemeli.'**
  String get varroaSonbaharKayitEksikGerekce;

  /// No description provided for @varroaSonbaharKayitEksikOneri.
  ///
  /// In tr, this message translates to:
  /// **'Yavru faaliyeti azaldıysa mücadele gerekliliğini değerlendir.'**
  String get varroaSonbaharKayitEksikOneri;

  /// No description provided for @varroaKisSonbaharKayitVar.
  ///
  /// In tr, this message translates to:
  /// **'Sonbahar varroa kaydı görünüyor.'**
  String get varroaKisSonbaharKayitVar;

  /// No description provided for @varroaKisSonbaharKayitVarGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Kış döneminde esas amaç, sonbaharda düşürülmüş yükü koruyarak koloniyi gereksiz strese sokmamaktır.'**
  String get varroaKisSonbaharKayitVarGerekce;

  /// No description provided for @varroaKisSonbaharKayitVarOneri.
  ///
  /// In tr, this message translates to:
  /// **'Kovanı gereksiz açmadan genel durumu izle.'**
  String get varroaKisSonbaharKayitVarOneri;

  /// No description provided for @varroaKisGozden.
  ///
  /// In tr, this message translates to:
  /// **'Kış varroa durumu gözden geçirilmeli.'**
  String get varroaKisGozden;

  /// No description provided for @varroaKisGozdenGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt uzun süredir yok. Yavru faaliyeti azaldıysa durum tekrar değerlendirilmelidir.'**
  String get varroaKisGozdenGerekce;

  /// No description provided for @varroaKisGozdenOneri.
  ///
  /// In tr, this message translates to:
  /// **'Yavru durumu ve mevsim koşullarına göre kış kontrolü yap.'**
  String get varroaKisGozdenOneri;

  /// No description provided for @varroaBalDonemiDikkat.
  ///
  /// In tr, this message translates to:
  /// **'Bal döneminde varroa kararı dikkat ister.'**
  String get varroaBalDonemiDikkat;

  /// No description provided for @varroaBalDonemiGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı başladıktan sonra kalıntı riski olan kimyasal mücadele önerilmez.'**
  String get varroaBalDonemiGerekce;

  /// No description provided for @varroaBalDonemiOneri1.
  ///
  /// In tr, this message translates to:
  /// **'Gerekirse yalnızca bala kalıntı riski taşımayan, etikete ve mevzuata uygun yöntemleri değerlendir.'**
  String get varroaBalDonemiOneri1;

  /// No description provided for @varroaBalDonemiOneri2.
  ///
  /// In tr, this message translates to:
  /// **'Kimyasal mücadeleyi hasat sonrasına planla.'**
  String get varroaBalDonemiOneri2;

  /// No description provided for @varroaBalOncesiTamamlandiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı öncesi varroa planı tamamlanmış görünüyor.'**
  String get varroaBalOncesiTamamlandiBaslik;

  /// No description provided for @varroaBalOncesiTamamlandiGerekce.
  ///
  /// In tr, this message translates to:
  /// **'{balAkimMetni} tarihinde başlaması beklenen bal akımı öncesi en geç {sonGunMetni} tarihine kadar mücadele tamamlanmalıydı. Kayıt buna uygun görünüyor.'**
  String varroaBalOncesiTamamlandiGerekce(
      String balAkimMetni, String sonGunMetni);

  /// No description provided for @varroaBalOncesiTamamlandiOneri.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı içinde yeni mücadele planlama.'**
  String get varroaBalOncesiTamamlandiOneri;

  /// No description provided for @varroaBalOncesiKapaniyorBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı öncesi mücadele penceresi kapanıyor.'**
  String get varroaBalOncesiKapaniyorBaslik;

  /// No description provided for @varroaBalOncesiKapaniyorGerekce.
  ///
  /// In tr, this message translates to:
  /// **'{balAkimMetni} tarihinde başlaması beklenen bal akımı öncesi kalıntı riskini azaltmak için mücadele en geç {sonGunMetni} tarihine kadar tamamlanmış olmalı.'**
  String varroaBalOncesiKapaniyorGerekce(
      String balAkimMetni, String sonGunMetni);

  /// No description provided for @varroaBalOncesiKapaniyorOneri1.
  ///
  /// In tr, this message translates to:
  /// **'Bu aşamada bal akımı öncesi kimyasal mücadele planlarken kalıntı riskini dikkate al.'**
  String get varroaBalOncesiKapaniyorOneri1;

  /// No description provided for @varroaBalOncesiKapaniyorOneri2.
  ///
  /// In tr, this message translates to:
  /// **'Geciktiysen yeni kimyasal uygulamayı bal akımı sonrasına bırakman daha güvenli olabilir.'**
  String get varroaBalOncesiKapaniyorOneri2;

  /// No description provided for @varroaBalOncesiSonPencereBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı öncesi son varroa penceresine giriliyor.'**
  String get varroaBalOncesiSonPencereBaslik;

  /// No description provided for @varroaBalOncesiSonPencereGerekce.
  ///
  /// In tr, this message translates to:
  /// **'{balAkimMetni} tarihinde başlaması beklenen bal akımı için mücadele en geç {sonGunMetni} tarihine kadar tamamlanmalı. Süre daralıyor.'**
  String varroaBalOncesiSonPencereGerekce(
      String balAkimMetni, String sonGunMetni);

  /// No description provided for @varroaBalOncesiSonPencereOneri.
  ///
  /// In tr, this message translates to:
  /// **'Mücadele gerekiyorsa son güvenli tarihe bırakmadan planla.'**
  String get varroaBalOncesiSonPencereOneri;

  /// No description provided for @varroaBalOncesiSonGunHatirla.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı öncesi son güvenli mücadele tarihi: {sonGunMetni}.'**
  String varroaBalOncesiSonGunHatirla(String sonGunMetni);

  /// No description provided for @varroaSonKayit.
  ///
  /// In tr, this message translates to:
  /// **'Son kayıt: {tarih} / {yontem}.'**
  String varroaSonKayit(String tarih, String yontem);

  /// No description provided for @kararPasifBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni aktif değil'**
  String get kararPasifBaslik;

  /// No description provided for @kararPasifMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Aktif üretimde değerlendirme. Kayıt olarak tut, gerekiyorsa birleştirme planında düşün.'**
  String get kararPasifMesaj;

  /// No description provided for @kararPasifNedenAktifGorunmuyor.
  ///
  /// In tr, this message translates to:
  /// **'Koloni aktif görünmüyor.'**
  String get kararPasifNedenAktifGorunmuyor;

  /// No description provided for @kararPasifNedenSonmugGorunuyor.
  ///
  /// In tr, this message translates to:
  /// **'Son muayene verisinde koloni sönmüş görünüyor.'**
  String get kararPasifNedenSonmugGorunuyor;

  /// No description provided for @kararPasifNedenIsaretli.
  ///
  /// In tr, this message translates to:
  /// **'Koloni durumu pasif olarak işaretli.'**
  String get kararPasifNedenIsaretli;

  /// No description provided for @kararPasifSecilimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Pasif kayıt'**
  String get kararPasifSecilimBaslik;

  /// No description provided for @kararPasifSecilimMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni aktif üretimde değildir. Soy ve geçmiş takibi için tutulur.'**
  String get kararPasifSecilimMesaj;

  /// No description provided for @kararVetoNedenDogrudanOgul.
  ///
  /// In tr, this message translates to:
  /// **'Kökeni oğul olduğu için temiz donör havuzuna alınmadı.'**
  String get kararVetoNedenDogrudanOgul;

  /// No description provided for @kararVetoNedenKendisiOgul.
  ///
  /// In tr, this message translates to:
  /// **'Kendi geçmişinde oğul attığı için temiz donör havuzuna alınmadı.'**
  String get kararVetoNedenKendisiOgul;

  /// No description provided for @kararVetoNedenAtaHatta.
  ///
  /// In tr, this message translates to:
  /// **'Atasal hatta oğul izi taşıdığı için temiz donör havuzuna alınmadı.'**
  String get kararVetoNedenAtaHatta;

  /// No description provided for @kararVetoNedenGenel.
  ///
  /// In tr, this message translates to:
  /// **'Temiz donör havuzuna alınmadı.'**
  String get kararVetoNedenGenel;

  /// No description provided for @kararVetoBolmeBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Genetik veto var; güvenli bölme veya üretim için kullan'**
  String get kararVetoBolmeBaslik;

  /// No description provided for @kararVetoBolmeMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Ana üretme. 9 çıta ve üstü güçte olduğu için bölme, kapalı yavru desteği veya üretim için değerlendirilebilir.'**
  String get kararVetoBolmeMesaj;

  /// No description provided for @kararVetoBolmeSecilimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Genetik veto / güçlü operasyonel kullanım'**
  String get kararVetoBolmeSecilimBaslik;

  /// No description provided for @kararVetoBolmeSecilimMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Donör havuzunda değil. 9 çıta güvenli saha eşiğini geçtiği için yalnızca operasyonel bölme, destek ve üretim rolünde değerlendirilebilir.'**
  String get kararVetoBolmeSecilimMesaj;

  /// No description provided for @kararVetoUretimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Genetik veto var; üretimde değerlendir'**
  String get kararVetoUretimBaslik;

  /// No description provided for @kararVetoUretimMesajRiskliBand.
  ///
  /// In tr, this message translates to:
  /// **'Ana üretme. 6–8 çıta arası bölme için riskli kabul edilir; sistem bölme önermiyor. Önce güçlendir, üretim ve destek rolünde değerlendir.'**
  String get kararVetoUretimMesajRiskliBand;

  /// No description provided for @kararVetoUretimMesajGecGuclu.
  ///
  /// In tr, this message translates to:
  /// **'Ana üretme. Koloni güçlü üreme gelişimi gösteriyor; ancak bal akımına yakın dönemde standart bölme üretim gücünü düşürebilir. Saha baskısı oluşursa kontrollü bölme ayrıca değerlendirilebilir.'**
  String get kararVetoUretimMesajGecGuclu;

  /// No description provided for @kararVetoUretimMesajGec.
  ///
  /// In tr, this message translates to:
  /// **'Ana üretme. Koloni güçlü olabilir; ancak standart bölme için zaman geç kalmış görünüyor. Üretim gücünü koru.'**
  String get kararVetoUretimMesajGec;

  /// No description provided for @kararVetoUretimMesajOzelStrateji.
  ///
  /// In tr, this message translates to:
  /// **'Ana üretme. Bal akımı içinde standart bölme önerilmez. Yalnızca bilinçli üretim stratejisi olarak yavru azaltma bölmesi ayrıca değerlendirilebilir.'**
  String get kararVetoUretimMesajOzelStrateji;

  /// No description provided for @kararVetoUretimMesajGenel.
  ///
  /// In tr, this message translates to:
  /// **'Ana üretme. Bal ve genel üretim odağında kullan. Donör değil ama çalışkan üretim kolonisi olarak değerlendirilebilir.'**
  String get kararVetoUretimMesajGenel;

  /// No description provided for @kararVetoUretimSecilimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Genetik veto / üretim kolonisi'**
  String get kararVetoUretimSecilimBaslik;

  /// No description provided for @kararVetoUretimSecilimMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Temiz donör havuzunda değil. Buna rağmen üretim ve saha sürekliliği açısından kullanılabilir.'**
  String get kararVetoUretimSecilimMesaj;

  /// No description provided for @kararVetoDestekBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Genetik veto var; destekleyerek kullan'**
  String get kararVetoDestekBaslik;

  /// No description provided for @kararVetoDestekMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Oğul izi olduğundan ana üretiminde kullanma. Gelişimine göre destek kolonisi veya üretim kolonisi olarak kullanılabilir.'**
  String get kararVetoDestekMesaj;

  /// No description provided for @kararVetoDestekSecilimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Genetik veto / destek kullanımı'**
  String get kararVetoDestekSecilimBaslik;

  /// No description provided for @kararVetoDestekSecilimMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Donör havuzunda değil. Güç durumuna göre destek veya üretim kolonisi olarak değerlendirilebilir.'**
  String get kararVetoDestekSecilimMesaj;

  /// No description provided for @kararVetoGuclenirBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Genetik veto var; önce toparla ve izle'**
  String get kararVetoGuclenirBaslik;

  /// No description provided for @kararVetoGuclenirMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Ana üretme. Önce gücünü toparla. Besleme, destek ve yakın muayene ile gelişimine bak; sonra saha rolünü netleştir.'**
  String get kararVetoGuclenirMesaj;

  /// No description provided for @kararVetoGuclenirSecilimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Genetik veto / önce toparlanmalı'**
  String get kararVetoGuclenirSecilimBaslik;

  /// No description provided for @kararVetoGuclenirSecilimMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Donör havuzunda değil. Önce güç kazanmalı; sonra yalnızca operasyonel rolü yeniden okunmalıdır.'**
  String get kararVetoGuclenirSecilimMesaj;

  /// No description provided for @kararDonor1Baslik.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni 1. donör adayı'**
  String get kararDonor1Baslik;

  /// No description provided for @kararDonor1MesajBase.
  ///
  /// In tr, this message translates to:
  /// **'Ana üretiminde öncelikli. Gücünü koru. Bölme veya başka kullanım kararını donör değerini bozmayacak şekilde düşün.'**
  String get kararDonor1MesajBase;

  /// No description provided for @kararDonor1NedeniBase.
  ///
  /// In tr, this message translates to:
  /// **'Donör havuzundaki en güçlü koloni olarak öne çıkıyor. Donör skoru: {donorSkoru} / 100.'**
  String kararDonor1NedeniBase(int donorSkoru);

  /// No description provided for @kararDonor1SecilimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni 1. donör adayı'**
  String get kararDonor1SecilimBaslik;

  /// No description provided for @kararDonor1SecilimMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni donör havuzunda ilk sırada yer alıyor ve ana üretimi için en güçlü aday kabul ediliyor.'**
  String get kararDonor1SecilimMesaj;

  /// No description provided for @kararDonor2Baslik.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni 2. donör adayı'**
  String get kararDonor2Baslik;

  /// No description provided for @kararDonor2MesajBase.
  ///
  /// In tr, this message translates to:
  /// **'Ana üretiminde güçlü bir alternatif olarak değerlendir. İlk tercihin uygun değilse buna yönel.'**
  String get kararDonor2MesajBase;

  /// No description provided for @kararDonor2NedeniBase.
  ///
  /// In tr, this message translates to:
  /// **'Donör havuzunda üst sırada yer alıyor. Donör skoru: {donorSkoru} / 100.'**
  String kararDonor2NedeniBase(int donorSkoru);

  /// No description provided for @kararDonor2SecilimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni 2. donör adayı'**
  String get kararDonor2SecilimBaslik;

  /// No description provided for @kararDonor2SecilimMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni donör havuzunda üst sırada yer alıyor ve ana üretimi için güçlü alternatif kabul ediliyor.'**
  String get kararDonor2SecilimMesaj;

  /// No description provided for @kararDonor3Baslik.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni 3. donör adayı'**
  String get kararDonor3Baslik;

  /// No description provided for @kararDonor3MesajBase.
  ///
  /// In tr, this message translates to:
  /// **'Ana üretiminde yedek güçlü aday olarak değerlendir. Üretimde de değerli kalabilir.'**
  String get kararDonor3MesajBase;

  /// No description provided for @kararDonor3NedeniBase.
  ///
  /// In tr, this message translates to:
  /// **'Donör havuzunda ilk üç içinde yer alıyor. Donör skoru: {donorSkoru} / 100.'**
  String kararDonor3NedeniBase(int donorSkoru);

  /// No description provided for @kararDonor3SecilimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni 3. donör adayı'**
  String get kararDonor3SecilimBaslik;

  /// No description provided for @kararDonor3SecilimMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni donör havuzunda ilk üç içinde yer alıyor ve ana üretimi için değerlendirilebilir.'**
  String get kararDonor3SecilimMesaj;

  /// No description provided for @kararSartliDonorBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni donör havuzunda, ama ilk sıralarda değil'**
  String get kararSartliDonorBaslik;

  /// No description provided for @kararSartliDonorMesajBase.
  ///
  /// In tr, this message translates to:
  /// **'Üretimde değerlendir. Gelişimi sürerse ileride donör alternatifi olarak yeniden bak.'**
  String get kararSartliDonorMesajBase;

  /// No description provided for @kararSartliDonorNedeniBase.
  ///
  /// In tr, this message translates to:
  /// **'Donör havuzuna girmiş olsa da şu an ilk üçte değil. Donör skoru: {donorSkoru} / 100.'**
  String kararSartliDonorNedeniBase(int donorSkoru);

  /// No description provided for @kararSartliDonorSecilimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Donör havuzunda'**
  String get kararSartliDonorSecilimBaslik;

  /// No description provided for @kararSartliDonorSecilimMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni donör havuzuna girmiş durumda; ancak şu an ilk sıradaki adaylardan biri değil.'**
  String get kararSartliDonorSecilimMesaj;

  /// No description provided for @kararAnaDegisimZamanBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni için ana değişimi zamanı uygun'**
  String get kararAnaDegisimZamanBaslik;

  /// No description provided for @kararAnaDegisimPlanlaBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Ana değişimini sezon planına al'**
  String get kararAnaDegisimPlanlaBaslik;

  /// No description provided for @kararAnaDegisimZamanMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Hasat sonrası pencere ana değişimi için uygundur. Üretimde kalacaksa genç ve güvenilir bir ana ile yenilemek doğru olabilir.'**
  String get kararAnaDegisimZamanMesaj;

  /// No description provided for @kararAnaDegisimPlanMesajBase.
  ///
  /// In tr, this message translates to:
  /// **'Ana yaşı izlenmeli; ancak planlı ana değişimi için en güçlü pencere hasat sonrasıdır. Zorunlu sorun yoksa takvime al.'**
  String get kararAnaDegisimPlanMesajBase;

  /// No description provided for @kararAnaDegisimNedeni.
  ///
  /// In tr, this message translates to:
  /// **'Ana yaşı {anaYasi} yıl görünüyor. Ürün standardında 2 yaş ana değişimi için dikkat eşiğidir.'**
  String kararAnaDegisimNedeni(int anaYasi);

  /// No description provided for @kararAnaDegisimZamanSecilimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Ana değişimi için uygun pencere'**
  String get kararAnaDegisimZamanSecilimBaslik;

  /// No description provided for @kararAnaDegisimPlanSecilimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Ana değişimi planlanmalı'**
  String get kararAnaDegisimPlanSecilimBaslik;

  /// No description provided for @kararAnaDegisimSecilimMesajVarsayilan.
  ///
  /// In tr, this message translates to:
  /// **'Koloni tamamen olumsuz değildir; ancak daha iyi verim için ana yenileme düşünülebilir.'**
  String get kararAnaDegisimSecilimMesajVarsayilan;

  /// No description provided for @kararBolmeUygunBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni bölme için uygun görünüyor'**
  String get kararBolmeUygunBaslik;

  /// No description provided for @kararBolmeUygunMesaj.
  ///
  /// In tr, this message translates to:
  /// **'9 çıta ve üstü güçte. Donör önceliğinde değilse güvenli bölme için değerlendirilebilir. Ana koloni en az 5 çıta kalmalı, yeni bölme en az 4 çıta başlamalı.'**
  String get kararBolmeUygunMesaj;

  /// No description provided for @kararBolmeUygunNedeni.
  ///
  /// In tr, this message translates to:
  /// **'Koloni 9 çıta güvenli saha eşiğini karşılıyor, üretim sezonunda ve trend düşüşte değil.'**
  String get kararBolmeUygunNedeni;

  /// No description provided for @kararBolmeUygunSecilimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bölme için uygun'**
  String get kararBolmeUygunSecilimBaslik;

  /// No description provided for @kararBolmeUygunSecilimMesaj.
  ///
  /// In tr, this message translates to:
  /// **'9 çıta güvenli saha eşiği karşılandığı için donör önceliğinde değilse bölme için değerlendirilebilir.'**
  String get kararBolmeUygunSecilimMesaj;

  /// No description provided for @kararBolmeRiskliBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bölme için güç sınırında'**
  String get kararBolmeRiskliBaslik;

  /// No description provided for @kararBolmeRiskliMesaj.
  ///
  /// In tr, this message translates to:
  /// **'6–8 çıta arası biyolojik olarak mümkün görünse de ITOGENA bölme önermiyor. Önce güçlendir, 9 çıta ve üstünde yeniden değerlendir.'**
  String get kararBolmeRiskliMesaj;

  /// No description provided for @kararBolmeRiskliNedeni.
  ///
  /// In tr, this message translates to:
  /// **'Güvenli saha bölme eşiği 9 çıtadır. Daha düşük güçte hem ana koloni hem yeni bölme kaybedilebilir.'**
  String get kararBolmeRiskliNedeni;

  /// No description provided for @kararBolmeRiskliSecilimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bölme önerilmez'**
  String get kararBolmeRiskliSecilimBaslik;

  /// No description provided for @kararBolmeRiskliSecilimMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Koloni güçlenene kadar üretim, destek veya takip rolünde tutulmalıdır.'**
  String get kararBolmeRiskliSecilimMesaj;

  /// No description provided for @kararBolmeZamaniGecBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Güç var; standart bölme zamanı zayıf'**
  String get kararBolmeZamaniGecBaslik;

  /// No description provided for @kararBolmeZamaniGecMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Koloni 9 çıta eşiğini karşılıyor; ancak bal akımına 57 günden az kaldığı için standart bölme üretim gücünü düşürebilir. Bu dönemde koloni gücünü koru.'**
  String get kararBolmeZamaniGecMesaj;

  /// No description provided for @kararBolmeZamaniGecSecilimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bölme yerine üretimde tut'**
  String get kararBolmeZamaniGecSecilimBaslik;

  /// No description provided for @kararBolmeZamaniGecSecilimMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Zaman penceresi nedeniyle bölme kararı güçlü görünmüyor; üretim gücü korunmalıdır.'**
  String get kararBolmeZamaniGecSecilimMesaj;

  /// No description provided for @kararBalAkimiOzelBolmeBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımında standart bölme önerilmez'**
  String get kararBalAkimiOzelBolmeBaslik;

  /// No description provided for @kararBalAkimiOzelBolmeMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Koloni güçlü; fakat bal akımı içinde standart bölme önerisi verilmez. Yalnızca bilinçli üretim stratejisi olarak yavru azaltma bölmesi ayrıca değerlendirilebilir.'**
  String get kararBalAkimiOzelBolmeMesaj;

  /// No description provided for @kararBalAkimiOzelBolmeSecilimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Özel üretim stratejisi'**
  String get kararBalAkimiOzelBolmeSecilimBaslik;

  /// No description provided for @kararBalAkimiOzelBolmeSecilimMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Bu karar otomatik bölme önerisi değildir; arıcının hedeflediği üretim tekniğine bağlıdır.'**
  String get kararBalAkimiOzelBolmeSecilimMesaj;

  /// No description provided for @kararGucluKoloniBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Güçlü koloni; bölme zamanı değil'**
  String get kararGucluKoloniBaslik;

  /// No description provided for @kararGucluKoloniMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Koloni güçlü görünüyor; ancak bu tarih aralığında standart bölme kararı ciddi görünmez. Gücü üretim, bakım veya sezon planında değerlendir.'**
  String get kararGucluKoloniMesaj;

  /// No description provided for @kararGucluKoloniSecilimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Üretimde değerlendir'**
  String get kararGucluKoloniSecilimBaslik;

  /// No description provided for @kararGucluKoloniSecilimMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Koloni gücü değerli; zaman penceresi uygun olduğunda bölme yeniden okunabilir.'**
  String get kararGucluKoloniSecilimMesaj;

  /// No description provided for @kararUretimdeBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni üretimde değerlendirilebilir'**
  String get kararUretimdeBaslik;

  /// No description provided for @kararUretimMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Bal ve genel üretim odağında kullan. Sezona göre destek veya üretim rolünde değerlendir.'**
  String get kararUretimMesaj;

  /// No description provided for @kararUretimNedeni.
  ///
  /// In tr, this message translates to:
  /// **'Performansı üretim için yeterli görünüyor.'**
  String get kararUretimNedeni;

  /// No description provided for @kararUretimSecilimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Üretimde değerlendir'**
  String get kararUretimSecilimBaslik;

  /// No description provided for @kararUretimSecilimMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni üretim ve süreklilik açısından değerlidir; donör önceliğinde görünmüyor.'**
  String get kararUretimSecilimMesaj;

  /// No description provided for @kararVeriGuveniDusukBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Karar var; veri güveni düşük'**
  String get kararVeriGuveniDusukBaslik;

  /// No description provided for @kararVeriGuveniDusukMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut kayda göre rolü izleme ve güçlendirme tarafında. Tek muayene kesin hüküm için zayıftır; ikinci ve üçüncü kayıtla karar netleşir.'**
  String get kararVeriGuveniDusukMesaj;

  /// No description provided for @kararVeriGuveniDusukNedeni.
  ///
  /// In tr, this message translates to:
  /// **'Sistem karar üretir, ancak muayene verisi etkili değerlendirme için henüz sınırlıdır.'**
  String get kararVeriGuveniDusukNedeni;

  /// No description provided for @kararVeriGuveniDusukSecilimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Veri güveni düşük'**
  String get kararVeriGuveniDusukSecilimBaslik;

  /// No description provided for @kararVeriGuveniDusukSecilimMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Donör ya da üretim rolü tamamen kapatılmaz; ancak kararın güven düzeyi düşük olduğu açıkça izlenmelidir.'**
  String get kararVeriGuveniDusukSecilimMesaj;

  /// No description provided for @kararYakinTakipBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloniye yakından bakmak gerekir'**
  String get kararYakinTakipBaslik;

  /// No description provided for @kararYakinTakipMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Destek, besleme ve sık muayene ile gelişimi yeniden değerlendir.'**
  String get kararYakinTakipMesaj;

  /// No description provided for @kararYakinTakipNedeni.
  ///
  /// In tr, this message translates to:
  /// **'Güç veya gidişat istenen seviyede görünmüyor.'**
  String get kararYakinTakipNedeni;

  /// No description provided for @kararYakinTakipSecilimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'İzleyerek karar ver'**
  String get kararYakinTakipSecilimBaslik;

  /// No description provided for @kararYakinTakipSecilimMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni için hüküm vermeden önce biraz daha veri ve gözlem gerekir.'**
  String get kararYakinTakipSecilimMesaj;

  /// No description provided for @kararDestekRolBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloniyi destek rolünde değerlendir'**
  String get kararDestekRolBaslik;

  /// No description provided for @kararDestekRolMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Şu an için en doğru rol destek ve düzenli takip görünüyor. Güçlenirse sonraki değerlendirmede üretimde daha öne çıkabilir.'**
  String get kararDestekRolMesaj;

  /// No description provided for @kararDestekRolNedeni.
  ///
  /// In tr, this message translates to:
  /// **'Donör havuzunda üst sırada değil, ama tamamen olumsuz da görünmüyor.'**
  String get kararDestekRolNedeni;

  /// No description provided for @kararDestekRolSecilimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Destek / üretim rolü'**
  String get kararDestekRolSecilimBaslik;

  /// No description provided for @kararDestekRolSecilimMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni destek ve süreklilik açısından değerlidir; donör önceliğinde görünmüyor.'**
  String get kararDestekRolSecilimMesaj;

  /// No description provided for @kararKartDurum.
  ///
  /// In tr, this message translates to:
  /// **'Durum'**
  String get kararKartDurum;

  /// No description provided for @kararKartNeYap.
  ///
  /// In tr, this message translates to:
  /// **'Ne yap'**
  String get kararKartNeYap;

  /// No description provided for @kararKartVeriGuveni.
  ///
  /// In tr, this message translates to:
  /// **'Veri Güveni'**
  String get kararKartVeriGuveni;

  /// No description provided for @kararKartZamanBaglami.
  ///
  /// In tr, this message translates to:
  /// **'Zaman Bağlamı'**
  String get kararKartZamanBaglami;

  /// No description provided for @kararKartBiyolojikDurum.
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik Durum'**
  String get kararKartBiyolojikDurum;

  /// No description provided for @kararKartBiyolojikNot.
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik Not'**
  String get kararKartBiyolojikNot;

  /// No description provided for @kararKartSahadaOncelik.
  ///
  /// In tr, this message translates to:
  /// **'Sahada Öncelik'**
  String get kararKartSahadaOncelik;

  /// No description provided for @kararKartZamanBaglamiVarsayilan.
  ///
  /// In tr, this message translates to:
  /// **'Karar mevcut sezon ve bal akımı takvimine göre okunur.'**
  String get kararKartZamanBaglamiVarsayilan;

  /// No description provided for @kararKartBiyolojikOncelik.
  ///
  /// In tr, this message translates to:
  /// **'Bu koloni biyolojik zamanlama açısından öncelikli kontrol istemektedir.'**
  String get kararKartBiyolojikOncelik;

  /// No description provided for @veriGuveniYok.
  ///
  /// In tr, this message translates to:
  /// **'Veri yok'**
  String get veriGuveniYok;

  /// No description provided for @veriGuveniCokSinirli.
  ///
  /// In tr, this message translates to:
  /// **'Veri çok sınırlı'**
  String get veriGuveniCokSinirli;

  /// No description provided for @veriGuveniIzlenmeli.
  ///
  /// In tr, this message translates to:
  /// **'Veri izlenmeli'**
  String get veriGuveniIzlenmeli;

  /// No description provided for @veriGuveniYeterli.
  ///
  /// In tr, this message translates to:
  /// **'Veri güveni yeterli'**
  String get veriGuveniYeterli;

  /// No description provided for @veriGuveniNotYok.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt yoksa sistem yalnızca kimlik ve kaynak bilgisine göre sınırlı yorum yapabilir.'**
  String get veriGuveniNotYok;

  /// No description provided for @veriGuveniNotTek.
  ///
  /// In tr, this message translates to:
  /// **'Tek muayene karar üretir ama güven zayıftır; donör ve ana değişim kararlarında temkinli okunmalıdır.'**
  String get veriGuveniNotTek;

  /// No description provided for @veriGuveniNotAz.
  ///
  /// In tr, this message translates to:
  /// **'2–4 muayene izleme bandıdır; karar var ama sonraki kayıtlarla güçlenmelidir.'**
  String get veriGuveniNotAz;

  /// No description provided for @veriGuveniNotYeterli.
  ///
  /// In tr, this message translates to:
  /// **'5 ve üzeri muayene ile değerlendirme güvenilir banda girmiştir.'**
  String get veriGuveniNotYeterli;

  /// No description provided for @davranisNotuSaldirganEsnek.
  ///
  /// In tr, this message translates to:
  /// **' Davranış açısından not düşülmüş durumda; ancak kullanıcı ayarı esnek olduğu için veto uygulanmadı.'**
  String get davranisNotuSaldirganEsnek;

  /// No description provided for @davranisNotuSaldirgan.
  ///
  /// In tr, this message translates to:
  /// **' Davranış açısından dikkat notu bulunuyor.'**
  String get davranisNotuSaldirgan;

  /// No description provided for @davranisNotuSinirli.
  ///
  /// In tr, this message translates to:
  /// **' Davranış açısından hafif bir dikkat notu bulunuyor.'**
  String get davranisNotuSinirli;

  /// No description provided for @kisYorumCokGuclu.
  ///
  /// In tr, this message translates to:
  /// **'Çok güçlü çıkış'**
  String get kisYorumCokGuclu;

  /// No description provided for @kisYorumGuclu.
  ///
  /// In tr, this message translates to:
  /// **'Güçlü çıkış'**
  String get kisYorumGuclu;

  /// No description provided for @kisYorumOrta.
  ///
  /// In tr, this message translates to:
  /// **'Orta çıkış'**
  String get kisYorumOrta;

  /// No description provided for @kisYorumZayif.
  ///
  /// In tr, this message translates to:
  /// **'Zayıf çıkış'**
  String get kisYorumZayif;

  /// No description provided for @kisYorumRiskli.
  ///
  /// In tr, this message translates to:
  /// **'Riskli çıkış'**
  String get kisYorumRiskli;

  /// No description provided for @biyoKabiliyetPetekOrmeBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik Kabiliyet'**
  String get biyoKabiliyetPetekOrmeBaslik;

  /// No description provided for @biyoKabiliyetPetekOrmeMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Petek örme kapasitesi güçlü görünüyor. Ham petek verilecekse yavru bloğu kesilmeden dıştan genişletme daha güvenlidir.'**
  String get biyoKabiliyetPetekOrmeMesaj;

  /// No description provided for @biyoGenisletmeRiskiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Genişletme Riski'**
  String get biyoGenisletmeRiskiBaslik;

  /// No description provided for @biyoGenisletmeRiskiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Petek örme kapasitesi sınırlı görünüyor. Ham petek yerine kabarmış petek veya sıkı düzen daha güvenlidir.'**
  String get biyoGenisletmeRiskiMesaj;

  /// No description provided for @biyoBalAkimiKapasitesiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bal Akımı Kapasitesi'**
  String get biyoBalAkimiKapasitesiBaslik;

  /// No description provided for @biyoBalAkimiKapasitesiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Tarlacı ve bal işleme kapasitesi güçlü görünüyor. Bal akımı döneminde alan, kat ve sırlanma takibi öne alınmalı.'**
  String get biyoBalAkimiKapasitesiMesaj;

  /// No description provided for @biyoBakiciDengesiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bakıcı Dengesi'**
  String get biyoBakiciDengesiBaslik;

  /// No description provided for @biyoBakiciDengesiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Yavru bakım kapasitesi iyi fakat petek örme sınırlı. Yavru alanını bozmayacak kabarmış petek, ham petekten daha güvenli olur.'**
  String get biyoBakiciDengesiMesaj;

  /// No description provided for @biyoKisGuvenligi.
  ///
  /// In tr, this message translates to:
  /// **'Kış Güvenliği'**
  String get biyoKisGuvenligi;

  /// No description provided for @biyoKisGuvenligiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Kış dayanımı sınırlı görünüyor. Öncelik hasat veya genişletme değil stok güvenliği ve sıkı düzendir.'**
  String get biyoKisGuvenligiMesaj;

  /// No description provided for @biyoSahaNotu.
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik Saha Notu'**
  String get biyoSahaNotu;

  /// No description provided for @genetikRiskVetoOgul.
  ///
  /// In tr, this message translates to:
  /// **'Oğul kökeni/izi genetik yayılım için veto kabul edildi.'**
  String get genetikRiskVetoOgul;

  /// No description provided for @genetikVetoOzet.
  ///
  /// In tr, this message translates to:
  /// **'Üretim değeri ayrı tutulur; genetik çoğaltma kararı veto edilir.'**
  String get genetikVetoOzet;

  /// No description provided for @genetikRiskKapasiteDusuk.
  ///
  /// In tr, this message translates to:
  /// **'İşlevsel çıta kapasitesi çoğaltma için düşük.'**
  String get genetikRiskKapasiteDusuk;

  /// No description provided for @genetikRiskYavruNetlesme.
  ///
  /// In tr, this message translates to:
  /// **'Yavru düzeni netleşmeden genetik yayılım öne çıkarılmaz.'**
  String get genetikRiskYavruNetlesme;

  /// No description provided for @genetikRiskGucDususu.
  ///
  /// In tr, this message translates to:
  /// **'Son kayıtta güç düşüşü var; çoğaltma yerine neden analizi gerekir.'**
  String get genetikRiskGucDususu;

  /// No description provided for @genetikRiskAktivasyonDusuk.
  ///
  /// In tr, this message translates to:
  /// **'Aktivasyon düşük; fiziksel çıta genetik kapasite gibi okunmamalı.'**
  String get genetikRiskAktivasyonDusuk;

  /// No description provided for @genetikRiskKisStok.
  ///
  /// In tr, this message translates to:
  /// **'Kış/hasat sonrası stok güvenliği zayıf.'**
  String get genetikRiskKisStok;

  /// No description provided for @genetikRiskAnaSureci.
  ///
  /// In tr, this message translates to:
  /// **'Ana/yavru süreci açık; genetik karar izleme bandına çekilir.'**
  String get genetikRiskAnaSureci;

  /// No description provided for @genetikRiskBolmeToparlanma.
  ///
  /// In tr, this message translates to:
  /// **'Bölme toparlanması tamamlanmadan yeni çoğaltma hedefi açılmaz.'**
  String get genetikRiskBolmeToparlanma;

  /// No description provided for @genetikRiskSisirme.
  ///
  /// In tr, this message translates to:
  /// **'Riskli şişirme var; fiziksel genişleme genetik başarı sayılmaz.'**
  String get genetikRiskSisirme;

  /// No description provided for @genetikOzetYuksek.
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik kapasite, yavru düzeni, istikrar ve süreç güvenliği çoğaltma için güçlü sinyal veriyor.'**
  String get genetikOzetYuksek;

  /// No description provided for @genetikOzetIzle.
  ///
  /// In tr, this message translates to:
  /// **'Olumlu genetik sinyaller var; karar için istikrar, süreç kapanışı ve sezon penceresi birlikte izlenmeli.'**
  String get genetikOzetIzle;

  /// No description provided for @genetikOzetDusuk.
  ///
  /// In tr, this message translates to:
  /// **'Çoğaltma değeri düşük/temkinli: {risk}'**
  String genetikOzetDusuk(String risk);

  /// No description provided for @genetikOzetVarsayilan.
  ///
  /// In tr, this message translates to:
  /// **'Çoğaltma değeri şu aşamada öncelikli değil.'**
  String get genetikOzetVarsayilan;

  /// No description provided for @varroaKisaVetoDikkat.
  ///
  /// In tr, this message translates to:
  /// **'Varroa dikkat'**
  String get varroaKisaVetoDikkat;

  /// No description provided for @varroaKisaVarroa.
  ///
  /// In tr, this message translates to:
  /// **'Varroa'**
  String get varroaKisaVarroa;

  /// No description provided for @varroaVetoBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bal döneminde varroa mücadelesinde kalıntı riskine dikkat'**
  String get varroaVetoBaslik;

  /// No description provided for @varroaVetoMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı/hasat döneminde kalıntı riski olan kimyasal mücadele önerilmez. Gerekiyorsa organik yöntemler değerlendirilir.'**
  String get varroaVetoMesaj;

  /// No description provided for @yonetimBolmeAdayi.
  ///
  /// In tr, this message translates to:
  /// **'Bölme adayı'**
  String get yonetimBolmeAdayi;

  /// No description provided for @yonetimBolmeDikkat.
  ///
  /// In tr, this message translates to:
  /// **'Bölme dikkat'**
  String get yonetimBolmeDikkat;

  /// No description provided for @yonetimKontrolluBolmeBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Genetik çoğaltma / kontrollü bölme penceresi'**
  String get yonetimKontrolluBolmeBaslik;

  /// No description provided for @yonetimSinirliiBolmeBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Sınırlı bölme değerlendirmesi'**
  String get yonetimSinirliiBolmeBaslik;

  /// No description provided for @yonetimKatVerKisa.
  ///
  /// In tr, this message translates to:
  /// **'Kat ver'**
  String get yonetimKatVerKisa;

  /// No description provided for @yonetimKatVerBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kat / ballık ver'**
  String get yonetimKatVerBaslik;

  /// No description provided for @yonetimUcuncuKatKisa.
  ///
  /// In tr, this message translates to:
  /// **'3. kat ver'**
  String get yonetimUcuncuKatKisa;

  /// No description provided for @yonetimUcuncuKatBaslik.
  ///
  /// In tr, this message translates to:
  /// **'3. kat / ikinci ballık ver'**
  String get yonetimUcuncuKatBaslik;

  /// No description provided for @yonetimAlanBallikBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Alan ihtiyacı / ballık değerlendirme'**
  String get yonetimAlanBallikBaslik;

  /// No description provided for @yonetimAlanCitaBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Alan ihtiyacı / çıta ekleme'**
  String get yonetimAlanCitaBaslik;

  /// No description provided for @yonetimAlanGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Aktivasyon oranı koloni gücü etiketi değildir; mevcut hacmin dolduğunu ve alan ihtiyacını gösterir.'**
  String get yonetimAlanGerekce;

  /// No description provided for @yonetimAlanAcKisa.
  ///
  /// In tr, this message translates to:
  /// **'Alan aç'**
  String get yonetimAlanAcKisa;

  /// No description provided for @yonetimHasatBakimKisa.
  ///
  /// In tr, this message translates to:
  /// **'Bakım'**
  String get yonetimHasatBakimKisa;

  /// No description provided for @yonetimHasatBakimBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Hasat sonrası bakım yönü'**
  String get yonetimHasatBakimBaslik;

  /// No description provided for @yonetimKisHazirlikKisa.
  ///
  /// In tr, this message translates to:
  /// **'Kış hazırlık'**
  String get yonetimKisHazirlikKisa;

  /// No description provided for @yonetimKisHazirlikBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kışa hazırlık kontrolü'**
  String get yonetimKisHazirlikBaslik;

  /// No description provided for @beslemeFeedingNone.
  ///
  /// In tr, this message translates to:
  /// **'Besleme yok'**
  String get beslemeFeedingNone;

  /// No description provided for @beslemeFeedingShort.
  ///
  /// In tr, this message translates to:
  /// **'Besleme'**
  String get beslemeFeedingShort;

  /// No description provided for @beslemeFeedingWatch.
  ///
  /// In tr, this message translates to:
  /// **'Besleme izle'**
  String get beslemeFeedingWatch;

  /// No description provided for @beslemeFeedingNotRecommended.
  ///
  /// In tr, this message translates to:
  /// **'Besleme önerilmez'**
  String get beslemeFeedingNotRecommended;

  /// No description provided for @beslemeRiskEtiketi.
  ///
  /// In tr, this message translates to:
  /// **'Risk: {risk}'**
  String beslemeRiskEtiketi(String risk);

  /// No description provided for @surecOgulRiskiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Oğul riski'**
  String get surecOgulRiskiBaslik;

  /// No description provided for @surecOgulBelirtisi3GunMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Ana memesi görüldü. Bu sağlık sorunu değil, oğul davranışı ve koloni sıkışıklığı işaretidir. Koloniyi sakin biçimde kontrol et; gerekiyorsa bölme yap veya 1–2 kaliteli meme bırakıp fazlasını azalt.'**
  String get surecOgulBelirtisi3GunMesaj;

  /// No description provided for @surecOgulBelirtisi7GunMesaj.
  ///
  /// In tr, this message translates to:
  /// **'İlk hafta artçı oğul riski yüksektir. Meme sayısını kontrol et; birden fazla güçlü meme bırakmak koloniyi tekrar bölebilir. Gerekiyorsa bölme veya fazla memeleri azaltma kararı ver.'**
  String get surecOgulBelirtisi7GunMesaj;

  /// No description provided for @surecOgulRiskiTakibiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Oğul riski takibi'**
  String get surecOgulRiskiTakibiBaslik;

  /// No description provided for @surecOgulBelirtisiTakipMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Oğul belirtisi takip döneminde. Yeni meme, sıkışıklık veya huzursuzluk yoksa süreç kendiliğinden sönümlenir; gereksiz tekrar uyarı üretmez.'**
  String get surecOgulBelirtisiTakipMesaj;

  /// No description provided for @surecOgulSonrasiTekrarBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Tekrarlayan oğul / nüfus kaybı riski'**
  String get surecOgulSonrasiTekrarBaslik;

  /// No description provided for @surecOgulSonrasiTekrarMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Oğul kaydı tekrar ediyor. Bu artık normal artçı takibi değil; koloni hızla nüfus kaybedebilir. Meme sayısı, kalan arı gücü, stok ve ana belirtisi birlikte okunmalı. Çok zayıfladıysa yoğun emek yerine birleştirme veya sınırlı destek daha doğru olabilir.'**
  String get surecOgulSonrasiTekrarMesaj;

  /// No description provided for @surecOgulSonrasiArtciRiskBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Oğul sonrası artçı riski yüksek'**
  String get surecOgulSonrasiArtciRiskBaslik;

  /// No description provided for @surecOgulSonrasiArtciRiskMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Oğul sonrası ilk hafta artçı oğul riski yüksektir. Amaç koloniyi tekrar böldürmemektir. Kontrol gerekiyorsa kısa ve sakin yapılmalı; fazla meme bırakmak tekrar nüfus kaybı doğurabilir. Üretim/kat/hasat kararı geri plandadır.'**
  String get surecOgulSonrasiArtciRiskMesaj;

  /// No description provided for @surecArtciOgulTakipBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Artçı oğul riski izleniyor'**
  String get surecArtciOgulTakipBaslik;

  /// No description provided for @surecArtciOgulTakipMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Artçı oğul riski devam eder ama ilk haftaya göre azalır. Yeni meme, huzursuzluk veya tekrar çıkış belirtisi yoksa ana sürecini bozmadan beklemek daha doğrudur. Günlük veya kapalı yavru görülürse süreç kapanır.'**
  String get surecArtciOgulTakipMesaj;

  /// No description provided for @surecOgulSonrasiAnaCiftlesmeBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Oğul sonrası ana / çiftleşme süreci'**
  String get surecOgulSonrasiAnaCiftlesmeBaslik;

  /// No description provided for @surecOgulSonrasiAnaCiftlesmeMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Artçı riski büyük ölçüde kapanır. Bu dönem yeni ana çıkışı, olgunlaşma ve çiftleşme penceresidir. Yavru hâlâ görülmeyebilir; bu tek başına çöküş sayılmaz. Dış uçuş, polen gelişi ve sakinlik izlenir. Günlük veya kapalı yavru görülürse muayenede işaretle, süreç kapanır.'**
  String get surecOgulSonrasiAnaCiftlesmeMesaj;

  /// No description provided for @surecOgulSonrasiYumurtlamaBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Oğul sonrası yumurtlama kontrolü'**
  String get surecOgulSonrasiYumurtlamaBaslik;

  /// No description provided for @surecOgulSonrasiYumurtlamaMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Oğul sonrası 31–45. gün arası artık yumurtlama netleşmelidir. Günlük veya kapalı yavru görülürse süreç kapanır. Hâlâ yavru yoksa bu süreç normal bekleme olmaktan çıkar; ana başarısızlığı, çiftleşme kaybı veya yalancı ana riski yavru-yok tanısı ile öne alınır.'**
  String get surecOgulSonrasiYumurtlamaMesaj;

  /// No description provided for @surecBolmeSonrasiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Bölme sonrası toparlanma'**
  String get surecBolmeSonrasiBaslik;

  /// No description provided for @surecBolmeSonrasi30GunMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Koloniyi sıkışık tut ve besleme yap. Yeni düzen kurulana kadar destek gerekir.'**
  String get surecBolmeSonrasi30GunMesaj;

  /// No description provided for @surecBolmeSonrasiGecMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Ana durumunu kontrol et. Toparlanma gecikmiş olabilir.'**
  String get surecBolmeSonrasiGecMesaj;

  /// No description provided for @surecBaglamAnaKazanma.
  ///
  /// In tr, this message translates to:
  /// **'ana kazanma'**
  String get surecBaglamAnaKazanma;

  /// No description provided for @surecBaglamOgulSonrasi.
  ///
  /// In tr, this message translates to:
  /// **'oğul sonrası'**
  String get surecBaglamOgulSonrasi;

  /// No description provided for @surecBaglamBolmeSonrasi.
  ///
  /// In tr, this message translates to:
  /// **'bölme sonrası'**
  String get surecBaglamBolmeSonrasi;

  /// No description provided for @surecYavruYokNormalBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Yavru yokluğu bu aşamada normal olabilir'**
  String get surecYavruYokNormalBaslik;

  /// No description provided for @surecYavruYokNormalMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Yavru düzeni \"Yok\" kaydedildi; ancak {baglam} sürecinde {gun}. gündesin. Bu dönemde yavru görülmemesi tek başına sorun değildir. Kovanı bu tarihte açmak gerekli olmayabilir; gereksiz açma bakire ana ve kabul sürecini bozabilir.'**
  String surecYavruYokNormalMesaj(String baglam, int gun);

  /// No description provided for @surecYavruYokErkenTakipBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Yumurtlama için hâlâ erken olabilir'**
  String get surecYavruYokErkenTakipBaslik;

  /// No description provided for @surecYavruYokErkenTakipMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Yavru düzeni \"Yok\" kaydedildi. {baglam} sürecinden {gun} gün geçmiş. Koloni sakin ve çalışıyorsa hemen sert müdahale önerilmez; 5–7 gün sonra günlük yumurta / genç larva kontrolü daha doğru olur.'**
  String surecYavruYokErkenTakipMesaj(String baglam, int gun);

  /// No description provided for @surecYavruYokBalBaskisiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Yavru yokluğu bal baskısıyla ilişkili olabilir'**
  String get surecYavruYokBalBaskisiBaslik;

  /// No description provided for @surecYavruYokBalBaskisiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Yavru görünmemesi doğrudan anasızlık anlamına gelmeyebilir. Bal akımı aktif ve ballı çıta oranı yüksek görünüyor; ana yumurtlayacak boş alan bulamıyor olabilir. Önce alan ve bal baskısını değerlendir, erken ana müdahalesi yapma.'**
  String get surecYavruYokBalBaskisiMesaj;

  /// No description provided for @surecYavruYokAnaProblemiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Ana kalitesi / yalancı ana riski'**
  String get surecYavruYokAnaProblemiBaslik;

  /// No description provided for @surecYavruYokAnaProblemiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Yavru yokluğu erkek yavru baskısı veya düzensiz yumurta belirtisiyle birlikte okunuyor. Bu durum çiftleşememiş ana, sperm problemi veya yalancı ana başlangıcı anlamına gelebilir. Beklemeyi uzatma; koloni gücüne göre ana değiştirme veya birleştirme değerlendir.'**
  String get surecYavruYokAnaProblemiMesaj;

  /// No description provided for @surecYavruYokBiyolojikCokusBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Biyolojik geri dönüş kapasitesi düşük'**
  String get surecYavruYokBiyolojikCokusBaslik;

  /// No description provided for @surecYavruYokBiyolojikCokusMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Koloni uzun süredir yeni işçi üretmiyor olabilir. {cita} çıta seviyesinde yavrusuzluk uzarsa mevcut nüfus yaşlanır ve koloni doğal küçülmeye gidebilir. Yoğun emek harcamadan önce güçlü koloniyle birleştirme veya sınırlı destek seçeneğini değerlendir.'**
  String surecYavruYokBiyolojikCokusMesaj(int cita);

  /// No description provided for @surecYavruYokGecikmisTaniBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Yavru yokluğu riskli gecikmeye girdi'**
  String get surecYavruYokGecikmisTaniBaslik;

  /// No description provided for @surecYavruYokGecikmisTaniTemel.
  ///
  /// In tr, this message translates to:
  /// **'Beklenen yumurtlama penceresi aşılmaya başladı. Geç çiftleşme, arı kuşu kaynaklı ana kaybı, ana başarısızlığı veya zayıf koloni olasılıkları birlikte değerlendirilmeli.'**
  String get surecYavruYokGecikmisTaniTemel;

  /// No description provided for @surecYavruYokGecikmisTaniAriKusu.
  ///
  /// In tr, this message translates to:
  /// **'Arı kuşu riski aktif olduğu için çiftleşme kaybı ihtimali yükselir.'**
  String get surecYavruYokGecikmisTaniAriKusu;

  /// No description provided for @surecYavruYokGecikmisTaniSakinPolen.
  ///
  /// In tr, this message translates to:
  /// **'Koloni sakinliği ve polen gelişi içeride ana olma ihtimalini tamamen dışlamaz.'**
  String get surecYavruYokGecikmisTaniSakinPolen;

  /// No description provided for @surecYavruYokGecikmisTaniHuzursuzPolenYok.
  ///
  /// In tr, this message translates to:
  /// **'Huzursuzluk veya polen yokluğu anasızlık/zayıflama şüphesini artırır.'**
  String get surecYavruYokGecikmisTaniHuzursuzPolenYok;

  /// No description provided for @surecYavruYokGecikmisTaniSonuc.
  ///
  /// In tr, this message translates to:
  /// **'5–7 gün içinde net kontrol yap; hâlâ yavru yoksa beklemeyi uzatma.'**
  String get surecYavruYokGecikmisTaniSonuc;

  /// No description provided for @surecYavruYokTaniAdayiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Yumurtlama gecikiyor olabilir'**
  String get surecYavruYokTaniAdayiBaslik;

  /// No description provided for @surecYavruYokTaniAdayiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Yavru düzeni \"Yok\" kaydedildi ve {baglam} sürecinden {gun} gün geçmiş. Bu artık yalnızca normal bekleme olarak bırakılmamalı; koloni davranışı, polen gelişi, ana memesi kalıntısı, bal baskısı ve erkek yavru baskısı birlikte okunmalı.'**
  String surecYavruYokTaniAdayiMesaj(String baglam, int gun);

  /// No description provided for @surecYavruYokNormalKoloniBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Normal kolonide yavru yokluğu'**
  String get surecYavruYokNormalKoloniBaslik;

  /// No description provided for @surecYavruYokNormalKoloniMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Aktif bölme/oğul/ana kazanma süreci görünmeden yavru düzeni \"Yok\" kaydedildi. Bu durum ana durumu, bal baskısı, koloni zayıflaması veya yalancı ana riski açısından kontrol edilmelidir.'**
  String get surecYavruYokNormalKoloniMesaj;

  /// No description provided for @surecSistemGerekce.
  ///
  /// In tr, this message translates to:
  /// **' Sistem gerekçesi: {gerekce}. Yaşam gücü okuması: {yasam}/100.'**
  String surecSistemGerekce(String gerekce, int yasam);

  /// No description provided for @surecHasatSonrasiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Hasat sonrası bakım gerekli'**
  String get surecHasatSonrasiBaslik;

  /// No description provided for @surecHasatSonrasiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Bal alındıysa koloni strese girebilir. Arı basmayan petek veya kat varsa kaldır, koloniyi sıkışık düzene al. Stok zayıfsa kısa süreli 1:1 şurup destek olabilir; kış stoğu eksikse 2:1 şurup veya uygun hazır yem düşün. Varroa sayımı ya da mücadele penceresini geciktirme.'**
  String get surecHasatSonrasiMesaj;

  /// No description provided for @surecGelisimYavasBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Gelişim yavaş görünüyor'**
  String get surecGelisimYavasBaslik;

  /// No description provided for @surecGelisimYavasMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Bu dönem için normal değil. Kontrol et. Ana var mı, günlük düzen var mı? Yavru alanı yeterli mi? Polen akışı var mı? (yoksa polenli kek ver) Varroa baskısı var mı?'**
  String get surecGelisimYavasMesaj;

  /// No description provided for @surecAnaKazanmaSureci.
  ///
  /// In tr, this message translates to:
  /// **'Ana kazanma süreci'**
  String get surecAnaKazanmaSureci;

  /// No description provided for @surecGerekceAktifBaglam.
  ///
  /// In tr, this message translates to:
  /// **'{baglam} sürecinden {gun} gün geçmiş'**
  String surecGerekceAktifBaglam(String baglam, int gun);

  /// No description provided for @surecGerekceAktifBaglamYok.
  ///
  /// In tr, this message translates to:
  /// **'aktif ana kazanma süreci görünmüyor'**
  String get surecGerekceAktifBaglamYok;

  /// No description provided for @surecGerekceToplamCita.
  ///
  /// In tr, this message translates to:
  /// **'{cita} çıta güç seviyesi'**
  String surecGerekceToplamCita(int cita);

  /// No description provided for @surecGerekceArdisikYavrusuz.
  ///
  /// In tr, this message translates to:
  /// **'{sayi} ardışık yavrusuz kayıt'**
  String surecGerekceArdisikYavrusuz(int sayi);

  /// No description provided for @surecGerekceTrendZayif.
  ///
  /// In tr, this message translates to:
  /// **'gelişim yönü zayıflıyor'**
  String get surecGerekceTrendZayif;

  /// No description provided for @surecGerekceKoloniSakin.
  ///
  /// In tr, this message translates to:
  /// **'koloni sakin işaretlenmiş'**
  String get surecGerekceKoloniSakin;

  /// No description provided for @surecGerekceKoloniHuzursuz.
  ///
  /// In tr, this message translates to:
  /// **'koloni huzursuz işaretlenmiş'**
  String get surecGerekceKoloniHuzursuz;

  /// No description provided for @surecGerekcePolenVar.
  ///
  /// In tr, this message translates to:
  /// **'polen gelişi var'**
  String get surecGerekcePolenVar;

  /// No description provided for @surecGerekcePolenYok.
  ///
  /// In tr, this message translates to:
  /// **'polen gelişi yok'**
  String get surecGerekcePolenYok;

  /// No description provided for @surecGerekceBalGelisiGuclu.
  ///
  /// In tr, this message translates to:
  /// **'bal/nektar gelişi güçlü'**
  String get surecGerekceBalGelisiGuclu;

  /// No description provided for @surecGerekceBalGelisiZayif.
  ///
  /// In tr, this message translates to:
  /// **'bal/nektar gelişi güçlü değil'**
  String get surecGerekceBalGelisiZayif;

  /// No description provided for @surecGerekceBalBaskisi.
  ///
  /// In tr, this message translates to:
  /// **'bal akımı ve ballı çıta baskısı var'**
  String get surecGerekceBalBaskisi;

  /// No description provided for @surecGerekceAriKusu.
  ///
  /// In tr, this message translates to:
  /// **'arı kuşu riski aktif'**
  String get surecGerekceAriKusu;

  /// No description provided for @surecGerekceErkekYavru.
  ///
  /// In tr, this message translates to:
  /// **'erkek yavru baskısı işaretlenmiş'**
  String get surecGerekceErkekYavru;

  /// No description provided for @surecGerekceYalaanciAna.
  ///
  /// In tr, this message translates to:
  /// **'yalancı ana / düzensiz yumurta şüphesi var'**
  String get surecGerekceYalaanciAna;

  /// No description provided for @beslemeBalAkimiBasladi.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı başladı.'**
  String get beslemeBalAkimiBasladi;

  /// No description provided for @beslemeBalAkimiGunKaldi.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımına {gunKaldi} gün kaldı; bal akımından {kesmeGun} gün önce besleme kesilmeli.'**
  String beslemeBalAkimiGunKaldi(int gunKaldi, int kesmeGun);

  /// No description provided for @beslemeOnerilmezMesaj.
  ///
  /// In tr, this message translates to:
  /// **'{zamanMetni} Hasat hedeflenen kolonide şeker bazlı besleme yapılmamalı.'**
  String beslemeOnerilmezMesaj(String zamanMetni);

  /// No description provided for @beslemeOnerilmezRisk.
  ///
  /// In tr, this message translates to:
  /// **'Şurup veya şekerli yem, nektar akımıyla birlikte bala taşınabilir. Hasat kalitesi açısından risk oluşturur.'**
  String get beslemeOnerilmezRisk;

  /// No description provided for @beslemeOnerilmezTekrarAraligi.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı ve hasat penceresinde uygulanmaz'**
  String get beslemeOnerilmezTekrarAraligi;

  /// No description provided for @beslemeOnerilmezDozNotu.
  ///
  /// In tr, this message translates to:
  /// **'Bu karar yalnızca hasat hedefli kolonide bal kalitesi güvenliği içindir.'**
  String get beslemeOnerilmezDozNotu;

  /// No description provided for @beslemeOlculuDestekTip.
  ///
  /// In tr, this message translates to:
  /// **'Ölçülü Destek'**
  String get beslemeOlculuDestekTip;

  /// No description provided for @beslemeGelisimTakibiTip.
  ///
  /// In tr, this message translates to:
  /// **'Gelişim Takibi'**
  String get beslemeGelisimTakibiTip;

  /// No description provided for @beslemeHacimOturgaMesajStok.
  ///
  /// In tr, this message translates to:
  /// **'Yeni verilen hacim oturma aşamasında. Stok ve yavru durumuna göre ölçülü destek değerlendirilebilir.'**
  String get beslemeHacimOturgaMesajStok;

  /// No description provided for @beslemeHacimOturgaMesajTakip.
  ///
  /// In tr, this message translates to:
  /// **'Yeni verilen hacim oturma aşamasında. Stok, yavru ve aktivasyon birlikte takip edilmeli.'**
  String get beslemeHacimOturgaMesajTakip;

  /// No description provided for @beslemeHacimRiskliSisirme.
  ///
  /// In tr, this message translates to:
  /// **'Hacim hızlı açıldıysa fazla besleme koloni düzenini bozabilir; destek ölçülü tutulmalıdır.'**
  String get beslemeHacimRiskliSisirme;

  /// No description provided for @beslemeHacimGerekceStok.
  ///
  /// In tr, this message translates to:
  /// **'Stok durumuna göre destek değerlendirilebilir'**
  String get beslemeHacimGerekceStok;

  /// No description provided for @beslemeHacimGerekceTakip.
  ///
  /// In tr, this message translates to:
  /// **'Yeni hacim aktivasyonu takip edilir'**
  String get beslemeHacimGerekceTakip;

  /// No description provided for @beslemeHacimGerekceIslevselCita.
  ///
  /// In tr, this message translates to:
  /// **'İşlevsel üretim çıtası yaklaşık {cita} çıta'**
  String beslemeHacimGerekceIslevselCita(int cita);

  /// No description provided for @beslemeHacimGerekceAktivasyon.
  ///
  /// In tr, this message translates to:
  /// **'Aktivasyon yaklaşık %{yuzde}'**
  String beslemeHacimGerekceAktivasyon(int yuzde);

  /// No description provided for @beslemeHacimDozNotu.
  ///
  /// In tr, this message translates to:
  /// **'Amaç koloniyi şişirmek değil, yeni hacim oturana kadar ölçülü enerji desteği sağlamaktır.'**
  String get beslemeHacimDozNotu;

  /// No description provided for @beslemeKontrolluDestekTip.
  ///
  /// In tr, this message translates to:
  /// **'Kontrollü Destek'**
  String get beslemeKontrolluDestekTip;

  /// No description provided for @beslemeKontrolluDestekMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Ana kazanma veya anasızlık sürecinde destek gerekiyorsa az ve kontrollü düşünülmeli.'**
  String get beslemeKontrolluDestekMesaj;

  /// No description provided for @beslemeKontrolluDestekRisk.
  ///
  /// In tr, this message translates to:
  /// **'Kovanı gereksiz açmak ana kabulü ve çiftleşme sürecini bozabilir.'**
  String get beslemeKontrolluDestekRisk;

  /// No description provided for @beslemeKontrolluDestekGerekce1.
  ///
  /// In tr, this message translates to:
  /// **'Aktif ana kazanma / anasızlık süreci var'**
  String get beslemeKontrolluDestekGerekce1;

  /// No description provided for @beslemeKontrolluDestekGerekce2.
  ///
  /// In tr, this message translates to:
  /// **'Stres azaltma öncelikli olmalı'**
  String get beslemeKontrolluDestekGerekce2;

  /// No description provided for @beslemeKontrolluDestekDozNotu.
  ///
  /// In tr, this message translates to:
  /// **'Amaç koloniyi şişirmek değil, süreci strese sokmadan hafif enerji desteği sağlamaktır.'**
  String get beslemeKontrolluDestekDozNotu;

  /// No description provided for @beslemeStokTamamlamaTip.
  ///
  /// In tr, this message translates to:
  /// **'Stok Tamamlama'**
  String get beslemeStokTamamlamaTip;

  /// No description provided for @beslemeStokTamamlamaMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Hasat sonrası dönemde stok durumuna göre 2:1 şurup ile stok tamamlama değerlendirilebilir.'**
  String get beslemeStokTamamlamaMesaj;

  /// No description provided for @beslemeStokTamamlamaRisk.
  ///
  /// In tr, this message translates to:
  /// **'Aşırı hacim, açıkta yem ve yağmacılık riski kontrol edilmeli.'**
  String get beslemeStokTamamlamaRisk;

  /// No description provided for @beslemeStokTamamlamaGerekce1.
  ///
  /// In tr, this message translates to:
  /// **'Hasat sonrası bakım süreci aktif'**
  String get beslemeStokTamamlamaGerekce1;

  /// No description provided for @beslemeStokTamamlamaGerekce2.
  ///
  /// In tr, this message translates to:
  /// **'Stok alanı baskı altında görünüyor'**
  String get beslemeStokTamamlamaGerekce2;

  /// No description provided for @beslemeStokTamamlamaDozNotu.
  ///
  /// In tr, this message translates to:
  /// **'Stok tamamlama amacı gelişim teşvikinden farklıdır; koloni sıkışık düzende tutulmalıdır.'**
  String get beslemeStokTamamlamaDozNotu;

  /// No description provided for @beslemePolenliDestekTip.
  ///
  /// In tr, this message translates to:
  /// **'Polenli Destek'**
  String get beslemePolenliDestekTip;

  /// No description provided for @beslemePolenliDestekMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Yavru gelişimi sürüyor. Polen stoğu sahada zayıf görülürse protein desteği değerlendirilebilir.'**
  String get beslemePolenliDestekMesaj;

  /// No description provided for @beslemePolenliDestekRisk.
  ///
  /// In tr, this message translates to:
  /// **'Gereksiz protein desteği tüketilmezse bozulma ve hijyen riski oluşturabilir.'**
  String get beslemePolenliDestekRisk;

  /// No description provided for @beslemePolenliDestekGerekce1.
  ///
  /// In tr, this message translates to:
  /// **'Yavru alanı geniş'**
  String get beslemePolenliDestekGerekce1;

  /// No description provided for @beslemePolenliDestekGerekce2.
  ///
  /// In tr, this message translates to:
  /// **'Stok/polen baskısı oluşuyor'**
  String get beslemePolenliDestekGerekce2;

  /// No description provided for @beslemePolenliDestekDozNotu.
  ///
  /// In tr, this message translates to:
  /// **'Protein desteği yalnızca polen eksikliği sahada doğrulanırsa anlamlıdır.'**
  String get beslemePolenliDestekDozNotu;

  /// No description provided for @beslemeGelisimDestegiTip.
  ///
  /// In tr, this message translates to:
  /// **'Gelişim Desteği'**
  String get beslemeGelisimDestegiTip;

  /// No description provided for @beslemeGelisimDestegiMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Koloni gelişim düzeninde. Stok durumuna göre ölçülü 1:1 şurup desteği değerlendirilebilir.'**
  String get beslemeGelisimDestegiMesaj;

  /// No description provided for @beslemeGelisimDestegiRisk.
  ///
  /// In tr, this message translates to:
  /// **'Aşırı besleme yağmacılık ve kovan içi denge bozulması riski yaratabilir.'**
  String get beslemeGelisimDestegiRisk;

  /// No description provided for @beslemeGelisimDestegiGerekce1.
  ///
  /// In tr, this message translates to:
  /// **'Düşük çıta seviyesinde gelişim kolonisi'**
  String get beslemeGelisimDestegiGerekce1;

  /// No description provided for @beslemeGelisimDestegiGerekce2.
  ///
  /// In tr, this message translates to:
  /// **'Karar kovan içi stok gözlemine göre verilmeli'**
  String get beslemeGelisimDestegiGerekce2;

  /// No description provided for @beslemeGelisimDestegiDozNotu.
  ///
  /// In tr, this message translates to:
  /// **'Amaç yavru gelişimini desteklemek; fazla şurup verip kovan içi dengeyi bozmamak olmalıdır.'**
  String get beslemeGelisimDestegiDozNotu;

  /// No description provided for @beslemeOlculuDestekOrta7Mesaj.
  ///
  /// In tr, this message translates to:
  /// **'Koloni orta güçte. Stok durumuna göre ölçülü gelişim desteği değerlendirilebilir.'**
  String get beslemeOlculuDestekOrta7Mesaj;

  /// No description provided for @beslemeOlculuDestekOrta7Risk.
  ///
  /// In tr, this message translates to:
  /// **'Aşırı teşvik oğul baskısı veya yağmacılık riskini artırabilir.'**
  String get beslemeOlculuDestekOrta7Risk;

  /// No description provided for @beslemeOlculuDestekOrta7Gerekce1.
  ///
  /// In tr, this message translates to:
  /// **'Orta güçte koloni'**
  String get beslemeOlculuDestekOrta7Gerekce1;

  /// No description provided for @beslemeOlculuDestekOrta7DozNotu.
  ///
  /// In tr, this message translates to:
  /// **'Saha gözleminde polen ve nektar gelişi yeterliyse besleme azaltılabilir.'**
  String get beslemeOlculuDestekOrta7DozNotu;

  /// No description provided for @beslemeYonetimMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Besleme kararı kovan içi stok, yavru yükü ve saha nektar/polen gelişine göre verilmelidir.'**
  String get beslemeYonetimMesaj;

  /// No description provided for @beslemeYonetimGerekce.
  ///
  /// In tr, this message translates to:
  /// **'Sistem stok durumunu kesin ölçmez; saha gözlemi belirleyicidir'**
  String get beslemeYonetimGerekce;

  /// No description provided for @beslemeYonetimDozNotu.
  ///
  /// In tr, this message translates to:
  /// **'Stok zayıf görülürse ölçülü destek değerlendirilebilir; yeterli görülürse yalnızca takip edilebilir.'**
  String get beslemeYonetimDozNotu;

  /// No description provided for @beslemeGunArayla.
  ///
  /// In tr, this message translates to:
  /// **'2–3 gün arayla, saha stok durumuna göre'**
  String get beslemeGunArayla;

  /// No description provided for @beslemeGunAralykKisaKontrol.
  ///
  /// In tr, this message translates to:
  /// **'2–3 gün arayla, kısa süreli'**
  String get beslemeGunAralykKisaKontrol;

  /// No description provided for @beslemeGunAralykStokKontrol.
  ///
  /// In tr, this message translates to:
  /// **'2–3 gün arayla, stok kontrolüyle'**
  String get beslemeGunAralykStokKontrol;

  /// No description provided for @beslemeGunAralykTamamlanana.
  ///
  /// In tr, this message translates to:
  /// **'2–3 gün arayla, stok tamamlanana kadar'**
  String get beslemeGunAralykTamamlanana;

  /// No description provided for @beslemeKekTuketim.
  ///
  /// In tr, this message translates to:
  /// **'Tüketim durumuna göre küçük parçalar halinde'**
  String get beslemeKekTuketim;

  /// No description provided for @beslemeKekBozulmaRisk.
  ///
  /// In tr, this message translates to:
  /// **'Tüketim durumuna göre; bozulma riski izlenerek'**
  String get beslemeKekBozulmaRisk;

  /// No description provided for @biyolSinifEtiketZayif.
  ///
  /// In tr, this message translates to:
  /// **'Zayıf'**
  String get biyolSinifEtiketZayif;

  /// No description provided for @biyolSinifEtiketGelisim.
  ///
  /// In tr, this message translates to:
  /// **'Gelişim'**
  String get biyolSinifEtiketGelisim;

  /// No description provided for @biyolSinifEtiketUretim.
  ///
  /// In tr, this message translates to:
  /// **'Üretim'**
  String get biyolSinifEtiketUretim;

  /// No description provided for @biyolSinifEtiketHasat.
  ///
  /// In tr, this message translates to:
  /// **'Hasat'**
  String get biyolSinifEtiketHasat;

  /// No description provided for @biyolSinifAciklamaZayif.
  ///
  /// In tr, this message translates to:
  /// **'Öncelik yaşatma, sıkıştırma ve ölçülü destek.'**
  String get biyolSinifAciklamaZayif;

  /// No description provided for @biyolSinifAciklamaGelisim.
  ///
  /// In tr, this message translates to:
  /// **'Öncelik düzenli gelişim ve ana/yavru dengesinin korunması.'**
  String get biyolSinifAciklamaGelisim;

  /// No description provided for @biyolSinifAciklamaUretim.
  ///
  /// In tr, this message translates to:
  /// **'Koloni üretim gücüne girmiştir; alan, oğul riski ve bal akımı birlikte izlenir.'**
  String get biyolSinifAciklamaUretim;

  /// No description provided for @biyolSinifAciklamaHasat.
  ///
  /// In tr, this message translates to:
  /// **'Koloni bal akımı ve hasat/alan yönetimi açısından güçlü banttadır.'**
  String get biyolSinifAciklamaHasat;

  /// No description provided for @biyolYavrusuzlukMesajNormal.
  ///
  /// In tr, this message translates to:
  /// **'Yavru verisi mevcut; biyolojik geri dönüş kapasitesi yavru üretimiyle destekleniyor.'**
  String get biyolYavrusuzlukMesajNormal;

  /// No description provided for @biyolYavrusuzlukOneriNormal.
  ///
  /// In tr, this message translates to:
  /// **'Normal biyolojik model akışıyla izle.'**
  String get biyolYavrusuzlukOneriNormal;

  /// No description provided for @biyolYavrusuzlukMesajBolmeOgul.
  ///
  /// In tr, this message translates to:
  /// **'Bu aşamada yavru görülmemesi normal olabilir. Koloni ana kazanma veya çiftleşme döneminde olabilir; gereksiz açma riski artırır.'**
  String get biyolYavrusuzlukMesajBolmeOgul;

  /// No description provided for @biyolYavrusuzlukOneriBolmeOgul.
  ///
  /// In tr, this message translates to:
  /// **'Kovanı gereksiz açma; yumurtlama kontrol penceresini bekle.'**
  String get biyolYavrusuzlukOneriBolmeOgul;

  /// No description provided for @biyolYavrusuzlukMesajBalBaskisi.
  ///
  /// In tr, this message translates to:
  /// **'Yavru yokluğu tek başına anasızlık anlamına gelmez. Bal akımı ve ballı çıta baskısı yumurtlama alanını daraltmış olabilir.'**
  String get biyolYavrusuzlukMesajBalBaskisi;

  /// No description provided for @biyolYavrusuzlukOneriBalBaskisi.
  ///
  /// In tr, this message translates to:
  /// **'Önce alan ve bal baskısını değerlendir; erken ana müdahalesi yapma.'**
  String get biyolYavrusuzlukOneriBalBaskisi;

  /// No description provided for @biyolYavrusuzlukMesajDusukKapasite.
  ///
  /// In tr, this message translates to:
  /// **'Koloni uzun süredir yeni işçi üretmiyor. Bu güç seviyesinde mevcut nüfus yaşlanıyor olabilir; yoğun emek ve kaynak harcamak verimli olmayabilir.'**
  String get biyolYavrusuzlukMesajDusukKapasite;

  /// No description provided for @biyolYavrusuzlukOneriDusukKapasite.
  ///
  /// In tr, this message translates to:
  /// **'Güçlü koloniyle birleştirme veya sınırlı müdahale öncelikli değerlendirilmelidir.'**
  String get biyolYavrusuzlukOneriDusukKapasite;

  /// No description provided for @biyolYavrusuzlukMesajGecYumurtlama.
  ///
  /// In tr, this message translates to:
  /// **'Yumurtlama beklenen döneme girilmiş. Yavru hâlâ yoksa geç çiftleşme, ana kaybı, bal baskısı veya zayıf koloni olasılıkları birlikte okunmalı.'**
  String get biyolYavrusuzlukMesajGecYumurtlama;

  /// No description provided for @biyolYavrusuzlukOneriGecYumurtlama.
  ///
  /// In tr, this message translates to:
  /// **'5–7 gün içinde tekrar kontrol et; koloni zayıflıyorsa beklemeyi uzatma.'**
  String get biyolYavrusuzlukOneriGecYumurtlama;

  /// No description provided for @biyolYavrusuzlukMesajGenel.
  ///
  /// In tr, this message translates to:
  /// **'Yavru yokluğu izlenmeli; mevcut gün aralığında tek başına kesin anasızlık kararı verilmemelidir.'**
  String get biyolYavrusuzlukMesajGenel;

  /// No description provided for @biyolYavrusuzlukOneriGenel.
  ///
  /// In tr, this message translates to:
  /// **'Koloni davranışı, polen gelişi ve bir sonraki muayene ile birlikte değerlendir.'**
  String get biyolYavrusuzlukOneriGenel;

  /// No description provided for @biyolHasatVeriYokMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Hasat yorumu için çıta ve bal verisi gerekir.'**
  String get biyolHasatVeriYokMesaj;

  /// No description provided for @biyolHasatVeriYokKural.
  ///
  /// In tr, this message translates to:
  /// **'Ölçüm yoksa hasat kararı üretme.'**
  String get biyolHasatVeriYokKural;

  /// No description provided for @biyolHasatBallikMesaj.
  ///
  /// In tr, this message translates to:
  /// **'Katlı sistemde hasat önceliği ballıktadır; kuluçkalık koruma alanı kabul edilir.'**
  String get biyolHasatBallikMesaj;

  /// No description provided for @biyolHasatBallikKural.
  ///
  /// In tr, this message translates to:
  /// **'Ballık hasadı yalnızca sırlı, yavrusuz ve olgun çıtalarda düşünülür.'**
  String get biyolHasatBallikKural;

  /// No description provided for @biyolHasatOnerilmezMesaj.
  ///
  /// In tr, this message translates to:
  /// **'7 çıta ve altındaki kolonide hasat önerilmez; kuluçkalık güvenliği korunmalıdır.'**
  String get biyolHasatOnerilmezMesaj;

  /// No description provided for @biyolHasatOnerilmezKural.
  ///
  /// In tr, this message translates to:
  /// **'Koloni hasatla 7 çıta altına düşürülmez.'**
  String get biyolHasatOnerilmezKural;

  /// No description provided for @biyolHasat8CitaMesaj.
  ///
  /// In tr, this message translates to:
  /// **'8 çıtalı kolonide 1. ve 8. çıtalar dış stok bölgesidir; sırlı ve yavrusuzsa şartlı hasat düşünülebilir.'**
  String get biyolHasat8CitaMesaj;

  /// No description provided for @biyolHasat8CitaKural.
  ///
  /// In tr, this message translates to:
  /// **'1. veya 8. çıta dış stok bölgesi değilse alınmaz.'**
  String get biyolHasat8CitaKural;

  /// No description provided for @biyolHasat9CitaMesaj.
  ///
  /// In tr, this message translates to:
  /// **'9 çıtalı kolonide 1. ve 9. çıtalar dış stok bölgesi olarak kontrol edilebilir.'**
  String get biyolHasat9CitaMesaj;

  /// No description provided for @biyolHasat9CitaKural.
  ///
  /// In tr, this message translates to:
  /// **'Yavru/polen alanı bozulmaz; yalnızca sırlı dış bal alınır.'**
  String get biyolHasat9CitaKural;

  /// No description provided for @biyolHasat10CitaMesaj.
  ///
  /// In tr, this message translates to:
  /// **'10 çıtalı kuluçkalıkta 1. ve 10. çıtalar dış stok bölgesi olarak kontrol edilebilir.'**
  String get biyolHasat10CitaMesaj;

  /// No description provided for @biyolHasat10CitaKural.
  ///
  /// In tr, this message translates to:
  /// **'Kuluçkalık stok güvenliği ve yavru bloğu korunmadan hasat yapılmaz.'**
  String get biyolHasat10CitaKural;

  /// No description provided for @biyolHasatAdayMetni.
  ///
  /// In tr, this message translates to:
  /// **'{metin} sayılı çıtalar yavrusuz ve sırlıysa hasat için değerlendirilebilir.'**
  String biyolHasatAdayMetni(String metin);

  /// No description provided for @biyolIlgincGozKapasitesi.
  ///
  /// In tr, this message translates to:
  /// **'Bu kolonide tahmini {gozMin}–{gozMax} petek gözü kapasitesi bulunur.'**
  String biyolIlgincGozKapasitesi(int gozMin, int gozMax);

  /// No description provided for @biyolIlgincAriNufusu.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini arı nüfusu {ariMin}–{ariMax} aralığındadır.'**
  String biyolIlgincAriNufusu(int ariMin, int ariMax);

  /// No description provided for @biyolIlgincYavruAlani.
  ///
  /// In tr, this message translates to:
  /// **'Yavru alanı tahmini {yavruMin}–{yavruMax} göz kapasitesindedir.'**
  String biyolIlgincYavruAlani(int yavruMin, int yavruMax);

  /// No description provided for @biyolIlgincHasatPotansiyeli.
  ///
  /// In tr, this message translates to:
  /// **'Sırlı ve yavrusuz çıtalar uygunsa tahmini hasat potansiyeli {hasatMin}–{hasatMax} kg bandındadır.'**
  String biyolIlgincHasatPotansiyeli(String hasatMin, String hasatMax);

  /// No description provided for @biyolIlgincUyari.
  ///
  /// In tr, this message translates to:
  /// **'Bu veriler kesin sayım değil; standart biyolojik koloni modeliyle üretilen saha projeksiyonudur.'**
  String get biyolIlgincUyari;

  /// No description provided for @biyolYorumVeriYok.
  ///
  /// In tr, this message translates to:
  /// **'Model için çıta verisi yok. İlk muayene sonrası tahmini biyolojik düzen okunabilir.'**
  String get biyolYorumVeriYok;

  /// No description provided for @biyolYorumBallikAlan.
  ///
  /// In tr, this message translates to:
  /// **'Alt kuluçkalık {kapasite} çıta kabul edildi. Üstteki {cita} çıta ballık/kat alanı olarak yorumlandı. Merkez yavru bloğu ({blok}) korunmalı.'**
  String biyolYorumBallikAlan(int kapasite, int cita, String blok);

  /// No description provided for @biyolYorumKucukKoloni.
  ///
  /// In tr, this message translates to:
  /// **'Küçük koloni. Merkez yavru bloğu ve ısı düzeni korunmalı; gereksiz hacim bırakılmamalı.'**
  String get biyolYorumKucukKoloni;

  /// No description provided for @biyolYorumGelisimSuffix.
  ///
  /// In tr, this message translates to:
  /// **'Merkez yavru bloğu ({blok}) korunmalı.'**
  String biyolYorumGelisimSuffix(String blok);

  /// No description provided for @biyolYorumDoluPrefix.
  ///
  /// In tr, this message translates to:
  /// **'Kuluçkalık dolu kabul edilir. Kat, sıkışıklık ve oğul baskısı birlikte izlenmeli.'**
  String get biyolYorumDoluPrefix;

  /// No description provided for @biyolSeviyeYuksek.
  ///
  /// In tr, this message translates to:
  /// **'yüksek'**
  String get biyolSeviyeYuksek;

  /// No description provided for @biyolSeviyeOrta.
  ///
  /// In tr, this message translates to:
  /// **'orta'**
  String get biyolSeviyeOrta;

  /// No description provided for @biyolSeviyeSinirli.
  ///
  /// In tr, this message translates to:
  /// **'sınırlı'**
  String get biyolSeviyeSinirli;

  /// No description provided for @biyolSeviyeDusuk.
  ///
  /// In tr, this message translates to:
  /// **'düşük'**
  String get biyolSeviyeDusuk;

  /// No description provided for @biyolRiskKritik.
  ///
  /// In tr, this message translates to:
  /// **'kritik'**
  String get biyolRiskKritik;

  /// No description provided for @biyolRiskYuksek.
  ///
  /// In tr, this message translates to:
  /// **'yüksek'**
  String get biyolRiskYuksek;

  /// No description provided for @biyolRiskOrta.
  ///
  /// In tr, this message translates to:
  /// **'orta'**
  String get biyolRiskOrta;

  /// No description provided for @biyolRiskDusuk.
  ///
  /// In tr, this message translates to:
  /// **'düşük'**
  String get biyolRiskDusuk;

  /// No description provided for @biyolGelisimGuclu.
  ///
  /// In tr, this message translates to:
  /// **'gelişim yönü güçlü'**
  String get biyolGelisimGuclu;

  /// No description provided for @biyolGelisimDengeli.
  ///
  /// In tr, this message translates to:
  /// **'gelişim yönü dengeli'**
  String get biyolGelisimDengeli;

  /// No description provided for @biyolGelisimBaskili.
  ///
  /// In tr, this message translates to:
  /// **'gelişim baskılanıyor'**
  String get biyolGelisimBaskili;

  /// No description provided for @biyolGelisimSinirli.
  ///
  /// In tr, this message translates to:
  /// **'gelişim sınırlı'**
  String get biyolGelisimSinirli;

  /// No description provided for @biyolUretimBalaYoneliyor.
  ///
  /// In tr, this message translates to:
  /// **'bala yöneliyor'**
  String get biyolUretimBalaYoneliyor;

  /// No description provided for @biyolUretimYavruDuzeni.
  ///
  /// In tr, this message translates to:
  /// **'yavru düzenini güçlendiriyor'**
  String get biyolUretimYavruDuzeni;

  /// No description provided for @biyolUretimStokIhtiyac.
  ///
  /// In tr, this message translates to:
  /// **'stok desteğine ihtiyaç duyabilir'**
  String get biyolUretimStokIhtiyac;

  /// No description provided for @biyolUretimDengeli.
  ///
  /// In tr, this message translates to:
  /// **'dengeli saha düzeninde'**
  String get biyolUretimDengeli;

  /// No description provided for @biyolMomentumIvmeleniyor.
  ///
  /// In tr, this message translates to:
  /// **'ivmeleniyor'**
  String get biyolMomentumIvmeleniyor;

  /// No description provided for @biyolMomentumDengede.
  ///
  /// In tr, this message translates to:
  /// **'dengede'**
  String get biyolMomentumDengede;

  /// No description provided for @biyolMomentumYavasliyor.
  ///
  /// In tr, this message translates to:
  /// **'yavaşlıyor'**
  String get biyolMomentumYavasliyor;

  /// No description provided for @biyolMomentumKiriliyor.
  ///
  /// In tr, this message translates to:
  /// **'kırılıyor'**
  String get biyolMomentumKiriliyor;

  /// No description provided for @biyolAlanBaskisiYuksek.
  ///
  /// In tr, this message translates to:
  /// **'alan baskısı yüksek'**
  String get biyolAlanBaskisiYuksek;

  /// No description provided for @biyolAlanKullanimDengeli.
  ///
  /// In tr, this message translates to:
  /// **'alan kullanımı dengeli'**
  String get biyolAlanKullanimDengeli;

  /// No description provided for @biyolAlanBosHacim.
  ///
  /// In tr, this message translates to:
  /// **'boş hacim taşıyor'**
  String get biyolAlanBosHacim;

  /// No description provided for @biyolYonOlumlu.
  ///
  /// In tr, this message translates to:
  /// **'olumlu güçlenme beklenir'**
  String get biyolYonOlumlu;

  /// No description provided for @biyolYonKontrollu.
  ///
  /// In tr, this message translates to:
  /// **'kontrollü gelişim beklenir'**
  String get biyolYonKontrollu;

  /// No description provided for @biyolYonTemkinli.
  ///
  /// In tr, this message translates to:
  /// **'temkinli izleme gerekir'**
  String get biyolYonTemkinli;

  /// No description provided for @biyolYonZayiflama.
  ///
  /// In tr, this message translates to:
  /// **'zayıflama riski izlenmeli'**
  String get biyolYonZayiflama;

  /// No description provided for @biyolOncelikliRiskCokus.
  ///
  /// In tr, this message translates to:
  /// **'biyolojik çöküş riski'**
  String get biyolOncelikliRiskCokus;

  /// No description provided for @biyolOncelikliRiskHacim.
  ///
  /// In tr, this message translates to:
  /// **'hacim aktivasyonu tamamlanmamış'**
  String get biyolOncelikliRiskHacim;

  /// No description provided for @biyolOncelikliRiskYavru.
  ///
  /// In tr, this message translates to:
  /// **'yavru düzeni belirsiz'**
  String get biyolOncelikliRiskYavru;

  /// No description provided for @biyolOncelikliRiskBalAkim.
  ///
  /// In tr, this message translates to:
  /// **'bal akımına üretim kapasitesi sınırlı'**
  String get biyolOncelikliRiskBalAkim;

  /// No description provided for @biyolOncelikliRiskStok.
  ///
  /// In tr, this message translates to:
  /// **'stok güvenliği sınırlı'**
  String get biyolOncelikliRiskStok;

  /// No description provided for @biyolSahaOzetiRiskle.
  ///
  /// In tr, this message translates to:
  /// **'{gelisimYonu}; öncelikli risk: {oncelikliRisk}.'**
  String biyolSahaOzetiRiskle(String gelisimYonu, String oncelikliRisk);

  /// No description provided for @biyolSahaOzetiNormal.
  ///
  /// In tr, this message translates to:
  /// **'{gelisimYonu}; {uretimYonu}.'**
  String biyolSahaOzetiNormal(String gelisimYonu, String uretimYonu);

  /// No description provided for @biyolKapasiteGuclu.
  ///
  /// In tr, this message translates to:
  /// **'güçlü'**
  String get biyolKapasiteGuclu;

  /// No description provided for @biyolKapasiteOrta.
  ///
  /// In tr, this message translates to:
  /// **'orta'**
  String get biyolKapasiteOrta;

  /// No description provided for @biyolKapasiteSinirli.
  ///
  /// In tr, this message translates to:
  /// **'sınırlı'**
  String get biyolKapasiteSinirli;

  /// No description provided for @biyolKapasiteZayif.
  ///
  /// In tr, this message translates to:
  /// **'zayıf'**
  String get biyolKapasiteZayif;

  /// No description provided for @biyolGenisletmeErken.
  ///
  /// In tr, this message translates to:
  /// **'genişletme erken; önce sıkı düzen ve yavru ısısı korunmalı'**
  String get biyolGenisletmeErken;

  /// No description provided for @biyolGenisletmeGucluBallik.
  ///
  /// In tr, this message translates to:
  /// **'ballık yönetimi sürdürülebilir; yavru bloğu kesilmeden alan verilebilir'**
  String get biyolGenisletmeGucluBallik;

  /// No description provided for @biyolGenisletmeGuclu.
  ///
  /// In tr, this message translates to:
  /// **'kontrollü genişletme güvenli görünüyor'**
  String get biyolGenisletmeGuclu;

  /// No description provided for @biyolGenisletmeSinirli.
  ///
  /// In tr, this message translates to:
  /// **'sınırlı genişletme yapılabilir; kabarmış petek ham petekten daha güvenli olabilir'**
  String get biyolGenisletmeSinirli;

  /// No description provided for @biyolGenisletmeYavruBaski.
  ///
  /// In tr, this message translates to:
  /// **'yavru bakım baskısı var; ham petek yerine kabarmış petek tercih edilmeli'**
  String get biyolGenisletmeYavruBaski;

  /// No description provided for @biyolGenisletmeRiskli.
  ///
  /// In tr, this message translates to:
  /// **'aşırı genişletme riskli; önce iş gücü ve stok dengesi izlenmeli'**
  String get biyolGenisletmeRiskli;

  /// No description provided for @biyolBalAkimiGucluBallik.
  ///
  /// In tr, this message translates to:
  /// **'bal akımı güçlü değerlendirilebilir; ballıkta sırlanma takibi öne alınmalı'**
  String get biyolBalAkimiGucluBallik;

  /// No description provided for @biyolBalAkimiGuclu.
  ///
  /// In tr, this message translates to:
  /// **'nektar kapasitesi güçlü; sıkışma başlamadan kat hazırlığı izlenmeli'**
  String get biyolBalAkimiGuclu;

  /// No description provided for @biyolBalAkimiSinirli.
  ///
  /// In tr, this message translates to:
  /// **'bal akımı sınırlı değerlendirilebilir; alan ve sırlanma birlikte izlenmeli'**
  String get biyolBalAkimiSinirli;

  /// No description provided for @biyolBalAkimiZayif.
  ///
  /// In tr, this message translates to:
  /// **'bal akımı kapasitesi sınırlı; üretimden önce koloni organizasyonu güçlenmeli'**
  String get biyolBalAkimiZayif;

  /// No description provided for @biyolBakiciGuclu.
  ///
  /// In tr, this message translates to:
  /// **'bakıcı arı dengesi güçlü; yavru alanı korunarak büyütme yapılabilir'**
  String get biyolBakiciGuclu;

  /// No description provided for @biyolBakiciPetekSinirli.
  ///
  /// In tr, this message translates to:
  /// **'bakıcı kapasitesi var fakat petek örme sınırlı; kabarmış petek daha güvenli'**
  String get biyolBakiciPetekSinirli;

  /// No description provided for @biyolBakiciSinirli.
  ///
  /// In tr, this message translates to:
  /// **'bakıcı kapasitesi sınırlı; aşırı yavru yükü veya sert genişletme risklidir'**
  String get biyolBakiciSinirli;

  /// No description provided for @biyolBakiciOrta.
  ///
  /// In tr, this message translates to:
  /// **'bakıcı dengesi orta bantta; genişletme kontrollü yapılmalı'**
  String get biyolBakiciOrta;

  /// No description provided for @biyolHamPetekGuclu.
  ///
  /// In tr, this message translates to:
  /// **'Yeterli genç işçi kapasitesi görünüyor; ham petek verilecekse yavru bloğunun dışına verilebilir.'**
  String get biyolHamPetekGuclu;

  /// No description provided for @biyolHamPetekSinirli.
  ///
  /// In tr, this message translates to:
  /// **'Ham petek sınırlı verilebilir; kabarmış petek daha güvenli olur.'**
  String get biyolHamPetekSinirli;

  /// No description provided for @biyolHamPetekDusuk.
  ///
  /// In tr, this message translates to:
  /// **'Ham petek için genç işçi kapasitesi sınırlı; önce kabarmış petek veya sıkı düzen daha güvenli.'**
  String get biyolHamPetekDusuk;

  /// No description provided for @biyolBeslemeNektarIyi.
  ///
  /// In tr, this message translates to:
  /// **'Nektar toplama kapasitesi iyi; bal akımında gereksiz şurup vermekten kaçın.'**
  String get biyolBeslemeNektarIyi;

  /// No description provided for @biyolBeslemeYavruIyi.
  ///
  /// In tr, this message translates to:
  /// **'Yavru bakım kapasitesi iyi; polen/stok zayıfsa destek besleme düşünülebilir.'**
  String get biyolBeslemeYavruIyi;

  /// No description provided for @biyolBeslemePetekVar.
  ///
  /// In tr, this message translates to:
  /// **'Petek örme kapasitesi var; akım yoksa hafif destek büyümeyi koruyabilir.'**
  String get biyolBeslemePetekVar;

  /// No description provided for @biyolBeslemeKontrollu.
  ///
  /// In tr, this message translates to:
  /// **'Besleme kararı stok, hava ve süreç durumuna göre kontrollü verilmelidir.'**
  String get biyolBeslemeKontrollu;

  /// No description provided for @biyolSahaStokOnceligi.
  ///
  /// In tr, this message translates to:
  /// **'Öncelik hasat değil stok güvenliği ve kış dayanımıdır.'**
  String get biyolSahaStokOnceligi;

  /// No description provided for @biyolSahaYavruOnceligi.
  ///
  /// In tr, this message translates to:
  /// **'Öncelik genişletme değil yavru alanını ve ısı düzenini korumaktır.'**
  String get biyolSahaYavruOnceligi;

  /// No description provided for @biyolSahaHamPetek.
  ///
  /// In tr, this message translates to:
  /// **'Ham petek verilebilir; yavru bloğu kesilmeden dıştan genişlet.'**
  String get biyolSahaHamPetek;

  /// No description provided for @biyolSahaBalAkimiBallik.
  ///
  /// In tr, this message translates to:
  /// **'Bal akımı değerlendirilebilir; ballıkta sırlanma takibi yap.'**
  String get biyolSahaBalAkimiBallik;

  /// No description provided for @biyolSahaBalAkimiKat.
  ///
  /// In tr, this message translates to:
  /// **'Nektar kapasitesi güçlü; sıkışma artarsa kat hazırlığını değerlendir.'**
  String get biyolSahaBalAkimiKat;

  /// No description provided for @biyolSahaYavruPetekSinirli.
  ///
  /// In tr, this message translates to:
  /// **'Yavru bakım güçlü ama petek örme sınırlı; kabarmış petek ham petekten daha güvenli.'**
  String get biyolSahaYavruPetekSinirli;

  /// No description provided for @biyolSahaKontrolluBuyut.
  ///
  /// In tr, this message translates to:
  /// **'Koloniyi kontrollü büyüt; karar için son muayene, stok ve süreç durumunu birlikte oku.'**
  String get biyolSahaKontrolluBuyut;

  /// No description provided for @biyolKabiliyetPetekGuclu.
  ///
  /// In tr, this message translates to:
  /// **'petek örme güçlü'**
  String get biyolKabiliyetPetekGuclu;

  /// No description provided for @biyolKabiliyetYavruGuclu.
  ///
  /// In tr, this message translates to:
  /// **'yavru bakımı güçlü'**
  String get biyolKabiliyetYavruGuclu;

  /// No description provided for @biyolKabiliyetNektarGuclu.
  ///
  /// In tr, this message translates to:
  /// **'nektar toplama güçlü'**
  String get biyolKabiliyetNektarGuclu;

  /// No description provided for @biyolKabiliyetBalIslemeGuclu.
  ///
  /// In tr, this message translates to:
  /// **'bal işleme güçlü'**
  String get biyolKabiliyetBalIslemeGuclu;

  /// No description provided for @biyolKabiliyetKisDikkat.
  ///
  /// In tr, this message translates to:
  /// **'kış stok/dayanım dikkat ister'**
  String get biyolKabiliyetKisDikkat;

  /// No description provided for @biyolKabiliyetOrta.
  ///
  /// In tr, this message translates to:
  /// **'Kabiliyetler orta bantta; aşırı genişletme veya ağır işlem yerine kontrollü ilerle.'**
  String get biyolKabiliyetOrta;

  /// No description provided for @biyolCitaYavruStok.
  ///
  /// In tr, this message translates to:
  /// **'Yavru/stok'**
  String get biyolCitaYavruStok;

  /// No description provided for @biyolCitaBalliPolenli.
  ///
  /// In tr, this message translates to:
  /// **'Ballı/polenli'**
  String get biyolCitaBalliPolenli;

  /// No description provided for @biyolCitaBalStogu.
  ///
  /// In tr, this message translates to:
  /// **'Bal stoğu'**
  String get biyolCitaBalStogu;

  /// No description provided for @biyolCitaYavruPolenli.
  ///
  /// In tr, this message translates to:
  /// **'Yavru/polenli'**
  String get biyolCitaYavruPolenli;

  /// No description provided for @biyolCitaYavru.
  ///
  /// In tr, this message translates to:
  /// **'Yavru'**
  String get biyolCitaYavru;

  /// No description provided for @biyolCitaYavruluPolenli.
  ///
  /// In tr, this message translates to:
  /// **'Yavrulu/polenli'**
  String get biyolCitaYavruluPolenli;

  /// No description provided for @biyolCitaYavruStokGecis.
  ///
  /// In tr, this message translates to:
  /// **'Yavru/stok geçiş alanı'**
  String get biyolCitaYavruStokGecis;

  /// No description provided for @biyolCitaBalliPolenliGecis.
  ///
  /// In tr, this message translates to:
  /// **'Ballı/polenli geçiş alanı'**
  String get biyolCitaBalliPolenliGecis;

  /// No description provided for @biyolCitaBallikBal.
  ///
  /// In tr, this message translates to:
  /// **'Ballık / bal alanı'**
  String get biyolCitaBallikBal;

  /// No description provided for @biyolCitaBallikAktivasyon.
  ///
  /// In tr, this message translates to:
  /// **'Ballık / aktivasyon sürecinde'**
  String get biyolCitaBallikAktivasyon;

  /// No description provided for @biyolCitaKapaliYavruluCekim.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı yavrulu çekim çıtası'**
  String get biyolCitaKapaliYavruluCekim;

  /// No description provided for @biyolCitaBalliPolenliCekim.
  ///
  /// In tr, this message translates to:
  /// **'Ballı/polenli çekim çıtası'**
  String get biyolCitaBalliPolenliCekim;

  /// No description provided for @biyolCitaSurupluk.
  ///
  /// In tr, this message translates to:
  /// **'Şurupluk'**
  String get biyolCitaSurupluk;

  /// No description provided for @biyolCitaYeniPetekAktivasyon.
  ///
  /// In tr, this message translates to:
  /// **'yeni petek aktivasyonu'**
  String get biyolCitaYeniPetekAktivasyon;

  /// No description provided for @biyolYavruBlokBelirsiz.
  ///
  /// In tr, this message translates to:
  /// **'Belirsiz'**
  String get biyolYavruBlokBelirsiz;

  /// No description provided for @biyolYavruBlok1Cita.
  ///
  /// In tr, this message translates to:
  /// **'{no}. çıta'**
  String biyolYavruBlok1Cita(int no);

  /// No description provided for @biyolYavruBlokAralik.
  ///
  /// In tr, this message translates to:
  /// **'{bas}–{son}. çıtalar'**
  String biyolYavruBlokAralik(int bas, int son);

  /// No description provided for @biyolAnaBolgeMerkez.
  ///
  /// In tr, this message translates to:
  /// **'Merkez yavru çıtası'**
  String get biyolAnaBolgeMerkez;

  /// No description provided for @biyolAnaBolgeAralik.
  ///
  /// In tr, this message translates to:
  /// **'{sol}–{sag}. çıtalar çevresi'**
  String biyolAnaBolgeAralik(int sol, int sag);

  /// No description provided for @biyolAnaBolgeYavruBlok.
  ///
  /// In tr, this message translates to:
  /// **'{blok} çevresi'**
  String biyolAnaBolgeYavruBlok(String blok);

  /// No description provided for @biyolGelisimAlaniAcik.
  ///
  /// In tr, this message translates to:
  /// **'Gelişim alanı merkez dışındaki boş/kabarmış petekle açılmalı.'**
  String get biyolGelisimAlaniAcik;

  /// No description provided for @biyolGelisimAlaniMetin.
  ///
  /// In tr, this message translates to:
  /// **'{adaylar}. çıtaların dışından kontrollü genişletme yapılabilir.'**
  String biyolGelisimAlaniMetin(String adaylar);

  /// No description provided for @biyolYerlesimSatiriFormat.
  ///
  /// In tr, this message translates to:
  /// **'{no}. çıta: {tip}'**
  String biyolYerlesimSatiriFormat(int no, String tip);

  /// No description provided for @biyolKovanNotuKatGecisi.
  ///
  /// In tr, this message translates to:
  /// **'Bu bir biyolojik dizilim projeksiyonudur: kat geçişinde üst kata işlevli çekim grubu, alt kuluçkalığa ise yeni verilen peteklerin aktivasyon süreci modellenir.'**
  String get biyolKovanNotuKatGecisi;

  /// No description provided for @biyolKovanNotuGenel.
  ///
  /// In tr, this message translates to:
  /// **'Dolu renkler işlevsel çıtayı; boş çerçeve ve alttan yukarı günlük dolum ise kovanda bulunan fakat biyolojik aktivasyonu süren yeni hacmi gösterir.'**
  String get biyolKovanNotuGenel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
