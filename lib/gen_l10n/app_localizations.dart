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
