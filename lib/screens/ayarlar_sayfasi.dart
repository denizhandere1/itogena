import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'ana_sayfa_kisayol.dart';
import 'kullanici_rehberi_sayfasi.dart' as rehber;
import '../services/veritabani_servisi.dart';
import '../services/karar_asistan_servisi.dart';
import '../services/arilik_uyari_servisi.dart';
import '../services/yedek_dosya_servisi.dart';
import '../services/guncelleme_servisi.dart';
import '../services/premium_servisi.dart';
import '../services/test_ariligi_servisi.dart';

class AyarlarSayfasi extends StatefulWidget {
  const AyarlarSayfasi({super.key});

  @override
  State<AyarlarSayfasi> createState() => _AyarlarSayfasiState();
}

class _AyarlarSayfasiState extends State<AyarlarSayfasi>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _yukleniyor = true;
  bool _kaydediliyor = false;
  bool _yedekAliniyor = false;
  bool _isPro = false;
  bool _yedekYukleniyor = false;
  bool _testAriligiOlusturuluyor = false;

  String _kisBaslangic = VeritabaniServisi.varsayilanAyarDegeri('season_kis_baslangic');
  String _kisBitis = VeritabaniServisi.varsayilanAyarDegeri('season_kis_bitis');
  String _uretimBaslangic = VeritabaniServisi.varsayilanAyarDegeri('season_uretim_baslangic');
  String _uretimBitis = VeritabaniServisi.varsayilanAyarDegeri('season_uretim_bitis');
  String _davranisToleransi = VeritabaniServisi.varsayilanAyarDegeri('davranis_toleransi');

  String _balAkim1Baslangic = VeritabaniServisi.varsayilanAyarDegeri('bal_akim1_baslangic');
  String _balAkim1Bitis = VeritabaniServisi.varsayilanAyarDegeri('bal_akim1_bitis');

  bool _balAkim2Aktif = false;
  String _balAkim2Baslangic = VeritabaniServisi.varsayilanAyarDegeri('bal_akim2_baslangic');
  String _balAkim2Bitis = VeritabaniServisi.varsayilanAyarDegeri('bal_akim2_bitis');

  String _riskAriKusuBaslangic = VeritabaniServisi.varsayilanAyarDegeri('risk_ari_kusu_baslangic');
  String _riskAriKusuBitis = VeritabaniServisi.varsayilanAyarDegeri('risk_ari_kusu_bitis');
  String _riskEsekArisiBaslangic = VeritabaniServisi.varsayilanAyarDegeri('risk_esek_arisi_baslangic');
  String _riskEsekArisiBitis = VeritabaniServisi.varsayilanAyarDegeri('risk_esek_arisi_bitis');
  String _riskYagmacilikBaslangic = VeritabaniServisi.varsayilanAyarDegeri('risk_yagmacilik_baslangic');
  String _riskYagmacilikBitis = VeritabaniServisi.varsayilanAyarDegeri('risk_yagmacilik_bitis');
  String _riskMumGuvesiBaslangic = VeritabaniServisi.varsayilanAyarDegeri('risk_mum_guvesi_baslangic');
  String _riskMumGuvesiBitis = VeritabaniServisi.varsayilanAyarDegeri('risk_mum_guvesi_bitis');
  String _riskFareBaslangic = VeritabaniServisi.varsayilanAyarDegeri('risk_fare_baslangic');
  String _riskFareBitis = VeritabaniServisi.varsayilanAyarDegeri('risk_fare_bitis');

  List<Map<String, dynamic>> _kalibrasyonAriliklari = [];
  int? _kalibrasyonArilikId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _isPro = PremiumServisi.isPro;
    _ayarlariYukle();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _ayarlariYukle() async {
    final seciliArilikId = _kalibrasyonArilikId;
    final ariliklar = await VeritabaniServisi.ariliklariGetir();

    final kisBaslangic = await VeritabaniServisi.ayarStringGetir(
      'season_kis_baslangic',
      varsayilan: VeritabaniServisi.varsayilanAyarDegeri('season_kis_baslangic'),
    );
    final kisBitis = await VeritabaniServisi.ayarStringGetir(
      'season_kis_bitis',
      varsayilan: VeritabaniServisi.varsayilanAyarDegeri('season_kis_bitis'),
    );
    final uretimBaslangic = await VeritabaniServisi.ayarStringGetir(
      'season_uretim_baslangic',
      varsayilan: VeritabaniServisi.varsayilanAyarDegeri('season_uretim_baslangic'),
    );
    final uretimBitis = await VeritabaniServisi.ayarStringGetir(
      'season_uretim_bitis',
      varsayilan: VeritabaniServisi.varsayilanAyarDegeri('season_uretim_bitis'),
    );
    final davranisToleransi = await VeritabaniServisi.ayarStringGetir(
      'davranis_toleransi',
      varsayilan: VeritabaniServisi.varsayilanAyarDegeri('davranis_toleransi'),
    );

    final balAkim1Baslangic = await _kalibrasyonAyarGetir(
      'bal_akim1_baslangic',
      varsayilan: VeritabaniServisi.varsayilanAyarDegeri('bal_akim1_baslangic'),
    );
    final balAkim1Bitis = await _kalibrasyonAyarGetir(
      'bal_akim1_bitis',
      varsayilan: VeritabaniServisi.varsayilanAyarDegeri('bal_akim1_bitis'),
    );
    final balAkim2AktifStr = await _kalibrasyonAyarGetir(
      'bal_akim2_aktif',
      varsayilan: VeritabaniServisi.varsayilanAyarDegeri('bal_akim2_aktif'),
    );
    final balAkim2Baslangic = await _kalibrasyonAyarGetir(
      'bal_akim2_baslangic',
      varsayilan: VeritabaniServisi.varsayilanAyarDegeri('bal_akim2_baslangic'),
    );
    final balAkim2Bitis = await _kalibrasyonAyarGetir(
      'bal_akim2_bitis',
      varsayilan: VeritabaniServisi.varsayilanAyarDegeri('bal_akim2_bitis'),
    );
    final riskAriKusuBaslangic = await _kalibrasyonAyarGetir(
      'risk_ari_kusu_baslangic',
      varsayilan: VeritabaniServisi.varsayilanAyarDegeri('risk_ari_kusu_baslangic'),
    );
    final riskAriKusuBitis = await _kalibrasyonAyarGetir(
      'risk_ari_kusu_bitis',
      varsayilan: VeritabaniServisi.varsayilanAyarDegeri('risk_ari_kusu_bitis'),
    );
    final riskEsekArisiBaslangic = await _kalibrasyonAyarGetir(
      'risk_esek_arisi_baslangic',
      varsayilan: VeritabaniServisi.varsayilanAyarDegeri('risk_esek_arisi_baslangic'),
    );
    final riskEsekArisiBitis = await _kalibrasyonAyarGetir(
      'risk_esek_arisi_bitis',
      varsayilan: VeritabaniServisi.varsayilanAyarDegeri('risk_esek_arisi_bitis'),
    );
    final riskYagmacilikBaslangic = await _kalibrasyonAyarGetir(
      'risk_yagmacilik_baslangic',
      varsayilan: VeritabaniServisi.varsayilanAyarDegeri('risk_yagmacilik_baslangic'),
    );
    final riskYagmacilikBitis = await _kalibrasyonAyarGetir(
      'risk_yagmacilik_bitis',
      varsayilan: VeritabaniServisi.varsayilanAyarDegeri('risk_yagmacilik_bitis'),
    );
    final riskMumGuvesiBaslangic = await _kalibrasyonAyarGetir(
      'risk_mum_guvesi_baslangic',
      varsayilan: VeritabaniServisi.varsayilanAyarDegeri('risk_mum_guvesi_baslangic'),
    );
    final riskMumGuvesiBitis = await _kalibrasyonAyarGetir(
      'risk_mum_guvesi_bitis',
      varsayilan: VeritabaniServisi.varsayilanAyarDegeri('risk_mum_guvesi_bitis'),
    );
    final riskFareBaslangic = await _kalibrasyonAyarGetir(
      'risk_fare_baslangic',
      varsayilan: VeritabaniServisi.varsayilanAyarDegeri('risk_fare_baslangic'),
    );
    final riskFareBitis = await _kalibrasyonAyarGetir(
      'risk_fare_bitis',
      varsayilan: VeritabaniServisi.varsayilanAyarDegeri('risk_fare_bitis'),
    );

    if (!mounted) return;
    setState(() {
      _kalibrasyonAriliklari = ariliklar;
      _kalibrasyonArilikId = seciliArilikId;
      _kisBaslangic = kisBaslangic;
      _kisBitis = kisBitis;
      _uretimBaslangic = uretimBaslangic;
      _uretimBitis = uretimBitis;
      _davranisToleransi =
          davranisToleransi == 'esnek' ? 'esnek' : 'standart';
      _balAkim1Baslangic = balAkim1Baslangic;
      _balAkim1Bitis = balAkim1Bitis;
      _balAkim2Aktif = balAkim2AktifStr == '1';
      _balAkim2Baslangic = balAkim2Baslangic;
      _balAkim2Bitis = balAkim2Bitis;
      _riskAriKusuBaslangic = riskAriKusuBaslangic;
      _riskAriKusuBitis = riskAriKusuBitis;
      _riskEsekArisiBaslangic = riskEsekArisiBaslangic;
      _riskEsekArisiBitis = riskEsekArisiBitis;
      _riskYagmacilikBaslangic = riskYagmacilikBaslangic;
      _riskYagmacilikBitis = riskYagmacilikBitis;
      _riskMumGuvesiBaslangic = riskMumGuvesiBaslangic;
      _riskMumGuvesiBitis = riskMumGuvesiBitis;
      _riskFareBaslangic = riskFareBaslangic;
      _riskFareBitis = riskFareBitis;
      _yukleniyor = false;
    });
  }

  Future<String> _kalibrasyonAyarGetir(
    String anahtar, {
    required String varsayilan,
  }) async {
    return VeritabaniServisi.kalibrasyonAyarGetir(
      anahtar,
      arilikId: _kalibrasyonArilikId,
    );
  }

  Future<void> _kalibrasyonAyarKaydet(String anahtar, String deger) async {
    await VeritabaniServisi.kalibrasyonAyarKaydet(
      anahtar,
      deger,
      arilikId: _kalibrasyonArilikId,
    );
  }

  String _kalibrasyonKapsamMetni() {
    final arilikId = _kalibrasyonArilikId;
    if (arilikId == null || arilikId <= 0) return 'Tüm arılıklar';

    final arilik = _kalibrasyonAriliklari.firstWhere(
      (e) => _toInt(e['id']) == arilikId,
      orElse: () => const <String, dynamic>{},
    );
    final ad = (arilik['ad'] ?? '').toString().trim();
    return ad.isEmpty ? 'Seçili arılık' : ad;
  }

  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }

  bool get _kalibrasyonTamamlandi {
    return _kisBaslangic.isNotEmpty &&
        _kisBitis.isNotEmpty &&
        _uretimBaslangic.isNotEmpty &&
        _uretimBitis.isNotEmpty;
  }

  int _mmDdSirasi(String mmDd) {
    final parcalar = mmDd.split('-');
    final ay = int.tryParse(parcalar.first) ?? 1;
    final gun = int.tryParse(parcalar.last) ?? 1;
    return ay * 100 + gun;
  }

  String _mmDdGoster(String mmDd) {
    final temiz = mmDd.trim();
    final parcalar = temiz.split('-');
    if (parcalar.length != 2) return temiz;
    final ay = int.tryParse(parcalar[0]);
    final gun = int.tryParse(parcalar[1]);
    if (ay == null || gun == null) return temiz;
    return '${gun.toString().padLeft(2, '0')}.${ay.toString().padLeft(2, '0')}';
  }

  bool _aralikGecerli(String baslangic, String bitis) {
    return _mmDdSirasi(baslangic) <= _mmDdSirasi(bitis);
  }

  Future<void> _tarihSec({
    required String baslangicMi,
    required bool kisSezonu,
  }) async {
    final mevcut = kisSezonu
        ? (baslangicMi == 'bas' ? _kisBaslangic : _kisBitis)
        : (baslangicMi == 'bas' ? _uretimBaslangic : _uretimBitis);

    final parcalar = mevcut.split('-');
    final ay = int.tryParse(parcalar.first) ?? 1;
    final gun = int.tryParse(parcalar.last) ?? 1;

    final secilen = await showDatePicker(
      context: context,
      locale: const Locale('tr', 'TR'),
      initialDate: DateTime(DateTime.now().year, ay, gun),
      firstDate: DateTime(DateTime.now().year, 1, 1),
      lastDate: DateTime(DateTime.now().year, 12, 31),
    );

    if (secilen == null) return;

    final mmDd =
        '${secilen.month.toString().padLeft(2, '0')}-${secilen.day.toString().padLeft(2, '0')}';

    setState(() {
      if (kisSezonu) {
        if (baslangicMi == 'bas') {
          _kisBaslangic = mmDd;
        } else {
          _kisBitis = mmDd;
        }
      } else {
        if (baslangicMi == 'bas') {
          _uretimBaslangic = mmDd;
        } else {
          _uretimBitis = mmDd;
        }
      }
    });
  }

  Future<void> _balAkimTarihSec({
    required int index,
    required bool baslangic,
  }) async {
    final mevcut = index == 1
        ? (baslangic ? _balAkim1Baslangic : _balAkim1Bitis)
        : (baslangic ? _balAkim2Baslangic : _balAkim2Bitis);

    final parcalar = mevcut.split('-');
    final ay = int.tryParse(parcalar.first) ?? 1;
    final gun = int.tryParse(parcalar.last) ?? 1;

    final secilen = await showDatePicker(
      context: context,
      locale: const Locale('tr', 'TR'),
      initialDate: DateTime(DateTime.now().year, ay, gun),
      firstDate: DateTime(DateTime.now().year, 1, 1),
      lastDate: DateTime(DateTime.now().year, 12, 31),
    );

    if (secilen == null) return;

    final mmDd =
        '${secilen.month.toString().padLeft(2, '0')}-${secilen.day.toString().padLeft(2, '0')}';

    setState(() {
      if (index == 1) {
        if (baslangic) {
          _balAkim1Baslangic = mmDd;
        } else {
          _balAkim1Bitis = mmDd;
        }
      } else {
        if (baslangic) {
          _balAkim2Baslangic = mmDd;
        } else {
          _balAkim2Bitis = mmDd;
        }
      }
    });
  }


  Future<void> _riskTarihSec({
    required String kod,
    required bool baslangic,
  }) async {
    final mevcut = _riskTarihiGetir(kod: kod, baslangic: baslangic);
    final parcalar = mevcut.split('-');
    final ay = int.tryParse(parcalar.first) ?? 1;
    final gun = int.tryParse(parcalar.last) ?? 1;

    final secilen = await showDatePicker(
      context: context,
      locale: const Locale('tr', 'TR'),
      initialDate: DateTime(DateTime.now().year, ay, gun),
      firstDate: DateTime(DateTime.now().year, 1, 1),
      lastDate: DateTime(DateTime.now().year, 12, 31),
    );

    if (secilen == null) return;

    final mmDd =
        '${secilen.month.toString().padLeft(2, '0')}-${secilen.day.toString().padLeft(2, '0')}';

    setState(() {
      _riskTarihiAta(kod: kod, baslangic: baslangic, deger: mmDd);
    });
  }

  String _riskTarihiGetir({
    required String kod,
    required bool baslangic,
  }) {
    switch (kod) {
      case 'ARI_KUSU':
        return baslangic ? _riskAriKusuBaslangic : _riskAriKusuBitis;
      case 'ESEK_ARISI':
        return baslangic ? _riskEsekArisiBaslangic : _riskEsekArisiBitis;
      case 'YAGMACILIK':
        return baslangic ? _riskYagmacilikBaslangic : _riskYagmacilikBitis;
      case 'MUM_GUVESI':
        return baslangic ? _riskMumGuvesiBaslangic : _riskMumGuvesiBitis;
      case 'FARE':
        return baslangic ? _riskFareBaslangic : _riskFareBitis;
      default:
        return '01-01';
    }
  }

  void _riskTarihiAta({
    required String kod,
    required bool baslangic,
    required String deger,
  }) {
    switch (kod) {
      case 'ARI_KUSU':
        if (baslangic) {
          _riskAriKusuBaslangic = deger;
        } else {
          _riskAriKusuBitis = deger;
        }
        break;
      case 'ESEK_ARISI':
        if (baslangic) {
          _riskEsekArisiBaslangic = deger;
        } else {
          _riskEsekArisiBitis = deger;
        }
        break;
      case 'YAGMACILIK':
        if (baslangic) {
          _riskYagmacilikBaslangic = deger;
        } else {
          _riskYagmacilikBitis = deger;
        }
        break;
      case 'MUM_GUVESI':
        if (baslangic) {
          _riskMumGuvesiBaslangic = deger;
        } else {
          _riskMumGuvesiBitis = deger;
        }
        break;
      case 'FARE':
        if (baslangic) {
          _riskFareBaslangic = deger;
        } else {
          _riskFareBitis = deger;
        }
        break;
    }
  }

  Future<void> _kaydet() async {
    setState(() => _kaydediliyor = true);

    try {
      if (!_aralikGecerli(_balAkim1Baslangic, _balAkim1Bitis)) {
        throw Exception(
          '1. bal akımı aralığında başlangıç tarihi bitişten sonra olamaz.',
        );
      }
      if (_balAkim2Aktif && !_aralikGecerli(_balAkim2Baslangic, _balAkim2Bitis)) {
        throw Exception(
          '2. bal akımı aralığında başlangıç tarihi bitişten sonra olamaz.',
        );
      }

      final seciliArilikId = _kalibrasyonArilikId;

      await VeritabaniServisi.ayarKaydet('season_kis_baslangic', _kisBaslangic);
      await VeritabaniServisi.ayarKaydet('season_kis_bitis', _kisBitis);
      await VeritabaniServisi.ayarKaydet(
        'season_uretim_baslangic',
        _uretimBaslangic,
      );
      await VeritabaniServisi.ayarKaydet('season_uretim_bitis', _uretimBitis);
      await VeritabaniServisi.ayarKaydet(
        'davranis_toleransi',
        _davranisToleransi,
      );

      await _kalibrasyonAyarKaydet(
        'bal_akim1_baslangic',
        _balAkim1Baslangic,
      );
      await _kalibrasyonAyarKaydet('bal_akim1_bitis', _balAkim1Bitis);
      await _kalibrasyonAyarKaydet(
        'bal_akim2_aktif',
        _balAkim2Aktif ? '1' : '0',
      );
      await _kalibrasyonAyarKaydet(
        'bal_akim2_baslangic',
        _balAkim2Baslangic,
      );
      await _kalibrasyonAyarKaydet('bal_akim2_bitis', _balAkim2Bitis);
      await _kalibrasyonAyarKaydet(
        'risk_ari_kusu_baslangic',
        _riskAriKusuBaslangic,
      );
      await _kalibrasyonAyarKaydet('risk_ari_kusu_bitis', _riskAriKusuBitis);
      await _kalibrasyonAyarKaydet(
        'risk_esek_arisi_baslangic',
        _riskEsekArisiBaslangic,
      );
      await _kalibrasyonAyarKaydet(
        'risk_esek_arisi_bitis',
        _riskEsekArisiBitis,
      );
      await _kalibrasyonAyarKaydet(
        'risk_yagmacilik_baslangic',
        _riskYagmacilikBaslangic,
      );
      await _kalibrasyonAyarKaydet(
        'risk_yagmacilik_bitis',
        _riskYagmacilikBitis,
      );
      await _kalibrasyonAyarKaydet(
        'risk_mum_guvesi_baslangic',
        _riskMumGuvesiBaslangic,
      );
      await _kalibrasyonAyarKaydet(
        'risk_mum_guvesi_bitis',
        _riskMumGuvesiBitis,
      );
      await _kalibrasyonAyarKaydet('risk_fare_baslangic', _riskFareBaslangic);
      await _kalibrasyonAyarKaydet('risk_fare_bitis', _riskFareBitis);

      KararAsistanServisi.tumCacheTemizle();
      VeritabaniServisi.balAkimCacheTemizle(arilikId: seciliArilikId);
      ArilikUyariServisi.cacheTemizle(arilikId: seciliArilikId);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            seciliArilikId == null
                ? 'Genel ayarlar tüm arılıklar için kaydedildi.'
                : '${_kalibrasyonKapsamMetni()} arılığı için özel kalibrasyon kaydedildi.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ayarlar kaydedilemedi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _kaydediliyor = false);
      }
    }
  }

  Future<void> _yedekAlVePaylas() async {
    if (_yedekAliniyor || _yedekYukleniyor) return;
    setState(() => _yedekAliniyor = true);
    try {
      await YedekDosyaServisi.yedekOlusturVePaylas();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Yedek hazırlandı. Güvenli bir yere kaydet.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Yedek alınırken hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _yedekAliniyor = false);
      }
    }
  }

  Future<void> _yedektenYukle() async {
    if (_yedekYukleniyor || _yedekAliniyor) return;

    final onay = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('YEDEKTEN GERİ YÜKLE'),
        content: const Text(
          'Bu işlem mevcut veriyi seçtiğin yedek ile tamamen değiştirir. Devam etmeden önce güncel bir yedek alman önerilir. Şimdi yükleme başlasın mı?',
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
            child: const Text('Yüklemeyi Başlat'),
          ),
        ],
      ),
    );

    if (onay != true) return;

    setState(() => _yedekYukleniyor = true);
    try {
      await YedekDosyaServisi.yedekDosyasindanYukle();
      await _ayarlariYukle();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yedekten geri yükleme tamamlandı.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Yedek yüklenirken hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _yedekYukleniyor = false);
      }
    }
  }



  Future<void> _testAriligiOlustur() async {
    if (_testAriligiOlusturuluyor || _yedekAliniyor || _yedekYukleniyor || _kaydediliyor) return;

    final onay = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Test arılığı oluşturulsun mu?'),
        content: const Text(
          'Bu işlem Uluköy veya başka gerçek arılık verisine dokunmaz. '
          'Yalnızca ITOGENA_TEST_ARILIGI adlı ayrı test arılığını oluşturur. '
          'Aynı isimde eski test arılığı varsa sadece onu silip yeniden kurar.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Oluştur'),
          ),
        ],
      ),
    );

    if (onay != true) return;

    setState(() => _testAriligiOlusturuluyor = true);

    try {
      final sonuc = await TestAriligiServisi.olusturVeyaYenile();
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${TestAriligiServisi.testAriligiAdi} hazır. '
            '${sonuc.koloniSayisi} test kolonisi oluşturuldu. '
            '${sonuc.oncekiTestAriligiSilindi ? 'Eski test arılığı yenilendi.' : 'Mevcut gerçek arılıklara dokunulmadı.'}',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Test arılığı oluşturulamadı: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _testAriligiOlusturuluyor = false);
      }
    }
  }

  Future<void> _guncellemeKontrolEt() async {
    if (_yedekAliniyor || _yedekYukleniyor || _kaydediliyor) return;

    try {
      final bilgi = await GuncellemeServisi.kontrolEt();

      if (!mounted) return;

      final hata = bilgi.hata;
      if (hata != null && hata.trim().isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(hata),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!bilgi.diyalogGoster) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Uygulama güncel. Mevcut sürüm: ${bilgi.currentVersionName} (${bilgi.currentVersionCode})',
            ),
          ),
        );
        return;
      }

      await GuncellemeServisi.guncellemeDiyaloguGoster(context, bilgi);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Güncelleme kontrolü başarısız: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _teknikReferansGoster() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const rehber.KullaniciRehberiSayfasi(),
      ),
    );
  }

  Widget _referansBolum(String baslik, List<String> maddeler) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 8),
          ...maddeler.map(
            (m) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      m,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.45,
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

  Widget _kalibrasyonDurumKarti() {
    final tamam = _kalibrasyonTamamlandi;
    final renk = tamam ? Colors.green : Colors.deepOrange;
    final arka = tamam ? const Color(0xFFEAF7EC) : const Color(0xFFFFF3E0);
    final ikon = tamam ? Icons.verified : Icons.warning_amber_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: arka,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: renk.withOpacity(0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ikon, color: renk, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              tamam
                  ? 'Arılık kalibrasyonu tanımlı. Sistem sezon ve bal akımı bağlamını kullanabilir.'
                  : 'Arılık kalibrasyonu eksik. Sezon ve bal akımı tanımları gözden geçirilmeli.',
              style: const TextStyle(fontSize: 12, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sezonTarihKarti({
    required String baslik,
    required String altMetin,
    required String baslangic,
    required String bitis,
    required VoidCallback onBaslangicTap,
    required VoidCallback onBitisTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 6),
          Text(altMetin, style: const TextStyle(fontSize: 12, height: 1.4)),
          const SizedBox(height: 6),
          const Text(
            'Tarih gösterimi gün/ay formatındadır; kayıt formatı sistem içinde korunur.',
            style: TextStyle(fontSize: 11, height: 1.35, color: Colors.black54),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onBaslangicTap,
                  icon: const Icon(Icons.event),
                  label: Text('Başlangıç: ${_mmDdGoster(baslangic)}'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onBitisTap,
                  icon: const Icon(Icons.event_available),
                  label: Text('Bitiş: ${_mmDdGoster(bitis)}'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _davranisTercihiKarti() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DAVRANIŞ TERCİHİ',
            style: TextStyle(fontWeight: FontWeight.w900, color: Colors.brown),
          ),
          const SizedBox(height: 6),
          const Text(
            'Bu ayar yalnızca genetik seçilim ve donör filtresi tarafını etkiler. Çekirdek eşikleri değiştirmez.',
            style: TextStyle(fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 12),
          RadioListTile<String>(
            value: 'standart',
            groupValue: _davranisToleransi,
            activeColor: Colors.amber,
            contentPadding: EdgeInsets.zero,
            title: const Text('Standart', style: TextStyle(fontWeight: FontWeight.w700)),
            subtitle: const Text(
              'Yönetilebilir koloniler önceliklidir. Hırçınlık seçilim tarafında daha belirgin eksidir.',
              style: TextStyle(fontSize: 12, height: 1.35),
            ),
            onChanged: (v) {
              if (v == null) return;
              setState(() => _davranisToleransi = v);
            },
          ),
          RadioListTile<String>(
            value: 'esnek',
            groupValue: _davranisToleransi,
            activeColor: Colors.amber,
            contentPadding: EdgeInsets.zero,
            title: const Text('Esnek', style: TextStyle(fontWeight: FontWeight.w700)),
            subtitle: const Text(
              'Güç ve verim öne çıkıyorsa davranış verisi seçilim tarafında daha yumuşak yorumlanır.',
              style: TextStyle(fontSize: 12, height: 1.35),
            ),
            onChanged: (v) {
              if (v == null) return;
              setState(() => _davranisToleransi = v);
            },
          ),
        ],
      ),
    );
  }

  Widget _kalibrasyonKapsamKarti() {
    final seciliDeger = _kalibrasyonArilikId ?? 0;
    final kapsamMetni = _kalibrasyonKapsamMetni();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FBFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.lightBlue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tune_rounded, color: Colors.blueGrey),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'KALİBRASYON KAPSAMI',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.brown,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Bal akımı ve genel risk takvimi bu kapsama göre kaydedilir. Tüm arılıklar seçilirse genel varsayılanlar güncellenir. Tek arılık seçilirse yalnızca o arılık için özel kalibrasyon oluşturulur.',
            style: TextStyle(fontSize: 12, height: 1.45, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            value: seciliDeger,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Bu kalibrasyonu kullan',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            items: [
              const DropdownMenuItem<int>(
                value: 0,
                child: Text('Tüm arılıklar için kullan'),
              ),
              ..._kalibrasyonAriliklari.map((arilik) {
                final id = _toInt(arilik['id']);
                final ad = (arilik['ad'] ?? '-').toString();
                return DropdownMenuItem<int>(
                  value: id,
                  child: Text('Yalnızca $ad arılığı için kullan'),
                );
              }),
            ],
            onChanged: (v) async {
              if (v == null) return;
              setState(() {
                _kalibrasyonArilikId = v <= 0 ? null : v;
                _yukleniyor = true;
              });
              await _ayarlariYukle();
            },
          ),
          const SizedBox(height: 10),
          Text(
            _kalibrasyonArilikId == null
                ? 'Şu anda genel varsayılan kalibrasyonu düzenliyorsun. Özel ayarı olmayan tüm arılıklar bunu kullanır.'
                : '$kapsamMetni için özel kalibrasyon alanı açık. Burada yaptığın bal akımı ve risk takvimi değişiklikleri diğer arılıkları etkilemez.',
            style: const TextStyle(fontSize: 12, height: 1.45, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _balAkimBilgiKarti() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FBFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.lightBlue.shade200),
      ),
      child: const Text(
        'Bal akımı pencereleri biyolojik geri sayımların temel referansıdır. İlk pencere zorunlu, ikinci pencere ise sadece gerçekten ihtiyaç varsa açık tutulur.',
        style: TextStyle(fontSize: 12, height: 1.45, color: Colors.black87),
      ),
    );
  }

  Widget _ikinciBalAkimAnahtari() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: SwitchListTile(
        value: _balAkim2Aktif,
        activeColor: Colors.amber,
        contentPadding: EdgeInsets.zero,
        title: const Text(
          '2. bal akımını kullan',
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.brown),
        ),
        subtitle: const Text(
          'Örn: Ağustos / Eylül çam balı. İhtiyacın yoksa kapalı bırak.',
          style: TextStyle(fontSize: 12, height: 1.4),
        ),
        onChanged: (v) {
          setState(() => _balAkim2Aktif = v);
        },
      ),
    );
  }


  Widget _riskTakvimiBilgiKarti() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: const Text(
        'Genel risk takvimi koloniye özel karar üretmez. Arı kuşu, eşek arısı, yağmacılık, mum güvesi ve fare gibi dönemsel riskleri arılık ekranında hatırlatır. Tarihleri kendi bölgenin gerçek baskı dönemine göre daraltabilirsin.',
        style: TextStyle(fontSize: 12, height: 1.45, color: Colors.black87),
      ),
    );
  }

  Widget _riskTarihKarti({
    required String kod,
    required String baslik,
    required String altMetin,
    required String baslangic,
    required String bitis,
  }) {
    return _sezonTarihKarti(
      baslik: baslik,
      altMetin: altMetin,
      baslangic: baslangic,
      bitis: bitis,
      onBaslangicTap: () => _riskTarihSec(kod: kod, baslangic: true),
      onBitisTap: () => _riskTarihSec(kod: kod, baslangic: false),
    );
  }

  List<Widget> _riskTakvimiKartlari() {
    return [
      _riskTakvimiBilgiKarti(),
      _riskTarihKarti(
        kod: 'ARI_KUSU',
        baslik: 'Arı Kuşu Risk Dönemi',
        altMetin: 'Varsayılan: Mayıs – Ağustos. Kendi bölgenin göç ve baskı dönemine göre daraltabilirsin.',
        baslangic: _riskAriKusuBaslangic,
        bitis: _riskAriKusuBitis,
      ),
      _riskTarihKarti(
        kod: 'ESEK_ARISI',
        baslik: 'Eşek Arısı / Sarıca Risk Dönemi',
        altMetin: 'Varsayılan: Temmuz – Ekim. Baskının yoğunlaştığı döneme göre ayarla.',
        baslangic: _riskEsekArisiBaslangic,
        bitis: _riskEsekArisiBitis,
      ),
      _riskTarihKarti(
        kod: 'YAGMACILIK',
        baslik: 'Yağmacılık Risk Dönemi',
        altMetin: 'Varsayılan: Temmuz – Eylül. Hasat sonrası ve kurak dönem baskısına göre ayarla.',
        baslangic: _riskYagmacilikBaslangic,
        bitis: _riskYagmacilikBitis,
      ),
      _riskTarihKarti(
        kod: 'MUM_GUVESI',
        baslik: 'Mum Güvesi Risk Dönemi',
        altMetin: 'Varsayılan: Haziran – Eylül. Sıcak dönem ve zayıf koloni riskine göre ayarla.',
        baslangic: _riskMumGuvesiBaslangic,
        bitis: _riskMumGuvesiBitis,
      ),
      _riskTarihKarti(
        kod: 'FARE',
        baslik: 'Fare Risk Dönemi',
        altMetin: 'Varsayılan: Kasım – Şubat. Bu aralık yıl taşar; sistem bunu doğru yorumlar.',
        baslangic: _riskFareBaslangic,
        bitis: _riskFareBitis,
      ),
    ];
  }

  Widget _tabGenel() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        _kalibrasyonDurumKarti(),
        _sezonTarihKarti(
          baslik: 'Kış / Dayanıklılık Dönemi',
          altMetin: 'Varsayılan yapı 1 Eylül – 15 Marttır. Gerekirse sahana göre ince ayar yap.',
          baslangic: _kisBaslangic,
          bitis: _kisBitis,
          onBaslangicTap: () => _tarihSec(baslangicMi: 'bas', kisSezonu: true),
          onBitisTap: () => _tarihSec(baslangicMi: 'bit', kisSezonu: true),
        ),
        _sezonTarihKarti(
          baslik: 'Aktif / Üretim Dönemi',
          altMetin: 'Varsayılan yapı 15 Mart – 31 Ağustostur. Gerekirse sahana göre ince ayar yap.',
          baslangic: _uretimBaslangic,
          bitis: _uretimBitis,
          onBaslangicTap: () => _tarihSec(baslangicMi: 'bas', kisSezonu: false),
          onBitisTap: () => _tarihSec(baslangicMi: 'bit', kisSezonu: false),
        ),
        _kalibrasyonKapsamKarti(),
        _balAkimBilgiKarti(),
        _sezonTarihKarti(
          baslik: 'Bal Akımı Aralığı 1',
          altMetin: 'İlk ana akım. Örn: Mayıs sonu / Haziran başı.',
          baslangic: _balAkim1Baslangic,
          bitis: _balAkim1Bitis,
          onBaslangicTap: () => _balAkimTarihSec(index: 1, baslangic: true),
          onBitisTap: () => _balAkimTarihSec(index: 1, baslangic: false),
        ),
        _ikinciBalAkimAnahtari(),
        if (_balAkim2Aktif)
          _sezonTarihKarti(
            baslik: 'Bal Akımı Aralığı 2',
            altMetin: 'İkinci akım. Örn: Ağustos / Eylül çam balı.',
            baslangic: _balAkim2Baslangic,
            bitis: _balAkim2Bitis,
            onBaslangicTap: () => _balAkimTarihSec(index: 2, baslangic: true),
            onBitisTap: () => _balAkimTarihSec(index: 2, baslangic: false),
          ),
        ..._riskTakvimiKartlari(),
        _davranisTercihiKarti(),
        OutlinedButton.icon(
          onPressed: _teknikReferansGoster,
          icon: const Icon(Icons.menu_book_outlined),
          label: const Text('Kullanıcı rehberini aç'),
        ),
      ],
    );
  }

  Widget _sistemBilgiKarti() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: const Text(
        'Yedek alma ve geri yükleme akışı sistemde tutulur. Geri yükleme sonrası bakım adımı çalıştırılır ve karar önbelleği temizlenir.',
        style: TextStyle(fontSize: 12, height: 1.45, color: Colors.black87),
      ),
    );
  }
  Widget _uygulamaKimlikKarti() {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final info = snapshot.data;
        final surum = info == null ? "Yükleniyor" : "${info.version}+${info.buildNumber}";
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.brown.withOpacity(0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.verified_outlined, color: Colors.brown),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "UYGULAMA KİMLİĞİ",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _kimlikSatiri("Uygulama", "ITOGENA"),
              _kimlikSatiri("Tanım", "Arı Kolonileri Yönetim Sistemi"),
              _kimlikSatiri("Sürüm", surum),
              _kimlikSatiri("Yıl", "2026"),
              _kimlikSatiri("Üretici", "İTOGA Çiftliği"),
              _kimlikSatiri("Veri", "Cihaz içi SQLite veritabanı"),
              const SizedBox(height: 8),
              const Text(
                "Sistem amacı: basit saha verisini zaman, olay ve süreç mantığıyla okuyarak uygulanabilir koloni kararı üretmek.",
                style: TextStyle(fontSize: 12, height: 1.45, color: Colors.black87),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _kimlikSatiri(String baslik, String deger) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 76,
            child: Text(
              baslik,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.brown,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              deger,
              style: const TextStyle(fontSize: 12, height: 1.35, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }


  Widget _sistemIslemKarti({
    required String baslik,
    required String altMetin,
    required IconData ikon,
    required Color renk,
    required VoidCallback onTap,
    bool calisiyor = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: renk.withOpacity(0.30)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: renk.withOpacity(0.10),
          child: calisiyor
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: renk),
                )
              : Icon(ikon, color: renk),
        ),
        title: Text(
          baslik,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
        subtitle: Text(altMetin, style: const TextStyle(fontSize: 12, height: 1.35)),
        trailing: const Icon(Icons.chevron_right),
        onTap: calisiyor ? null : onTap,
      ),
    );
  }

  Widget _tabSistem() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        _sistemBilgiKarti(),
        _uygulamaKimlikKarti(),
        _sistemIslemKarti(
          baslik: 'Yedek Al',
          altMetin: 'Tüm veriyi JSON yedek dosyası olarak oluştur ve paylaş.',
          ikon: Icons.backup_outlined,
          renk: Colors.green,
          calisiyor: _yedekAliniyor,
          onTap: _yedekAlVePaylas,
        ),
        _sistemIslemKarti(
          baslik: 'Yedekten Yükle',
          altMetin: 'Daha önce aldığın JSON yedeğini seç ve mevcut verinin yerine yükle.',
          ikon: Icons.restore_outlined,
          renk: Colors.indigo,
          calisiyor: _yedekYukleniyor,
          onTap: _yedektenYukle,
        ),
        _sistemIslemKarti(
          baslik: 'Test Arılığı Oluştur / Yenile',
          altMetin: 'Uluköy verisine dokunmadan ayrı ITOGENA_TEST_ARILIGI içinde 40 senaryo kurar.',
          ikon: Icons.science_outlined,
          renk: Colors.blueGrey,
          calisiyor: _testAriligiOlusturuluyor,
          onTap: _testAriligiOlustur,
        ),
        _sistemIslemKarti(
          baslik: 'Güncellemeyi Kontrol Et',
          altMetin: 'Yeni sürüm varsa önce yedek aldırır, ardından güvenli APK bağlantısını açar.',
          ikon: Icons.system_update_alt_outlined,
          renk: Colors.orange,
          onTap: _guncellemeKontrolEt,
        ),
        Container(
          margin: const EdgeInsets.only(top: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.deepOrange.shade200),
          ),
          child: const Text(
            'Yedekten yükleme mevcut veriyi tamamen değiştirir. Yüklemeden hemen önce yeni bir yedek almak en güvenli yaklaşımdır.',
            style: TextStyle(fontSize: 12, height: 1.45, color: Colors.black87),
          ),
        ),
        _sistemIslemKarti(
          baslik: 'Gizlilik Politikası',
          altMetin: 'Uygulama veri kullanımı ve gizlilik ilkelerini görüntüle.',
          ikon: Icons.privacy_tip_outlined,
          renk: Colors.teal,
          onTap: () => launchUrl(
            Uri.parse('https://itogaciftligi.com/itogena-gizlilik-politikasi/'),
            mode: LaunchMode.externalApplication,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'GELİŞTİRİCİ',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'PRO mod (test)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'PRO özellikleri kilit olmadan görüntüler.',
                  style: TextStyle(fontSize: 12),
                ),
                value: _isPro,
                activeColor: const Color(0xFFFFB300),
                onChanged: (deger) async {
                  if (deger) {
                    await PremiumServisi.proAktifEt();
                  } else {
                    await PremiumServisi.proIptalEt();
                  }
                  setState(() => _isPro = deger);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: const Text(
          'AYARLAR VE KALİBRASYON',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [AnaSayfaKisayol.aksiyon(context)],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          indicatorColor: Colors.brown,
          tabs: const [
            Tab(text: 'GENEL'),
            Tab(text: 'SİSTEM'),
          ],
        ),
      ),
      body: _yukleniyor
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : TabBarView(
              controller: _tabController,
              children: [
                _tabGenel(),
                _tabSistem(),
              ],
            ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: _kaydediliyor ? null : _kaydet,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: _kaydediliyor
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_outlined),
            label: Text(
              _kaydediliyor ? 'KAYDEDİLİYOR...' : 'GENEL AYARLARI KAYDET',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
