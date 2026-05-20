import 'dart:math' as math;

/// ITOGENA demografi motoru.
///
/// Amaç kesin arı sayımı yapmak değildir. Çıta gücü, yavru yükü, sezon,
/// gelişim yönü ve kaynak tipinden saha kararlarında kullanılabilir iş gücü
/// dağılımı üretir.
class DemografiMotoru {
  static Map<String, dynamic> hesapla({
    required int tahminiAri,
    required int tahminiYavru,
    required int kuluclukCita,
    required int ballikCita,
    required double gunlukMomentum,
    required String momentumEtiketi,
    required String kaynakTipi,
    String yavruDuzeni = '',
    Map<String, dynamic>? sezonBiyoloji,
  }) {
    final int toplamAri = math.max(0, tahminiAri);
    final int yavru = math.max(0, tahminiYavru);
    final String sezonKodu = (sezonBiyoloji?['kod'] ?? '').toString().trim();
    final String sezonAdi = (sezonBiyoloji?['ad'] ?? '').toString().trim();
    final double sezonKatsayisi = _toDouble(sezonBiyoloji?['aktivasyonKatsayisi']);
    final String momentum = momentumEtiketi.trim();
    final String kaynak = kaynakTipi.trim().toLowerCase();
    final String duzen = yavruDuzeni.trim().toLowerCase();

    // Temporal polyethism saha modeli:
    // 0–3 gün temizlik, 3–10 gün bakıcı, 10–16 gün petek örme/bal işleme,
    // 16–21 gün iç iş/bekçilik, 21+ gün tarlacı. Bu sayım değil, karar katsayısıdır.
    double temizlikOran = 0.08;
    double bakiciOran = 0.24;
    double petekOrucuOran = 0.16;
    double icIsciOran = 0.12;
    double bekciOran = 0.06;
    double tarlaciOran = 0.29;
    double erkekOran = 0.05;

    final List<String> gerekceler = <String>[];

    final bool hizliGelisim = gunlukMomentum >= 0.15 ||
        momentum.contains('Güçlü') ||
        momentum.contains('Patlayıcı') ||
        momentum.contains('hızlı') ||
        momentum.contains('Hızlı');
    if (hizliGelisim) {
      temizlikOran += 0.01;
      bakiciOran += 0.04;
      petekOrucuOran += 0.04;
      tarlaciOran -= 0.05;
      bekciOran -= 0.01;
      gerekceler.add('Koloni gelişim yönü genç işçi ve bakım arısı ağırlığını artırıyor.');
    }

    if (ballikCita > 0 || kuluclukCita >= 8) {
      tarlaciOran += 0.04;
      icIsciOran += 0.02;
      bakiciOran -= 0.03;
      temizlikOran -= 0.01;
      gerekceler.add('Koloni üretim hacmine yaklaştığı için tarlacı ve bal işleme yükü artıyor.');
    }

    if (kaynak.contains('oğul') || kaynak.contains('ogul')) {
      petekOrucuOran += 0.03;
      bakiciOran += 0.02;
      tarlaciOran -= 0.03;
      gerekceler.add('Oğul kökenli kolonide petek işleme eğilimi daha yüksek kabul edildi.');
    }

    switch (sezonKodu) {
      case 'kis':
        tarlaciOran -= 0.08;
        petekOrucuOran -= 0.05;
        bakiciOran -= 0.02;
        icIsciOran += 0.05;
        bekciOran += 0.04;
        temizlikOran += 0.03;
        gerekceler.add('Kış döneminde dış çalışma ve petek işleme kapasitesi doğal olarak düşer.');
        break;
      case 'kis_cikisi':
        bakiciOran += 0.04;
        temizlikOran += 0.01;
        tarlaciOran -= 0.03;
        gerekceler.add('Kış çıkışında bakım yükü artar; tarlacı kapasitesi henüz tam açılmaz.');
        break;
      case 'ilkbahar_gelisim':
        bakiciOran += 0.05;
        petekOrucuOran += 0.03;
        tarlaciOran -= 0.03;
        gerekceler.add('İlkbahar gelişiminde yavru bakım ve petek işleme baskısı yükselir.');
        break;
      case 'bal_akimi_oncesi':
        petekOrucuOran += 0.03;
        bakiciOran += 0.02;
        tarlaciOran += 0.01;
        gerekceler.add('Bal akımı öncesinde alan hazırlığı ve genç işçi kapasitesi önem kazanır.');
        break;
      case 'bal_akimi':
        tarlaciOran += 0.08;
        icIsciOran += 0.03;
        bakiciOran -= 0.04;
        temizlikOran -= 0.01;
        gerekceler.add('Bal akımında tarlacı ve bal işleme kapasitesi öne çıkar.');
        break;
      case 'hasat_sonrasi':
        bakiciOran += 0.02;
        icIsciOran += 0.02;
        tarlaciOran -= 0.03;
        gerekceler.add('Hasat sonrası koloni toparlanma ve denge kurma dönemindedir.');
        break;
      case 'sonbahar_hazirlik':
        bakiciOran += 0.03;
        icIsciOran += 0.02;
        tarlaciOran -= 0.02;
        gerekceler.add('Sonbahar hazırlığında kış arısı ve stok düzeni önceliklidir.');
        break;
      case 'gec_sonbahar':
        tarlaciOran -= 0.05;
        petekOrucuOran -= 0.04;
        icIsciOran += 0.04;
        bekciOran += 0.02;
        gerekceler.add('Geç sonbaharda genişleme değil, daralma ve savunma dengesi önemlidir.');
        break;
    }

    if (duzen.contains('blok')) {
      bakiciOran += 0.03;
      gerekceler.add('Blok yavru düzeni bakım arısı kapasitesini destekler.');
    } else if (duzen.contains('dağınık') || duzen.contains('daginik')) {
      bakiciOran -= 0.03;
      icIsciOran += 0.01;
      gerekceler.add('Dağınık yavru düzeni bakım sürekliliği açısından temkinli okundu.');
    } else if (duzen.contains('yok')) {
      bakiciOran -= 0.05;
      tarlaciOran += 0.03;
      gerekceler.add('Yavru yok kaydı bakım yükünü düşürür; ancak biyolojik risk ayrıca izlenmelidir.');
    }

    temizlikOran = math.max(0.03, temizlikOran);
    bakiciOran = math.max(0.08, bakiciOran);
    petekOrucuOran = math.max(0.04, petekOrucuOran);
    icIsciOran = math.max(0.05, icIsciOran);
    bekciOran = math.max(0.03, bekciOran);
    tarlaciOran = math.max(0.08, tarlaciOran);
    erkekOran = math.max(0.01, erkekOran);

    final toplamOran = temizlikOran +
        bakiciOran +
        petekOrucuOran +
        icIsciOran +
        bekciOran +
        tarlaciOran +
        erkekOran;
    temizlikOran /= toplamOran;
    bakiciOran /= toplamOran;
    petekOrucuOran /= toplamOran;
    icIsciOran /= toplamOran;
    bekciOran /= toplamOran;
    tarlaciOran /= toplamOran;
    erkekOran /= toplamOran;

    int adet(double oran) => (toplamAri * oran).round();

    final int temizlikAri = adet(temizlikOran);
    final int bakiciAri = adet(bakiciOran);
    final int petekOrucuAri = adet(petekOrucuOran);
    final int icIsci = adet(icIsciOran);
    final int bekciAri = adet(bekciOran);
    final int tarlaciAri = adet(tarlaciOran);
    final int erkekAri = adet(erkekOran);
    final int gencIsciAri = temizlikAri + bakiciAri + petekOrucuAri;
    final int isciAri = math.max(0, toplamAri - erkekAri);

    final double gencIsciOran = temizlikOran + bakiciOran + petekOrucuOran;
    final double bakiciYuku = yavru <= 0 || bakiciAri <= 0 ? 0 : yavru / bakiciAri;
    final String bakiciDenge = _bakiciDenge(bakiciYuku, yavru);
    final String gencIsciSeviyesi = _oranSeviyesi(gencIsciOran, 0.32, 0.42);
    final String bakiciSeviyesi = _oranSeviyesi(bakiciOran, 0.20, 0.28);
    final String tarlaciSeviyesi = _oranSeviyesi(tarlaciOran, 0.24, 0.34);
    final String gelecekNufusDestegi = _gelecekNufusDestegi(
      yavru: yavru,
      toplamAri: toplamAri,
      kuluclukCita: kuluclukCita,
      sezonKodu: sezonKodu,
    );
    final String yasliNufusBaskisi = _yasliNufusBaskisi(
      tarlaciOran: tarlaciOran,
      gencIsciOran: gencIsciOran,
      sezonKodu: sezonKodu,
    );
    final String guvenDuzeyi = _guvenDuzeyi(
      toplamAri: toplamAri,
      kuluclukCita: kuluclukCita,
      yavru: yavru,
      sezonKodu: sezonKodu,
    );

    return {
      // Geriye dönük uyumlu alanlar
      'toplamAri': toplamAri,
      'isciAri': isciAri,
      'erkekAri': erkekAri,
      'yavru': yavru,
      'temizlikAri': temizlikAri,
      'bakiciAri': bakiciAri,
      'petekOrucuAri': petekOrucuAri,
      'gencIsciAri': gencIsciAri,
      'icIsci': icIsci,
      'bekciAri': bekciAri,
      'tarlaciAri': tarlaciAri,
      'temizlikOran': _yuvarla(temizlikOran * 100),
      'bakiciOran': _yuvarla(bakiciOran * 100),
      'petekOrucuOran': _yuvarla(petekOrucuOran * 100),
      'gencIsciOran': _yuvarla(gencIsciOran * 100),
      'icIsciOran': _yuvarla(icIsciOran * 100),
      'bekciOran': _yuvarla(bekciOran * 100),
      'tarlaciOran': _yuvarla(tarlaciOran * 100),
      'erkekOran': _yuvarla(erkekOran * 100),
      'yasGorevDagilimi': {
        '0_3_gun_temizlik': temizlikAri,
        '3_10_gun_bakici': bakiciAri,
        '10_16_gun_petek_orme_bal_isleme': petekOrucuAri,
        '16_21_gun_bekcilik_ic_is': bekciAri + icIsci,
        '21_gun_ustu_tarlaci': tarlaciAri,
      },

      // Yeni demografi motoru alanları
      'sezonKodu': sezonKodu,
      'sezonAdi': sezonAdi,
      'sezonKatsayisi': _yuvarla(sezonKatsayisi),
      'gencIsciSeviyesi': gencIsciSeviyesi,
      'bakiciSeviyesi': bakiciSeviyesi,
      'tarlaciSeviyesi': tarlaciSeviyesi,
      'bakiciYuku': _yuvarla(bakiciYuku),
      'bakiciDenge': bakiciDenge,
      'gelecekNufusDestegi': gelecekNufusDestegi,
      'yasliNufusBaskisi': yasliNufusBaskisi,
      'demografiGuvenDuzeyi': guvenDuzeyi,
      'isGucuOzeti': _isGucuOzeti(
        gencIsciSeviyesi: gencIsciSeviyesi,
        bakiciSeviyesi: bakiciSeviyesi,
        tarlaciSeviyesi: tarlaciSeviyesi,
        gelecekNufusDestegi: gelecekNufusDestegi,
      ),
      'sahaYorumu': _sahaYorumu(
        toplamAri: toplamAri,
        gencIsciSeviyesi: gencIsciSeviyesi,
        bakiciDenge: bakiciDenge,
        tarlaciSeviyesi: tarlaciSeviyesi,
        yasliNufusBaskisi: yasliNufusBaskisi,
      ),
      'demografiGerekceleri': gerekceler,
      'demografiNotu':
          'Bu dağılım kesin sayım değildir; çıta, yavru, sezon ve gelişim yönünden üretilen saha projeksiyonudur.',
    };
  }

