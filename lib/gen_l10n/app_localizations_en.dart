// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Itogena Apiary Management';

  @override
  String get girisYukleniyor => 'Preparing data...';

  @override
  String get girisSurumKontrol => 'Checking version...';

  @override
  String get girisYeniSurum => 'Checking for new version...';

  @override
  String get girisAnaSayfaAciliyor => 'Opening home page...';

  @override
  String get girisBaslatmaSorunu => 'A problem occurred during startup.';

  @override
  String girisBaslatmaHatasi(String hata) {
    return 'Startup error: $hata';
  }

  @override
  String get iptal => 'Cancel';

  @override
  String get tamam => 'OK';

  @override
  String get evet => 'Yes';

  @override
  String get hayir => 'No';

  @override
  String get sil => 'Delete';

  @override
  String get duzenle => 'Edit';

  @override
  String get kaydet => 'Save';

  @override
  String get ekle => 'Add';

  @override
  String get vazgec => 'Cancel';

  @override
  String get kapat => 'Close';

  @override
  String get geri => 'Back';

  @override
  String get onayla => 'Confirm';

  @override
  String get hata => 'Error';

  @override
  String get basarili => 'Success';

  @override
  String get uyari => 'Warning';

  @override
  String get bilgi => 'Info';

  @override
  String get yukleniyor => 'Loading...';

  @override
  String get bilinmiyor => 'Unknown';

  @override
  String get proRozeti => 'PRO';

  @override
  String get proOzellik => 'This feature is available in the PRO version.';

  @override
  String get proYukselt => 'Upgrade to PRO';
}
