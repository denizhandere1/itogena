import 'package:flutter/material.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'ana_sayfa_kisayol.dart';
import '../services/veritabani_servisi.dart';
import '../services/karar_asistan_servisi.dart';
import '../services/yedek_dosya_servisi.dart';

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
  bool _yedekYukleniyor = false;

  String _kisBaslangic = '09-01';
  String _kisBitis = '03-15';
  String _uretimBaslangic = '03-15';
  String _uretimBitis = '08-31';
  String _davranisToleransi = 'standart';

  String _balAkim1Baslangic = '05-25';
  String _balAkim1Bitis = '06-15';

  bool _balAkim2Aktif = false;
  String _balAkim2Baslangic = '08-20';
  String _balAkim2Bitis = '09-20';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _ayarlariYukle();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _ayarlariYukle() async {
    final kisBaslangic = await VeritabaniServisi.ayarStringGetir(
      'season_kis_baslangic',
      varsayilan: '09-01',
    );
    final kisBitis = await VeritabaniServisi.ayarStringGetir(
      'season_kis_bitis',
      varsayilan: '03-15',
    );
    final uretimBaslangic = await VeritabaniServisi.ayarStringGetir(
      'season_uretim_baslangic',
      varsayilan: '03-15',
    );
    final uretimBitis = await VeritabaniServisi.ayarStringGetir(
      'season_uretim_bitis',
      varsayilan: '08-31',
    );
    final davranisToleransi = await VeritabaniServisi.ayarStringGetir(
      'davranis_toleransi',
      varsayilan: 'standart',
    );
    final balAkim1Baslangic = await VeritabaniServisi.ayarStringGetir(
      'bal_akim1_baslangic',
      varsayilan: '05-25',
    );
    final balAkim1Bitis = await VeritabaniServisi.ayarStringGetir(
      'bal_akim1_bitis',
      varsayilan: '06-15',
    );
    final balAkim2AktifStr = await VeritabaniServisi.ayarStringGetir(
      'bal_akim2_aktif',
      varsayilan: '0',
    );
    final balAkim2Baslangic = await VeritabaniServisi.ayarStringGetir(
      'bal_akim2_baslangic',
      varsayilan: '08-20',
    );
    final balAkim2Bitis = await VeritabaniServisi.ayarStringGetir(
      'bal_akim2_bitis',
      varsayilan: '09-20',
    );

    if (!mounted) return;
    setState(() {
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
      _yukleniyor = false;
    });
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
      await VeritabaniServisi.ayarKaydet(
        'bal_akim1_baslangic',
        _balAkim1Baslangic,
      );
      await VeritabaniServisi.ayarKaydet('bal_akim1_bitis', _balAkim1Bitis);
      await VeritabaniServisi.ayarKaydet(
        'bal_akim2_aktif',
        _balAkim2Aktif ? '1' : '0',
      );
      await VeritabaniServisi.ayarKaydet(
        'bal_akim2_baslangic',
        _balAkim2Baslangic,
      );
      await VeritabaniServisi.ayarKaydet('bal_akim2_bitis', _balAkim2Bitis);

      KararAsistanServisi.tumCacheTemizle();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Genel ayarlar kaydedildi.'),
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

  void _teknikReferansGoster() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final controller = ScrollController();
        return Container(
          height: MediaQuery.of(context).size.height * 0.82,
          decoration: const BoxDecoration(
            color: Color(0xFFFFFDE7),
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 52,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(24),
                  children: [
                    const Text(
                      'İTOGENA AYARLAR REHBERİ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Text(
                      'Sezon kalibrasyonu, bal akımı ve veri güvenliği',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 11),
                    ),
                    const Divider(height: 32, thickness: 1.5),
                    _referansBolum(
                      '1. SİSTEM FELSEFESİ',
                      const [
                        'Veri → analiz → karar → aksiyon akışı korunur.',
                        'Sistem gereksiz açıklama değil, sahada yapılacak işi öne çıkarır.',
                        'Çekirdek eşikler ve puan omurgası artık kullanıcı ekranından değiştirilmez.',
                      ],
                    ),
                    _referansBolum(
                      '2. KULLANICIYA AÇIK KALAN ALANLAR',
                      const [
                        'Sezon tarihleri açık kalır. Coğrafya değişir; bu yüzden saha takvimi kullanıcı tarafından kalibre edilir.',
                        'Bal akımı pencereleri açık kalır. Biyolojik geri sayımlar ve üretim bağlamı bu tarihlere dayanır.',
                        'Davranış tercihi açık kalır. Bu ayar yalnızca seçilim yorumunu yumuşatır veya sertleştirir.',
                      ],
                    ),
                    _referansBolum(
                      '3. SİSTEM TARAFINDAN YÖNETİLEN ALANLAR',
                      const [
                        'Kış ve üretim eşikleri kullanıcı ekranından kaldırıldı.',
                        'Çıta bantları, bölme alt sınırları, donör mantığı ve veto omurgası sistem içinde korunur.',
                        'Bu sayede kullanıcı yanlış kalibrasyonla karar motorunu bozmaz.',
                      ],
                    ),
                    _referansBolum(
                      '4. VARSAYILAN TAKVİM',
                      const [
                        'Aktif dönem varsayılanı: 15 Mart – 31 Ağustos.',
                        'Kış dönemi varsayılanı: 1 Eylül – 15 Mart.',
                        'Bu tarihler gerekirse kullanıcı tarafından kendi coğrafyasına göre güncellenebilir.',
                      ],
                    ),
                    _referansBolum(
                      '5. YEDEK SİSTEMİ',
                      const [
                        'Yedek alma ve yedekten yükleme aynı JSON formatı üzerinden çalışır.',
                        'Geri yükleme sonrası sistem bakım ve onarım adımı çalıştırılır.',
                        'Büyük değişikliklerden önce yeni bir yedek almak güvenlik standardıdır.',
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onBaslangicTap,
                  icon: const Icon(Icons.event),
                  label: Text('Başlangıç: $baslangic'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onBitisTap,
                  icon: const Icon(Icons.event_available),
                  label: Text('Bitiş: $bitis'),
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
        _davranisTercihiKarti(),
        OutlinedButton.icon(
          onPressed: _teknikReferansGoster,
          icon: const Icon(Icons.menu_book_outlined),
          label: const Text('Teknik referans ve ayarlar rehberini aç'),
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
