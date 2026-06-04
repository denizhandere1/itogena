import 'dart:async';

import 'package:flutter/material.dart';
import 'package:itogena_v45/gen_l10n/app_localizations.dart';

import 'ana_sayfa_kisayol.dart';
import '../services/premium_servisi.dart';
import '../services/veritabani_servisi.dart';
import '../widgets/pro_kapit.dart';
import '../services/karar_asistan_servisi.dart';
import '../services/koloni_biyolojik_model_servisi.dart';
import 'koloni_detay_sayfasi.dart';
import 'rapor_listesi_sayfasi.dart';


const double _balliCitaMinKg = 1.8;
const double _balliCitaMaxKg = 2.5;

class _BalPotansiyeliHesabi {
  final double aktivasyonluBalliCita;
  final double minKg;
  final double maxKg;
  final List<String> bilgiler;

  const _BalPotansiyeliHesabi({
    required this.aktivasyonluBalliCita,
    required this.minKg,
    required this.maxKg,
    required this.bilgiler,
  });
}

class _ArilikIstatistikHesabi {
  final int kovanSayisi;
  final int toplamCita;
  final double balliCita;
  final double ariliCita;
  final int tahminiAriMin;
  final int tahminiAriMax;
  final int gucluSayisi;
  final int ortaSayisi;
  final int zayifSayisi;

  const _ArilikIstatistikHesabi({
    required this.kovanSayisi,
    required this.toplamCita,
    required this.balliCita,
    required this.ariliCita,
    required this.tahminiAriMin,
    required this.tahminiAriMax,
    required this.gucluSayisi,
    required this.ortaSayisi,
    required this.zayifSayisi,
  });
}

double _modelBalliCitaSayisi(
    Map<String, dynamic> model, {
      required bool aktivasyonlaAgirliklandir,
    }) {
  double toplam = 0;

  void tara(dynamic liste) {
    if (liste is! Iterable) return;
    for (final item in liste) {
      if (item is! Map) continue;
      if ((item['tur'] ?? '').toString() != 'cita') continue;
      final tip = (item['tip'] ?? '').toString().toLowerCase();
      final bool balliPozisyon = tip.contains('bal') || tip.contains('ball');
      if (!balliPozisyon) continue;
      final aktiflik = _ekDouble(item['aktiflik']).clamp(0.0, 1.0).toDouble();
      if (aktiflik <= 0) continue;
      toplam += aktivasyonlaAgirliklandir ? aktiflik : 1.0;
    }
  }

  tara(model['altKatYerlesim']);
  tara(model['ustKatYerlesim']);

  if (toplam > 0) return toplam;

  final hasatEdilebilir = _ekDouble(model['hasatEdilebilirCita']);
  if (hasatEdilebilir > 0) return hasatEdilebilir;

  return 0;
}

Future<_ArilikIstatistikHesabi> _arilikIstatistikHesapla(
    List<Map<String, dynamic>> koloniler,
    ) async {
  int kovanSayisi = 0;
  int toplamCita = 0;
  double balliCita = 0;
  double ariliCita = 0;
  int guclu = 0;
  int orta = 0;
  int zayif = 0;

  for (final koloni in koloniler) {
    final int koloniId = _ekInt(koloni['id']);
    if (koloniId <= 0) continue;

    kovanSayisi++;

    final int skor = _ekInt(koloni['skor']);
    if (skor >= 70) {
      guclu++;
    } else if (skor >= 50) {
      orta++;
    } else {
      zayif++;
    }

    final fizikselCita = _ekInt(koloni['sonCita'] ?? koloni['citaSayisi']);
    toplamCita += fizikselCita;
    balliCita += _ekDouble(koloni['bal_cita'] ?? koloni['balCita']);
    ariliCita += _kayitliIslevselCita(koloni);
  }

  return _ArilikIstatistikHesabi(
    kovanSayisi: kovanSayisi,
    toplamCita: toplamCita,
    balliCita: balliCita,
    ariliCita: ariliCita,
    tahminiAriMin: (ariliCita * 4000).round(),
    tahminiAriMax: (ariliCita * 6000).round(),
    gucluSayisi: guclu,
    ortaSayisi: orta,
    zayifSayisi: zayif,
  );
}

Future<_BalPotansiyeliHesabi> _aktivasyonluBalliCitaPotansiyeliHesapla(
    List<Map<String, dynamic>> koloniler,
    ) async {
  // Tüm koloniler için modelleri aynı anda başlat — sequential await yerine paralel
  final sonuclar = await Future.wait(
    koloniler.map((koloni) async {
      final int koloniId = _ekInt(koloni['id']);
      if (koloniId <= 0) return null;

      double aktifBalliCita = 0;
      double hamBalliCita = 0;
      try {
        final model = await KoloniBiyolojikModelServisi.modelGetir(koloniId);
        aktifBalliCita = _modelBalliCitaSayisi(
          model,
          aktivasyonlaAgirliklandir: true,
        );
        hamBalliCita = _modelBalliCitaSayisi(
          model,
          aktivasyonlaAgirliklandir: false,
        );
      } catch (_) {
        final kayitli = _ekDouble(koloni['bal_cita'] ?? koloni['balCita']);
        aktifBalliCita = kayitli;
        hamBalliCita = kayitli;
      }

      if (aktifBalliCita <= 0) return null;
      return (koloni: koloni, aktif: aktifBalliCita, ham: hamBalliCita);
    }),
  );

  double aktivasyonluBalliCita = 0;
  double minKg = 0;
  double maxKg = 0;
  final bilgiler = <String>[];

  for (final sonuc in sonuclar) {
    if (sonuc == null) continue;
    aktivasyonluBalliCita += sonuc.aktif;
    minKg += sonuc.aktif * _balliCitaMinKg;
    maxKg += sonuc.aktif * _balliCitaMaxKg;

    if (bilgiler.length < 5) {
      final kovanNo = (sonuc.koloni['kovanNo'] ?? '-').toString();
      bilgiler.add(
        'Kovan $kovanNo: biyolojik modelde ${_ekFmt(sonuc.ham)} ballı pozisyon, aktivasyonla ${_ekFmt(sonuc.aktif)} çıta üretim hesabına alındı.',
      );
    }
  }

  return _BalPotansiyeliHesabi(
    aktivasyonluBalliCita: aktivasyonluBalliCita,
    minKg: minKg,
    maxKg: maxKg,
    bilgiler: bilgiler,
  );
}

