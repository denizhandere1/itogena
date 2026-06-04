import 'package:flutter/material.dart';
import 'package:itogena_v45/gen_l10n/app_localizations.dart';
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
    'Yok',
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
  int _eklenenTemelPetek = 0;
  int _eklenenKabarmisPetek = 0;
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
  bool _suruplukKaldirmaPenceresiAktif = false;
  bool _suruplukKaldirildiMi = false;
  bool _suruplukKarryForward = false;
  String _suruplukKaldirmaMesaji = '';

  bool? _taniKoloniSakinMi;
  bool? _taniPolenGelisiVar;
  bool? _taniBalNektarGelisiGuclu;
  bool? _taniErkekYavruBaskin;
  bool _yavruYokTaniSorulariGoster = false;
  bool _yavruYokErkenPencereMi = false;
  String _yavruYokTaniPencereMesaji = '';

  bool _onYuklemeYapildi = false;
  bool _kaydediliyor = false;
  int _referansCita = 0;

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

  bool get _hacimAktivasyonGosterilebilir =>
      widget.muayene == null && widget.sonMuayene != null;

  int get _eklenenCitaAdedi => _hacimAktivasyonGosterilebilir
      ? (_cita - _referansCita).clamp(0, 99).toInt()
      : 0;

  void _eklenenPetekAdetleriniDengele() {
    final int artis = _eklenenCitaAdedi;
    if (artis <= 0) {
      _eklenenTemelPetek = 0;
      _eklenenKabarmisPetek = 0;
      return;
    }

    if (_eklenenTemelPetek < 0) _eklenenTemelPetek = 0;
    if (_eklenenKabarmisPetek < 0) _eklenenKabarmisPetek = 0;

    int toplam = _eklenenTemelPetek + _eklenenKabarmisPetek;
    if (toplam == 0) {
      _eklenenTemelPetek = artis;
      _eklenenKabarmisPetek = 0;
      return;
    }

    if (toplam > artis) {
      int fazla = toplam - artis;
      final int kabarmisAzalt = fazla.clamp(0, _eklenenKabarmisPetek).toInt();
      _eklenenKabarmisPetek -= kabarmisAzalt;
      fazla -= kabarmisAzalt;
      if (fazla > 0) {
        _eklenenTemelPetek =
            (_eklenenTemelPetek - fazla).clamp(0, artis).toInt();
      }
    } else if (toplam < artis) {
      _eklenenTemelPetek += artis - toplam;
    }
  }

  bool get _hasatBakimModuAktif => _bal > 0;

  bool get _yavruDuzeniYokMu => _yavruDuzeni.trim().toLowerCase() == 'yok';

  bool get _yavruYokTaniSorulariAcilmali {
    if (!_yavruDuzeniYokMu) return false;
    if (_yavruYokErkenPencereMi) return false;
    if (_yavruYokTaniSorulariGoster) return true;

    // Yavru yok işaretlenmişse kısa tanı soruları varsayılan olarak açılır.
    // Aktif ana kazanma/oğul/bölme süreci erken pencere değilse bu gözlem artık
    // saha alarmıdır; soruların bazı kolonilerde hiç çıkmaması hatalı karar
    // üretimine yol açıyordu.
    return true;
  }

  void _yavruDuzeniDegistir(String yeniDeger) {
    final bool yokSecildi = yeniDeger.trim().toLowerCase() == 'yok';
    setState(() {
      _yavruDuzeni = yeniDeger;
      if (yokSecildi) {
        _yavru = 0;
      } else {
        _taniKoloniSakinMi = null;
        _taniPolenGelisiVar = null;
        _taniBalNektarGelisiGuclu = null;
        _taniErkekYavruBaskin = null;
        _gunlukKapaliYavruGoruldu = false;
      }
    });
    _ustBilgiyiYukle();
  }

  Map<String, dynamic> _yavruYokPencereDurumunuHesapla(
    List<Map<String, dynamic>> aktifSurecler,
  ) {
    bool soruGoster = false;
    bool erkenPencere = false;
    String mesaj = '';

    for (final surec in aktifSurecler) {
      final kod = (surec['kod'] ?? '').toString().toUpperCase();
      final grup = (surec['grup'] ?? '').toString().toUpperCase();
      final baslik = (surec['baslik'] ?? '').toString();
      final surecMesaji = (surec['mesaj'] ?? '').toString();
      final birlesik = '$kod $grup $baslik $surecMesaji'.toLowerCase();

      if (kod.startsWith('YAVRU_YOK_')) {
        if (kod == 'YAVRU_YOK_NORMAL_BEKLEME' ||
            kod == 'YAVRU_YOK_ERKEN_TAKIP') {
          erkenPencere = true;
          mesaj = baslik.isNotEmpty
              ? baslik
              : 'Bu aşamada yavru görülmemesi normal olabilir.';
        } else {
          soruGoster = true;
          mesaj = baslik.isNotEmpty
              ? baslik
              : 'Yavru yokluğu için kısa tanı gözlemleri gerekli.';
        }
        continue;
      }

      if (grup == 'ANASIZLIK' ||
          grup == 'BOLME' ||
          grup == 'OGUL_SONRASI' ||
          kod.contains('ANASIZLIK') ||
          kod.contains('BOLME') ||
          kod.contains('OGUL_SONRASI')) {
        if (birlesik.contains('gereksiz açma') ||
            birlesik.contains('gereksiz acma') ||
            birlesik.contains('hassastır') ||
            birlesik.contains('hassastir') ||
            birlesik.contains('erken olabilir')) {
          erkenPencere = true;
          if (mesaj.isEmpty) {
            mesaj = 'Aktif biyolojik süreçte erken pencere olabilir.';
          }
        }

        if (birlesik.contains('gecikmiş') ||
            birlesik.contains('gecikmis') ||
            birlesik.contains('ana durumunu kontrol') ||
            birlesik.contains('toparlanma gecik')) {
          soruGoster = true;
          erkenPencere = false;
          if (mesaj.isEmpty) {
            mesaj = 'Yavru yokluğu için kısa tanı gözlemleri gerekli.';
          }
        }
      }
    }

    return {
      'soruGoster': soruGoster,
      'erkenPencere': erkenPencere && !soruGoster,
      'mesaj': mesaj,
    };
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

      final suruplukPenceresi =
          await VeritabaniServisi.suruplukKaldirmaPenceresiGetir(
        widget.koloniDonemiId,
        tarih: _tarih,
      );
      final bool suruplukPencereAktif = suruplukPenceresi['aktif'] == true;
      final bool hasatBakimModuAktif = _hasatBakimModuAktif;
      final bool hasatModuAktif = _cita >= 8 || hasatBakimModuAktif;
      final bool suruplukPencereHasatIcinAktif =
          suruplukPencereAktif && hasatModuAktif;
      final String suruplukMesaji =
          (suruplukPenceresi['mesaj'] ?? '').toString();

      final yavruYokPencere = _yavruYokPencereDurumunuHesapla(aktifSurecler);

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

        _anaKazanmaSureciAktifMi =
            anaKazanmaAktif || _anasizBirakildiMi || _gunlukKapaliYavruGoruldu;
        _yavruYokTaniSorulariGoster = yavruYokPencere['soruGoster'] == true;
        _yavruYokErkenPencereMi = yavruYokPencere['erkenPencere'] == true;
        _yavruYokTaniPencereMesaji =
            (yavruYokPencere['mesaj'] ?? '').toString();
        _suruplukKaldirmaPenceresiAktif = suruplukPencereHasatIcinAktif ||
            hasatBakimModuAktif ||
            (_suruplukKaldirildiMi && hasatModuAktif);
        // Hasat ve fallback mesajları widget'ta l10n ile üretilir; burada yalnızca
        // servis kaynaklı mesaj saklanır.
        _suruplukKaldirmaMesaji = (suruplukPencereHasatIcinAktif && !hasatBakimModuAktif)
            ? suruplukMesaji.trim()
            : '';
        if ((!suruplukPencereHasatIcinAktif || !hasatModuAktif) &&
            !hasatBakimModuAktif &&
            widget.muayene == null) {
          _suruplukKaldirildiMi = false;
        }
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
    _referansCita = _cita;

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
    _eklenenTemelPetek = _intDeger(m['eklenenTemelPetek']);
    _eklenenKabarmisPetek = _intDeger(m['eklenenKabarmisPetek']);

    _not = _taniEtiketleriniTemizle(m['notlar']?.toString() ?? '');
    _notController.text = _not;
    _taniKoloniSakinMi = null;
    _taniPolenGelisiVar = null;
    _taniBalNektarGelisiGuclu = null;
    _taniErkekYavruBaskin = null;
    _taniEtiketleriniYukle(m);

    _anaGorulmedi = _intDeger(m['anaAriGoruldu']) == 0;
    _ogulBelirtisi = _intDeger(m['ogulBelirtisi']) == 1;
    _ogulAtti = _intDeger(m['ogulAtti']) == 1;
    _bolmeYapildi = _intDeger(m['bolmeYapildi']) == 1;
    _kovanSondu = _intDeger(m['kovanSondu']) == 1;

    _anasizBirakildiMi = _intDeger(m['anasizBirakildiMi']) == 1;
    _anaDegisimPlanlandiMi = _intDeger(m['anaDegisimPlanlandiMi']) == 1;
    _gunlukKapaliYavruGoruldu = _intDeger(m['gunlukKapaliYavruGoruldu']) == 1;
    _suruplukKaldirildiMi = _intDeger(m['suruplukKaldirildiMi']) == 1;
    _anaKazanmaYontemi = _normalizeAnaKazanmaYontemi(m['anaKazanmaYontemi']);

    final anasizTarihMetni =
        (m['anasizBaslangicTarihi'] ?? '').toString().trim();
    if (anasizTarihMetni.isNotEmpty) {
      _anasizBaslangicTarihi = _guvenliTarihParse(anasizTarihMetni);
    }

    if (_anasizBirakildiMi) {
      _anasizBaslangicTarihi ??= _tarih;
    }

    if (_yavruDuzeniYokMu) {
      _yavru = 0;
    }
  }

  void _sonMuayenedenOnYukle(Map<String, dynamic> m) {
    _tarih = _bugun();

    _cita = _intDeger(m['citaSayisi']);
    _yavru = _intDeger(m['yavruluCita']);
    _bal = _intDeger(m['bal_cita']);
    _referansCita = _cita;

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
    // Önceki muayenede şurupluk kaldırıldıysa durum bu muayeneye taşınır.
    // Arıcı muayene ekranında "Şurupluk eklendi" işaretleyene kadar
    // kaldırılmış sayılmaya devam eder.
    _suruplukKarryForward = _intDeger(m['suruplukKaldirildiMi']) == 1;
    _suruplukKaldirildiMi = _suruplukKarryForward;
    _anaKazanmaYontemi = _normalizeAnaKazanmaYontemi(m['anaKazanmaYontemi']);
    _anasizBaslangicTarihi = null;

    if (_yavruDuzeniYokMu) {
      _yavru = 0;
    }

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


  int _intDeger(dynamic deger) {
    if (deger == null) return 0;
    if (deger is int) return deger;
    if (deger is double) return deger.round();
    return int.tryParse(deger.toString()) ?? 0;
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
    if (temiz.contains('amitraz') || temiz.contains('varroset'))
      return 'Amitraz';
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

  // Kullanıcı ekranında tarih standardı: gün.ay.yıl.
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

    final l = AppLocalizations.of(context);
    final onay = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.yeniKoloniGecmisTarihBaslik),
        content: Text(l.muayeneEkleGecmisTarihIcerik),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l.vazgec),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l.yeniKoloniEvetDegistir),
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

    await _ustBilgiyiYukle();
  }

  bool? _notEtiketiBoolOku(String metin, String anahtar) {
    final desen = RegExp('\\[$anahtar=([01])\\]');
    final eslesme = desen.firstMatch(metin);
    if (eslesme == null) return null;
    return eslesme.group(1) == '1';
  }

  String _taniEtiketleriniTemizle(String metin) {
    return metin
        .replaceAll(RegExp(r'\[TANI_POLEN=[01]\]\s*'), '')
        .replaceAll(RegExp(r'\[TANI_BAL_GELISI=[01]\]\s*'), '')
        .replaceAll(RegExp(r'\[TANI_ERKEK_YAVRU=[01]\]\s*'), '')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }

  String _taniEtiketleriniUygula(String metin) {
    var temiz = _taniEtiketleriniTemizle(metin);
    final etiketler = <String>[];
    if (_taniPolenGelisiVar != null) {
      etiketler.add('[TANI_POLEN=${_taniPolenGelisiVar! ? 1 : 0}]');
    }
    if (_taniBalNektarGelisiGuclu != null) {
      etiketler.add('[TANI_BAL_GELISI=${_taniBalNektarGelisiGuclu! ? 1 : 0}]');
    }
    if (_taniErkekYavruBaskin != null) {
      etiketler.add('[TANI_ERKEK_YAVRU=${_taniErkekYavruBaskin! ? 1 : 0}]');
    }

    if (etiketler.isEmpty) return temiz;
    final etiketMetni = etiketler.join(' ');
    if (temiz.isEmpty) return etiketMetni;
    return '$temiz\n$etiketMetni';
  }

  void _taniEtiketleriniYukle(Map<String, dynamic> m) {
    final notlar = (m['notlar'] ?? '').toString();
    final mizacMetni = (m['mizac'] ?? '').toString().toLowerCase();
    if (mizacMetni.contains('sakin')) {
      _taniKoloniSakinMi = true;
    } else if (mizacMetni.contains('sinirli') ||
        mizacMetni.contains('saldırgan') ||
        mizacMetni.contains('saldirgan')) {
      _taniKoloniSakinMi = false;
    } else {
      _taniKoloniSakinMi = null;
    }

    _taniPolenGelisiVar = _notEtiketiBoolOku(notlar, 'TANI_POLEN');
    _taniBalNektarGelisiGuclu =
        _notEtiketiBoolOku(notlar, 'TANI_BAL_GELISI');

    final erkekEtiketi = _notEtiketiBoolOku(notlar, 'TANI_ERKEK_YAVRU');
    final erkekMetni = (m['erkekAriDurumu'] ?? '').toString().toLowerCase();
    if (erkekEtiketi != null) {
      _taniErkekYavruBaskin = erkekEtiketi;
    } else if (erkekMetni.contains('bask')) {
      _taniErkekYavruBaskin = true;
    } else if (erkekMetni.contains('normal') || erkekMetni.contains('yok')) {
      _taniErkekYavruBaskin = false;
    } else {
      _taniErkekYavruBaskin = null;
    }
  }

  String? _erkekAriDurumuKayitDegeri() {
    if (!_yavruDuzeniYokMu || _taniErkekYavruBaskin == null) return null;
    return _taniErkekYavruBaskin!
        ? 'Erkek yavru gözleri baskın'
        : 'Erkek yavru baskısı yok';
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
          final l = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l.muayeneEkleSesHata1)),
          );
        },
      );

      if (!_sesHazir) {
        if (!mounted) return;
        final l = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.muayeneEkleSesHata2)),
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
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.muayeneEkleSesHata3)),
      );
    }
  }

  Future<void> _kaydet() async {
    if (_kaydediliyor) return;

    if (mounted) {
      setState(() {
        _kaydediliyor = true;
      });
    }

    final String kayitNotu = _yavruDuzeniYokMu
        ? _taniEtiketleriniUygula(_notController.text.trim())
        : _taniEtiketleriniTemizle(_notController.text.trim());

    final veri = <String, dynamic>{
      'koloniId': widget.koloniDonemiId,
      'tarih': _tarihDbFormatla(_tarih),
      'citaSayisi': _cita,
      'bal_cita': _bal,
      'yavruluCita': _yavruDuzeniYokMu ? 0 : _yavru,
      'yavruDuzeni': _yavruDuzeni,
      'mizac': _yavruDuzeniYokMu && _taniKoloniSakinMi != null
          ? (_taniKoloniSakinMi! ? 'Sakin' : 'Sinirli')
          : _mizac,
      'beslemeTipi': _besleme,
      'beslemeYapildi': _besleme == 'Yok' ? 0 : 1,
      'varroaMucadele': _varroaMucadele == 'Yok' ? null : _varroaMucadele,
      'anaAriGoruldu': _anaGorulmedi ? 0 : 1,
      'ogulBelirtisi': _ogulBelirtisi ? 1 : 0,
      'ogulAtti': _ogulAtti ? 1 : 0,
      'bolmeYapildi': _bolmeYapildi ? 1 : 0,
      'kovanSondu': _kovanSondu ? 1 : 0,
      'notlar': kayitNotu,
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
      'erkekAriDurumu': _erkekAriDurumuKayitDegeri(),
      'anaDegisimPlanlandiMi': _anaDegisimPlanlandiMi ? 1 : 0,
      'gunlukKapaliYavruGoruldu':
          (_anaKazanmaSureciAktifMi ||
                      _anasizBirakildiMi ||
                      _yavruDuzeniYokMu ||
                      _yavruYokTaniSorulariGoster) &&
                  _gunlukKapaliYavruGoruldu
              ? 1
              : 0,
      'suruplukKaldirildiMi': _suruplukKaldirildiMi ? 1 : 0,
      'suruplukKaldirmaManuelMi': _suruplukKaldirildiMi ? 1 : 0,
      'eklenenPetekTipi': _eklenenCitaAdedi > 0
          ? (_eklenenKabarmisPetek > 0 && _eklenenTemelPetek > 0
              ? 'Karışık petek'
              : (_eklenenKabarmisPetek > 0 ? 'Kabarmış petek' : 'Temel petek'))
          : null,
      'eklenenTemelPetek': _eklenenCitaAdedi > 0 ? _eklenenTemelPetek : 0,
      'eklenenKabarmisPetek': _eklenenCitaAdedi > 0 ? _eklenenKabarmisPetek : 0,
    };

    try {
      if (widget.muayene != null) {
        await VeritabaniServisi.muayeneGuncelle(widget.muayene!['id'], veri);
      } else {
        await VeritabaniServisi.muayeneEkle(veri);
      }

      // Kayıt sonrası gereksiz arılık/donör cache temizliği ve ek koloni sorgusu
      // form kapanışını yavaşlatıyordu. Muayene değişikliği doğrudan bu koloniyi
      // etkiler; arılık düzeyi ağır analiz, listeye dönüldüğünde zaten yenilenir.
      KararAsistanServisi.koloniCacheTemizle(widget.koloniDonemiId);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _kaydediliyor = false;
        });
        final l = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.muayeneEkleKayitHata(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _ustKoloniBilgiKutusu() {
    final l = AppLocalizations.of(context);
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
            l.muayeneEkleKovanEtiket(kovan),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Colors.brown,
            ),
          ),
          if (arilik != null) ...[
            const SizedBox(height: 4),
            Text(
              l.muayeneEkleArilikEtiket(arilik),
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
    final l = AppLocalizations.of(context);
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.amber.shade200),
      ),
      child: ListTile(
        leading: const Icon(Icons.calendar_today, color: Colors.brown),
        title: Text(
          l.muayeneEkleMuayeneTarihi,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(_tarihFormatla(_tarih)),
        trailing: const Icon(Icons.edit_calendar),
        onTap: _tarihSec,
      ),
    );
  }

  Future<void> _citaSayisiniGuncelle(int v) async {
    if (!mounted) return;
    setState(() {
      _cita = v;
      if (_yavru > _cita) _yavru = _cita;
      if (_bal > _cita) _bal = _cita;
      _eklenenPetekAdetleriniDengele();
    });
    await _ustBilgiyiYukle();
  }

  Future<void> _yavruluCitaSayisiniGuncelle(int v) async {
    if (!mounted) return;
    setState(() {
      _yavru = v.clamp(0, _cita).toInt();
      if (_yavru > 0 && _yavruDuzeniYokMu) {
        _yavruDuzeni = 'Normal';
      }
    });
  }

  Future<void> _balCitaSayisiniGuncelle(int v) async {
    if (!mounted) return;
    setState(() {
      _bal = v.clamp(0, _cita).toInt();
    });
    await _ustBilgiyiYukle();
  }

  Widget _adimliInputKarti() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Builder(builder: (context) {
        final l = AppLocalizations.of(context);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _adimliInput(l.muayeneEkleToplam, _cita, _citaSayisiniGuncelle),
            _adimliInput(l.muayeneEkleYavrulu, _yavru, _yavruluCitaSayisiniGuncelle),
            _adimliInput(l.muayeneEkleBalHasat, _bal, _balCitaSayisiniGuncelle),
          ],
        );
      }),
    );
  }

  Widget _petekAktivasyonKutusu() {
    if (!_hacimAktivasyonGosterilebilir) return const SizedBox.shrink();

    final int artis = _eklenenCitaAdedi;
    if (artis <= 0) return const SizedBox.shrink();

    _eklenenPetekAdetleriniDengele();

    final bool katGecisi = _referansCita >= 9 && _cita >= 11;
    final bool aniArtis = artis >= 3 && !katGecisi;
    final Color renk = aniArtis
        ? Colors.deepOrange
        : (katGecisi ? Colors.amber.shade800 : Colors.green.shade700);
    final Color zemin =
        aniArtis ? const Color(0xFFFFF3E0) : const Color(0xFFE8F5E9);
    final l = AppLocalizations.of(context);
    final String metin = aniArtis
        ? l.muayeneEklePetekAktivasyonAniArtis(artis)
        : (katGecisi
            ? l.muayeneEklePetekAktivasyonKatGecis
            : l.muayeneEklePetekAktivasyonNormal);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12, bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: zemin,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: renk.withOpacity(0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.muayeneEklePetekAktivasyonBaslik(artis),
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: renk,
            ),
          ),
          const SizedBox(height: 8),
          Text(metin, style: const TextStyle(fontSize: 12, height: 1.4)),
          const SizedBox(height: 10),
          Text(
            l.muayeneEklePetekDagilimBilgi,
            style: const TextStyle(
                fontSize: 12, height: 1.35, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _petekAdetSecici(
                  l.muayeneEkleTemel,
                  _eklenenTemelPetek,
                  (v) => setState(() {
                    _eklenenTemelPetek = v.clamp(0, artis).toInt();
                    final int toplam =
                        _eklenenTemelPetek + _eklenenKabarmisPetek;
                    if (toplam > artis) {
                      _eklenenKabarmisPetek =
                          (artis - _eklenenTemelPetek).clamp(0, artis).toInt();
                    }
                  }),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _petekAdetSecici(
                  l.muayeneEkleKabarmis,
                  _eklenenKabarmisPetek,
                  (v) => setState(() {
                    _eklenenKabarmisPetek = v.clamp(0, artis).toInt();
                    final int toplam =
                        _eklenenTemelPetek + _eklenenKabarmisPetek;
                    if (toplam > artis) {
                      _eklenenTemelPetek = (artis - _eklenenKabarmisPetek)
                          .clamp(0, artis)
                          .toInt();
                    }
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l.muayeneEklePetekToplam(_eklenenTemelPetek + _eklenenKabarmisPetek, artis),
            style: const TextStyle(fontSize: 11.8, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _petekAdetSecici(String etiket, int deger, Function(int) degisti) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.brown.shade100),
      ),
      child: Column(
        children: [
          Text(
            etiket,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, size: 22),
                onPressed: () => degisti(deger > 0 ? deger - 1 : 0),
              ),
              Text(
                deger.toString(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 22),
                onPressed: () => degisti(deger + 1),
              ),
            ],
          ),
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
    Function(String?) degisti, {
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: deger,
        decoration: InputDecoration(
          labelText: etiket,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey.shade100,
        ),
        items: liste
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: enabled ? degisti : null,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Colors.brown, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppLocalizations.of(context).muayeneEkleBolmeBilgi,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.deepOrange, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppLocalizations.of(context).muayeneEkleOgulAttiBilgi,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.history, color: Colors.blue, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppLocalizations.of(context).muayeneEkleOnYuklemeBilgi,
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

  Widget _gunlukKapaliYavruKapanisKutusu() {
    if (!_anaKazanmaSureciAktifMi &&
        !_anasizBirakildiMi &&
        !_yavruDuzeniYokMu &&
        !_yavruYokTaniSorulariGoster &&
        !_gunlukKapaliYavruGoruldu) {
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
        title: Text(
          AppLocalizations.of(context).muayeneEkleGunlukYavruBaslik,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: Text(
          AppLocalizations.of(context).muayeneEkleGunlukYavruAciklama,
          style: const TextStyle(fontSize: 12, height: 1.4),
        ),
      ),
    );
  }


  Widget _yavruYokBilgiKutusu() {
    if (!_yavruDuzeniYokMu) return const SizedBox.shrink();

    final l = AppLocalizations.of(context);
    final String metin = _yavruYokErkenPencereMi
        ? '${l.muayeneEkleYavruYokErken} ${_yavruYokTaniPencereMesaji.isNotEmpty ? _yavruYokTaniPencereMesaji : l.muayeneEkleYavruYokErkenVarsayilan}'
        : (_yavruYokTaniSorulariAcilmali
            ? l.muayeneEkleYavruYokTani
            : l.muayeneEkleYavruYokNormal);

    return _bilgiKutusu(
      icon: Icons.info_outline,
      renk: Colors.blueGrey,
      metin: metin,
    );
  }

  Widget _taniSecenekSatiri({
    required String baslik,
    required String aciklama,
    required bool? deger,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            aciklama,
            style: const TextStyle(fontSize: 11.8, height: 1.35),
          ),
          const SizedBox(height: 8),
          Builder(builder: (context) {
            final l = AppLocalizations.of(context);
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: Text(l.evet),
                  selected: deger == true,
                  selectedColor: Colors.amber,
                  onSelected: (_) => setState(() => onChanged(true)),
                ),
                ChoiceChip(
                  label: Text(l.hayir),
                  selected: deger == false,
                  selectedColor: Colors.amber.shade100,
                  onSelected: (_) => setState(() => onChanged(false)),
                ),
                ChoiceChip(
                  label: Text(l.muayeneEkleTaniEminDegil),
                  selected: deger == null,
                  selectedColor: Colors.grey.shade200,
                  onSelected: (_) => setState(() => onChanged(null)),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _yavruYokTaniSorulariKutusu() {
    if (!_yavruYokTaniSorulariAcilmali) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Builder(builder: (context) {
            final l = AppLocalizations.of(context);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.muayeneEkleYavruYokTaniBaslik,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l.muayeneEkleYavruYokTaniAciklama,
                  style: const TextStyle(fontSize: 12, height: 1.4),
                ),
                const SizedBox(height: 10),
                _taniSecenekSatiri(
                  baslik: l.muayeneEkleTaniKoloniSakin,
                  aciklama: l.muayeneEkleTaniKoloniSakinAciklama,
                  deger: _taniKoloniSakinMi,
                  onChanged: (v) {
                    _taniKoloniSakinMi = v;
                    if (v == true) {
                      _mizac = 'Sakin';
                    } else if (v == false) {
                      _mizac = 'Sinirli';
                    }
                  },
                ),
                _taniSecenekSatiri(
                  baslik: l.muayeneEkleTaniPolen,
                  aciklama: l.muayeneEkleTaniPolenAciklama,
                  deger: _taniPolenGelisiVar,
                  onChanged: (v) => _taniPolenGelisiVar = v,
                ),
                _taniSecenekSatiri(
                  baslik: l.muayeneEkleTaniBal,
                  aciklama: l.muayeneEkleTaniBalAciklama,
                  deger: _taniBalNektarGelisiGuclu,
                  onChanged: (v) => _taniBalNektarGelisiGuclu = v,
                ),
                _taniSecenekSatiri(
                  baslik: l.muayeneEkleTaniErkek,
                  aciklama: l.muayeneEkleTaniErkekAciklama,
                  deger: _taniErkekYavruBaskin,
                  onChanged: (v) => _taniErkekYavruBaskin = v,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _suruplukKaldirmaKutusu() {
    // Önceki muayeneden taşınan "kaldırıldı" durumu → "eklendi mi?" seçeneği göster
    if (_suruplukKarryForward && _suruplukKaldirildiMi) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8, bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F0FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.deepPurple.shade200),
        ),
        child: CheckboxListTile(
          value: false,
          onChanged: (v) {
            if (v == true) {
              setState(() {
                _suruplukKaldirildiMi = false;
                _suruplukKarryForward = false;
              });
            }
          },
          activeColor: Colors.deepPurple,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(
            AppLocalizations.of(context).muayeneEkleSuruplukEklendi,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          subtitle: Text(
            AppLocalizations.of(context).muayeneEkleSuruplukEklendiAciklama,
            style: const TextStyle(fontSize: 12, height: 1.4),
          ),
        ),
      );
    }

    if (!_suruplukKaldirmaPenceresiAktif && !_suruplukKaldirildiMi) {
      return const SizedBox.shrink();
    }

    final l = AppLocalizations.of(context);
    final mesaj = _suruplukKaldirmaMesaji.trim().isEmpty
        ? l.muayeneEkleSuruplukVarsayilanMesaj
        : _suruplukKaldirmaMesaji.trim();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: CheckboxListTile(
        value: _suruplukKaldirildiMi,
        onChanged: (v) {
          setState(() {
            _suruplukKaldirildiMi = v ?? false;
            if (_suruplukKaldirildiMi && !_hasatBakimModuAktif) {
              _besleme = 'Yok';
            }
          });
        },
        activeColor: Colors.orange,
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          l.muayeneEkleSuruplukKaldirildi,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: Text(
          _hasatBakimModuAktif
              ? '$mesaj ${l.muayeneEkleSuruplukKaldirildiHasat}'
              : '$mesaj ${l.muayeneEkleSuruplukKaldirildiNormal}',
          style: const TextStyle(fontSize: 12, height: 1.4),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: _kaydediliyor ? null : _kaydet,
        child: _kaydediliyor
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.black,
                ),
              )
            : Text(
                widget.muayene == null
                    ? AppLocalizations.of(context).muayeneEkleKaydet
                    : AppLocalizations.of(context).muayeneEkleGuncelle,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final double altBosluk = MediaQuery.of(context).padding.bottom + 110;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: Text(
          l.muayeneEkleAppBarBaslik(_tarihFormatla(_tarih)),
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
                    _petekAktivasyonKutusu(),
                    const SizedBox(height: 20),
                    _hizliDropdown(
                      l.muayeneEkleYavruDuzeniLabel,
                      _yavruDuzeniSecenekleri,
                      _yavruDuzeni,
                      (v) {
                        if (v == null) return;
                        _yavruDuzeniDegistir(v);
                      },
                    ),
                    _yavruYokBilgiKutusu(),
                    _yavruYokTaniSorulariKutusu(),
                    const SizedBox(height: 4),
                    _baslik(l.muayeneEkleKoloniMizaci),
                    _ikonluSecim(
                      _mizacSecenekleri,
                      _mizac,
                      (v) => setState(() => _mizac = v),
                    ),
                    const Divider(height: 32),
                    _hizliDropdown(
                      l.muayeneEkleBeslemeLabel,
                      _beslemeSecenekleri,
                      _besleme,
                      (v) => setState(() => _besleme = v!),
                      enabled: !_suruplukKaldirildiMi || _hasatBakimModuAktif,
                    ),
                    if (_suruplukKaldirildiMi && !_hasatBakimModuAktif)
                      _bilgiKutusu(
                        icon: Icons.no_food,
                        renk: Colors.orange,
                        metin: l.muayeneEkleBeslemeSuruplukBilgi,
                      ),
                    if (_hasatBakimModuAktif)
                      _bilgiKutusu(
                        icon: Icons.restore,
                        renk: Colors.green,
                        metin: l.muayeneEkleHasatBakimBilgi,
                      ),
                    _suruplukKaldirmaKutusu(),
                    _hizliDropdown(
                      l.muayeneEkleVarroaLabel,
                      _varroaSecenekleri,
                      _varroaMucadele,
                      (v) => setState(() => _varroaMucadele = v!),
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      title: Text(l.muayeneEkleOgulBelirtisiBaslik),
                      subtitle: Text(
                        l.muayeneEkleOgulBelirtisiAciklama,
                        style: const TextStyle(fontSize: 12),
                      ),
                      value: _ogulBelirtisi,
                      onChanged: (v) =>
                          setState(() => _ogulBelirtisi = v ?? false),
                      activeColor: Colors.amber,
                      contentPadding: EdgeInsets.zero,
                    ),
                    CheckboxListTile(
                      title: Text(l.muayeneEkleOgulAttiBaslik),
                      subtitle: Text(
                        l.muayeneEkleOgulAttiAciklama,
                        style: const TextStyle(fontSize: 12),
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
                      title: Text(l.muayeneEkleAnaGorulmedi),
                      value: _anaGorulmedi,
                      onChanged: (v) =>
                          setState(() => _anaGorulmedi = v ?? false),
                      activeColor: Colors.amber,
                      contentPadding: EdgeInsets.zero,
                    ),
                    CheckboxListTile(
                      title: Text(l.muayeneEkleBolmeYapildiBaslik),
                      subtitle: Text(
                        l.muayeneEkleBolmeYapildiAciklama,
                        style: const TextStyle(fontSize: 12),
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
                      title: Text(l.muayeneEkleKovanSonduBaslik),
                      subtitle: Text(
                        l.muayeneEkleKovanSonduAciklama,
                        style: const TextStyle(fontSize: 12),
                      ),
                      value: _kovanSondu,
                      onChanged: (v) =>
                          setState(() => _kovanSondu = v ?? false),
                      activeColor: Colors.amber,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const Divider(height: 36),
                    _baslik(l.muayeneEkleAnauretimBaslik),
                    _bilgiKutusu(
                      icon: Icons.schedule,
                      renk: Colors.blueGrey,
                      metin: l.muayeneEkleAnauretimBilgi,
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      title: Text(l.muayeneEkleAnasizBirakildiBaslik),
                      subtitle: Text(
                        l.muayeneEkleAnasizBirakildiAciklama,
                        style: const TextStyle(fontSize: 12),
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
                        value: _anaKazanmaYontemi,
                        decoration: InputDecoration(
                          labelText: l.yeniKoloniAnaKazanmaLabel,
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'kendi_anasi',
                            child: Text(l.muayeneDetayKendiAnasi),
                          ),
                          DropdownMenuItem(
                            value: 'kapali_meme',
                            child: Text(l.muayeneDetayKapaliMeme),
                          ),
                          DropdownMenuItem(
                            value: 'hazir_ana',
                            child: Text(l.muayeneDetayHazirAna),
                          ),
                        ],
                        onChanged: (v) {
                          if (v == null) return;
                          setState(() => _anaKazanmaYontemi = v);
                        },
                      ),
                      const SizedBox(height: 8),
                      _bilgiKutusu(
                        icon: Icons.timeline,
                        renk: Colors.brown,
                        metin: _anaKazanmaYontemi == 'kapali_meme'
                            ? l.yeniKoloniAnaKazanmaBilgiKapaliMeme
                            : (_anaKazanmaYontemi == 'hazir_ana'
                                ? l.yeniKoloniAnaKazanmaBilgiHazirAna
                                : l.yeniKoloniAnaKazanmaBilgiKendiAnasi),
                      ),
                    ],
                    _gunlukKapaliYavruKapanisKutusu(),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _notController,
                      decoration: InputDecoration(
                        labelText: l.muayeneEkleNotlarLabel,
                        helperText: _sesDinleniyor
                            ? l.muayeneEkleSesHelperAktif
                            : l.muayeneEkleSesHelper,
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
                                  ? l.muayeneEkleSesDurdur
                                  : l.muayeneEkleSesBasla,
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
