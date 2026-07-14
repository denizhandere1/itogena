import 'package:flutter/material.dart';
import 'package:itogena_v45/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ana_sayfa_kisayol.dart';

class KullaniciRehberiSayfasi extends StatelessWidget {
  const KullaniciRehberiSayfasi({super.key});

  Widget _madde(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13, height: 1.45)),
          ),
        ],
      ),
    );
  }

  Widget _uyari(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: Colors.deepOrange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13, height: 1.45)),
          ),
        ],
      ),
    );
  }

  Widget _kutu(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.black87),
      ),
    );
  }

  Widget _bolum(String baslik, List<Widget> icerik, {bool acik = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: ExpansionTile(
          initiallyExpanded: acik,
          tilePadding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
          childrenPadding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white,
          title: Text(
            baslik,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w900,
              color: Colors.brown,
            ),
          ),
          children: icerik,
        ),
      ),
    );
  }

  Widget _proTablosu(BuildContext context) {
    final l = AppLocalizations.of(context);
    final satirlar = <List<Object>>[
      [l.rehberProS1, true, true],
      [l.rehberProS1b, false, true],
      [l.rehberProS1c, true, true],
      [l.rehberProS1d, false, true],
      [l.rehberProS2, true, true],
      [l.rehberProS3, true, true],
      [l.rehberProS4, true, true],
      [l.rehberProS5, true, true],
      [l.rehberProS6, false, true],
      [l.rehberProS7, true, true],
      [l.rehberProS7b, false, true],
      [l.rehberProS8, false, true],
      [l.rehberProS9, false, true],
      [l.rehberProS10, false, true],
      [l.rehberProS11, false, true],
      [l.rehberProS12, false, true],
      [l.rehberProS13, false, true],
      [l.rehberProS14, false, true],
      [l.rehberProS15, false, true],
      [l.rehberProS16, false, true],
      [l.rehberProS17, true, true],
      [l.rehberProS19, false, true],
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text(l.rehberProOzellik,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Colors.black54)),
                ),
                SizedBox(
                  width: 64,
                  child: Center(
                    child: Text(l.rehberProUcretsiz,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: Colors.black54)),
                  ),
                ),
                SizedBox(
                  width: 48,
                  child: Center(
                    child: Text(l.rehberProPRO,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFFFB300))),
                  ),
                ),
              ],
            ),
          ),
          ...satirlar.asMap().entries.map((e) {
            final i = e.key;
            final satir = e.value;
            final ucretsiz = satir[1] as bool;
            final pro = satir[2] as bool;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: i.isOdd ? Colors.grey.shade50 : Colors.white,
                borderRadius: i == satirlar.length - 1
                    ? const BorderRadius.vertical(bottom: Radius.circular(11))
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(satir[0] as String,
                        style: const TextStyle(fontSize: 12.5, height: 1.3)),
                  ),
                  SizedBox(
                    width: 64,
                    child: Center(
                      child: Icon(
                        ucretsiz ? Icons.check_circle : Icons.remove,
                        size: 18,
                        color: ucretsiz ? Colors.green : Colors.grey.shade300,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    child: Center(
                      child: Icon(
                        pro ? Icons.check_circle : Icons.remove,
                        size: 18,
                        color: pro
                            ? const Color(0xFFFFB300)
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: Text(l.rehberBaslik,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [AnaSayfaKisayol.aksiyon(context)],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 120),
        children: [

          // ── 1 ────────────────────────────────────────────────────────
          _bolum(l.rehber1Baslik, [
            _kutu(l.rehber1Kutu),
            _madde(l.rehber1M1),
            _madde(l.rehber1M2),
            _madde(l.rehber1M3),
            _madde(l.rehber1M4),
            _madde(l.rehber1M5),
            _madde(l.rehber1M6),
            _madde(l.rehber1M7),
            _madde(l.rehber1M8),
            _madde(l.rehber1M9),
          ], acik: true),

          // ── 2 ────────────────────────────────────────────────────────
          _bolum(l.rehber2Baslik, [
            _kutu(l.rehber2Kutu),
            _proTablosu(context),
          ], acik: true),

          // ── 3 ────────────────────────────────────────────────────────
          _bolum(l.rehber3Baslik, [
            _madde(l.rehber3M1),
            _madde(l.rehber3M2),
            _madde(l.rehber3M3),
            _madde(l.rehber3M4),
            _madde(l.rehber3M5),
            _madde(l.rehber3M6),
            _madde(l.rehber3M7),
          ]),

          // ── 3B ───────────────────────────────────────────────────────
          _bolum(l.rehber3bBaslik, [
            _madde(l.rehber3bM1),
            _madde(l.rehber3bM2),
            _madde(l.rehber3bM3),
            _madde(l.rehber3bM4),
            _madde(l.rehber3bM5),
            _madde(l.rehber3bM6),
          ]),

          // ── 3C ───────────────────────────────────────────────────────
          _bolum(l.rehber3cBaslik, [
            _madde(l.rehber3cM1),
            _madde(l.rehber3cM2),
            _madde(l.rehber3cM3),
            _madde(l.rehber3cM4),
          ]),

          // ── 3D ───────────────────────────────────────────────────────
          _bolum(l.rehber3dBaslik, [
            _madde(l.rehber3dM1),
            _madde(l.rehber3dM2),
            _madde(l.rehber3dM3),
            _madde(l.rehber3dM4),
          ]),

          // ── 3E ───────────────────────────────────────────────────────
          _bolum(l.rehber3eBaslik, [
            _madde(l.rehber3eM1),
            _madde(l.rehber3eM2),
            _madde(l.rehber3eM3),
            _madde(l.rehber3eM4),
          ]),

          // ── 3F ───────────────────────────────────────────────────────
          _bolum(l.rehber3fBaslik, [
            _madde(l.rehber3fM1),
            _madde(l.rehber3fM2),
            _madde(l.rehber3fM3),
            _madde(l.rehber3fM4),
          ]),

          // ── 3G ───────────────────────────────────────────────────────
          _bolum(l.rehber3gBaslik, [
            _madde(l.rehber3gM1),
            _madde(l.rehber3gM2),
            _madde(l.rehber3gM3),
            _madde(l.rehber3gM4),
          ]),

          // ── 4 ────────────────────────────────────────────────────────
          _bolum(l.rehber4Baslik, [
            _madde(l.rehber4M1),
            _madde(l.rehber4M2),
            _madde(l.rehber4M3),
            _madde(l.rehber4M4),
            _madde(l.rehber4M5),
            _madde(l.rehber4M6),
          ]),

          // ── 5 ────────────────────────────────────────────────────────
          _bolum(l.rehber5Baslik, [
            _madde(l.rehber5M1),
            _madde(l.rehber5M2),
            _madde(l.rehber5M3),
            _madde(l.rehber5M4),
          ]),

          // ── 6 ────────────────────────────────────────────────────────
          _bolum(l.rehber6Baslik, [
            _madde(l.rehber6M1),
            _madde(l.rehber6M2),
            _madde(l.rehber6M3),
            _madde(l.rehber6M4),
            _madde(l.rehber6M5),
          ]),

          // ── 7 ────────────────────────────────────────────────────────
          _bolum(l.rehber7Baslik, [
            _madde(l.rehber7M1),
            _madde(l.rehber7M2),
            _madde(l.rehber7M3),
            _madde(l.rehber7M4),
          ]),

          // ── 8 ────────────────────────────────────────────────────────
          _bolum(l.rehber8Baslik, [
            _madde(l.rehber8M1),
            _madde(l.rehber8M2),
            _madde(l.rehber8M3),
            _madde(l.rehber8M4),
          ]),

          // ── 9 ────────────────────────────────────────────────────────
          _bolum(l.rehber9Baslik, [
            _madde(l.rehber9M1),
            _madde(l.rehber9M2),
            _madde(l.rehber9M3),
            _madde(l.rehber9M4),
            _madde(l.rehber9M5),
          ]),

          // ── 10 ───────────────────────────────────────────────────────
          _bolum(l.rehber10Baslik, [
            _madde(l.rehber10M1),
            _madde(l.rehber10M2),
            _madde(l.rehber10M3),
            _madde(l.rehber10M4),
          ]),

          // ── 11 ───────────────────────────────────────────────────────
          _bolum(l.rehber11Baslik, [
            _madde(l.rehber11M1),
            _madde(l.rehber11M2),
            _madde(l.rehber11M3),
          ]),

          // ── 12 ───────────────────────────────────────────────────────
          _bolum(l.rehber12Baslik, [
            _madde(l.rehber12M1),
            _madde(l.rehber12M2),
            _madde(l.rehber12M3),
            _madde(l.rehber12M4),
          ]),

          // ── 13 ───────────────────────────────────────────────────────
          _bolum(l.rehber13Baslik, [
            _madde(l.rehber13M1),
            _madde(l.rehber13M2),
            _madde(l.rehber13M3),
          ]),

          // ── 14 ───────────────────────────────────────────────────────
          _bolum(l.rehber14Baslik, [
            _madde(l.rehber14M1),
            _madde(l.rehber14M2),
            _madde(l.rehber14M3),
          ]),

          // ── 15 ───────────────────────────────────────────────────────
          _bolum(l.rehber15Baslik, [
            _madde(l.rehber15M1),
            _madde(l.rehber15M2),
            _madde(l.rehber15M3),
            _madde(l.rehber15M4),
          ]),

          // ── 16 ───────────────────────────────────────────────────────
          _bolum(l.rehber16Baslik, [
            _madde(l.rehber16M1),
            _madde(l.rehber16M2),
            _madde(l.rehber16M3),
            _madde(l.rehber16M4),
          ]),

          // ── 17 ───────────────────────────────────────────────────────
          _bolum(l.rehber17Baslik, [
            _kutu(l.rehber17Kutu),
            _madde(l.rehber17M1),
            _madde(l.rehber17M2),
            _madde(l.rehber17M3),
            _madde(l.rehber17M4),
            _madde(l.rehber17M5),
            _madde(l.rehber17M6),
            _madde(l.rehber17M7),
            _madde(l.rehber17M8),
            _madde(l.rehber17M9),
            _madde(l.rehber17M10),
            _madde(l.rehber17M11),
          ]),

          // ── 18 ───────────────────────────────────────────────────────
          _bolum(l.rehber18Baslik, [
            _uyari(l.rehber18U1),
            _uyari(l.rehber18U2),
            _uyari(l.rehber18U3),
            _uyari(l.rehber18U4),
          ]),

          // ── 19 ───────────────────────────────────────────────────────
          _bolum(l.rehber19Baslik, [
            _madde(l.rehber19M1),
            _madde(l.rehber19M2),
            _uyari(l.rehber19U1),
          ]),

          // ── 20 ───────────────────────────────────────────────────────
          _bolum(l.rehber20Baslik, [
            _madde(l.rehber20M1),
            GestureDetector(
              onTap: () => launchUrl(
                Uri.parse('https://www.itogena.com/privacy-policy'),
                mode: LaunchMode.externalApplication,
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 4, bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.teal.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.privacy_tip_outlined, size: 18, color: Colors.teal.shade700),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l.rehber20Link,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.teal.shade700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Icon(Icons.open_in_new, size: 16, color: Colors.teal.shade400),
                  ],
                ),
              ),
            ),
          ]),

          // ── 21 ───────────────────────────────────────────────────────
          _bolum(l.rehber21Baslik, [
            _kutu(l.rehber21Kutu),
            _madde(l.rehber21M1),
            _madde(l.rehber21M2),
            _madde(l.rehber21M3),
            _madde(l.rehber21M4),
          ]),

          // ── 22 ───────────────────────────────────────────────────────
          _bolum(l.rehber22Baslik, [
            _kutu(l.rehber22Kutu),
            _madde(l.rehber22M1),
            _madde(l.rehber22M3),
            _madde(l.rehber22M4),
          ]),
        ],
      ),
    );
  }
}
