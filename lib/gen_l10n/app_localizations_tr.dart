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
  String get proRozeti => 'PRO';

  @override
  String get proOzellik => 'Bu özellik PRO sürümüne aittir.';

  @override
  String get proYukselt => 'PRO\'ya Yükselt';
}
