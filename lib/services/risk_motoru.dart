import 'dart:math' as math;

/// İTOGENA Risk Motoru
///
/// Amaç:
/// Koloninin o andaki kararlarını sert biçimde değiştirmek değil,
/// sezonun doğal risk primini ve koloninin biyolojik kırılganlığını birlikte
/// okuyarak dengeli bir risk freni üretmektir.
///
/// Bu motor kesin hastalık/zararlı teşhisi yapmaz.
/// Yalnızca saha kararlarını destekleyen açıklanabilir risk eğilimi üretir.
class RiskMotoru {
  static Map<String, dynamic> hesapla({
    required Map<String, dynamic> demografi,
    required Map<String, dynamic> kabiliyet,
    required Map<String, dynamic> citaAktivasyon,
    required Map<String, dynamic> sezonBiyoloji,
    required Map<String, dynamic> yavrusuzlukAnalizi,
    required int toplamCita,
    required int kuluclukCita,
    required int ballikCita,
    required int balliCita,
    required double islevselToplamCita,
    required int islevselUretimCita,
    required double aktivasyonOrani,
    required bool balAkimiAktif,
    required bool yavruYokMu,
    required bool riskliSisirme,
    required bool uretimGuvenliMi,
    required int hasatEdilebilirCita,
    required int tahminiStokCita,
    required String koloniSinifi,
    required double gunlukMomentum,
    required String momentumEtiketi,
  }) {
    final String sezonKodu =
        (sezonBiyoloji['kod'] ?? '').toString().trim().toLowerCase();

    final String sezonAdi =
        (sezonBiyoloji['ad'] ?? '').toString().trim();

    final double etkinCita = islevselToplamCita > 0
        ? islevselToplamCita
        : math.max(islevselUretimCita, toplamCita).toDouble();

    final List<Map<String, dynamic>> riskler = <Map<String, dynamic>>[];

    void ekle({
      required String kod,
      required String baslik,
      required int sezonPrimi,
      required int koloniKirilganligi,
      required String mesaj,
    }) {
      final int etki = _sinirlaRisk(
        ((sezonPrimi * 0.58) + (koloniKirilganligi * 0.42)).round(),
      );

      if (sezonPrimi <= 0 && koloniKirilganligi <= 0 && etki <= 0) {
        return;
      }

      riskler.add({
        'kod': kod,
        'baslik': baslik,
        'sezonPrimi': _riskEtiketi(sezonPrimi),
        'koloniKirilganligi': _riskEtiketi(koloniKirilganligi),
        'etki': _riskEtiketi(etki),
        'riskPuani': etki,
        'fren': _fren(etki),
        'mesaj': mesaj,
      });
    }

    final int savunmaPuani = _toInt(kabiliyet['savunmaPuani']);
    final int kisDayanimPuani = _toInt(kabiliyet['kisDayanimPuani']);
    final int toparlanmaPuani = _toInt(kabiliyet['toparlanmaPuani']);
    final int petekPuani = _toInt(kabiliyet['petekOrmePuani']);

    final String gencIsciSeviyesi =
        (demografi['gencIsciSeviyesi'] ?? '').toString().toLowerCase();
    final String yasliBaski =
        (demografi['yasliNufusBaskisi'] ?? '').toString().toLowerCase();
    final String gelecekDestek =
        (demografi['gelecekNufusDestegi'] ?? '').toString().toLowerCase();

    final int gencIsciKirilganligi =
        _seviyeRisk(gencIsciSeviyesi, ters: true);

    final int yasliBaskiRiski =
        _seviyeRisk(yasliBaski);

    final int gelecekDestekRiski =
        _seviyeRisk(gelecekDestek, ters: true);

    final int savunmaKirilganligi =
        savunmaPuani <= 30 ? 3 : (savunmaPuani <= 50 ? 2 : (savunmaPuani <= 70 ? 1 : 0));

    final int kisDayanimKirilganligi =
        kisDayanimPuani <= 30 ? 3 : (kisDayanimPuani <= 50 ? 2 : (kisDayanimPuani <= 70 ? 1 : 0));

    final int toparlanmaKirilganligi =
        toparlanmaPuani <= 30 ? 3 : (toparlanmaPuani <= 50 ? 2 : (toparlanmaPuani <= 70 ? 1 : 0));

    final int stokKirilganligi = _stokKirilganligi(
      toplamCita: toplamCita,
      balliCita: balliCita,
      tahminiStokCita: tahminiStokCita,
      sezonKodu: sezonKodu,
    );

    final int aktivasyonKirilganligi =
        aktivasyonOrani < 0.40 ? 3 : (aktivasyonOrani < 0.65 ? 2 : (aktivasyonOrani < 0.80 ? 1 : 0));

    final bool hacimRiskli =
        riskliSisirme ||
        citaAktivasyon['riskliSisirme'] == true ||
        (aktivasyonOrani < 0.55 && toplamCita >= 7);

    final int yavrusuzlukRiski = _yavrusuzlukRiskPuani(
      yavruYokMu: yavruYokMu,
      yavrusuzlukAnalizi: yavrusuzlukAnalizi,
    );

    final int zayifKoloniRiski =
        etkinCita <= 3 ? 3 : (etkinCita <= 5 ? 2 : (etkinCita <= 7 ? 1 : 0));

    ekle(
      kod: 'VARROA',
      baslik: 'Varroa',
      sezonPrimi: _sezonPrimi(sezonKodu, 'VARROA'),
      koloniKirilganligi: _sinirlaRisk(
        ((gelecekDestekRiski * 0.40) +
                (toparlanmaKirilganligi * 0.35) +
                (zayifKoloniRiski * 0.25))
            .round(),
      ),
      mesaj:
          'Varroa riski sezon, yavru döngüsü ve koloninin toparlanma kapasitesiyle birlikte okunur.',
    );

    ekle(
      kod: 'ARI_KUSU',
      baslik: 'Arı kuşu',
      sezonPrimi: _sezonPrimi(sezonKodu, 'ARI_KUSU'),
      koloniKirilganligi: _sinirlaRisk(
        ((yavrusuzlukRiski * 0.45) +
                (gencIsciKirilganligi * 0.30) +
                (zayifKoloniRiski * 0.25))
            .round(),
      ),
      mesaj:
          'Arı kuşu riski özellikle ana kazanma, çiftleşme ve zayıf toparlanma dönemlerinde kararları temkinli hale getirir.',
    );

    ekle(
      kod: 'ESEK_ARISI',
      baslik: 'Eşek arısı',
      sezonPrimi: _sezonPrimi(sezonKodu, 'ESEK_ARISI'),
      koloniKirilganligi: _sinirlaRisk(
        ((savunmaKirilganligi * 0.55) +
                (zayifKoloniRiski * 0.30) +
                (stokKirilganligi * 0.15))
            .round(),
      ),
      mesaj:
          'Eşek arısı baskısı zayıf ve savunma kapasitesi düşük kolonilerde daha fazla fren üretir.',
    );

    ekle(
      kod: 'YAGMA',
      baslik: 'Yağmacılık',
      sezonPrimi: _sezonPrimi(sezonKodu, 'YAGMA'),
      koloniKirilganligi: _sinirlaRisk(
        ((savunmaKirilganligi * 0.50) +
                (zayifKoloniRiski * 0.30) +
                (stokKirilganligi * 0.20))
            .round(),
      ),
      mesaj:
          'Yağmacılık riski hasat sonrası, sonbahar ve zayıf savunma dönemlerinde hacim/besleme kararlarını yumuşatır.',
    );

    ekle(
      kod: 'NEM_KIS',
      baslik: 'Nem / kış',
      sezonPrimi: _sezonPrimi(sezonKodu, 'NEM_KIS'),
      koloniKirilganligi: _sinirlaRisk(
        ((kisDayanimKirilganligi * 0.45) +
                (stokKirilganligi * 0.35) +
                (zayifKoloniRiski * 0.20))
            .round(),
      ),
      mesaj:
          'Nem ve kış riski genişletme değil sıkışık hacim, stok ve dayanım tarafını öne çıkarır.',
    );

    ekle(
      kod: 'ASIRI_GENISLEME',
      baslik: 'Aşırı genişleme',
      sezonPrimi: hacimRiskli ? 2 : 0,
      koloniKirilganligi: _sinirlaRisk(
        ((aktivasyonKirilganligi * 0.55) +
                (gencIsciKirilganligi * 0.25) +
                (petekPuani <= 40 ? 1 : 0))
            .round(),
      ),
      mesaj:
          'Yeni hacim koloninin işlevsel kapasitesinden hızlı büyüyorsa sistem genişleme kararlarını frenler.',
    );

    ekle(
      kod: 'YAVRUSUZLUK_YASLANMA',
      baslik: 'Yavrusuzluk / yaşlanma',
      sezonPrimi: yavruYokMu ? 2 : 0,
      koloniKirilganligi: _sinirlaRisk(
        ((yavrusuzlukRiski * 0.55) +
                (yasliBaskiRiski * 0.25) +
                (gencIsciKirilganligi * 0.20))
            .round(),
      ),
      mesaj:
          'Yavru dönüşü zayıfsa veya genç işçi desteği düşükse koloni yaşlanma yönünde temkinli okunur.',
    );

    ekle(
      kod: 'BAL_KALITESI',
      baslik: 'Bal kalitesi',
      sezonPrimi: _sezonPrimi(sezonKodu, 'BAL_KALITESI'),
      koloniKirilganligi: balAkimiAktif && hasatEdilebilirCita > 0 ? 1 : 0,
      mesaj:
          'Bal akımı ve hasat adaylığı varsa besleme/ilaçlama gibi kalıntı riski taşıyan kararlar daha dikkatli süzülür.',
    );

    riskler.sort((a, b) {
      final bp = _toInt(b['riskPuani']);
      final ap = _toInt(a['riskPuani']);
      if (bp != ap) return bp.compareTo(ap);
      return (a['kod'] ?? '').toString().compareTo((b['kod'] ?? '').toString());
    });

    final Map<String, dynamic>? anaRisk =
        riskler.isEmpty ? null : riskler.first;

    final int genelRiskPuani = riskler.isEmpty
        ? 0
        : _genelRiskPuani(riskler);

    final int genelRiskSeviyesi = _puanToRisk(genelRiskPuani);
    final double riskFreni = _fren(genelRiskSeviyesi);

    return {
      'genelRisk': _riskEtiketi(genelRiskSeviyesi),
      'genelRiskPuani': genelRiskPuani,
      'riskFreni': riskFreni,
      'anaRisk': anaRisk?['kod'] ?? '',
      'anaRiskBaslik': anaRisk?['baslik'] ?? '',
      'kisaMesaj': _kisaMesaj(
        genelRiskSeviyesi: genelRiskSeviyesi,
        anaRisk: anaRisk,
        sezonAdi: sezonAdi,
      ),
      'sezonKodu': sezonKodu,
      'sezonAdi': sezonAdi,
      'riskler': riskler,
      'not':
          'Risk motoru kesin teşhis üretmez; sezon risk primi ve koloni kırılganlığından dengeli karar freni üretir.',
    };
  }

