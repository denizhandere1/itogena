import 'package:flutter/material.dart';
import 'ana_sayfa_kisayol.dart';
import '../services/veritabani_servisi.dart';
import '../services/karar_asistan_servisi.dart';
import '../services/performans_ozeti_servisi.dart';
import '../services/ari_biyoloji_servisi.dart';
import '../services/soy_devamlilik_servisi.dart';
import '../services/yorum_motoru.dart';
import '../services/baglam_motoru.dart';
import '../services/koloni_context_servisi.dart';
import '../services/cita_aktivasyon_servisi.dart';
import '../services/performans_izleme_servisi.dart';
import 'muayene_ekle_sayfasi.dart';
import 'muayene_detay_sayfasi.dart';

class _LejantHap extends StatelessWidget {
  final Color renk;
  final String metin;

  const _LejantHap({
    required this.renk,
    required this.metin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.brown.shade100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: renk,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            metin,
            style: const TextStyle(
              fontSize: 10.8,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class KoloniDetaySayfasi extends StatefulWidget {
  final Map<String, dynamic> koloni;

  const KoloniDetaySayfasi({
    super.key,
    required this.koloni,
  });

  @override
  State<KoloniDetaySayfasi> createState() => _KoloniDetaySayfasiState();
}

class _KoloniDetaySayfasiState extends State<KoloniDetaySayfasi>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _muayeneler = [];
  List<Map<String, dynamic>> _tumKoloniler = [];

  Map<String, dynamic> _koloniOzet = {};
  Map<String, String>? _anaKarar;
  Map<String, String>? _secilimDurumu;
  Map<String, dynamic> _kimlikOzeti = {};
  Map<String, dynamic> _hatSonmeOzeti = {};
  Map<String, dynamic>? _biyolojiAnalizi;
  Map<String, dynamic>? _biyolojikModel;
  bool _biyolojikModelYukleniyor = false;
  bool _biyolojikModelYuklendi = false;
  Object? _biyolojikModelHatasi;
  Map<String, dynamic>? _soyDevamlilikAnalizi;
  List<Map<String, dynamic>> _aktifSurecler = [];
  Map<String, dynamic>? _hacimAktivasyon;
  Object? _hacimAktivasyonHatasi;
  List<Map<String, dynamic>> _yonetimKararlari = [];
  Object? _yonetimKararlariHatasi;

  Future<PerformansOzeti>? _performansFuture;
  bool _detayAnalizYukleniyor = false;
  bool _detayAnalizYuklendi = false;
  Object? _detayAnalizHatasi;
  int _detayYuklemeToken = 0;
  bool _veriDegisti = false;

  DateTime? _balAkimTarihi;
  DateTime? _balAkimBitisTarihi;
  String? _balAkimEtiketi;

  bool _yukleniyor = true;
  double _balKgFiyati = 600.0;

  String _seciliOzetKarti = 'surec';

  late TabController _tabController;

  int get _koloniId => _toInt(widget.koloni['id']);

  String get _kovanNo {
    final no = _metin(_koloniOzet['kovanNo'], varsayilan: '');
    if (no.isNotEmpty) return no;
    return _metin(widget.koloni['kovanNo']);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_sekmeDegisti);
    _verileriYukle();
  }

  @override
  void dispose() {
    _tabController.removeListener(_sekmeDegisti);
    _tabController.dispose();
    super.dispose();
  }

  void _sekmeDegisti() {
    if (_tabController.indexIsChanging) return;

    if (_tabController.index == 2) {
      _biyolojikModeliYukle();
      return;
    }

    if (_tabController.index == 3) {
      _performansFuture ??= PerformansOzetiServisi.getir(_koloniId);
      _detayAnalizleriYukle();
      if (mounted) setState(() {});
    }
  }

  Future<void> _verileriYukle() async {
    final int token = ++_detayYuklemeToken;

    // Faz 10.1: Ekran açılışında ağır servis cache'leri temizlenmez.
    // Cache temizliği yalnızca muayene ekleme/düzenleme/silme gibi veri değişikliklerinde yapılır.
    // Faz 1 Context: İlk ekran verisi tek KoloniContext üzerinden alınır.

    if (mounted) {
      setState(() {
        _yukleniyor = true;
        _performansFuture = null;
        _detayAnalizYukleniyor = false;
        _detayAnalizYuklendi = false;
        _detayAnalizHatasi = null;
        _tumKoloniler = [];
        _secilimDurumu = null;
        _kimlikOzeti = {};
        _hatSonmeOzeti = {};
        _biyolojiAnalizi = null;
        _biyolojikModel = null;
        _biyolojikModelYukleniyor = false;
        _biyolojikModelYuklendi = false;
        _biyolojikModelHatasi = null;
        _soyDevamlilikAnalizi = null;
        _hacimAktivasyon = null;
        _hacimAktivasyonHatasi = null;
        _yonetimKararlari = [];
        _yonetimKararlariHatasi = null;
      });
    }

    final contextVerisi = await PerformansIzlemeServisi.olc(
      'KoloniDetay.context(koloniId: $_koloniId)',
          () => KoloniContextServisi.getir(_koloniId),
      yavasEsikMs: 300,
    );

    if (!mounted || token != _detayYuklemeToken) return;

    setState(() {
      _koloniOzet = contextVerisi.koloni;
      _muayeneler = contextVerisi.muayeneler;
      _anaKarar = contextVerisi.anaKarar;
      _secilimDurumu = contextVerisi.secilim;
      _aktifSurecler = contextVerisi.aktifSurecler;
      _yonetimKararlari = List<Map<String, dynamic>>.from(
        contextVerisi.yonetimKararlari,
      );
      _yonetimKararlariHatasi = null;
      _yukleniyor = false;
    });

    _ilkEkranSonrasiHafifVerileriYukle(token);
    Future<void>.delayed(
      const Duration(milliseconds: 240),
          () => _hacimAktivasyonunuYukle(token),
    );

    if (_tabController.index == 2) {
      await _biyolojikModeliYukle();
    } else if (_tabController.index == 3) {
      _performansFuture ??= PerformansOzetiServisi.getir(_koloniId);
      await _detayAnalizleriYukle();
    }
  }

  Future<void> _ilkEkranSonrasiHafifVerileriYukle(int token) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    if (!mounted || token != _detayYuklemeToken) return;

    try {
      final koloniler = await VeritabaniServisi.kolonileriGetir();

      if (!mounted || token != _detayYuklemeToken) return;

      setState(() {
        _tumKoloniler = List<Map<String, dynamic>>.from(koloniler);
      });
    } catch (_) {
      // Bu veriler ilk ekran için zorunlu değildir; hata ana ekranı bloklamaz.
    }
  }

  Future<void> _hacimAktivasyonunuYukle(int token) async {
    try {
      final contextVerisi = await KoloniContextServisi.getirBiyolojikModelIle(
        _koloniId,
      );
      final biyolojikModel = contextVerisi.biyolojikModel ?? const <String, dynamic>{};
      final aktivasyon = Map<String, dynamic>.from(
        biyolojikModel['citaAktivasyon'] ?? const <String, dynamic>{},
      );

      if (!mounted || token != _detayYuklemeToken) return;

      setState(() {
        _hacimAktivasyon = Map<String, dynamic>.from(aktivasyon);
        _hacimAktivasyonHatasi = null;
      });
    } catch (e) {
      if (!mounted || token != _detayYuklemeToken) return;
      setState(() {
        _hacimAktivasyon = null;
        _hacimAktivasyonHatasi = e;
      });
    }
  }



  Future<void> _yonetimKararlariniYukle(int token) async {
    try {
      final kararlar = await KararAsistanServisi.yonetimKararlariGetir(
        _koloniId,
        hazirKoloni: _koloniOzet,
      );
      if (!mounted || token != _detayYuklemeToken) return;

      setState(() {
        _yonetimKararlari = List<Map<String, dynamic>>.from(kararlar);
        _yonetimKararlariHatasi = null;
      });
    } catch (e) {
      if (!mounted || token != _detayYuklemeToken) return;
      setState(() {
        _yonetimKararlari = [];
        _yonetimKararlariHatasi = e;
      });
    }
  }

  Future<void> _biyolojikModeliYukle({bool forceRefresh = false}) async {
    if (_biyolojikModelYukleniyor) return;
    if (_biyolojikModelYuklendi && !forceRefresh) return;

    final int token = _detayYuklemeToken;

    if (mounted) {
      setState(() {
        _biyolojikModelYukleniyor = true;
        _biyolojikModelHatasi = null;
      });
    }

    try {
      final contextVerisi = await KoloniContextServisi.getirBiyolojikModelIle(
        _koloniId,
        forceRefresh: forceRefresh,
      );
      final model = contextVerisi.biyolojikModel ?? const <String, dynamic>{};
      if (!mounted || token != _detayYuklemeToken) return;

      final balFiyatStr = await VeritabaniServisi.ayarStringGetir(
        'ekonomik_bal_kg_fiyat',
        varsayilan: '600',
      );
      if (!mounted || token != _detayYuklemeToken) return;

      setState(() {
        _biyolojikModel = Map<String, dynamic>.from(model);
        _balKgFiyati = double.tryParse(balFiyatStr) ?? 600.0;
        _biyolojikModelYuklendi = true;
        _biyolojikModelYukleniyor = false;
      });
    } catch (e) {
      if (!mounted || token != _detayYuklemeToken) return;

      setState(() {
        _biyolojikModelHatasi = e;
        _biyolojikModelYukleniyor = false;
      });
    }
  }

  Future<void> _detayAnalizleriYukle({bool forceRefresh = false}) async {
    if (_detayAnalizYukleniyor) return;
    if (_detayAnalizYuklendi && !forceRefresh) return;

    if (mounted) {
      setState(() {
        _detayAnalizYukleniyor = true;
        _detayAnalizHatasi = null;
      });
    }

    try {
      final sonuclar = await Future.wait<dynamic>([
        VeritabaniServisi.koloniHikayeOzetiGetir(_koloniId),
        VeritabaniServisi.hatSonmeAnaliziGetir(_koloniId),
        AriBiyolojiServisi.analizMapiGetir(_koloniId),
        SoyDevamlilikServisi.analizYap(_koloniId),
      ]);

      if (!mounted) return;

      setState(() {
        _kimlikOzeti = Map<String, dynamic>.from(sonuclar[0]);
        _hatSonmeOzeti = Map<String, dynamic>.from(sonuclar[1]);
        _biyolojiAnalizi = Map<String, dynamic>.from(sonuclar[2]);
        _soyDevamlilikAnalizi = (sonuclar[3] as SoyDevamlilikSonucu).toMap();
        _detayAnalizYuklendi = true;
        _detayAnalizYukleniyor = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _detayAnalizHatasi = e;
        _detayAnalizYukleniyor = false;
      });
    }
  }

  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }

