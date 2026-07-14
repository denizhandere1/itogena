
import 'package:flutter/material.dart';
import 'package:itogena_v45/gen_l10n/app_localizations.dart';
import 'ana_sayfa_kisayol.dart';
import '../services/premium_servisi.dart';
import '../services/soy_servisi.dart';
import '../widgets/pro_kapit.dart';
import 'koloni_detay_sayfasi.dart';

class SoyAgaciSayfasi extends StatefulWidget {
  const SoyAgaciSayfasi({super.key});

  @override
  State<SoyAgaciSayfasi> createState() => _SoyAgaciSayfasiState();
}

class _SoyAgaciSayfasiState extends State<SoyAgaciSayfasi>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    PremiumServisi.isProNotifier.addListener(_proGuncelle);
  }

  void _proGuncelle() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    PremiumServisi.isProNotifier.removeListener(_proGuncelle);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!PremiumServisi.isPro) return const ProSayfaKapit(child: SizedBox.shrink());
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).soyAgaciBaslik,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [AnaSayfaKisayol.aksiyon(context)],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          indicatorColor: Colors.brown,
          tabs: [
            Tab(text: AppLocalizations.of(context).soyAgaciBasitHat),
            Tab(text: AppLocalizations.of(context).soyAgaciDetayli),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: SoyServisi.soyAgaciniOlustur(),
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
                    AppLocalizations.of(context).soyAgaciHata(snapshot.error.toString()),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.red,
                      height: 1.4,
                    ),
                  ),
                ),
              );
            }

            final hamVeri = snapshot.data ?? [];
            final veri = _yasayanHatlariFiltrele(hamVeri);

            if (veri.isEmpty) {
              return Center(
                child: Text(
                  AppLocalizations.of(context).soyAgaciBulunamadi,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }

            return TabBarView(
              controller: _tabController,
              children: [
                _basitHatGorunumu(veri),
                _detayliGorunum(veri),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _basitHatGorunumu(List<Map<String, dynamic>> veri) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 110),
      children: [
        _ustAciklamaKutusu(
          AppLocalizations.of(context).soyAgaciBasitAciklama,
        ),
        const SizedBox(height: 12),
        ...veri.map((kok) => _basitHatBloku(kok, context)).toList(),
      ],
    );
  }

  Widget _detayliGorunum(List<Map<String, dynamic>> veri) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 96),
      itemCount: veri.length,
      itemBuilder: (context, index) {
        return _soyDali(
          context,
          veri[index],
          derinlik: 0,
        );
      },
    );
  }

  Widget _ustAciklamaKutusu(String metin) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Text(
        metin,
        style: const TextStyle(
          fontSize: 13,
          height: 1.45,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _basitHatBloku(Map<String, dynamic> kok, BuildContext context) {
    final satirlar = <_HatSatiri>[];
    _satirlariDoldur(kok, satirlar, derinlik: 0, context: context);

    final toplam = _toplamKoloniSayisi(kok);
    final aktif = _aktifKoloniSayisi(kok);
    final pasif = toplam - aktif;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
            AppLocalizations.of(context).soyAgaciHatOzeti,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Colors.brown.shade700,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ozetChip(AppLocalizations.of(context).soyAgaciToplam(toplam)),
              _ozetChip(AppLocalizations.of(context).soyAgaciAktif(aktif)),
              _ozetChip(AppLocalizations.of(context).soyAgaciPasif(pasif)),
            ],
          ),
          const SizedBox(height: 12),
          ...satirlar.map(_hatSatiriWidget),
        ],
      ),
    );
  }

  Widget _ozetChip(String metin) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Text(
        metin,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _hatSatiriWidget(_HatSatiri satir) {
    return Padding(
      padding: EdgeInsets.only(left: satir.derinlik * 18.0, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (satir.derinlik > 0) ...[
            const Text(
              '└─ ',
              style: TextStyle(
                fontSize: 16,
                height: 1.3,
                color: Colors.black87,
              ),
            ),
          ],
          Expanded(
            child: Text(
              satir.metin,
              style: TextStyle(
                fontSize: satir.derinlik == 0 ? 16 : 15,
                height: 1.4,
                fontWeight: satir.derinlik == 0
                    ? FontWeight.w900
                    : FontWeight.w500,
                color: satir.aktifMi ? Colors.black87 : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _satirlariDoldur(
      Map<String, dynamic> koloni,
      List<_HatSatiri> satirlar, {
        required int derinlik,
        required BuildContext context,
      }) {
    final aktifMi = koloni['aktifMi'] == true;
    final cocuklar =
        (koloni['cocuklar'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    satirlar.add(
      _HatSatiri(
        derinlik: derinlik,
        aktifMi: aktifMi,
        metin: _basitSatirMetni(koloni, derinlik: derinlik, context: context),
      ),
    );

    for (final cocuk in cocuklar) {
      _satirlariDoldur(cocuk, satirlar, derinlik: derinlik + 1, context: context);
    }
  }

  String _basitSatirMetni(Map<String, dynamic> koloni, {required int derinlik, required BuildContext context}) {
    final l10n = AppLocalizations.of(context);
    final aktifMi = koloni['aktifMi'] == true;
    final kovanNo = _metin(koloni['kovanNo']);
    final anaYili = _metin(koloni['anaYili'], varsayilan: '');
    final durum = aktifMi ? l10n.soyAgaciAktifDurum : l10n.soyAgaciPasifDurum;

    if (anaYili.isNotEmpty) {
      return l10n.soyAgaciKovanAnaYilDurum(kovanNo, anaYili, durum);
    }
    return l10n.soyAgaciKovanDurum(kovanNo, durum);
  }

  List<Map<String, dynamic>> _yasayanHatlariFiltrele(
      List<Map<String, dynamic>> veri,
      ) {
    final sonuc = <Map<String, dynamic>>[];

    for (final kok in veri) {
      final temiz = _yalnizcaYasayanHatDali(kok);
      if (temiz != null) {
        sonuc.add(temiz);
      }
    }

    sonuc.sort(_koloniSirala);
    return sonuc;
  }

  Map<String, dynamic>? _yalnizcaYasayanHatDali(Map<String, dynamic> koloni) {
    final aktifMi = koloni['aktifMi'] == true;
    final cocuklar =
        (koloni['cocuklar'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    final yeniCocuklar = <Map<String, dynamic>>[];
    for (final cocuk in cocuklar) {
      final temiz = _yalnizcaYasayanHatDali(cocuk);
      if (temiz != null) {
        yeniCocuklar.add(temiz);
      }
    }

    final daldaAktifVar = aktifMi || yeniCocuklar.isNotEmpty;
    if (!daldaAktifVar) return null;

    final sonuc = Map<String, dynamic>.from(koloni);
    sonuc['cocuklar'] = yeniCocuklar;
    return sonuc;
  }

  int _toplamKoloniSayisi(Map<String, dynamic> koloni) {
    final cocuklar =
        (koloni['cocuklar'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    int toplam = 1;
    for (final cocuk in cocuklar) {
      toplam += _toplamKoloniSayisi(cocuk);
    }
    return toplam;
  }

  int _aktifKoloniSayisi(Map<String, dynamic> koloni) {
    final aktifMi = koloni['aktifMi'] == true;
    final cocuklar =
        (koloni['cocuklar'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    int toplam = aktifMi ? 1 : 0;
    for (final cocuk in cocuklar) {
      toplam += _aktifKoloniSayisi(cocuk);
    }
    return toplam;
  }

  Widget _soyDali(
      BuildContext context,
      Map<String, dynamic> koloni, {
        required int derinlik,
      }) {
    final cocuklar =
        (koloni['cocuklar'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    final skor = _toInt(koloni['skor']);
    final sonCita = _toInt(koloni['sonCita']);
    final maxCita = _toInt(koloni['maxCitaKapasiye']);
    final balCita = _toInt(koloni['bal_cita']);
    final kovanNo = _metin(koloni['kovanNo']);
    final ilkKovanNo = _metin(koloni['ilkKovanNo'], varsayilan: '-');
    final anaYili = _metin(koloni['anaYili']);
    final kaynakTipi = _metin(koloni['kaynakTipi'], varsayilan: AppLocalizations.of(context).soyAgaciBilinmiyor);
    final sistemKimlik = _metin(koloni['sistemKimlik'], varsayilan: '-');
    final aktifMi = koloni['aktifMi'] == true;
    final cocukSayisi = cocuklar.length;

    final Color vurguRenk = !aktifMi
        ? Colors.grey
        : (skor >= 85
        ? Colors.purple
        : skor >= 70
        ? Colors.green
        : skor >= 50
        ? Colors.orange
        : Colors.red);

    final IconData ikon = derinlik == 0
        ? Icons.account_tree_outlined
        : Icons.subdirectory_arrow_right;

    return Padding(
      padding: EdgeInsets.only(left: derinlik * 18.0, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: vurguRenk.withOpacity(0.30)),
          boxShadow: [
            BoxShadow(
              color: vurguRenk.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            leading: Icon(ikon, color: vurguRenk),
            title: Text(
              AppLocalizations.of(context).soyAgaciKovanNo(kovanNo),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                AppLocalizations.of(context).soyAgaciKaynakAnaYil(kaynakTipi, anaYili),
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  color: Colors.black54,
                ),
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: vurguRenk.withOpacity(0.10),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: vurguRenk.withOpacity(0.22)),
              ),
              child: Text(
                aktifMi ? '%$skor' : AppLocalizations.of(context).soyAgaciPasifBadge,
                style: TextStyle(
                  color: vurguRenk,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _miniBilgiKutusu(
                    ikon: Icons.view_week_outlined,
                    etiket: AppLocalizations.of(context).soyAgaciSonCita,
                    deger: sonCita.toString(),
                    renk: Colors.green,
                  ),
                  _miniBilgiKutusu(
                    ikon: Icons.stacked_bar_chart_outlined,
                    etiket: AppLocalizations.of(context).soyAgaciMaxCita,
                    deger: maxCita.toString(),
                    renk: Colors.purple,
                  ),
                  _miniBilgiKutusu(
                    ikon: Icons.inventory_2_outlined,
                    etiket: AppLocalizations.of(context).soyAgaciBalCitasi,
                    deger: balCita.toString(),
                    renk: Colors.orange,
                  ),
                  _miniBilgiKutusu(
                    ikon: Icons.hub_outlined,
                    etiket: AppLocalizations.of(context).soyAgaciTureyenEtiket,
                    deger: cocukSayisi.toString(),
                    renk: Colors.blueGrey,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _bilgiSatiri(AppLocalizations.of(context).soyAgaciIlkSahaEtiketi, ilkKovanNo),
              _bilgiSatiri(AppLocalizations.of(context).soyAgaciSistemKimlik, sistemKimlik),
              _bilgiSatiri(AppLocalizations.of(context).soyAgaciDurumEtiket, aktifMi ? AppLocalizations.of(context).soyAgaciAktifMetin : AppLocalizations.of(context).soyAgaciPasifMetin),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: Colors.amber.shade400),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KoloniDetaySayfasi(koloni: koloni),
                      ),
                    );
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: Text(AppLocalizations.of(context).soyAgaciKoloniAnalizineGit),
                ),
              ),
              if (cocuklar.isNotEmpty) ...[
                const SizedBox(height: 10),
                const Divider(height: 18),
                ...cocuklar.map(
                      (cocuk) => _soyDali(
                    context,
                    cocuk,
                    derinlik: derinlik + 1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniBilgiKutusu({
    required IconData ikon,
    required String etiket,
    required String deger,
    required Color renk,
  }) {
    return Container(
      width: 104,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: renk.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: renk.withOpacity(0.20)),
      ),
      child: Column(
        children: [
          Icon(ikon, color: renk, size: 18),
          const SizedBox(height: 6),
          Text(
            deger,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: renk,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            etiket,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bilgiSatiri(String etiket, String deger) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              etiket,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.brown,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              deger,
              style: const TextStyle(
                fontSize: 12,
                height: 1.35,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _metin(dynamic v, {String varsayilan = '-'}) {
    if (v == null) return varsayilan;
    final s = v.toString().trim();
    if (s.isEmpty) return varsayilan;
    return s;
  }

  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }

  int _koloniSirala(Map<String, dynamic> a, Map<String, dynamic> b) {
    final aAktif = a['aktifMi'] == true;
    final bAktif = b['aktifMi'] == true;
    if (aAktif != bAktif) return aAktif ? -1 : 1;

    final aSira = _toInt(a['sahaSirasi']);
    final bSira = _toInt(b['sahaSirasi']);
    if (aSira != bSira) return aSira.compareTo(bSira);

    final aNo = (a['kovanNo'] ?? '').toString();
    final bNo = (b['kovanNo'] ?? '').toString();
    return aNo.compareTo(bNo);
  }
}

class _HatSatiri {
  final int derinlik;
  final bool aktifMi;
  final String metin;

  const _HatSatiri({
    required this.derinlik,
    required this.aktifMi,
    required this.metin,
  });
}