  static String _oranSeviyesi(double oran, double ortaEsik, double yuksekEsik) {
    if (oran >= yuksekEsik) return 'yüksek';
    if (oran >= ortaEsik) return 'orta';
    return 'düşük';
  }

  static String _bakiciDenge(double bakiciYuku, int yavru) {
    if (yavru <= 0) return 'yavru yükü yok';
    if (bakiciYuku <= 1.4) return 'rahat';
    if (bakiciYuku <= 2.2) return 'dengeli';
    if (bakiciYuku <= 3.2) return 'sınırda';
    return 'baskı yüksek';
  }

  static String _gelecekNufusDestegi({
    required int yavru,
    required int toplamAri,
    required int kuluclukCita,
    required String sezonKodu,
  }) {
    if (yavru <= 0) return 'düşük';
    final double oran = toplamAri <= 0 ? 0 : yavru / toplamAri;
    final bool gelisimSezonu = sezonKodu == 'kis_cikisi' ||
        sezonKodu == 'ilkbahar_gelisim' ||
        sezonKodu == 'bal_akimi_oncesi' ||
        sezonKodu == 'sonbahar_hazirlik';
    if (oran >= 0.55 || (kuluclukCita >= 7 && gelisimSezonu)) return 'yüksek';
    if (oran >= 0.28 || kuluclukCita >= 5) return 'orta';
    return 'düşük';
  }

