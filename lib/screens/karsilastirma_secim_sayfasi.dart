import 'package:flutter/material.dart';
import 'package:itogena_v45/gen_l10n/app_localizations.dart';
import 'ana_sayfa_kisayol.dart';
import '../services/veritabani_servisi.dart';
import '../services/performans_ozeti_servisi.dart';
import '../services/karar_asistan_servisi.dart';

class KarsilastirmaSecimSayfasi extends StatefulWidget {
  final String baslik;

  const KarsilastirmaSecimSayfasi({
    super.key,
    this.baslik = 'RAPORLAR > KARŞILAŞTIRMALI PERFORMANS',
  });

  @override
  State<KarsilastirmaSecimSayfasi> createState() =>
      _KarsilastirmaSecimSayfasiState();
}

class _KarsilastirmaSecimSayfasiState extends State<KarsilastirmaSecimSayfasi> {
  bool _yukleniyor = true;
  bool _hesapliyor = false;

  List<Map<String, dynamic>> _koloniler = [];
  final Set<int> _seciliKoloniIdleri = {};

  @override
  void initState() {
    super.initState();
    _verileriYukle();
  }

  Future<void> _verileriYukle() async {
    final koloniler = await VeritabaniServisi.kolonileriGetir();

    koloniler.sort((a, b) {
      final aSkor = _toInt(a['skor']);
      final bSkor = _toInt(b['skor']);
      if (aSkor != bSkor) return bSkor.compareTo(aSkor);

      final aNo = (a['kovanNo'] ?? '').toString();
      final bNo = (b['kovanNo'] ?? '').toString();
      return aNo.compareTo(bNo);
    });

    if (!mounted) return;
    setState(() {
      _koloniler = koloniler;
      _yukleniyor = false;
    });
  }

  int _toInt(dynamic deger) {
    if (deger == null) return 0;
    if (deger is int) return deger;
    if (deger is double) return deger.round();
    return int.tryParse(deger.toString()) ?? 0;
  }

