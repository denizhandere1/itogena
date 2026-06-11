import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'yedek_dosya_servisi.dart';

class GuncellemeBilgisi {
  final bool guncellemeVar;
  final bool zorunluGuncelleme;
  final bool desteklenmeyenSurum;
  final String latestVersionName;
  final int latestVersionCode;
  final int currentVersionCode;
  final String currentVersionName;
  final String mesaj;
  final String? hata;
  final AppUpdateInfo? iapBilgisi;

  const GuncellemeBilgisi({
    required this.guncellemeVar,
    required this.zorunluGuncelleme,
    required this.desteklenmeyenSurum,
    required this.latestVersionName,
    required this.latestVersionCode,
    required this.currentVersionCode,
    required this.currentVersionName,
    required this.mesaj,
    this.hata,
    this.iapBilgisi,
  });

  bool get diyalogGoster => guncellemeVar || desteklenmeyenSurum;

  factory GuncellemeBilgisi.yok({
    required int currentVersionCode,
    required String currentVersionName,
  }) {
    return GuncellemeBilgisi(
      guncellemeVar: false,
      zorunluGuncelleme: false,
      desteklenmeyenSurum: false,
      latestVersionName: currentVersionName,
      latestVersionCode: currentVersionCode,
      currentVersionCode: currentVersionCode,
      currentVersionName: currentVersionName,
      mesaj: '',
    );
  }

  factory GuncellemeBilgisi.hata({
    required int currentVersionCode,
    required String currentVersionName,
    required String hata,
  }) {
    return GuncellemeBilgisi(
      guncellemeVar: false,
      zorunluGuncelleme: false,
      desteklenmeyenSurum: false,
      latestVersionName: currentVersionName,
      latestVersionCode: currentVersionCode,
      currentVersionCode: currentVersionCode,
      currentVersionName: currentVersionName,
      mesaj: '',
      hata: hata,
    );
  }
}

class GuncellemeServisi {
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.itogaciftligi.itogena';

  /// Play Store API üzerinden güncelleme kontrolü yapar.
  /// Debug modda veya uygulama Play Store'da yayında değilken
  /// sessizce "güncelleme yok" döner — crash veya hata snackbar'ı olmaz.
  static Future<GuncellemeBilgisi> kontrolEt({String dilKodu = 'tr'}) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersionCode =
        int.tryParse(packageInfo.buildNumber.trim()) ?? 0;
    final currentVersionName = packageInfo.version.trim();

    try {
      final AppUpdateInfo info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability != UpdateAvailability.updateAvailable) {
        return GuncellemeBilgisi.yok(
          currentVersionCode: currentVersionCode,
          currentVersionName: currentVersionName,
        );
      }

      // Yalnızca immediate izinliyse (flexible değilse) zorunlu say.
      // Her iki tip izinliyse kullanıcı dostu flexible tercih edilir.
      final zorunlu =
          info.immediateUpdateAllowed && !info.flexibleUpdateAllowed;

      return GuncellemeBilgisi(
        guncellemeVar: true,
        zorunluGuncelleme: zorunlu,
        desteklenmeyenSurum: false,
        latestVersionName: '',
        latestVersionCode: info.availableVersionCode ?? 0,
        currentVersionCode: currentVersionCode,
        currentVersionName: currentVersionName,
        mesaj: '',
        iapBilgisi: info,
      );
    } catch (_) {
      // Debug mod, emülatör veya Play Store dışı dağıtım — sessiz dön.
      return GuncellemeBilgisi.yok(
        currentVersionCode: currentVersionCode,
        currentVersionName: currentVersionName,
      );
    }
  }

  static Future<bool> playStoreSayfasiniAc() async {
    final uri = Uri.parse(playStoreUrl);
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Future<void> guncellemeDiyaloguGoster(
    BuildContext context,
    GuncellemeBilgisi bilgi,
  ) async {
    if (!bilgi.diyalogGoster) return;

    final bool zorunlu = bilgi.zorunluGuncelleme;
    bool islemde = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: !zorunlu,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> guncellemeAkisi() async {
              if (islemde) return;
              setState(() => islemde = true);

              try {
                // Önce yedek al — mevcut veri her zaman korunur
                await YedekDosyaServisi.yedekOlusturVePaylas();

                if (!dialogContext.mounted) return;

                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(
                    content: Text('Yedek hazırlandı. Güncelleme başlatılıyor…'),
                  ),
                );

                final iap = bilgi.iapBilgisi;
                if (iap != null) {
                  if (zorunlu) {
                    // Tam ekran zorunlu güncelleme — uygulama yeniden başlar
                    await InAppUpdate.performImmediateUpdate();
                  } else {
                    // Arka planda indir, hazır olunca kur ve yeniden başlat
                    await InAppUpdate.startFlexibleUpdate();
                    await InAppUpdate.completeFlexibleUpdate();
                  }
                } else {
                  // Yedek: Play Store sayfasını aç (IAP yoksa)
                  final acildi = await playStoreSayfasiniAc();
                  if (!acildi && dialogContext.mounted) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(
                        content: Text('Play Store açılamadı.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }

                if (!zorunlu && dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              } catch (e) {
                if (!dialogContext.mounted) return;
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  SnackBar(
                    content: Text('Güncelleme başarısız: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              } finally {
                if (dialogContext.mounted) {
                  setState(() => islemde = false);
                }
              }
            }

            return WillPopScope(
              onWillPop: () async => !zorunlu && !islemde,
              child: AlertDialog(
                title: Text(
                  zorunlu ? 'GÜNCELLEME GEREKLİ' : 'YENİ SÜRÜM HAZIR',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mevcut sürüm: ${bilgi.currentVersionName} (${bilgi.currentVersionCode})',
                      style: const TextStyle(fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Yeni sürüm kullanıma girdi. Güncellemeden önce yedek alman önerilir.',
                      style: TextStyle(fontSize: 13, height: 1.45),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '"Yedek Al ve Güncelle" butonuna bastığında JSON yedeği otomatik hazırlanır, ardından güncelleme başlar.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: Colors.black54,
                      ),
                    ),
                    if (bilgi.desteklenmeyenSurum) ...[
                      const SizedBox(height: 10),
                      const Text(
                        'Bu sürüm artık desteklenmiyor. Devam etmek için güncelleme yapmalısın.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          fontWeight: FontWeight.w700,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ],
                ),
                actions: [
                  if (!zorunlu)
                    TextButton(
                      onPressed:
                          islemde ? null : () => Navigator.of(dialogContext).pop(),
                      child: const Text('SONRA'),
                    ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: islemde ? null : guncellemeAkisi,
                    child: islemde
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'YEDEK AL VE GÜNCELLE',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
