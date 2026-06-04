import 'package:flutter/material.dart';
import 'package:itogena_v45/screens/arilik_secim_sayfasi.dart';
import 'package:itogena_v45/screens/ayarlar_sayfasi.dart';
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Row(
            children: [
              Image.asset(
                'assets/images/anasayfa_ikon.png',
                height: 28,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Muayeneni kaydet,\ngerisini biz hallederiz.',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Özellik listesi
          _ozellikSatiri(
            Icons.hive_outlined,
            'Kovanın içini gör',
            'Hangi çıtada yavru var, hangi çıtada bal — görsel olarak.',
          ),
          const SizedBox(height: 8),
          _ozellikSatiri(
            Icons.assignment_turned_in_outlined,
            'Ne yapman gerektiğini öğren',
            'Donör adayı mı, ana değişimi mi, bölme mi — sistem söyler.',
            isPro: true,
          ),
          const SizedBox(height: 8),
          _ozellikSatiri(
            Icons.warning_amber_outlined,
            'Riskleri önceden gör',
            'Varroa, arı kuşu, yağmacılık — sezon ve koloni birlikte okunur.',
            isPro: true,
          ),
          const SizedBox(height: 8),
          _ozellikSatiri(
            Icons.savings_outlined,
            'Hasat tahminini al',
            'Tahmini bal miktarı ve ekonomik değer koloniye göre hesaplanır.',
            isPro: true,
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => const rehber.KullaniciRehberiSayfasi(),
                ),
              );
            },
            icon: const Icon(Icons.menu_book_outlined, size: 18),
            label: const Text('Kullanıcı Rehberi'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.brown,
              side: BorderSide(color: Colors.brown.shade200),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ozellikSatiri(
    IconData ikon,
    String baslik,
    String aciklama, {
    bool isPro = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(ikon, size: 18, color: Colors.amber.shade800),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    baslik,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  if (isPro) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'PRO',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                aciklama,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _menuKarti({
    required BuildContext context,
    required String baslik,
    required String altBaslik,
    required IconData ikon,
    required Widget sayfa,
    bool isPro = false,
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
          title: Row(
            children: [
              Expanded(
                child: Text(
                  baslik,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
              if (isPro)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB300),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    'PRO',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
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
              altBaslik: 'Kolonilerini ekle, muayene yap, takip et',
              ikon: Icons.hive_outlined,
              sayfa: const ArilikSecimSayfasi(),
            ),
            _menuKarti(
              context: context,
              baslik: 'Raporlar',
              altBaslik: 'Arılık geneli istatistik, ekonomik değer ve donör listesi',
              ikon: Icons.analytics_outlined,
              isPro: true,
              sayfa: const ArilikSecimSayfasi(raporModu: true),
            ),
            _menuKarti(
              context: context,
              baslik: 'Soy Ağacı',
              altBaslik: 'Kolonilerin genetik hat takibi',
              ikon: Icons.account_tree_outlined,
              isPro: true,
              sayfa: const SoyAgaciSayfasi(),
            ),
            _menuKarti(
              context: context,
              baslik: 'Formüller ve Hesaplamalar',
              altBaslik: 'Şurup ve oksalik asit yardımcı ekranı',
              ikon: Icons.calculate_outlined,
              isPro: true,
              sayfa: const FormullerHesaplamalarSayfasi(),
            ),
            _menuKarti(
              context: context,
              baslik: 'Ayarlar',
              altBaslik:
                  'Kalibrasyon, bal akımı, risk takvimi ve sistem tercihleri',
              ikon: Icons.settings_outlined,
              sayfa: const AyarlarSayfasi(),
            ),
          ],
        ),
      ),
    );
  }
}