  Future<void> _karsilastir() async {
    if (_seciliKoloniIdleri.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).karsilastirmaSecimMinKoloni),
        ),
      );
      return;
    }

    setState(() {
      _hesapliyor = true;
    });

    try {
      final List<Map<String, dynamic>> secilenler = _koloniler
          .where((k) => _seciliKoloniIdleri.contains(_toInt(k['id'])))
          .toList();

      final List<_KarsilastirmaKoloniVerisi> veriler = [];
      final donorler = await KararAsistanServisi.donorAdaylariSiraliGetir();

      for (final koloni in secilenler) {
        final id = _toInt(koloni['id']);
        final performans = await PerformansOzetiServisi.getir(id);
        final secilim = await KararAsistanServisi.secilimDurumuGetir(
          id,
          koloni,
          siraliDonorler: donorler,
        );
        final karar = await KararAsistanServisi.anaKararUret(
          id,
          koloni,
          siraliDonorler: donorler,
        );

        veriler.add(
          _KarsilastirmaKoloniVerisi(
            koloniId: id,
            kovanNo: (koloni['kovanNo'] ?? '-').toString(),
            genelSkor: performans.genelSkor,
            donorSkoru: performans.donorSkoru,
            donorMu: performans.donorMu,
            donorSirasi: performans.donorSirasi,
            vetoVarMi: performans.vetoVarMi,
            vetoNedeni: performans.vetoNedeni,
            secilimBaslik: (secilim['baslik'] ?? '-').toString(),
            kararBaslik: (karar['baslik'] ?? '-').toString(),
            hamProfil: performans.hamProfil,
          ),
        );
      }

      veriler.sort((a, b) {
        if (a.vetoVarMi != b.vetoVarMi) {
          return a.vetoVarMi ? 1 : -1;
        }
        if (a.donorMu != b.donorMu) {
          return a.donorMu ? -1 : 1;
        }
        if (a.donorMu && b.donorMu) {
          final aSira = a.donorSirasi ?? 999;
          final bSira = b.donorSirasi ?? 999;
          if (aSira != bSira) return aSira.compareTo(bSira);
        }
        if (a.donorSkoru != b.donorSkoru) {
          return b.donorSkoru.compareTo(a.donorSkoru);
        }
        return b.genelSkor.compareTo(a.genelSkor);
      });

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => KarsilastirmaliPerformansSayfasi(
            baslik: widget.baslik,
            veriler: veriler,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _hesapliyor = false;
        });
      }
    }
  }

  void _secimDegistir(int koloniId) {
    setState(() {
      if (_seciliKoloniIdleri.contains(koloniId)) {
        _seciliKoloniIdleri.remove(koloniId);
      } else {
        if (_seciliKoloniIdleri.length >= 3) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).karsilastirmaSecimMaxKoloni),
            ),
          );
          return;
        }
        _seciliKoloniIdleri.add(koloniId);
      }
    });
  }

  Widget _koloniSecimKarti(Map<String, dynamic> koloni) {
    final koloniId = _toInt(koloni['id']);
    final secili = _seciliKoloniIdleri.contains(koloniId);
    final skor = _toInt(koloni['skor']);
    final sonCita = _toInt(koloni['sonCita']);
    final bal = _toInt(koloni['bal_cita']);
    final kovanNo = (koloni['kovanNo'] ?? '-').toString();

    final renk = _renkSkoraGore(skor);

    return InkWell(
      onTap: () => _secimDegistir(koloniId),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: secili ? Colors.amber.shade700 : Colors.grey.shade300,
            width: secili ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Checkbox(
              value: secili,
              onChanged: (_) => _secimDegistir(koloniId),
              activeColor: Colors.amber,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).karsilastirmaKovanNo(kovanNo),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _miniBilgi(AppLocalizations.of(context).karsilastirmaSecimSkor, '%$skor'),
                      const SizedBox(width: 8),
                      _miniBilgi(AppLocalizations.of(context).karsilastirmaSecimSonCita, sonCita.toString()),
                      const SizedBox(width: 8),
                      _miniBilgi(AppLocalizations.of(context).karsilastirmaSecimBal, bal.toString()),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: renk.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Text(
                '%$skor',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: renk,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniBilgi(String etiket, String deger) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        children: [
          Text(
            etiket,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.blueGrey,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            deger,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Color _renkSkoraGore(int skor) {
    if (skor >= 85) return Colors.purple;
    if (skor >= 70) return Colors.green;
    if (skor >= 50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: Text(widget.baslik),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [AnaSayfaKisayol.aksiyon(context)],
      ),
      body: _yukleniyor
          ? const Center(
        child: CircularProgressIndicator(color: Colors.amber),
      )
          : Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: Text(
              AppLocalizations.of(context).karsilastirmaSecimAciklama,
              style: TextStyle(
                fontSize: 12,
                height: 1.45,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
              children: _koloniler.map(_koloniSecimKarti).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _hesapliyor ? null : _karsilastir,
        backgroundColor: Colors.amber,
        icon: _hesapliyor
            ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.black,
          ),
        )
            : const Icon(Icons.table_chart, color: Colors.black),
        label: Text(
          _hesapliyor ? AppLocalizations.of(context).karsilastirmaSecimBekle : AppLocalizations.of(context).karsilastirmaSecimButon,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class KarsilastirmaliPerformansSayfasi extends StatelessWidget {
  final String baslik;
  final List<_KarsilastirmaKoloniVerisi> veriler;

  const KarsilastirmaliPerformansSayfasi({
    super.key,
    required this.baslik,
    required this.veriler,
  });

  Color _renkSkoraGore(int skor) {
    if (skor >= 85) return Colors.purple;
    if (skor >= 70) return Colors.green;
    if (skor >= 50) return Colors.orange;
    return Colors.red;
  }

  String _yorumSkoraGore(int skor) {
    if (skor >= 85) return 'Üst';
    if (skor >= 70) return 'Güçlü';
    if (skor >= 50) return 'Orta';
    return 'Zayıf';
  }

  int _hamPuaniGetir(_KarsilastirmaKoloniVerisi v, String anahtar) {
    final raw = v.hamProfil[anahtar];
    if (raw == null) return 0;
    if (raw is int) return raw;
    if (raw is double) return raw.round();
    return int.tryParse(raw.toString()) ?? 0;
  }

  String _metinPuaniGetir(_KarsilastirmaKoloniVerisi v, String alan) {
    switch (alan) {
      case 'donor':
        if (v.vetoVarMi) return 'Genetik veto';
        if (v.donorMu) {
          return v.donorSirasi != null ? '#${v.donorSirasi}' : 'Evet';
        }
        return 'Yok';
      case 'genel':
        return '%${v.genelSkor}';
      case 'ureme':
        return '${_hamPuaniGetir(v, "uremePuaniHam")}';
      case 'uretim':
        return '${_hamPuaniGetir(v, "uretimPuaniHam")}';
      case 'dayaniklilik':
        return '${_hamPuaniGetir(v, "dayaniklilikPuaniHam")}';
      case 'hat':
        return '${_hamPuaniGetir(v, "soyPuaniHam")}';
      case 'davranis':
        return '${_hamPuaniGetir(v, "davranisPuaniHam")}';
      case 'veri':
        return '${_hamPuaniGetir(v, "veriGuveniPuaniHam")}';
      case 'kis':
        final yorum = (v.hamProfil['kisCikisYorum'] ?? '-').toString();
        return yorum;
      case 'ogul':
        if (v.vetoVarMi) {
          final neden = (v.vetoNedeni ?? '').toLowerCase();
          if (neden.contains('atasal')) return 'Ata izi';
          if (neden.contains('kendi geçmişinde')) return 'Kendi oğulu';
          if (neden.contains('oğul kökenli')) return 'Oğul kökenli';
          return 'Veto';
        }
        return 'Temiz';
      default:
        return '-';
    }
  }

  List<String> _nedenMetinleri() {
    final List<String> sonuc = [];

    for (int i = 0; i < veriler.length; i++) {
      final v = veriler[i];
      final sira = i + 1;
      final List<String> nedenler = [];

      if (!v.vetoVarMi && v.donorMu && v.donorSirasi != null) {
        nedenler.add('temiz donör havuzunda ${v.donorSirasi}. sırada');
      } else if (v.vetoVarMi) {
        nedenler.add('genetik seçilimde veto alıyor');
      } else {
        nedenler.add('temiz donör havuzunda ama ilk sırada görünmüyor');
      }

      if (v.donorSkoru > 0) {
        nedenler.add('donör skoru ${v.donorSkoru}');
      }

      nedenler.add('genel performans skoru ${v.genelSkor}');
      nedenler.add('seçilim durumu "${v.secilimBaslik}"');

      if ((v.hamProfil['kisCikisVeriYeterliMi'] ?? false) == true) {
        final kisYorum = (v.hamProfil['kisCikisYorum'] ?? '').toString();
        if (kisYorum.trim().isNotEmpty) {
          nedenler.add('kış çıkışı "$kisYorum"');
        }
      }

      sonuc.add(
        '$sira. sırada Kovan ${v.kovanNo}: ${nedenler.join(', ')}.',
      );
    }

    return sonuc;
  }

  Widget _hucre(String metin, {Color? renk, bool vurgu = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: renk?.withOpacity(0.08) ?? Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        metin,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: vurgu ? 12 : 11,
          fontWeight: vurgu ? FontWeight.w900 : FontWeight.w700,
          color: Colors.black87,
          height: 1.25,
        ),
      ),
    );
  }

  Widget _satir(String etiket, String alan) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(width: 110, child: _hucre(etiket, vurgu: true)),
        ...veriler.map((v) {
          final Color renk;
          if (alan == 'donor' && v.vetoVarMi) {
            renk = Colors.red;
          } else if (alan == 'genel') {
            renk = _renkSkoraGore(v.genelSkor);
          } else if (alan == 'ogul' && _metinPuaniGetir(v, alan) == 'Temiz') {
            renk = Colors.green;
          } else {
            final ham = alan == 'genel'
                ? v.genelSkor
                : alan == 'kis'
                ? 50
                : _hamPuaniGetir(
              v,
              alan == 'hat'
                  ? 'soyPuaniHam'
                  : alan == 'veri'
                  ? 'veriGuveniPuaniHam'
                  : '${alan}PuaniHam',
            );
            renk = _renkSkoraGore(
              alan == 'genel'
                  ? ham
                  : (ham >= 85
                  ? 85
                  : ham >= 70
                  ? 70
                  : ham >= 50
                  ? 50
                  : 40),
            );
          }
          return Expanded(
            child: _hucre(_metinPuaniGetir(v, alan), renk: renk),
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final nedenler = _nedenMetinleri();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).karsilastirmaPerformansBaslik),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [AnaSayfaKisayol.aksiyon(context)],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: Text(
              baslik,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Colors.brown,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 110, child: _hucre(AppLocalizations.of(context).karsilastirmaKriter, vurgu: true)),
                      ...veriler.map(
                            (v) => Expanded(
                          child: SizedBox(
                            width: 120,
                            child: _hucre(
                              AppLocalizations.of(context).karsilastirmaKovanNo(v.kovanNo),
                              renk: _renkSkoraGore(v.genelSkor),
                              vurgu: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  _satir(AppLocalizations.of(context).karsilastirmaDonorDurumu, 'donor'),
                  _satir(AppLocalizations.of(context).karsilastirmaBiyoloji, 'genel'),
                  _satir(AppLocalizations.of(context).karsilastirmaUreme, 'ureme'),
                  _satir(AppLocalizations.of(context).karsilastirmaUretim, 'uretim'),
                  _satir(AppLocalizations.of(context).karsilastirmaDayaniklilik, 'dayaniklilik'),
                  _satir(AppLocalizations.of(context).karsilastirmaKisCikisi, 'kis'),
                  _satir(AppLocalizations.of(context).karsilastirmaHatGucu, 'hat'),
                  _satir(AppLocalizations.of(context).karsilastirmaDavranis, 'davranis'),
                  _satir(AppLocalizations.of(context).karsilastirmaVeriGuveni, 'veri'),
                  _satir(AppLocalizations.of(context).karsilastirmaOgulDurumu, 'ogul'),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).karsilastirmaSistemYorumuPerf,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 10),
                ...nedenler.map(
                      (m) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      m,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.45,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KarsilastirmaKoloniVerisi {
  final int koloniId;
  final String kovanNo;
  final int genelSkor;
  final int donorSkoru;
  final bool donorMu;
  final int? donorSirasi;
  final bool vetoVarMi;
  final String? vetoNedeni;
  final String secilimBaslik;
  final String kararBaslik;
  final Map<String, dynamic> hamProfil;

  _KarsilastirmaKoloniVerisi({
    required this.koloniId,
    required this.kovanNo,
    required this.genelSkor,
    required this.donorSkoru,
    required this.donorMu,
    required this.donorSirasi,
    required this.vetoVarMi,
    required this.vetoNedeni,
    required this.secilimBaslik,
    required this.kararBaslik,
    required this.hamProfil,
  });
}
