import 'dart:async';

import 'package:flutter/material.dart';

import 'ana_sayfa_kisayol.dart';
import '../services/veritabani_servisi.dart';
import '../services/karar_asistan_servisi.dart';
import 'koloni_detay_sayfasi.dart';
import 'rapor_listesi_sayfasi.dart';

class RaporlarSayfasi extends StatefulWidget {
  const RaporlarSayfasi({super.key});

  @override
  State<RaporlarSayfasi> createState() => _RaporlarSayfasiState();
}

class _RaporlarSayfasiState extends State<RaporlarSayfasi> {
  bool _yukleniyor = true;
  bool _donorlerYukleniyor = false;
  int _yuklemeToken = 0;

  List<Map<String, dynamic>> _tumKoloniler = [];
  List<Map<String, dynamic>> _aktifKoloniler = [];
  List<Map<String, dynamic>> _siraliDonorler = [];
  List<Map<String, dynamic>> _ilkUcDonor = [];
  List<Map<String, dynamic>> _ilkUcGuclu = [];

  int _ortalamaSkor = 0;
  int _aktifKovanSayisi = 0;
  int _toplamAriliCita = 0;
  double _ekonomikDeger = 0;

  Timer? _ekonomikKaydetDebounce;

  final TextEditingController _ariliCitaDegeriController =
      TextEditingController();
  final TextEditingController _bosKovanDegeriController =
      TextEditingController();
  final TextEditingController _bosKabarmisPetekSayisiController =
      TextEditingController();
  final TextEditingController _bosKabarmisPetekDegeriController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _verileriYukle();
  }

  @override
  void dispose() {
    _ekonomikKaydetDebounce?.cancel();
    _ariliCitaDegeriController.dispose();
    _bosKovanDegeriController.dispose();
    _bosKabarmisPetekSayisiController.dispose();
    _bosKabarmisPetekDegeriController.dispose();
    super.dispose();
  }

  Future<void> _verileriYukle() async {
    final int token = ++_yuklemeToken;

    if (mounted) {
      setState(() {
        _yukleniyor = true;
        _donorlerYukleniyor = false;
      });
    }

    final tumKoloniler = await VeritabaniServisi.kolonileriGetir(
      sadeceAktifler: false,
    );

    final koloniIdleri = tumKoloniler
        .map((k) => _toInt(k['id']))
        .where((id) => id > 0)
        .toList();

    final aktiflikMap =
        await VeritabaniServisi.koloniAktiflikHaritasiGetir(koloniIdleri);

    final ekonomikAriliCita = await VeritabaniServisi.ayarStringGetir(
      'ekonomik_arili_cita',
      varsayilan: '900',
    );
    final ekonomikBosKovan = await VeritabaniServisi.ayarStringGetir(
      'ekonomik_bos_kovan',
      varsayilan: '1500',
    );
    final ekonomikPetekSayi = await VeritabaniServisi.ayarStringGetir(
      'ekonomik_petek_sayi',
      varsayilan: '0',
    );
    final ekonomikPetekDeger = await VeritabaniServisi.ayarStringGetir(
      'ekonomik_petek_deger',
      varsayilan: '120',
    );

    final aktifKoloniler = <Map<String, dynamic>>[];
    int toplamSkor = 0;
    int toplamAriliCita = 0;

    for (final koloni in tumKoloniler) {
      final koloniId = _toInt(koloni['id']);
      if (koloniId <= 0) continue;
      if (aktiflikMap[koloniId] == true) {
        aktifKoloniler.add(koloni);
        toplamSkor += _toInt(koloni['skor']);
        toplamAriliCita += _toInt(koloni['sonCita']);
      }
    }

    final ilkUcGuclu = List<Map<String, dynamic>>.from(aktifKoloniler)
      ..sort(_gucluKoloniSirala);

    if (!mounted || token != _yuklemeToken) return;

    _ariliCitaDegeriController.text = ekonomikAriliCita;
    _bosKovanDegeriController.text = ekonomikBosKovan;
    _bosKabarmisPetekSayisiController.text = ekonomikPetekSayi;
    _bosKabarmisPetekDegeriController.text = ekonomikPetekDeger;

    setState(() {
      _tumKoloniler = tumKoloniler;
      _aktifKoloniler = aktifKoloniler;
      _siraliDonorler = const <Map<String, dynamic>>[];
      _ilkUcDonor = const <Map<String, dynamic>>[];
      _ilkUcGuclu = ilkUcGuclu.take(3).toList();
      _aktifKovanSayisi = aktifKoloniler.length;
      _toplamAriliCita = toplamAriliCita;
      _ortalamaSkor = aktifKoloniler.isEmpty
          ? 0
          : (toplamSkor / aktifKoloniler.length).round();
      _ekonomikDeger = _hesaplananEkonomikDeger();
      _yukleniyor = false;
      _donorlerYukleniyor = true;
    });

    Future<void>.delayed(const Duration(milliseconds: 250), () async {
      await _donorleriArkaPlandaYukle(token);
    });
  }

  Future<void> _donorleriArkaPlandaYukle(int token) async {
    if (_aktifKoloniler.isEmpty) {
      if (!mounted || token != _yuklemeToken) return;
      setState(() => _donorlerYukleniyor = false);
      return;
    }

    final siraliDonorler = await KararAsistanServisi.donorAdaylariSiraliGetir();

    if (!mounted || token != _yuklemeToken) return;

    final donorIdleri = siraliDonorler
        .where((e) => _toInt(e['sira']) >= 1 && _toInt(e['sira']) <= 3)
        .map((e) => _toInt(e['koloniId']))
        .toSet();

    final ilkUcDonor = _aktifKoloniler
        .where((k) => donorIdleri.contains(_toInt(k['id'])))
        .toList()
      ..sort((a, b) {
        final aSira = _donorSirasiBul(_toInt(a['id']), siraliDonorler);
        final bSira = _donorSirasiBul(_toInt(b['id']), siraliDonorler);
        return aSira.compareTo(bSira);
      });

    final ilkUcGuclu = List<Map<String, dynamic>>.from(_aktifKoloniler)
      ..sort((a, b) {
        final donorKiyas = _donorOncelikKiyasla(a, b, siraliDonorler);
        if (donorKiyas != 0) return donorKiyas;
        return _gucluKoloniSirala(a, b);
      });

    setState(() {
      _siraliDonorler = siraliDonorler;
      _ilkUcDonor = ilkUcDonor.take(3).toList();
      _ilkUcGuclu = ilkUcGuclu.take(3).toList();
      _donorlerYukleniyor = false;
    });
  }

  int _gucluKoloniSirala(Map<String, dynamic> a, Map<String, dynamic> b) {
    final skorKiyas = _toInt(b['skor']).compareTo(_toInt(a['skor']));
    if (skorKiyas != 0) return skorKiyas;

    final aSon = _toInt(a['sonCita']);
    final bSon = _toInt(b['sonCita']);
    if (aSon != bSon) return bSon.compareTo(aSon);

    final aBal = _toInt(a['bal_cita']);
    final bBal = _toInt(b['bal_cita']);
    if (aBal != bBal) return bBal.compareTo(aBal);

    return (a['kovanNo'] ?? '').toString().compareTo(
          (b['kovanNo'] ?? '').toString(),
        );
  }

  int _donorOncelikKiyasla(
    Map<String, dynamic> a,
    Map<String, dynamic> b,
    List<Map<String, dynamic>> donorler,
  ) {
    final aDonor = _donorSirasiBul(_toInt(a['id']), donorler) > 0;
    final bDonor = _donorSirasiBul(_toInt(b['id']), donorler) > 0;
    if (aDonor == bDonor) return 0;
    return aDonor ? -1 : 1;
  }

  double _hesaplananEkonomikDeger() {
    final ariliCitaDegeri = _toDouble(_ariliCitaDegeriController.text);
    final bosKovanDegeri = _toDouble(_bosKovanDegeriController.text);
    final bosKabarmisPetekSayisi =
        _toIntFromText(_bosKabarmisPetekSayisiController.text);
    final bosKabarmisPetekDegeri =
        _toDouble(_bosKabarmisPetekDegeriController.text);

    return (_toplamAriliCita * ariliCitaDegeri) +
        (_aktifKovanSayisi * bosKovanDegeri) +
        (bosKabarmisPetekSayisi * bosKabarmisPetekDegeri);
  }

  void _ekonomikAlanDegisti() {
    setState(() {
      _ekonomikDeger = _hesaplananEkonomikDeger();
    });

    _ekonomikKaydetDebounce?.cancel();
    _ekonomikKaydetDebounce = Timer(const Duration(milliseconds: 450), () async {
      await VeritabaniServisi.ayarKaydet(
        'ekonomik_arili_cita',
        _ariliCitaDegeriController.text.trim(),
      );
      await VeritabaniServisi.ayarKaydet(
        'ekonomik_bos_kovan',
        _bosKovanDegeriController.text.trim(),
      );
      await VeritabaniServisi.ayarKaydet(
        'ekonomik_petek_sayi',
        _bosKabarmisPetekSayisiController.text.trim(),
      );
      await VeritabaniServisi.ayarKaydet(
        'ekonomik_petek_deger',
        _bosKabarmisPetekDegeriController.text.trim(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: const Text(
          'RAPORLAR',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [AnaSayfaKisayol.aksiyon(context)],
      ),
      body: _yukleniyor
          ? const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              children: [
                _genelDurumKarti(),
                const SizedBox(height: 16),
                _raporSecimKutusu(),
                const SizedBox(height: 16),
                _ekonomikDegerKarti(),
              ],
            ),
    );
  }

  Widget _genelDurumKarti() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GENEL DURUM',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 15,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _anaOzetKutusu(
                  'Aktif kovan',
                  _aktifKovanSayisi.toString(),
                  Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _anaOzetKutusu(
                  'Orta skor',
                  _ortalamaSkor.toString(),
                  _skorRengi(_ortalamaSkor),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _anaOzetKutusu(
                  'Arılı çıta',
                  _toplamAriliCita.toString(),
                  Colors.blueGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.payments_outlined,
                  size: 20,
                  color: Colors.brown.shade700,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Arılık tahmini ekonomik değer',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Text(
                  '${_paraFormatla(_ekonomikDeger)} TL',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Colors.brown,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _kompaktGridBolumu(
                  baslik: 'DONÖRLER',
                  koloniler: _ilkUcDonor,
                  fallbackMetin:
                      _donorlerYukleniyor ? 'Hesaplanıyor' : 'Henüz yok',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _kompaktGridBolumu(
                  baslik: 'İLK 3 GÜÇLÜ',
                  koloniler: _ilkUcGuclu,
                  fallbackMetin: 'Henüz yok',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kompaktGridBolumu({
    required String baslik,
    required List<Map<String, dynamic>> koloniler,
    required String fallbackMetin,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          baslik,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 12,
            color: Colors.brown,
          ),
        ),
        const SizedBox(height: 6),
        if (koloniler.isEmpty)
          Container(
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFCF2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Text(
              fallbackMetin,
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: koloniler.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 1.12,
            ),
            itemBuilder: (context, index) {
              final koloni = koloniler[index];
              final skor = _toInt(koloni['skor']);
              final renk = _skorRengi(skor);
              final kovanNo = (koloni['kovanNo'] ?? '-').toString();

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => KoloniDetaySayfasi(koloni: koloni),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: renk.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: renk.withOpacity(0.28)),
                  ),
                  child: Center(
                    child: Text(
                      kovanNo,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                        color: renk,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _raporSecimKutusu() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RAPOR SEÇ',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 15,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ağır liste hesapları ilk açılışta çalışmaz. Sadece görmek istediğin liste açıldığında yüklenir.',
            style: TextStyle(fontSize: 12, height: 1.45, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          _raporSatiri(
            baslik: 'Güçlüden Zayıfa',
            altMetin: 'Tüm aktif koloniler yüksek skordan düşüğe sıralanır.',
            ikon: Icons.arrow_downward_rounded,
            onTap: () => _listeyeGit(
              'GÜÇLÜDEN ZAYIFA',
              'gucluden_zayifa',
            ),
          ),
          _raporSatiri(
            baslik: 'Zayıftan Güçlüye',
            altMetin: 'Tüm aktif koloniler düşük skordan yükseğe sıralanır.',
            ikon: Icons.arrow_upward_rounded,
            onTap: () => _listeyeGit(
              'ZAYIFTAN GÜÇLÜYE',
              'zayiftan_gucluye',
            ),
          ),
          _raporSatiri(
            baslik: 'Donör Adayları',
            altMetin: '1. sıradan başlayarak donör havuzu listelenir.',
            ikon: Icons.workspace_premium_outlined,
            onTap: () => _listeyeGit(
              'DONÖR ADAYLARI',
              'donor_adaylari',
            ),
          ),
          _raporSatiri(
            baslik: 'Genetik Veto',
            altMetin: 'Donör dışı kalan veto kayıtları kendi içinde sıralanır.',
            ikon: Icons.block_outlined,
            onTap: () => _listeyeGit(
              'GENETİK VETO',
              'genetik_veto',
            ),
          ),
        ],
      ),
    );
  }

  Widget _raporSatiri({
    required String baslik,
    required String altMetin,
    required IconData ikon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.amber.shade100,
          child: Icon(ikon, color: Colors.brown),
        ),
        title: Text(
          baslik,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          altMetin,
          style: const TextStyle(fontSize: 12, height: 1.35),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _ekonomikDegerKarti() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'EKONOMİK DEĞER',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 15,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tahmini toplam değer: ${_paraFormatla(_ekonomikDeger)} TL',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          _alan('Arılı çıta değeri', _ariliCitaDegeriController),
          const SizedBox(height: 10),
          _alan('Boş kovan değeri', _bosKovanDegeriController),
          const SizedBox(height: 10),
          _alan('Boş kabarmış petek adedi', _bosKabarmisPetekSayisiController),
          const SizedBox(height: 10),
          _alan(
            'Boş kabarmış petek birim değeri',
            _bosKabarmisPetekDegeriController,
          ),
        ],
      ),
    );
  }

  Widget _alan(String etiket, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: (_) => _ekonomikAlanDegisti(),
      decoration: InputDecoration(
        labelText: etiket,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: const Color(0xFFFFFDF7),
      ),
    );
  }

  Widget _anaOzetKutusu(String baslik, String deger, Color renk) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(
        color: renk.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: renk.withOpacity(0.24)),
      ),
      child: Column(
        children: [
          Text(
            deger,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: renk,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            baslik,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _listeyeGit(String baslik, String tip) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RaporListesiSayfasi(
          baslik: baslik,
          raporTipi: tip,
        ),
      ),
    );
  }

  int _donorSirasiBul(int koloniId, List<Map<String, dynamic>> donorler) {
    for (final donor in donorler) {
      if (_toInt(donor['koloniId']) == koloniId) {
        return _toInt(donor['sira']);
      }
    }
    return 0;
  }

  Color _skorRengi(int skor) {
    if (skor >= 85) return Colors.purple;
    if (skor >= 70) return Colors.green;
    if (skor >= 50) return Colors.orange;
    return Colors.red;
  }

  String _paraFormatla(double deger) {
    return deger.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
  }

  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }

  int _toIntFromText(String metin) {
    return int.tryParse(metin.trim()) ?? 0;
  }

  double _toDouble(String metin) {
    return double.tryParse(metin.trim().replaceAll(',', '.')) ?? 0;
  }
}
