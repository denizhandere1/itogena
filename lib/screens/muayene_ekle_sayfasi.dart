import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'ana_sayfa_kisayol.dart';
import '../services/veritabani_servisi.dart';
import '../services/karar_asistan_servisi.dart';

class MuayeneEkleSayfasi extends StatefulWidget {
  final int koloniDonemiId;
  final Map<String, dynamic>? muayene;
  final Map<String, dynamic>? sonMuayene;
  final String? kovanNo;
  final String? arilikAdi;

  const MuayeneEkleSayfasi({
    super.key,
    required this.koloniDonemiId,
    this.muayene,
    this.sonMuayene,
    this.kovanNo,
    this.arilikAdi,
  });

  @override
  State<MuayeneEkleSayfasi> createState() => _MuayeneEkleSayfasiState();
}

class _MuayeneEkleSayfasiState extends State<MuayeneEkleSayfasi> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _notController = TextEditingController();

  static const List<String> _yavruDuzeniSecenekleri = [
    'Blok',
    'Normal',
    'Dağınık',
    'Kambur',
  ];

  static const List<String> _mizacSecenekleri = [
    'Sakin',
    'Sinirli',
    'Saldırgan',
  ];

  static const List<String> _beslemeSecenekleri = [
    'Yok',
    '1:1 Şurup',
    '2:1 Şurup',
    'Kek',
    'Fondan',
  ];

  static const List<String> _varroaSecenekleri = [
    'Yok',
    'Drone Kesimi',
    'Bölme',
    'Timol',
    'Amitraz',
    'Formik',
    'Oksalik',
  ];

  late DateTime _tarih;
  DateTime? _anasizBaslangicTarihi;

  int _cita = 0;
  int _yavru = 0;
  int _bal = 0;

  String _yavruDuzeni = 'Normal';
  String _mizac = 'Sakin';
  String _besleme = 'Yok';
  String _varroaMucadele = 'Yok';
  String _anaKazanmaYontemi = 'kendi_anasi';
  String _not = '';

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _sesDinleniyor = false;
  bool _sesHazir = false;
  String _sesBaslangicMetni = '';

  bool _anaGorulmedi = false;
  bool _ogulBelirtisi = false;
  bool _ogulAtti = false;
  bool _bolmeYapildi = false;
  bool _kovanSondu = false;

  bool _anasizBirakildiMi = false;
  bool _anaDegisimPlanlandiMi = false;
  bool _gunlukKapaliYavruGoruldu = false;
  bool _anaKazanmaSureciAktifMi = false;

  String _memeDurumu = 'Yok';

  bool _onYuklemeYapildi = false;

  String _ustKovanNo = '-';
  String _ustArilikAdi = '-';

  @override
  void initState() {
    super.initState();

    _ustKovanNo = (widget.kovanNo ?? '').toString().trim();
    _ustArilikAdi = (widget.arilikAdi ?? '').toString().trim();

    if (widget.muayene != null) {
      _duzenlemeKaydiniYukle(widget.muayene!);
    } else if (widget.sonMuayene != null) {
      _sonMuayenedenOnYukle(widget.sonMuayene!);
    } else {
      _tarih = _bugun();
    }

    _ustBilgiyiYukle();
  }

  @override
  void dispose() {
    if (_sesDinleniyor) {
      _speech.stop();
    }
    _notController.dispose();
    super.dispose();
  }

  Future<void> _ustBilgiyiYukle() async {
    try {
      final koloni =
      await VeritabaniServisi.koloniOzetiGetir(widget.koloniDonemiId);
      if (!mounted) return;

      final surecDurumu =
      await KararAsistanServisi.surecDurumuGetir(widget.koloniDonemiId);
      final aktifSurecler = List<Map<String, dynamic>>.from(
        surecDurumu['aktifSurecler'] ?? const <Map<String, dynamic>>[],
      );
      final anaKazanmaAktif = aktifSurecler.any((s) {
        final grup = (s['grup'] ?? '').toString().toUpperCase();
        final kod = (s['kod'] ?? '').toString().toUpperCase();
        return grup == 'ANASIZLIK' ||
            kod.contains('ANASIZLIK') ||
            kod.contains('ANA_KAZANMA');
      });

      setState(() {
        final dbKovanNo = (koloni['kovanNo'] ?? '').toString().trim();
        if (dbKovanNo.isNotEmpty) {
          _ustKovanNo = dbKovanNo;
        }

        final dbArilikAdi =
        (koloni['arilikAdi'] ?? koloni['arilik'] ?? '').toString().trim();
        if (dbArilikAdi.isNotEmpty) {
          _ustArilikAdi = dbArilikAdi;
        }

        _anaKazanmaSureciAktifMi = anaKazanmaAktif ||
            _anasizBirakildiMi ||
            _gunlukKapaliYavruGoruldu;
      });
    } catch (_) {
      // Üst bilgi yüklenemese bile form çalışmaya devam etsin.
    }
  }

  void _duzenlemeKaydiniYukle(Map<String, dynamic> m) {
    _tarih = _guvenliTarihParse(m['tarih']) ?? _bugun();

    _cita = _intDeger(m['citaSayisi']);
    _yavru = _intDeger(m['yavruluCita']);
    _bal = _intDeger(m['bal_cita']);

    _yavruDuzeni = _stringDeger(
      m['yavruDuzeni'],
      varsayilan: 'Normal',
      izinliDegerler: _yavruDuzeniSecenekleri,
    );

    _mizac = _stringDeger(
      m['mizac'],
      varsayilan: 'Sakin',
      izinliDegerler: _mizacSecenekleri,
    );

    _besleme = _stringDeger(
      m['beslemeTipi'],
      varsayilan: 'Yok',
      izinliDegerler: _beslemeSecenekleri,
    );

    _varroaMucadele = _normalizeVarroaMucadele(m['varroaMucadele']);

    _not = m['notlar']?.toString() ?? '';
    _notController.text = _not;

    _anaGorulmedi = _intDeger(m['anaAriGoruldu']) == 0;
    _ogulBelirtisi = _intDeger(m['ogulBelirtisi']) == 1;
    _ogulAtti = _intDeger(m['ogulAtti']) == 1;
    _bolmeYapildi = _intDeger(m['bolmeYapildi']) == 1;
    _kovanSondu = _intDeger(m['kovanSondu']) == 1;

    _anasizBirakildiMi = _intDeger(m['anasizBirakildiMi']) == 1;
    _anaDegisimPlanlandiMi = _intDeger(m['anaDegisimPlanlandiMi']) == 1;
    _gunlukKapaliYavruGoruldu = _intDeger(m['gunlukKapaliYavruGoruldu']) == 1;
    _anaKazanmaYontemi = _normalizeAnaKazanmaYontemi(m['anaKazanmaYontemi']);

    final anasizTarihMetni = (m['anasizBaslangicTarihi'] ?? '').toString().trim();
    if (anasizTarihMetni.isNotEmpty) {
      _anasizBaslangicTarihi = _guvenliTarihParse(anasizTarihMetni);
    }

    if (_anasizBirakildiMi) {
      _anasizBaslangicTarihi ??= _tarih;
    }

    _memeDurumu = _stringDeger(
      m['memeDurumu'],
      varsayilan: 'Yok',
      izinliDegerler: const ['Yok', 'Açık', 'Kapalı', 'Çıkmış', 'Bozulmuş'],
    );
  }

  void _sonMuayenedenOnYukle(Map<String, dynamic> m) {
    _tarih = _bugun();

    _cita = _intDeger(m['citaSayisi']);
    _yavru = _intDeger(m['yavruluCita']);
    _bal = _intDeger(m['bal_cita']);

    _yavruDuzeni = _stringDeger(
      m['yavruDuzeni'],
      varsayilan: 'Normal',
      izinliDegerler: _yavruDuzeniSecenekleri,
    );

    _mizac = _stringDeger(
      m['mizac'],
      varsayilan: 'Sakin',
      izinliDegerler: _mizacSecenekleri,
    );

    _besleme = _stringDeger(
      m['beslemeTipi'],
      varsayilan: 'Yok',
      izinliDegerler: _beslemeSecenekleri,
    );

    _varroaMucadele = _normalizeVarroaMucadele(m['varroaMucadele']);

    _not = m['notlar']?.toString() ?? '';
    _notController.text = _not;

    _anaGorulmedi = false;
    _ogulBelirtisi = _intDeger(m['ogulBelirtisi']) == 1;

    _ogulAtti = false;
    _bolmeYapildi = false;
    _kovanSondu = false;

    _anasizBirakildiMi = false;
    _anaDegisimPlanlandiMi = false;
    _gunlukKapaliYavruGoruldu = false;
    _anaKazanmaYontemi = _normalizeAnaKazanmaYontemi(m['anaKazanmaYontemi']);
    _anasizBaslangicTarihi = null;

    _memeDurumu = _stringDeger(
      m['memeDurumu'],
      varsayilan: 'Yok',
      izinliDegerler: const ['Yok', 'Açık', 'Kapalı', 'Çıkmış', 'Bozulmuş'],
    );

    _onYuklemeYapildi = true;
  }

  String _normalizeAnaKazanmaYontemi(dynamic deger) {
    final temiz = (deger ?? '').toString().trim().toLowerCase();
    if (temiz == 'kapali_meme' ||
        temiz == 'kapalı ana memesi var' ||
        temiz == 'kapali ana memesi var') {
      return 'kapali_meme';
    }
    if (temiz == 'hazir_ana' ||
        temiz == 'hazır çiftleşmiş ana verildi' ||
        temiz == 'hazir ciftlesmis ana verildi') {
      return 'hazir_ana';
    }
    return 'kendi_anasi';
  }

  String _anaKazanmaYontemiMetni(String kod) {
    switch (kod) {
      case 'kapali_meme':
        return 'Hazır kapalı ana memesi var';
      case 'hazir_ana':
        return 'Hazır çiftleşmiş ana verildi';
      case 'kendi_anasi':
      default:
        return 'Kendi anasını yapacak';
    }
  }

  int _intDeger(dynamic deger) {
    if (deger == null) return 0;
    if (deger is int) return deger;
    if (deger is double) return deger.round();
    return int.tryParse(deger.toString()) ?? 0;
  }

  int? _nullableIntDeger(dynamic deger) {
    if (deger == null) return null;
    if (deger is int) return deger;
    if (deger is double) return deger.round();
    return int.tryParse(deger.toString());
  }

  String _stringDeger(
      dynamic deger, {
        required String varsayilan,
        List<String>? izinliDegerler,
      }) {
    final metin = deger?.toString().trim() ?? '';
    if (metin.isEmpty) return varsayilan;
    if (izinliDegerler != null && !izinliDegerler.contains(metin)) {
      return varsayilan;
    }
    return metin;
  }

  String _normalizeVarroaMucadele(dynamic deger) {
    final ham = (deger ?? '').toString().trim();
    if (ham.isEmpty || ham == '-' || ham.toLowerCase() == 'yok') {
      return 'Yok';
    }

    final temiz = ham.toLowerCase();
    if (temiz.contains('drone')) return 'Drone Kesimi';
    if (temiz.contains('erkek') && temiz.contains('kes')) return 'Drone Kesimi';
    if (temiz == 'bölme' || temiz == 'bolme') return 'Bölme';
    if (temiz.contains('timol')) return 'Timol';
    if (temiz.contains('amitraz') || temiz.contains('varroset')) return 'Amitraz';
    if (temiz.contains('formik')) return 'Formik';
    if (temiz.contains('oksalik')) return 'Oksalik';

    return 'Yok';
  }

  DateTime _bugun() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime? _guvenliTarihParse(dynamic deger) {
    final metin = (deger ?? '').toString().trim();
    if (metin.isEmpty) return null;

    final dogrudan = DateTime.tryParse(metin);
    if (dogrudan != null) {
      return DateTime(dogrudan.year, dogrudan.month, dogrudan.day);
    }

    if (metin.contains('.')) {
      final parcalar = metin.split('.');
      if (parcalar.length == 3) {
        final gun = int.tryParse(parcalar[0]) ?? 1;
        final ay = int.tryParse(parcalar[1]) ?? 1;
        final yil = int.tryParse(parcalar[2]) ?? DateTime.now().year;
        return DateTime(yil, ay, gun);
      }
    }

    if (metin.contains('/')) {
      final parcalar = metin.split('/');
      if (parcalar.length == 3) {
        final gun = int.tryParse(parcalar[0]) ?? 1;
        final ay = int.tryParse(parcalar[1]) ?? 1;
        final yil = int.tryParse(parcalar[2]) ?? DateTime.now().year;
        return DateTime(yil, ay, gun);
      }
    }

    return null;
  }

  String _tarihFormatla(DateTime dt) {
    final gun = dt.day.toString().padLeft(2, '0');
    final ay = dt.month.toString().padLeft(2, '0');
    final yil = dt.year.toString();
    return '$gun.$ay.$yil';
  }

  String _tarihDbFormatla(DateTime dt) {
    final yil = dt.year.toString().padLeft(4, '0');
    final ay = dt.month.toString().padLeft(2, '0');
    final gun = dt.day.toString().padLeft(2, '0');
    return '$yil-$ay-$gun';
  }

  Future<bool> _gecmisTarihOnayi({
    required DateTime mevcutTarih,
    required DateTime yeniTarih,
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
        title: const Text('Geçmiş tarih seçildi'),
        content: const Text(
          'Muayene tarihini geriye çekiyorsun. '
          'Bu doğruysa devam et. Sistem, tarih koloni başlangıcı veya arılık başlangıcı ile çelişirse kaydı engeller.',
        ),
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

  Future<void> _tarihSec() async {
    final rootContext = Navigator.of(context, rootNavigator: true).context;

    final secilen = await showDatePicker(
      context: rootContext,
      initialDate: _tarih,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      locale: const Locale('tr', 'TR'),
    );

    if (secilen == null) return;

    final yeniTarih = DateTime(secilen.year, secilen.month, secilen.day);
    final onay = await _gecmisTarihOnayi(
      mevcutTarih: _tarih,
      yeniTarih: yeniTarih,
    );

    if (!onay) return;

    setState(() {
      _tarih = yeniTarih;
      if (_anasizBirakildiMi) {
        _anasizBaslangicTarihi = _tarih;
      }
    });
  }

  void _notMetniniGuncelle(String metin) {
    _not = metin;
    if (_notController.text == metin) return;
    _notController.value = TextEditingValue(
      text: metin,
      selection: TextSelection.collapsed(offset: metin.length),
    );
  }

  Future<void> _sesleNotYaz() async {
    if (_sesDinleniyor) {
      await _speech.stop();
      if (!mounted) return;
      setState(() => _sesDinleniyor = false);
      return;
    }

    try {
      _sesHazir = await _speech.initialize(
        onStatus: (status) {
          if (!mounted) return;
          if (status == 'done' || status == 'notListening') {
            setState(() => _sesDinleniyor = false);
          }
        },
        onError: (_) {
          if (!mounted) return;
          setState(() => _sesDinleniyor = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ses algılama başlatılamadı. Android mikrofon iznini kontrol et.'),
            ),
          );
        },
      );

      if (!_sesHazir) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bu cihazda sesle yazma kullanılamıyor.'),
          ),
        );
        return;
      }

      _sesBaslangicMetni = _notController.text.trim();

      if (!mounted) return;
      setState(() => _sesDinleniyor = true);

      await _speech.listen(
        localeId: 'tr_TR',
        listenMode: stt.ListenMode.dictation,
        partialResults: true,
        cancelOnError: true,
        onResult: (result) {
          final algilanan = result.recognizedWords.trim();
          if (algilanan.isEmpty) return;

          final yeniMetin = _sesBaslangicMetni.isEmpty
              ? algilanan
              : '$_sesBaslangicMetni\n$algilanan';

          _notMetniniGuncelle(yeniMetin);
        },
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _sesDinleniyor = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesle not ekleme sırasında hata oluştu.'),
        ),
      );
    }
  }

  Future<void> _kaydet() async {
    final veri = <String, dynamic>{
      'koloniId': widget.koloniDonemiId,
      'tarih': _tarihDbFormatla(_tarih),
      'citaSayisi': _cita,
      'bal_cita': _bal,
      'yavruluCita': _yavru,
      'yavruDuzeni': _yavruDuzeni,
      'mizac': _mizac,
      'beslemeTipi': _besleme,
      'beslemeYapildi': _besleme == 'Yok' ? 0 : 1,
      'varroaMucadele': _varroaMucadele == 'Yok' ? null : _varroaMucadele,
      'anaAriGoruldu': _anaGorulmedi ? 0 : 1,
      'ogulBelirtisi': _ogulBelirtisi ? 1 : 0,
      'ogulAtti': _ogulAtti ? 1 : 0,
      'bolmeYapildi': _bolmeYapildi ? 1 : 0,
      'kovanSondu': _kovanSondu ? 1 : 0,
      'notlar': _notController.text.trim(),
      'anaUretimGirisimVarMi': 0,
      'anasizBirakildiMi': _anasizBirakildiMi ? 1 : 0,
      'anasizBaslangicTarihi':
      _anasizBirakildiMi && _anasizBaslangicTarihi != null
          ? _tarihDbFormatla(_anasizBaslangicTarihi!)
          : null,
      'anaKazanmaYontemi': _anasizBirakildiMi ? _anaKazanmaYontemi : null,
      'memeDurumu': (_anaKazanmaYontemi == 'kapali_meme'
          ? 'Kapalı'
          : (_ogulAtti ? 'Çıkmış' : (_ogulBelirtisi ? 'Kapalı' : null))),
      'anaDegisimPlanlandiMi': _anaDegisimPlanlandiMi ? 1 : 0,
      'gunlukKapaliYavruGoruldu':
      (_anaKazanmaSureciAktifMi || _anasizBirakildiMi) &&
          _gunlukKapaliYavruGoruldu
          ? 1
          : 0,
    };

    try {
      if (widget.muayene != null) {
        await VeritabaniServisi.muayeneGuncelle(widget.muayene!['id'], veri);
      } else {
        await VeritabaniServisi.muayeneEkle(veri);
      }

      final koloniOzet =
      await VeritabaniServisi.koloniOzetiGetir(widget.koloniDonemiId);
      final arilikId = _intDeger(koloniOzet['arilikId']);
      KararAsistanServisi.arilikCacheTemizle(arilikId);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Teknik sorun oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _ustKoloniBilgiKutusu() {
    final kovan = _ustKovanNo.trim().isEmpty ? '-' : _ustKovanNo.trim();
    final arilik = _ustArilikAdi.trim().isEmpty ? null : _ustArilikAdi.trim();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KOVAN: $kovan',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Colors.brown,
            ),
          ),
          if (arilik != null) ...[
            const SizedBox(height: 4),
            Text(
              'ARILIK: $arilik',
              style: const TextStyle(
                fontSize: 12.5,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _tarihKarti() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.amber.shade200),
      ),
      child: ListTile(
        leading: const Icon(Icons.calendar_today, color: Colors.brown),
        title: const Text(
          'Muayene Tarihi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(_tarihFormatla(_tarih)),
        trailing: const Icon(Icons.edit_calendar),
        onTap: _tarihSec,
      ),
    );
  }

  Widget _adimliInputKarti() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _adimliInput('Toplam', _cita, (v) => setState(() => _cita = v)),
          _adimliInput('Yavrulu', _yavru, (v) => setState(() => _yavru = v)),
          _adimliInput('Bal/Hasat', _bal, (v) => setState(() => _bal = v)),
        ],
      ),
    );
  }

  Widget _adimliInput(String etiket, int deger, Function(int) degisti) {
    return Column(
      children: [
        Text(etiket),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
              onPressed: () => degisti(deger > 0 ? deger - 1 : 0),
            ),
            Text(
              deger.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.green),
              onPressed: () => degisti(deger + 1),
            ),
          ],
        ),
      ],
    );
  }

  Widget _ikonluSecim(
      List<String> secenekler,
      String secili,
      Function(String) secildi,
      ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: secenekler
          .map(
            (s) => ChoiceChip(
          label: Text(s),
          selected: secili == s,
          selectedColor: Colors.amber,
          onSelected: (_) => secildi(s),
        ),
      )
          .toList(),
    );
  }

  Widget _hizliDropdown(
      String etiket,
      List<String> liste,
      String deger,
      Function(String?) degisti,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: deger,
        decoration: InputDecoration(
          labelText: etiket,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        items: liste
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: degisti,
      ),
    );
  }

  Widget _baslik(String metin) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        metin,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _bilgiKutusu({
    required IconData icon,
    required Color renk,
    required String metin,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: renk.withOpacity(0.30)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: renk, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              metin,
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

  Widget _bolmeBilgiKutusu() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.brown, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Yeni açılan kolonide Kaynak Koloni bilgisini girmen, soy takibi ve performans analizini güçlendirir.',
              style: TextStyle(
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

  Widget _ogulAttiBilgiKutusu() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.deepOrange.shade200),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.deepOrange, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Oğul attı, gerçekleşmiş olaydır. Seçilim ve hat değerlendirmesini etkiler.',
              style: TextStyle(
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

  Widget _onYuklemeBilgiKutusu() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.history, color: Colors.blue, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Son muayene verileri ön yüklendi. Gerekli alanları güncelleyerek devam edebilirsin.',
              style: TextStyle(
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

  Widget _gunlukKapaliYavruKapanisKutusu() {
    if (!_anaKazanmaSureciAktifMi && !_anasizBirakildiMi && !_gunlukKapaliYavruGoruldu) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: CheckboxListTile(
        value: _gunlukKapaliYavruGoruldu,
        onChanged: (v) {
          setState(() {
            _gunlukKapaliYavruGoruldu = v ?? false;
          });
        },
        activeColor: Colors.green,
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        title: const Text(
          'Günlük / kapalı yavru görüldü',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: const Text(
          'Yalnızca bölme veya anasızlık kaynaklı ana kazanma sürecinde görünür. İşaretlersen bu süreç kapanır ve koloni normal yönetim sürecine geçer.',
          style: TextStyle(fontSize: 12, height: 1.4),
        ),
      ),
    );
  }

  Widget _kaydetButonu() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 60),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: _kaydet,
        child: Text(
          widget.muayene == null ? 'KAYDET' : 'GÜNCELLE',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double altBosluk = MediaQuery.of(context).padding.bottom + 110;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: Text(
          '${_tarihFormatla(_tarih)} / Muayene Girişi',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [AnaSayfaKisayol.aksiyon(context)],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16, 16, 16, altBosluk),
                  children: [
                    _ustKoloniBilgiKutusu(),
                    if (_onYuklemeYapildi) _onYuklemeBilgiKutusu(),
                    _tarihKarti(),
                    const SizedBox(height: 16),
                    _adimliInputKarti(),
                    const SizedBox(height: 20),
                    _hizliDropdown(
                      'Yavru Düzeni',
                      _yavruDuzeniSecenekleri,
                      _yavruDuzeni,
                          (v) => setState(() => _yavruDuzeni = v!),
                    ),
                    const SizedBox(height: 4),
                    _baslik('Koloni Mizacı'),
                    _ikonluSecim(
                      _mizacSecenekleri,
                      _mizac,
                          (v) => setState(() => _mizac = v),
                    ),
                    const Divider(height: 32),
                    _hizliDropdown(
                      'Besleme',
                      _beslemeSecenekleri,
                      _besleme,
                          (v) => setState(() => _besleme = v!),
                    ),
                    _hizliDropdown(
                      'Varroa Mücadelesi',
                      _varroaSecenekleri,
                      _varroaMucadele,
                          (v) => setState(() => _varroaMucadele = v!),
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      title: const Text('Oğul Belirtisi'),
                      subtitle: const Text(
                        'Karar önerisi ve yakın izleme sinyali üretir.',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: _ogulBelirtisi,
                      onChanged: (v) => setState(() => _ogulBelirtisi = v ?? false),
                      activeColor: Colors.amber,
                      contentPadding: EdgeInsets.zero,
                    ),
                    CheckboxListTile(
                      title: const Text('Oğul Attı'),
                      subtitle: const Text(
                        'Gerçekleşmiş olaydır. Skor ve hat pozisyonunu etkiler.',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: _ogulAtti,
                      onChanged: (v) {
                        setState(() {
                          _ogulAtti = v ?? false;
                          if (_ogulAtti) {
                            _ogulBelirtisi = true;
                          }
                        });
                      },
                      activeColor: Colors.amber,
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (_ogulAtti) _ogulAttiBilgiKutusu(),
                    CheckboxListTile(
                      title: const Text('Ana Görülmedi'),
                      value: _anaGorulmedi,
                      onChanged: (v) => setState(() => _anaGorulmedi = v ?? false),
                      activeColor: Colors.amber,
                      contentPadding: EdgeInsets.zero,
                    ),
                    CheckboxListTile(
                      title: const Text('Bölme Yapıldı'),
                      subtitle: const Text(
                        'Çıta düşüşü performans kaybı değil, kontrollü çoğalma olarak yorumlanır.',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: _bolmeYapildi,
                      onChanged: (v) {
                        setState(() {
                          _bolmeYapildi = v ?? false;
                          if (!_bolmeYapildi && !_anasizBirakildiMi) {
                            _anaKazanmaYontemi = 'kendi_anasi';
                          }
                        });
                      },
                      activeColor: Colors.amber,
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (_bolmeYapildi) _bolmeBilgiKutusu(),
                    CheckboxListTile(
                      title: const Text('Kovan Söndü'),
                      subtitle: const Text(
                        'Koloninin aktif performans yerine yaşam döngüsü sonu olarak değerlendirilmesini sağlar.',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: _kovanSondu,
                      onChanged: (v) => setState(() => _kovanSondu = v ?? false),
                      activeColor: Colors.amber,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const Divider(height: 36),
                    _baslik('Ana Üretimi ve Zamanlama'),
                    _bilgiKutusu(
                      icon: Icons.schedule,
                      renk: Colors.blueGrey,
                      metin:
                      'Biyolojik ana kazanma takvimi yalnızca gerçekten anasız bırakılan koloni için çalışır. Anaç kolonideki bölme işlemi ayrı olarak toparlanma süreci üretir.',
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      title: const Text('Koloni Anasız Bırakıldı'),
                      subtitle: const Text(
                        'Gün hesabı ve biyolojik pencere yorumu için kritik bilgidir.',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: _anasizBirakildiMi,
                      onChanged: (v) {
                        setState(() {
                          _anasizBirakildiMi = v ?? false;
                          if (!_anasizBirakildiMi) {
                            _anasizBaslangicTarihi = null;
                            if (!_anaKazanmaSureciAktifMi) {
                              _gunlukKapaliYavruGoruldu = false;
                            }
                          } else {
                            _anasizBaslangicTarihi = _tarih;
                            _anaKazanmaSureciAktifMi = true;
                          }
                        });
                      },
                      activeColor: Colors.amber,
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (_anasizBirakildiMi) ...[
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _anaKazanmaYontemiMetni(_anaKazanmaYontemi),
                        decoration: const InputDecoration(
                          labelText: 'Ana Kazanma Yöntemi',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Kendi anasını yapacak',
                            child: Text('Kendi anasını yapacak'),
                          ),
                          DropdownMenuItem(
                            value: 'Hazır kapalı ana memesi var',
                            child: Text('Hazır kapalı ana memesi var'),
                          ),
                          DropdownMenuItem(
                            value: 'Hazır çiftleşmiş ana verildi',
                            child: Text('Hazır çiftleşmiş ana verildi'),
                          ),
                        ],
                        onChanged: (v) {
                          if (v == null) return;
                          setState(() {
                            if (v == 'Hazır kapalı ana memesi var') {
                              _anaKazanmaYontemi = 'kapali_meme';
                            } else if (v == 'Hazır çiftleşmiş ana verildi') {
                              _anaKazanmaYontemi = 'hazir_ana';
                            } else {
                              _anaKazanmaYontemi = 'kendi_anasi';
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      _bilgiKutusu(
                        icon: Icons.timeline,
                        renk: Colors.brown,
                        metin: _anaKazanmaYontemi == 'kapali_meme'
                            ? 'Takvim kapalı ana memesi aşamasından başlar. 5. gün meme bozma uyarısı verilmez; ana çıkışı ve yumurtlama kontrolü beklenir.'
                            : (_anaKazanmaYontemi == 'hazir_ana'
                            ? 'Meme takvimi çalışmaz. Sistem kabul ve yumurtlama kontrolü penceresine odaklanır.'
                            : 'Takvim sıfırdan ana yapma süreciyle başlar. 5. gün kapalı meme kontrolü anlamlıdır.'),
                      ),
                    ],
                    _gunlukKapaliYavruKapanisKutusu(),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _notController,
                      decoration: InputDecoration(
                        labelText: 'Notlar',
                        helperText: _sesDinleniyor
                            ? 'Dinleniyor... Konuşman not alanına yazılıyor.'
                            : 'Mikrofona dokunarak sesle not ekleyebilirsin.',
                        helperStyle: TextStyle(
                          color: _sesDinleniyor
                              ? Colors.red.shade700
                              : Colors.black54,
                          fontWeight: _sesDinleniyor
                              ? FontWeight.w800
                              : FontWeight.normal,
                        ),
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOut,
                            width: _sesDinleniyor ? 52 : 46,
                            height: _sesDinleniyor ? 52 : 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _sesDinleniyor
                                  ? Colors.red.withOpacity(0.16)
                                  : Colors.amber.withOpacity(0.18),
                              border: Border.all(
                                color: _sesDinleniyor
                                    ? Colors.red.shade400
                                    : Colors.brown.withOpacity(0.35),
                                width: _sesDinleniyor ? 2 : 1,
                              ),
                            ),
                            child: IconButton(
                              tooltip: _sesDinleniyor
                                  ? 'Sesle yazmayı durdur'
                                  : 'Sesle not ekle',
                              icon: Icon(
                                _sesDinleniyor ? Icons.mic : Icons.mic_none,
                                color: _sesDinleniyor
                                    ? Colors.red.shade700
                                    : Colors.brown,
                                size: _sesDinleniyor ? 30 : 27,
                              ),
                              onPressed: _sesleNotYaz,
                            ),
                          ),
                        ),
                        suffixIconConstraints: const BoxConstraints(
                          minWidth: 62,
                          minHeight: 62,
                        ),
                      ),
                      maxLines: 4,
                      onChanged: (v) => _not = v,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: _kaydetButonu(),
      ),
    );
  }
}