int _ekInt(dynamic deger) {
  if (deger == null) return 0;
  if (deger is int) return deger;
  if (deger is double) return deger.round();
  return int.tryParse(deger.toString()) ?? 0;
}

double _ekDouble(dynamic deger) {
  if (deger == null) return 0;
  if (deger is num) return deger.toDouble();
  return double.tryParse(deger.toString().trim().replaceAll(',', '.')) ?? 0;
}

double _kayitliIslevselCita(Map<String, dynamic> koloni) {
  final islevsel = _ekDouble(koloni['islevselToplamCita']);
  if (islevsel > 0) return islevsel.floorToDouble();

  final sonCita = _ekDouble(koloni['sonCita']);
  if (sonCita > 0) return sonCita.floorToDouble();

  return _ekDouble(koloni['citaSayisi']).floorToDouble();
}

String _ekFmt(double deger) {
  if (deger == deger.truncateToDouble()) return deger.toStringAsFixed(0);
  return deger.toStringAsFixed(1);
}

class RaporlarSayfasi extends StatefulWidget {
  final int arilikId;
  final String arilikAd;

  const RaporlarSayfasi({
    super.key,
    required this.arilikId,
    required this.arilikAd,
  });

  @override
  State<RaporlarSayfasi> createState() => _RaporlarSayfasiState();
}

class _RaporlarSayfasiState extends State<RaporlarSayfasi> {
  bool _yukleniyor = true;
  bool _donorlerYukleniyor = false;
  bool _ekonomikAlanAcik = false;
  bool _ekonomikYukleniyor = false;
  bool _ekonomikVeriYuklendi = false;
  bool _ilgincBilgilerAcik = false;
  bool _ilgincBilgilerYukleniyor = false;
  bool _ilgincBilgilerYuklendi = false;
  bool _arilikIstatistikAcik = false;
  bool _arilikIstatistikYukleniyor = false;
  bool _arilikIstatistikYuklendi = false;
  Object? _arilikIstatistikHatasi;
  _ArilikIstatistikHesabi? _arilikIstatistik;
  int _yuklemeToken = 0;

  List<Map<String, dynamic>> _aktifKoloniler = [];
  List<Map<String, dynamic>> _ilkUcDonor = [];
  List<Map<String, dynamic>> _ilkUcGuclu = [];

  int _ortalamaSkor = 0;
  int _aktifKovanSayisi = 0;
  double _toplamAriliCita = 0;
  double _ekonomikDeger = 0;
  double _tahminiBalPotansiyeliMinKg = 0;
  double _tahminiBalPotansiyeliMaxKg = 0;
  double _tahminiBalDegeriMin = 0;
  double _tahminiBalDegeriMax = 0;
  double _aktivasyonluBalliCita = 0;
  final List<String> _ilgincBilgiler = [];

  Timer? _ekonomikKaydetDebounce;

  final TextEditingController _ariliCitaDegeriController =
  TextEditingController();
  final TextEditingController _bosKovanDegeriController =
  TextEditingController();
  final TextEditingController _bosKabarmisPetekSayisiController =
  TextEditingController();
  final TextEditingController _bosKabarmisPetekDegeriController =
  TextEditingController();
  final TextEditingController _balKgFiyatiController =
  TextEditingController();

  @override
  void initState() {
    super.initState();
    _verileriYukle();
  }

  @override
  void dispose() {
    _ekonomikKaydetDebounce?.cancel();
    _ariliCitaDegeriController.dispose();
    _bosKovanDegeriController.dispose();
    _bosKabarmisPetekSayisiController.dispose();
    _bosKabarmisPetekDegeriController.dispose();
    _balKgFiyatiController.dispose();
    super.dispose();
  }

  Future<void> _verileriYukle() async {
    final int token = ++_yuklemeToken;

    if (mounted) {
      setState(() {
        _yukleniyor = true;
        _donorlerYukleniyor = false;
      });
    }

    final tumKoloniler = await VeritabaniServisi.kovanlariAriligaGoreGetir(
      widget.arilikId,
    );

    final koloniIdleri = tumKoloniler
        .map((k) => _toInt(k['id']))
        .where((id) => id > 0)
        .toList();

    final aktiflikMap =
    await VeritabaniServisi.koloniAktiflikHaritasiGetir(koloniIdleri);

    final aktifKoloniler = <Map<String, dynamic>>[];
    int toplamSkor = 0;
    double toplamAriliCita = 0;
    for (final koloni in tumKoloniler) {
      final koloniId = _toInt(koloni['id']);
      if (koloniId <= 0) continue;
      if (aktiflikMap[koloniId] == true) {
        aktifKoloniler.add(koloni);
        toplamSkor += _toInt(koloni['skor']);

        // Performans temizliği:
        // Raporlar ana ekranı açılırken her koloni için biyolojik model
        // hesaplatmak ekran açılışını gereksiz ağırlaştırıyordu. Bu alanda
        // yaklaşık toplam yeterlidir; detaylı biyolojik/ekonomik hesaplar
        // kullanıcı ilgili alanı açtığında lazy-load çalışır.
        final aktifCita = _kayitliIslevselCita(koloni);
        toplamAriliCita += aktifCita;
      }
    }

    final ilkUcGuclu = List<Map<String, dynamic>>.from(aktifKoloniler)
      ..sort(_gucluKoloniSirala);

    if (!mounted || token != _yuklemeToken) return;

    setState(() {
      _aktifKoloniler = aktifKoloniler;
      _ilkUcDonor = const <Map<String, dynamic>>[];
      _ilkUcGuclu = ilkUcGuclu.take(3).toList();
      _aktifKovanSayisi = aktifKoloniler.length;
      _toplamAriliCita = toplamAriliCita;
      _ortalamaSkor = aktifKoloniler.isEmpty
          ? 0
          : (toplamSkor / aktifKoloniler.length).round();
      _tahminiBalPotansiyeliMinKg = 0;
      _tahminiBalPotansiyeliMaxKg = 0;
      _tahminiBalDegeriMin = 0;
      _tahminiBalDegeriMax = 0;
      _aktivasyonluBalliCita = 0;
      _ilgincBilgiler.clear();
      _ekonomikDeger = 0;
      _ekonomikAlanAcik = false;
      _ekonomikYukleniyor = false;
      _ekonomikVeriYuklendi = false;
      _ilgincBilgilerAcik = false;
      _ilgincBilgilerYukleniyor = false;
      _ilgincBilgilerYuklendi = false;
      _arilikIstatistikAcik = false;
      _arilikIstatistikYukleniyor = false;
      _arilikIstatistikYuklendi = false;
      _arilikIstatistikHatasi = null;
      _arilikIstatistik = null;
      _yukleniyor = false;
      _donorlerYukleniyor = true;
    });

    Future<void>.delayed(const Duration(milliseconds: 250), () async {
      await _donorleriArkaPlandaYukle(token);
    });
  }

