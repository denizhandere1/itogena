import 'package:flutter/material.dart';
import 'ana_sayfa_kisayol.dart';
import '../services/veritabani_servisi.dart';
import 'koloniler_sayfasi.dart';
import 'raporlar_sayfasi.dart';
import '../services/arilik_uyari_servisi.dart';

class ArilikSecimSayfasi extends StatefulWidget {
  final bool raporModu;

  const ArilikSecimSayfasi({
    super.key,
    this.raporModu = false,
  });

  @override
  State<ArilikSecimSayfasi> createState() => _ArilikSecimSayfasiState();
}

class _ArilikSecimSayfasiState extends State<ArilikSecimSayfasi> {
  List<Map<String, dynamic>> _ariliklar = [];
  final Map<int, List<ArilikUyari>> _uyariMap = {};
  final Map<int, bool> _uyariDetayMap = {};
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

    final Map<int, List<ArilikUyari>> uyariMap = {};
    final bugun = DateTime.now();
    final uyariSonuclari = await Future.wait<MapEntry<int, List<ArilikUyari>>>(
      ariliklar.map((arilik) async {
        final arilikId = _toInt(arilik['id']);
        if (arilikId <= 0) {
          return MapEntry<int, List<ArilikUyari>>(
            arilikId,
            const <ArilikUyari>[],
          );
        }

        final uyarilar = await ArilikUyariServisi.uyarilariGetir(
          bugun,
          arilikId: arilikId,
        );
        return MapEntry<int, List<ArilikUyari>>(arilikId, uyarilar);
      }),
    );

    for (final sonuc in uyariSonuclari) {
      if (sonuc.key > 0) uyariMap[sonuc.key] = sonuc.value;
    }

    if (!mounted) return;

