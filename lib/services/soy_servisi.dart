import 'veritabani_servisi.dart';

class SoyServisi {
  static Future<List<Map<String, dynamic>>> soyAgaciniOlustur() async {
    final koloniler = await VeritabaniServisi.kolonileriGetir(
      sadeceAktifler: false,
    );

    if (koloniler.isEmpty) return [];

    final Set<int> gorunenIdler = <int>{};

    final List<Map<String, dynamic>> kokKoloniler = koloniler.where((k) {
      return _kokKoloniMi(k);
    }).toList()
      ..sort(_koloniSirala);

    final List<Map<String, dynamic>> agac = [];

    for (final kok in kokKoloniler) {
      final int kokId = _toInt(kok['id']);
      if (kokId <= 0) continue;
      if (gorunenIdler.contains(kokId)) continue;

      final dal = await _nesilleriYukle(
        ebeveyn: kok,
        tumListe: koloniler,
        yol: <int>{},
        gorunenIdler: gorunenIdler,
      );

      final bool yasayanHatMi = _daldaAktifVarMi(dal);
      if (!yasayanHatMi) {
        continue;
      }

      agac.add(dal);
    }

    agac.sort(_koloniSirala);
    return agac;
  }

  static Future<Map<String, dynamic>> _nesilleriYukle({
    required Map<String, dynamic> ebeveyn,
    required List<Map<String, dynamic>> tumListe,
    required Set<int> yol,
    required Set<int> gorunenIdler,
  }) async {
    final int ebeveynId = _toInt(ebeveyn['id']);

    if (ebeveynId <= 0) {
      return {
        ...ebeveyn,
        'aktifMi': true,
        'yasayanHatMi': true,
        'cocuklar': <Map<String, dynamic>>[],
      };
    }

    if (yol.contains(ebeveynId)) {
      final ozet = await VeritabaniServisi.koloniOzetiGetir(ebeveynId);
      final aktifMi = await VeritabaniServisi.koloniAktifMi(ebeveynId);

      return {
        ...ebeveyn,
        'skor': ozet['skor'] ?? ebeveyn['skor'] ?? 0,
        'sonCita': ozet['sonCita'] ?? ebeveyn['sonCita'] ?? 0,
        'bal_cita': ozet['bal_cita'] ?? ebeveyn['bal_cita'] ?? 0,
        'maxCitaKapasiye':
        ozet['maxCitaKapasiye'] ?? ebeveyn['maxCitaKapasiye'] ?? 0,
        'aktifMi': aktifMi,
        'yasayanHatMi': aktifMi,
        'cocuklar': <Map<String, dynamic>>[],
      };
    }

    final Set<int> yeniYol = {...yol, ebeveynId};
    gorunenIdler.add(ebeveynId);

    final ozet = await VeritabaniServisi.koloniOzetiGetir(ebeveynId);
    final aktifMi = await VeritabaniServisi.koloniAktifMi(ebeveynId);

    final List<Map<String, dynamic>> cocuklar = tumListe.where((k) {
      final int id = _toInt(k['id']);
      if (id <= 0 || id == ebeveynId) return false;
      return _buKoloniEbeveyneBagliMi(k, ebeveyn);
    }).toList()
      ..sort(_koloniSirala);

    final List<Map<String, dynamic>> altNesiller = [];

    for (final cocuk in cocuklar) {
      final cocukId = _toInt(cocuk['id']);
      if (cocukId <= 0) continue;

      final dal = await _nesilleriYukle(
        ebeveyn: cocuk,
        tumListe: tumListe,
        yol: yeniYol,
        gorunenIdler: gorunenIdler,
      );
      altNesiller.add(dal);
    }

    final bool yasayanHatMi =
        aktifMi || altNesiller.any((c) => c['yasayanHatMi'] == true);

    return {
      ...ebeveyn,
      'skor': ozet['skor'] ?? ebeveyn['skor'] ?? 0,
      'sonCita': ozet['sonCita'] ?? ebeveyn['sonCita'] ?? 0,
      'bal_cita': ozet['bal_cita'] ?? ebeveyn['bal_cita'] ?? 0,
      'maxCitaKapasiye':
      ozet['maxCitaKapasiye'] ?? ebeveyn['maxCitaKapasiye'] ?? 0,
      'aktifMi': aktifMi,
      'yasayanHatMi': yasayanHatMi,
      'cocuklar': altNesiller,
    };
  }

  static bool _daldaAktifVarMi(Map<String, dynamic> dal) {
    if (dal['aktifMi'] == true) return true;

    final List<Map<String, dynamic>> cocuklar =
        (dal['cocuklar'] as List?)?.cast<Map<String, dynamic>>() ??
            const <Map<String, dynamic>>[];

    for (final cocuk in cocuklar) {
      if (_daldaAktifVarMi(cocuk)) return true;
    }

    return false;
  }

  static bool _buKoloniEbeveyneBagliMi(
      Map<String, dynamic> cocuk,
      Map<String, dynamic> ebeveyn,
      ) {
    final int cocukId = _toInt(cocuk['id']);
    final int ebeveynId = _toInt(ebeveyn['id']);
    if (cocukId <= 0 || ebeveynId <= 0) return false;
    if (cocukId == ebeveynId) return false;

    final int kaynakKoloniId = _toInt(cocuk['kaynakKoloniId']);
    if (kaynakKoloniId > 0) {
      return kaynakKoloniId == ebeveynId;
    }

    final int ebeveynKoloniId = _toInt(cocuk['ebeveynKoloniId']);
    if (ebeveynKoloniId > 0) {
      return ebeveynKoloniId == ebeveynId;
    }

    return false;
  }

  static bool _kokKoloniMi(Map<String, dynamic> koloni) {
    final int id = _toInt(koloni['id']);
    final int kaynakId = _toInt(koloni['kaynakKoloniId']);
    final int ebeveynId = _toInt(koloni['ebeveynKoloniId']);
    final int kokId = _toInt(koloni['kokKoloniId']);

    final String kaynakTipi =
    (koloni['kaynakTipi'] ?? '').toString().trim().toLowerCase();
    final String kaynakKoloni =
    (koloni['kaynakKoloni'] ?? '').toString().trim().toLowerCase();

    if (id <= 0) return false;

    if (kokId > 0 && kokId == id) return true;
    if (ebeveynId <= 0 && kaynakId <= 0) return true;
    if (kaynakTipi == 'ana hat' || kaynakTipi == 'dış kaynak') return true;
    if (kaynakKoloni.isEmpty || kaynakKoloni == '-') return true;

    return false;
  }

  static int _koloniSirala(Map<String, dynamic> a, Map<String, dynamic> b) {
    final aAktif = a['aktifMi'] == true;
    final bAktif = b['aktifMi'] == true;
    if (aAktif != bAktif) {
      return aAktif ? -1 : 1;
    }

    final aSira = _toInt(a['sahaSirasi']);
    final bSira = _toInt(b['sahaSirasi']);
    if (aSira != bSira) return aSira.compareTo(bSira);

    final aNo = (a['kovanNo'] ?? '').toString();
    final bNo = (b['kovanNo'] ?? '').toString();
    return aNo.compareTo(bNo);
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }
}