  static int _genelRiskPuani(List<Map<String, dynamic>> riskler) {
    int toplam = 0;
    int agirlik = 0;

    for (int i = 0; i < riskler.length; i++) {
      final int puan = _toInt(riskler[i]['riskPuani']);
      final int w = i == 0 ? 5 : (i == 1 ? 3 : 1);
      toplam += puan * w;
      agirlik += w;
    }

    if (agirlik <= 0) return 0;
    final double ort = toplam / agirlik;

    // Birden çok orta/yüksek risk varsa genel risk hafif artar.
    final int ortaUstu = riskler.where((r) => _toInt(r['riskPuani']) >= 2).length;
    final double ek = ortaUstu >= 3 ? 0.35 : (ortaUstu == 2 ? 0.20 : 0.0);

    return ((ort + ek) * 25).round().clamp(0, 100).toInt();
  }

  static int _puanToRisk(int puan) {
    if (puan >= 70) return 3;
    if (puan >= 45) return 2;
    if (puan >= 20) return 1;
    return 0;
  }

  static String _kisaMesaj({
    required int genelRiskSeviyesi,
    required Map<String, dynamic>? anaRisk,
    required String sezonAdi,
  }) {
    final String riskAdi = (anaRisk?['baslik'] ?? '').toString();

    switch (genelRiskSeviyesi) {
      case 3:
        return riskAdi.isEmpty
            ? 'Sezon ve koloni kırılganlığı birlikte yüksek risk üretiyor.'
            : '$riskAdi riski öne çıkıyor; kararlar temkinli uygulanmalı.';
      case 2:
        return riskAdi.isEmpty
            ? 'Sezon riski orta-yüksek; kararlar dengeli frenlenir.'
            : '$riskAdi riski orta-yüksek; koloni yönetimi buna göre yumuşatılır.';
      case 1:
        return riskAdi.isEmpty
            ? 'Sezon riski düşük/orta; küçük karar freni yeterli.'
            : '$riskAdi riski izlenir; fren düşük seviyede kalır.';
      default:
        return sezonAdi.isEmpty
            ? 'Belirgin doğal risk baskısı yok.'
            : '$sezonAdi için belirgin risk baskısı düşük.';
    }
  }