    setState(() {
      _ariliklar = ariliklar;
      _uyariMap
        ..clear()
        ..addAll(uyariMap);
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

  DateTime _bugun() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  String _isoTarih(DateTime tarih) {
    final yil = tarih.year.toString().padLeft(4, '0');
    final ay = tarih.month.toString().padLeft(2, '0');
    final gun = tarih.day.toString().padLeft(2, '0');
    return '$yil-$ay-$gun';
  }

  String _tarihFormatla(DateTime tarih) {
    final gun = tarih.day.toString().padLeft(2, '0');
    final ay = tarih.month.toString().padLeft(2, '0');
    return '$gun.$ay.${tarih.year}';
  }

  DateTime? _guvenliTarihParse(dynamic deger) {
    final metin = (deger ?? '').toString().trim();
    if (metin.isEmpty) return null;

    final tarih = DateTime.tryParse(metin);
    if (tarih == null) return null;

    return DateTime(tarih.year, tarih.month, tarih.day);
  }

  Future<bool> _gecmisTarihOnayi({
    required DateTime mevcutTarih,
    required DateTime yeniTarih,
    required String baslik,
    required String mesaj,
  }) async {
    final mevcut = DateTime(
      mevcutTarih.year,
      mevcutTarih.month,
      mevcutTarih.day,
    );
    final yeni = DateTime(
      yeniTarih.year,
      yeniTarih.month,
      yeniTarih.day,
    );

    if (!yeni.isBefore(mevcut)) return true;

    final onay = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(baslik),
        content: Text(mesaj),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Evet, değiştir'),
          ),
        ],
      ),
    );

    return onay == true;
  }

  void _arilikEkleDiyalog() {
    final controller = TextEditingController();
    DateTime kurulusTarihi = _bugun();
    final tarihController = TextEditingController(
      text: _tarihFormatla(kurulusTarihi),
    );
    int? kopyalanacakArilikId;
    bool kalibrasyonuKopyala = false;

    final kopyalanabilirAriliklar = _ariliklar.where((a) {
      final id = _toInt(a['id']);
      return id > 0;
    }).toList();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Yeni Arılık Ekle'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Arılık adı',
                      hintText: 'Örn: Uluköy',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: tarihController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Arılık başlangıç tarihi',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      final secilen = await showDatePicker(
                        context: dialogContext,
                        locale: const Locale('tr', 'TR'),
                        initialDate: kurulusTarihi,
                        firstDate: DateTime(2000, 1, 1),
                        lastDate: _bugun(),
                      );

                      if (secilen == null) return;

                      final yeniTarih = DateTime(
                        secilen.year,
                        secilen.month,
                        secilen.day,
                      );

                      final onay = await _gecmisTarihOnayi(
                        mevcutTarih: kurulusTarihi,
                        yeniTarih: yeniTarih,
                        baslik: 'Geçmiş tarih seçildi',
                        mesaj:
                        'Arılık başlangıç tarihini geriye çekiyorsun. '
                            'Bu doğruysa devam et. Sistem yine de koloni ve muayene tarihleriyle çakışırsa kaydı engeller.',
                      );

                      if (!onay) return;

                      setDialogState(() {
                        kurulusTarihi = yeniTarih;
                        tarihController.text = _tarihFormatla(kurulusTarihi);
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Kalibrasyon',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 6),
                  RadioListTile<bool>(
                    value: false,
                    groupValue: kalibrasyonuKopyala,
                    contentPadding: EdgeInsets.zero,
                    activeColor: Colors.amber,
                    title: const Text(
                      'Varsayılan kalibrasyonu kullan',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: const Text(
                      'Yeni arılık özel ayar oluşturmaz; genel varsayılan bal akımı ve risk takvimini kullanır.',
                      style: TextStyle(fontSize: 12, height: 1.35),
                    ),
                    onChanged: (v) {
                      setDialogState(() {
                        kalibrasyonuKopyala = false;
                        kopyalanacakArilikId = null;
                      });
                    },
                  ),
                  RadioListTile<bool>(
                    value: true,
                    groupValue: kalibrasyonuKopyala,
                    contentPadding: EdgeInsets.zero,
                    activeColor: Colors.amber,
                    title: const Text(
                      'Mevcut bir arılıktan kopyala',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: const Text(
                      'Seçilen arılığın bal akımı ve genel risk takvimi yeni arılığa özel kalibrasyon olarak kopyalanır.',
                      style: TextStyle(fontSize: 12, height: 1.35),
                    ),
                    onChanged: kopyalanabilirAriliklar.isEmpty
                        ? null
                        : (v) {
                      setDialogState(() {
                        kalibrasyonuKopyala = true;
                        kopyalanacakArilikId ??=
                            _toInt(kopyalanabilirAriliklar.first['id']);
                      });
                    },
                  ),
                  if (kalibrasyonuKopyala) ...[
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: kopyalanacakArilikId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Kopyalanacak arılık',
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      items: kopyalanabilirAriliklar.map((arilik) {
                        final id = _toInt(arilik['id']);
                        final ad = (arilik['ad'] ?? '-').toString();
                        return DropdownMenuItem<int>(
                          value: id,
                          child: Text(ad),
                        );
                      }).toList(),
                      onChanged: (v) {
                        setDialogState(() {
                          kopyalanacakArilikId = v;
                        });
                      },
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              AnaSayfaKisayol.aksiyon(context),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('İptal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final ad = controller.text.trim();
                  if (ad.isEmpty) return;

                  if (kalibrasyonuKopyala &&
                      (kopyalanacakArilikId == null ||
                          kopyalanacakArilikId! <= 0)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Kalibrasyon kopyalanacak arılığı seçmelisin.'),
                      ),
                    );
                    return;
                  }

                  try {
                    final yeniArilikId = await VeritabaniServisi.arilikEkle(
                      ad,
                      kurulusTarihi: _isoTarih(kurulusTarihi),
                    );

                    if (kalibrasyonuKopyala &&
                        kopyalanacakArilikId != null &&
                        yeniArilikId > 0) {
                      await VeritabaniServisi.arilikKalibrasyonunuKopyala(
                        kaynakArilikId: kopyalanacakArilikId!,
                        hedefArilikId: yeniArilikId,
                      );
                      ArilikUyariServisi.cacheTemizle(arilikId: yeniArilikId);
                    }

                    if (!mounted) return;

                    Navigator.pop(context);
                    _verileriYukle();
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Arılık kaydedilemedi: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Kaydet'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _arilikDuzenleDiyalog(Map<String, dynamic> arilik) {
    final arilikId = _toInt(arilik['id']);
    if (arilikId <= 0) return;

    final adController = TextEditingController(
      text: (arilik['ad'] ?? '').toString(),
    );

    DateTime kurulusTarihi =
        _guvenliTarihParse(arilik['kurulusTarihi']) ?? _bugun();
    final tarihController = TextEditingController(
      text: _tarihFormatla(kurulusTarihi),
    );

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Arılık Bilgilerini Düzenle'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: adController,
                    decoration: const InputDecoration(
                      labelText: 'Arılık adı',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: tarihController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Arılık başlangıç tarihi',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      final secilen = await showDatePicker(
                        context: dialogContext,
                        locale: const Locale('tr', 'TR'),
                        initialDate: kurulusTarihi,
                        firstDate: DateTime(2000, 1, 1),
                        lastDate: _bugun(),
                      );

                      if (secilen == null) return;

                      final yeniTarih = DateTime(
                        secilen.year,
                        secilen.month,
                        secilen.day,
                      );

                      final onay = await _gecmisTarihOnayi(
                        mevcutTarih: kurulusTarihi,
                        yeniTarih: yeniTarih,
                        baslik: 'Geçmiş tarih seçildi',
                        mesaj:
                        'Arılık başlangıç tarihini geriye çekiyorsun. '
                            'Bu doğruysa devam et. Sistem, bu tarih koloni veya muayene kayıtlarıyla çelişirse kaydı engeller.',
                      );

                      if (!onay) return;

                      setDialogState(() {
                        kurulusTarihi = yeniTarih;
                        tarihController.text = _tarihFormatla(kurulusTarihi);
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Kural: Arılık başlangıç tarihi, bu arılıktaki koloni ve muayene tarihlerinden sonra olamaz. Aynı tarih kabul edilir.',
                    style: TextStyle(fontSize: 12, height: 1.35),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('İptal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final ad = adController.text.trim();
                  if (ad.isEmpty) return;

                  try {
                    await VeritabaniServisi.arilikGuncelle(
                      arilikId,
                      ad: ad,
                      kurulusTarihi: _isoTarih(kurulusTarihi),
                    );

                    ArilikUyariServisi.cacheTemizle(arilikId: arilikId);

                    if (!mounted) return;
                    Navigator.pop(dialogContext);
                    _verileriYukle();
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Arılık güncellenemedi: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Kaydet'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _ariligaGit(Map<String, dynamic> arilik) async {
    final arilikId = _toInt(arilik['id']);
    final arilikAd = arilik['ad']?.toString() ?? '-';
    if (arilikId <= 0) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => widget.raporModu
            ? RaporlarSayfasi(
          arilikAd: arilikAd,
          arilikId: arilikId,
        )
            : KolonilerSayfasi(
          arilikAd: arilikAd,
          arilikId: arilikId,
        ),
      ),
    );
    _verileriYukle();
  }

  Future<void> _uyariyiBuSezonGizle({
    required int arilikId,
    required ArilikUyari uyari,
  }) async {
    await ArilikUyariServisi.sezonlukGizle(
      uyari.kod,
      DateTime.now(),
      arilikId: arilikId,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${uyari.baslik} bu arılıkta bu sezon gizlendi.'),
      ),
    );

    await _verileriYukle();
  }

  Future<void> _arilikSilAkisi(Map<String, dynamic> arilik) async {
    final arilikId = _toInt(arilik['id']);
    final arilikAdi = (arilik['ad'] ?? '').toString().trim();
    if (arilikId <= 0 || arilikAdi.isEmpty) return;

    final ozet = _ozetMap[arilikId] ?? const <String, dynamic>{};
    final toplam = _toInt(ozet['toplam']);
    final aktif = _toInt(ozet['aktif']);
    final pasif = _toInt(ozet['pasif']);

    final ilkOnay = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (dialogContext) => AlertDialog(
        title: const Text('ARILIĞI SİL'),
        content: Text(
          'Bu işlem geri alınamaz.\n\n'
              'Silinecek arılık: $arilikAdi\n'
              'Toplam koloni: $toplam\n'
              'Aktif koloni: $aktif\n'
              'Pasif / sönmüş koloni: $pasif\n\n'
              'Bu arılığa bağlı koloniler, muayeneler, olay kayıtları, numara geçmişi ve arılık özel kalibrasyonları silinir.\n\n'
              'Devam etmeden önce güncel yedek aldığından emin ol.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext, rootNavigator: true).pop(false),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(dialogContext, rootNavigator: true).pop(true),
            child: const Text('Devam Et'),
          ),
        ],
      ),
    );

    if (ilkOnay != true || !mounted) return;

    final ikinciOnay = await _arilikSilmeAdOnayi(arilikAdi);
    if (ikinciOnay != true) return;

    // Dialog kapanış animasyonu tamamen bitmeden listeyi rebuild etmek Flutter'da
    // inherited widget bağımlılığı assertion'ına yol açabiliyor. Silme işlemi
    // yalnızca açık onaydan sonra başlar; Vazgeç akışında hiçbir DB işlemi yapılmaz.
    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (!mounted) return;

    try {
      setState(() {
        _yukleniyor = true;
      });

      await VeritabaniServisi.arilikSil(arilikId);
      ArilikUyariServisi.cacheTemizle(arilikId: arilikId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$arilikAdi arılığı silindi.')),
      );

      await _verileriYukle();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _yukleniyor = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Arılık silinemedi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool?> _arilikSilmeAdOnayi(String arilikAdi) async {
    final controller = TextEditingController();
    bool adDogru = false;

    final sonuc = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('SON ONAY'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Silme işlemini kesinleştirmek için arılık adını birebir yaz.',
                ),
                const SizedBox(height: 10),
                SelectableText(
                  arilikAdi,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Arılık adını yaz',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) {
                    setDialogState(() {
                      adDogru = v.trim() == arilikAdi;
                    });
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  'Bu işlem arılık verisini kalıcı olarak siler.',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext, rootNavigator: true).pop(false),
                child: const Text('Vazgeç'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: adDogru
                    ? () => Navigator.of(dialogContext, rootNavigator: true).pop(true)
                    : null,
                child: const Text('Kalıcı Olarak Sil'),
              ),
            ],
          );
        },
      ),
    );

    // Controller'ı burada dispose etmiyoruz. Dialog kapanış animasyonu sırasında
    // TextField hâlâ kısa süre canlı kalabildiği için erken dispose Flutter
    // assertion'ı üretebiliyor. Bu küçük controller, ekran ömrü içinde güvenli
    // şekilde GC'ye bırakılır.
    return sonuc;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: Text(
          widget.raporModu ? 'RAPOR İÇİN ARILIK SEÇ' : 'ARILIK SEÇİMİ',
          style: const TextStyle(fontWeight: FontWeight.bold),
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
              'Henüz arılık eklenmemiş.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _arilikEkleDiyalog,
              child: const Text('İlk Arılığını Ekle'),
            ),
          ],
        ),
      )
          : ListView(
        padding: EdgeInsets.fromLTRB(
          widget.raporModu ? 12 : 16,
          widget.raporModu ? 12 : 16,
          widget.raporModu ? 12 : 16,
          124,
        ),
        children: widget.raporModu
            ? _ariliklar.map(_raporArilikSatiri).toList()
            : _ariliklar.map(_arilikKarti).toList(),
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



  Widget _raporArilikSatiri(Map<String, dynamic> arilik) {
    final arilikId = _toInt(arilik['id']);
    final ozet = _ozetMap[arilikId] ?? const <String, dynamic>{};
    final ad = arilik['ad']?.toString() ?? '-';
    final toplam = _toInt(ozet['toplam']);
    final aktif = _toInt(ozet['aktif']);
    final ortalamaSkor = _toInt(ozet['ortalamaSkor']);
    final skorRenk = _skorRengi(ortalamaSkor);

    return InkWell(
      onTap: () => _ariligaGit(arilik),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.amber.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.hive_outlined, size: 22, color: Colors.brown),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ad,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14.5,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Aktif $aktif / Toplam $toplam',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Colors.black54,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: skorRenk.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: skorRenk.withOpacity(0.22)),
              ),
              child: Text(
                '%$ortalamaSkor',
                style: TextStyle(
                  color: skorRenk,
                  fontWeight: FontWeight.w900,
                  fontSize: 12.5,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: Colors.brown),
          ],
        ),
      ),
    );
  }

  Widget _raporModuBilgiKarti() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: const Text(
        'Raporlar seçtiğin arılığa göre hazırlanır. Ekonomik değer, arılık istatistikleri, donör listeleri ve güçlü/zayıf sıralamaları yalnızca bu arılıktaki aktif kolonileri dikkate alır.',
        style: TextStyle(fontSize: 12.5, height: 1.4, color: Colors.black87),
      ),
    );
  }

  Widget _genelUyariAlani({
    required int arilikId,
    required List<ArilikUyari> uyarilar,
  }) {
    final detayAcik = _uyariDetayMap[arilikId] ?? false;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${uyarilar.length} aktif genel uyarı var',
                  style: TextStyle(
                    fontSize: 12.8,
                    fontWeight: FontWeight.w900,
                    color: Colors.orange.shade900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...uyarilar.map(
                (uyari) => _uyariOzetSatiri(
              arilikId: arilikId,
              uyari: uyari,
              detayAcik: detayAcik,
            ),
          ),
          const SizedBox(height: 2),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _uyariDetayMap[arilikId] = !detayAcik;
                });
              },
              icon: Icon(
                detayAcik
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: 20,
              ),
              label: Text(
                detayAcik ? 'Detayları kapat' : 'Detayları göster',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blueGrey.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _uyariOzetSatiri({
    required int arilikId,
    required ArilikUyari uyari,
    required bool detayAcik,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            uyari.baslik,
            style: const TextStyle(
              fontSize: 12.8,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            detayAcik ? uyari.mesaj : _ilkCumle(uyari.mesaj),
            maxLines: detayAcik ? null : 1,
            overflow: detayAcik ? TextOverflow.visible : TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12.2,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
          if (detayAcik) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _uyariyiBuSezonGizle(
                  arilikId: arilikId,
                  uyari: uyari,
                ),
                icon: const Icon(Icons.visibility_off_outlined, size: 16),
                label: const Text(
                  'Bu arılıkta bu sezon gösterme',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blueGrey.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _ilkCumle(String metin) {
    final temiz = metin.trim();
    if (temiz.isEmpty) return '';

    final noktaIndex = temiz.indexOf('.');
    if (noktaIndex <= 0) return temiz;

    return temiz.substring(0, noktaIndex + 1);
  }

  Widget _arilikKarti(Map<String, dynamic> arilik) {
    final arilikId = _toInt(arilik['id']);
    final ozet = _ozetMap[arilikId] ?? {};
    final uyarilar = _uyariMap[arilikId] ?? const <ArilikUyari>[];

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        arilik['ad']?.toString() ?? '-',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "Başlangıç: ${_tarihFormatla(_guvenliTarihParse(arilik['kurulusTarihi']) ?? _bugun())}",
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Arılığı düzenle',
                  onPressed: () => _arilikDuzenleDiyalog(arilik),
                  icon: const Icon(Icons.edit_calendar_outlined),
                  color: Colors.brown,
                ),
                IconButton(
                  tooltip: 'Arılığı sil',
                  onPressed: () => _arilikSilAkisi(arilik),
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red,
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
                    '%$ortalamaSkor',
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
                    'Toplam',
                    toplam.toString(),
                    Colors.blueGrey,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ozetKutusu(
                    'Aktif',
                    aktif.toString(),
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ozetKutusu(
                    'Pasif',
                    pasif.toString(),
                    Colors.deepOrange,
                  ),
                ),
              ],
            ),
            if (uyarilar.isNotEmpty)
              _genelUyariAlani(
                arilikId: arilikId,
                uyarilar: uyarilar,
              ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Arılığa gir',
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
