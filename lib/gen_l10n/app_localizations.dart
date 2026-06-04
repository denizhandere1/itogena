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
