import 'package:flutter/material.dart';
import 'package:itogena_v45/gen_l10n/app_localizations.dart';
import 'ana_sayfa_kisayol.dart';
import '../services/hat_analiz_servisi.dart';
import '../utils/servis_metin_lokalizer.dart';
import '../services/premium_servisi.dart';
import '../services/veritabani_servisi.dart';
import '../widgets/pro_kapit.dart';
import 'koloni_detay_sayfasi.dart';

class HatAnalizSayfasi extends StatefulWidget {
  const HatAnalizSayfasi({super.key});

  @override
  State<HatAnalizSayfasi> createState() => _HatAnalizSayfasiState();
}

class _HatAnalizSayfasiState extends State<HatAnalizSayfasi> {
  List<HatAnalizSonucu> _tumSonuclar = [];
  bool _yukleniyor = true;

  String _filtre = 'Tümü';

  @override
  void initState() {
    super.initState();
    PremiumServisi.isProNotifier.addListener(_proGuncelle);
    _verileriYukle();
  }

  void _proGuncelle() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    PremiumServisi.isProNotifier.removeListener(_proGuncelle);
    super.dispose();
  }

  Future<void> _verileriYukle() async {
    setState(() {
      _yukleniyor = true;
    });

    final sonuclar = await HatAnalizServisi.analizleriGetir();

    if (!mounted) return;

    setState(() {
      _tumSonuclar = sonuclar;
      _yukleniyor = false;
    });
  }

  List<HatAnalizSonucu> get _filtreli {
    if (_filtre == 'Tümü') return _tumSonuclar;
    return _tumSonuclar.where((e) => e.karar == _filtre).toList();
  }

  int get _toplamHat => _tumSonuclar.length;

  int _kategoriSayisi(String kategori) {
    return _tumSonuclar.where((e) => e.karar == kategori).length;
  }

  Color _kararRengi(String karar) {
    switch (karar) {
      case 'Donör Hat':
        return Colors.purple;
      case 'Güçlü Üretim Hattı':
        return Colors.green;
      case 'Takip Edilmeli':
        return Colors.orange;
      case 'Riskli Hat':
        return Colors.red;
      case 'Operasyonel Hat':
        return Colors.brown;
      case 'Veri Yetersiz':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  IconData _kararIkonu(String karar) {
    switch (karar) {
      case 'Donör Hat':
        return Icons.workspace_premium;
      case 'Güçlü Üretim Hattı':
        return Icons.verified;
      case 'Takip Edilmeli':
        return Icons.visibility;
      case 'Riskli Hat':
        return Icons.warning_amber_rounded;
      case 'Operasyonel Hat':
        return Icons.build_circle_outlined;
      case 'Veri Yetersiz':
        return Icons.hourglass_bottom;
      default:
        return Icons.analytics_outlined;
    }
  }

  Widget _filtreChip(String etiket) {
    final secili = _filtre == etiket;
    final l = AppLocalizations.of(context);
    final goruntu = etiket == 'Tümü'
        ? l.hatAnalizTumu
        : ServisMetinLokalizer.cevir(etiket, l);
    return ChoiceChip(
      label: Text(
        goruntu,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: secili ? Colors.black : Colors.black87,
        ),
      ),
      selected: secili,
      selectedColor: Colors.amber,
      onSelected: (_) {
        setState(() {
          _filtre = etiket;
        });
      },
    );
  }

  Widget _sayacKutusu(String baslik, int sayi, Color renk) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: renk.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: renk.withOpacity(0.20)),
      ),
      child: Column(
        children: [
          Text(
            sayi.toString(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: renk,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            baslik,
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

  Widget _ustGenelOzet() {
    return Container(
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Text(
                  _toplamHat.toString(),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Bu ekranda yalnızca yaşayan devamı olan hatlar gösterilir. Tamamen kapanmış ve aktif koloni bırakmamış hatlar ana listede yer almaz.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Toplam yaşayan hat sayısı',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _kategoriPaneli() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _sayacKutusu(
                'Donör Hat',
                _kategoriSayisi('Donör Hat'),
                Colors.purple,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _sayacKutusu(
                'Üretim Hattı',
                _kategoriSayisi('Güçlü Üretim Hattı'),
                Colors.green,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _sayacKutusu(
                'Operasyonel',
                _kategoriSayisi('Operasyonel Hat'),
                Colors.brown,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _sayacKutusu(
                'Riskli',
                _kategoriSayisi('Riskli Hat'),
                Colors.red,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _sayacKutusu(
                'Takip',
                _kategoriSayisi('Takip Edilmeli'),
                Colors.orange,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _sayacKutusu(
                'Veri Az',
                _kategoriSayisi('Veri Yetersiz'),
                Colors.blueGrey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _temsilKoloniDetayinaGit(HatAnalizSonucu s) async {
    final acilacakId = s.temsilKoloniId > 0 ? s.temsilKoloniId : s.kokKoloniId;
    final koloni = await VeritabaniServisi.koloniOzetiGetir(acilacakId);
    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => KoloniDetaySayfasi(koloni: koloni),
      ),
    );
  }

  Widget _ozetHucre(String etiket, String deger) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber.shade200),
        ),
        child: Column(
          children: [
            Text(
              deger,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
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
      ),
    );
  }

  Widget _hatKarti(HatAnalizSonucu s) {
    final l = AppLocalizations.of(context);
    final renk = _kararRengi(s.karar);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: renk.withOpacity(0.22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: renk.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(_kararIkonu(s.karar), color: renk),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.kokAktifMi
                          ? AppLocalizations.of(context).hatAnalizAktifHat(s.temsilKovanNo)
                          : AppLocalizations.of(context).hatAnalizAktifTemsilci(s.temsilKovanNo),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s.kokAktifMi
                          ? ServisMetinLokalizer.cevir(s.karar, l)
                          : AppLocalizations.of(context).hatAnalizSonmusDurum(ServisMetinLokalizer.cevir(s.karar, l), s.kokKovanNo),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: renk,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: renk.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  s.hatSkoru.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: renk,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            ServisMetinLokalizer.cevir(s.gerekce, l),
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _ozetHucre(AppLocalizations.of(context).hatAnalizToplam, s.toplamKoloni.toString()),
              const SizedBox(width: 8),
              _ozetHucre(AppLocalizations.of(context).hatAnalizAktif, s.aktifKoloni.toString()),
              const SizedBox(width: 8),
              _ozetHucre(AppLocalizations.of(context).hatAnalizSonmus, s.sonenKoloni.toString()),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _ozetHucre(AppLocalizations.of(context).hatAnalizSonmeOrani, s.sonmeOrani.toStringAsFixed(0)),
              const SizedBox(width: 8),
              _ozetHucre(AppLocalizations.of(context).hatAnalizOrtMaksCita, s.ortalamaMaxCita.toStringAsFixed(1)),
              const SizedBox(width: 8),
              _ozetHucre(AppLocalizations.of(context).hatAnalizOrtBalCita, s.ortalamaBalCita.toStringAsFixed(1)),
            ],
          ),
          if (s.notlar.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              AppLocalizations.of(context).hatAnalizNeden,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 8),
            ...s.notlar.map(
                  (n) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        ServisMetinLokalizer.cevir(n, l),
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.35,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _temsilKoloniDetayinaGit(s),
              icon: const Icon(Icons.open_in_new),
              label: Text(s.kokAktifMi ? AppLocalizations.of(context).hatAnalizAktifHatiAc : AppLocalizations.of(context).hatAnalizAktifTemsilciAc),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!PremiumServisi.isPro) return const ProSayfaKapit(child: SizedBox.shrink());
    final filtreler = <String>[
      'Tümü',
      'Donör Hat',
      'Güçlü Üretim Hattı',
      'Operasyonel Hat',
      'Riskli Hat',
      'Takip Edilmeli',
      'Veri Yetersiz',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).hatAnalizAppBarBaslik),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [AnaSayfaKisayol.aksiyon(context)],
      ),
      body: _yukleniyor
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _verileriYukle,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              AppLocalizations.of(context).hatAnalizSayfaBasligi,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              AppLocalizations.of(context).hatAnalizAciklama,
              style: TextStyle(
                fontSize: 13,
                height: 1.45,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 14),
            _ustGenelOzet(),
            const SizedBox(height: 14),
            _kategoriPaneli(),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).hatAnalizFiltre,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Colors.blueGrey,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: filtreler.map(_filtreChip).toList(),
            ),
            const SizedBox(height: 16),
            if (_filtreli.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context).hatAnalizBos,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              )
            else
              ..._filtreli.map(_hatKarti),
          ],
        ),
      ),
    );
  }
}