  Future<void> _donorleriArkaPlandaYukle(int token) async {
    if (_aktifKoloniler.isEmpty) {
      if (!mounted || token != _yuklemeToken) return;
      setState(() => _donorlerYukleniyor = false);
      return;
    }

    final siraliDonorler = await KararAsistanServisi.donorAdaylariSiraliGetir(
      arilikId: widget.arilikId,
    );

    if (!mounted || token != _yuklemeToken) return;

    final donorIdleri = siraliDonorler
        .where((e) => _toInt(e['sira']) >= 1 && _toInt(e['sira']) <= 3)
        .map((e) => _toInt(e['koloniId']))
        .toSet();

    final ilkUcDonor = _aktifKoloniler
        .where((k) => donorIdleri.contains(_toInt(k['id'])))
        .toList()
      ..sort((a, b) {
        final aSira = _donorSirasiBul(_toInt(a['id']), siraliDonorler);
        final bSira = _donorSirasiBul(_toInt(b['id']), siraliDonorler);
        return aSira.compareTo(bSira);
      });

    final ilkUcGuclu = List<Map<String, dynamic>>.from(_aktifKoloniler)
      ..sort((a, b) {
        final donorKiyas = _donorOncelikKiyasla(a, b, siraliDonorler);
        if (donorKiyas != 0) return donorKiyas;
        return _gucluKoloniSirala(a, b);
      });

    setState(() {
      _ilkUcDonor = ilkUcDonor.take(3).toList();
      _ilkUcGuclu = ilkUcGuclu.take(3).toList();
      _donorlerYukleniyor = false;
    });
  }

  int _gucluKoloniSirala(Map<String, dynamic> a, Map<String, dynamic> b) {
    final skorKiyas = _toInt(b['skor']).compareTo(_toInt(a['skor']));
    if (skorKiyas != 0) return skorKiyas;

    final aSon = _toInt(a['sonCita']);
    final bSon = _toInt(b['sonCita']);
    if (aSon != bSon) return bSon.compareTo(aSon);

    final aBal = _toInt(a['bal_cita']);
    final bBal = _toInt(b['bal_cita']);
    if (aBal != bBal) return bBal.compareTo(aBal);

    return (a['kovanNo'] ?? '').toString().compareTo(
      (b['kovanNo'] ?? '').toString(),
    );
  }

  int _donorOncelikKiyasla(
      Map<String, dynamic> a,
      Map<String, dynamic> b,
      List<Map<String, dynamic>> donorler,
      ) {
    final aDonor = _donorSirasiBul(_toInt(a['id']), donorler) > 0;
    final bDonor = _donorSirasiBul(_toInt(b['id']), donorler) > 0;
    if (aDonor == bDonor) return 0;
    return aDonor ? -1 : 1;
  }

  Future<void> _ekonomikVerileriYukle() async {
    if (_ekonomikYukleniyor) return;

    if (_ekonomikVeriYuklendi) {
      setState(() => _ekonomikAlanAcik = !_ekonomikAlanAcik);
      return;
    }

    final int token = _yuklemeToken;
    setState(() {
      _ekonomikAlanAcik = true;
      _ekonomikYukleniyor = true;
    });

    final ekonomikAriliCita = await VeritabaniServisi.ayarStringGetir(
      'ekonomik_arili_cita',
      varsayilan: '900',
    );
    final ekonomikBosKovan = await VeritabaniServisi.ayarStringGetir(
      'ekonomik_bos_kovan',
      varsayilan: '1500',
    );
    final ekonomikPetekSayi = await VeritabaniServisi.ayarStringGetir(
      'ekonomik_petek_sayi',
      varsayilan: '0',
    );
    final ekonomikPetekDeger = await VeritabaniServisi.ayarStringGetir(
      'ekonomik_petek_deger',
      varsayilan: '120',
    );
    final ekonomikBalKgFiyat = await VeritabaniServisi.ayarStringGetir(
      'ekonomik_bal_kg_fiyat',
      varsayilan: '600',
    );

    final balHesabi = await _aktivasyonluBalliCitaPotansiyeliHesapla(
      _aktifKoloniler,
    );
    final balPotansiyeliMin = balHesabi.minKg;
    final balPotansiyeliMax = balHesabi.maxKg;
    final bilgiler = balHesabi.bilgiler;

    if (!mounted || token != _yuklemeToken) return;

    _ariliCitaDegeriController.text = ekonomikAriliCita;
    _bosKovanDegeriController.text = ekonomikBosKovan;
    _bosKabarmisPetekSayisiController.text = ekonomikPetekSayi;
    _bosKabarmisPetekDegeriController.text = ekonomikPetekDeger;
    _balKgFiyatiController.text = ekonomikBalKgFiyat;

    setState(() {
      _tahminiBalPotansiyeliMinKg = balPotansiyeliMin;
      _tahminiBalPotansiyeliMaxKg = balPotansiyeliMax;
      _aktivasyonluBalliCita = balHesabi.aktivasyonluBalliCita;
      _tahminiBalDegeriMin =
          balPotansiyeliMin * _toDouble(_balKgFiyatiController.text);
      _tahminiBalDegeriMax =
          balPotansiyeliMax * _toDouble(_balKgFiyatiController.text);
      _ilgincBilgiler
        ..clear()
        ..addAll(bilgiler);
      _ilgincBilgilerYuklendi = true;
      _ekonomikDeger = _hesaplananEkonomikDeger();
      _ekonomikYukleniyor = false;
      _ekonomikVeriYuklendi = true;
    });
  }

