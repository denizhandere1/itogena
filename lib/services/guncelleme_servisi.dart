import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  static const String versionJsonUrl =
      'https://itogaciftligi.com/itogena/version.json';

  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.itogaciftligi.itogena';

  static Future<GuncellemeBilgisi> kontrolEt({
    String url = versionJsonUrl,
    String dilKodu = 'tr',
  }) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final int currentVersionCode =
        int.tryParse(packageInfo.buildNumber.trim()) ?? 0;
    final String currentVersionName = packageInfo.version.trim();

    try {
      final uri = Uri.parse(url);
      final response = await http
          .get(
            uri,
            headers: const {
              'Cache-Control': 'no-cache',
              'Pragma': 'no-cache',
            },
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        return GuncellemeBilgisi.hata(
          currentVersionCode: currentVersionCode,
          currentVersionName: currentVersionName,
          hata: 'Sunucu yanıtı alınamadı (${response.statusCode}).',
        );
      }

      final dynamic decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return GuncellemeBilgisi.hata(
          currentVersionCode: currentVersionCode,
          currentVersionName: currentVersionName,
          hata: 'version.json formatı geçersiz.',
        );
      }

      final String latestVersionName =
          (decoded['latestVersionName'] ?? '').toString().trim();
      final int latestVersionCode =
          int.tryParse((decoded['latestVersionCode'] ?? '').toString()) ?? 0;
      final bool forceUpdate = decoded['forceUpdate'] == true;
      final int minSupportedVersionCode =
          int.tryParse((decoded['minSupportedVersionCode'] ?? '').toString()) ??
              0;
      final String messageTr = (decoded['messageTr'] ?? '').toString().trim();
      final String messageEn = (decoded['messageEn'] ?? '').toString().trim();

      final String mesaj = dilKodu.toLowerCase().startsWith('en')
          ? (messageEn.isNotEmpty ? messageEn : messageTr)
          : (messageTr.isNotEmpty ? messageTr : messageEn);

      final bool desteklenmeyenSurum =
          currentVersionCode < minSupportedVersionCode;
      final bool guncellemeVar = latestVersionCode > currentVersionCode;
      final bool zorunluGuncelleme = desteklenmeyenSurum || forceUpdate;

      return GuncellemeBilgisi(
        guncellemeVar: guncellemeVar,
        zorunluGuncelleme: zorunluGuncelleme,
        desteklenmeyenSurum: desteklenmeyenSurum,
        latestVersionName:
            latestVersionName.isNotEmpty ? latestVersionName : currentVersionName,
        latestVersionCode:
            latestVersionCode > 0 ? latestVersionCode : currentVersionCode,
        currentVersionCode: currentVersionCode,
        currentVersionName: currentVersionName,
        mesaj: mesaj,
      );
    } catch (e) {
      return GuncellemeBilgisi.hata(
        currentVersionCode: currentVersionCode,
        currentVersionName: currentVersionName,
        hata: 'Güncelleme kontrolü yapılamadı: $e',
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
                await YedekDosyaServisi.yedekOlusturVePaylas();

                if (!dialogContext.mounted) return;

                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Yedek hazırlandı. Güvenli bir yere kaydetmen önerilir.',
                    ),
                  ),
                );

                final bool acildi = await playStoreSayfasiniAc();

                if (!dialogContext.mounted) return;

                if (!acildi) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('Play Store açılamadı.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (!zorunlu && dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              } catch (e) {
                if (!dialogContext.mounted) return;
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  SnackBar(
                    content: Text('Yedek alma / güncelleme akışı başarısız: $e'),
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
                    const SizedBox(height: 6),
                    Text(
                      'Yeni sürüm: ${bilgi.latestVersionName} (${bilgi.latestVersionCode})',
                      style: const TextStyle(fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      bilgi.mesaj.isNotEmpty
                          ? bilgi.mesaj
                          : 'Yeni sürüm hazır. Güncellemeden önce yedek alman önerilir.',
                      style: const TextStyle(fontSize: 13, height: 1.45),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Güncellemeden önce otomatik JSON yedeği hazırlanır, ardından Play Store açılır.',
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
                      onPressed: islemde
                          ? null
                          : () => Navigator.of(dialogContext).pop(),
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