  double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  String _kg(double v) => v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 1);

  String _metin(dynamic v, {String varsayilan = '-'}) {
    final s = (v ?? '').toString().trim();
    return s.isEmpty ? varsayilan : s;
  }

  Color _skorRengi(int skor) {
    if (skor >= 85) return Colors.purple;
    if (skor >= 70) return Colors.green;
    if (skor >= 50) return Colors.orange;
    return Colors.red;
  }

  Color _kararRengi(String tip) {
    switch (tip.trim().toLowerCase()) {
      case 'pozitif':
        return Colors.green;
      case 'negatif':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Color _biyolojiRengi(String durumKodu) {
    switch (durumKodu) {
      case 'UYGUN':
      case 'UYGUN_PENCERE':
        return Colors.green;
      case 'KRITIK':
      case 'ZAMAN_KRITIK':
      case 'MUDAHALE':
        return Colors.red;
      case 'DIKKAT':
      case 'IZLE':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  IconData _biyolojiIkonu(String durumKodu) {
    switch (durumKodu) {
      case 'UYGUN':
      case 'UYGUN_PENCERE':
        return Icons.check_circle_outline;
      case 'KRITIK':
      case 'ZAMAN_KRITIK':
      case 'MUDAHALE':
        return Icons.warning_amber_rounded;
      case 'DIKKAT':
      case 'IZLE':
        return Icons.visibility_outlined;
      default:
        return Icons.biotech_outlined;
    }
  }

  List<Map<String, dynamic>> _tureyenler() {
    final kendiId = _toInt(_koloniOzet['id']);

    return _tumKoloniler.where((k) {
      final kaynakId = _toInt(k['kaynakKoloniId']);
      return kaynakId > 0 && kaynakId == kendiId;
    }).toList();
  }

  List<Map<String, dynamic>> _aktifTureyenler(
      List<Map<String, dynamic>> liste) {
    return liste.where((k) {
      final durum = _metin(k['durum'], varsayilan: 'aktif').toLowerCase();
      return durum != 'sondu' && durum != 'söndü' && durum != 'pasif';
    }).toList();
  }

  String _kaynakMetni() {
    final tip = _metin(_koloniOzet['kaynakTipi'], varsayilan: '');
    final kaynak = _metin(_koloniOzet['kaynakKoloni'], varsayilan: '');

    if (tip == 'Ana Hat') return 'Ana Hat';
    if (tip == 'Bölme') {
      return kaynak.isEmpty ? 'Bölme' : '$kaynak koloniden bölme';
    }
    if (tip == 'Oğul') {
      return kaynak.isEmpty ? 'Oğul' : '$kaynak koloniden oğul';
    }
    return 'Dış kaynak';
  }

  bool get _surecModuAktif => _gorunurSurecler().isNotEmpty;

  List<Map<String, dynamic>> _gorunurSurecler() {
    if (_aktifSurecler.isEmpty) return const <Map<String, dynamic>>[];

    // Süreç kartı gerçek aktif süreçleri göstermelidir.
    // Ana karar zaten süreci baskılamış olsa bile süreç bilgisi UI'de kaybolmamalıdır.
    // Bu nedenle burada anaKarar filtresi uygulanmaz.
    return BaglamMotoru.gorunurSurecleriSirala(
      _aktifSurecler,
      anaKarar: null,
    );
  }

  bool _anaKartlaAyniSurecMi(Map<String, dynamic> surec) {
    return BaglamMotoru.anaKartlaAyniSurecMi(_anaKarar, surec);
  }

  String _normalizeKarsilastirmaMetni(dynamic deger) {
    return (deger ?? '')
        .toString()
        .trim()
        .toLowerCase()
        .replaceAll('ı', 'i')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ş', 's')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  String _kararMetni() {
    final bool secilimSurecSizmasi = _secilimDurumu?['kod']?.startsWith('SUREC_') == true;
    final secilimBaslik = secilimSurecSizmasi
        ? ''
        : _metin(_secilimDurumu?['baslik'], varsayilan: '');
    final lower = secilimBaslik.toLowerCase();

    if (lower.contains('donör değil') || lower.contains('donor değil')) {
      return 'Genetik seçilimde uygun değil.';
    }

    if (secilimBaslik.isNotEmpty) {
      return secilimBaslik.endsWith('.') ? secilimBaslik : '$secilimBaslik.';
    }

    final kararBaslik = _metin(_anaKarar?['baslik'], varsayilan: '');
    if (kararBaslik.isNotEmpty) {
      return kararBaslik.endsWith('.') ? kararBaslik : '$kararBaslik.';
    }

    return 'Yakın takip et.';
  }

  String _kararOzetMetni() {
    final anaMesaj = _metin(_anaKarar?['mesaj'], varsayilan: '');
    final bool secilimSurecSizmasi = _secilimDurumu?['kod']?.startsWith('SUREC_') == true;
    final secilimMesaji = secilimSurecSizmasi
        ? ''
        : _metin(_secilimDurumu?['mesaj'], varsayilan: '');

    if (anaMesaj.isNotEmpty && anaMesaj != '-') {
      return anaMesaj.endsWith('.') ? anaMesaj : '$anaMesaj.';
    }

    if (secilimMesaji.isNotEmpty && secilimMesaji != '-') {
      return secilimMesaji.endsWith('.') ? secilimMesaji : '$secilimMesaji.';
    }

    return _kullanimMetni();
  }

  String _kullanimMetni() {
    return 'Kapalı yavru desteği ve bal üretimi gibi destekleyici alanlarda değerlendirilmeli.';
  }

  // Kullanıcı ekranında tarih standardı: gün.ay.yıl.
  String _tarihFormatla(DateTime dt) {
    final gun = dt.day.toString().padLeft(2, '0');
    final ay = dt.month.toString().padLeft(2, '0');
    final yil = dt.year.toString();
    return '$gun.$ay.$yil';
  }

  String _soyOzetMetni() {
    final tureyenler = _tureyenler();
    if (tureyenler.isEmpty) {
      return '';
    }

    final aktif = _aktifTureyenler(tureyenler);
    final double yasamaOrani = aktif.length / tureyenler.length;

    final yorum = YorumMotoru.soyYorumUret(
      yasamaOrani: yasamaOrani,
      toplamTureyen: tureyenler.length,
      aktifTureyen: aktif.length,
      muayeneSayisi: _muayeneler.length,
    );

    return '${aktif.length} türeyen koloni aktif. $yorum';
  }

  Color _vurguRengi() {
    final karar = _kararMetni().toLowerCase();
    if (karar.contains('donör değil') || karar.contains('donor değil')) {
      return const Color(0xFF8D6E63);
    }
    if (karar.contains('donör') || karar.contains('donor')) {
      return const Color(0xFF7B1FA2);
    }
    return const Color(0xFFB26A00);
  }

  Future<void> _muayeneEkle() async {
    final sonuc = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => MuayeneEkleSayfasi(
          koloniDonemiId: _koloniId,
          sonMuayene: _muayeneler.isNotEmpty ? _muayeneler.first : null,
        ),
      ),
    );

    if (sonuc == true) {
      _veriDegisti = true;
      KararAsistanServisi.koloniCacheTemizle(_koloniId);
      KoloniContextServisi.cacheTemizle(_koloniId);
      await _verileriYukle();
    }
  }

  Future<void> _muayeneDetayAc(Map<String, dynamic> muayene) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => MuayeneDetaySayfasi(
          muayene: muayene,
          kovanNo: _kovanNo,
        ),
      ),
    );
  }

  Future<void> _muayeneDuzenle(Map<String, dynamic> muayene) async {
    final sonuc = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => MuayeneEkleSayfasi(
          koloniDonemiId: _koloniId,
          muayene: muayene,
        ),
      ),
    );

    if (sonuc == true) {
      _veriDegisti = true;
      KararAsistanServisi.koloniCacheTemizle(_koloniId);
      KoloniContextServisi.cacheTemizle(_koloniId);
      await _verileriYukle();
    }
  }

  Future<void> _muayeneSil(Map<String, dynamic> muayene) async {
    final onay = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Muayene Sil'),
        content: Text(
          '${muayene['tarih'] ?? '-'} tarihli muayene silinsin mi?\n\nBu işlem geri alınamaz.',
        ),
        actions: [
          AnaSayfaKisayol.aksiyon(context),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Sil',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (onay != true) return;

    await VeritabaniServisi.muayeneSil(muayene['id']);
    _veriDegisti = true;
    KararAsistanServisi.arilikCacheTemizle(_toInt(_koloniOzet['arilikId']));
    KararAsistanServisi.koloniCacheTemizle(_koloniId);
    KoloniContextServisi.cacheTemizle(_koloniId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Muayene silindi.')),
    );

    await _verileriYukle();
  }

  Future<void> _koloniNumarasiDegistir() async {
    final mevcutNo = (_koloniOzet['kovanNo'] ?? widget.koloni['kovanNo'] ?? '')
        .toString()
        .trim();
    final controller = TextEditingController(text: mevcutNo);

    final yeniNo = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Koloni Numarasını Değiştir'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Bu işlem koloninin saha numarasını değiştirir. Soy bağı ve muayene geçmişi korunur.',
              style: TextStyle(fontSize: 12, height: 1.4),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Yeni koloni / kovan numarası',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          AnaSayfaKisayol.aksiyon(context),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Devam Et'),
          ),
        ],
      ),
    );

    if (yeniNo == null || yeniNo.trim().isEmpty) return;

    await VeritabaniServisi.koloniNumarasiniDegistir(
      koloniId: _koloniId,
      yeniKovanNo: yeniNo.trim(),
    );
    _veriDegisti = true;
    KararAsistanServisi.arilikCacheTemizle(_toInt(_koloniOzet['arilikId']));
    KoloniContextServisi.cacheTemizle(_koloniId);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Koloni numarası ${yeniNo.trim()} olarak güncellendi.'),
      ),
    );
    await _verileriYukle();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _veriDegisti);
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFDE7),
        appBar: AppBar(
          title: Text('KOVAN $_kovanNo'),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          actions: [
            AnaSayfaKisayol.aksiyon(context),
            IconButton(
              tooltip: 'Koloni numarasını değiştir',
              onPressed: _koloniNumarasiDegistir,
              icon: const Icon(Icons.edit_note_rounded, color: Colors.black),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.black,
            indicatorColor: Colors.brown,
            tabs: const [
              Tab(text: 'GENEL DURUM'),
              Tab(text: 'MUAYENELER'),
              Tab(text: 'BİYOLOJİK MODEL'),
              Tab(text: 'PERFORMANS'),
            ],
          ),
        ),
        body: SafeArea(
          bottom: false,
          child: _yukleniyor
              ? const Center(
            child: CircularProgressIndicator(color: Colors.amber),
          )
              : TabBarView(
            controller: _tabController,
            children: [
              _genelDurumSekmesi(),
              _muayenelerSekmesi(),
              _biyolojikModelSekmesi(),
              _performansSekmesi(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _muayeneEkle,
          backgroundColor: Colors.amber,
          icon: const Icon(Icons.add_chart, color: Colors.black),
          label: const Text(
            'Muayene Ekle',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _genelDurumSekmesi() {
    return ListView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 120,
      ),
      children: [
        _ustOzetBandi(),
        _anaBaslikGridi(),
        _seciliOzetDetayPaneli(),
      ],
    );
  }

  Widget _anaBaslikGridi() {
    final surec = _surecOzetBilgisi();
    final biyoloji = _biyolojiOzetBilgisi();
    final yonetim = _yonetimOzetBilgisi();
    final genetik = _genetikOzetBilgisi();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _anaBaslikKarti(
                  id: 'surec',
                  sira: '1',
                  etiket: 'SÜREÇ',
                  anaMetin: surec['ana'].toString(),
                  altMetin: surec['alt'].toString(),
                  dipMetin: surec['dip'].toString(),
                  ikon: Icons.warning_amber_rounded,
                  renk: surec['renk'] as Color,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _anaBaslikKarti(
                  id: 'biyoloji',
                  sira: '2',
                  etiket: 'BİYOLOJİ',
                  anaMetin: biyoloji['ana'].toString(),
                  altMetin: biyoloji['alt'].toString(),
                  dipMetin: biyoloji['dip'].toString(),
                  ikon: Icons.eco_outlined,
                  renk: biyoloji['renk'] as Color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _anaBaslikKarti(
                  id: 'yonetim',
                  sira: '3',
                  etiket: 'YÖNETİM',
                  anaMetin: yonetim['ana'].toString(),
                  altMetin: yonetim['alt'].toString(),
                  dipMetin: yonetim['dip'].toString(),
                  ikon: Icons.assignment_turned_in_outlined,
                  renk: yonetim['renk'] as Color,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _anaBaslikKarti(
                  id: 'genetik',
                  sira: '4',
                  etiket: 'GENETİK',
                  anaMetin: genetik['ana'].toString(),
                  altMetin: genetik['alt'].toString(),
                  dipMetin: genetik['dip'].toString(),
                  ikon: Icons.account_tree_outlined,
                  renk: genetik['renk'] as Color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _anaBaslikKarti({
    required String id,
    required String sira,
    required String etiket,
    required String anaMetin,
    required String altMetin,
    required String dipMetin,
    required IconData ikon,
    required Color renk,
  }) {
    final secili = _seciliOzetKarti == id;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (_seciliOzetKarti == id) return;
          setState(() => _seciliOzetKarti = id);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: 118,
          padding: const EdgeInsets.fromLTRB(11, 10, 11, 9),
          decoration: BoxDecoration(
            color: secili ? renk.withOpacity(0.075) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: secili ? renk.withOpacity(0.68) : renk.withOpacity(0.22),
              width: secili ? 1.6 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: secili
                    ? renk.withOpacity(0.08)
                    : Colors.black.withOpacity(0.025),
                blurRadius: secili ? 10 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 21,
                    height: 21,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: renk,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      sira,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(ikon, color: renk, size: 16),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      etiket,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.6,
                        fontWeight: FontWeight.w900,
                        color: renk,
                        letterSpacing: 0.12,
                      ),
                    ),
                  ),
                  Icon(
                    secili
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.chevron_right_rounded,
                    color: renk,
                    size: 19,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                anaMetin,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14.9,
                  fontWeight: FontWeight.w900,
                  height: 1.10,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                altMetin,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11.4,
                  fontWeight: FontWeight.w800,
                  height: 1.18,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _seciliOzetDetayPaneli() {
    switch (_seciliOzetKarti) {
      case 'biyoloji':
        return _hacimAktivasyonKarti();
      case 'yonetim':
        return _yonetimDurumuKarti();
      case 'genetik':
        return _genelDurumAnaKarti();
      case 'surec':
      default:
        if (_surecModuAktif) return _surecKarti();
        return const SizedBox.shrink();
    }
  }

  Widget _surecYokKarti() {
    return _acilirBilgiKarti(
      baslik: 'Aktif kritik süreç yok',
      ozet: 'Kolonide şu an öne çıkan açma yasağı, oğul sonrası, anasızlık veya benzeri acil süreç görünmüyor.',
      ikon: Icons.check_circle_outline_rounded,
      renk: Colors.green.shade700,
      detaylar: const [
        Text(
          'Süreç kartı yalnızca zaman hassasiyeti olan saha uyarılarını öne çıkarır. Kritik süreç yoksa biyolojik durum ve yönetim kararı daha fazla önem kazanır.',
          style: TextStyle(fontSize: 12.4, height: 1.42),
        ),
      ],
    );
  }

  Map<String, Object> _surecOzetBilgisi() {
    final surecler = _gorunurSurecler();
    if (surecler.isEmpty) {
      return {
        'ana': 'Aktif süreç yok',
        'alt': 'Kritik uyarı görünmüyor',
        'dip': 'Normal takip',
        'renk': Colors.green.shade700,
      };
    }

    final surec = surecler.first;
    final baslik = _metin(surec['baslik'], varsayilan: 'Aktif süreç');
    final mesaj = _metin(surec['mesaj'], varsayilan: 'Süreç takibi gerekli.');
    final tip = _metin(surec['tip'], varsayilan: 'takip').toLowerCase();
    final oncelik = _toInt(surec['oncelik']);
    final renk = tip == 'kritik' || oncelik >= 90
        ? Colors.red.shade700
        : (tip == 'uyari' ? Colors.orange.shade800 : Colors.brown.shade700);

    final String anaEylem = _surecAnaEylemMetni(
      baslik: baslik,
      mesaj: mesaj,
    );
    final String altBaglam = _surecBaglamMetni(
      baslik: baslik,
      mesaj: mesaj,
    );

    return {
      'ana': anaEylem,
      'alt': altBaglam,
      'dip': oncelik > 0 ? 'Öncelik $oncelik/100' : 'Detayları aç',
      'renk': renk,
    };
  }

  String _surecAnaEylemMetni({
    required String baslik,
    required String mesaj,
  }) {
    final birlesik = _normalizeKarsilastirmaMetni('$baslik $mesaj');

    if (birlesik.contains('koloniyi gereksiz acma') ||
        birlesik.contains('gereksiz acma')) {
      return 'Koloniyi gereksiz açma';
    }
    if (birlesik.contains('kesinlikle acma') ||
        birlesik.contains('kovani kesinlikle acma') ||
        birlesik.contains('koloniyi acma')) {
      return 'Koloniyi açma';
    }
    if (birlesik.contains('mudahale etme') ||
        birlesik.contains('mudahele etme')) {
      return 'Müdahale etme';
    }
    if (birlesik.contains('fazla memeleri azalt') ||
        birlesik.contains('meme sayisini kontrol')) {
      return 'Meme sayısını kontrol et';
    }
    if (birlesik.contains('birleştir') || birlesik.contains('birlestir')) {
      return 'Birleştirmeyi değerlendir';
    }
    if (birlesik.contains('alan') && birlesik.contains('bal bask')) {
      return 'Alanı kontrol et';
    }
    if (birlesik.contains('ana değiş') || birlesik.contains('ana degis')) {
      return 'Ana kararını değerlendir';
    }
    if (birlesik.contains('tekrar kontrol') || birlesik.contains('5–7 gün')) {
      return 'Tekrar kontrol et';
    }
    if (birlesik.contains('bolme yap') || birlesik.contains('bolme karari')) {
      return 'Bölme kararını netleştir';
    }
    if (birlesik.contains('kontrol et')) {
      return 'Kontrol et';
    }
    if (birlesik.contains('takip')) {
      return 'Yakından takip et';
    }

    return _kisaKartMetni(_ilkCumle(mesaj, varsayilan: baslik), 28);
  }

  String _surecBaglamMetni({
    required String baslik,
    required String mesaj,
  }) {
    final temizBaslik = baslik.trim();
    if (temizBaslik.isNotEmpty && temizBaslik != '-') {
      return _kisaKartMetni(temizBaslik, 42);
    }
    return _kisaKartMetni(
      _ilkCumle(mesaj, varsayilan: 'Aktif süreç'),
      42,
    );
  }

  Map<String, Object> _biyolojiOzetBilgisi() {
    final aktivasyon = _hacimAktivasyon;
    if (_hacimAktivasyonHatasi != null && aktivasyon == null) {
      return {
        'ana': 'Okunamadı',
        'alt': 'Aktivasyon hesabı hatalı',
        'dip': 'Kontrol et',
        'renk': Colors.deepOrange,
      };
    }
    if (aktivasyon == null || aktivasyon.isEmpty) {
      return {
        'ana': 'Hazırlanıyor',
        'alt': 'Aktivasyon yükleniyor',
        'dip': 'Arka planda',
        'renk': Colors.blueGrey,
      };
    }

    final int fizikselCita = _toInt(
      aktivasyon['fizikselCita'] ??
          (_muayeneler.isNotEmpty ? _muayeneler.first['citaSayisi'] : _koloniOzet['sonCita']),
    );
    final double islevselMin = _toDouble(aktivasyon['islevselCitaMin']);
    final double islevselMax = _toDouble(aktivasyon['islevselCitaMax']);
    final double islevsel = _toDouble(
      aktivasyon['islevselCitaOrta'] ??
          aktivasyon['islevselUretimCita'] ??
          ((islevselMin + islevselMax) / 2),
    );
    final double toplamOran = _toplamHacimAktivasyonOrani(
      aktivasyon,
      fizikselCita: fizikselCita,
      islevselCita: islevsel,
    );
    final int yuzde = (toplamOran * 100).round().clamp(0, 100).toInt();
    final hacimTipi = _metin(aktivasyon['hacimDegisimTipi'], varsayilan: 'yok');
    final renk = _aktivasyonRengi(toplamOran, hacimTipi);

    return {
      'ana': 'Hacim %$yuzde',
      'alt': fizikselCita > 0 ? '$fizikselCita → ${_kg(islevsel)} çıta' : 'İşlevsel hacim okunuyor',
      'dip': _aktivasyonSeviyesi(toplamOran),
      'renk': renk,
    };
  }

  Map<String, Object> _yonetimOzetBilgisi() {
    final yonetimKarari = _yonetimKararlari.isEmpty ? null : _yonetimKararlari.first;
    if (yonetimKarari != null) {
      final baslik = _metin(yonetimKarari['baslik'], varsayilan: 'Yönetim kararı');
      final mesaj = _metin(yonetimKarari['mesaj'], varsayilan: baslik);
      final kategori = _metin(yonetimKarari['kategori'], varsayilan: 'yonetim').toLowerCase();
      final renk = kategori == 'veto'
          ? Colors.deepOrange.shade700
          : Colors.brown.shade700;
      return {
        'ana': _metin(yonetimKarari['kisa'], varsayilan: baslik),
        'alt': _ilkCumle(mesaj, varsayilan: baslik),
        'dip': 'Yönetim',
        'renk': renk,
      };
    }

    if (_yonetimKararlariHatasi != null) {
      return {
        'ana': 'Karar hatası',
        'alt': 'Yönetim kararları okunamadı',
        'dip': 'Kontrol et',
        'renk': Colors.deepOrange,
      };
    }

    return {
      'ana': 'Yönetim yok',
      'alt': 'Öne çıkan saha müdahalesi görünmüyor',
      'dip': 'Takip',
      'renk': Colors.blueGrey.shade700,
    };
  }

  Map<String, Object> _genetikOzetBilgisi() {
    final baslik = _metin(_secilimDurumu?['baslik'], varsayilan: 'Genetik bekleniyor');
    final mesaj = _metin(
      _secilimDurumu?['mesaj'],
      varsayilan: 'Seçilim bilgisi arka planda hazırlanıyor.',
    );
    final temizBaslik = baslik.toLowerCase();
    final temizMesaj = mesaj.toLowerCase();
    final bool surecMetniSizmis = _secilimDurumu?['kod']?.startsWith('SUREC_') == true ||
        temizBaslik.contains('oğul sonrası') ||
        temizBaslik.contains('ogul sonrasi') ||
        temizBaslik.contains('ana kazanma') ||
        temizBaslik.contains('koloniyi aç') ||
        temizBaslik.contains('koloniyi ac');
    final renk = _vurguRengi();

    String ana;
    String alt;

    if (surecMetniSizmis) {
      ana = 'Genetik bekleniyor';
      alt = 'Seçilim ayrı okunacak';
    } else if (temizBaslik.contains('bekleniyor')) {
      ana = 'Hazırlanıyor';
      alt = 'Seçilim yükleniyor';
    } else if (temizBaslik.contains('veto') || temizMesaj.contains('donör havuzunda değil') || temizMesaj.contains('donor havuzunda değil')) {
      ana = 'Donör dışı';
      if (temizMesaj.contains('oğul') || temizMesaj.contains('ogul') || temizBaslik.contains('oğul') || temizBaslik.contains('ogul')) {
        alt = 'Oğul izi / veto';
      } else if (temizBaslik.contains('üretim') || temizBaslik.contains('uretim') || temizMesaj.contains('üretim') || temizMesaj.contains('uretim')) {
        alt = 'Üretimde değerlendir';
      } else {
        alt = 'Veto bilgisi var';
      }
    } else if (temizBaslik.contains('donör') || temizBaslik.contains('donor')) {
      ana = 'Donör adayı';
      alt = _ilkCumle(mesaj, varsayilan: 'Soy takibi uygun');
    } else if (temizBaslik.contains('üretim') || temizBaslik.contains('uretim')) {
      ana = 'Üretim kolonisi';
      alt = _ilkCumle(mesaj, varsayilan: 'Saha rolü üretim');
    } else if (temizBaslik.contains('destek')) {
      ana = 'Destek kolonisi';
      alt = _ilkCumle(mesaj, varsayilan: 'Destek rolü');
    } else {
      ana = _kisaKartMetni(baslik, 34);
      alt = _ilkCumle(mesaj, varsayilan: _kararMetni());
    }

    return {
      'ana': _kisaKartMetni(ana, 28),
      'alt': _kisaKartMetni(alt, 42),
      'dip': _genetikDipMetni(),
      'renk': renk,
    };
  }

  String _genetikDipMetni() {
    final baslik = _metin(_secilimDurumu?['baslik'], varsayilan: '').toLowerCase();
    if (baslik.contains('veto')) return 'Veto bilgisi';
    if (baslik.contains('donör') || baslik.contains('donor')) return 'Donör bilgisi';
    if (baslik.contains('üretim') || baslik.contains('uretim')) return 'Üretim rolü';
    return 'Seçilim';
  }

  String _ilkCumle(String metin, {String varsayilan = ''}) {
    final temiz = metin.trim();
    if (temiz.isEmpty || temiz == '-') return varsayilan;
    final parcalar = temiz.split('.').map((e) => e.trim()).where((e) => e.isNotEmpty);
    if (parcalar.isEmpty) return varsayilan;
    final ilk = parcalar.first;
    return ilk.length > 80 ? '${ilk.substring(0, 77)}...' : ilk;
  }

  String _kisaKartMetni(String metin, int max) {
    final temiz = metin.trim();
    if (temiz.isEmpty || temiz == '-') return '';
    if (temiz.length <= max) return temiz;
    if (max <= 3) return temiz.substring(0, max);
    return '${temiz.substring(0, max - 3)}...';
  }

  Widget _acilirBilgiKarti({
    required String baslik,
    required String ozet,
    required IconData ikon,
    required Color renk,
    required List<Widget> detaylar,
    String? rozet,
    bool baslangictaAcik = true,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: renk.withOpacity(0.34), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: renk.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: baslangictaAcik,
          tilePadding: const EdgeInsets.fromLTRB(14, 10, 10, 8),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          leading: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: renk.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(ikon, color: renk, size: 20),
          ),
          title: Text(
            baslik,
            style: TextStyle(
              fontSize: 13.6,
              fontWeight: FontWeight.w900,
              color: renk,
              letterSpacing: 0.1,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              ozet,
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.35,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          trailing: rozet == null || rozet.trim().isEmpty
              ? null
              : Container(
            constraints: const BoxConstraints(maxWidth: 108),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: renk.withOpacity(0.10),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: renk.withOpacity(0.18)),
            ),
            child: Text(
              rozet,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.4,
                fontWeight: FontWeight.w900,
                color: renk,
              ),
            ),
          ),
          children: detaylar,
        ),
      ),
    );
  }

  double _toplamHacimAktivasyonOrani(
      Map<String, dynamic> aktivasyon, {
        required int fizikselCita,
        required double islevselCita,
      }) {
    final double kayitli = _toDouble(
      aktivasyon['toplamHacimAktivasyonOrani'] ??
          aktivasyon['toplamAktivasyonOrani'] ??
          aktivasyon['gosterimAktivasyonOrani'],
    );
    if (kayitli > 0) return kayitli.clamp(0.0, 1.0).toDouble();
    if (fizikselCita <= 0) return 1.0;
    return (islevselCita / fizikselCita).clamp(0.0, 1.0).toDouble();
  }

  String _aktivasyonSeviyesi(double oran) {
    if (oran >= 0.95) return 'alan dolu';
    if (oran >= 0.85) return 'tamamlanıyor';
    if (oran >= 0.70) return 'iyi';
    if (oran >= 0.45) return 'orta';
    if (oran >= 0.20) return 'düşük';
    return 'çok düşük';
  }

  Color _aktivasyonRengi(double oran, String hacimTipi) {
    final tip = hacimTipi.toLowerCase();
    if (tip.contains('riskli') || tip.contains('zayiflama')) return Colors.deepOrange;
    if (tip.contains('hasat')) return Colors.blueGrey;
    if (tip.contains('uretim') || tip.contains('üretim')) return Colors.green.shade700;
    if (oran >= 0.85) return Colors.green.shade700;
    if (oran >= 0.70) return Colors.teal.shade700;
    if (oran >= 0.45) return Colors.amber.shade800;
    return Colors.deepOrange;
  }

  String _hacimDegisimTipiMetni(String tip) {
    switch (tip) {
      case CitaAktivasyonServisi.hacimTipiKatGecisi:
        return 'Kat geçişi; yeni hacim kademeli aktive ediliyor.';
      case CitaAktivasyonServisi.hacimTipiBallikUretimGenislemesi:
        return 'Bal akımı içinde üretim genişlemesi kabul ediliyor.';
      case CitaAktivasyonServisi.hacimTipiRiskliHizliGenisleme:
        return 'Bal akımı dışında hızlı genişleme; temkinli okunmalı.';
      case CitaAktivasyonServisi.hacimTipiHasatKaynakliDusus:
        return 'Hasat kaynaklı düşüş; biyolojik zayıflama sayılmaz.';
      case CitaAktivasyonServisi.hacimTipiBiyolojikZayiflamaSuphesi:
        return 'Hacim düşüşü biyolojik zayıflama açısından izlenmeli.';
      case CitaAktivasyonServisi.hacimTipiKuluclukGenislemesi:
        return 'Kuluçkalık genişlemesi kontrollü okunuyor.';
      default:
        return 'Hacim değişimi normal bantta.';
    }
  }

  String _beslemeKisaOzet(
      String mesaj,
      List<String> gerekceler,
      String dozBandi,
      ) {
    if (gerekceler.isNotEmpty) return gerekceler.first;
    if (mesaj.trim().isNotEmpty) {
      final parcalar = mesaj.split('.').map((e) => e.trim()).where((e) => e.isNotEmpty);
      if (parcalar.isNotEmpty) return '${parcalar.first}.';
    }
    if (dozBandi.isNotEmpty && dozBandi != '-') return 'Tahmini destek bandı: $dozBandi';
    return 'Besleme kararı stok, yavru, süreç ve işlevsel çıta birlikte okunarak verilir.';
  }

  Widget _hacimAktivasyonKarti() {
    final aktivasyon = _hacimAktivasyon;

    if (_hacimAktivasyonHatasi != null && aktivasyon == null) {
      return _acilirBilgiKarti(
        baslik: 'Biyolojik durum okunamadı',
        ozet: 'Hacim aktivasyon hesabı üretilemedi.',
        ikon: Icons.error_outline,
        renk: Colors.deepOrange,
        detaylar: [
          Text(
            'Hata: $_hacimAktivasyonHatasi',
            style: const TextStyle(fontSize: 12.4, height: 1.4),
          ),
        ],
      );
    }

    if (aktivasyon == null || aktivasyon.isEmpty) {
      if (_muayeneler.isEmpty) return const SizedBox.shrink();
      return _acilirBilgiKarti(
        baslik: 'Biyolojik durum hazırlanıyor',
        ozet: 'Fiziksel çıta, işlevsel üretim çıtası ve toplam hacim aktivasyonu birlikte okunacak.',
        ikon: Icons.hourglass_bottom_rounded,
        renk: Colors.blueGrey,
        detaylar: const [
          Text(
            'Bu hesap ekranı bloke etmemek için ilk açılıştan sonra yüklenir.',
            style: TextStyle(fontSize: 12.4, height: 1.4),
          ),
        ],
      );
    }

    final int fizikselCita = _toInt(
      aktivasyon['fizikselCita'] ??
          (_muayeneler.isNotEmpty ? _muayeneler.first['citaSayisi'] : _koloniOzet['sonCita']),
    );
    final int oncekiCita = _toInt(aktivasyon['oncekiCita']);
    final int eklenenCita = _toInt(aktivasyon['eklenenCita']);
    final int aktivasyonSuresi = _toInt(aktivasyon['aktivasyonSuresiGun']);
    final int gecenGun = _toInt(aktivasyon['gecenGun']);
    final double islevselMin = _toDouble(aktivasyon['islevselCitaMin']);
    final double islevselMax = _toDouble(aktivasyon['islevselCitaMax']);
    final double islevselOrta = _toDouble(
      aktivasyon['islevselCitaOrta'] ??
          aktivasyon['islevselUretimCita'] ??
          ((islevselMin + islevselMax) / 2),
    );
    final double toplamOran = _toplamHacimAktivasyonOrani(
      aktivasyon,
      fizikselCita: fizikselCita,
      islevselCita: islevselOrta,
    );
    final int yuzde = (toplamOran * 100).round().clamp(0, 100).toInt();
    final String hacimTipi = _metin(aktivasyon['hacimDegisimTipi'], varsayilan: 'yok');
    final Color renk = _aktivasyonRengi(toplamOran, hacimTipi);
    final String hacimTipiMetni = _hacimDegisimTipiMetni(hacimTipi);
    final int temel = _toInt(aktivasyon['temelPetekAdedi']);
    final int kabarmis = _toInt(aktivasyon['kabarmisPetekAdedi']);
    final String petekTipi = _metin(aktivasyon['petekTipi'], varsayilan: '');
    final int kalanGun = aktivasyonSuresi > 0
        ? (aktivasyonSuresi - gecenGun).clamp(0, 999).toInt()
        : 0;

    final String baslik = 'Toplam hacim aktivasyonu: %$yuzde';
    final String alanYorumu = toplamOran >= 0.95
        ? 'Sistem mevcut hacmin büyük bölümünü aktif üretim kapasitesi olarak okuyor.'
        : hacimTipiMetni;
    final String kisaOzet = fizikselCita > 0
        ? '$fizikselCita fiziksel çıta → yaklaşık ${_kg(islevselOrta)} işlevsel üretim çıtası. $alanYorumu'
        : 'Fiziksel hacim ve işlevsel üretim kapasitesi birlikte okunuyor.';

    return _acilirBilgiKarti(
      baslik: baslik,
      ozet: kisaOzet,
      ikon: Icons.biotech_outlined,
      renk: renk,
      detaylar: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _miniBilgiHap('Fiziksel', '$fizikselCita çıta'),
            if (islevselOrta > 0) _miniBilgiHap('İşlevsel', '${_kg(islevselOrta)} çıta'),
            _miniBilgiHap('Toplam hacim', '%$yuzde'),
            if (eklenenCita > 0) _miniBilgiHap('Eklenen', '$eklenenCita çıta'),
            if (oncekiCita > 0) _miniBilgiHap('Önceki', '$oncekiCita çıta'),
            if (temel > 0) _miniBilgiHap('Temel', temel.toString()),
            if (kabarmis > 0) _miniBilgiHap('Kabarmış', kabarmis.toString()),
            if (petekTipi.isNotEmpty) _miniBilgiHap('Petek', petekTipi),
            if (kalanGun > 0) _miniBilgiHap('Kalan', '$kalanGun gün'),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: toplamOran,
            minHeight: 8,
            backgroundColor: renk.withOpacity(0.10),
            color: renk,
          ),
        ),
        if (hacimTipiMetni.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            hacimTipiMetni,
            style: const TextStyle(fontSize: 12.4, height: 1.42, fontWeight: FontWeight.w700),
          ),
        ],
      ],
    );
  }


  Widget _yonetimKarariSatiri(Map<String, dynamic> karar) {
    final baslik = _metin(karar['baslik'], varsayilan: 'Yönetim kararı');
    final mesaj = _metin(karar['mesaj'], varsayilan: '');
    final gerekce = _metin(karar['gerekce'], varsayilan: '');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.brown.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.brown.withOpacity(0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.add_home_work_outlined, size: 17, color: Colors.brown.shade700),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  baslik,
                  style: TextStyle(
                    fontSize: 12.6,
                    height: 1.32,
                    fontWeight: FontWeight.w900,
                    color: Colors.brown.shade800,
                  ),
                ),
              ),
            ],
          ),
          if (mesaj.isNotEmpty && mesaj != '-') ...[
            const SizedBox(height: 7),
            Text(
              mesaj,
              style: const TextStyle(fontSize: 12.2, height: 1.38, fontWeight: FontWeight.w700),
            ),
          ],
          if (gerekce.isNotEmpty && gerekce != '-') ...[
            const SizedBox(height: 6),
            Text(
              gerekce,
              style: const TextStyle(fontSize: 11.8, height: 1.34, color: Colors.black87),
            ),
          ],
        ],
      ),
    );
  }

  Widget _yonetimDurumuKarti() {
    if (_yonetimKararlariHatasi != null && _yonetimKararlari.isEmpty) {
      return _acilirBilgiKarti(
        baslik: 'Yönetim kararları üretilemedi',
        ozet: 'Saha yönetimi karar hattı bu koloni için sonuç veremedi.',
        ikon: Icons.assignment_turned_in_outlined,
        renk: Colors.deepOrange,
        detaylar: [
          Text(
            'Hata: $_yonetimKararlariHatasi',
            style: const TextStyle(fontSize: 12.4, height: 1.4),
          ),
        ],
      );
    }

    if (_yonetimKararlari.isEmpty) {
      return _acilirBilgiKarti(
        baslik: 'Öne çıkan yönetim kararı yok',
        ozet: 'Süreç, biyolojik sınıf ve sezon birlikte okundu; şu an ayrı bir saha müdahalesi öne çıkmıyor.',
        ikon: Icons.assignment_turned_in_outlined,
        renk: Colors.blueGrey,
        detaylar: const [
          Text(
            'Bu kart artık besleme motorunu ayrı bir gerçeklik olarak okumaz. Besleme, kat, alan, varroa, şurupluk, kış ve hasat sonrası kararları aynı yönetim listesinde değerlendirilir.',
            style: TextStyle(fontSize: 12.4, height: 1.4),
          ),
        ],
      );
    }

    final ilkKarar = _yonetimKararlari.first;
    final kategori = _metin(ilkKarar['kategori'], varsayilan: 'yonetim').toLowerCase();
    final Color renk = kategori == 'veto'
        ? Colors.deepOrange.shade700
        : Colors.brown.shade700;
    final String baslik = 'Yönetim kararları';
    final String ozet = _ilkCumle(
      _metin(ilkKarar['mesaj'], varsayilan: ''),
      varsayilan: _metin(ilkKarar['baslik'], varsayilan: 'Yönetim kararı'),
    );

    return _acilirBilgiKarti(
      baslik: baslik,
      ozet: ozet,
      ikon: Icons.assignment_turned_in_outlined,
      renk: renk,
      rozet: 'Yönetim',
      detaylar: _yonetimKararlari.map(_yonetimKarariSatiri).toList(growable: false),
    );
  }

  Color _beslemeOncelikRengi(String oncelik, bool gerekliMi) {
    final temiz = oncelik.trim().toLowerCase();
    if (temiz == 'kritik') return Colors.red.shade700;
    if (temiz == 'yuksek' || temiz == 'yüksek') return Colors.deepOrange;
    if (temiz == 'orta') return Colors.amber.shade800;
    if (gerekliMi) return Colors.green.shade700;
    return Colors.blueGrey;
  }

  Widget _biyolojikModelSekmesi() {
    if (!_biyolojikModelYuklendi && !_biyolojikModelYukleniyor) {
      Future<void>.microtask(_biyolojikModeliYukle);
    }

    if (_biyolojikModelYukleniyor && _biyolojikModel == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.amber),
      );
    }

    if (_biyolojikModelHatasi != null && _biyolojikModel == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Text(
              'Biyolojik model üretilemedi:\n$_biyolojikModelHatasi',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ),
      );
    }

    final model = _biyolojikModel;
    if (model == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: const Text(
              'Biyolojik model için önce muayene ve çıta verisi gerekir.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.only(
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 120,
      ),
      children: [
        _biyolojikModelKarti(model),
      ],
    );
  }

  Widget _biyolojikModelKarti(Map<String, dynamic> model) {
    final List<Map<String, dynamic>> altKatYerlesim =
    (model['altKatYerlesim'] as List? ?? const <dynamic>[])
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList(growable: false);
    final List<Map<String, dynamic>> ustKatYerlesim =
    (model['ustKatYerlesim'] as List? ?? const <dynamic>[])
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList(growable: false);
    final List<Map<String, dynamic>> ucuncuKatYerlesim =
    (model['ucuncuKatYerlesim'] as List? ?? const <dynamic>[])
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList(growable: false);
    final String kovanGorselNotu =
    _metin(model['kovanGorselNotu'], varsayilan: '');
    final String suruplukKonumMetni =
    _metin(model['suruplukKonumMetni'], varsayilan: '');
    final bool suruplukPenceresiAktif =
        model['suruplukKaldirmaPenceresiAktif'] == true;
    final bool suruplukKaldirildiMi = model['suruplukKaldirildiMi'] == true;
    final String suruplukKaldirmaMesaji =
    _metin(model['suruplukKaldirmaMesaji'], varsayilan: '');
    final String yavruBlok = _metin(model['yavruBlok'], varsayilan: 'Belirsiz');
    final String gelisimAlani = _metin(model['gelisimAlani'], varsayilan: '');
    final String hasatAdayMetni =
    _metin(model['hasatAdayMetni'], varsayilan: '');
    final int toplamCita = _toInt(model['toplamCita']);
    final String yorum = _metin(model['yorum'], varsayilan: '');
    final int ariMin = _toInt(model['tahminiAriMin']);
    final int ariMax = _toInt(model['tahminiAriMax']);
    final double hasatMin = _toDouble(model['hasatPotansiyeliMinKg']);
    final double hasatMax = _toDouble(model['hasatPotansiyeliMaxKg']);
    final double birakMin = _toDouble(model['birakilmasiGerekenBalMinKg']);
    final double birakMax = _toDouble(model['birakilmasiGerekenBalMaxKg']);
    final Map<String, dynamic> kabiliyet = Map<String, dynamic>.from(
      model['kabiliyet'] ?? const <String, dynamic>{},
    );
    final Map<String, dynamic> citaAktivasyon = Map<String, dynamic>.from(
      model['citaAktivasyon'] ?? const <String, dynamic>{},
    );
    final Map<String, dynamic> demografi = Map<String, dynamic>.from(
      model['demografi'] ?? const <String, dynamic>{},
    );
    final int tarlaciYuzde = _toInt(demografi['tarlaciOran']);
    final int bakiciYuzde = _toInt(demografi['bakiciOran']);
    final int gencIsciYuzde = _toInt(demografi['gencIsciOran']);
    final String hamPetekOnerisi =
    _metin(kabiliyet['hamPetekOnerisi'], varsayilan: '');
    final String beslemeOnerisi =
    _metin(kabiliyet['beslemeOnerisi'], varsayilan: '');

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.hive_outlined, color: Color(0xFF2E7D32), size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'BİYOLOJİK DİZİLİM PROJEKSİYONU',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (altKatYerlesim.isNotEmpty || ustKatYerlesim.isNotEmpty) ...[
            _kovanYerlesimGorseli(
              altKat: altKatYerlesim,
              ustKat: ustKatYerlesim,
              ucuncuKat: ucuncuKatYerlesim,
              notMetni: kovanGorselNotu,
              suruplukMetni: suruplukKonumMetni,
              aktivasyon: citaAktivasyon,
            ),
            const SizedBox(height: 12),
          ],
          if (toplamCita >= 8 && hasatAdayMetni.trim().isNotEmpty) ...[
            _hasatProjeksiyonuKarti(
              hasatAdayMetni: hasatAdayMetni,
              hasatMin: hasatMin,
              hasatMax: hasatMax,
              balKgFiyati: _balKgFiyati,
              suruplukPenceresiAktif: suruplukPenceresiAktif,
              suruplukKaldirildiMi: suruplukKaldirildiMi,
              suruplukKaldirmaMesaji: suruplukKaldirmaMesaji,
            ),
            const SizedBox(height: 10),
          ],
          Text(
            'Merkez yavru bloğu: $yavruBlok. Bu blok korunmalı.',
            style: const TextStyle(
              fontSize: 12.7,
              height: 1.4,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          if (gelisimAlani.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              gelisimAlani,
              style: const TextStyle(
                  fontSize: 12.5, height: 1.4, color: Colors.black87),
            ),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _miniBilgiHap('Tahmini arı', '$ariMin–$ariMax'),
              if (hasatMax > 0)
                _miniBilgiHap(
                    'Bal potansiyeli', '${_kg(hasatMin)}–${_kg(hasatMax)} kg'),
              _miniBilgiHap(
                  'Bırakılacak stok', '${_kg(birakMin)}–${_kg(birakMax)} kg'),
              if (_toInt(citaAktivasyon['toplamHacimAktivasyonYuzde']) > 0)
                _miniBilgiHap(
                  'Hacim aktivasyonu',
                  '%${_toInt(citaAktivasyon['toplamHacimAktivasyonYuzde'])}',
                ),
              if (tarlaciYuzde > 0)
                _miniBilgiHap('Tarlacı', '%$tarlaciYuzde'),
              if (bakiciYuzde > 0)
                _miniBilgiHap('Bakıcı', '%$bakiciYuzde'),
              if (gencIsciYuzde > 0)
                _miniBilgiHap('Genç işçi', '%$gencIsciYuzde'),
            ],
          ),
          const SizedBox(height: 10),
          _kabiliyetSatiri('Petek örme', _toInt(kabiliyet['petekOrmePuani'])),
          _kabiliyetSatiri(
              'Yavru bakımı', _toInt(kabiliyet['yavruBakimPuani'])),
          _kabiliyetSatiri(
              'Nektar toplama', _toInt(kabiliyet['nektarToplamaPuani'])),
          _kabiliyetSatiri('Bal işleme', _toInt(kabiliyet['balIslemePuani'])),
          if (hamPetekOnerisi.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              hamPetekOnerisi,
              style: const TextStyle(
                  fontSize: 12.5, height: 1.4, color: Colors.black87),
            ),
          ],
          if (beslemeOnerisi.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              beslemeOnerisi,
              style: const TextStyle(
                  fontSize: 12.5, height: 1.4, color: Colors.black87),
            ),
          ],
          if (yorum.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              yorum,
              style: TextStyle(
                  fontSize: 12.5, height: 1.4, color: Colors.brown.shade700),
            ),
          ],
        ],
      ),
    );
  }

  Widget _hasatProjeksiyonuKarti({
    required String hasatAdayMetni,
    required double hasatMin,
    required double hasatMax,
    required double balKgFiyati,
    required bool suruplukPenceresiAktif,
    required bool suruplukKaldirildiMi,
    required String suruplukKaldirmaMesaji,
  }) {
    final bool hasatCitaVar = hasatAdayMetni.trim().isNotEmpty;
    final String anaMesaj = hasatCitaVar
        ? hasatAdayMetni
        : 'Hasat adayı çıta oluşmadı. Koloni gücü ve dış stok durumuna göre takip et.';

    final String suruplukMesaji;
    if (suruplukKaldirildiMi) {
      suruplukMesaji = '';
    } else if (suruplukPenceresiAktif) {
      suruplukMesaji = suruplukKaldirmaMesaji.trim().isNotEmpty
          ? suruplukKaldirmaMesaji
          : 'Bal akımı yaklaştığı için besleme kısıtı başladı. Şurupluk kovandaysa görselde kalır; yalnızca muayenede kaldırıldı olarak işaretlenirse dizilimden çıkar.';
    } else {
      suruplukMesaji = '';
    }

    final double ekonomikMin = hasatMin * balKgFiyati;
    final double ekonomikMax = hasatMax * balKgFiyati;
    final bool ekonomikGoster = balKgFiyati > 0 && hasatMax > 0;

    String _para(double tutar) {
      if (tutar >= 1000) {
        return '${(tutar / 1000).toStringAsFixed(1).replaceAll('.', ',')} bin ₺';
      }
      return '${tutar.round()} ₺';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFB300), width: 1.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.savings_outlined, color: Color(0xFFFFA000), size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'HASAT PROJEKSİYONU',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF5D4037),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            anaMesaj,
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.4,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          if (hasatMax > 0) ...[
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFFCC80)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tahmini miktar',
                          style: TextStyle(fontSize: 10.5, color: Colors.black54),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${_kg(hasatMin)} – ${_kg(hasatMax)} kg',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF5D4037),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (ekonomikGoster) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FBE7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFDCE775)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Tahmini değer',
                                style: TextStyle(fontSize: 10.5, color: Colors.black54),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7B1FA2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'PRO',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_para(ekonomikMin)} – ${_para(ekonomikMax)}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF33691E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
          ],
          const Text(
            'Yalnızca yavrusuz ve sırlıysa değerlendir. Kuluçkalık güvenliği bozulmamalı.',
            style: TextStyle(fontSize: 12.2, height: 1.4, color: Colors.black54),
          ),
          if (suruplukMesaji.isNotEmpty) ...[
            const SizedBox(height: 7),
            Text(
              suruplukMesaji,
              style: TextStyle(
                fontSize: 11.8,
                height: 1.35,
                color: Colors.brown.shade700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _kovanYerlesimGorseli({
    required List<Map<String, dynamic>> altKat,
    required List<Map<String, dynamic>> ustKat,
    required List<Map<String, dynamic>> ucuncuKat,
    required String notMetni,
    required String suruplukMetni,
    required Map<String, dynamic> aktivasyon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.brown.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (ucuncuKat.isNotEmpty) ...[
            _katBasligi('3. KAT / BALLIK', Icons.view_week_outlined),
            const SizedBox(height: 4),
            _citaSirasi(ucuncuKat, aktivasyon: aktivasyon),
            const SizedBox(height: 9),
          ],
          if (ustKat.isNotEmpty) ...[
            _katBasligi('ÜST KAT / BALLIK', Icons.view_week_outlined),
            const SizedBox(height: 4),
            _citaSirasi(ustKat, aktivasyon: aktivasyon),
            const SizedBox(height: 9),
          ],
          _katBasligi('ALT KAT / KULUÇKALIK', Icons.inventory_2_outlined),
          const SizedBox(height: 4),
          _citaSirasi(altKat, aktivasyon: aktivasyon),
          const SizedBox(height: 7),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: const [
              _LejantHap(renk: Color(0xFFFFD54F), metin: 'Bal/stok'),
              _LejantHap(renk: Color(0xFFFFA726), metin: 'Ballı-polenli'),
              _LejantHap(renk: Color(0xFF8D6E63), metin: 'Yavru'),
              _LejantHap(renk: Color(0xFFFFFFFF), metin: 'Boş çerçeve'),
              _LejantHap(renk: Color(0xFF2E7D32), metin: 'Günlük dolum'),
              _LejantHap(renk: Color(0xFF64B5F6), metin: 'Şurupluk'),
            ],
          ),
          if (suruplukMetni.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              suruplukMetni,
              style: TextStyle(
                fontSize: 11.8,
                height: 1.35,
                fontWeight: FontWeight.w700,
                color: Colors.blueGrey.shade700,
              ),
            ),
          ],
          if (notMetni.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              notMetni,
              style: TextStyle(
                fontSize: 11.5,
                height: 1.35,
                color: Colors.brown.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _katBasligi(String metin, IconData ikon) {
    return Row(
      children: [
        Icon(ikon, size: 16, color: Colors.brown.shade700),
        const SizedBox(width: 6),
        Text(
          metin,
          style: TextStyle(
            fontSize: 11.8,
            fontWeight: FontWeight.w900,
            letterSpacing: .2,
            color: Colors.brown.shade800,
          ),
        ),
      ],
    );
  }

  Widget _citaSirasi(
      List<Map<String, dynamic>> citalar, {
        required Map<String, dynamic> aktivasyon,
      }) {
    if (citalar.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final int adet = citalar.length;
        final double bosluk = adet > 1 ? 3.0 : 0.0;
        final double toplamBosluk = bosluk * (adet - 1);

        // Mevcut genişlikle sığan ideal çıta boyutu
        final double idealGenislik =
        ((constraints.maxWidth - toplamBosluk) / adet)
            .clamp(24.0, 34.0)
            .toDouble();

        // Minimum 24.0 genişlikte toplam gereken alan
        const double minCitaGenislik = 24.0;
        final double toplamGerekenAlan =
            minCitaGenislik * adet + toplamBosluk;

        // Eğer tüm çıtalar sığıyorsa normal Row; sığmıyorsa yatay kaydırılabilir
        final bool sigiyor = toplamGerekenAlan <= constraints.maxWidth;

        final rowChildren = <Widget>[
          for (int i = 0; i < citalar.length; i++) ...[
            SizedBox(
              width: sigiyor ? idealGenislik : minCitaGenislik,
              child: _citaBlogu(citalar[i], aktivasyon: aktivasyon),
            ),
            if (i != citalar.length - 1) SizedBox(width: bosluk),
          ],
        ];

        if (sigiyor) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: rowChildren,
          );
        }

        // Çıtalar sığmıyor → yatay kaydırma
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: rowChildren,
          ),
        );
      },
    );
  }

  Widget _citaBlogu(
      Map<String, dynamic> item, {
        required Map<String, dynamic> aktivasyon,
      }) {
    final String tur = _metin(item['tur'], varsayilan: 'cita');
    final int no = _toInt(item['no']);
    final String kat = _metin(item['kat'], varsayilan: 'alt');
    final String tip = _metin(item['tip'], varsayilan: '');
    final bool anaBolgesi = item['anaBolgesi'] == true;
    final bool surupluk = tur == 'surupluk';
    final bool aktivasyonSurecinde = item['aktivasyonSurecinde'] == true;
    final double aktiflik = surupluk
        ? 1.0
        : (item.containsKey('aktiflik')
        ? _toDouble(item['aktiflik']).clamp(0.0, 1.0).toDouble()
        : 1.0);
    final Color hedefRenk =
    surupluk ? const Color(0xFF64B5F6) : _citaHedefRengi(tip, no, kat);
    final String etiket = surupluk ? 'Ş' : no.toString();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 16,
          child: anaBolgesi
              ? const Text('👑', style: TextStyle(fontSize: 13))
              : const SizedBox.shrink(),
        ),
        _citaGorselGovdesi(
          etiket: etiket,
          hedefRenk: hedefRenk,
          surupluk: surupluk,
          aktivasyonSurecinde: aktivasyonSurecinde,
          aktiflik: aktiflik,
          aktivasyon: aktivasyon,
        ),
      ],
    );
  }

  Widget _citaGorselGovdesi({
    required String etiket,
    required Color hedefRenk,
    required bool surupluk,
    required bool aktivasyonSurecinde,
    required double aktiflik,
    required Map<String, dynamic> aktivasyon,
  }) {
    if (surupluk) {
      return Container(
        height: 68,
        decoration: BoxDecoration(
          color: hedefRenk,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: Colors.blue.shade100, width: .9),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.045),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Text(
            etiket,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      );
    }

    if (!aktivasyonSurecinde || aktiflik >= 0.98) {
      return Container(
        height: 68,
        decoration: BoxDecoration(
          color: hedefRenk,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: Colors.brown.shade200, width: .8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.045),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Text(
            etiket,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 11.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      );
    }

    final int toplamGun = _toInt(aktivasyon['aktivasyonSuresiGun'])
        .clamp(1, 36)
        .toInt();
    final int gecenGun = _toInt(aktivasyon['gecenGun']).clamp(0, toplamGun).toInt();
    final int doluGun = gecenGun > 0
        ? gecenGun
        : (aktiflik * toplamGun).round().clamp(0, toplamGun).toInt();

    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Colors.blueGrey.shade300, width: 1.15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          children: [
            Positioned.fill(
              child: _gunlukAktivasyonDolumu(
                toplamGun: toplamGun,
                doluGun: doluGun,
                renk: hedefRenk,
              ),
            ),
            Center(
              child: Text(
                etiket,
                style: TextStyle(
                  color: doluGun / toplamGun >= 0.45
                      ? Colors.black87
                      : Colors.blueGrey.shade600,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gunlukAktivasyonDolumu({
    required int toplamGun,
    required int doluGun,
    required Color renk,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: List<Widget>.generate(toplamGun, (i) {
        final int yukaridanIndex = i;
        final int alttanIndex = toplamGun - yukaridanIndex;
        final bool dolu = alttanIndex <= doluGun;
        return Expanded(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: i == 0 ? 0 : 0.35),
            color: dolu ? renk : Colors.transparent,
          ),
        );
      }),
    );
  }

  Color _citaHedefRengi(String tip, int no, String kat) {
    final t = tip.toLowerCase();
    final bool aktivasyon = t.contains('aktivasyon');
    final bool biyolojikRolVar = t.contains('yavru') ||
        t.contains('polen') ||
        t.contains('bal') ||
        t.contains('stok');

    if (!aktivasyon || biyolojikRolVar) return _citaRengi(tip);

    if (kat == 'ust' || kat == 'ucuncu' || t.contains('ballık')) return const Color(0xFFFFD54F);
    if (no == 1 || no == 10) return const Color(0xFFFFD54F);
    if (no == 2 || no == 9) return const Color(0xFFFFA726);
    if (no >= 3 && no <= 8) return const Color(0xFF8D6E63);
    return const Color(0xFFFFD54F);
  }

  Color _citaRengi(String tip) {
    final t = tip.toLowerCase();
    if (t.contains('yavru')) return const Color(0xFF8D6E63);
    if (t.contains('polen')) return const Color(0xFFFFA726);
    if (t.contains('bal') || t.contains('stok')) return const Color(0xFFFFD54F);
    return const Color(0xFFFFFFFF);
  }

  String _citaKisaTip(String tip) {
    final t = tip.toLowerCase();
    if (t.contains('yavru') && t.contains('polen')) return 'Yavru';
    if (t.contains('yavru')) return 'Yavru';
    if (t.contains('polen')) return 'Polen';
    if (t.contains('bal') || t.contains('stok')) return 'Bal';
    if (t.contains('ballık')) return 'Bal';
    return 'Alan';
  }

  Widget _kabiliyetSatiri(String baslik, int puan) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              baslik,
              style:
              const TextStyle(fontSize: 11.8, fontWeight: FontWeight.w800),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: (puan.clamp(0, 100)) / 100,
                minHeight: 8,
                backgroundColor: Colors.green.shade50,
                color: puan >= 70
                    ? Colors.green
                    : (puan >= 45 ? Colors.orange : Colors.red),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$puan',
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }

  Widget _miniBilgiHap(String etiket, String deger) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Text(
        '$etiket: $deger',
        style: const TextStyle(fontSize: 11.4, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _surecKarti() {
    final gorunurSurecler = _gorunurSurecler();
    if (gorunurSurecler.isEmpty) return const SizedBox.shrink();

    final sirali = BaglamMotoru.gorunurSurecleriSirala(
      gorunurSurecler,
      anaKarar: null,
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sirali
            .map((s) => _tekSurecKutusu(s, arkaPlan: _arkaPlanSureciMi(s)))
            .toList(growable: false),
      ),
    );
  }

  Widget _surecBolumBasligi({
    required String baslik,
    required IconData ikon,
    required Color renk,
  }) {
    return Row(
      children: [
        Icon(ikon, color: renk, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            baslik,
            style: TextStyle(
              fontSize: 13.6,
              fontWeight: FontWeight.w900,
              color: renk,
            ),
          ),
        ),
      ],
    );
  }

  bool _arkaPlanSureciMi(Map<String, dynamic> surec) {
    return BaglamMotoru.arkaPlanSureciMi(surec);
  }

  Widget _tekSurecKutusu(
      Map<String, dynamic> surec, {
        bool arkaPlan = false,
      }) {
    final baslik = _metin(surec['baslik'], varsayilan: 'Aktif süreç');
    final mesaj = _metin(surec['mesaj'], varsayilan: '');

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(arkaPlan ? 12 : 14),
      decoration: BoxDecoration(
        color: arkaPlan ? const Color(0xFFFFFBF2) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: arkaPlan ? Colors.brown.shade100 : Colors.amber.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (arkaPlan) ...[
                const Icon(
                  Icons.low_priority_rounded,
                  size: 17,
                  color: Color(0xFF8D6E63),
                ),
                const SizedBox(width: 7),
              ],
              Expanded(
                child: Text(
                  baslik,
                  style: TextStyle(
                    fontSize: arkaPlan ? 12.8 : 13.4,
                    fontWeight: FontWeight.w900,
                    color: arkaPlan ? const Color(0xFF6D4C41) : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          if (mesaj.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              mesaj,
              style: TextStyle(
                fontSize: arkaPlan ? 12.3 : 12.8,
                height: 1.45,
                color: arkaPlan ? Colors.brown.shade700 : Colors.black87,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _ustOzetBandi() {
    final sonCita = _toInt(_koloniOzet['sonCita']);
    final maxCita = _toInt(_koloniOzet['maxCitaKapasiye']);
    final balCita = _toInt(_koloniOzet['bal_cita']);
    final anaYili = _metin(_koloniOzet['anaYili']);
    final kaynak = _kaynakMetni();
    final muayeneSayisi = _muayeneler.length;
    final tureyenSayisi = _tureyenler().length;
    final skor = _toInt(_koloniOzet['skor']);

    String temiz(String metin) {
      final s = metin.trim();
      return s.isEmpty || s == '-' ? '—' : s;
    }

    Widget satir(String metin, {FontWeight agirlik = FontWeight.w800}) {
      return Text(
        metin,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12.2,
          height: 1.25,
          fontWeight: agirlik,
          color: Colors.black87,
        ),
      );
    }

    final birinciSatir =
        'Kaynak: ${temiz(kaynak)} • Ana: ${temiz(anaYili)} • Son: $sonCita • Max: $maxCita';
    final ikinciSatir = skor > 0
        ? 'Bal: $balCita • Muayene: $muayeneSayisi • Türeyen: $tureyenSayisi • Skor: $skor'
        : 'Bal: $balCita • Muayene: $muayeneSayisi • Türeyen: $tureyenSayisi';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 9, 12, 5),
      padding: const EdgeInsets.fromLTRB(12, 9, 12, 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.brown.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.018),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          satir(birinciSatir, agirlik: FontWeight.w900),
          const SizedBox(height: 4),
          satir(ikinciSatir),
        ],
      ),
    );
  }

  bool _genetikSurecMetniSizmisMi() {
    final kod = (_secilimDurumu?['kod'] ?? '').toString().trim().toUpperCase();
    final baslik = _normalizeKarsilastirmaMetni(_secilimDurumu?['baslik']);
    final mesaj = _normalizeKarsilastirmaMetni(_secilimDurumu?['mesaj']);
    final birlesik = '$baslik $mesaj';

    return kod.startsWith('SUREC_') ||
        birlesik.contains('ogul sonrasi') ||
        birlesik.contains('ana kazanma') ||
        birlesik.contains('koloniyi ac') ||
        birlesik.contains('gereksiz acma') ||
        birlesik.contains('kovani ac') ||
        birlesik.contains('mudahele etme') ||
        birlesik.contains('mudahale etme');
  }

  String _genetikDetayBasligi() {
    if (_genetikSurecMetniSizmisMi()) {
      return 'Genetik değerlendirme ayrı izleniyor';
    }

    final baslik = _metin(_secilimDurumu?['baslik'], varsayilan: '');
    if (baslik.isNotEmpty && baslik != '-') return baslik;

    final ozet = _genetikOzetBilgisi();
    final ana = _metin(ozet['ana'], varsayilan: 'Genetik değerlendirme');
    return ana == '-' ? 'Genetik değerlendirme' : ana;
  }

  String _genetikDetayOzeti() {
    if (_genetikSurecMetniSizmisMi()) {
      return 'Aktif süreç bilgisi Süreç kartında gösterilir. Bu alan yalnızca donör, veto, üretim/destek rolü ve soy değerlendirmesi için kullanılır.';
    }

    final mesaj = _metin(_secilimDurumu?['mesaj'], varsayilan: '');
    if (mesaj.isNotEmpty && mesaj != '-') return mesaj;

    final ozet = _genetikOzetBilgisi();
    final alt = _metin(ozet['alt'], varsayilan: '');
    if (alt.isNotEmpty && alt != '-') return alt;

    return 'Genetik değerlendirme için süreçten bağımsız seçilim bilgisi hazırlanıyor.';
  }

  Widget _genelDurumAnaKarti() {
    final vurgu = _vurguRengi();
    final tureyenler = _tureyenler();
    final bool surecSizmasi = _genetikSurecMetniSizmisMi();
    final String genetikBaslik = _genetikDetayBasligi();
    final String genetikOzet = _genetikDetayOzeti();
    final String secilimBaslik = surecSizmasi
        ? ''
        : _metin(_secilimDurumu?['baslik'], varsayilan: '');
    final String secilimMesaji = surecSizmasi
        ? ''
        : _metin(_secilimDurumu?['mesaj'], varsayilan: '');

    final detaylar = <Widget>[
      _vurguluMetin(
        genetikOzet,
        renk: surecSizmasi ? Colors.blueGrey : const Color(0xFF1565C0),
        ikon: surecSizmasi
            ? Icons.info_outline_rounded
            : Icons.account_tree_outlined,
        fontSize: 13.0,
        agirlik: FontWeight.w600,
      ),
    ];

    if (!surecSizmasi && (secilimBaslik.isNotEmpty || secilimMesaji.isNotEmpty)) {
      detaylar.add(const SizedBox(height: 10));
      detaylar.add(Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: vurgu.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: vurgu.withOpacity(0.16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (secilimBaslik.isNotEmpty)
              Text(
                secilimBaslik,
                style: const TextStyle(
                  fontSize: 12.7,
                  fontWeight: FontWeight.w900,
                  height: 1.35,
                ),
              ),
            if (secilimMesaji.isNotEmpty && secilimMesaji != '-') ...[
              const SizedBox(height: 5),
              Text(
                secilimMesaji,
                style: const TextStyle(
                  fontSize: 12.2,
                  height: 1.38,
                  color: Colors.black87,
                ),
              ),
            ],
          ],
        ),
      ));
    }

    if (tureyenler.isNotEmpty) {
      detaylar.add(const SizedBox(height: 12));
      detaylar.add(Text(
        'Türeyen koloniler',
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w800,
          color: Colors.grey.shade700,
        ),
      ));
      detaylar.add(const SizedBox(height: 8));
      detaylar.add(Wrap(
        spacing: 6,
        runSpacing: 6,
        children: tureyenler.map((k) {
          final aktifMi = _aktifTureyenler([k]).isNotEmpty;
          final renk = aktifMi ? const Color(0xFF2E7D32) : const Color(0xFFC62828);

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: renk.withOpacity(0.10),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: renk.withOpacity(0.22)),
            ),
            child: Text(
              _metin(k['kovanNo']),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: renk,
              ),
            ),
          );
        }).toList(),
      ));
    }

    if (_soyOzetMetni().trim().isNotEmpty) {
      detaylar.add(const SizedBox(height: 12));
      detaylar.add(_vurguluMetin(
        _soyOzetMetni(),
        renk: const Color(0xFF2E7D32),
        ikon: Icons.insights_outlined,
        fontSize: 13.2,
        agirlik: FontWeight.w600,
      ));
    }

    return _acilirBilgiKarti(
      baslik: 'Genetik değerlendirme',
      ozet: genetikBaslik,
      ikon: Icons.account_tree_outlined,
      renk: surecSizmasi ? Colors.blueGrey : vurgu,
      rozet: secilimBaslik.isEmpty ? null : secilimBaslik,
      detaylar: detaylar,
    );
  }

  Widget _muayenelerSekmesi() {
    if (_muayeneler.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: const Text(
              'Henüz muayene kaydı yok.\n\nAşağıdaki "Muayene Ekle" butonuyla ilk kaydı girebilirsin.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 120,
      ),
      itemCount: _muayeneler.length,
      itemBuilder: (c, i) => _muayeneKarti(_muayeneler[i]),
    );
  }

  Widget _performansSekmesi() {
    final future =
    _performansFuture ??= PerformansOzetiServisi.getir(_koloniId);

    if (!_detayAnalizYuklendi && !_detayAnalizYukleniyor) {
      Future<void>.microtask(_detayAnalizleriYukle);
    }

    return FutureBuilder<PerformansOzeti>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.amber),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Performans özeti üretilemedi:\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Text('Performans özeti verisi bulunamadı.'),
          );
        }

        final veri = snapshot.data!;
        final renk = _skorRengi(veri.genelSkor);

        return ListView(
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            top: 12,
            bottom: MediaQuery.of(context).padding.bottom + 120,
          ),
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: renk, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PERFORMANS ÖZETİ',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              veri.durum.toUpperCase(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: renk,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: renk,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          '%${veri.genelSkor}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: renk.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      veri.genelYorum,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _kriterGrafikKarti(veri.kriterler),
            if (_hatSonmeOzeti.isNotEmpty) _hatDayaniklilikAcilirKarti(),
            if (_detayAnalizYukleniyor) _detayAnalizYukleniyorKarti(),
            if (_detayAnalizHatasi != null) _detayAnalizHataKarti(),
          ],
        );
      },
    );
  }

  Widget _detayAnalizYukleniyorKarti() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.amber,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Detay analizleri yükleniyor...',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detayAnalizHataKarti() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: const Text(
        'Detay analizleri yüklenemedi. Genel karar ve muayene kayıtları kullanılabilir.',
        style: TextStyle(fontSize: 13, height: 1.4, color: Colors.black87),
      ),
    );
  }

  Widget _vurguluMetin(
      String metin, {
        required Color renk,
        required IconData ikon,
        double fontSize = 14,
        FontWeight agirlik = FontWeight.w700,
      }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: renk.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: renk.withOpacity(0.20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ikon, size: 18, color: renk),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              metin,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: agirlik,
                height: 1.45,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _performansMiniKarti({
    required IconData ikon,
    required String etiket,
    required String deger,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade100),
      ),
      child: Column(
        children: [
          Icon(ikon, size: 18, color: Colors.brown),
          const SizedBox(height: 6),
          Text(
            etiket,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            deger,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _muayeneKarti(Map<String, dynamic> m) {
    final cita = _toInt(m['citaSayisi']);
    final yavru = _toInt(m['yavruluCita']);
    final bal = _toInt(m['bal_cita']);
    final tarih = _metin(m['tarih']);

    final tetikler = <_TetikRozeti>[
      if (_toInt(m['ogulBelirtisi']) == 1)
        const _TetikRozeti('Oğul Belirtisi', Color(0xFFD96C63)),
      if (_toInt(m['bolmeYapildi']) == 1)
        const _TetikRozeti('Bölme Yapıldı', Color(0xFF8E24AA)),
      if (_toInt(m['anasizBirakildiMi']) == 1)
        const _TetikRozeti('Anasız Bırakıldı', Color(0xFFEF6C00)),
      if (_toInt(m['ogulAtti']) == 1)
        const _TetikRozeti('Oğul Attı', Color(0xFFC62828)),
      if (_toInt(m['kovanSondu']) == 1)
        const _TetikRozeti('Kovan Söndü', Color(0xFF5D4037)),
      if (_toInt(m['bal_cita']) > 0)
        const _TetikRozeti('Hasat', Color(0xFF2E7D32)),
      if (_toInt(m['disaridanHazirAnaVerildi']) == 1)
        const _TetikRozeti('Hazır Ana Verildi', Color(0xFF1565C0)),
      if (_toInt(m['gunlukKapaliYavruGoruldu']) == 1)
        const _TetikRozeti('Günlük/Kapalı Yavru', Color(0xFF00838F)),
      if (_toInt(m['kapaliYavruluCitaAktarildi']) == 1)
        const _TetikRozeti('Kapalı Yavrulu Çıta', Color(0xFF6D4C41)),
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    tarih,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.brown,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Muayene detayı',
                  onPressed: () => _muayeneDetayAc(m),
                  icon: const Icon(Icons.visibility_outlined,
                      color: Colors.brown),
                ),
                IconButton(
                  tooltip: 'Muayeneyi düzenle',
                  onPressed: () => _muayeneDuzenle(m),
                  icon: const Icon(Icons.edit_outlined, color: Colors.blueGrey),
                ),
                IconButton(
                  tooltip: 'Muayeneyi sil',
                  onPressed: () => _muayeneSil(m),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _performansMiniKarti(
                    ikon: Icons.grid_view_outlined,
                    etiket: 'Çıta',
                    deger: cita.toString(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _performansMiniKarti(
                    ikon: Icons.hive_outlined,
                    etiket: 'Yavrulu',
                    deger: yavru.toString(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _performansMiniKarti(
                    ikon: Icons.inventory_2_outlined,
                    etiket: 'Bal/Hasat',
                    deger: bal.toString(),
                  ),
                ),
              ],
            ),
            if (tetikler.isNotEmpty) ...[
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: tetikler.map((t) => _tetikChip(t)).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tetikChip(_TetikRozeti tetik) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: tetik.renk.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: tetik.renk.withOpacity(0.24)),
      ),
      child: Text(
        tetik.metin,
        style: TextStyle(
          fontSize: 11.6,
          fontWeight: FontWeight.w800,
          color: tetik.renk,
        ),
      ),
    );
  }

  Widget _kriterGrafikKarti(List<KriterOzeti> kriterler) {
    if (kriterler.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bar_chart_rounded, color: Colors.brown),
              SizedBox(width: 8),
              Text(
                'KRİTER BAZLI PERFORMANS',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Colors.brown,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...kriterler.map(_performansKriterGrafikSatiri),
        ],
      ),
    );
  }

  Widget _performansKriterGrafikSatiri(KriterOzeti kriter) {
    final renk = _skorRengi(kriter.skor);
    final oran = (kriter.skor.clamp(0, 100)) / 100.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  kriter.ad,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '%${kriter.skor}',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                  color: renk,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: oran,
              minHeight: 8,
              color: renk,
              backgroundColor: renk.withOpacity(0.12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _maddeKutusu({
    required String baslik,
    required IconData ikon,
    required Color renk,
    required List<String> maddeler,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: renk.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(ikon, color: renk),
              const SizedBox(width: 8),
              Text(
                baslik,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: renk,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...maddeler.map(
                (m) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.circle, size: 8, color: renk),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      m,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _takvimAraligi(dynamic bas, dynamic bit) {
    final b = _takvimTarihMetni(bas);
    final e = _takvimTarihMetni(bit);
    if (b.isEmpty && e.isEmpty) return '';
    if (b.isNotEmpty && e.isEmpty) return b;
    if (b.isEmpty && e.isNotEmpty) return e;
    if (b == e) return b;
    return '$b - $e';
  }

  String _takvimTarihMetni(dynamic deger) {
    final metin = (deger ?? '').toString().trim();
    if (metin.isEmpty || metin == 'null') return '';
    final dt = DateTime.tryParse(metin);
    if (dt == null) return metin;
    final gun = dt.day.toString().padLeft(2, '0');
    final ay = dt.month.toString().padLeft(2, '0');
    return '$gun.$ay.${dt.year}';
  }

  String _anaKazanmaYontemiDetayMetni(dynamic deger) {
    final temiz = (deger ?? '').toString().trim();
    switch (temiz) {
      case 'kapali_meme':
        return 'Hazır kapalı ana memesi var';
      case 'hazir_ana':
        return 'Hazır çiftleşmiş ana verildi';
      case 'kendi_anasi':
      default:
        return 'Kendi anasını yapacak';
    }
  }

  Widget _biyolojiSahaUyarisiKutusu(Map<dynamic, dynamic> uyari) {
    final baslik = (uyari['baslik'] ?? '').toString();
    final mesaj = (uyari['mesaj'] ?? '').toString();
    final neYap = (uyari['neYap'] ?? '').toString();
    final neYapma = (uyari['neYapma'] ?? '').toString();
    final gerekce = (uyari['gerekce'] ?? '').toString();
    final seviye = (uyari['seviye'] ?? 'takip').toString();

    final Color renk = seviye == 'kritik'
        ? Colors.red
        : (seviye == 'uyari' ? Colors.deepOrange : Colors.green);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: renk.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: renk.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (baslik.isNotEmpty)
            Text(
              baslik,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: renk,
              ),
            ),
          if (mesaj.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              mesaj,
              style: const TextStyle(fontSize: 12, height: 1.4),
            ),
          ],
          if (neYap.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Ne yap: $neYap',
              style: const TextStyle(fontSize: 12, height: 1.4),
            ),
          ],
          if (neYapma.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              'Ne yapma: $neYapma',
              style: const TextStyle(fontSize: 12, height: 1.4),
            ),
          ],
          if (gerekce.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              'Neden: $gerekce',
              style: const TextStyle(fontSize: 12, height: 1.4),
            ),
          ],
        ],
      ),
    );
  }

  Widget _biyolojiDurumKarti(Map<String, dynamic> veri) {
    final String baslik = (veri['baslik'] ?? 'Biyolojik takip').toString();
    final String mesaj = (veri['mesaj'] ?? '').toString();
    final String durumKodu = (veri['durumKodu'] ?? '').toString();
    final Color renk = _biyolojiRengi(durumKodu);
    final IconData ikon = _biyolojiIkonu(durumKodu);

    final detaylar = <String>[
      'Meme takibi: ${_metin(veri['memeTakipDurumu'], varsayilan: 'Bilinmiyor')}',
    ];

    Map<dynamic, dynamic>? sahaUyarisi;

    final anasizlik = _toInt(veri['anasizlikGunSayisi']);
    if (anasizlik > 0) {
      detaylar.add('Süreç yaşı: $anasizlik gün');
    }

    final hamVeri = veri['hamVeri'];
    if (hamVeri is Map) {
      final hamSahaUyarisi = hamVeri['sahaUyarisi'];
      if (hamSahaUyarisi is Map) {
        sahaUyarisi = hamSahaUyarisi;
        final gunNo = _toInt(hamSahaUyarisi['gunNo']);
        final baslikUyari = (hamSahaUyarisi['baslik'] ?? '').toString();
        if (gunNo > 0 && baslikUyari.isNotEmpty) {
          detaylar.add('Bugün: $gunNo. gün — $baslikUyari');
        }
      }
      final takvim = hamVeri['takvim'];
      if (takvim is Map) {
        final anaKazanmaYontemi =
        _anaKazanmaYontemiDetayMetni(takvim['anaKazanmaYontemi']);
        detaylar.add('Ana kazanma yöntemi: $anaKazanmaYontemi');

        final memeKapanma = _takvimAraligi(
          takvim['memeKapanmaBaslangic'],
          takvim['memeKapanmaBitis'],
        );
        if (memeKapanma.isNotEmpty) {
          detaylar.add('Tahmini meme kapanma: $memeKapanma');
        }

        final anaCikisi = _takvimAraligi(
          takvim['anaCikisiBaslangic'],
          takvim['anaCikisiBitis'],
        );
        if (anaCikisi.isNotEmpty) {
          detaylar.add('Tahmini ana çıkışı: $anaCikisi');
        }

        final ciftlesme = _takvimAraligi(
          takvim['ciftlesmeBaslangic'],
          takvim['ciftlesmeBitis'],
        );
        if (ciftlesme.isNotEmpty) {
          detaylar.add('Çiftleşme uçuş penceresi: $ciftlesme');
        }

        final yumurtlama = _takvimAraligi(
          takvim['yumurtlamaKontrolBaslangic'],
          takvim['yumurtlamaKontrolBitis'],
        );
        if (yumurtlama.isNotEmpty) {
          detaylar.add('Yumurtlama kontrol penceresi: $yumurtlama');
        }

        final dokunma = _takvimAraligi(
          takvim['kovanaDokunmaBaslangic'],
          takvim['kovanaDokunmaBitis'],
        );
        if (dokunma.isNotEmpty && hamVeri['dokunmaPenceresi'] == true) {
          detaylar.add('Kovana dokunma: $dokunma arasında gereksiz açma.');
        }
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: renk.withOpacity(0.30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(ikon, color: renk),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'BİYOLOJİK DETAY',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: renk,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            baslik,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
          if (mesaj.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              mesaj,
              style: const TextStyle(fontSize: 12, height: 1.45),
            ),
          ],
          const SizedBox(height: 10),
          if (sahaUyarisi != null) ...[
            _biyolojiSahaUyarisiKutusu(sahaUyarisi!),
            const SizedBox(height: 10),
          ],
          ...detaylar.map(
                (e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                '• $e',
                style: const TextStyle(fontSize: 12, height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _soyVeKimlikOzetiKarti() {
    final kaynakTipi =
    _metin(_kimlikOzeti['kaynakTipi'], varsayilan: _kaynakMetni());
    final kaynakKoloni = _metin(_kimlikOzeti['kaynakKoloni'], varsayilan: '-');
    final kokKoloni = _metin(_kimlikOzeti['kokKoloni'], varsayilan: '-');
    final ebeveyn = _metin(_kimlikOzeti['ebeveynKoloni'], varsayilan: '-');
    final sistemKimlik = _metin(_kimlikOzeti['sistemKimlik'], varsayilan: '-');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
              Icon(Icons.account_tree_outlined, color: Colors.brown),
              SizedBox(width: 8),
              Text(
                'SOY VE KİMLİK DETAYI',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Colors.brown,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _bilgiSatiri('Kaynak tipi', kaynakTipi),
          _bilgiSatiri('Kaynak koloni', kaynakKoloni),
          _bilgiSatiri('Ebeveyn koloni', ebeveyn),
          _bilgiSatiri('Kök koloni', kokKoloni),
          _bilgiSatiri('Sistem kimlik', sistemKimlik),
        ],
      ),
    );
  }

  Widget _soyDevamlilikKarti(Map<String, dynamic> veri) {
    final toplam = _toInt(veri['toplamTureyen']);
    final aktif = _toInt(veri['aktifTureyen']);
    final sonen = _toInt(veri['sonenTureyen']);
    final yeni = _toInt(veri['hesabaKatilmayanCokYeni']);
    final yorum = _metin(veri['yorum'], varsayilan: '-');
    final puan = _toInt(veri['puan']);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.green.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.insights_outlined, color: Colors.green),
              SizedBox(width: 8),
              Text(
                'SOY DEVAMLILIK DETAYI',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _performansMiniKarti(
                  ikon: Icons.hub_outlined,
                  etiket: 'Toplam',
                  deger: toplam.toString(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _performansMiniKarti(
                  ikon: Icons.check_circle_outline,
                  etiket: 'Aktif',
                  deger: aktif.toString(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _performansMiniKarti(
                  ikon: Icons.cancel_outlined,
                  etiket: 'Sönen',
                  deger: sonen.toString(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _performansMiniKarti(
                  ikon: Icons.hourglass_bottom,
                  etiket: 'Çok Yeni',
                  deger: yeni.toString(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _vurguluMetin(
            yorum,
            renk: Colors.green,
            ikon: Icons.auto_awesome_outlined,
            fontSize: 13,
            agirlik: FontWeight.w600,
          ),
          const SizedBox(height: 8),
          _bilgiSatiri('Soy puanı', puan.toString()),
        ],
      ),
    );
  }

  Widget _hatDayaniklilikAcilirKarti() {
    final hatSonmeOrani =
    _metin(_hatSonmeOzeti['hatSonmeOrani'], varsayilan: '-');
    final hatDurum = _metin(_hatSonmeOzeti['hatDurum'], varsayilan: '-');
    final yorum = _metin(_hatSonmeOzeti['yorum'], varsayilan: '-');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.deepOrange.withOpacity(0.22)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          leading: const Icon(Icons.shield_outlined, color: Colors.deepOrange),
          title: const Text(
            'HAT DAYANIKLILIK DETAYI',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: Colors.deepOrange,
            ),
          ),
          subtitle: Text(
            'Durum: $hatDurum • Sönme oranı: $hatSonmeOrani',
            style: const TextStyle(fontSize: 11.5, color: Colors.black54),
          ),
          children: [
            _bilgiSatiri('Hat sönme oranı', hatSonmeOrani),
            _bilgiSatiri('Hat durumu', hatDurum),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                yorum,
                style: const TextStyle(fontSize: 12, height: 1.45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hatDayaniklilikKarti() {
    final hatSonmeOrani =
    _metin(_hatSonmeOzeti['hatSonmeOrani'], varsayilan: '-');
    final hatDurum = _metin(_hatSonmeOzeti['hatDurum'], varsayilan: '-');
    final yorum = _metin(_hatSonmeOzeti['yorum'], varsayilan: '-');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.deepOrange.withOpacity(0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.shield_outlined, color: Colors.deepOrange),
              SizedBox(width: 8),
              Text(
                'HAT DAYANIKLILIK DETAYI',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _bilgiSatiri('Hat sönme oranı', hatSonmeOrani),
          _bilgiSatiri('Hat durumu', hatDurum),
          const SizedBox(height: 8),
          Text(
            yorum,
            style: const TextStyle(fontSize: 12, height: 1.45),
          ),
        ],
      ),
    );
  }

  Widget _bilgiSatiri(String etiket, String deger) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              etiket,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.blueGrey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              deger,
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TetikRozeti {
  final String metin;
  final Color renk;

  const _TetikRozeti(this.metin, this.renk);
}