  Future<void> _ilgincBilgileriYukle() async {
    if (_ilgincBilgilerYukleniyor) return;

    if (_ilgincBilgilerYuklendi) {
      setState(() => _ilgincBilgilerAcik = !_ilgincBilgilerAcik);
      return;
    }

    final int token = _yuklemeToken;
    setState(() {
      _ilgincBilgilerAcik = true;
      _ilgincBilgilerYukleniyor = true;
    });

    final bilgiler = <String>[];
    for (final koloni in _aktifKoloniler) {
      final model = KoloniBiyolojikModelServisi.modelOlustur(koloni: koloni);
      final kovanNo = (koloni['kovanNo'] ?? '-').toString();
      final hasatMetni = (model['hasatAdayMetni'] ?? '').toString();
      if (hasatMetni.isNotEmpty &&
          !hasatMetni.contains('önerilmez') &&
          bilgiler.length < 5) {
        bilgiler.add('Kovan $kovanNo: $hasatMetni');
      }
    }

    if (!mounted || token != _yuklemeToken) return;

    setState(() {
      _ilgincBilgiler
        ..clear()
        ..addAll(bilgiler);
      _ilgincBilgilerYukleniyor = false;
      _ilgincBilgilerYuklendi = true;
    });
  }

  Future<void> _arilikIstatistikleriniYukle() async {
    if (_arilikIstatistikYukleniyor) return;

    if (_arilikIstatistikYuklendi) {
      setState(() => _arilikIstatistikAcik = !_arilikIstatistikAcik);
      return;
    }

    final int token = _yuklemeToken;
    setState(() {
      _arilikIstatistikAcik = true;
      _arilikIstatistikYukleniyor = true;
      _arilikIstatistikHatasi = null;
    });

    try {
      final sonuc = await _arilikIstatistikHesapla(_aktifKoloniler);
      if (!mounted || token != _yuklemeToken) return;

      setState(() {
        _arilikIstatistik = sonuc;
        _arilikIstatistikYukleniyor = false;
        _arilikIstatistikYuklendi = true;
        _arilikIstatistikHatasi = null;
      });
    } catch (e) {
      if (!mounted || token != _yuklemeToken) return;

      setState(() {
        _arilikIstatistik = null;
        _arilikIstatistikYukleniyor = false;
        _arilikIstatistikYuklendi = false;
        _arilikIstatistikHatasi = e;
      });
    }
  }

  double _hesaplananEkonomikDeger() {
    final ariliCitaDegeri = _toDouble(_ariliCitaDegeriController.text);
    final bosKovanDegeri = _toDouble(_bosKovanDegeriController.text);
    final bosKabarmisPetekSayisi =
    _toIntFromText(_bosKabarmisPetekSayisiController.text);
    final bosKabarmisPetekDegeri =
    _toDouble(_bosKabarmisPetekDegeriController.text);

    final balKgFiyati = _toDouble(_balKgFiyatiController.text);
    final tahminiBalDegeriOrta = ((_tahminiBalPotansiyeliMinKg + _tahminiBalPotansiyeliMaxKg) / 2) * balKgFiyati;

    return (_toplamAriliCita * ariliCitaDegeri) +
        (_aktifKovanSayisi * bosKovanDegeri) +
        (bosKabarmisPetekSayisi * bosKabarmisPetekDegeri) +
        tahminiBalDegeriOrta;
  }

