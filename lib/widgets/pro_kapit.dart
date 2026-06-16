import 'package:flutter/material.dart';
import 'package:itogena_v45/gen_l10n/app_localizations.dart';
import 'package:itogena_v45/screens/pro_yukselme_sayfasi.dart';
import 'package:itogena_v45/services/premium_servisi.dart';

// Belirli bir kartı/bölümü kilitler — içeriği soluk gösterir, üstüne kilit overlay'i koyar
class ProKapit extends StatefulWidget {
  final Widget child;

  const ProKapit({super.key, required this.child});

  @override
  State<ProKapit> createState() => _ProKapitState();
}

class _ProKapitState extends State<ProKapit> {
  @override
  void initState() {
    super.initState();
    PremiumServisi.isProNotifier.addListener(_guncelle);
  }

  @override
  void dispose() {
    PremiumServisi.isProNotifier.removeListener(_guncelle);
    super.dispose();
  }

  void _guncelle() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (PremiumServisi.isPro) return widget.child;

    return Stack(
      children: [
        IgnorePointer(
          child: Opacity(opacity: 0.18, child: widget.child),
        ),
        Positioned.fill(
          child: _KilitOverlay(tamEkran: false),
        ),
      ],
    );
  }
}

// Tüm sayfayı kilitler — PRO değilse kendi Scaffold'u ile kilit ekranı gösterir
class ProSayfaKapit extends StatefulWidget {
  final Widget child;

  const ProSayfaKapit({super.key, required this.child});

  @override
  State<ProSayfaKapit> createState() => _ProSayfaKapitState();
}

class _ProSayfaKapitState extends State<ProSayfaKapit> {
  @override
  void initState() {
    super.initState();
    PremiumServisi.isProNotifier.addListener(_guncelle);
  }

  @override
  void dispose() {
    PremiumServisi.isProNotifier.removeListener(_guncelle);
    super.dispose();
  }

  void _guncelle() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (PremiumServisi.isPro) return widget.child;
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const _KilitOverlay(tamEkran: true),
    );
  }
}

class _KilitOverlay extends StatelessWidget {
  final bool tamEkran;

  const _KilitOverlay({required this.tamEkran});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(tamEkran ? 1.0 : 0.88),
        borderRadius: tamEkran ? null : BorderRadius.circular(14),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFFB300), width: 1.5),
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  color: Color(0xFFFFA000),
                  size: 32,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  l10n.proRozeti,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.proOzellik,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _yukseltDialoguGoster(context, l10n),
                  icon: const Icon(Icons.workspace_premium_outlined, size: 18),
                  label: Text(l10n.proYukselt),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB300),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _yukseltDialoguGoster(BuildContext context, AppLocalizations l10n) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProYukselmeSayfasi()),
    );
  }
}
