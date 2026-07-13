import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';

import '../gen_l10n/app_localizations.dart';
import '../services/premium_servisi.dart';

enum _AbonelikTipi { aylik, yillik }

class ProYukselmeSayfasi extends StatefulWidget {
  const ProYukselmeSayfasi({super.key});

  @override
  State<ProYukselmeSayfasi> createState() => _ProYukselmeSayfasiState();
}

class _ProYukselmeSayfasiState extends State<ProYukselmeSayfasi> {
  _AbonelikTipi _secili = _AbonelikTipi.yillik;

  bool _urunlerYukleniyor = true;
  bool _urunYuklemeHatasi = false;
  Map<String, ProductDetails> _urunler = {};

  bool _islemSuruyor = false;

  StreamSubscription<List<PurchaseDetails>>? _satinAlmaDinleyici;

  @override
  void initState() {
    super.initState();
    _urunleriYukle();
    _satinAlmaDinleyici =
        PremiumServisi.satinAlmaAkisi.listen(_satinAlmaGuncelle);
    PremiumServisi.isProNotifier.addListener(_proDurumuDegisti);
  }

  @override
  void dispose() {
    _satinAlmaDinleyici?.cancel();
    PremiumServisi.isProNotifier.removeListener(_proDurumuDegisti);
    super.dispose();
  }

  void _proDurumuDegisti() {
    if (mounted) setState(() {});
  }

  List<String> _ozellikler(AppLocalizations l) => [
    l.proOzellik1,
    l.proOzellik2,
    l.proOzellik3,
    l.proOzellik4,
    l.proOzellik5,
    l.proOzellik6,
    l.proOzellik7,
    l.proOzellik8,
    l.proOzellik9,
  ];

  Future<void> _urunleriYukle() async {
    setState(() {
      _urunlerYukleniyor = true;
      _urunYuklemeHatasi = false;
    });
    final liste = await PremiumServisi.urunleriGetir();
    if (!mounted) return;
    if (liste.isEmpty) {
      setState(() {
        _urunlerYukleniyor = false;
        _urunYuklemeHatasi = true;
      });
      return;
    }
    setState(() {
      _urunler = {for (final u in liste) u.id: u};
      _urunlerYukleniyor = false;
    });
  }

  void _satinAlmaGuncelle(List<PurchaseDetails> satinAlmalar) {
    if (!mounted) return;
    final l = AppLocalizations.of(context);
    for (final s in satinAlmalar) {
      if (!PremiumServisi.urunIdleri.contains(s.productID)) continue;
      switch (s.status) {
        case PurchaseStatus.pending:
          setState(() => _islemSuruyor = true);
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          setState(() => _islemSuruyor = false);
          break;
        case PurchaseStatus.error:
          setState(() => _islemSuruyor = false);
          _mesajGoster(
            l.proYukselmeSatinAlmaHatasi(s.error?.message ?? ''),
          );
          break;
        case PurchaseStatus.canceled:
          setState(() => _islemSuruyor = false);
          _mesajGoster(l.proYukselmeSatinAlmaIptal);
          break;
      }
    }
  }

