import 'package:flutter/material.dart';
import 'ana_sayfa_kisayol.dart';
import '../services/veritabani_servisi.dart';
import '../services/karar_asistan_servisi.dart';
import 'package:itogena_v45/gen_l10n/app_localizations.dart';

class YeniKoloniSayfasi extends StatefulWidget {
  final Map<String, dynamic>? koloni;
  final int? arilikId;

  const YeniKoloniSayfasi({
    super.key,
    this.koloni,
    this.arilikId,
  });

  @override
  State<YeniKoloniSayfasi> createState() => _YeniKoloniSayfasiState();
}

class _YeniKoloniSayfasiState extends State<YeniKoloniSayfasi> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _noCont;
  late TextEditingController _siraCont;
  late TextEditingController _notCont;
  late TextEditingController _kaynakKoloniCont;
  late TextEditingController _citaCont;
  late TextEditingController _tarihCont;

  late DateTime _olusturmaTarihi;
  int? _seciliKaynakKoloniId;

  String _anaYili = DateTime.now().year.toString();
  String _kaynakTipi = 'Bölme';
  String _anaKazanmaYontemi = 'kendi_anasi';
  String _kovanTipi = 'Langstroth';
  bool _suruplukVarMi = false;

  bool _yukleniyor = true;
  bool _kaydediliyor = false;
  List<Map<String, dynamic>> _arilikKolonileri = [];

  int? get _aktifArilikId =>
      widget.arilikId ?? _toInt(widget.koloni?['arilikId']);

  bool get _kaynakKoloniGerekli =>
      _kaynakTipi == 'Bölme' || _kaynakTipi == 'Oğul';

  bool get _anaKazanmaYontemiSecimiGoster => _kaynakTipi == 'Bölme';

  @override
  void initState() {
    super.initState();

    _noCont = TextEditingController(
      text: widget.koloni?['kovanNo']?.toString() ?? '',
    );
    _siraCont = TextEditingController(
      text: widget.koloni?['sahaSirasi']?.toString() ?? '',
    );
    _notCont = TextEditingController(
      text: widget.koloni?['notMetni']?.toString() ?? '',
    );
    _kaynakKoloniCont = TextEditingController(
      text: _baslangicKaynakKoloniMetni(),
    );
    _citaCont = TextEditingController(
      text: widget.koloni?['sonCita']?.toString() ?? '0',
    );
    _olusturmaTarihi = _guvenliTarihParse(widget.koloni?["olusturmaTarihi"]) ?? _bugun();
    _tarihCont = TextEditingController(
      text: _tarihFormatla(_olusturmaTarihi),
    );
    final mevcutKaynakKoloniId = _toInt(widget.koloni?['kaynakKoloniId']);
    final mevcutKaynakKoloniMetni =
        widget.koloni?['kaynakKoloni']?.toString().trim().toLowerCase() ?? '';
    _seciliKaynakKoloniId = mevcutKaynakKoloniId > 0
        ? mevcutKaynakKoloniId
        : ((mevcutKaynakKoloniMetni == 'dış kaynak' ||
        mevcutKaynakKoloniMetni == 'dis kaynak' ||
        mevcutKaynakKoloniMetni == 'koloni dışı' ||
        mevcutKaynakKoloniMetni == 'koloni disi')
        ? -1
        : null);

    final anaYiliMetin = widget.koloni?['anaYili']?.toString().trim() ?? '';
    if (anaYiliMetin.isNotEmpty) {
      _anaYili = anaYiliMetin;
    }

    final kaynakTipiMetin = widget.koloni?['kaynakTipi']?.toString().trim() ?? '';
    if (kaynakTipiMetin.isNotEmpty) {
      _kaynakTipi = _normalizeKaynakTipi(kaynakTipiMetin);
    }

    _anaKazanmaYontemi = _normalizeAnaKazanmaYontemi(
      widget.koloni?['anaKazanmaYontemi'],
    );
    _kovanTipi = _normalizeKovanTipi(widget.koloni?['kovanTipi']);
    _suruplukVarMi = _toBool(widget.koloni?['suruplukVarMi']);
    if (_kaynakTipi == 'Oğul') {
      _anaKazanmaYontemi = 'hazir_ana';
    }

    _verileriYukle();
  }

  String _baslangicKaynakKoloniMetni() {
    final kaynak = widget.koloni?['kaynakKoloni']?.toString().trim() ?? '';
    if (kaynak == '-' || kaynak.toLowerCase() == 'dış kaynak' || kaynak.toLowerCase() == 'dis kaynak') {
      return '';
    }
    return kaynak;
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

  String _kaynakTipiMetni(BuildContext context, String kod) {
    final l = AppLocalizations.of(context);
    switch (kod) {
      case 'Ana Hat': return l.yeniKoloniKaynakAnaHat;
      case 'Oğul': return l.yeniKoloniKaynakOgul;
      case 'Bölme':
      default: return l.yeniKoloniKaynakBolme;
    }
  }

  String _normalizeKaynakTipi(String tip) {
    final temiz = tip.trim().toLowerCase();
    if (temiz == 'satın alma' ||
        temiz == 'satınalma' ||
        temiz == 'paket arı' ||
        temiz == 'paket ari' ||
        temiz == 'dış kaynak' ||
        temiz == 'dis kaynak') {
      return 'Bölme';
    }
    if (temiz == 'ana hat') return 'Ana Hat';
    if (temiz == 'oğul' || temiz == 'ogul') return 'Oğul';
    if (temiz == 'bölme' || temiz == 'bolme') return 'Bölme';
    return 'Bölme';
  }

  String _normalizeKovanTipi(dynamic deger) {
    final temiz = (deger ?? '').toString().trim().toLowerCase();
    if (temiz.contains('dadant')) return 'Dadant';
    return 'Langstroth';
  }

  bool _toBool(dynamic deger) {
    if (deger == true) return true;
    if (deger is int) return deger == 1;
    final temiz = (deger ?? '').toString().trim().toLowerCase();
    return temiz == '1' || temiz == 'true' || temiz == 'evet' || temiz == 'var';
  }

  DateTime _bugun() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime? _guvenliTarihParse(dynamic deger) {
    final metin = (deger ?? '').toString().trim();
    if (metin.isEmpty) return null;
    return DateTime.tryParse(metin);
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

  Future<bool> _gecmisTarihOnayi({
    required DateTime mevcutTarih,
    required DateTime yeniTarih,
  }) async {
    final l = AppLocalizations.of(context);
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
        title: Text(l.yeniKoloniGecmisTarihBaslik),
        content: Text(l.yeniKoloniGecmisTarihIcerik),
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

  Future<void> _olusturmaTarihiSec() async {
    final secilen = await showDatePicker(
      context: context,
      locale: const Locale('tr', 'TR'),
      initialDate: _olusturmaTarihi,
      firstDate: DateTime(2000, 1, 1),
      lastDate: _bugun(),
    );

    if (secilen == null) return;

    final yeniTarih = DateTime(secilen.year, secilen.month, secilen.day);
    final onay = await _gecmisTarihOnayi(
      mevcutTarih: _olusturmaTarihi,
      yeniTarih: yeniTarih,
    );

    if (!onay) return;

    setState(() {
      _olusturmaTarihi = yeniTarih;
      _tarihCont.text = _tarihFormatla(_olusturmaTarihi);
    });
  }


  @override
  void dispose() {
    _noCont.dispose();
    _siraCont.dispose();
    _notCont.dispose();
    _kaynakKoloniCont.dispose();
    _citaCont.dispose();
    _tarihCont.dispose();
    super.dispose();
  }

  Future<void> _verileriYukle() async {
    final arilikId = _aktifArilikId;

    if (arilikId != null && arilikId > 0) {
      final koloniler = await VeritabaniServisi.kovanlariAriligaGoreGetir(
        arilikId,
        sadeceAktifler: true,
      );

      if (!mounted) return;
      setState(() {
        _arilikKolonileri = koloniler;
        _yukleniyor = false;
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      _arilikKolonileri = [];
      _yukleniyor = false;
    });
  }

  Map<String, dynamic>? _seciliKaynakKoloniKaydi() {
    final hedefId = _seciliKaynakKoloniId;
    if (hedefId == null || hedefId <= 0) return null;

    for (final koloni in _arilikKolonileri) {
      if (_toInt(koloni['id']) == hedefId) {
        return koloni;
      }
    }
    return null;
  }

  Future<void> _kaydet() async {
    if (_kaydediliyor) return;
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _kaydediliyor = true;
    });

    final l = AppLocalizations.of(context);

    try {
      final aktifKovanNo = _noCont.text.trim();
      final bool disKaynakSecildi = _seciliKaynakKoloniId == -1;
      final kaynakKoloni = disKaynakSecildi
          ? 'Dış Kaynak'
          : _kaynakKoloniCont.text.trim();

      Map<String, dynamic>? kaynakKaydi;

      if (_kaynakKoloniGerekli && !disKaynakSecildi) {
        kaynakKaydi = _seciliKaynakKoloniKaydi();
        if (kaynakKaydi == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.yeniKoloniKaynakBulunamadi),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      final veri = <String, dynamic>{
        'arilikId': _aktifArilikId,
        'kovanNo': aktifKovanNo,
        'ilkKovanNo': widget.koloni?['ilkKovanNo']?.toString().trim().isNotEmpty == true
            ? widget.koloni!['ilkKovanNo']
            : aktifKovanNo,
        'sahaSirasi': int.tryParse(_siraCont.text.trim()) ?? 0,
        'anaYili': _anaYili,
        'olusturmaTarihi': _isoTarih(_olusturmaTarihi),
        'kaynakTipi': _kaynakTipi,
        'kaynakKoloni': _kaynakKoloniGerekli ? kaynakKoloni : '-',
        'kaynakKoloniId': (_kaynakKoloniGerekli && !disKaynakSecildi) ? _toInt(kaynakKaydi?['id']) : null,
        'kaynakKovanNoSnapshot': (_kaynakKoloniGerekli && !disKaynakSecildi)
            ? ((kaynakKaydi?['ilkKovanNo'] ?? kaynakKaydi?['kovanNo'])?.toString())
            : null,
        'anaKazanmaYontemi': _kaynakTipi == 'Oğul'
            ? 'hazir_ana'
            : (_anaKazanmaYontemiSecimiGoster ? _anaKazanmaYontemi : null),
        'kovanTipi': _kovanTipi,
        'suruplukVarMi': _suruplukVarMi ? 1 : 0,
        'notMetni': _notCont.text.trim(),
        'sonCita': int.tryParse(_citaCont.text.trim()) ?? 0,
        'rol': widget.koloni?['rol']?.toString() ?? 'Üretim',
        'skor': widget.koloni?['skor'] ?? 0,
        'maxCitaKapasiye': widget.koloni?['maxCitaKapasiye'] ?? 0,
        'bal_cita': widget.koloni?['bal_cita'] ?? 0,
      };

      if (widget.koloni != null) {
        await VeritabaniServisi.koloniGuncelle(
          widget.koloni!['id'] as int,
          veri,
        );
      } else {
        await VeritabaniServisi.koloniEkle(veri);
      }

      KararAsistanServisi.arilikCacheTemizle(_aktifArilikId);

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.yeniKoloniKayitHata(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _kaydediliyor = false;
        });
      }
    }
  }

  int _toInt(dynamic deger) {
    if (deger == null) return 0;
    if (deger is int) return deger;
    return int.tryParse(deger.toString()) ?? 0;
  }

  List<DropdownMenuItem<int>> _kaynakKoloniSecenekleri(BuildContext context) {
    final l = AppLocalizations.of(context);
    final mevcutKoloniNo = widget.koloni?['kovanNo']?.toString().trim() ?? '';

    final secenekler = _arilikKolonileri.where((k) {
      final kovanNo = (k['kovanNo'] ?? '').toString().trim();
      if (kovanNo.isEmpty) return false;
      if (widget.koloni != null && kovanNo == mevcutKoloniNo) return false;
      return true;
    }).toList();

    final items = <DropdownMenuItem<int>>[
      DropdownMenuItem<int>(
        value: -1,
        child: Text(l.yeniKoloniDisKaynak),
      ),
    ];

    items.addAll(secenekler.map((k) {
      final id = _toInt(k['id']);
      final no = (k['kovanNo'] ?? '').toString();
      return DropdownMenuItem<int>(
        value: id,
        child: Text(no),
      );
    }));

    return items;
  }

  String _kaynakBilgiMetni(BuildContext context) {
    final l = AppLocalizations.of(context);
    switch (_kaynakTipi) {
      case 'Ana Hat':
        return l.yeniKoloniKaynakBilgiAnaHat;
      case 'Bölme':
        return l.yeniKoloniKaynakBilgiBolme;
      case 'Oğul':
        return l.yeniKoloniKaynakBilgiOgul;
      default:
        return l.yeniKoloniKaynakBilgiVarsayilan;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: Text(
          widget.koloni == null ? l.yeniKoloniBaslik : l.yeniKoloniDuzenle,
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [AnaSayfaKisayol.aksiyon(context)],
        elevation: 1,
      ),
      body: _yukleniyor
          ? const Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          children: [
            _bolumBaslik(l.yeniKoloniBolumKaynakOlusumBilgisi),
            DropdownButtonFormField<String>(
              value: _kaynakTipi,
              decoration: InputDecoration(
                labelText: l.yeniKoloniKaynakTipiLabel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              items: const ['Bölme', 'Oğul', 'Ana Hat'].map((v) =>
                  DropdownMenuItem<String>(
                    value: v,
                    child: Text(_kaynakTipiMetni(context, v)),
                  )).toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() {
                  _kaynakTipi = v;
                  if (_kaynakTipi == 'Oğul') {
                    _anaKazanmaYontemi = 'hazir_ana';
                  } else if (_kaynakTipi == 'Bölme') {
                    _anaKazanmaYontemi = 'kendi_anasi';
                  }
                  if (!_kaynakKoloniGerekli) {
                    _kaynakKoloniCont.clear();
                    _seciliKaynakKoloniId = null;
                  }
                });
              },
            ),
            const SizedBox(height: 12),
            _bilgiKutusu(_kaynakBilgiMetni(context)),
            if (_kaynakKoloniGerekli) ...[
              if (_anaKazanmaYontemiSecimiGoster) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _anaKazanmaYontemi,
                  decoration: InputDecoration(
                    labelText: l.yeniKoloniAnaKazanmaLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                  _anaKazanmaYontemi == 'kapali_meme'
                      ? l.yeniKoloniAnaKazanmaBilgiKapaliMeme
                      : (_anaKazanmaYontemi == 'hazir_ana'
                          ? l.yeniKoloniAnaKazanmaBilgiHazirAna
                          : l.yeniKoloniAnaKazanmaBilgiKendiAnasi),
                ),
              ],
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DropdownButtonFormField<int>(
                  value: _seciliKaynakKoloniId,
                  decoration: InputDecoration(
                    labelText: l.yeniKoloniKaynakKoloniLabel,
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: _kaynakKoloniSecenekleri(context),
                  onChanged: (v) {
                    setState(() {
                      _seciliKaynakKoloniId = v;
                      if (v == -1) {
                        _kaynakKoloniCont.text = 'Dış Kaynak';
                      } else {
                        final secili = _seciliKaynakKoloniKaydi();
                         _kaynakKoloniCont.text = secili == null
                            ? ''
                            : (secili['kovanNo'] ?? '').toString();
                      }
                    });
                  },
                  validator: (value) {
                    if (_kaynakKoloniGerekli && value == null) {
                      return l.yeniKoloniKaynakKoloniValidasyon;
                    }
                    return null;
                  },
                ),
              ),
            ],
            const Divider(height: 32),
            _bolumBaslik(l.yeniKoloniBolumSahaBilgileri),
            Row(
              children: [
                Expanded(
                  child: _dropdownField(
                    l.yeniKoloniKovanTipiLabel,
                    const ['Langstroth', 'Dadant'],
                    _kovanTipi,
                    (v) => setState(() => _kovanTipi = v ?? 'Langstroth'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      l.yeniKoloniSurupluk,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      _suruplukVarMi ? l.yeniKoloniSuruplukVar : l.yeniKoloniSuruplukYok,
                      style: const TextStyle(fontSize: 11.5),
                    ),
                    value: _suruplukVarMi,
                    activeColor: Colors.amber,
                    onChanged: (v) => setState(() => _suruplukVarMi = v),
                  ),
                ),
              ],
            ),
            _bilgiKutusu(
              _suruplukVarMi
                  ? l.yeniKoloniSuruplukBilgiVar
                  : l.yeniKoloniSuruplukBilgiYok,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _tarihCont,
              readOnly: true,
              decoration: InputDecoration(
                labelText: l.yeniKoloniBaslangicTarihi,
                prefixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onTap: _olusturmaTarihiSec,
            ),
            const SizedBox(height: 12),
            _inputField(
              _noCont,
              l.yeniKoloniKovanNoLabel,
              Icons.tag,
              zorunlu: true,
            ),
            Row(
              children: [
                Expanded(
                  child: _dropdownField(
                    l.yeniKoloniAnaAriYili,
                    List.generate(4, (i) => (DateTime.now().year - 2 + i).toString()),
                    _anaYili,
                        (v) => setState(() => _anaYili = v!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _inputField(
                    _siraCont,
                    l.yeniKoloniSahaSirasi,
                    Icons.format_list_numbered,
                    sayi: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _inputField(
              _citaCont,
              l.yeniKoloniIlkCitaSayisi,
              Icons.grid_on,
              sayi: true,
            ),
            _bilgiKutusu(l.yeniKoloniSahaBilgisiNot),
            const Divider(height: 32),
            _bolumBaslik(l.yeniKoloniBolumNotlar),
            _inputField(
              _notCont,
              l.yeniKoloniOzelNotlar,
              Icons.note,
              maxLine: 3,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _yukleniyor
          ? null
          : SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: SizedBox(
          height: 56,
          child: ElevatedButton.icon(
            onPressed: _kaydediliyor ? null : _kaydet,
            icon: _kaydediliyor
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Icon(Icons.save),
            label: Text(
              _kaydediliyor ? l.ayarlarKaydediliyor : l.yeniKoloniBilgileriKaydet,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bilgiKutusu(String metin) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Colors.brown, size: 18),
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

  Widget _bolumBaslik(String metin) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      metin.toUpperCase(),
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
        letterSpacing: 0.8,
      ),
    ),
  );

  Widget _dropdownField(
      String label,
      List<String> items,
      String value,
      ValueChanged<String?> onChanged,
      ) {
    final mevcutDeger = items.contains(value) ? value : items.first;

    return DropdownButtonFormField<String>(
      value: mevcutDeger,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: items
          .map(
            (e) => DropdownMenuItem<String>(
          value: e,
          child: Text(e),
        ),
      )
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _inputField(
      TextEditingController controller,
      String label,
      IconData icon, {
        bool zorunlu = false,
        bool enabled = true,
        bool sayi = false,
        int maxLine = 1,
        String? Function(String?)? validator,
      }) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLine,
        keyboardType: sayi ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey.shade100,
        ),
        validator: validator ??
                (value) {
              final metin = value?.trim() ?? '';
              if (zorunlu && metin.isEmpty) {
                return l.yeniKoloniAlanZorunlu;
              }
              if (sayi && metin.isNotEmpty && int.tryParse(metin) == null) {
                return l.yeniKoloniSayiGir;
              }
              return null;
            },
      ),
    );
  }
}