  static String _yasliNufusBaskisi({
    required double tarlaciOran,
    required double gencIsciOran,
    required String sezonKodu,
  }) {
    final bool hassasSezon = sezonKodu == 'hasat_sonrasi' ||
        sezonKodu == 'sonbahar_hazirlik' ||
        sezonKodu == 'gec_sonbahar';
    if (tarlaciOran >= 0.38 && gencIsciOran < 0.34) return 'yüksek';
    if (hassasSezon && tarlaciOran >= 0.32 && gencIsciOran < 0.38) {
      return 'orta';
    }
    return 'düşük';
  }

  static String _guvenDuzeyi({
    required int toplamAri,
    required int kuluclukCita,
    required int yavru,
    required String sezonKodu,
  }) {
    if (toplamAri <= 0 || kuluclukCita <= 0) return 'düşük';
    if (yavru > 0 && sezonKodu.isNotEmpty) return 'orta';
    return 'düşük';
  }

  static String _isGucuOzeti({
    required String gencIsciSeviyesi,
    required String bakiciSeviyesi,
    required String tarlaciSeviyesi,
    required String gelecekNufusDestegi,
  }) {
    return 'Genç işçi: $gencIsciSeviyesi · Bakıcı: $bakiciSeviyesi · Tarlacı: $tarlaciSeviyesi · Gelecek nüfus: $gelecekNufusDestegi';
  }

