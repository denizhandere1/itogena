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
