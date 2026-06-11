import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

import 'yedek_servisi.dart';

class YedekDosyaServisi {
  /// JSON yedeği üretir, dosyaya yazar ve paylaşım ekranı açar.
  static Future<void> yedekOlusturVePaylas() async {
    final jsonStr = await YedekServisi.yedekAl();
    final dir = await getTemporaryDirectory();

    final now = DateTime.now();
    final tarihStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final dosyaAdi = 'itogena_yedek_$tarihStr.json';

    final file = File('${dir.path}/$dosyaAdi');
    await file.writeAsString(jsonStr);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'İTOGENA yedek dosyası — $tarihStr',
    );

    try {
      await file.delete();
    } catch (_) {}
  }

  /// Kullanıcıdan JSON dosyası seçtirir ve içeriğini okuyarak metadata döndürür.
  /// Kullanıcı iptal ederse null döner.
  static Future<YedekMeta?> dosyaSecVeMetaOku() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.isEmpty) return null;

    final path = result.files.single.path;
    if (path == null) throw Exception('Dosya yolu alınamadı.');

    final file = File(path);
    if (!await file.exists()) throw Exception('Dosya bulunamadı.');

    final jsonStr = await file.readAsString();
    return YedekServisi.jsonMetaOku(jsonStr);
  }

  /// Daha önce okunan bir yedek metasından geri yükleme yapar.
  static Future<void> metadenYukle(YedekMeta meta) async {
    await YedekServisi.yedektenYukle(meta.jsonIcerigi);
  }
}