  void _mesajGoster(String mesaj) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mesaj)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          child: Column(
            children: [
              _baslik(l),
              const SizedBox(height: 24),
              _ozelliklerKarti(l),
              const SizedBox(height: 20),
              if (PremiumServisi.isPro)
                _mevcutPlanKarti(l)
              else
                _urunAlani(l),
              const SizedBox(height: 24),
              _altBilgi(l),
            ],
          ),
        ),
      ),
    );
  }

  Widget _baslik(AppLocalizations l) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFFB300), width: 1.5),
          ),
          child: const Icon(
            Icons.workspace_premium_rounded,
            color: Color(0xFFFFA000),
            size: 40,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          l.proYukselmeSayfaBaslik,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l.proYukselmeSayfaAltBaslik,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.brown.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _ozelliklerKarti(AppLocalizations l) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        children: _ozellikler(l)
            .map(
              (o) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF7B9B6B),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        o,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _mevcutPlanKarti(AppLocalizations l) {
    final urunId = PremiumServisi.aktifUrunId;
    final planAdi = urunId == PremiumServisi.yillikId
        ? l.proYukselmeYillik
        : urunId == PremiumServisi.aylikId
            ? l.proYukselmeAylik
            : null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFB300), width: 1.5),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.workspace_premium_rounded,
            color: Color(0xFFFFA000),
            size: 34,
          ),
          const SizedBox(height: 10),
          Text(
            l.proYukselmeZatenProBaslik,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          if (planAdi != null) ...[
            const SizedBox(height: 6),
            Text(
              '${l.proYukselmeMevcutPlaniniz}: $planAdi',
              style: TextStyle(
                fontSize: 13,
                color: Colors.brown.shade600,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          if (urunId != null) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _abonelikYonet(urunId),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.brown,
                side: const BorderSide(color: Color(0xFFFFB300)),
              ),
              icon: const Icon(Icons.settings_outlined, size: 18),
              label: Text(l.proYukselmeAbonelikYonet),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _abonelikYonet(String urunId) async {
    final uri = Uri.parse(
      'https://play.google.com/store/account/subscriptions'
      '?sku=$urunId&package=com.itogaciftligi.itogena',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _urunAlani(AppLocalizations l) {
    if (_urunlerYukleniyor) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Column(
          children: [
            const CircularProgressIndicator(color: Color(0xFFFFB300)),
            const SizedBox(height: 12),
            Text(
              l.proYukselmeUrunlerYukleniyor,
              style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    if (_urunYuklemeHatasi) {
      return Column(
        children: [
          Text(
            l.proYukselmeUrunYuklemeHatasi,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _urunleriYukle,
            style: OutlinedButton.styleFrom(foregroundColor: Colors.brown),
            child: Text(l.proYukselmeTekrarDene),
          ),
        ],
      );
    }

    final yillik = _urunler[PremiumServisi.yillikId];
    final aylik = _urunler[PremiumServisi.aylikId];

    return Column(
      children: [
        if (yillik != null) _yillikKart(l, yillik),
        if (yillik != null && aylik != null) const SizedBox(height: 10),
        if (aylik != null) _aylikKart(l, aylik),
        const SizedBox(height: 24),
        _aboneOlButonu(l),
      ],
    );
  }

  Widget _yillikKart(AppLocalizations l, ProductDetails urun) {
    final secili = _secili == _AbonelikTipi.yillik;
    final aylikKarsiligi = urun.rawPrice / 12;
    final karsilikMetni =
        '≈ ${urun.currencySymbol}${aylikKarsiligi.toStringAsFixed(2)}/ay';

    return GestureDetector(
      onTap: () => setState(() => _secili = _AbonelikTipi.yillik),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: secili ? const Color(0xFFFFF8E1) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: secili ? const Color(0xFFFFB300) : Colors.grey.shade300,
            width: secili ? 2 : 1,
          ),
          boxShadow: secili
              ? [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              secili
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: secili ? const Color(0xFFFFB300) : Colors.grey.shade400,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        l.proYukselmeYillik,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB300),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          l.proYukselmeYillikEnAvantajli,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    karsilikMetni,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  urun.price,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  l.proYukselmeTasarruf,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF7B9B6B),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _aylikKart(AppLocalizations l, ProductDetails urun) {
    final secili = _secili == _AbonelikTipi.aylik;
    return GestureDetector(
      onTap: () => setState(() => _secili = _AbonelikTipi.aylik),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: secili ? const Color(0xFFFFF8E1) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: secili ? const Color(0xFFFFB300) : Colors.grey.shade300,
            width: secili ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              secili
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: secili ? const Color(0xFFFFB300) : Colors.grey.shade400,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l.proYukselmeAylik,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
            ),
            Text(
              urun.price,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _aboneOlButonu(AppLocalizations l) {
    final urun = _secili == _AbonelikTipi.yillik
        ? _urunler[PremiumServisi.yillikId]
        : _urunler[PremiumServisi.aylikId];

    final etiket = urun == null
        ? ''
        : (_secili == _AbonelikTipi.yillik
            ? '${l.proYukselmeAboneOlYillik} — ${urun.price}'
            : '${l.proYukselmeAboneOlAylik} — ${urun.price}');

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (urun == null || _islemSuruyor) ? null : () => _aboneOl(urun),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFB300),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _islemSuruyor
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                etiket,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
              ),
      ),
    );
  }

  Widget _altBilgi(AppLocalizations l) {
    return Column(
      children: [
        TextButton(
          onPressed: _islemSuruyor ? null : _satinAlimiGeriYukle,
          child: Text(
            l.proYukselmeGeriYukle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.brown,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            l.proYukselmeOtomatikYenileme,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _aboneOl(ProductDetails urun) async {
    setState(() => _islemSuruyor = true);
    final basladi = await PremiumServisi.satinaAlBaslat(urun.id);
    if (!basladi && mounted) {
      setState(() => _islemSuruyor = false);
      _mesajGoster(AppLocalizations.of(context).proYukselmeUrunYuklemeHatasi);
    }
    // Sonuç (purchased/error/canceled) purchaseStream üzerinden _satinAlmaGuncelle'a gelir.
  }

  Future<void> _satinAlimiGeriYukle() async {
    final l = AppLocalizations.of(context);
    final oncekiPro = PremiumServisi.isPro;
    setState(() => _islemSuruyor = true);
    await PremiumServisi.geriYukle();
    // restorePurchases() isteği yollar; sonuçlar purchaseStream'e asenkron düşer.
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _islemSuruyor = false);
    if (PremiumServisi.isPro && !oncekiPro) {
      _mesajGoster(l.proYukselmeGeriYuklemeBasarili);
    } else if (!PremiumServisi.isPro) {
      _mesajGoster(l.proYukselmeGeriYuklemeBulunamadi);
    }
  }
}
