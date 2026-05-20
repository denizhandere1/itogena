import 'package:flutter/material.dart';

import 'ana_sayfa_kisayol.dart';
import '../services/rapor_siralama_servisi.dart';
import 'koloni_detay_sayfasi.dart';

class RaporListesiSayfasi extends StatefulWidget {
  final String raporTipi;
  final String baslik;
  final int arilikId;
  final String arilikAd;

  const RaporListesiSayfasi({
    super.key,
    required this.raporTipi,
    required this.baslik,
    required this.arilikId,
    required this.arilikAd,
  });

  @override
  State<RaporListesiSayfasi> createState() => _RaporListesiSayfasiState();
}

class _RaporListesiSayfasiState extends State<RaporListesiSayfasi> {
  late Future<List<RaporListeKaydi>> _future;

  @override
  void initState() {
    super.initState();
    _future = RaporSiralamaServisi.listeGetir(
      widget.raporTipi,
      arilikId: widget.arilikId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: Text(
          '${widget.baslik} - ${widget.arilikAd}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [AnaSayfaKisayol.aksiyon(context)],
      ),
      body: FutureBuilder<List<RaporListeKaydi>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Rapor listesi üretilemedi:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            );
          }

          final liste = snapshot.data ?? const <RaporListeKaydi>[];
          if (liste.isEmpty) {
            return const Center(
              child: Text(
                'Bu listede gösterilecek aktif koloni bulunamadı.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            children: [
              _ustBilgiKutusu(liste.length),
              const SizedBox(height: 12),
              _tabloBaslikSatiri(),
              const SizedBox(height: 8),
              ...liste.map(_satirKarti),
            ],
          );
        },
      ),
    );
  }

  Widget _ustBilgiKutusu(int adet) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Text(
        'Bu liste ${widget.arilikAd} arılığındaki aktif kolonilerden üretilir. Sıralama ana eksende skora göre yapılır. Eşitlikte önce üreme, sonra üretim, sonra donörlük öne çıkar. Toplam $adet kayıt var.',
        style: const TextStyle(
          fontSize: 12,
          height: 1.45,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _tabloBaslikSatiri() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.brown.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.brown.shade100),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 52,
            child: Text(
              'SIRA',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              'KOLONİ NO',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
            ),
          ),
          SizedBox(
            width: 124,
            child: Text(
              'DURUM',
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _satirKarti(RaporListeKaydi kayit) {
    final renk = _durumRengi(kayit.durumKodu);
    final kovanNo = (kayit.koloni['kovanNo'] ?? '-').toString();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => KoloniDetaySayfasi(koloni: kayit.koloni),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: renk.withOpacity(0.28)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 52,
              child: Text(
                '${kayit.sira}.',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kovanNo,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Skor ${kayit.genelSkor}  •  ${kayit.sonCita} çıta',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 124,
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: renk.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: renk.withOpacity(0.25)),
                  ),
                  child: Text(
                    kayit.durumMetni,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: renk,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _durumRengi(String kod) {
    switch (kod) {
      case 'donor':
        return Colors.purple;
      case 'veto':
        return Colors.red;
      case 'cok_zayif':
        return Colors.red;
      case 'gelismekte':
        return Colors.orange;
      case 'uretim':
        return Colors.blueGrey;
      case 'guclu':
        return Colors.green;
      case 'cok_guclu':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}