  static String _sahaYorumu({
    required int toplamAri,
    required String gencIsciSeviyesi,
    required String bakiciDenge,
    required String tarlaciSeviyesi,
    required String yasliNufusBaskisi,
  }) {
    if (toplamAri <= 0) return 'Demografi için yeterli koloni gücü verisi yok.';
    if (yasliNufusBaskisi == 'yüksek') {
      return 'Kolonide yaşlı/tarlacı ağırlığı yüksek; gelecek nüfus ve yavru desteği dikkatle izlenmeli.';
    }
    if (gencIsciSeviyesi == 'yüksek' && bakiciDenge != 'baskı yüksek') {
      return 'Genç işçi kapasitesi iyi; petek işleme ve yavru bakım tarafı destekli görünüyor.';
    }
    if (tarlaciSeviyesi == 'yüksek') {
      return 'Tarlacı kapasitesi güçlü; uygun sezonda nektar toplama gücü öne çıkar.';
    }
    if (bakiciDenge == 'baskı yüksek') {
      return 'Yavru yükü bakıcı kapasitesini zorluyor; aşırı genişletme temkinli yapılmalı.';
    }
    return 'Koloni iş gücü dengeli; karar için sezon ve aktivasyonla birlikte okunmalı.';
  }

  static double _toDouble(dynamic deger) {
    if (deger == null) return 0;
    if (deger is num) return deger.toDouble();
    return double.tryParse(deger.toString().replaceAll(',', '.')) ?? 0;
  }

  static double _yuvarla(double v) => double.parse(v.toStringAsFixed(2));
}
