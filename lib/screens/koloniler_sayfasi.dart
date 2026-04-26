import 'package:flutter/material.dart';
import '../services/veritabani_servisi.dart';
import '../services/karar_asistan_servisi.dart';
import 'koloni_detay_sayfasi.dart';
import 'yeni_koloni_sayfasi.dart';
import 'karsilastirma_sayfasi.dart';

class KolonilerSayfasi extends StatefulWidget {
  final String arilikAd;
  final int arilikId;

  const KolonilerSayfasi({
    super.key,
    required this.arilikAd,
    required this.arilikId,
  });

  @override
  State<KolonilerSayfasi> createState() => _KolonilerSayfasiState();
}

class _KolonilerSayfasiState extends State<KolonilerSayfasi>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _koloniler = [];
  bool _yukleniyor = true;
  bool _donorlerYukleniyor = false;
  List<Map<String, dynamic>> _siraliDonorler = [];
  final Map<int, Map<String, bool>> _alarmDurumMap = {};
  final Map<int, bool> _aktiflikMap = {};

  bool _karsilastirmaModu = false;
  final Set<int> _seciliKoloniIdleri = <int>{};

  late TabController _tabController;
  int _yuklemeToken = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _verileriYukle();
  }

  @override
  void dispose() {
    _tabController.dispose();
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

    final veri =
    await VeritabaniServisi.kovanlariAriligaGoreGetir(widget.arilikId);

    final Map<int, Map<String, bool>> alarmMap = {};
    final Map<int, bool> aktiflikMap = {};

    await Future.wait(veri.map((k) async {
      final koloniId = _toInt(k['id']);
      if (koloniId <= 0) return;

      final muayeneler = await VeritabaniServisi.muayeneleriGetir(koloniId);
      final son =
      muayeneler.isNotEmpty ? muayeneler.first : const <String, dynamic>{};

      final bool ogulBelirtisi = _toInt(son['ogulBelirtisi']) == 1;
      final bool bolmeYapildi = _toInt(son['bolmeYapildi']) == 1;
      final bool ogulAtti = _toInt(son['ogulAtti']) == 1;

      final DateTime? sonTarih = _parseTarih(son['tarih']);
      final int gunFarki = sonTarih == null
          ? 0
          : _gun(DateTime.now()).difference(_gun(sonTarih)).inDays;

      final bool anaMemesiAktif =
          ogulBelirtisi && !bolmeYapildi && !ogulAtti && gunFarki >= 0;

      alarmMap[koloniId] = {
        'anaMemesiKritik': anaMemesiAktif && gunFarki <= 7,
        'anaMemesiTakip':
        anaMemesiAktif && gunFarki > 7 && gunFarki <= 14,
        'ogulAtti': ogulAtti,
      };

      aktiflikMap[koloniId] = await VeritabaniServisi.koloniAktifMi(koloniId);
    }));

    if (!mounted || token != _yuklemeToken) return;

    setState(() {
      _koloniler = veri;
      _alarmDurumMap
        ..clear()
        ..addAll(alarmMap);
      _aktiflikMap
        ..clear()
        ..addAll(aktiflikMap);
      _siraliDonorler = [];
      _seciliKoloniIdleri.removeWhere(
            (id) => !_aktifKoloniler.any((k) => _toInt(k['id']) == id),
      );
      _yukleniyor = false;
      _donorlerYukleniyor = true;
    });

    try {
      final siraliDonorler = await KararAsistanServisi.donorAdaylariSiraliGetir(
        arilikId: widget.arilikId,
      );

      if (!mounted || token != _yuklemeToken) return;

      setState(() {
        _siraliDonorler = siraliDonorler;
        _donorlerYukleniyor = false;
      });
    } catch (_) {
      if (!mounted || token != _yuklemeToken) return;

      setState(() {
        _siraliDonorler = [];
        _donorlerYukleniyor = false;
      });
    }
  }

  List<Map<String, dynamic>> get _aktifKoloniler {
    return _koloniler.where((k) => _aktifMi(k)).toList();
  }

  List<Map<String, dynamic>> get _sonmusKoloniler {
    return _koloniler.where((k) => !_aktifMi(k)).toList();
  }

  bool _aktifMi(Map<String, dynamic> k) {
    final koloniId = _toInt(k['id']);
    return _aktiflikMap[koloniId] ?? true;
  }

  bool _sonmusMu(Map<String, dynamic> k) => !_aktifMi(k);

  String _pasifDurumEtiketi(Map<String, dynamic> k) {
    final durum = (k['durum'] ?? '').toString().trim().toLowerCase();
    if (durum == 'pasif') return 'PASİF';
    return 'SÖNDÜ';
  }

  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }

  DateTime _gun(DateTime t) {
    return DateTime(t.year, t.month, t.day);
  }

  DateTime? _parseTarih(dynamic v) {
    final s = (v ?? '').toString().trim();
    if (s.isEmpty) return null;

    final iso = DateTime.tryParse(s);
    if (iso != null) {
      return DateTime(iso.year, iso.month, iso.day);
    }

    if (s.contains('.')) {
      final p = s.split('.');
      if (p.length == 3) {
        final gun = int.tryParse(p[0]);
        final ay = int.tryParse(p[1]);
        final yil = int.tryParse(p[2]);
        if (gun != null && ay != null && yil != null) {
          return DateTime(yil, ay, gun);
        }
      }
    }

    if (s.contains('/')) {
      final p = s.split('/');
      if (p.length == 3) {
        final gun = int.tryParse(p[0]);
        final ay = int.tryParse(p[1]);
        final yil = int.tryParse(p[2]);
        if (gun != null && ay != null && yil != null) {
          return DateTime(yil, ay, gun);
        }
      }
    }

    return null;
  }

  Color _skorRengi(int skor) {
    if (skor >= 85) return const Color(0xFF7B6D8D);
    if (skor >= 70) return const Color(0xFF6F8A63);
    if (skor >= 50) return const Color(0xFFB18A5A);
    return const Color(0xFFA7645E);
  }

  String? _donorRozetiMetni(int koloniId) {
    for (final item in _siraliDonorler) {
      if (_toInt(item['koloniId']) == koloniId) {
        final sira = _toInt(item['sira']);
        if (sira == 1) return '1';
        if (sira == 2) return '2';
        if (sira == 3) return '3';
        return 'D';
      }
    }
    return null;
  }

  bool _anaMemesiKritikAlarmiVar(Map<String, dynamic> k) {
    final koloniId = _toInt(k['id']);
    return _alarmDurumMap[koloniId]?['anaMemesiKritik'] == true;
  }

  bool _anaMemesiTakipAlarmiVar(Map<String, dynamic> k) {
    final koloniId = _toInt(k['id']);
    return _alarmDurumMap[koloniId]?['anaMemesiTakip'] == true;
  }

  bool _anaMemesiAlarmiVar(Map<String, dynamic> k) {
    return _anaMemesiKritikAlarmiVar(k) || _anaMemesiTakipAlarmiVar(k);
  }

  bool _ogulAttiAlarmiVar(Map<String, dynamic> k) {
    final koloniId = _toInt(k['id']);
    return _alarmDurumMap[koloniId]?['ogulAtti'] == true;
  }

  void _karsilastirmaModunuDegistir() {
    if (_tabController.index == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Karşılaştırma modu yalnızca aktif koloniler için kullanılabilir.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _karsilastirmaModu = !_karsilastirmaModu;
      if (!_karsilastirmaModu) {
        _seciliKoloniIdleri.clear();
      }
    });
  }

  void _koloniSeciminiDegistir(Map<String, dynamic> k) {
    final koloniId = _toInt(k['id']);
    if (koloniId <= 0) return;
    if (_sonmusMu(k)) return;

    if (_seciliKoloniIdleri.contains(koloniId)) {
      setState(() {
        _seciliKoloniIdleri.remove(koloniId);
      });
      return;
    }

    if (_seciliKoloniIdleri.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('En fazla 3 koloni karşılaştırılabilir.'),
        ),
      );
      return;
    }

    setState(() {
      _seciliKoloniIdleri.add(koloniId);
    });
  }

  Future<void> _karsilastirmayaGit() async {
    if (_seciliKoloniIdleri.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Karşılaştırma için en az 2 koloni seçmelisiniz.'),
        ),
      );
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KarsilastirmaSayfasi(
          koloniIdleri: _seciliKoloniIdleri.toList(),
        ),
      ),
    );
  }

  Future<void> _detayaGit(Map<String, dynamic> k) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KoloniDetaySayfasi(koloni: k),
      ),
    );
    KararAsistanServisi.arilikCacheTemizle(widget.arilikId);
    await _verileriYukle();
  }

  Future<void> _yeniKovan() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => YeniKoloniSayfasi(arilikId: widget.arilikId),
      ),
    );
    KararAsistanServisi.arilikCacheTemizle(widget.arilikId);
    await _verileriYukle();
  }

  Future<void> _koloniDuzenle(Map<String, dynamic> k) async {
    final onay = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Koloniyi Düzenle'),
        content: Text(
          '${k['kovanNo'] ?? '-'} numaralı koloni için düzenleme ekranı açılsın mı?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Devam Et'),
          ),
        ],
      ),
    );

    if (onay != true) return;
    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => YeniKoloniSayfasi(
          arilikId: widget.arilikId,
          koloni: k,
        ),
      ),
    );

    KararAsistanServisi.arilikCacheTemizle(widget.arilikId);
    await _verileriYukle();
  }

  Future<void> _koloniSil(Map<String, dynamic> k) async {
    final koloniId = _toInt(k['id']);
    if (koloniId <= 0) return;

    final onay = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Koloniyi Sil'),
        content: Text(
          '${k['kovanNo'] ?? '-'} numaralı koloni silinsin mi?\n\n'
              'Bu işlem geri alınamaz. İlgili numara geçmişi ve olay kayıtları da silinir.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (onay != true) return;

    try {
      await VeritabaniServisi.koloniSil(koloniId);
      KararAsistanServisi.arilikCacheTemizle(widget.arilikId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${k['kovanNo'] ?? '-'} numaralı koloni silindi.'),
        ),
      );

      await _verileriYukle();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Koloni silinirken hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final seciliSayi = _seciliKoloniIdleri.length;
    final aktifSayi = _aktifKoloniler.length;
    final sonmusSayi = _sonmusKoloniler.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F1E6),
      appBar: AppBar(
        titleSpacing: 10,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.arilikAd,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            Text(
              _karsilastirmaModu
                  ? '$seciliSayi koloni seçildi'
                  : (_donorlerYukleniyor
                  ? 'Koloniler • Donör rozetleri hazırlanıyor'
                  : 'Koloniler'),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color:
                _karsilastirmaModu ? Colors.brown.shade900 : Colors.black87,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          indicatorColor: Colors.brown,
          tabs: [
            Tab(text: 'AKTİF ($aktifSayi)'),
            Tab(text: 'SÖNMÜŞ ($sonmusSayi)'),
          ],
          onTap: (index) {
            if (index == 1 && _karsilastirmaModu) {
              setState(() {
                _karsilastirmaModu = false;
                _seciliKoloniIdleri.clear();
              });
            }
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _karsilastirmaModunuDegistir,
                child: Ink(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _karsilastirmaModu
                        ? Colors.brown.withOpacity(0.10)
                        : Colors.white.withOpacity(0.30),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _karsilastirmaModu
                          ? Colors.brown.shade400
                          : Colors.black.withOpacity(0.12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _karsilastirmaModu
                            ? Icons.close_fullscreen
                            : Icons.compare_arrows,
                        size: 18,
                        color: Colors.black87,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _karsilastirmaModu ? 'Kapat' : 'Karşılaştır',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_donorlerYukleniyor && !_yukleniyor)
            const LinearProgressIndicator(
              minHeight: 2,
              color: Colors.brown,
              backgroundColor: Colors.transparent,
            ),
          if (_karsilastirmaModu && _tabController.index == 0)
            _karsilastirmaBilgiBandi(),
          Expanded(
            child: _yukleniyor
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
              controller: _tabController,
              children: [
                _koloniGridi(
                  koloniler: _aktifKoloniler,
                  bosMesaj: 'Bu arılıkta aktif koloni kaydı yok.',
                  sonmusSekmesi: false,
                ),
                _koloniGridi(
                  koloniler: _sonmusKoloniler,
                  bosMesaj: 'Bu arılıkta sönmüş koloni kaydı yok.',
                  sonmusSekmesi: true,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _karsilastirmaModu && _tabController.index == 0
          ? FloatingActionButton.extended(
        onPressed: seciliSayi >= 2 ? _karsilastirmayaGit : null,
        backgroundColor: seciliSayi >= 2 ? Colors.amber : Colors.grey,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.compare),
        label: Text('Karşılaştır ($seciliSayi)'),
      )
          : FloatingActionButton(
        onPressed: _yeniKovan,
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _koloniGridi({
    required List<Map<String, dynamic>> koloniler,
    required String bosMesaj,
    required bool sonmusSekmesi,
  }) {
    if (koloniler.isEmpty) {
      return Center(
        child: Text(bosMesaj),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 90),
      itemCount: koloniler.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        mainAxisExtent: 128,
      ),
      itemBuilder: (_, i) => _koloniKutusu(
        koloniler[i],
        sonmusSekmesi: sonmusSekmesi,
      ),
    );
  }

  Widget _karsilastirmaBilgiBandi() {
    final seciliSayi = _seciliKoloniIdleri.length;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.compare_arrows, size: 18, color: Colors.brown),
              SizedBox(width: 8),
              Text(
                'KARŞILAŞTIRMA MODU',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Colors.brown,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Karşılaştırmak istediğiniz 2 veya 3 aktif koloniye dokunun. Bu mod açıkken koloni detayı yerine seçim yapılır.',
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Seçili koloni: $seciliSayi / 3',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: seciliSayi >= 2
                  ? Colors.green.shade700
                  : Colors.orange.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _koloniKutusu(
      Map<String, dynamic> k, {
        required bool sonmusSekmesi,
      }) {
    final koloniId = _toInt(k['id']);
    final skor = _toInt(k['skor']);
    final sonCita = _toInt(k['sonCita']);
    final skorRenk = _skorRengi(skor);
    final donorRozeti = sonmusSekmesi ? null : _donorRozetiMetni(koloniId);
    final secili = _seciliKoloniIdleri.contains(koloniId);

    final bool anaMemesiKritikAlarmi =
        !sonmusSekmesi && _anaMemesiKritikAlarmiVar(k);
    final bool anaMemesiTakipAlarmi =
        !sonmusSekmesi && _anaMemesiTakipAlarmiVar(k);
    final bool anaMemesiAlarmi = !sonmusSekmesi && _anaMemesiAlarmiVar(k);
    final bool ogulAttiAlarmi = !sonmusSekmesi && _ogulAttiAlarmiVar(k);

    final Color ustRenk = sonmusSekmesi ? Colors.grey.shade500 : skorRenk;
    final Color cerceveRenk = sonmusSekmesi
        ? Colors.grey.withOpacity(0.55)
        : (secili ? Colors.amber.shade700 : skorRenk.withOpacity(0.45));

    final Color alarmRengi = ogulAttiAlarmi
        ? const Color(0xFF8E2F2B)
        : (anaMemesiTakipAlarmi
        ? Colors.orange.shade700
        : const Color(0xFFC94C44));

    return Opacity(
      opacity: sonmusSekmesi ? 0.88 : 1,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: secili ? Colors.amber.withOpacity(0.10) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: cerceveRenk,
                width: secili ? 2.2 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 26,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: secili ? Colors.amber.shade700 : ustRenk,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(13),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${k['kovanNo'] ?? '-'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (donorRozeti != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.30),
                            ),
                          ),
                          child: Text(
                            donorRozeti,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (_karsilastirmaModu && !sonmusSekmesi) {
                        _koloniSeciminiDegistir(k);
                      } else {
                        _detayaGit(k);
                      }
                    },
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(13),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: _karsilastirmaModu && !sonmusSekmesi
                                ? Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: secili
                                    ? Colors.amber.withOpacity(0.20)
                                    : Colors.grey.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                secili
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                size: 18,
                                color: secili
                                    ? Colors.amber.shade800
                                    : Colors.grey,
                              ),
                            )
                                : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                if (!sonmusSekmesi) ...[
                                  InkWell(
                                    onTap: () => _koloniDuzenle(k),
                                    borderRadius:
                                    BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color:
                                        Colors.amber.withOpacity(0.14),
                                        borderRadius:
                                        BorderRadius.circular(20),
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        size: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                ],
                                InkWell(
                                  onTap: () => _koloniSil(k),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.10),
                                      borderRadius:
                                      BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.delete_outline,
                                      size: 16,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            sonmusSekmesi ? _pasifDurumEtiketi(k) : '%$skor',
                            style: TextStyle(
                              fontSize: sonmusSekmesi ? 17 : 22,
                              fontWeight: FontWeight.w900,
                              color: secili
                                  ? Colors.amber.shade800
                                  : (sonmusSekmesi
                                  ? Colors.grey.shade700
                                  : skorRenk),
                              height: 1,
                            ),
                          ),
                          Text(
                            '$sonCita çıta',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: sonmusSekmesi
                                  ? Colors.grey.shade700
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (anaMemesiAlarmi || ogulAttiAlarmi)
            Positioned(
              top: 0,
              right: 0,
              child: IgnorePointer(
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: alarmRengi,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(13),
                      bottomLeft: Radius.circular(12),
                    ),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    anaMemesiKritikAlarmi || ogulAttiAlarmi
                        ? '!'
                        : '•',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}