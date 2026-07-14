import 'package:flutter/material.dart';
import 'package:itogena_v45/gen_l10n/app_localizations.dart';
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
    PremiumServisi.isProNotifier.addListener(_proGuncelle);
  }

  void _proGuncelle() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    PremiumServisi.isProNotifier.removeListener(_proGuncelle);
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
        title: Text(
          AppLocalizations.of(context).formullerBaslik,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
          tabs: [
            Tab(text: AppLocalizations.of(context).formullerSekmeSurup),
            Tab(text: AppLocalizations.of(context).formullerSekmeOksalik),
            Tab(text: AppLocalizations.of(context).formullerSekmeBiyoloji),
            Tab(text: AppLocalizations.of(context).formullerSekmeBalAkimi),
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
    final l = AppLocalizations.of(context);
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
            baslik: l.fHesapSurupFormulBaslik,
            aciklama: l.fHesapSurupFormulAciklama,
          ),
          const SizedBox(height: 14),
          _bolumBaslik(l.fHesapSurupOraniBolum),
          Text(
            l.fHesapSurupOraniAciklama,
            style: const TextStyle(
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
          _bolumBaslik(l.fHesapSurupHedefBolum),
          _sayiAlani(
            controller: _toplamKgController,
            etiket: l.fHesapSurupHedefEtiket,
            yardim: l.fHesapSurupHedefYardim,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 18),
          _sonucKarti(
            baslik: '$_surupOrani ${l.fHesapSurupSonucSuffix}',
            satirlar: [
              _SonucSatiri(l.fHesapSurupHedefBolum, '${hedefSurup.toStringAsFixed(2)} kg'),
              _SonucSatiri(l.fHesapSurupSekerSatir, '${sekerMiktari.toStringAsFixed(2)} kg'),
              _SonucSatiri(l.fHesapSurupSuSatir, '${suMiktari.toStringAsFixed(2)} kg'),
              _SonucSatiri(l.fHesapSurupKatsayiSatir, katsayi.toStringAsFixed(2)),
            ],
            notMetni: l.fHesapSurupNot,
            renk: Colors.indigo,
          ),
        ],
      ),
    );
  }

  Widget _oksalikSekmesi() {
    final l = AppLocalizations.of(context);
    return SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          _ustBilgiKarti(
            icon: Icons.science_outlined,
            baslik: l.fHesapOksalikBaslik,
            aciklama: l.fHesapOksalikAciklama,
          ),
          const SizedBox(height: 18),
          _standartFormulKarti(
            baslik: l.fHesapOksalikFormulBaslik,
            satirlar: [
              _SonucSatiri(l.fHesapSurupSekerSatir, '100 g'),
              _SonucSatiri(l.fHesapSurupSuSatir, '500 g'),
              _SonucSatiri(l.fHesapOksalikTozAsitSatir, '20 g'),
              _SonucSatiri(l.fHesapOksalikUygulamaSatir, l.fHesapOksalikUygulamaDegeri),
            ],
          ),
          const SizedBox(height: 16),
          _uyariKutusu(
            renk: Colors.brown,
            baslik: l.fHesapOksalikUygulamaNotu,
            metin: l.fHesapOksalikUygulamaNotMetni,
          ),
          const SizedBox(height: 12),
          _uyariKutusu(
            renk: Colors.red,
            baslik: l.fHesapOksalikGuvenlikBaslik,
            metin: l.fHesapOksalikGuvenlikMetni,
          ),
        ],
      ),
    );
  }

  Widget _biyolojiSekmesi() {
    final l = AppLocalizations.of(context);
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

    final Map<String, String> baslangicTipleriGoster = {
      'Anasız Bırakıldı': l.fHesapBiyolojiAnasizBirakildi,
      'Bölme Yapıldı': l.fHesapBiyolojiBolmeYapildi,
      'Hazır Kapalı Ana Memesi': l.fHesapBiyolojiKapaliMeme,
      'Hazır Çiftleşmiş Ana': l.fHesapBiyolojiHazirAna,
    };

    return SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
        children: [
          _ustBilgiKarti(
            icon: Icons.timeline_outlined,
            baslik: l.fHesapBiyolojiBaslik,
            aciklama: l.fHesapBiyolojiAciklama,
          ),
          const SizedBox(height: 14),
          _bolumBaslik(l.fHesapBiyolojiAnaKazanmaBolum),
          _secimKartiLocalize(
            baslik: l.fHesapBiyolojiBaslangicTipi,
            secenekler: const [
              'Anasız Bırakıldı',
              'Bölme Yapıldı',
              'Hazır Kapalı Ana Memesi',
              'Hazır Çiftleşmiş Ana',
            ],
            displayLabels: baslangicTipleriGoster,
            seciliDeger: _biyolojiBaslangicTipi,
            onChanged: (v) => setState(() => _biyolojiBaslangicTipi = v),
          ),
          const SizedBox(height: 12),
          _tarihSecimKarti(
            baslik: l.fHesapBiyolojiBaslangicTarihi,
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
              baslik: '${baslangicTipleriGoster[_biyolojiBaslangicTipi] ?? _biyolojiBaslangicTipi} ${l.fHesapBiyolojiTakvimSuffix}',
              satirlar: _biyolojiTakvimSatirlari(takvim, l),
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
              baslik: l.fHesapBiyolojiSahaNotu,
              metin: l.fHesapBiyolojiSahaNotMetni,
            ),
          ],
          const SizedBox(height: 18),
          _bolumBaslik(l.fHesapBiyolojiIsciYavruBolum),
          _tarihSecimKarti(
            baslik: l.fHesapBiyolojiIsciYavruTarihi,
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
              baslik: l.fHesapBiyolojiIsciYavruPencere,
              satirlar: [
                _SonucSatiri(l.fHesapBiyolojiBaslangicSatir, isciTakvim['baslangic'] as String),
                _SonucSatiri(l.fHesapBiyolojiTahminiCikis, isciTakvim['cikis'] as String),
              ],
              renk: Colors.green,
            ),
          ],
          const SizedBox(height: 18),
          _bolumBaslik(l.fHesapBiyolojiErkekYavruBolum),
          _tarihSecimKarti(
            baslik: l.fHesapBiyolojiErkekYavruTarihi,
            controller: _erkekKapaliYavruTarihController,
            onTap: () async {
              final secilen = await _tarihSec(context, _erkekKapaliYavruTarihi);
              if (secilen != null) {
                setState(() {
                  _erkekKapaliYavruTarihi = secilen;
                  _erkekKapaliYavruTarihController.text = _tarihFormatla(secilen);
                });
              }
            },
          ),
          const SizedBox(height: 12),
          if (erkekTakvim != null) ...[
            _sonucKarti(
              baslik: l.fHesapBiyolojiErkekYavruPencere,
              satirlar: [
                _SonucSatiri(l.fHesapBiyolojiBaslangicSatir, erkekTakvim['baslangic'] as String),
                _SonucSatiri(l.fHesapBiyolojiTahminiCikis, erkekTakvim['cikis'] as String),
              ],
              renk: Colors.blueGrey,
            ),
          ],
        ],
      ),
    );
  }

  Widget _balAkimiSekmesi() {
    final l = AppLocalizations.of(context);
    final int cita = int.tryParse(_citaController.text) ?? 0;

    return SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          _ustBilgiKarti(
            icon: Icons.hive_outlined,
            baslik: l.fHesapBalAkimiBaslik,
            aciklama: l.fHesapBalAkimiAciklama,
          ),
          const SizedBox(height: 14),
          _tarihSecimKarti(
            baslik: l.fHesapBalAkimTarihi,
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
            etiket: l.fHesapBalAkimCitaSayisi,
            yardim: l.fHesapBalAkimCitaYardim,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 18),
          if (_balAkimTarihi == null)
            _uyariKutusu(
              renk: Colors.blueGrey,
              baslik: l.fHesapBalAkimTarihBekleniyor,
              metin: l.fHesapBalAkimTarihBekleniyorMetni,
            ),
          if (_balAkimTarihi != null && cita > 0)
            _sonucKarti(
              baslik: l.fHesapBalAkimKararBaslik,
              satirlar: _balAkimiSonucSatirlari(cita, l),
              renk: Colors.deepOrange,
            ),
        ],
      ),
    );
  }

  List<_SonucSatiri> _balAkimiSonucSatirlari(int cita, AppLocalizations l) {
    final sonuc = _hesaplaBalAkimi(cita);
    final DateTime sonTarih = sonuc['sonTarih'] as DateTime;
    final int maxCita = sonuc['maxCita'] as int;
    final int hedefMin = sonuc['hedefMin'] as int;

    final String durum = maxCita <= 0
        ? l.fHesapBalAkimGucYetersiz
        : l.fHesapBalAkimMaxCitaUyari(maxCita.toString());

    return [
      _SonucSatiri(l.fHesapBalAkimSonTarih, _tarihFormatla(sonTarih)),
      _SonucSatiri(l.fHesapBalAkimPlanlamaEsigi, l.fHesapBalAkimPlanlamaEsigiDeger),
      _SonucSatiri(l.fHesapBalAkimBiyolojikSure, l.fHesapBalAkimBiyolojikSureDeger),
      _SonucSatiri(l.fHesapBalAkimMevcutGuc, '$cita çıta'),
      _SonucSatiri(l.fHesapBalAkimHedefAltSinir, '$hedefMin çıta'),
      _SonucSatiri(l.fHesapBalAkimEnFazla, '$maxCita çıta'),
      _SonucSatiri(l.fHesapBalAkimKarar, durum),
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

  List<_SonucSatiri> _biyolojiTakvimSatirlari(BiyolojiTakvimBilgisi takvim, AppLocalizations l) {
    final List<_SonucSatiri> satirlar = [
      _SonucSatiri(l.fHesapBiyolojiBaslangicSatir, AriBiyolojiServisi.tarihMetni(takvim.baslangic)),
    ];

    if (takvim.kabulKontrolBaslangic != null) {
      satirlar.add(
        _SonucSatiri(
          l.fHesapBiyolojiKabulPencere,
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
          l.fHesapBiyolojiMemePencere,
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
          l.fHesapBiyolojiAnaCikisi,
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
          l.fHesapBiyolojiCiftlesmePencere,
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
          l.fHesapBiyolojiYumurtlamaPencere,
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
          l.fHesapBiyolojiDokunmaPencere,
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

  Widget _secimKartiLocalize({
    required String baslik,
    required List<String> secenekler,
    required Map<String, String> displayLabels,
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
              child: Text(displayLabels[e] ?? e),
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
