import 'package:flutter/material.dart';

class MuayeneDetaySayfasi extends StatelessWidget {
  final Map<String, dynamic> muayene;
  final String kovanNo;

  const MuayeneDetaySayfasi({
    super.key,
    required this.muayene,
    required this.kovanNo,
  });

  String _metin(dynamic v, {String varsayilan = '-'}) {
    if (v == null) return varsayilan;
    final s = v.toString().trim();
    if (s.isEmpty) return varsayilan;
    return s;
  }

  int _int(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }

  bool _boolAlan(dynamic v) => _int(v) == 1;

  String _anaKazanmaYontemiMetni(dynamic v) {
    final temiz = (v ?? '').toString().trim();
    if (temiz.isEmpty) return '-';
    switch (temiz) {
      case 'kapali_meme':
        return 'Hazır kapalı ana memesi var';
      case 'hazir_ana':
        return 'Hazır çiftleşmiş ana verildi';
      case 'kendi_anasi':
        return 'Kendi anasını yapacak';
      default:
        return temiz;
    }
  }

  Widget _satir(String baslik, String deger) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              baslik,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.brown,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              deger,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bolumKart({
    required String baslik,
    required List<Widget> children,
    IconData? ikon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (ikon != null) ...[
                Icon(ikon, color: Colors.brown, size: 20),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  baslik,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.brown,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  String _tarihFormatla(String ham) {
    final temiz = ham.trim();
    if (temiz.isEmpty) return '-';

    try {
      final dt = DateTime.tryParse(temiz);
      if (dt != null) {
        final gun = dt.day.toString().padLeft(2, '0');
        final ay = dt.month.toString().padLeft(2, '0');
        final yil = dt.year.toString();
        return '$gun.$ay.$yil';
      }
    } catch (_) {}

    return temiz;
  }

  List<String> _varroaSecimleri() {
    final secimler = <String>[];

    void ekle(String etiket) {
      if (!secimler.contains(etiket)) secimler.add(etiket);
    }

    if (_boolAlan(muayene['varroaDroneKesimi'])) ekle('Drone Kesimi');
    if (_boolAlan(muayene['varroaBolme'])) ekle('Bölme');
    if (_boolAlan(muayene['varroaTimol'])) ekle('Timol');
    if (_boolAlan(muayene['varroaAmitraz'])) ekle('Amitraz');
    if (_boolAlan(muayene['varroaFormik'])) ekle('Formik');
    if (_boolAlan(muayene['varroaOksalik'])) ekle('Oksalik');

    final eski = _metin(muayene['varroaMucadele'], varsayilan: '');
    final eskiNorm = eski.toLowerCase();

    if (secimler.isEmpty && eski.isNotEmpty && eski != '-') {
      if (eskiNorm.contains('drone')) ekle('Drone Kesimi');
      else if (eskiNorm == 'bölme' || eskiNorm == 'bolme') ekle('Bölme');
      else if (eskiNorm.contains('timol')) ekle('Timol');
      else if (eskiNorm.contains('varroset') || eskiNorm.contains('amitraz')) ekle('Amitraz');
      else if (eskiNorm.contains('formik')) ekle('Formik');
      else if (eskiNorm.contains('oksalik')) ekle('Oksalik');
      else if (eskiNorm != 'yok') ekle(eski);
    }

    return secimler;
  }

  List<Widget> _tetikSatirlari() {
    final satirlar = <Widget>[];

    void ekle(String etiket, bool kosul) {
      if (!kosul) return;
      satirlar.add(_satir(etiket, 'Evet'));
    }

    ekle('Oğul Belirtisi', _boolAlan(muayene['ogulBelirtisi']));
    ekle('Oğul Attı', _boolAlan(muayene['ogulAtti']));
    ekle('Bölme Yapıldı', _boolAlan(muayene['bolmeYapildi']));
    ekle('Anasız Bırakıldı', _boolAlan(muayene['anasizBirakildiMi']));
    ekle('Kovan Söndü', _boolAlan(muayene['kovanSondu']));

    final balHasat = _int(muayene['bal_cita']);
    if (balHasat > 0) {
      satirlar.add(_satir('Bal/Hasat', balHasat.toString()));
    }

    return satirlar;
  }

  List<Widget> _surecSatirlari() {
    final satirlar = <Widget>[];

    void ekle(String etiket, bool kosul) {
      if (!kosul) return;
      satirlar.add(_satir(etiket, 'Evet'));
    }

    ekle('Kapalı Yavrulu Çıta Aktarıldı', _boolAlan(muayene['kapaliYavruluCitaAktarildi']));
    final anaKazanmaYontemi = _anaKazanmaYontemiMetni(muayene['anaKazanmaYontemi']);
    if (anaKazanmaYontemi != '-') {
      satirlar.add(_satir('Ana Kazanma Yöntemi', anaKazanmaYontemi));
    }
    ekle('Dışarıdan Hazır Ana Verildi', _boolAlan(muayene['disaridanHazirAnaVerildi']));
    ekle('Günlük / Kapalı Yavru Görüldü', _boolAlan(muayene['gunlukKapaliYavruGoruldu']));
    ekle('Şurupluk Kaldırıldı', _boolAlan(muayene['suruplukKaldirildiMi']));

    return satirlar;
  }

  @override
  Widget build(BuildContext context) {
    final altBosluk = MediaQuery.of(context).padding.bottom + 28;

    final tarih = _tarihFormatla(_metin(muayene['tarih']));
    final cita = _int(muayene['citaSayisi']).toString();
    final yavruluCita = _int(muayene['yavruluCita']).toString();
    final balHasat = _int(muayene['bal_cita']).toString();

    final yavruDuzeni = _metin(muayene['yavruDuzeni']);
    final mizac = _metin(muayene['mizac']);
    final besleme = _metin(muayene['beslemeTipi']);
    final notlar = _metin(muayene['notlar'], varsayilan: 'Yok');
    final varroaSecimleri = _varroaSecimleri();

    final tetikSatirlari = _tetikSatirlari();
    final surecSatirlari = _surecSatirlari();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: Text(
          'KOVAN $kovanNo / MUAYENE',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(14, 14, 14, altBosluk),
          children: [
            _bolumKart(
              baslik: 'GENEL BİLGİ',
              ikon: Icons.calendar_month_outlined,
              children: [
                _satir('Tarih', tarih),
                _satir('Çıta', cita),
                _satir('Yavrulu Çıta', yavruluCita),
                _satir('Bal/Hasat', balHasat),
                _satir('Yavru Düzeni', yavruDuzeni),
                _satir('Mizaç', mizac),
                _satir('Besleme', besleme),
                _satir(
                  'Varroa Mücadelesi',
                  varroaSecimleri.isEmpty ? 'Yok' : varroaSecimleri.join(', '),
                ),
              ],
            ),
            if (tetikSatirlari.isNotEmpty)
              _bolumKart(
                baslik: 'TETİKLER',
                ikon: Icons.bolt_outlined,
                children: tetikSatirlari,
              ),
            if (surecSatirlari.isNotEmpty)
              _bolumKart(
                baslik: 'SÜREÇ KAYITLARI',
                ikon: Icons.timeline_outlined,
                children: surecSatirlari,
              ),
            _bolumKart(
              baslik: 'NOTLAR',
              ikon: Icons.notes_outlined,
              children: [
                Text(
                  notlar,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
