import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

import 'yedek_servisi.dart';

class YedekDosyaServisi {
  /// JSON yedeği üretir, dosyaya yazar ve paylaşım ekranı açar
  static Future<void> yedekOlusturVePaylas() async {
    final jsonStr = await YedekServisi.yedekAl();

    final dir = await getTemporaryDirectory();

    final dosyaAdi =
        'itogena_yedek_${DateTime.now().millisecondsSinceEpoch}.json';

    final file = File('${dir.path}/$dosyaAdi');

    await file.writeAsString(jsonStr);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'İTOGENA yedek dosyası',
    );
  }

  /// Kullanıcıdan JSON dosyası seçtirir ve geri yükler
  static Future<void> yedekDosyasindanYukle() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.isEmpty) {
      return;
    }

    final path = result.files.single.path;

    if (path == null) {
      throw Exception('Dosya yolu alınamadı.');
    }

    final file = File(path);

    if (!await file.exists()) {
      throw Exception('Dosya bulunamadı.');
    }

    final jsonStr = await file.readAsString();

    await YedekServisi.yedektenYukle(jsonStr);
  }
}