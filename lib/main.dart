import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:itogena_v45/screens/ana_sayfa.dart';
import 'package:itogena_v45/services/guncelleme_servisi.dart';
import 'package:itogena_v45/services/veritabani_servisi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ItogenaApp());
}

class ItogenaApp extends StatelessWidget {
  const ItogenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'İtogena Arılık Yönetimi',
      debugShowCheckedModeBanner: false,
      locale: const Locale('tr', 'TR'),
      supportedLocales: const [
        Locale('tr', 'TR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFFFFFDE7),
        useMaterial3: true,
      ),
      home: const GirisEkrani(),
    );
  }
}

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  bool _hazirlaniyor = true;
  String _durumMetni = 'Veriler hazırlanıyor...';

  @override
  void initState() {
    super.initState();
    _uygulamayiHazirla();
  }

  Future<void> _uygulamayiHazirla() async {
    try {
      setState(() {
        _hazirlaniyor = true;
        _durumMetni = 'Veriler hazırlanıyor...';
      });

      await Future.wait([
        VeritabaniServisi.db,
        Future.delayed(const Duration(milliseconds: 900)),
      ]);

      if (!mounted) return;

      setState(() {
        _durumMetni = 'Sürüm kontrol ediliyor...';
      });

      final dilKodu =
          WidgetsBinding.instance.platformDispatcher.locale.languageCode;

      final guncelleme = await GuncellemeServisi.kontrolEt(
        dilKodu: dilKodu,
      );

      if (!mounted) return;

      if (guncelleme.diyalogGoster) {
        setState(() {
          _durumMetni = 'Yeni sürüm denetleniyor...';
        });

        await GuncellemeServisi.guncellemeDiyaloguGoster(
          context,
          guncelleme,
        );
      }

      if (!mounted) return;

      setState(() {
        _durumMetni = 'Ana sayfa açılıyor...';
      });

      await Future.delayed(const Duration(milliseconds: 250));

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AnaSayfa(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _hazirlaniyor = false;
        _durumMetni = 'Başlatma sırasında sorun oluştu.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Başlatma hatası: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/anasayfa_ikon.png',
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                const Text(
                  'ITOGENA',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  _durumMetni,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 22),
                if (_hazirlaniyor)
                  const CircularProgressIndicator(
                    color: Colors.amber,
                  )
                else
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 28,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
