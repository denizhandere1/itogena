import 'package:flutter/material.dart';
import '../gen_l10n/app_localizations.dart';

enum _AbonelikTipi { aylik, yillik }

class ProYukselmeSayfasi extends StatefulWidget {
  const ProYukselmeSayfasi({super.key});

  @override
  State<ProYukselmeSayfasi> createState() => _ProYukselmeSayfasiState();
}

class _ProYukselmeSayfasiState extends State<ProYukselmeSayfasi> {
  _AbonelikTipi _secili = _AbonelikTipi.yillik;

  // TODO: in_app_purchase entegrasyonunda ProductDetails.price ile değiştirilecek
  static const String _yillikFiyat = '₺890/yıl';
  static const String _yillikAylikKarsiligi = '≈ ₺74,17/ay';
  static const String _aylikFiyat = '₺89/ay';
  static const String _tasarrufYuzde = '%17 tasarruf';

  static const List<String> _ozellikler = [
    'Sınırsız koloni (ücretsiz: 10)',
    'Biyolojik model — tam analiz',
    'Hasat projeksiyonu',
    'Performans raporları',
    'Hat analizi',
    'Koloni karşılaştırma',
    'Soy ağacı',
    'Çoklu arılık yönetimi',
  ];

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
              _baslik(),
              const SizedBox(height: 24),
              _ozelliklerKarti(),
              const SizedBox(height: 20),
              _yillikKart(),
              const SizedBox(height: 10),
              _aylikKart(),
              const SizedBox(height: 24),
              _aboneOlButonu(l),
              const SizedBox(height: 12),
              _altBilgi(l),
            ],
          ),
        ),
      ),
    );
  }

  Widget _baslik() {
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
        const Text(
          'İtogena PRO',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Arılıklarınızı sınırsız büyütün',
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

  Widget _ozelliklerKarti() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        children: _ozellikler
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

  Widget _yillikKart() {
    final secili = _secili == _AbonelikTipi.yillik;
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
                      const Text(
                        'Yıllık',
                        style: TextStyle(
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
                        child: const Text(
                          'En Avantajlı',
                          style: TextStyle(
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
                    _yillikAylikKarsiligi,
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
                  _yillikFiyat,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  _tasarrufYuzde,
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

  Widget _aylikKart() {
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
            const Expanded(
              child: Text(
                'Aylık',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
            ),
            Text(
              _aylikFiyat,
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
    final etiket = _secili == _AbonelikTipi.yillik
        ? 'Yıllık Abone Ol — $_yillikFiyat'
        : 'Aylık Abone Ol — $_aylikFiyat';

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _aboneOl,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFB300),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
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
          onPressed: _satinAlimiGeriYukle,
          child: const Text(
            'Satın Alımı Geri Yükle',
            style: TextStyle(
              fontSize: 12,
              color: Colors.brown,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Abonelik otomatik olarak yenilenir. İstediğiniz zaman Play Store\'dan iptal edebilirsiniz.',
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

  void _aboneOl() {
    // TODO: in_app_purchase entegrasyonu — bu blok değiştirilecek
    // _secili == _AbonelikTipi.yillik
    //   ? IapServisi.satin_al(yillikProductId)
    //   : IapServisi.satin_al(aylikProductId);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.workspace_premium_outlined, color: Color(0xFFFFA000)),
            SizedBox(width: 8),
            Text('İtogena PRO'),
          ],
        ),
        content: const Text(
          'PRO abonelik yakında kullanıma girecek.\n\nBeta sürecinde tüm özellikler açık tutulmaktadır.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).kapat),
          ),
        ],
      ),
    );
  }

  void _satinAlimiGeriYukle() {
    // TODO: in_app_purchase.restorePurchases()
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Satın alım geri yükleme yakında kullanıma girecek.'),
      ),
    );
  }
}