  void _ekonomikAlanDegisti() {
    setState(() {
      final balKgFiyati = _toDouble(_balKgFiyatiController.text);
      _tahminiBalDegeriMin = _tahminiBalPotansiyeliMinKg * balKgFiyati;
      _tahminiBalDegeriMax = _tahminiBalPotansiyeliMaxKg * balKgFiyati;
      _ekonomikDeger = _hesaplananEkonomikDeger();
    });

    _ekonomikKaydetDebounce?.cancel();
    _ekonomikKaydetDebounce = Timer(const Duration(milliseconds: 450), () async {
      await VeritabaniServisi.ayarKaydet(
        'ekonomik_arili_cita',
        _ariliCitaDegeriController.text.trim(),
      );
      await VeritabaniServisi.ayarKaydet(
        'ekonomik_bos_kovan',
        _bosKovanDegeriController.text.trim(),
      );
      await VeritabaniServisi.ayarKaydet(
        'ekonomik_petek_sayi',
        _bosKabarmisPetekSayisiController.text.trim(),
      );
      await VeritabaniServisi.ayarKaydet(
        'ekonomik_petek_deger',
        _bosKabarmisPetekDegeriController.text.trim(),
      );
      await VeritabaniServisi.ayarKaydet(
        'ekonomik_bal_kg_fiyat',
        _balKgFiyatiController.text.trim(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!PremiumServisi.isPro) return const ProSayfaKapit(child: SizedBox.shrink());
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).raporlarSayfaBaslik,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [AnaSayfaKisayol.aksiyon(context)],
      ),
      body: _yukleniyor
          ? const Center(
        child: CircularProgressIndicator(color: Colors.amber),
      )
          : ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          _arilikSecimSatiri(),
          const SizedBox(height: 10),
          _genelDurumKarti(),
          const SizedBox(height: 16),
          _raporSecimKutusu(),
        ],
      ),
    );
  }

  Widget _arilikSecimSatiri() {
    return InkWell(
      onTap: _arilikSec,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.amber.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.hive_outlined, size: 20, color: Colors.brown),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context).raporlarArilikEtiketi,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: Colors.black54,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                widget.arilikAd,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w900,
                  color: Colors.brown,
                ),
              ),
            ),
            const Icon(Icons.expand_more, color: Colors.brown),
          ],
        ),
      ),
    );
  }

  Future<void> _arilikSec() async {
    final ariliklar = await VeritabaniServisi.ariliklariGetir();
    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFFFFFDE7),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        if (ariliklar.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Text(AppLocalizations.of(context).raporlarArilikBulunamadi),
          );
        }
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
                child: Text(
                  AppLocalizations.of(context).raporlarArilikSec,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Colors.brown,
                  ),
                ),
              ),
              ...ariliklar.map((arilik) {
                final id = _toInt(arilik['id']);
                final ad = (arilik['ad'] ?? '-').toString();
                final secili = id == widget.arilikId;
                return Card(
                  color: secili ? Colors.amber.shade100 : Colors.white,
                  child: ListTile(
                    leading: Icon(
                      secili ? Icons.check_circle : Icons.hive_outlined,
                      color: Colors.brown,
                    ),
                    title: Text(
                      ad,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      if (id <= 0 || id == widget.arilikId) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RaporlarSayfasi(
                            arilikId: id,
                            arilikAd: ad,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _genelDurumKarti() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).raporlarGenelDurum,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 15,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _anaOzetKutusu(
                  AppLocalizations.of(context).raporlarAktifKovan,
                  _aktifKovanSayisi.toString(),
                  Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _anaOzetKutusu(
                  AppLocalizations.of(context).raporlarOrtaSkor,
                  _ortalamaSkor.toString(),
                  _skorRengi(_ortalamaSkor),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _anaOzetKutusu(
                  AppLocalizations.of(context).raporlarAriliCita,
                  _kg(_toplamAriliCita),
                  Colors.blueGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _arilikIstatistikKarti(),
          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _kompaktGridBolumu(
                  baslik: AppLocalizations.of(context).raporlarDonorler,
                  koloniler: _ilkUcDonor,
                  fallbackMetin: _donorlerYukleniyor
                      ? AppLocalizations.of(context).raporlarHesaplaniyor
                      : AppLocalizations.of(context).raporlarHenuzYok,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _kompaktGridBolumu(
                  baslik: AppLocalizations.of(context).raporlarIlkUcGuclu,
                  koloniler: _ilkUcGuclu,
                  fallbackMetin: AppLocalizations.of(context).raporlarHenuzYok,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kompaktGridBolumu({
    required String baslik,
    required List<Map<String, dynamic>> koloniler,
    required String fallbackMetin,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          baslik,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 12,
            color: Colors.brown,
          ),
        ),
        const SizedBox(height: 6),
        if (koloniler.isEmpty)
          Container(
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFCF2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Text(
              fallbackMetin,
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: koloniler.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 1.12,
            ),
            itemBuilder: (context, index) {
              final koloni = koloniler[index];
              final skor = _toInt(koloni['skor']);
              final renk = _skorRengi(skor);
              final kovanNo = (koloni['kovanNo'] ?? '-').toString();

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => KoloniDetaySayfasi(koloni: koloni),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: renk.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: renk.withOpacity(0.28)),
                  ),
                  child: Center(
                    child: Text(
                      kovanNo,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                        color: renk,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _raporSecimKutusu() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).raporlarRaporSec,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 15,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).raporlarListeLazyAciklama,
            style: const TextStyle(fontSize: 12, height: 1.45, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          _raporSatiri(
            baslik: AppLocalizations.of(context).raporlarGucludenZayifaBaslik,
            altMetin: AppLocalizations.of(context).raporlarGucludenZayifaAlt,
            ikon: Icons.arrow_downward_rounded,
            onTap: () => _listeyeGit(
              AppLocalizations.of(context).raporlarGucludenZayifaListeBaslik,
              'gucluden_zayifa',
            ),
          ),
          _raporSatiri(
            baslik: AppLocalizations.of(context).raporlarZayiftanGucluye,
            altMetin: AppLocalizations.of(context).raporlarZayiftanGucluAlt,
            ikon: Icons.arrow_upward_rounded,
            onTap: () => _listeyeGit(
              AppLocalizations.of(context).raporlarZayiftanGucluListeBaslik,
              'zayiftan_gucluye',
            ),
          ),
          _raporSatiri(
            baslik: AppLocalizations.of(context).raporlarDonorAdaylariBaslik,
            altMetin: AppLocalizations.of(context).raporlarDonorAdaylariAlt,
            ikon: Icons.workspace_premium_outlined,
            onTap: () => _listeyeGit(
              AppLocalizations.of(context).raporlarDonorAdaylariListeBaslik,
              'donor_adaylari',
            ),
          ),
          _raporSatiri(
            baslik: AppLocalizations.of(context).raporlarGenetikVetoBaslik,
            altMetin: AppLocalizations.of(context).raporlarGenetikVetoAlt,
            ikon: Icons.block_outlined,
            onTap: () => _listeyeGit(
              AppLocalizations.of(context).raporlarGenetikVetoListeBaslik,
              'genetik_veto',
            ),
          ),
          _raporSatiri(
            baslik: AppLocalizations.of(context).raporlarEkonomikDegerBaslik,
            altMetin: AppLocalizations.of(context).raporlarEkonomikDegerAlt,
            ikon: Icons.payments_outlined,
            onTap: _ekonomikDegerSayfasinaGit,
          ),
        ],
      ),
    );
  }

  Widget _arilikIstatistikKarti() {
    if (!_arilikIstatistikAcik) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: _arilikIstatistikleriniYukle,
          icon: const Icon(Icons.calculate_outlined),
          label: Text(AppLocalizations.of(context).raporlarIstatistikHesapla),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            foregroundColor: Colors.deepPurple,
            side: BorderSide(color: Colors.deepPurple.withOpacity(0.45)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      );
    }

    if (_arilikIstatistikYukleniyor) {
      return Container(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFCF2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.amber.shade200),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.3, color: Colors.amber),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                AppLocalizations.of(context).raporlarIstatistikHesaplaniyor,
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      );
    }

    if (_arilikIstatistikHatasi != null) {
      return Container(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).raporlarIstatistikHata(_arilikIstatistikHatasi.toString()),
              style: const TextStyle(fontSize: 12, color: Colors.red, height: 1.35),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _arilikIstatistikYuklendi = false;
                  _arilikIstatistikHatasi = null;
                });
                _arilikIstatistikleriniYukle();
              },
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context).raporlarTekrarHesapla),
            ),
          ],
        ),
      );
    }

    final istatistik = _arilikIstatistik;
    if (istatistik == null) return const SizedBox.shrink();

    final double aktivasyonFarki =
    (istatistik.toplamCita - istatistik.ariliCita)
        .clamp(0, istatistik.toplamCita)
        .toDouble();

    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context).raporlarArilikIstatistikleri,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13.5,
                    color: Colors.brown,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => setState(() => _arilikIstatistikAcik = false),
                icon: const Icon(Icons.expand_less, size: 17),
                label: Text(AppLocalizations.of(context).kapat),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.24,
            children: [
              _istatistikKutusu(AppLocalizations.of(context).kovan, istatistik.kovanSayisi.toString(), Colors.green),
              _istatistikKutusu(AppLocalizations.of(context).raporlarToplamCita, istatistik.toplamCita.toString(), Colors.blueGrey),
              _istatistikKutusu(AppLocalizations.of(context).raporlarBalTemasi, _kg(istatistik.balliCita), Colors.amber.shade800),
              _istatistikKutusu(AppLocalizations.of(context).raporlarAriliCita, _kg(istatistik.ariliCita), Colors.teal),
              _istatistikKutusu(AppLocalizations.of(context).raporlarAktivasyonFarki, _kg(aktivasyonFarki), Colors.deepOrange),
              _istatistikKutusu(AppLocalizations.of(context).raporlarTahminiAri, _ariSayisiAraligi(istatistik.tahminiAriMin, istatistik.tahminiAriMax), Colors.brown),
              _istatistikKutusu(AppLocalizations.of(context).raporlarGuclu, istatistik.gucluSayisi.toString(), Colors.green),
              _istatistikKutusu(AppLocalizations.of(context).raporlarOrta, istatistik.ortaSayisi.toString(), Colors.orange),
              _istatistikKutusu(AppLocalizations.of(context).raporlarZayif, istatistik.zayifSayisi.toString(), Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _istatistikKutusu(String baslik, String deger, Color renk) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
      decoration: BoxDecoration(
        color: renk.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: renk.withOpacity(0.22)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  deger,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: renk,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              baslik,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10.3,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _raporSatiri({
    required String baslik,
    required String altMetin,
    required IconData ikon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.amber.shade100,
          child: Icon(ikon, color: Colors.brown),
        ),
        title: Text(
          baslik,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          altMetin,
          style: const TextStyle(fontSize: 12, height: 1.35),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _ekonomikDegerKarti() {
    if (!_ekonomikAlanAcik) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.amber.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'EKONOMİK DEĞER',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 15,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ağır ekonomik değer ve bal potansiyeli hesabı ilk açılışta çalışmaz. Kullanıcı isterse hesaplanır.',
              style: TextStyle(fontSize: 12.5, height: 1.4, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _ekonomikVerileriYukle,
                icon: const Icon(Icons.calculate_outlined),
                label: const Text('Ekonomik değeri hesapla'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_ekonomikYukleniyor) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.amber.shade300),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.amber),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Ekonomik değer hesaplanıyor...',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'EKONOMİK DEĞER',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: Colors.brown,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => setState(() => _ekonomikAlanAcik = false),
                icon: const Icon(Icons.expand_less, size: 18),
                label: const Text('Kapat'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Tahmini toplam değer: ${_paraFormatla(_ekonomikDeger)} TL',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (_tahminiBalPotansiyeliMaxKg > 0) ...[
            const SizedBox(height: 6),
            Text(
              'Aktivasyonlu ballı çıta: ${_kg(_aktivasyonluBalliCita)} çıta',
              style: TextStyle(fontSize: 12.5, height: 1.4, color: Colors.brown.shade700),
            ),
            const SizedBox(height: 4),
            Text(
              'Tahmini bal: ${_kg(_tahminiBalPotansiyeliMinKg)}–${_kg(_tahminiBalPotansiyeliMaxKg)} kg / ${_paraFormatla(_tahminiBalDegeriMin)}–${_paraFormatla(_tahminiBalDegeriMax)} TL',
              style: TextStyle(fontSize: 12.5, height: 1.4, color: Colors.brown.shade700),
            ),
            const SizedBox(height: 6),
            const Text(
              'Bu hesap biyolojik modelde bal/ballık pozisyonunda görünen çıtaları aktivasyon düzeyiyle okur; boş çıta, toplam fiziksel çıta veya boş kabarmış petek bal gibi sayılmaz.',
              style: TextStyle(fontSize: 12, height: 1.35, color: Colors.black54),
            ),
          ],
          const SizedBox(height: 12),
          _alan('Bal satış fiyatı (kg/TL)', _balKgFiyatiController),
          const SizedBox(height: 10),
          _alan('Arılı çıta değeri', _ariliCitaDegeriController),
          const SizedBox(height: 10),
          _alan('Boş kovan değeri', _bosKovanDegeriController),
          const SizedBox(height: 10),
          _alan('Boş kabarmış petek adedi', _bosKabarmisPetekSayisiController),
          const SizedBox(height: 10),
          _alan(
            'Boş kabarmış petek birim değeri',
            _bosKabarmisPetekDegeriController,
          ),
        ],
      ),
    );
  }

  Widget _ilgincBilgilerKarti() {
    if (!_ilgincBilgilerAcik) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'KOLONİLER HAKKINDA İLGİNÇ BİLGİLER',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 15,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Koloni bazlı biyolojik notlar ağır hesap içerdiği için ilk açılışta çalışmaz.',
              style: TextStyle(fontSize: 12.5, height: 1.4, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _ilgincBilgileriYukle,
                icon: const Icon(Icons.auto_awesome_outlined),
                label: const Text('Biyolojik notları oluştur'),
              ),
            ),
          ],
        ),
      );
    }

    if (_ilgincBilgilerYukleniyor) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.green),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Biyolojik notlar hazırlanıyor...',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      );
    }

    final bilgiler = _ilgincBilgiler.isEmpty
        ? <String>[
      'Hasat adayı çıta verisi oluştuğunda burada koloni bazlı kısa biyolojik notlar gösterilir.',
      'Biyolojik model akademik genel kabuller ve saha verisiyle tahmini projeksiyon üretir; kesin ölçüm değildir.',
    ]
        : _ilgincBilgiler;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'KOLONİLER HAKKINDA İLGİNÇ BİLGİLER',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: Colors.brown,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => setState(() => _ilgincBilgilerAcik = false),
                icon: const Icon(Icons.expand_less, size: 18),
                label: const Text('Kapat'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...bilgiler.map(
                (b) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.auto_awesome_outlined, size: 17, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      b,
                      style: const TextStyle(fontSize: 12.5, height: 1.4),
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

  Widget _alan(String etiket, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: (_) => _ekonomikAlanDegisti(),
      decoration: InputDecoration(
        labelText: etiket,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: const Color(0xFFFFFDF7),
      ),
    );
  }

  Widget _anaOzetKutusu(String baslik, String deger, Color renk) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(
        color: renk.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: renk.withOpacity(0.24)),
      ),
      child: Column(
        children: [
          Text(
            deger,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: renk,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            baslik,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _listeyeGit(String baslik, String tip) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RaporListesiSayfasi(
          baslik: baslik,
          raporTipi: tip,
          arilikId: widget.arilikId,
          arilikAd: widget.arilikAd,
        ),
      ),
    );
  }


  void _ekonomikDegerSayfasinaGit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EkonomikDegerSayfasi(
          arilikAd: widget.arilikAd,
          aktifKoloniler: _aktifKoloniler,
          aktifKovanSayisi: _aktifKovanSayisi,
          toplamAriliCita: _toplamAriliCita,
        ),
      ),
    );
  }

  int _donorSirasiBul(int koloniId, List<Map<String, dynamic>> donorler) {
    for (final donor in donorler) {
      if (_toInt(donor['koloniId']) == koloniId) {
        return _toInt(donor['sira']);
      }
    }
    return 0;
  }

  Color _skorRengi(int skor) {
    if (skor >= 85) return Colors.purple;
    if (skor >= 70) return Colors.green;
    if (skor >= 50) return Colors.orange;
    return Colors.red;
  }

  String _kg(double v) => v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 1);

  String _paraFormatla(double deger) {
    return deger.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
    );
  }

  String _ariSayisiAraligi(int min, int max) {
    if (max <= 0) return '0';
    if (max >= 1000000) {
      final double minM = min / 1000000;
      final double maxM = max / 1000000;
      return '${_kg(minM)}–${_kg(maxM)} mn';
    }
    return '${(min / 1000).round()}–${(max / 1000).round()} bin';
  }

  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }

  int _toIntFromText(String metin) {
    return int.tryParse(metin.trim()) ?? 0;
  }

  double _toDouble(dynamic deger) {
    if (deger == null) return 0;
    if (deger is num) return deger.toDouble();
    return double.tryParse(deger.toString().trim().replaceAll(',', '.')) ?? 0;
  }
}

