import 'package:flutter/material.dart';
import 'package:itogena_v45/screens/arilik_secim_sayfasi.dart';
import 'package:itogena_v45/screens/ayarlar_sayfasi.dart';
import 'package:itogena_v45/screens/raporlar_sayfasi.dart';
import 'package:itogena_v45/screens/soy_agaci_sayfasi.dart';
import 'package:itogena_v45/screens/formuller_hesaplamalar_sayfasi.dart';
import 'package:itogena_v45/screens/kullanici_rehberi_sayfasi.dart' as rehber;

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  Widget _bilgiKarti() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.brown),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'İTOGENA NE YAPAR?',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: Colors.brown,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'İTOGENA, muayene kayıtlarını sadece saklamaz; olayları, süreçleri ve zamanı birlikte okuyarak koloni için ne yapılması gerektiğini söyleyen bir arılık yönetim sistemidir.',
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => const rehber.KullaniciRehberiSayfasi(),
                  ),
                );
              },
              icon: const Icon(Icons.menu_book_outlined),
              label: const Text('Detaylı Bilgi'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuKarti({
    required BuildContext context,
    required String baslik,
    required String altBaslik,
    required IconData ikon,
    required Widget sayfa,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: Card(
        color: Colors.white,
        elevation: 1.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.amber.shade200),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.amber.shade100,
            child: Icon(ikon, color: Colors.brown),
          ),
          title: Text(
            baslik,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          subtitle: Text(
            altBaslik,
            style: const TextStyle(fontSize: 12, height: 1.35),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => sayfa),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double altBosluk = MediaQuery.of(context).padding.bottom + 90;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: const Text(
          'ITOGENA',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(0, 0, 0, altBosluk),
          children: [
            _bilgiKarti(),
            _menuKarti(
              context: context,
              baslik: 'Arılık Yönetimi',
              altBaslik: 'Arılıklarını ve kolonilerini görüntüle',
              ikon: Icons.hive_outlined,
              sayfa: const ArilikSecimSayfasi(),
            ),
            _menuKarti(
              context: context,
              baslik: 'Raporlar',
              altBaslik: 'Karar, risk ve genel arılık görünümü',
              ikon: Icons.analytics_outlined,
              sayfa: const RaporlarSayfasi(),
            ),
            _menuKarti(
              context: context,
              baslik: 'Soy Ağacı',
              altBaslik: 'Kolonilerin genetik hat takibini görüntüle',
              ikon: Icons.account_tree_outlined,
              sayfa: const SoyAgaciSayfasi(),
            ),
            _menuKarti(
              context: context,
              baslik: 'Formüller ve Hesaplamalar',
              altBaslik: 'Şurup ve oksalik asit yardımcı ekranı',
              ikon: Icons.calculate_outlined,
              sayfa: const FormullerHesaplamalarSayfasi(),
            ),
            _menuKarti(
              context: context,
              baslik: 'Ayarlar',
              altBaslik:
              'Saha tanımları, bal akımı, sistem tercihleri ve yedekleme',
              ikon: Icons.settings_outlined,
              sayfa: const AyarlarSayfasi(),
            ),
          ],
        ),
      ),
    );
  }
}
