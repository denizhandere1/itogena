import 'package:flutter/material.dart';
import 'ana_sayfa_kisayol.dart';
import '../services/ari_biyoloji_servisi.dart';
import '../services/premium_servisi.dart';
import '../widgets/pro_kapit.dart';

class FormullerHesaplamalarSayfasi extends StatefulWidget {
  const FormullerHesaplamalarSayfasi({super.key});

  @override
  State<FormullerHesaplamalarSayfasi> createState() =>
      _FormullerHesaplamalarSayfasiState();
}

class _FormullerHesaplamalarSayfasiState
    extends State<FormullerHesaplamalarSayfasi>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController _toplamKgController =
  TextEditingController(text: '10');

  final TextEditingController _biyolojiTarihController =
  TextEditingController();
  final TextEditingController _isciKapaliYavruTarihController =
  TextEditingController();
  final TextEditingController _erkekKapaliYavruTarihController =
  TextEditingController();

  final TextEditingController _citaController =
  TextEditingController(text: '9');

  String _surupOrani = '1:1';
  String _biyolojiBaslangicTipi = 'Anasız Bırakıldı';

  DateTime? _biyolojiBaslangicTarihi;
  DateTime? _isciKapaliYavruTarihi;
  DateTime? _erkekKapaliYavruTarihi;
  DateTime? _balAkimTarihi;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _toplamKgController.dispose();
    _biyolojiTarihController.dispose();
    _isciKapaliYavruTarihController.dispose();
    _erkekKapaliYavruTarihController.dispose();
    _citaController.dispose();
    super.dispose();
  }

  double _parseDouble(TextEditingController c, double varsayilan) {
    return double.tryParse(c.text.trim().replaceAll(',', '.')) ?? varsayilan;
  }

  @override
  Widget build(BuildContext context) {
    if (!PremiumServisi.isPro) return const ProSayfaKapit(child: SizedBox.shrink());
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: const Text(
          'FORMÜLLER VE HESAPLAMALAR',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [AnaSayfaKisayol.aksiyon(context)],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelPadding: const EdgeInsets.symmetric(horizontal: 12),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black87,
          indicatorColor: Colors.brown,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'ŞURUP'),
            Tab(text: 'OKSALİK'),
            Tab(text: 'BİYOLOJİ'),
            Tab(text: 'BAL AKIMI'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _surupSekmesi(),
          _oksalikSekmesi(),
          _biyolojiSekmesi(),
          _balAkimiSekmesi(),
        ],
      ),
    );
  }

  Widget _surupSekmesi() {
    final hedefSurup = _parseDouble(_toplamKgController, 10);

    final bool birBir = _surupOrani == '1:1';
    final double katsayi = birBir ? 0.76 : 0.68;
    final double toplamGirdi = katsayi == 0 ? 0.0 : hedefSurup / katsayi;
    final double suMiktari = birBir ? toplamGirdi / 2 : toplamGirdi * (1 / 3);
    final double sekerMiktari = birBir ? toplamGirdi / 2 : toplamGirdi * (2 / 3);

    return SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          _ustBilgiKarti(
            icon: Icons.water_drop_outlined,
            baslik: 'Şurup Formülü',
            aciklama:
            'Hedef şerbet miktarını kg olarak girersen sistem kg su ve kg şeker verir. Sahada aynı ölçü kabını kullanıyorsan 1:1 veya 2:1 oranı aynı mantıkla korunur.',
          ),
          const SizedBox(height: 14),
          _bolumBaslik('Şurup Oranı'),
          const Text(
            '1:1 genelde teşvik şurubu, 2:1 genelde stok / kış hazırlığı için kullanılır. Bu ekran zorunlu uygulama emri değil, oran hesabı yardımcısıdır.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _oranChip('1:1'),
              _oranChip('2:1'),
            ],
          ),
          const SizedBox(height: 18),
          _bolumBaslik('Hedef Şerbet'),
          _sayiAlani(
            controller: _toplamKgController,
            etiket: 'Hedef şerbet miktarı',
            yardim:
            'Örnek: 10 kg hedef şerbet için gerekli kg su ve kg şeker hesaplanır.',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 18),
          _sonucKarti(
            baslik: '$_surupOrani Şurup Sonucu',
            satirlar: [
              _SonucSatiri('Hedef Şerbet', '${hedefSurup.toStringAsFixed(2)} kg'),
              _SonucSatiri('Şeker', '${sekerMiktari.toStringAsFixed(2)} kg'),
              _SonucSatiri('Su', '${suMiktari.toStringAsFixed(2)} kg'),
              _SonucSatiri('Saha Katsayısı', katsayi.toStringAsFixed(2)),
            ],
            notMetni:
            'Kg hesabı hedef şerbet ağırlığı içindir. Hacimsel kapla çalışıyorsan aynı kapla oran kur; 1:1 için eşit kap, 2:1 için iki kap şeker bir kap su mantığı korunur.',
            renk: Colors.indigo,
          ),
        ],
      ),
    );
  }

  Widget _oksalikSekmesi() {
    return SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          _ustBilgiKarti(
            icon: Icons.science_outlined,
            baslik: 'Oksalik Asit Yardımcı Hesabı',
            aciklama:
            'Bu ekran yalnızca hesaplama yardımcısıdır. Uygulama kararı için ruhsatlı ürün etiketi, yerel mevzuat ve veteriner/teknik danışman talimatı esas alınır.',
          ),
          const SizedBox(height: 18),
          _standartFormulKarti(
            baslik: '10–15 Kovan İçin Standart Formül',
            satirlar: const [
              _SonucSatiri('Şeker', '100 g'),
              _SonucSatiri('Su', '500 g'),
              _SonucSatiri('Toz oksalik asit', '20 g'),
              _SonucSatiri('Uygulama şekli', 'Damlatma'),
            ],
          ),
          const SizedBox(height: 16),
          _uyariKutusu(
            renk: Colors.brown,
            baslik: 'Uygulama Notu',
            metin:
            'Oksalik uygulaması genelde yavrusuz / yavru çok az dönemde daha anlamlıdır. Sıcaklık, doz, uygulama yöntemi ve tekrar sayısı için ürün etiketi esas alınmalıdır.',
          ),
          const SizedBox(height: 12),
          _uyariKutusu(
            renk: Colors.red,
            baslik: 'Güvenlik Uyarısı',
            metin:
            'Koruyucu gözlük, eldiven ve maske kullan. Asit buharını soluma, cilt ve göz temasından kaçın. Ruhsatsız ürün, belirsiz doz veya etiketsiz karışım kullanma. Bu ekran tedavi talimatı değil, yardımcı hesaplama ekranıdır.',
          ),
        ],
      ),
    );
  }

  Widget _biyolojiSekmesi() {
    final String anaKazanmaYontemi = _formulBiyolojiYontemi();
    final BiyolojiTakvimBilgisi? takvim = _biyolojiBaslangicTarihi == null
        ? null
        : AriBiyolojiServisi.anaKazanmaTakvimi(
            baslangic: _biyolojiBaslangicTarihi!,
            anaKazanmaYontemi: anaKazanmaYontemi,
          );

    final Map<String, dynamic>? sahaUyarisi = _biyolojiBaslangicTarihi == null
        ? null
        : AriBiyolojiServisi.sahaUyarisiUret(
            baslangic: _biyolojiBaslangicTarihi!,
            anaKazanmaYontemi: anaKazanmaYontemi,
          );

    final isciTakvim = _isciKapaliYavruTarihi == null
        ? null
        : _isciKapaliYavruTakvimi(_isciKapaliYavruTarihi!);

    final erkekTakvim = _erkekKapaliYavruTarihi == null
        ? null
        : _erkekKapaliYavruTakvimi(_erkekKapaliYavruTarihi!);

    return SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
        children: [
          _ustBilgiKarti(
            icon: Icons.timeline_outlined,
            baslik: 'Biyolojik Takvim',
            aciklama:
            'Bu ekran ana kazanma biyoloji takvimini merkezi AriBiyolojiServisi üzerinden okur. Koloni detay, süreç uyarıları ve formüller aynı tarih mantığını kullanır.',
          ),
          const SizedBox(height: 14),
          _bolumBaslik('Ana Kazanma Süreci'),
          _secimKarti(
            baslik: 'Başlangıç tipi',
            secenekler: const [
              'Anasız Bırakıldı',
              'Bölme Yapıldı',
              'Hazır Kapalı Ana Memesi',
              'Hazır Çiftleşmiş Ana',
            ],
            seciliDeger: _biyolojiBaslangicTipi,
            onChanged: (v) => setState(() => _biyolojiBaslangicTipi = v),
          ),
          const SizedBox(height: 12),
          _tarihSecimKarti(
            baslik: 'Başlangıç tarihi',
            controller: _biyolojiTarihController,
            onTap: () async {
              final secilen = await _tarihSec(context, _biyolojiBaslangicTarihi);
              if (secilen != null) {
                setState(() {
                  _biyolojiBaslangicTarihi = secilen;
                  _biyolojiTarihController.text = _tarihFormatla(secilen);
                });
              }
            },
          ),
          const SizedBox(height: 12),
          if (takvim != null) ...[
            _sonucKarti(
              baslik: '$_biyolojiBaslangicTipi Takvimi',
              satirlar: _biyolojiTakvimSatirlari(takvim),
              renk: Colors.deepOrange,
            ),
            const SizedBox(height: 12),
            if (sahaUyarisi != null)
              _uyariKutusu(
                renk: _sahaUyarisiRengi(sahaUyarisi['seviye']),
                baslik: (sahaUyarisi['baslik'] ?? 'Saha Uyarısı').toString(),
                metin: (sahaUyarisi['mesaj'] ?? '').toString(),
              ),
            const SizedBox(height: 12),
            _uyariKutusu(
              renk: Colors.deepOrange,
              baslik: 'Saha Notu',
              metin:
              'Gün sayımı başlangıç günü dahil edilerek yapılır. Günlük / kapalı yavru görülürse muayene ekranındaki ilgili kutucuk işaretlenir ve ana kazanma süreci kapanır.',
            ),
          ],
          const SizedBox(height: 18),
          _bolumBaslik('Kapalı İşçi Yavrusu Çıkışı'),
          _tarihSecimKarti(
            baslik: 'Kapalı işçi yavrusu görülen tarih',
            controller: _isciKapaliYavruTarihController,
            onTap: () async {
              final secilen = await _tarihSec(context, _isciKapaliYavruTarihi);
              if (secilen != null) {
                setState(() {
                  _isciKapaliYavruTarihi = secilen;
                  _isciKapaliYavruTarihController.text = _tarihFormatla(secilen);
                });
              }
            },
          ),
          const SizedBox(height: 12),
          if (isciTakvim != null) ...[
            _sonucKarti(
              baslik: 'Kapalı İşçi Yavrusu Çıkış Penceresi',
              satirlar: [
                _SonucSatiri('Başlangıç', isciTakvim['baslangic'] as String),
                _SonucSatiri('Tahmini çıkış', isciTakvim['cikis'] as String),
              ],
              renk: Colors.green,
            ),
          ],
          const SizedBox(height: 18),
          _bolumBaslik('Kapalı Erkek Yavrusu Çıkışı'),
          _tarihSecimKarti(
            baslik: 'Kapalı erkek yavrusu görülen tarih',
            controller: _erkekKapaliYavruTarihController,
            onTap: () async {
              final secilen = await _tarihSec(context, _erkekKapaliYavruTarihi);
              if (secilen != null) {
                setState(() {
                  _erkekKapaliYavruTarihi = secilen;
                  _erkekKapaliYavruTarihController.text =
                      _tarihFormatla(secilen);
                });
              }
            },
          ),
          const SizedBox(height: 12),
          if (erkekTakvim != null) ...[
            _sonucKarti(
              baslik: 'Kapalı Erkek Yavrusu Çıkış Penceresi',
              satirlar: [
                _SonucSatiri('Başlangıç', erkekTakvim['baslangic'] as String),
                _SonucSatiri('Tahmini çıkış', erkekTakvim['cikis'] as String),
              ],
              renk: Colors.blueGrey,
            ),
          ],
        ],
      ),
    );
  }

  Widget _balAkimiSekmesi() {
    final int cita = int.tryParse(_citaController.text) ?? 0;

    return SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          _ustBilgiKarti(
            icon: Icons.hive_outlined,
            baslik: 'Bal Akımı Kararı',
            aciklama:
            'Sistem, bal akımına zayıf girmemek için 57 günlük saha planlama eşiğini kullanır. 42 gün ise yumurtadan tarlacıya biyolojik süredir; bu ikisi aynı şey değildir.',
          ),
          const SizedBox(height: 14),
          _tarihSecimKarti(
            baslik: 'Bal akım başlangıç tarihi',
            controller: TextEditingController(
              text: _balAkimTarihi == null ? '' : _tarihFormatla(_balAkimTarihi!),
            ),
            onTap: () async {
              final secilen = await _tarihSec(context, _balAkimTarihi);
              if (secilen != null) {
                setState(() {
                  _balAkimTarihi = secilen;
                });
              }
            },
          ),
          const SizedBox(height: 12),
          _sayiAlani(
            controller: _citaController,
            etiket: 'Mevcut çıta sayısı',
            yardim: 'Örnek: 9',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 18),
          if (_balAkimTarihi == null)
            _uyariKutusu(
              renk: Colors.blueGrey,
              baslik: 'Tarih Bekleniyor',
              metin:
              'Karar üretilebilmesi için önce bal akım başlangıç tarihini seç.',
            ),
          if (_balAkimTarihi != null && cita > 0)
            _sonucKarti(
              baslik: 'Karar',
              satirlar: _balAkimiSonucSatirlari(cita),
              renk: Colors.deepOrange,
            ),
        ],
      ),
    );
  }

  List<_SonucSatiri> _balAkimiSonucSatirlari(int cita) {
    final sonuc = _hesaplaBalAkimi(cita);
    final DateTime sonTarih = sonuc['sonTarih'] as DateTime;
    final int maxCita = sonuc['maxCita'] as int;
    final int hedefMin = sonuc['hedefMin'] as int;

    final String durum = maxCita <= 0
        ? 'Bu güçte güvenli bölme penceresi açılmamış görünüyor.'
        : '$maxCita çıtadan fazla alınırsa koloni bal dönemine zayıf girebilir.';

    return [
      _SonucSatiri('Son güvenli bölme tarihi', _tarihFormatla(sonTarih)),
      _SonucSatiri('Planlama eşiği', '57 gün'),
      _SonucSatiri('Biyolojik süre', '42 gün: yumurtadan tarlacıya'),
      _SonucSatiri('Mevcut güç', '$cita çıta'),
      _SonucSatiri('Hedef alt sınır', '$hedefMin çıta'),
      _SonucSatiri('En fazla alınabilir', '$maxCita çıta'),
      _SonucSatiri('Karar', durum),
    ];
  }

  Map<String, dynamic> _hesaplaBalAkimi(int cita) {
    final DateTime sonTarih =
    _balAkimTarihi!.subtract(const Duration(days: 57));

    const int hedefMinCita = 7;

    int maxCita = cita - hedefMinCita;
    if (maxCita < 0) maxCita = 0;

    return {
      'sonTarih': sonTarih,
      'maxCita': maxCita,
      'hedefMin': hedefMinCita,
    };
  }

  String _formulBiyolojiYontemi() {
    switch (_biyolojiBaslangicTipi) {
      case 'Hazır Kapalı Ana Memesi':
        return 'kapali_meme';
      case 'Hazır Çiftleşmiş Ana':
        return 'hazir_ana';
      case 'Anasız Bırakıldı':
      case 'Bölme Yapıldı':
      default:
        return 'kendi_anasi';
    }
  }

  List<_SonucSatiri> _biyolojiTakvimSatirlari(BiyolojiTakvimBilgisi takvim) {
    final List<_SonucSatiri> satirlar = [
      _SonucSatiri('Başlangıç', AriBiyolojiServisi.tarihMetni(takvim.baslangic)),
    ];

    if (takvim.kabulKontrolBaslangic != null) {
      satirlar.add(
        _SonucSatiri(
          'Kabul kontrol penceresi',
          AriBiyolojiServisi.tarihAraligiMetni(
            takvim.kabulKontrolBaslangic,
            takvim.kabulKontrolBitis,
          ),
        ),
      );
    }

    if (takvim.memeKapanmaBaslangic != null) {
      satirlar.add(
        _SonucSatiri(
          'Tahmini meme kapanma',
          AriBiyolojiServisi.tarihAraligiMetni(
            takvim.memeKapanmaBaslangic,
            takvim.memeKapanmaBitis,
          ),
        ),
      );
    }

    if (takvim.anaCikisiBaslangic != null) {
      satirlar.add(
        _SonucSatiri(
          'Tahmini ana çıkışı',
          AriBiyolojiServisi.tarihAraligiMetni(
            takvim.anaCikisiBaslangic,
            takvim.anaCikisiBitis,
          ),
        ),
      );
    }

    if (takvim.ciftlesmeBaslangic != null) {
      satirlar.add(
        _SonucSatiri(
          'Çiftleşme uçuş penceresi',
          AriBiyolojiServisi.tarihAraligiMetni(
            takvim.ciftlesmeBaslangic,
            takvim.ciftlesmeBitis,
          ),
        ),
      );
    }

    if (takvim.yumurtlamaKontrolBaslangic != null) {
      satirlar.add(
        _SonucSatiri(
          'Yumurtlama kontrol penceresi',
          AriBiyolojiServisi.tarihAraligiMetni(
            takvim.yumurtlamaKontrolBaslangic,
            takvim.yumurtlamaKontrolBitis,
          ),
        ),
      );
    }

    if (takvim.kovanaDokunmaBaslangic != null) {
      satirlar.add(
        _SonucSatiri(
          'Kovana dokunma penceresi',
          AriBiyolojiServisi.tarihAraligiMetni(
            takvim.kovanaDokunmaBaslangic,
            takvim.kovanaDokunmaBitis,
          ),
        ),
      );
    }

    return satirlar;
  }

  Color _sahaUyarisiRengi(dynamic seviye) {
    switch ((seviye ?? '').toString().trim().toLowerCase()) {
      case 'kritik':
        return Colors.red;
      case 'uyari':
        return Colors.deepOrange;
      default:
        return Colors.blueGrey;
    }
  }

  Map<String, String> _isciKapaliYavruTakvimi(DateTime baslangic) {
    return {
      'baslangic': _tarihFormatla(baslangic),
      'cikis':
      '${_tarihFormatla(baslangic.add(const Duration(days: 11)))} - ${_tarihFormatla(baslangic.add(const Duration(days: 12)))}',
    };
  }

  Map<String, String> _erkekKapaliYavruTakvimi(DateTime baslangic) {
    return {
      'baslangic': _tarihFormatla(baslangic),
      'cikis':
      '${_tarihFormatla(baslangic.add(const Duration(days: 14)))} - ${_tarihFormatla(baslangic.add(const Duration(days: 15)))}',
    };
  }

  Future<DateTime?> _tarihSec(BuildContext context, DateTime? ilk) async {
    final secilen = await showDatePicker(
      context: context,
      initialDate: ilk ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      locale: const Locale('tr', 'TR'),
    );

    if (secilen == null) return null;
    return DateTime(secilen.year, secilen.month, secilen.day);
  }

  // Kullanıcı ekranında tarih standardı: gün.ay.yıl.
  // DB / JSON / import-export formatı bu yardımcıdan etkilenmez.
  String _tarihFormatla(DateTime dt) {
    final gun = dt.day.toString().padLeft(2, '0');
    final ay = dt.month.toString().padLeft(2, '0');
    final yil = dt.year.toString();
    return '$gun.$ay.$yil';
  }

  (double, double) _oranParcala(String oran) {
    final temiz = oran.replaceAll(' ', '');
    final parcalar = temiz.split(':');
    if (parcalar.length != 2) return (1, 1);

    final a = double.tryParse(parcalar[0]) ?? 1;
    final b = double.tryParse(parcalar[1]) ?? 1;
    return (a, b);
  }

  Widget _oranChip(String oran) {
    final secili = _surupOrani == oran;

    return ChoiceChip(
      label: Text(
        oran,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: secili ? Colors.black : Colors.black87,
        ),
      ),
      selected: secili,
      selectedColor: Colors.amber,
      onSelected: (_) {
        setState(() {
          _surupOrani = oran;
        });
      },
    );
  }

  Widget _ustBilgiKarti({
    required IconData icon,
    required String baslik,
    required String aciklama,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.amber.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.amber.shade900, size: 30),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    baslik,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    aciklama,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bolumBaslik(String metin) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        metin.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _sayiAlani({
    required TextEditingController controller,
    required String etiket,
    required String yardim,
    required Function(String) onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: etiket,
        helperText: yardim,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: const Color(0xFFFFFCF2),
      ),
    );
  }

  Widget _secimKarti({
    required String baslik,
    required List<String> secenekler,
    required String seciliDeger,
    required ValueChanged<String> onChanged,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.amber.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: DropdownButtonFormField<String>(
          value: seciliDeger,
          decoration: InputDecoration(
            labelText: baslik,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: const Color(0xFFFFFCF2),
          ),
          items: secenekler
              .map(
                (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            ),
          )
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }

  Widget _tarihSecimKarti({
    required String baslik,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: baslik,
        suffixIcon: const Icon(Icons.calendar_today_outlined),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: const Color(0xFFFFFCF2),
      ),
    );
  }

  Widget _sonucKarti({
    required String baslik,
    required List<_SonucSatiri> satirlar,
    required Color renk,
    String? notMetni,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: renk.withOpacity(0.45), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: renk,
            ),
          ),
          const SizedBox(height: 12),
          ...satirlar.map(
                (s) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.18),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.etiket,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      s.deger,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (notMetni != null && notMetni.trim().isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              notMetni,
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _standartFormulKarti({
    required String baslik,
    required List<_SonucSatiri> satirlar,
  }) {
    return _sonucKarti(
      baslik: baslik,
      satirlar: satirlar,
      renk: Colors.brown,
    );
  }

  Widget _uyariKutusu({
    required Color renk,
    required String baslik,
    required String metin,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: renk.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: TextStyle(
              color: renk,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            metin,
            style: const TextStyle(
              fontSize: 12,
              height: 1.45,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _SonucSatiri {
  final String etiket;
  final String deger;

  const _SonucSatiri(this.etiket, this.deger);
}