class EkonomikDegerSayfasi extends StatefulWidget {
  final String arilikAd;
  final List<Map<String, dynamic>> aktifKoloniler;
  final int aktifKovanSayisi;
  final double toplamAriliCita;

  const EkonomikDegerSayfasi({
    super.key,
    required this.arilikAd,
    required this.aktifKoloniler,
    required this.aktifKovanSayisi,
    required this.toplamAriliCita,
  });

  @override
  State<EkonomikDegerSayfasi> createState() => _EkonomikDegerSayfasiState();
}

class _EkonomikDegerSayfasiState extends State<EkonomikDegerSayfasi> {
  bool _yukleniyor = true;
  Object? _hata;

  double _ekonomikDeger = 0;
  double _tahminiBalPotansiyeliMinKg = 0;
  double _tahminiBalPotansiyeliMaxKg = 0;
  double _tahminiBalDegeriMin = 0;
  double _tahminiBalDegeriMax = 0;
  double _aktivasyonluBalliCita = 0;

  Timer? _kaydetDebounce;

  final TextEditingController _ariliCitaDegeriController = TextEditingController();
  final TextEditingController _bosKovanDegeriController = TextEditingController();
  final TextEditingController _bosKabarmisPetekSayisiController = TextEditingController();
  final TextEditingController _bosKabarmisPetekDegeriController = TextEditingController();
  final TextEditingController _balKgFiyatiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _verileriYukle();
  }

  @override
  void dispose() {
    _kaydetDebounce?.cancel();
    _ariliCitaDegeriController.dispose();
    _bosKovanDegeriController.dispose();
    _bosKabarmisPetekSayisiController.dispose();
    _bosKabarmisPetekDegeriController.dispose();
    _balKgFiyatiController.dispose();
    super.dispose();
  }

  Future<void> _verileriYukle() async {
    try {
      final ekonomikAriliCita = await VeritabaniServisi.ayarStringGetir(
        'ekonomik_arili_cita',
        varsayilan: '900',
      );
      final ekonomikBosKovan = await VeritabaniServisi.ayarStringGetir(
        'ekonomik_bos_kovan',
        varsayilan: '1500',
      );
      final ekonomikPetekSayi = await VeritabaniServisi.ayarStringGetir(
        'ekonomik_petek_sayi',
        varsayilan: '0',
      );
      final ekonomikPetekDeger = await VeritabaniServisi.ayarStringGetir(
        'ekonomik_petek_deger',
        varsayilan: '120',
      );
      final ekonomikBalKgFiyat = await VeritabaniServisi.ayarStringGetir(
        'ekonomik_bal_kg_fiyat',
        varsayilan: '600',
      );

      final balHesabi = await _aktivasyonluBalliCitaPotansiyeliHesapla(
        widget.aktifKoloniler,
      );
      final balPotansiyeliMin = balHesabi.minKg;
      final balPotansiyeliMax = balHesabi.maxKg;

      if (!mounted) return;

      _ariliCitaDegeriController.text = ekonomikAriliCita;
      _bosKovanDegeriController.text = ekonomikBosKovan;
      _bosKabarmisPetekSayisiController.text = ekonomikPetekSayi;
      _bosKabarmisPetekDegeriController.text = ekonomikPetekDeger;
      _balKgFiyatiController.text = ekonomikBalKgFiyat;

      setState(() {
        _tahminiBalPotansiyeliMinKg = balPotansiyeliMin;
        _tahminiBalPotansiyeliMaxKg = balPotansiyeliMax;
        _aktivasyonluBalliCita = balHesabi.aktivasyonluBalliCita;
        _ekonomikDeger = _hesaplananEkonomikDeger();
        _balDegerleriniGuncelle();
        _yukleniyor = false;
        _hata = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hata = e;
        _yukleniyor = false;
      });
    }
  }

  void _balDegerleriniGuncelle() {
    final balKgFiyati = _toDouble(_balKgFiyatiController.text);
    _tahminiBalDegeriMin = _tahminiBalPotansiyeliMinKg * balKgFiyati;
    _tahminiBalDegeriMax = _tahminiBalPotansiyeliMaxKg * balKgFiyati;
  }

  double _hesaplananEkonomikDeger() {
    final ariliCitaDegeri = _toDouble(_ariliCitaDegeriController.text);
    final bosKovanDegeri = _toDouble(_bosKovanDegeriController.text);
    final bosKabarmisPetekSayisi = _toIntFromText(_bosKabarmisPetekSayisiController.text);
    final bosKabarmisPetekDegeri = _toDouble(_bosKabarmisPetekDegeriController.text);
    final balKgFiyati = _toDouble(_balKgFiyatiController.text);
    final tahminiBalDegeriOrta =
        ((_tahminiBalPotansiyeliMinKg + _tahminiBalPotansiyeliMaxKg) / 2) * balKgFiyati;

    return (widget.toplamAriliCita * ariliCitaDegeri) +
        (widget.aktifKovanSayisi * bosKovanDegeri) +
        (bosKabarmisPetekSayisi * bosKabarmisPetekDegeri) +
        tahminiBalDegeriOrta;
  }

  void _ekonomikAlanDegisti() {
    setState(() {
      _balDegerleriniGuncelle();
      _ekonomikDeger = _hesaplananEkonomikDeger();
    });

    _kaydetDebounce?.cancel();
    _kaydetDebounce = Timer(const Duration(milliseconds: 450), () async {
      await VeritabaniServisi.ayarKaydet(
        'ekonomik_arili_cita',
        _ariliCitaDegeriController.text.trim(),
      );
      await VeritabaniServisi.ayarKaydet(
        'ekonomik_bos_kovan',
        _bosKovanDegeriController.text.trim(),
      );
      await VeritabaniServisi.ayarKaydet(
        'ekonomik_petek_sayi',
        _bosKabarmisPetekSayisiController.text.trim(),
      );
      await VeritabaniServisi.ayarKaydet(
        'ekonomik_petek_deger',
        _bosKabarmisPetekDegeriController.text.trim(),
      );
      await VeritabaniServisi.ayarKaydet(
        'ekonomik_bal_kg_fiyat',
        _balKgFiyatiController.text.trim(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!PremiumServisi.isPro) return const ProSayfaKapit(child: SizedBox.shrink());
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).ekDegerAppBarBaslik(widget.arilikAd),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [AnaSayfaKisayol.aksiyon(context)],
      ),
      body: _yukleniyor
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : _hata != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            AppLocalizations.of(context).ekDegerHata(_hata.toString()),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red, height: 1.4),
          ),
        ),
      )
          : ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          _ekonomikDegerKarti(),
        ],
      ),
    );
  }

  Widget _ekonomikDegerKarti() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).ekDegerKartBaslik,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 15,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).ekDegerTahminiToplam(_paraFormatla(_ekonomikDeger)),
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          if (_tahminiBalPotansiyeliMaxKg > 0) ...[
            const SizedBox(height: 6),
            Text(
              AppLocalizations.of(context).ekDegerAktivasyonluBalliCita(_kg(_aktivasyonluBalliCita)),
              style: TextStyle(fontSize: 12.5, height: 1.4, color: Colors.brown.shade700),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context).ekDegerTahminiBalAraligi(
                _kg(_tahminiBalPotansiyeliMinKg),
                _kg(_tahminiBalPotansiyeliMaxKg),
                _paraFormatla(_tahminiBalDegeriMin),
                _paraFormatla(_tahminiBalDegeriMax),
              ),
              style: TextStyle(fontSize: 12.5, height: 1.4, color: Colors.brown.shade700),
            ),
            const SizedBox(height: 6),
            Text(
              AppLocalizations.of(context).ekDegerHesapAciklama,
              style: const TextStyle(fontSize: 12, height: 1.35, color: Colors.black54),
            ),
          ],
          const SizedBox(height: 12),
          _alan(AppLocalizations.of(context).ekDegerBalFiyati, _balKgFiyatiController),
          const SizedBox(height: 10),
          _alan(AppLocalizations.of(context).ekDegerAriliCita, _ariliCitaDegeriController),
          const SizedBox(height: 10),
          _alan(AppLocalizations.of(context).ekDegerBosKovan, _bosKovanDegeriController),
          const SizedBox(height: 10),
          _alan(AppLocalizations.of(context).ekDegerBosKabarmisPetek, _bosKabarmisPetekSayisiController),
          const SizedBox(height: 10),
          _alan(AppLocalizations.of(context).ekDegerBosKabarmisPetekBirim, _bosKabarmisPetekDegeriController),
        ],
      ),
    );
  }

  Widget _alan(String etiket, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: (_) => _ekonomikAlanDegisti(),
      decoration: InputDecoration(
        labelText: etiket,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: const Color(0xFFFFFDF7),
      ),
    );
  }

  String _kg(double v) => v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 1);

  String _paraFormatla(double deger) {
    return deger.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
    );
  }

  int _toIntFromText(String metin) => int.tryParse(metin.trim()) ?? 0;

  double _toDouble(dynamic deger) {
    if (deger == null) return 0;
    if (deger is num) return deger.toDouble();
    return double.tryParse(deger.toString().trim().replaceAll(',', '.')) ?? 0;
  }
}