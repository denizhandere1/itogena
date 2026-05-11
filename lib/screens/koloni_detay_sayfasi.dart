import 'package:flutter/material.dart';
import 'ana_sayfa_kisayol.dart';
import '../services/veritabani_servisi.dart';
import '../services/karar_asistan_servisi.dart';
import '../services/performans_ozeti_servisi.dart';
import '../services/ari_biyoloji_servisi.dart';
import '../services/soy_devamlilik_servisi.dart';
import '../services/yorum_motoru.dart';
import '../services/baglam_motoru.dart';
import '../services/koloni_biyolojik_model_servisi.dart';
import '../services/cita_aktivasyon_servisi.dart';
import '../services/besleme_karar_motoru.dart';
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
  Map<String, dynamic>? _beslemeKarari;
  Object? _beslemeKarariHatasi;
  Map<String, dynamic>? _hacimAktivasyon;
  Object? _hacimAktivasyonHatasi;

  Future<PerformansOzeti>? _performansFuture;
  bool _detayAnalizYukleniyor = false;
  bool _detayAnalizYuklendi = false;
  Object? _detayAnalizHatasi;
  int _detayYuklemeToken = 0;

  DateTime? _balAkimTarihi;
  DateTime? _balAkimBitisTarihi;
  String? _balAkimEtiketi;

  bool _yukleniyor = true;

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
        _beslemeKarari = null;
        _beslemeKarariHatasi = null;
        _hacimAktivasyon = null;
        _hacimAktivasyonHatasi = null;
      });
    }

    final temelSonuclar = await Future.wait<dynamic>([
      VeritabaniServisi.koloniOzetiGetir(_koloniId),
      VeritabaniServisi.muayeneleriGetir(_koloniId),
    ]);

    final koloniOzet = Map<String, dynamic>.from(temelSonuclar[0]);
    final muayeneler = List<Map<String, dynamic>>.from(temelSonuclar[1]);

    final surecDurumu = await KararAsistanServisi.surecDurumuGetir(
      _koloniId,
      hazirKoloni: koloniOzet,
      hazirMuayeneler: muayeneler,
      forceRefresh: true,
    );

    final ikincilSonuclar = await Future.wait<dynamic>([
      KararAsistanServisi.anaKararUret(_koloniId, koloniOzet),
      VeritabaniServisi.aktifBalAkimGetir(),
    ]);

    final anaKarar = Map<String, String>.from(ikincilSonuclar[0]);
    final akim = ikincilSonuclar[1] as Map<String, dynamic>?;

    if (!mounted || token != _detayYuklemeToken) return;

    setState(() {
      _koloniOzet = koloniOzet;
      _muayeneler = muayeneler;
      _anaKarar = anaKarar;
      _aktifSurecler = List<Map<String, dynamic>>.from(
        surecDurumu['aktifSurecler'] ?? const <Map<String, dynamic>>[],
      );
      _balAkimTarihi = akim?['bas'] as DateTime?;
      _balAkimBitisTarihi = akim?['bit'] as DateTime?;
      _balAkimEtiketi = akim?['etiket']?.toString();
      _beslemeKarari = null;
      _beslemeKarariHatasi = null;
      _yukleniyor = false;
    });

    _ilkEkranSonrasiHafifVerileriYukle(token);
    Future<void>.delayed(
      const Duration(milliseconds: 180),
      () => _beslemeKarariniYukle(token),
    );
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
      final sonuclar = await Future.wait<dynamic>([
        VeritabaniServisi.kolonileriGetir(),
        KararAsistanServisi.secilimDurumuGetir(_koloniId, _koloniOzet),
      ]);

      if (!mounted || token != _detayYuklemeToken) return;

      setState(() {
        _tumKoloniler = List<Map<String, dynamic>>.from(sonuclar[0]);
        _secilimDurumu = Map<String, String>.from(sonuclar[1]);
      });
    } catch (_) {
      // Bu veriler ilk ekran için zorunlu değildir; hata ana ekranı bloklamaz.
    }
  }

  Future<void> _beslemeKarariniYukle(int token) async {
    try {
      final sonuc = await BeslemeKararMotoru.kararGetir(_koloniId);
      if (!mounted || token != _detayYuklemeToken) return;

      setState(() {
        _beslemeKarari = sonuc.toMap();
        _beslemeKarariHatasi = null;
      });
    } catch (e) {
      if (!mounted || token != _detayYuklemeToken) return;

      setState(() {
        _beslemeKarari = null;
        _beslemeKarariHatasi = e;
      });
    }
  }

  Future<void> _hacimAktivasyonunuYukle(int token) async {
    try {
      final sonMuayene = _muayeneler.isNotEmpty ? _muayeneler.first : null;
      final oncekiMuayene = _muayeneler.length >= 2 ? _muayeneler[1] : null;
      Map<String, dynamic> suruplukPenceresi = const <String, dynamic>{};

      try {
        suruplukPenceresi =
            await VeritabaniServisi.suruplukKaldirmaPenceresiGetir(_koloniId);
      } catch (_) {
        suruplukPenceresi = const <String, dynamic>{};
      }

      final aktivasyon = CitaAktivasyonServisi.hesapla(
        sonMuayene: sonMuayene,
        oncekiMuayene: oncekiMuayene,
        trend: const <String, dynamic>{},
        suruplukPenceresi: suruplukPenceresi,
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
      final model = await KoloniBiyolojikModelServisi.modelGetir(
        _koloniId,
        forceRefresh: forceRefresh,
      );
      if (!mounted || token != _detayYuklemeToken) return;

      setState(() {
        _biyolojikModel = Map<String, dynamic>.from(model);
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

    return BaglamMotoru.gorunurSurecleriSirala(
      _aktifSurecler,
      anaKarar: _anaKarar,
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
    final secilimBaslik = _metin(_secilimDurumu?['baslik'], varsayilan: '');
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
    final secilimMesaji = _metin(_secilimDurumu?['mesaj'], varsayilan: '');

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
      KararAsistanServisi.koloniCacheTemizle(_koloniId);
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
      KararAsistanServisi.koloniCacheTemizle(_koloniId);
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
    KararAsistanServisi.arilikCacheTemizle(_toInt(_koloniOzet['arilikId']));
    KararAsistanServisi.koloniCacheTemizle(_koloniId);

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
    KararAsistanServisi.arilikCacheTemizle(_toInt(_koloniOzet['arilikId']));

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
    return Scaffold(
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
    );
  }

  Widget _genelDurumSekmesi() {
    return ListView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 120,
      ),
      children: [
        _ustOzetBandi(),
        _genelDurumAnaKarti(),
        _hacimAktivasyonKarti(),
        _beslemeDurumuKarti(),
        if (_surecModuAktif) _surecKarti(),
      ],
    );
  }

  Widget _hacimAktivasyonKarti() {
    final aktivasyon = _hacimAktivasyon;
    if (aktivasyon == null || aktivasyon.isEmpty) {
      return const SizedBox.shrink();
    }

    final int eklenenCita = _toInt(aktivasyon['eklenenCita']);
    final int aktivasyonSuresi = _toInt(aktivasyon['aktivasyonSuresiGun']);
    final int gecenGun = _toInt(aktivasyon['gecenGun']);
    final String seviye =
        _metin(aktivasyon['uyariSeviyesi'], varsayilan: 'yok').toLowerCase();
    final bool tamamlandi =
        aktivasyonSuresi > 0 && gecenGun >= aktivasyonSuresi;
    if (eklenenCita <= 0 || seviye == 'yok' || tamamlandi) {
      return const SizedBox.shrink();
    }

    final bool kritik = seviye == 'kritik';
    final Color renk = kritik ? Colors.deepOrange : Colors.amber.shade800;
    final String mesaj = _metin(aktivasyon['mesaj'],
        varsayilan: 'Yeni verilen peteklerin biyolojik aktivasyonu sürüyor.');
    final String ozet = _metin(aktivasyon['ozet'], varsayilan: '');
    final int temel = _toInt(aktivasyon['temelPetekAdedi']);
    final int kabarmis = _toInt(aktivasyon['kabarmisPetekAdedi']);
    final double islevselMin = _toDouble(aktivasyon['islevselCitaMin']);
    final double islevselMax = _toDouble(aktivasyon['islevselCitaMax']);
    final double oran =
        _toDouble(aktivasyon['aktivasyonOrani']).clamp(0.0, 1.0).toDouble();
    final int kalanGun = aktivasyonSuresi > 0
        ? (aktivasyonSuresi - gecenGun).clamp(0, 999).toInt()
        : 0;
    final bool bilgiModu = gecenGun >= 3 && !kritik;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: renk.withOpacity(bilgiModu ? 0.26 : 0.44), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: renk.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                bilgiModu ? Icons.info_outline : Icons.warning_amber_rounded,
                color: renk,
                size: 21,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  bilgiModu
                      ? 'HACİM AKTİVASYONU SÜRÜYOR'
                      : 'HIZLI HACİM ARTIŞI',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: renk,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            mesaj,
            style: const TextStyle(
                fontSize: 12.7, height: 1.42, fontWeight: FontWeight.w700),
          ),
          if (ozet.isNotEmpty && ozet != mesaj) ...[
            const SizedBox(height: 7),
            Text(
              ozet,
              style: const TextStyle(
                  fontSize: 12.2, height: 1.38, color: Colors.black87),
            ),
          ],
          const SizedBox(height: 9),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _miniBilgiHap('Eklenen', '$eklenenCita çıta'),
              if (temel > 0) _miniBilgiHap('Temel', temel.toString()),
              if (kabarmis > 0) _miniBilgiHap('Kabarmış', kabarmis.toString()),
              if (islevselMax > 0)
                _miniBilgiHap(
                    'İşlevsel', '${_kg(islevselMin)}–${_kg(islevselMax)}'),
              if (kalanGun > 0) _miniBilgiHap('Kalan', '$kalanGun gün'),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: oran,
              minHeight: 8,
              backgroundColor: Colors.orange.shade50,
              color: renk,
            ),
          ),
          const SizedBox(height: 9),
          const Text(
            'Sıkışık düzen bozulursa kovan sıcaklığı korunmakta zorlanabilir, yavru alanı dağılabilir, savunma yükü artabilir ve petek güvesi riski yükselebilir. Görselde aktivasyon süresi gün birimlerine bölünür; her geçen gün ilgili çıtanın hedef biyolojik rengi alttan yukarı doğru bir kademe dolar.',
            style:
                TextStyle(fontSize: 12.1, height: 1.38, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _beslemeDurumuKarti() {
    final karar = _beslemeKarari;

    if (_beslemeKarariHatasi != null && karar == null) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Text(
          'Besleme kararı üretilemedi: $_beslemeKarariHatasi',
          style: const TextStyle(
            fontSize: 12.5,
            height: 1.4,
            color: Colors.black87,
          ),
        ),
      );
    }

    if (karar == null) {
      return const SizedBox.shrink();
    }

    final bool gerekliMi = karar['gerekliMi'] == true;
    final String tip = _metin(karar['tip'], varsayilan: 'İzle');
    final String oncelik = _metin(karar['oncelik'], varsayilan: 'dusuk');
    final String mesaj = _metin(karar['mesaj'], varsayilan: '');
    final String risk = _metin(karar['risk'], varsayilan: '');
    final String dozBandi = _metin(karar['dozBandi'], varsayilan: '');
    final String tekrarAraligi = _metin(karar['tekrarAraligi'], varsayilan: '');
    final String dozNotu = _metin(karar['dozNotu'], varsayilan: '');
    final List<String> gerekceler =
        (karar['gerekceler'] as List? ?? const <dynamic>[])
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList(growable: false);

    final Color renk = _beslemeOncelikRengi(oncelik, gerekliMi);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: renk.withOpacity(0.42), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: renk.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: renk.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.water_drop_outlined,
                  color: renk,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'BESLEME DURUMU',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Colors.brown,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: renk.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: renk.withOpacity(0.22)),
                ),
                child: Text(
                  tip,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                    color: renk,
                  ),
                ),
              ),
            ],
          ),
          if (mesaj.isNotEmpty && mesaj != '-') ...[
            const SizedBox(height: 10),
            Text(
              mesaj,
              style: const TextStyle(
                fontSize: 13.2,
                height: 1.45,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
          if (gerekceler.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...gerekceler.take(3).map(
                  (g) => Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle_outline, size: 15, color: renk),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            g,
                            style: const TextStyle(
                              fontSize: 12.2,
                              height: 1.35,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
          if (dozBandi.isNotEmpty && dozBandi != '-') ...[
            const SizedBox(height: 9),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: renk.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: renk.withOpacity(0.16)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tahmini destek bandı: $dozBandi',
                    style: const TextStyle(
                      fontSize: 12.4,
                      height: 1.35,
                      color: Colors.black87,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (tekrarAraligi.isNotEmpty && tekrarAraligi != '-') ...[
                    const SizedBox(height: 4),
                    Text(
                      tekrarAraligi,
                      style: const TextStyle(
                        fontSize: 12.1,
                        height: 1.35,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if (dozNotu.isNotEmpty && dozNotu != '-') ...[
                    const SizedBox(height: 4),
                    Text(
                      dozNotu,
                      style: const TextStyle(
                        fontSize: 11.8,
                        height: 1.35,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          if (risk.isNotEmpty && risk != '-') ...[
            const SizedBox(height: 9),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.18)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 17,
                    color: Colors.deepOrange,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      risk,
                      style: const TextStyle(
                        fontSize: 12.2,
                        height: 1.35,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
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
              notMetni: kovanGorselNotu,
              suruplukMetni: suruplukKonumMetni,
              aktivasyon: citaAktivasyon,
            ),
            const SizedBox(height: 12),
          ],
          if (toplamCita >= 8 && hasatAdayMetni.trim().isNotEmpty) ...[
            _hasatOnerisiKarti(
              hasatAdayMetni: hasatAdayMetni,
              hasatMin: hasatMin,
              hasatMax: hasatMax,
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

  Widget _hasatOnerisiKarti({
    required String hasatAdayMetni,
    required double hasatMin,
    required double hasatMax,
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
      suruplukMesaji =
          'Şurupluk kaldırılmış. Hasat öncesi dizilim buna göre modelleniyor.';
    } else if (suruplukPenceresiAktif) {
      suruplukMesaji = suruplukKaldirmaMesaji.trim().isNotEmpty
          ? suruplukKaldirmaMesaji
          : 'Bal akımı yaklaştığı için besleme kısıtı başladı. Şurupluk kovandaysa görselde kalır; yalnızca muayenede kaldırıldı olarak işaretlenirse dizilimden çıkar.';
    } else {
      suruplukMesaji = '';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFB300), width: 1.1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.hive_outlined,
            color: Color(0xFFFFA000),
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'HASAT ÖNERİSİ',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF5D4037),
                      ),
                    ),
                    if (hasatMax > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0xFFFFCC80)),
                        ),
                        child: Text(
                          '${_kg(hasatMin)}–${_kg(hasatMax)} kg potansiyel',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF5D4037),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  'Hasat adayı çıtalar: $anaMesaj',
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.35,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Yalnızca yavrusuz ve sırlıysa değerlendir. Kuluçkalık güvenliği bozulmamalı.',
                  style: TextStyle(
                    fontSize: 12.2,
                    height: 1.35,
                    color: Colors.black87,
                  ),
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
          ),
        ],
      ),
    );
  }

  Widget _kovanYerlesimGorseli({
    required List<Map<String, dynamic>> altKat,
    required List<Map<String, dynamic>> ustKat,
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
        final double genislik = ((constraints.maxWidth - toplamBosluk) / adet)
            .clamp(24.0, 34.0)
            .toDouble();

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (int i = 0; i < citalar.length; i++) ...[
              SizedBox(
                width: genislik,
                child: _citaBlogu(citalar[i], aktivasyon: aktivasyon),
              ),
              if (i != citalar.length - 1) SizedBox(width: bosluk),
            ],
          ],
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

    if (kat == 'ust' || t.contains('ballık')) return const Color(0xFFFFD54F);
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

    Widget hap(String etiket, String deger,
        {Color renk = const Color(0xFF5D4037)}) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: renk.withOpacity(0.08),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: renk.withOpacity(0.18)),
        ),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 11.6, color: Colors.black87),
            children: [
              TextSpan(
                  text: '$etiket ',
                  style: TextStyle(fontWeight: FontWeight.w700, color: renk)),
              TextSpan(
                  text: deger,
                  style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _vurguRengi().withOpacity(0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KOVAN $_kovanNo',
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              hap('Kaynak:', kaynak, renk: const Color(0xFF6D4C41)),
              hap('Ana:', anaYili, renk: const Color(0xFF455A64)),
              hap('Son:', sonCita.toString(), renk: const Color(0xFF2E7D32)),
              hap('Max:', maxCita.toString(), renk: const Color(0xFF6A1B9A)),
              hap('Bal:', balCita.toString(), renk: const Color(0xFFEF6C00)),
              hap('Muayene:', muayeneSayisi.toString(),
                  renk: const Color(0xFF00838F)),
              hap('Türeyen:', tureyenSayisi.toString(),
                  renk: const Color(0xFF7B1FA2)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _genelDurumAnaKarti() {
    final vurgu = _vurguRengi();
    final tureyenler = _tureyenler();

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: vurgu.withOpacity(0.28), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: vurgu.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: vurgu,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _vurguluMetin(
                  _kararMetni(),
                  renk: vurgu,
                  ikon: Icons.rule_folder_outlined,
                  fontSize: 14.2,
                  agirlik: FontWeight.w800,
                ),
                const SizedBox(height: 8),
                _vurguluMetin(
                  _kararOzetMetni(),
                  renk: const Color(0xFF1565C0),
                  ikon: Icons.build_circle_outlined,
                  fontSize: 13.2,
                  agirlik: FontWeight.w600,
                ),
                if (tureyenler.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Türeyen koloniler',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: tureyenler.map((k) {
                      final aktifMi = _aktifTureyenler([k]).isNotEmpty;
                      final renk = aktifMi
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFC62828);

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
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
                  ),
                ],
                if (_soyOzetMetni().trim().isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _vurguluMetin(
                    _soyOzetMetni(),
                    renk: const Color(0xFF2E7D32),
                    ikon: Icons.insights_outlined,
                    fontSize: 14,
                    agirlik: FontWeight.w600,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
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
