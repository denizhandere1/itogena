import 'package:flutter/material.dart';
import 'ana_sayfa_kisayol.dart';
import '../services/veritabani_servisi.dart';
import 'koloniler_sayfasi.dart';

class ArilikSecimSayfasi extends StatefulWidget {
  const ArilikSecimSayfasi({super.key});

  @override
  State<ArilikSecimSayfasi> createState() => _ArilikSecimSayfasiState();
}

class _ArilikSecimSayfasiState extends State<ArilikSecimSayfasi> {
  List<Map<String, dynamic>> _ariliklar = [];
  final Map<int, Map<String, dynamic>> _ozetMap = {};
  bool _yukleniyor = true;

  @override
  void initState() {
    super.initState();
    _verileriYukle();
  }

  Future<void> _verileriYukle() async {
    if (mounted) {
      setState(() {
        _yukleniyor = true;
      });
    }

    final ariliklar = await VeritabaniServisi.ariliklariGetir();
    final ozetler = await VeritabaniServisi.arilikOzetleriGetir();

    if (!mounted) return;

    setState(() {
      _ariliklar = ariliklar;
      _ozetMap
        ..clear()
        ..addAll(ozetler);
      _yukleniyor = false;
    });
  }

  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }

  Color _skorRengi(int skor) {
    if (skor >= 85) return Colors.purple;
    if (skor >= 70) return Colors.green;
    if (skor >= 50) return Colors.orange;
    return Colors.red;
  }

  void _arilikEkleDiyalog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Yeni Arılık Ekle"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Arılık Adı (Örn: Uluköy)",
          ),
        ),
        actions: [
          AnaSayfaKisayol.aksiyon(context),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () async {
              final ad = controller.text.trim();
              if (ad.isEmpty) return;

              await VeritabaniServisi.arilikEkle(ad);

              if (!mounted) return;

              Navigator.pop(context);
              _verileriYukle();
            },
            child: const Text("Kaydet"),
          ),
        ],
      ),
    );
  }

  void _ariligaGit(Map<String, dynamic> arilik) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => KolonilerSayfasi(
          arilikAd: arilik['ad']?.toString() ?? '-',
          arilikId: _toInt(arilik['id']),
        ),
      ),
    );
    _verileriYukle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: const Text(
          "ARILIK SEÇİMİ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [AnaSayfaKisayol.aksiyon(context)],
      ),
      body: _yukleniyor
          ? const Center(child: CircularProgressIndicator())
          : _ariliklar.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_off,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              "Henüz arılık eklenmemiş.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _arilikEkleDiyalog,
              child: const Text("İlk Arılığını Ekle"),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 124),
        itemCount: _ariliklar.length,
        itemBuilder: (context, index) {
          final arilik = _ariliklar[index];
          final arilikId = _toInt(arilik['id']);
          final ozet = _ozetMap[arilikId] ?? {};

          final toplam = _toInt(ozet['toplam']);
          final aktif = _toInt(ozet['aktif']);
          final pasif = _toInt(ozet['pasif']);
          final ortalamaSkor = _toInt(ozet['ortalamaSkor']);
          final skorRenk = _skorRengi(ortalamaSkor);

          return InkWell(
            onTap: () => _ariligaGit(arilik),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.place,
                        color: Colors.orange,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          arilik['ad']?.toString() ?? '-',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: skorRenk.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: skorRenk.withOpacity(0.25),
                          ),
                        ),
                        child: Text(
                          "%$ortalamaSkor",
                          style: TextStyle(
                            color: skorRenk,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _ozetKutusu(
                          "Toplam",
                          toplam.toString(),
                          Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ozetKutusu(
                          "Aktif",
                          aktif.toString(),
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ozetKutusu(
                          "Pasif",
                          pasif.toString(),
                          Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Arılığa gir",
                      style: TextStyle(
                        color: Colors.blueGrey.shade700,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SafeArea(
        minimum: const EdgeInsets.only(right: 8, bottom: 8),
        child: FloatingActionButton(
          onPressed: _arilikEkleDiyalog,
          backgroundColor: Colors.amber,
          child: const Icon(Icons.add, color: Colors.black),
        ),
      ),
    );
  }

  Widget _ozetKutusu(String etiket, String deger, Color renk) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: renk.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: renk.withOpacity(0.22)),
      ),
      child: Column(
        children: [
          Text(
            deger,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: renk,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            etiket,
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
}