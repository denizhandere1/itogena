import 'package:flutter/material.dart';
import '../services/veritabani_servisi.dart';
import '../services/karar_asistan_servisi.dart';
import '../services/koloni_grid_context.dart';
import '../services/koloni_grid_context_servisi.dart';
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
  final Map<int, KoloniGridContext> _gridContextMap = {};

  final TextEditingController _aramaController = TextEditingController();
  String _hizliFiltre = 'tum';

  bool _karsilastirmaModu = false;
  final Set<int> _seciliKoloniIdleri = <int>{};

  late TabController _tabController;
  int _yuklemeToken = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _aramaController.addListener(_aramaDegisti);
    _verileriYukle();
  }

  @override
  void dispose() {
    _aramaController.removeListener(_aramaDegisti);
    _aramaController.dispose();
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

    final koloniIdleri = veri
        .map((k) => _toInt(k['id']))
        .where((id) => id > 0)
        .toList();

    final aktiflikMap =
    await VeritabaniServisi.koloniAktiflikHaritasiGetir(koloniIdleri);

    final gridContextMap = await KoloniGridContextServisi.topluGetir(
      koloniler: veri,
      aktiflikMap: aktiflikMap,
    );

    if (!mounted || token != _yuklemeToken) return;

    setState(() {
      _koloniler = veri;
      _gridContextMap
        ..clear()
        ..addAll(gridContextMap);
      _siraliDonorler = [];
      _seciliKoloniIdleri.removeWhere(
            (id) => !_aktifKoloniler.any((k) => _toInt(k['id']) == id),
      );
      _yukleniyor = false;
      _donorlerYukleniyor = false;
    });

    _donorRozetleriniArkaPlandaYukle(token);
  }

  Future<void> _donorRozetleriniArkaPlandaYukle(int token) async {
    // Liste önce ekrana gelsin. Donör hesabı, ilk çizimi bloke etmesin.
    await Future<void>.delayed(const Duration(milliseconds: 250));

    if (!mounted || token != _yuklemeToken) return;

    setState(() {
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
    return _filtreleListe(_koloniler.where((k) => _aktifMi(k)).toList());
  }

  List<Map<String, dynamic>> get _sonmusKoloniler {
    return _filtreleListe(_koloniler.where((k) => !_aktifMi(k)).toList());
  }

  int get _aktifToplamSayi => _koloniler.where((k) => _aktifMi(k)).length;

  int get _sonmusToplamSayi => _koloniler.where((k) => !_aktifMi(k)).length;

  bool _aktifMi(Map<String, dynamic> k) {
    final koloniId = _toInt(k['id']);
    return _gridContextMap[koloniId]?.aktifMi ?? true;
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

  String _kaynakTipi(Map<String, dynamic> k) {
    return (k['kaynakTipi'] ?? '').toString().trim().toLowerCase();
  }

  bool _sonGunIcindeMi(Map<String, dynamic> k, int gun) {
    final tarih = _parseTarih(
      k['olusturmaTarihi'] ??
          k['olusturmaTarihiIso'] ??
          k['createdAt'] ??
          k['tarih'],
    );
    if (tarih == null) return false;

    final bugun = _gun(DateTime.now());
    final fark = bugun.difference(_gun(tarih)).inDays;
    return fark >= 0 && fark <= gun;
  }

  bool _yeniBolmeMi(Map<String, dynamic> k) {
    return _kaynakTipi(k) == 'bölme' && _sonGunIcindeMi(k, 45);
  }

  bool _yeniOgulMu(Map<String, dynamic> k) {
    return _kaynakTipi(k) == 'oğul' && _sonGunIcindeMi(k, 45);
  }


  bool _yavruGorulmeyenMi(Map<String, dynamic> k) {
    final koloniId = _toInt(k['id']);
    return _gridContextMap[koloniId]?.yavruYok == true;
  }

  String _yonetimGridEtiketi(Map<String, dynamic> k) {
    final koloniId = _toInt(k['id']);
    return _gridContextMap[koloniId]?.yonetimEtiketi ?? '';
  }

  String _citaAktivasyonGridMetni(Map<String, dynamic> k) {
    final koloniId = _toInt(k['id']);
    return _gridContextMap[koloniId]?.citaGridMetni ?? '${_toInt(k['sonCita'])} çıta';
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

  void _aramaDegisti() {
    if (!mounted) return;
    setState(() {
      _seciliKoloniIdleri.removeWhere(
            (id) => !_aktifKoloniler.any((k) => _toInt(k['id']) == id),
      );
    });
  }

  bool _filtreyeUyar(Map<String, dynamic> k) {
    final arama = _aramaController.text.trim().toLowerCase();
    if (arama.isNotEmpty) {
      final kovanNo = (k['kovanNo'] ?? '').toString().toLowerCase();
      if (!kovanNo.contains(arama)) return false;
    }

    switch (_hizliFiltre) {
      case 'bolme':
        return _yeniBolmeMi(k);
      case 'ogul':
        return _yeniOgulMu(k);
      case 'alarm':
        return _anaMemesiAlarmiVar(k) || _ogulAttiAlarmiVar(k);
      case 'yavru_yok':
        return _yavruGorulmeyenMi(k);
      case 'hasat':
        return _hasatAkintisiGoster(k, sonmusSekmesi: false);
      case 'tum':
      default:
        return true;
    }
  }

  List<Map<String, dynamic>> _filtreleListe(List<Map<String, dynamic>> liste) {
    return liste.where(_filtreyeUyar).toList();
  }

  bool _anaMemesiKritikAlarmiVar(Map<String, dynamic> k) {
    final koloniId = _toInt(k['id']);
    return _gridContextMap[koloniId]?.anaMemesiKritik == true;
  }

  bool _anaMemesiTakipAlarmiVar(Map<String, dynamic> k) {
    final koloniId = _toInt(k['id']);
    return _gridContextMap[koloniId]?.anaMemesiTakip == true;
  }

  bool _anaMemesiAlarmiVar(Map<String, dynamic> k) {
    return _anaMemesiKritikAlarmiVar(k) || _anaMemesiTakipAlarmiVar(k);
  }

  bool _ogulAttiAlarmiVar(Map<String, dynamic> k) {
    final koloniId = _toInt(k['id']);
    return _gridContextMap[koloniId]?.ogulAtti == true;
  }

  bool _hasatAkintisiGoster(Map<String, dynamic> k, {required bool sonmusSekmesi}) {
    if (sonmusSekmesi) return false;
    if (!_aktifMi(k)) return false;

    final int sonCita = _toInt(k['sonCita']);
    if (sonCita < 8) return false;

    // Grid ekranında ağır biyolojik model çalıştırmıyoruz.
    // 8 ve üzeri aktif koloniler hasat potansiyeli için görsel olarak işaretlenir;
    // kesin çıta önerisi koloni detayındaki biyolojik model kartında verilir.
    return true;
  }

  Widget _hasatAkintisiOverlay() {
    return IgnorePointer(
      child: SizedBox(
        width: 32,
        height: 42,
        child: Stack(
          children: [
            Container(
              width: 28,
              height: 12,
              decoration: BoxDecoration(
                color: const Color(0xFFFFB300).withOpacity(0.62),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(13),
                  bottomRight: Radius.circular(14),
                ),
              ),
            ),
            Positioned(
              left: 6,
              top: 24,
              child: Container(
                width: 7,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB300).withOpacity(0.58),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Positioned(
              left: 18,
              top: 22,
              child: Container(
                width: 5,
                height: 13,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC107).withOpacity(0.50),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
    final sonuc = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => KoloniDetaySayfasi(koloni: k),
      ),
    );

    // Detaya sadece bakılıp geri dönüldüyse donör/profil cache'i korunur.
    // Muayene, numara veya koloni verisi değiştiğinde detay ekranı true döndürür.
    if (sonuc == true) {
      KararAsistanServisi.arilikCacheTemizle(widget.arilikId);
      KoloniGridContextServisi.cacheTemizle();
      await _verileriYukle();
    }
  }

  Future<void> _yeniKovan() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => YeniKoloniSayfasi(arilikId: widget.arilikId),
      ),
    );
    KararAsistanServisi.arilikCacheTemizle(widget.arilikId);
    KoloniGridContextServisi.cacheTemizle();
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
    KoloniGridContextServisi.cacheTemizle();
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
      KoloniGridContextServisi.cacheTemizle(koloniId);

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
          _aramaBandi(),
          _hizliFiltreBandi(),
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
                Column(
                  children: [
                    if (!_karsilastirmaModu) _donorBilgiBandi(),
                    Expanded(
                      child: _koloniGridi(
                        koloniler: _aktifKoloniler,
                        bosMesaj: 'Bu arılıkta aktif koloni kaydı yok.',
                        sonmusSekmesi: false,
                      ),
                    ),
                  ],
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


  Widget _aramaBandi() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
      color: const Color(0xFFF3F1E6),
      child: TextField(
        controller: _aramaController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Kovan ara...',
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: _aramaController.text.trim().isEmpty
              ? null
              : IconButton(
            tooltip: 'Aramayı temizle',
            icon: const Icon(Icons.close, size: 20),
            onPressed: () => _aramaController.clear(),
          ),
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.amber.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.amber.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.brown.shade400, width: 1.4),
          ),
        ),
      ),
    );
  }

  Widget _hizliFiltreBandi() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF3F1E6),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _filtreChip('tum', 'Tümü'),
            _filtreChip('bolme', 'Yeni bölmeler'),
            _filtreChip('ogul', 'Yeni oğullar'),
            _filtreChip('alarm', 'Alarm'),
            _filtreChip('yavru_yok', 'Yavru yok'),
            _filtreChip('hasat', 'Hasat adayı'),
          ],
        ),
      ),
    );
  }

  Widget _filtreChip(String deger, String etiket) {
    final secili = _hizliFiltre == deger;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(
          etiket,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            color: secili ? Colors.black : Colors.brown.shade700,
          ),
        ),
        selected: secili,
        selectedColor: Colors.amber.shade300,
        backgroundColor: Colors.white,
        side: BorderSide(
          color: secili ? Colors.brown.shade300 : Colors.amber.shade100,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        onSelected: (_) {
          setState(() {
            _hizliFiltre = deger;
            _seciliKoloniIdleri.removeWhere(
                  (id) => !_aktifKoloniler.any((k) => _toInt(k['id']) == id),
            );
          });
        },
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
        mainAxisExtent: 136,
      ),
      itemBuilder: (_, i) => _koloniKutusu(
        koloniler[i],
        sonmusSekmesi: sonmusSekmesi,
      ),
    );
  }

  Widget _donorBilgiBandi() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.workspace_premium_outlined, size: 18, color: Colors.brown),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Rozetler: 1/2/3 ilk donör adaylarını, D donör havuzundaki diğer adayları gösterir. Genetik veto varsa detay ekranında ayrıca açıklanır.',
              style: TextStyle(
                fontSize: 11.5,
                height: 1.35,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
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
    final bool hasatAkintisiGoster = _hasatAkintisiGoster(k, sonmusSekmesi: sonmusSekmesi);
    final String yonetimEtiketi = sonmusSekmesi ? '' : _yonetimGridEtiketi(k);

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
                          Column(
                            children: [
                              Text(
                                sonmusSekmesi ? '$sonCita çıta' : _citaAktivasyonGridMetni(k),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w900,
                                  color: sonmusSekmesi
                                      ? Colors.grey.shade700
                                      : Colors.black87,
                                ),
                              ),
                              if (!sonmusSekmesi && yonetimEtiketi.isNotEmpty)
                                Text(
                                  yonetimEtiketi,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.brown.shade700,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (hasatAkintisiGoster)
            Positioned(
              top: 0,
              left: 0,
              child: _hasatAkintisiOverlay(),
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