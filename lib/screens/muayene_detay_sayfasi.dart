import 'package:flutter/material.dart';
import 'package:itogena_v45/gen_l10n/app_localizations.dart';

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

  String _anaKazanmaYontemiMetni(dynamic v, AppLocalizations l10n) {
    final temiz = (v ?? '').toString().trim();
    if (temiz.isEmpty) return '-';
    switch (temiz) {
      case 'kapali_meme':
        return l10n.muayeneDetayKapaliMeme;
      case 'hazir_ana':
        return l10n.muayeneDetayHazirAna;
      case 'kendi_anasi':
        return l10n.muayeneDetayKendiAnasi;
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

  List<String> _varroaSecimleri(AppLocalizations l10n) {
    final secimler = <String>[];

    void ekle(String etiket) {
      if (!secimler.contains(etiket)) secimler.add(etiket);
    }

    if (_boolAlan(muayene['varroaDroneKesimi'])) ekle(l10n.muayeneDetayDroneKesimi);
    if (_boolAlan(muayene['varroaBolme'])) ekle(l10n.muayeneDetayBolmeYapildi);
    if (_boolAlan(muayene['varroaTimol'])) ekle(l10n.muayeneDetayTimol);
    if (_boolAlan(muayene['varroaAmitraz'])) ekle(l10n.muayeneDetayAmitraz);
    if (_boolAlan(muayene['varroaFormik'])) ekle(l10n.muayeneDetayFormik);
    if (_boolAlan(muayene['varroaOksalik'])) ekle(l10n.muayeneDetayOksalik);

    final eski = _metin(muayene['varroaMucadele'], varsayilan: '');
    final eskiNorm = eski.toLowerCase();

    if (secimler.isEmpty && eski.isNotEmpty && eski != '-') {
      if (eskiNorm.contains('drone')) ekle(l10n.muayeneDetayDroneKesimi);
      else if (eskiNorm == 'bölme' || eskiNorm == 'bolme') ekle(l10n.muayeneDetayBolmeYapildi);
      else if (eskiNorm.contains('timol')) ekle(l10n.muayeneDetayTimol);
      else if (eskiNorm.contains('varroset') || eskiNorm.contains('amitraz')) ekle(l10n.muayeneDetayAmitraz);
      else if (eskiNorm.contains('formik')) ekle(l10n.muayeneDetayFormik);
      else if (eskiNorm.contains('oksalik')) ekle(l10n.muayeneDetayOksalik);
      else if (eskiNorm != 'yok') ekle(eski);
    }

    return secimler;
  }

  bool _yavruDuzeniYokMu() {
    final yavruDuzeni = _metin(muayene['yavruDuzeni'], varsayilan: '');
    return yavruDuzeni.trim().toLowerCase() == 'yok';
  }

  Widget _yavruYokKayitKutusu(AppLocalizations l10n) {
    if (!_yavruDuzeniYokMu()) return const SizedBox.shrink();

    final bool anaSureciKaydi =
        _boolAlan(muayene['anasizBirakildiMi']) ||
        _boolAlan(muayene['bolmeYapildi']) ||
        _boolAlan(muayene['ogulAtti']) ||
        _boolAlan(muayene['gunlukKapaliYavruGoruldu']) ||
        _anaKazanmaYontemiMetni(muayene['anaKazanmaYontemi'], l10n) != '-';

    final String mesaj = anaSureciKaydi
        ? l10n.muayeneDetayYavruYokAnaSureci
        : l10n.muayeneDetayYavruYokBasit;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blueGrey.withOpacity(0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Colors.blueGrey, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              mesaj,
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.45,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _tetikSatirlari(AppLocalizations l10n) {
    final satirlar = <Widget>[];

    void ekle(String etiket, bool kosul) {
      if (!kosul) return;
      satirlar.add(_satir(etiket, l10n.muayeneDetayEvet));
    }

    ekle(l10n.muayeneDetayOgulBelirtisi, _boolAlan(muayene['ogulBelirtisi']));
    ekle(l10n.muayeneDetayOgulAtti, _boolAlan(muayene['ogulAtti']));
    ekle(l10n.muayeneDetayBolmeYapildi, _boolAlan(muayene['bolmeYapildi']));
    ekle(l10n.muayeneDetayAnasizBirakildi, _boolAlan(muayene['anasizBirakildiMi']));
    ekle(l10n.muayeneDetayKovanSondu, _boolAlan(muayene['kovanSondu']));

    final balHasat = _int(muayene['bal_cita']);
    if (balHasat > 0) {
      satirlar.add(_satir(l10n.muayeneDetayBalHasat, balHasat.toString()));
    }

    return satirlar;
  }

  List<Widget> _surecSatirlari(AppLocalizations l10n) {
    final satirlar = <Widget>[];

    void ekle(String etiket, bool kosul) {
      if (!kosul) return;
      satirlar.add(_satir(etiket, l10n.muayeneDetayEvet));
    }

    ekle(l10n.muayeneDetayKapaliYavruAktarildi, _boolAlan(muayene['kapaliYavruluCitaAktarildi']));
    final anaKazanmaYontemi = _anaKazanmaYontemiMetni(muayene['anaKazanmaYontemi'], l10n);
    if (anaKazanmaYontemi != '-') {
      satirlar.add(_satir(l10n.muayeneDetayAnaKazanmaYontemi, anaKazanmaYontemi));
    }
    ekle(l10n.muayeneDetayDisaridanAna, _boolAlan(muayene['disaridanHazirAnaVerildi']));
    ekle(l10n.muayeneDetayGunlukYavru, _boolAlan(muayene['gunlukKapaliYavruGoruldu']));
    ekle(l10n.muayeneDetaySuruplukKaldirildi, _boolAlan(muayene['suruplukKaldirildiMi']));

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
    final l10n = AppLocalizations.of(context);
    final notlar = _metin(muayene['notlar'], varsayilan: l10n.muayeneDetayYok);
    final varroaSecimleri = _varroaSecimleri(l10n);

    final tetikSatirlari = _tetikSatirlari(l10n);
    final surecSatirlari = _surecSatirlari(l10n);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: Text(
          l10n.muayeneDetayBaslik(kovanNo),
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
              baslik: l10n.muayeneDetayGenelBilgi,
              ikon: Icons.calendar_month_outlined,
              children: [
                _satir(l10n.muayeneDetayTarih, tarih),
                _satir(l10n.muayeneDetayCita, cita),
                _satir(l10n.muayeneDetayYavruluCita, yavruluCita),
                _satir(l10n.muayeneDetayBalHasat, balHasat),
                _satir(l10n.muayeneDetayYavruDuzeni, yavruDuzeni),
                _satir(l10n.muayeneDetayMizac, mizac),
                _satir(l10n.muayeneDetayBesleme, besleme),
                _satir(
                  l10n.muayeneDetayVarroaMucadele,
                  varroaSecimleri.isEmpty ? l10n.muayeneDetayYok : varroaSecimleri.join(', '),
                ),
              ],
            ),
            _yavruYokKayitKutusu(l10n),
            if (tetikSatirlari.isNotEmpty)
              _bolumKart(
                baslik: l10n.muayeneDetayTetikler,
                ikon: Icons.bolt_outlined,
                children: tetikSatirlari,
              ),
            if (surecSatirlari.isNotEmpty)
              _bolumKart(
                baslik: l10n.muayeneDetaySurec,
                ikon: Icons.timeline_outlined,
                children: surecSatirlari,
              ),
            _bolumKart(
              baslik: l10n.muayeneDetayNotlar,
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
