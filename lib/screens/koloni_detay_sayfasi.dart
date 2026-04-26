import 'package:flutter/material.dart';
import 'ana_sayfa_kisayol.dart';
import '../services/veritabani_servisi.dart';
import '../services/karar_asistan_servisi.dart';
import '../services/performans_ozeti_servisi.dart';
import '../services/ari_biyoloji_servisi.dart';
import '../services/soy_devamlilik_servisi.dart';
import '../services/yorum_motoru.dart';
import 'muayene_ekle_sayfasi.dart';
import 'muayene_detay_sayfasi.dart';

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
  Map<String, dynamic>? _soyDevamlilikAnalizi;
  List<Map<String, dynamic>> _aktifSurecler = [];

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
    _tabController = TabController(length: 3, vsync: this);
    _verileriYukle();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _verileriYukle() async {
    if (mounted) {
      setState(() => _yukleniyor = true);
    }

    final koloniOzet = await VeritabaniServisi.koloniOzetiGetir(_koloniId);
    final muayeneler = await VeritabaniServisi.muayeneleriGetir(_koloniId);
    final tumKoloniler = await VeritabaniServisi.kolonileriGetir();
    final anaKarar =
    await KararAsistanServisi.anaKararUret(_koloniId, koloniOzet);
    final secilimDurumu = await KararAsistanServisi.secilimDurumuGetir(
      _koloniId,
      koloniOzet,
    );
    final kimlikOzeti =
    await VeritabaniServisi.koloniHikayeOzetiGetir(_koloniId);
    final hatSonmeOzeti =
    await VeritabaniServisi.hatSonmeAnaliziGetir(_koloniId);
    final biyolojiAnalizi = await AriBiyolojiServisi.analizMapiGetir(_koloniId);
    final soyDevamlilikAnalizi =
    (await SoyDevamlilikServisi.analizYap(_koloniId)).toMap();
    final surecDurumu = await KararAsistanServisi.surecDurumuGetir(_koloniId);

    final balAkim1BaslangicStr = await VeritabaniServisi.ayarStringGetir(
      'bal_akim1_baslangic',
      varsayilan: '',
    );
    final balAkim1BitisStr = await VeritabaniServisi.ayarStringGetir(
      'bal_akim1_bitis',
      varsayilan: '',
    );

    final balAkim2AktifStr = await VeritabaniServisi.ayarStringGetir(
      'bal_akim2_aktif',
      varsayilan: '0',
    );
    final balAkim2BaslangicStr = await VeritabaniServisi.ayarStringGetir(
      'bal_akim2_baslangic',
      varsayilan: '',
    );
    final balAkim2BitisStr = await VeritabaniServisi.ayarStringGetir(
      'bal_akim2_bitis',
      varsayilan: '',
    );

    final bugun = _sadeceGun(DateTime.now());
    final yil = bugun.year;
    final bool balAkim2Aktif = balAkim2AktifStr == '1';

    final adaylar = <Map<String, dynamic>>[];

    final akim1Bas = _mmDdToDateTime(balAkim1BaslangicStr, yil);
    final akim1Bit = _mmDdToDateTime(balAkim1BitisStr, yil);
    if (akim1Bas != null && akim1Bit != null && !akim1Bit.isBefore(akim1Bas)) {
      adaylar.add({
        'etiket': '1. bal akımı',
        'baslangic': akim1Bas,
        'bitis': akim1Bit,
      });
    }

    if (balAkim2Aktif) {
      final akim2Bas = _mmDdToDateTime(balAkim2BaslangicStr, yil);
      final akim2Bit = _mmDdToDateTime(balAkim2BitisStr, yil);
      if (akim2Bas != null &&
          akim2Bit != null &&
          !akim2Bit.isBefore(akim2Bas)) {
        adaylar.add({
          'etiket': '2. bal akımı',
          'baslangic': akim2Bas,
          'bitis': akim2Bit,
        });
      }
    }

    adaylar.sort(
          (a, b) =>
          (a['baslangic'] as DateTime).compareTo(b['baslangic'] as DateTime),
    );

    DateTime? secilenBaslangic;
    DateTime? secilenBitis;
    String? secilenEtiket;

    for (final akim in adaylar) {
      final bas = akim['baslangic'] as DateTime;
      final bit = akim['bitis'] as DateTime;
      if (!bugun.isAfter(bit)) {
        secilenBaslangic = bas;
        secilenBitis = bit;
        secilenEtiket = akim['etiket'] as String;
        break;
      }
    }

    if (!mounted) return;

    setState(() {
      _koloniOzet = koloniOzet;
      _muayeneler = muayeneler;
      _tumKoloniler = tumKoloniler;
      _anaKarar = anaKarar;
      _secilimDurumu = secilimDurumu;
      _kimlikOzeti = kimlikOzeti;
      _hatSonmeOzeti = hatSonmeOzeti;
      _biyolojiAnalizi = biyolojiAnalizi;
      _soyDevamlilikAnalizi = soyDevamlilikAnalizi;
      _aktifSurecler = List<Map<String, dynamic>>.from(
        surecDurumu['aktifSurecler'] ?? const <Map<String, dynamic>>[],
      );
      _balAkimTarihi = secilenBaslangic;
      _balAkimBitisTarihi = secilenBitis;
      _balAkimEtiketi = secilenEtiket;
      _yukleniyor = false;
    });
  }

  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }

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

  List<Map<String, dynamic>> _aktifTureyenler(List<Map<String, dynamic>> liste) {
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

  bool get _surecModuAktif => _aktifSurecler.isNotEmpty;

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

  DateTime? _mmDdToDateTime(String mmdd, int yil) {
    final temiz = mmdd.trim();
    if (temiz.isEmpty) return null;

    final parts = temiz.split('-');
    if (parts.length != 2) return null;

    final ay = int.tryParse(parts[0]);
    final gun = int.tryParse(parts[1]);

    if (ay == null || gun == null) return null;

    return DateTime(yil, ay, gun);
  }

  DateTime _sadeceGun(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  String _tarihFormatla(DateTime dt) {
    final gun = dt.day.toString().padLeft(2, '0');
    final ay = dt.month.toString().padLeft(2, '0');
    final yil = dt.year.toString();
    return '$gun.$ay.$yil';
  }

  String? _balAkimiKararMetni() {
    final balAkim = _balAkimTarihi;
    final balAkimBitis = _balAkimBitisTarihi;
    if (balAkim == null || balAkimBitis == null) return null;

    final bugun = _sadeceGun(DateTime.now());
    final balAkimGun = _sadeceGun(balAkim);
    final balAkimBitisGun = _sadeceGun(balAkimBitis);

    final uyariBaslangici = balAkimGun.subtract(const Duration(days: 57));
    final sonGuvenliBolme = balAkimGun.subtract(const Duration(days: 42));

    if (bugun.isBefore(uyariBaslangici)) return null;
    if (bugun.isAfter(balAkimBitisGun)) return null;

    final sonCita = _toInt(_koloniOzet['sonCita']);
    int maxAlinabilir = sonCita - 7;
    if (maxAlinabilir < 0) maxAlinabilir = 0;

    final etiket = _balAkimEtiketi == null ? '' : '${_balAkimEtiketi!} için ';

    if (bugun.isBefore(sonGuvenliBolme)) {
      if (maxAlinabilir <= 0) {
        return '${etiket}bölme için kritik döneme girildi. ${_tarihFormatla(sonGuvenliBolme)} tarihine kadar bu koloni 7 çıtanın altına düşmeden bölünecek güçte değildir.';
      }
      return '${etiket}bölme için kritik döneme girildi. ${_tarihFormatla(sonGuvenliBolme)} tarihine kadar, bu koloni 7 çıtanın altına düşürülmeden en fazla $maxAlinabilir çıta alınabilir.';
    }

    return '${etiket}üretim hedefi korunacaksa güvenli bölme penceresi kapandı.';
  }

  Color _varroaRenk(String seviye) {
    switch (seviye) {
      case 'kritik':
        return const Color(0xFFC62828);
      case 'risk':
        return const Color(0xFFEF6C00);
      case 'iyi':
        return const Color(0xFF2E7D32);
      default:
        return const Color(0xFF1565C0);
    }
  }

  IconData _varroaIkon(String seviye) {
    switch (seviye) {
      case 'kritik':
        return Icons.emergency_outlined;
      case 'risk':
        return Icons.warning_amber_rounded;
      case 'iyi':
        return Icons.verified_outlined;
      default:
        return Icons.calendar_month_outlined;
    }
  }

  Widget _varroaTakvimKarti() {
    final veri = KararAsistanServisi.varroaTakvimHatirlatmasiGetir(
      _muayeneler,
      balAkimBaslangici: _balAkimTarihi,
    );
    final seviye = (veri['seviye'] ?? 'bilgi').toString();
    if (seviye == 'bilgi') return const SizedBox.shrink();
    final renk = _varroaRenk(seviye);
    final baslik =
    _metin(veri['baslik'], varsayilan: 'Varroa takvimi izlenmeli.');
    final gerekce = _metin(veri['gerekce'], varsayilan: '');
    final oneriler = (veri['oneriler'] as List?)
        ?.map((e) => e.toString())
        .where((e) => e.trim().isNotEmpty)
        .toList() ??
        <String>[];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: renk.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: renk.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_varroaIkon(seviye), color: renk, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  baslik,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: renk,
                  ),
                ),
              ),
            ],
          ),
          if (gerekce.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              gerekce,
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.45,
                color: Colors.black87,
              ),
            ),
          ],
          if (oneriler.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text(
              'Öneri:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            ...oneriler.take(3).map(
                  (madde) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: renk,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        madde,
                        style: const TextStyle(
                          fontSize: 12.5,
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
        ],
      ),
    );
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
          labelColor: Colors.black,
          indicatorColor: Colors.brown,
          tabs: const [
            Tab(text: 'GENEL DURUM'),
            Tab(text: 'MUAYENELER'),
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
        if (_surecModuAktif)
          _surecKarti()
        else
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: _genelDurumAnaKarti(),
          ),
      ],
    );
  }

  Widget _surecKarti() {
    if (_aktifSurecler.isEmpty) return const SizedBox.shrink();

    final sirali = List<Map<String, dynamic>>.from(_aktifSurecler)
      ..sort((a, b) {
        final aOncelik = _surecOnceligi((a['kod'] ?? a['baslik']).toString());
        final bOncelik = _surecOnceligi((b['kod'] ?? b['baslik']).toString());
        return aOncelik.compareTo(bOncelik);
      });

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
        children: [
          const Row(
            children: [
              Icon(Icons.timelapse_rounded, color: Color(0xFFD96C63), size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'AKTİF SÜREÇLER',
                  style: TextStyle(
                    fontSize: 13.6,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFD96C63),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...sirali.map(_tekSurecKutusu),
        ],
      ),
    );
  }

  int _surecOnceligi(String kodVeyaBaslik) {
    final k = kodVeyaBaslik.toLowerCase();

    if (k.contains('anasiz') || k.contains('ana yok')) return 1;
    if (k.contains('oğul riski') || k.contains('ogul riski')) return 2;
    if (k.contains('oğul sonrası') || k.contains('ogul sonrasi')) return 3;
    if (k.contains('bölme sonrası') || k.contains('bolme sonrasi')) return 4;
    if (k.contains('ana değişim') || k.contains('ana degisim')) return 5;
    if (k.contains('hasat sonrası') || k.contains('hasat sonrasi')) return 6;
    if (k.contains('varroa')) return 7;
    return 99;
  }

  Widget _tekSurecKutusu(Map<String, dynamic> surec) {
    final baslik = _metin(surec['baslik'], varsayilan: 'Aktif süreç');
    final mesaj = _metin(surec['mesaj'], varsayilan: '');

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: const TextStyle(
              fontSize: 13.4,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
          if (mesaj.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              mesaj,
              style: const TextStyle(
                fontSize: 12.8,
                height: 1.45,
                color: Colors.black87,
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
                if (_balAkimiKararMetni() != null) ...[
                  const SizedBox(height: 8),
                  _vurguluMetin(
                    _balAkimiKararMetni()!,
                    renk: const Color(0xFFEF6C00),
                    ikon: Icons.schedule_outlined,
                    fontSize: 13.1,
                    agirlik: FontWeight.w600,
                  ),
                ],
                const SizedBox(height: 10),
                _varroaTakvimKarti(),
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
    return FutureBuilder<PerformansOzeti>(
      future: PerformansOzetiServisi.getir(_koloniId),
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
            Container(
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
                      Icon(Icons.table_chart_outlined, color: Colors.brown),
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
                  const SizedBox(height: 12),
                  ...veri.kriterler.map(_performansKriterSatiri),
                ],
              ),
            ),
            if (veri.gucluYonler.isNotEmpty)
              _maddeKutusu(
                baslik: 'GÜÇLÜ YÖNLER',
                ikon: Icons.trending_up,
                renk: Colors.green,
                maddeler: veri.gucluYonler,
              ),
            if (veri.zayifYonler.isNotEmpty)
              _maddeKutusu(
                baslik: 'GERİDE KALAN ALANLAR',
                ikon: Icons.low_priority_outlined,
                renk: Colors.deepOrange,
                maddeler: veri.zayifYonler,
              ),
            if (_biyolojiAnalizi != null) _biyolojiDurumKarti(_biyolojiAnalizi!),
            if (_kimlikOzeti.isNotEmpty) _soyVeKimlikOzetiKarti(),
            if (_soyDevamlilikAnalizi != null)
              _soyDevamlilikKarti(_soyDevamlilikAnalizi!),
            if (_hatSonmeOzeti.isNotEmpty) _hatDayaniklilikKarti(),
          ],
        );
      },
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
                  icon: const Icon(Icons.visibility_outlined, color: Colors.brown),
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

  Widget _performansKriterSatiri(KriterOzeti kriter) {
    final renk = _skorRengi(kriter.skor);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: renk.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: renk.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: renk,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                kriter.skor.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kriter.ad,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  kriter.yorum,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
              ],
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

  Widget _biyolojiDurumKarti(Map<String, dynamic> veri) {
    final String baslik = (veri['baslik'] ?? 'Biyolojik takip').toString();
    final String mesaj = (veri['mesaj'] ?? '').toString();
    final String durumKodu = (veri['durumKodu'] ?? '').toString();
    final Color renk = _biyolojiRengi(durumKodu);
    final IconData ikon = _biyolojiIkonu(durumKodu);

    final detaylar = <String>[
      'Meme takibi: ${_metin(veri['memeTakipDurumu'], varsayilan: 'Bilinmiyor')}',
    ];

    final anasizlik = _toInt(veri['anasizlikGunSayisi']);
    if (anasizlik > 0) {
      detaylar.add('Anasızlık süresi: $anasizlik gün');
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
