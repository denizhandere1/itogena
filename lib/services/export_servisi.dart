import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';

import 'veritabani_servisi.dart';

class ExportServisi {
  // PDF'e yazılacak metni Helvetica (Latin-1) ile uyumlu hale getirir.
  static String _ascii(String s) => s
      .replaceAll('ı', 'i')
      .replaceAll('İ', 'I')
      .replaceAll('ğ', 'g')
      .replaceAll('Ğ', 'G')
      .replaceAll('ü', 'u')
      .replaceAll('Ü', 'U')
      .replaceAll('ş', 's')
      .replaceAll('Ş', 'S')
      .replaceAll('ö', 'o')
      .replaceAll('Ö', 'O')
      .replaceAll('ç', 'c')
      .replaceAll('Ç', 'C');

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }

  static String _str(dynamic v) => (v ?? '').toString().trim();

  static String _truncate(String s, int max) =>
      s.length > max ? '${s.substring(0, max)}...' : s;

  static String _tarihStr() {
    final now = DateTime.now();
    final gun = now.day.toString().padLeft(2, '0');
    final ay = now.month.toString().padLeft(2, '0');
    return '${now.year}-$ay-$gun';
  }

  static Future<List<Map<String, dynamic>>> _muayeneleriGetir() async {
    final dbClient = await VeritabaniServisi.db;
    return dbClient.query('muayeneler', orderBy: 'tarih ASC, id ASC');
  }

  /// Tüm veriden PDF raporu üretip paylaşım ekranını açar.
  ///
  /// Belge oluşturma (font ölçümü + tablo düzeni) tamamen senkron ve CPU
  /// yoğun olduğu için ana isolate'te çalıştırılırsa büyük veri setlerinde
  /// (çok sayıda koloni/muayene) UI donar ve ANR oluşur. Bu yüzden veri
  /// hazırlığı burada (DB erişimi gerektirdiği için ana isolate'te) yapılır,
  /// asıl PDF inşası ise compute() ile arka plan isolate'ine taşınır.
  static Future<void> pdfOlusturVePaylas() async {
    final ariliklar = await VeritabaniServisi.ariliklariGetir();
    final koloniler = await VeritabaniServisi.kolonileriGetir(sadeceAktifler: false);
    final muayeneler = await _muayeneleriGetir();

    final muayeneByKoloni = <int, List<Map<String, dynamic>>>{};
    for (final m in muayeneler) {
      final id = _toInt(m['koloniId']);
      muayeneByKoloni.putIfAbsent(id, () => []).add(m);
    }

    final koloniByArilik = <int, List<Map<String, dynamic>>>{};
    for (final k in koloniler) {
      koloniByArilik.putIfAbsent(_toInt(k['arilikId']), () => []).add(k);
    }

    final tarih = _tarihStr();

    final bytes = await compute(_pdfBytesOlustur, {
      'ariliklar': ariliklar,
      'koloniByArilik': koloniByArilik,
      'muayeneByKoloni': muayeneByKoloni,
      'tarih': tarih,
    });

    final dir = await getTemporaryDirectory();
    final dosya = File('${dir.path}/itogena_rapor_$tarih.pdf');
    await dosya.writeAsBytes(bytes);

    await Share.shareXFiles(
      [XFile(dosya.path)],
      text: 'ITOGENA Arilik Raporu — $tarih',
    );

    try {
      await dosya.delete();
    } catch (_) {}
  }

  /// Arka plan isolate'inde çalışır: yalnızca CPU yoğun PDF inşasını yapar.
  /// compute() ile çağrıldığı için top-level/static bir fonksiyon olmalı ve
  /// girdi/çıktısı isolate sınırları arasında taşınabilir (Map/List/primitif)
  /// tipte olmalıdır.
  static Future<Uint8List> _pdfBytesOlustur(Map<String, dynamic> girdi) async {
    final ariliklar = (girdi['ariliklar'] as List).cast<Map<String, dynamic>>();
    final koloniByArilik = (girdi['koloniByArilik'] as Map).map(
      (k, v) => MapEntry(k as int, (v as List).cast<Map<String, dynamic>>()),
    );
    final muayeneByKoloni = (girdi['muayeneByKoloni'] as Map).map(
      (k, v) => MapEntry(k as int, (v as List).cast<Map<String, dynamic>>()),
    );
    final tarih = girdi['tarih'] as String;

    final doc = pw.Document();

    final headerStyle = pw.TextStyle(
      fontWeight: pw.FontWeight.bold,
      fontSize: 9,
    );
    const cellStyle = pw.TextStyle(fontSize: 8);

    for (final arilik in ariliklar) {
      final arilikId = _toInt(arilik['id']);
      final arilikAd = _ascii(_str(arilik['ad']));
      final arilikKoloniler = koloniByArilik[arilikId] ?? [];

      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          header: (ctx) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'ITOGENA — $arilikAd',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'Rapor: $tarih',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ],
              ),
              pw.Divider(thickness: 0.8),
            ],
          ),
          build: (_) => [
            pw.Text(
              'Arilik: $arilikAd  |  Koloni: ${arilikKoloniler.length}  |  '
              'Muayene: ${arilikKoloniler.fold<int>(0, (sum, k) => sum + (muayeneByKoloni[_toInt(k['id'])]?.length ?? 0))}',
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            ...arilikKoloniler.map((koloni) {
              final koloniId = _toInt(koloni['id']);
              final kovanNo = _ascii(_str(koloni['kovanNo']));
              final muayeneler = muayeneByKoloni[koloniId] ?? [];

              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Kovan $kovanNo  (${muayeneler.length} muayene)',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.brown700,
                    ),
                  ),
                  if (muayeneler.isEmpty)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 8, top: 2, bottom: 4),
                      child: pw.Text('Kayit yok', style: const pw.TextStyle(fontSize: 8)),
                    )
                  else
                    pw.TableHelper.fromTextArray(
                      headers: [
                        'Tarih',
                        'Cita',
                        'Yavrulu',
                        'Bal',
                        'Duzeni',
                        'Mizac',
                        'Besleme',
                        'Not',
                      ],
                      data: muayeneler.map((m) {
                        final notlar = _truncate(
                          _ascii(_str(m['notlar']).replaceAll('\n', ' ')),
                          35,
                        );
                        return [
                          _str(m['tarih']),
                          _toInt(m['citaSayisi']).toString(),
                          _toInt(m['yavruluCita']).toString(),
                          _toInt(m['bal_cita']).toString(),
                          _ascii(_str(m['yavruDuzeni'])),
                          _ascii(_str(m['mizac'])),
                          _ascii(_str(m['beslemeTipi'])),
                          notlar,
                        ];
                      }).toList(),
                      headerStyle: headerStyle,
                      cellStyle: cellStyle,
                      border: pw.TableBorder.all(
                        width: 0.5,
                        color: PdfColors.grey400,
                      ),
                      headerDecoration: const pw.BoxDecoration(
                        color: PdfColors.amber100,
                      ),
                      columnWidths: {
                        0: const pw.FixedColumnWidth(56),
                        1: const pw.FixedColumnWidth(28),
                        2: const pw.FixedColumnWidth(32),
                        3: const pw.FixedColumnWidth(26),
                        4: const pw.FixedColumnWidth(40),
                        5: const pw.FixedColumnWidth(36),
                        6: const pw.FixedColumnWidth(38),
                        7: const pw.FlexColumnWidth(),
                      },
                    ),
                ],
              );
            }),
          ],
          footer: (ctx) => pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('ITOGENA Arilik Yonetim', style: const pw.TextStyle(fontSize: 7)),
              pw.Text('Sayfa ${ctx.pageNumber} / ${ctx.pagesCount}',
                  style: const pw.TextStyle(fontSize: 7)),
            ],
          ),
        ),
      );
    }

    if (ariliklar.isEmpty) {
      doc.addPage(
        pw.Page(
          build: (_) => pw.Center(
            child: pw.Text('Kayitli veri bulunamadi.'),
          ),
        ),
      );
    }

    return doc.save();
  }

  /// Tüm veriden Excel (.xlsx) dosyası üretip paylaşım ekranını açar.
  static Future<void> excelOlusturVePaylas() async {
    final ariliklar = await VeritabaniServisi.ariliklariGetir();
    final koloniler = await VeritabaniServisi.kolonileriGetir(sadeceAktifler: false);
    final muayeneler = await _muayeneleriGetir();

    final arilikAdMap = <int, String>{};
    for (final a in ariliklar) {
      arilikAdMap[_toInt(a['id'])] = _str(a['ad']);
    }

    final koloniNoMap = <int, String>{};
    final koloniArilikMap = <int, int>{};
    for (final k in koloniler) {
      final id = _toInt(k['id']);
      koloniNoMap[id] = _str(k['kovanNo']);
      koloniArilikMap[id] = _toInt(k['arilikId']);
    }

    final excel = Excel.createExcel();

    // ── Sayfa 1: Muayeneler ─────────────────────────────────────────────────
    final muayeneSayfasi = excel['Muayeneler'];
    muayeneSayfasi.appendRow([
      TextCellValue('Tarih'),
      TextCellValue('Arılık'),
      TextCellValue('Kovan No'),
      TextCellValue('Toplam Çıta'),
      TextCellValue('Yavrulu Çıta'),
      TextCellValue('Bal Çıtası'),
      TextCellValue('Yavru Düzeni'),
      TextCellValue('Mizaç'),
      TextCellValue('Besleme'),
      TextCellValue('Varroa'),
      TextCellValue('Ana Görülmedi'),
      TextCellValue('Oğul Belirtisi'),
      TextCellValue('Oğul Attı'),
      TextCellValue('Bölme'),
      TextCellValue('Kovan Söndü'),
      TextCellValue('Anasız Bırakıldı'),
      TextCellValue('Notlar'),
    ]);

    for (final m in muayeneler) {
      final koloniId = _toInt(m['koloniId']);
      final arilikId = koloniArilikMap[koloniId] ?? 0;
      muayeneSayfasi.appendRow([
        TextCellValue(_str(m['tarih'])),
        TextCellValue(arilikAdMap[arilikId] ?? ''),
        TextCellValue(koloniNoMap[koloniId] ?? ''),
        IntCellValue(_toInt(m['citaSayisi'])),
        IntCellValue(_toInt(m['yavruluCita'])),
        IntCellValue(_toInt(m['bal_cita'])),
        TextCellValue(_str(m['yavruDuzeni'])),
        TextCellValue(_str(m['mizac'])),
        TextCellValue(_str(m['beslemeTipi'])),
        TextCellValue(_str(m['varroaMucadele'])),
        TextCellValue(_toInt(m['anaAriGoruldu']) == 0 ? 'Evet' : 'Hayır'),
        TextCellValue(_toInt(m['ogulBelirtisi']) == 1 ? 'Evet' : 'Hayır'),
        TextCellValue(_toInt(m['ogulAtti']) == 1 ? 'Evet' : 'Hayır'),
        TextCellValue(_toInt(m['bolmeYapildi']) == 1 ? 'Evet' : 'Hayır'),
        TextCellValue(_toInt(m['kovanSondu']) == 1 ? 'Evet' : 'Hayır'),
        TextCellValue(_toInt(m['anasizBirakildiMi']) == 1 ? 'Evet' : 'Hayır'),
        TextCellValue(_str(m['notlar'])),
      ]);
    }

    // ── Sayfa 2: Koloniler ───────────────────────────────────────────────────
    final koloniSayfasi = excel['Koloniler'];
    koloniSayfasi.appendRow([
      TextCellValue('Arılık'),
      TextCellValue('Kovan No'),
      TextCellValue('Oluşturma Tarihi'),
      TextCellValue('Durum'),
      TextCellValue('Kaynak Tipi'),
      TextCellValue('Kaynak Koloni'),
    ]);

    for (final k in koloniler) {
      final arilikId = _toInt(k['arilikId']);
      koloniSayfasi.appendRow([
        TextCellValue(arilikAdMap[arilikId] ?? ''),
        TextCellValue(_str(k['kovanNo'])),
        TextCellValue(_str(k['olusturmaTarihi'])),
        TextCellValue(_str(k['durum'])),
        TextCellValue(_str(k['kaynakTipi'])),
        TextCellValue(_str(k['kaynakKoloni'])),
      ]);
    }

    // ── Sayfa 3: Arılıklar ───────────────────────────────────────────────────
    final arilikSayfasi = excel['Arılıklar'];
    arilikSayfasi.appendRow([
      TextCellValue('Arılık Adı'),
      TextCellValue('Kuruluş Tarihi'),
      TextCellValue('Konum'),
    ]);

    for (final a in ariliklar) {
      arilikSayfasi.appendRow([
        TextCellValue(_str(a['ad'])),
        TextCellValue(_str(a['kurulusTarihi'])),
        TextCellValue(_str(a['konum'])),
      ]);
    }

    excel.delete('Sheet1');

    final tarih = _tarihStr();
    final bytes = excel.encode();
    if (bytes == null) throw Exception('Excel dosyası oluşturulamadı.');

    final dir = await getTemporaryDirectory();
    final dosya = File('${dir.path}/itogena_export_$tarih.xlsx');
    await dosya.writeAsBytes(bytes);

    await Share.shareXFiles(
      [XFile(dosya.path)],
      text: 'İTOGENA Veri Dışa Aktarma — $tarih',
    );

    try {
      await dosya.delete();
    } catch (_) {}
  }
}