  static int _sezonPrimi(String sezonKodu, String riskKodu) {
    const Map<String, Map<String, int>> matris = {
      'kis': {
        'VARROA': 1,
        'ARI_KUSU': 0,
        'ESEK_ARISI': 0,
        'YAGMA': 0,
        'NEM_KIS': 3,
        'BAL_KALITESI': 0,
      },
      'kis_cikisi': {
        'VARROA': 1,
        'ARI_KUSU': 1,
        'ESEK_ARISI': 0,
        'YAGMA': 1,
        'NEM_KIS': 2,
        'BAL_KALITESI': 0,
      },
      'ilkbahar_gelisim': {
        'VARROA': 1,
        'ARI_KUSU': 2,
        'ESEK_ARISI': 0,
        'YAGMA': 1,
        'NEM_KIS': 1,
        'BAL_KALITESI': 0,
      },
      'bal_akimi_oncesi': {
        'VARROA': 2,
        'ARI_KUSU': 2,
        'ESEK_ARISI': 1,
        'YAGMA': 1,
        'NEM_KIS': 0,
        'BAL_KALITESI': 2,
      },
      'bal_akimi': {
        'VARROA': 2,
        'ARI_KUSU': 1,
        'ESEK_ARISI': 1,
        'YAGMA': 1,
        'NEM_KIS': 0,
        'BAL_KALITESI': 3,
      },
      'hasat_sonrasi': {
        'VARROA': 3,
        'ARI_KUSU': 1,
        'ESEK_ARISI': 2,
        'YAGMA': 3,
        'NEM_KIS': 1,
        'BAL_KALITESI': 1,
      },
      'sonbahar_hazirlik': {
        'VARROA': 3,
        'ARI_KUSU': 0,
        'ESEK_ARISI': 3,
        'YAGMA': 3,
        'NEM_KIS': 2,
        'BAL_KALITESI': 0,
      },
      'gec_sonbahar': {
        'VARROA': 2,
        'ARI_KUSU': 0,
        'ESEK_ARISI': 1,
        'YAGMA': 2,
        'NEM_KIS': 3,
        'BAL_KALITESI': 0,
      },
    };

    return _sinirlaRisk(matris[sezonKodu]?[riskKodu] ?? 0);
  }

