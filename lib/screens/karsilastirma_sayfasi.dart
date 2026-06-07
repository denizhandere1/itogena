
import 'package:flutter/material.dart';
import 'package:itogena_v45/gen_l10n/app_localizations.dart';
import 'ana_sayfa_kisayol.dart';
import '../services/karsilastirma_ozeti_servisi.dart';
import '../utils/servis_metin_lokalizer.dart';
import '../services/premium_servisi.dart';
import '../widgets/pro_kapit.dart';

class KarsilastirmaSayfasi extends StatefulWidget {
  final List<int> koloniIdleri;

  const KarsilastirmaSayfasi({
    super.key,
    required this.koloniIdleri,
  });

  @override
  State<KarsilastirmaSayfasi> createState() => _KarsilastirmaSayfasiState();
}

class _KarsilastirmaSayfasiState extends State<KarsilastirmaSayfasi> {
  late Future<KarsilastirmaSonucu> _future;

  @override
  void initState() {
    super.initState();
    _future = KarsilastirmaOzetiServisi.getir(widget.koloniIdleri);
  }

  @override
  Widget build(BuildContext context) {
    if (!PremiumServisi.isPro) return const ProSayfaKapit(child: SizedBox.shrink());
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).karsilastirmaBaslik,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [AnaSayfaKisayol.aksiyon(context)],
      ),
      body: FutureBuilder<KarsilastirmaSonucu>(
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
                  AppLocalizations.of(context).karsilastirmaHata(snapshot.error.toString()),
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

          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.koloniler.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context).karsilastirmaKoloniBulunamadi,
                style: const TextStyle(fontSize: 14),
              ),
            );
          }

          final veri = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              _ustBilgiKutusu(),
              _koloniKartlari(veri),
              _karsilastirmaTablosu(veri),
              _sistemYorumuKutusu(veri),
            ],
          );
        },
      ),
    );
  }

  Widget _ustBilgiKutusu() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Text(
        AppLocalizations.of(context).karsilastirmaAciklama,
        style: TextStyle(
          fontSize: 12,
          height: 1.45,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _koloniKartlari(KarsilastirmaSonucu veri) {
    return Column(
      children: veri.koloniler.map((k) {
        final Color renk = _renkSkordan(k.genelSkor);
        final Color secilimRenk =
        _renkSkordan(k.vetoVarMi ? 10 : (k.donorMu ? 92 : 55));

        return Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: renk.withOpacity(0.22)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: renk.withOpacity(0.12),
                    foregroundColor: renk,
                    child: Text(
                      k.kovanNo,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).karsilastirmaKovanNo(k.kovanNo),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: renk.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      AppLocalizations.of(context).karsilastirmaPerformans(k.genelSkor.toString()),
                      style: TextStyle(
                        color: renk,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _chip(
                    k.vetoVarMi
                        ? (k.vetoOzeti.isEmpty ? AppLocalizations.of(context).karsilastirmaGenetikVeto : k.vetoOzeti)
                        : (k.donorMu
                        ? AppLocalizations.of(context).karsilastirmaTemizDonor((k.donorSirasi ?? '-').toString())
                        : AppLocalizations.of(context).karsilastirmaTemizHavuzda),
                    secilimRenk,
                  ),
                  _chip(k.secilimBaslik, secilimRenk),
                  _chip(k.anaKararBaslik, _renkSkordan(k.genelSkor)),
                  _chip(
                    k.biyolojiBaslik,
                    _renkSkordan(
                      k.biyolojiZamanKritik
                          ? 10
                          : (k.biyolojiAnaUretimineUygun ? 92 : 55),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _bilgiSatiri(AppLocalizations.of(context).karsilastirmaSistemYorumuLabel, k.sistemYorumu),
              const SizedBox(height: 8),
              _bilgiSatiri(AppLocalizations.of(context).karsilastirmaBiyoloji, k.biyolojiMesaji),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _karsilastirmaTablosu(KarsilastirmaSonucu veri) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.table_chart_outlined, color: Colors.brown),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).karsilastirmaTablo,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Colors.brown,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStatePropertyAll(
                Color(0x2DFFC107),
              ),
              dataRowMinHeight: 74,
              dataRowMaxHeight: 90,
              columns: [
                const DataColumn(
                  label: SizedBox(
                    width: 150,
                    child: Text(
                      'Kriter',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ...veri.koloniler.map(
                      (k) => DataColumn(
                    label: SizedBox(
                      width: 130,
                      child: Text(
                        AppLocalizations.of(context).karsilastirmaKovanNo(k.kovanNo),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
              rows: veri.satirlar.map((satir) {
                return DataRow(
                  cells: [
                    DataCell(
                      SizedBox(
                        width: 150,
                        child: Text(
                          ServisMetinLokalizer.cevir(satir.baslik, AppLocalizations.of(context)),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    ...satir.hucreler.map((hucre) {
                      final renk = _renkSkordan(hucre.renkSkoru);
                      return DataCell(
                        SizedBox(
                          width: 130,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: renk.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border:
                              Border.all(color: renk.withOpacity(0.22)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  hucre.deger,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: renk,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  ServisMetinLokalizer.cevir(hucre.yorum, AppLocalizations.of(context)),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    height: 1.2,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sistemYorumuKutusu(KarsilastirmaSonucu veri) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_alt_outlined, color: Colors.brown),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).karsilastirmaSistemYorumu,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Colors.brown,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...veri.sistemYorumu.map(
                (y) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '• $y',
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String metin, Color renk) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: renk.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: renk.withOpacity(0.20)),
      ),
      child: Text(
        metin,
        style: TextStyle(
          color: renk,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _bilgiSatiri(String baslik, String metin) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          baslik,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: Colors.brown,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          metin.isEmpty ? '-' : metin,
          style: const TextStyle(
            fontSize: 12,
            height: 1.35,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Color _renkSkordan(int skor) {
    if (skor >= 85) return Colors.purple;
    if (skor >= 70) return Colors.green;
    if (skor >= 50) return Colors.orange;
    return Colors.red;
  }
}