  static int _stokKirilganligi({
    required int toplamCita,
    required int balliCita,
    required int tahminiStokCita,
    required String sezonKodu,
  }) {
    final bool stokSezonu = sezonKodu == 'kis' ||
        sezonKodu == 'kis_cikisi' ||
        sezonKodu == 'sonbahar_hazirlik' ||
        sezonKodu == 'gec_sonbahar';

    final int stokCita = math.max(balliCita, tahminiStokCita);
    final double oran = toplamCita <= 0 ? 0.0 : stokCita / toplamCita;

    if (stokSezonu) {
      if (oran < 0.18) return 3;
      if (oran < 0.28) return 2;
      if (oran < 0.38) return 1;
      return 0;
    }

    if (oran < 0.10) return 2;
    if (oran < 0.18) return 1;
    return 0;
  }

  static int _yavrusuzlukRiskPuani({
    required bool yavruYokMu,
    required Map<String, dynamic> yavrusuzlukAnalizi,
  }) {
    if (!yavruYokMu) return 0;

    final String cokus =
        (yavrusuzlukAnalizi['biyolojikCokusRiski'] ?? '').toString().toLowerCase();

    if (cokus.contains('kritik')) return 3;
    if (cokus.contains('yüksek') || cokus.contains('yuksek')) return 3;
    if (cokus.contains('orta')) return 2;
    if (cokus.contains('düşük') || cokus.contains('dusuk')) return 1;

    final int gun = _toInt(yavrusuzlukAnalizi['yavrusuzGun']);
    if (gun >= 35) return 3;
    if (gun >= 21) return 2;
    return 1;
  }

  static int _seviyeRisk(String seviye, {bool ters = false}) {
    final String s = seviye.toLowerCase();

    int deger;
    if (s.contains('kritik')) {
      deger = 3;
    } else if (s.contains('yüksek') || s.contains('yuksek') || s.contains('güçlü') || s.contains('guclu')) {
      deger = 3;
    } else if (s.contains('orta')) {
      deger = 2;
    } else if (s.contains('düşük') || s.contains('dusuk') || s.contains('zayıf') || s.contains('zayif')) {
      deger = 1;
    } else {
      deger = 0;
    }

    if (!ters) return _sinirlaRisk(deger);

    // "ters" modunda yüksek kapasite düşük risk, düşük kapasite yüksek risk demektir.
    if (deger >= 3) return 0;
    if (deger == 2) return 1;
    if (deger == 1) return 2;
    return 1;
  }

  static int _sinirlaRisk(num v) => v.round().clamp(0, 3).toInt();

  static double _fren(int risk) {
    switch (_sinirlaRisk(risk)) {
      case 3:
        return 0.75;
      case 2:
        return 0.88;
      case 1:
        return 0.95;
      default:
        return 1.00;
    }
  }

  static String _riskEtiketi(int risk) {
    switch (_sinirlaRisk(risk)) {
      case 3:
        return 'kritik';
      case 2:
        return 'yüksek';
      case 1:
        return 'orta';
      default:
        return 'düşük';
    }
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    if (v is num) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }
}
