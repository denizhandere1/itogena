import 'dart:math' as math;

import 'trend_servisi.dart';
import 'veritabani_servisi.dart';

class KoloniBiyolojikModelServisi {
  static const String kovanTipiLangstroth = 'Langstroth';
  static const String kovanTipiDadant = 'Dadant';

  static Future<Map<String, dynamic>> modelGetir(int koloniId) async {
    final koloni = await VeritabaniServisi.koloniOzetiGetir(koloniId);
    final muayeneler = await VeritabaniServisi.muayeneleriGetir(koloniId);
    final sonMuayene = muayeneler.isNotEmpty ? muayeneler.first : null;
    Map<String, dynamic> trend = const <String, dynamic>{};
    try {
      trend = await TrendServisi.koloniTrendiGetir(koloniId);
    } catch (_) {
      trend = const <String, dynamic>{};
    }
    Map<String, dynamic> suruplukPenceresi = const <String, dynamic>{};
    try {
      suruplukPenceresi =
      await VeritabaniServisi.suruplukKaldirmaPenceresiGetir(koloniId);
    } catch (_) {
      suruplukPenceresi = const <String, dynamic>{};
    }

    return modelOlustur(
      koloni: koloni,
      sonMuayene: sonMuayene,
      trend: trend,
      suruplukPenceresi: suruplukPenceresi,
    );
  }

  static Map<String, dynamic> modelOlustur({
    required Map<String, dynamic> koloni,
    Map<String, dynamic>? sonMuayene,
    Map<String, dynamic>? trend,
    Map<String, dynamic>? suruplukPenceresi,
  }) {
    final String kovanTipi = normalizeKovanTipi(koloni['kovanTipi']);
    final bool suruplukKayittaVarMi = _toBool(koloni['suruplukVarMi']);
    // Eski kayıtların çoğunda suruplukVarMi alanı migration nedeniyle 0 gelir.
    // Bu 0 değeri her zaman "fiziksel şurupluk yok" anlamına gelmez.
    // İTOGENA görsel modelinde şurupluk, arıcı açıkça kaldırmadıkça varsayılan ekipman olarak modellenir.
    final bool suruplukVarMi = true;
    final bool suruplukKaldirmaPenceresiAktif =
        suruplukPenceresi?['aktif'] == true;
    final bool hamSuruplukKaldirildiMi = _toBool(
      sonMuayene?['suruplukKaldirildiMi'] ?? koloni['suruplukKaldirildiMi'],
    );
    // Şurupluk kaldırma kaydı yalnızca bal akımı öncesi/akım içi
    // pencerede yerleşimi değiştirir. Hasat sonrası besleme dönemi açıldığında
    // şurupluk tekrar kullanılabilir kabul edilir.
    final bool suruplukKaldirildiMi =
        suruplukKaldirmaPenceresiAktif && hamSuruplukKaldirildiMi;

    final int toplamCita = _pozitifInt(
      sonMuayene?['citaSayisi'] ?? koloni['sonCita'],
    );
    final int balliCita = _pozitifInt(
      sonMuayene?['bal_cita'] ?? koloni['bal_cita'],
    );
    final int yavruluCita = _pozitifInt(sonMuayene?['yavruluCita']);
    final String yavruDuzeni = (sonMuayene?['yavruDuzeni'] ?? '').toString().trim();
    final String kaynakTipi = (koloni['kaynakTipi'] ?? '').toString().trim().toLowerCase();

    final Map<String, num> katsayi = _katsayilar(kovanTipi);
    final int katOncesiKapasite =
        suruplukVarMi && !suruplukKaldirildiMi ? 9 : 10;
    final bool katAtildi = toplamCita > katOncesiKapasite;
    final int kuluclukKapasitesi = katAtildi ? 10 : katOncesiKapasite;
    final int kuluclukCita = toplamCita.clamp(0, kuluclukKapasitesi).toInt();
    final int ballikCita = katAtildi ? math.max(0, toplamCita - 10) : 0;

    final int tahminiAriMin = (toplamCita * katsayi['ariMin']!).round();
    final int tahminiAriMax = (toplamCita * katsayi['ariMax']!).round();
    final int tahminiAriOrta = ((tahminiAriMin + tahminiAriMax) / 2).round();
    final int tahminiGozMin = (kuluclukCita * katsayi['gozMin']!).round();
    final int tahminiGozMax = (kuluclukCita * katsayi['gozMax']!).round();

    final int tahminiYavruCita = yavruluCita > 0
        ? yavruluCita.clamp(0, kuluclukCita).toInt()
        : _tahminiYavruCita(kuluclukCita, yavruDuzeni: yavruDuzeni);
    final int tahminiPolenCita = _tahminiPolenCita(kuluclukCita, tahminiYavruCita);
    final int tahminiStokCita = math.max(
      0,
      kuluclukCita - tahminiYavruCita - tahminiPolenCita,
    );

    final int tahminiYavruGozMin = (tahminiYavruCita * katsayi['yavruGozMin']!).round();
    final int tahminiYavruGozMax = (tahminiYavruCita * katsayi['yavruGozMax']!).round();
    final int tahminiYavruGozOrta = ((tahminiYavruGozMin + tahminiYavruGozMax) / 2).round();

    final double balKatsayiMin = katsayi['balKgMin']!.toDouble();
    final double balKatsayiMax = katsayi['balKgMax']!.toDouble();
    final hasatCitalari = _hasatAdayCitalari(
      kuluclukCita: kuluclukCita,
      kuluclukKapasitesi: kuluclukKapasitesi,
      ballikCita: ballikCita,
      balliCita: balliCita,
    );
    final hasatGuvenligi = _hasatGuvenligi(
      kuluclukCita: kuluclukCita,
      kuluclukKapasitesi: kuluclukKapasitesi,
      ballikCita: ballikCita,
      balliCita: balliCita,
      hasatAdaySayisi: hasatCitalari.length,
    );
    final int hasatEdilebilirCita = hasatCitalari.length;
    final double hasatPotansiyeliMinKg = hasatEdilebilirCita * balKatsayiMin;
    final double hasatPotansiyeliMaxKg = hasatEdilebilirCita * balKatsayiMax;

    final double birakilmasiGerekenBalMinKg = _birakilacakBalMinKg(kuluclukCita, kovanTipi);
    final double birakilmasiGerekenBalMaxKg = _birakilacakBalMaxKg(kuluclukCita, kovanTipi);

    final yerlesim = _yerlesimDizilimi(kuluclukCita);
    final yerlesimSatirlari = _yerlesimSatirlari(yerlesim);
    final yavruBlok = _yavruBlokAraligi(yerlesim);
    final anaBolgesi = _anaBolgesiMetni(kuluclukCita, yavruBlok);
    final gelisimAlani = _gelisimAlaniMetni(yerlesim, kuluclukKapasitesi);
    final kovanYerlesimi = _kovanYerlesimiOlustur(
      yerlesim: yerlesim,
      suruplukVarMi: suruplukVarMi,
      suruplukKaldirildiMi: suruplukKaldirildiMi,
      kuluclukKapasitesi: kuluclukKapasitesi,
      katAtildi: katAtildi,
      kuluclukCita: kuluclukCita,
      ballikCita: ballikCita,
      yavruBlok: yavruBlok,
    );

    final double gunlukMomentum = _toDouble(trend?['gunlukMomentum']);
    final String momentumEtiketi = (trend?['momentumEtiketi'] ?? '').toString().trim();
    final Map<String, dynamic> demografi = _demografiOlustur(
      tahminiAri: tahminiAriOrta,
      tahminiYavru: tahminiYavruGozOrta,
      kuluclukCita: kuluclukCita,
      ballikCita: ballikCita,
      gunlukMomentum: gunlukMomentum,
      momentumEtiketi: momentumEtiketi,
      kaynakTipi: kaynakTipi,
    );
    final Map<String, dynamic> kabiliyet = _kabiliyetOlustur(
      demografi: demografi,
      kuluclukCita: kuluclukCita,
      ballikCita: ballikCita,
      balliCita: balliCita,
      gunlukMomentum: gunlukMomentum,
      momentumEtiketi: momentumEtiketi,
      yavruDuzeni: yavruDuzeni,
    );

    final yorum = _yorumUret(
      toplamCita: toplamCita,
      kuluclukCita: kuluclukCita,
      ballikCita: ballikCita,
      kuluclukKapasitesi: kuluclukKapasitesi,
      balliCita: balliCita,
      hasatPotansiyeliMaxKg: hasatPotansiyeliMaxKg,
      kabiliyet: kabiliyet,
      yavruBlok: yavruBlok,
    );

    return {
      'kovanTipi': kovanTipi,
      'suruplukVarMi': suruplukVarMi,
      'suruplukKayittaVarMi': suruplukKayittaVarMi,
      'suruplukKaldirildiMi': suruplukKaldirildiMi,
      'suruplukKaldirmaPenceresiAktif': suruplukKaldirmaPenceresiAktif,
      'suruplukKaldirmaMesaji': (suruplukPenceresi?['mesaj'] ?? '').toString(),
      'suruplukKonumMetni': kovanYerlesimi['suruplukKonumMetni'],
      'kuluclukKapasitesi': kuluclukKapasitesi,
      'toplamCita': toplamCita,
      'kuluclukCita': kuluclukCita,
      'ballikCita': ballikCita,
      'katAtildi': katAtildi,
      'tahminiAriMin': tahminiAriMin,
      'tahminiAriMax': tahminiAriMax,
      'tahminiAriOrta': tahminiAriOrta,
      'tahminiGozMin': tahminiGozMin,
      'tahminiGozMax': tahminiGozMax,
      'tahminiYavruCita': tahminiYavruCita,
      'tahminiYavruGozMin': tahminiYavruGozMin,
      'tahminiYavruGozMax': tahminiYavruGozMax,
      'tahminiYavruGozOrta': tahminiYavruGozOrta,
      'tahminiPolenCita': tahminiPolenCita,
      'tahminiStokCita': tahminiStokCita,
      'hasatEdilebilirCita': hasatEdilebilirCita,
      'hasatPotansiyeliMinKg': _yuvarla(hasatPotansiyeliMinKg),
      'hasatPotansiyeliMaxKg': _yuvarla(hasatPotansiyeliMaxKg),
      'birakilmasiGerekenBalMinKg': _yuvarla(birakilmasiGerekenBalMinKg),
      'birakilmasiGerekenBalMaxKg': _yuvarla(birakilmasiGerekenBalMaxKg),
      'anaBolgesi': anaBolgesi,
      'yavruBlok': yavruBlok,
      'gelisimAlani': gelisimAlani,
      'hasatAdayCitalari': hasatCitalari,
      'hasatAdayMetni': _hasatAdayMetni(hasatCitalari),
      'hasatGuvenligi': hasatGuvenligi['seviye'],
      'hasatGuvenligiMesaji': hasatGuvenligi['mesaj'],
      'hasatKuralMetni': hasatGuvenligi['kural'],
      'yerlesim': yerlesim,
      'yerlesimSatirlari': yerlesimSatirlari,
      'yerlesimMetni': yerlesim.join(' / '),
      'altKatYerlesim': kovanYerlesimi['altKatYerlesim'],
      'ustKatYerlesim': kovanYerlesimi['ustKatYerlesim'],
      'tacPozisyonlari': kovanYerlesimi['tacPozisyonlari'],
      'kovanGorselNotu': kovanYerlesimi['not'],
      'demografi': demografi,
      'kabiliyet': kabiliyet,
      'ilgincBilgiler': _ilgincBilgiler(
        tahminiGozMin: tahminiGozMin,
        tahminiGozMax: tahminiGozMax,
        tahminiAriMin: tahminiAriMin,
        tahminiAriMax: tahminiAriMax,
        tahminiYavruGozMin: tahminiYavruGozMin,
        tahminiYavruGozMax: tahminiYavruGozMax,
        hasatMin: hasatPotansiyeliMinKg,
        hasatMax: hasatPotansiyeliMaxKg,
      ),
      'yorum': yorum,
    };
  }

  static String normalizeKovanTipi(dynamic deger) {
    final temiz = (deger ?? '').toString().trim().toLowerCase();
    if (temiz.contains('dadant')) return kovanTipiDadant;
    return kovanTipiLangstroth;
  }

  static Map<String, num> _katsayilar(String kovanTipi) {
    if (kovanTipi == kovanTipiDadant) {
      return const {
        'ariMin': 2300,
        'ariMax': 2700,
        'gozMin': 8000,
        'gozMax': 9000,
        'yavruGozMin': 5000,
        'yavruGozMax': 6500,
        'balKgMin': 3.0,
        'balKgMax': 4.0,
      };
    }
    return const {
      'ariMin': 1800,
      'ariMax': 2200,
      'gozMin': 6000,
      'gozMax': 7000,
      'yavruGozMin': 3500,
      'yavruGozMax': 5000,
      'balKgMin': 2.0,
      'balKgMax': 2.5,
    };
  }

  static int _tahminiYavruCita(int kuluclukCita, {required String yavruDuzeni}) {
    final d = yavruDuzeni.toLowerCase();
    int temel;
    if (kuluclukCita <= 0) {
      temel = 0;
    } else if (kuluclukCita <= 3) {
      temel = 1;
    } else if (kuluclukCita <= 5) {
      temel = 2;
    } else if (kuluclukCita <= 7) {
      temel = 3;
    } else if (kuluclukCita <= 8) {
      temel = 4;
    } else {
      temel = 5;
    }
    if (d.contains('blok')) temel += 1;
    if (d.contains('dağınık') || d.contains('daginik') || d.contains('kambur')) temel -= 1;
    return temel.clamp(0, kuluclukCita).toInt();
  }

  static int _tahminiPolenCita(int kuluclukCita, int yavruCita) {
    if (kuluclukCita <= 3) return 1;
    if (kuluclukCita <= 6) return 1;
    if (kuluclukCita <= 8) return 2;
    return math.max(1, math.min(2, kuluclukCita - yavruCita - 2));
  }

  static double _birakilacakBalMinKg(int kuluclukCita, String kovanTipi) {
    final double katsayi = kovanTipi == kovanTipiDadant ? 1.1 : 0.8;
    return math.max(2.5, kuluclukCita * katsayi);
  }

  static double _birakilacakBalMaxKg(int kuluclukCita, String kovanTipi) {
    final double katsayi = kovanTipi == kovanTipiDadant ? 1.5 : 1.1;
    return math.max(4.0, kuluclukCita * katsayi);
  }

  static List<String> _yerlesimDizilimi(int cita) {
    switch (cita) {
      case 0:
        return const <String>[];
      case 1:
        return const ['Yavru/stok'];
      case 2:
        return const ['Stok/polen', 'Yavru/stok'];
      case 3:
        return const ['Bal stoğu', 'Yavru', 'Bal/polen'];
      case 4:
        return const ['Bal stoğu', 'Polen/yavru', 'Yavru', 'Bal stoğu'];
      case 5:
        return const ['Bal stoğu', 'Polen', 'Yavru', 'Yavru/polen', 'Bal stoğu'];
      case 6:
        return const ['Bal stoğu', 'Polen', 'Yavru', 'Yavru', 'Polen/bal', 'Bal stoğu'];
      case 7:
        return const ['Bal stoğu', 'Polen', 'Yavru', 'Yavru', 'Yavru', 'Polen/bal', 'Bal stoğu'];
      case 8:
        return const ['Bal stoğu', 'Polen', 'Yavru', 'Yavru', 'Yavru', 'Yavru/polen', 'Bal stoğu', 'Bal stoğu'];
      case 9:
        return const ['Bal stoğu', 'Polen', 'Yavru', 'Yavru', 'Yavru', 'Yavru', 'Yavru/polen', 'Bal stoğu', 'Bal stoğu'];
      default:
        return const ['Bal stoğu', 'Polen/bal', 'Yavru', 'Yavru', 'Yavru', 'Yavru', 'Yavru/polen', 'Polen/bal', 'Bal stoğu', 'Bal stoğu'];
    }
  }

  static List<String> _yerlesimSatirlari(List<String> yerlesim) {
    return List<String>.generate(
      yerlesim.length,
      (i) => '${i + 1}. çıta: ${yerlesim[i]}',
    );
  }


  static Map<String, dynamic> _kovanYerlesimiOlustur({
    required List<String> yerlesim,
    required bool suruplukVarMi,
    required bool suruplukKaldirildiMi,
    required int kuluclukKapasitesi,
    required bool katAtildi,
    required int kuluclukCita,
    required int ballikCita,
    required String yavruBlok,
  }) {
    final List<int> tacPozisyonlari = _tacPozisyonlari(yavruBlok);

    Map<String, dynamic> citaMap({
      required String kat,
      required int no,
      required String tip,
      bool anaBolgesi = false,
    }) {
      return {
        'tur': 'cita',
        'kat': kat,
        'no': no,
        'tip': tip,
        'anaBolgesi': anaBolgesi,
      };
    }

    Map<String, dynamic> suruplukMap(String kat, int no) {
      return {
        'tur': 'surupluk',
        'kat': kat,
        'no': no,
        'tip': 'Şurupluk',
        'anaBolgesi': false,
      };
    }

    final altKat = <Map<String, dynamic>>[];
    final ustKat = <Map<String, dynamic>>[];

    if (!katAtildi) {
      if (suruplukVarMi && !suruplukKaldirildiMi) {
        altKat.add(suruplukMap('alt', 0));
      }
      for (int i = 0; i < yerlesim.length; i++) {
        final no = i + 1;
        altKat.add(citaMap(
          kat: 'alt',
          no: no,
          tip: yerlesim[i],
          anaBolgesi: tacPozisyonlari.contains(no),
        ));
      }
    } else {
      for (int no = 1; no <= 10; no++) {
        final tip = no <= yerlesim.length ? yerlesim[no - 1] : 'Kuluçkalık';
        altKat.add(citaMap(
          kat: 'alt',
          no: no,
          tip: tip,
          anaBolgesi: tacPozisyonlari.contains(no),
        ));
      }

      if (suruplukVarMi && !suruplukKaldirildiMi) {
        ustKat.add(suruplukMap('ust', 11));
        for (int i = 0; i < ballikCita; i++) {
          ustKat.add(citaMap(
            kat: 'ust',
            no: 11 + i,
            tip: 'Ballık / bal alanı',
          ));
        }
      } else {
        for (int i = 0; i < ballikCita; i++) {
          ustKat.add(citaMap(
            kat: 'ust',
            no: 11 + i,
            tip: 'Ballık / bal alanı',
          ));
        }
      }
    }

    final String suruplukKonumMetni;
    if (!suruplukVarMi) {
      suruplukKonumMetni = 'Koloni kaydında şurupluk işaretli değil.';
    } else if (suruplukKaldirildiMi) {
      suruplukKonumMetni = 'Şurupluk kaldırılmış; yerine petek düzeni devam ediyor.';
    } else if (katAtildi) {
      suruplukKonumMetni = 'Kat atıldığı için şurupluk üst katta en solda modellenir.';
    } else {
      suruplukKonumMetni = 'Kat öncesi şurupluk alt katta en solda modellenir.';
    }

    return {
      'altKatYerlesim': altKat,
      'ustKatYerlesim': ustKat,
      'tacPozisyonlari': tacPozisyonlari,
      'suruplukKonumMetni': suruplukKonumMetni,
      'not': 'Görsel yerleşim kesin fotoğraf değildir; son muayene verilerinden üretilmiş saha projeksiyonudur.',
    };
  }

  static List<int> _tacPozisyonlari(String yavruBlok) {
    final sayilar = RegExp(r'\d+').allMatches(yavruBlok).map((e) {
      return int.tryParse(e.group(0) ?? '') ?? 0;
    }).where((e) => e > 0).toList(growable: false);

    if (sayilar.isEmpty) return const <int>[];
    final int bas = sayilar.first;
    final int bit = sayilar.length >= 2 ? sayilar.last : sayilar.first;
    final int merkez = ((bas + bit) / 2).round();
    final sonuc = <int>{merkez};
    if (bit - bas >= 3) {
      sonuc.add((merkez - 1).clamp(bas, bit).toInt());
      sonuc.add((merkez + 1).clamp(bas, bit).toInt());
    }
    return sonuc.toList()..sort();
  }

  static String _yavruBlokAraligi(List<String> yerlesim) {
    final indeksler = <int>[];
    for (int i = 0; i < yerlesim.length; i++) {
      if (yerlesim[i].toLowerCase().contains('yavru')) indeksler.add(i + 1);
    }
    if (indeksler.isEmpty) return 'Belirsiz';
    if (indeksler.length == 1) return '${indeksler.first}. çıta';
    return '${indeksler.first}–${indeksler.last}. çıtalar';
  }

  static String _anaBolgesiMetni(int kuluclukCita, String yavruBlok) {
    if (kuluclukCita <= 0) return 'Belirsiz';
    if (yavruBlok != 'Belirsiz') return '$yavruBlok çevresi';
    if (kuluclukCita <= 3) return 'Merkez yavru çıtası';
    final int sol = (kuluclukCita / 2).floor();
    final int sag = math.min(kuluclukCita, sol + 1);
    return '$sol–$sag. çıtalar çevresi';
  }

  static String _gelisimAlaniMetni(List<String> yerlesim, int kapasite) {
    if (yerlesim.isEmpty) return 'Belirsiz';
    if (yerlesim.length >= kapasite) return 'Kuluçkalık dolu; yeni gelişim alanı kat/ballık yönetimiyle açılmalı.';
    final adaylar = <int>[];
    for (int i = 0; i < yerlesim.length; i++) {
      final s = yerlesim[i].toLowerCase();
      if (s.contains('polen') || s.contains('bal')) adaylar.add(i + 1);
    }
    if (adaylar.isEmpty) return 'Gelişim alanı merkez dışındaki boş/kabarmış petekle açılmalı.';
    return '${adaylar.join(', ')}. çıtaların dışından kontrollü genişletme yapılabilir.';
  }

  static List<int> _hasatAdayCitalari({
    required int kuluclukCita,
    required int kuluclukKapasitesi,
    required int ballikCita,
    required int balliCita,
  }) {
    if (balliCita <= 0 && ballikCita <= 0) return <int>[];

    // Katlı sistemde hasat önceliği ballıktır. Kuluçkalık koruma alanı kabul edilir.
    if (ballikCita > 0) {
      final int bas = kuluclukKapasitesi + 1;
      return List<int>.generate(ballikCita, (i) => bas + i);
    }

    // Kuluçkalıkta hasat ancak dış stok güvenliği varsa düşünülür.
    if (kuluclukCita <= 7) return <int>[];
    if (kuluclukCita == 8) return balliCita >= 1 ? <int>[8] : <int>[];
    if (kuluclukCita == 9) return balliCita >= 1 ? <int>[8, 9] : <int>[];
    return balliCita >= 1 ? <int>[9, 10] : <int>[];
  }

  static Map<String, String> _hasatGuvenligi({
    required int kuluclukCita,
    required int kuluclukKapasitesi,
    required int ballikCita,
    required int balliCita,
    required int hasatAdaySayisi,
  }) {
    if (kuluclukCita <= 0) {
      return const {
        'seviye': 'veri_yok',
        'mesaj': 'Hasat yorumu için çıta ve bal verisi gerekir.',
        'kural': 'Ölçüm yoksa hasat kararı üretme.',
      };
    }

    if (ballikCita > 0) {
      return {
        'seviye': hasatAdaySayisi > 0 ? 'ballik_oncelikli' : 'izle',
        'mesaj': 'Katlı sistemde hasat önceliği ballıktadır; kuluçkalık koruma alanı kabul edilir.',
        'kural': 'Ballık hasadı yalnızca sırlı, yavrusuz ve olgun çıtalarda düşünülür.',
      };
    }

    if (kuluclukCita <= 7) {
      return const {
        'seviye': 'onerilmez',
        'mesaj': '7 çıta ve altındaki kolonide hasat önerilmez; kuluçkalık güvenliği korunmalıdır.',
        'kural': 'Koloni hasatla 7 çıta altına düşürülmez.',
      };
    }

    if (kuluclukCita == 8) {
      return const {
        'seviye': 'sinirli',
        'mesaj': '8 çıtalı kolonide yalnızca dış stok çıtası sırlı ve yavrusuzsa sınırlı hasat düşünülebilir.',
        'kural': '8. çıta dış stok bölgesi değilse alınmaz.',
      };
    }

    if (kuluclukCita == 9) {
      return const {
        'seviye': 'kontrollu',
        'mesaj': '9 çıtalı kolonide 8–9. çıtalar dış stok bölgesi olarak kontrol edilebilir.',
        'kural': 'Yavru/polen alanı bozulmaz; yalnızca sırlı dış bal alınır.',
      };
    }

    return const {
      'seviye': 'uygun_kontrol',
      'mesaj': '10 çıtalı kuluçkalıkta 9–10. çıtalar dış stok bölgesi olarak kontrol edilebilir.',
      'kural': 'Kuluçkalık stok güvenliği ve yavru bloğu korunmadan hasat yapılmaz.',
    };
  }

  static String _hasatAdayMetni(List<int> adaylar) {
    if (adaylar.isEmpty) return '';
    final metin = adaylar.join(', ');
    return '$metin sayılı çıtalar yavrusuz ve sırlıysa hasat için değerlendirilebilir.';
  }

  static Map<String, dynamic> _demografiOlustur({
    required int tahminiAri,
    required int tahminiYavru,
    required int kuluclukCita,
    required int ballikCita,
    required double gunlukMomentum,
    required String momentumEtiketi,
    required String kaynakTipi,
  }) {
    // Temporal polyethism saha modeli:
    // 0–3 gün temizlik, 3–10 gün bakıcı, 10–16 gün petek örme/bal işleme,
    // 16–21 gün bekçilik/iç iş, 21+ gün tarlacı. Bu kesin sayım değil, karar katsayısıdır.
    double temizlikOran = 0.08;
    double bakiciOran = 0.24;
    double petekOrucuOran = 0.16;
    double icIsciOran = 0.12;
    double bekciOran = 0.06;
    double tarlaciOran = 0.29;
    double erkekOran = 0.05;

    if (gunlukMomentum >= 0.15 || momentumEtiketi.contains('Güçlü') || momentumEtiketi.contains('Patlayıcı')) {
      temizlikOran += 0.01;
      bakiciOran += 0.04;
      petekOrucuOran += 0.04;
      tarlaciOran -= 0.05;
      bekciOran -= 0.01;
    }
    if (ballikCita > 0 || kuluclukCita >= 8) {
      tarlaciOran += 0.04;
      icIsciOran += 0.02;
      bakiciOran -= 0.03;
      temizlikOran -= 0.01;
    }
    if (kaynakTipi.contains('oğul') || kaynakTipi.contains('ogul')) {
      petekOrucuOran += 0.03;
      bakiciOran += 0.02;
      tarlaciOran -= 0.03;
    }

    final toplamOran = temizlikOran + bakiciOran + petekOrucuOran + icIsciOran + bekciOran + tarlaciOran + erkekOran;
    temizlikOran /= toplamOran;
    bakiciOran /= toplamOran;
    petekOrucuOran /= toplamOran;
    icIsciOran /= toplamOran;
    bekciOran /= toplamOran;
    tarlaciOran /= toplamOran;
    erkekOran /= toplamOran;

    int adet(double oran) => (tahminiAri * oran).round();

    final int temizlikAri = adet(temizlikOran);
    final int bakiciAri = adet(bakiciOran);
    final int petekOrucuAri = adet(petekOrucuOran);
    final int icIsci = adet(icIsciOran);
    final int bekciAri = adet(bekciOran);
    final int tarlaciAri = adet(tarlaciOran);
    final int erkekAri = adet(erkekOran);
    final int gencIsciAri = temizlikAri + bakiciAri + petekOrucuAri;

    return {
      'toplamAri': tahminiAri,
      'isciAri': (tahminiAri * (1 - erkekOran)).round(),
      'erkekAri': erkekAri,
      'yavru': tahminiYavru,
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
      'gencIsciOran': _yuvarla((temizlikOran + bakiciOran + petekOrucuOran) * 100),
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
      'demografiNotu': 'Bu dağılım kesin sayım değil; çıta, yavru, sezon ve momentumdan üretilen saha projeksiyonudur.',
    };
  }

  static Map<String, dynamic> _kabiliyetOlustur({
    required Map<String, dynamic> demografi,
    required int kuluclukCita,
    required int ballikCita,
    required int balliCita,
    required double gunlukMomentum,
    required String momentumEtiketi,
    required String yavruDuzeni,
  }) {
    final int toplam = _toInt(demografi['toplamAri']);
    int scoreFrom(dynamic oran, double hedef) {
      final o = _toDouble(oran);
      return ((o / hedef) * 100).round().clamp(0, 100).toInt();
    }
    final petek = (scoreFrom(demografi['petekOrucuOran'], 18) + (scoreFrom(demografi['gencIsciOran'], 48) * 0.15).round() + (gunlukMomentum >= 0.12 ? 12 : 0) + (kuluclukCita >= 6 ? 6 : 0)).clamp(0, 100).toInt();
    final yavruBakim = (scoreFrom(demografi['bakiciOran'], 30) + (scoreFrom(demografi['gencIsciOran'], 48) * 0.10).round() + (yavruDuzeni.toLowerCase().contains('blok') ? 10 : 0)).clamp(0, 100).toInt();
    final nektar = (scoreFrom(demografi['tarlaciOran'], 40) + (ballikCita > 0 ? 10 : 0) + (toplam >= 16000 ? 8 : 0)).clamp(0, 100).toInt();
    final balIsleme = ((scoreFrom(demografi['icIsciOran'], 20) + nektar) / 2).round().clamp(0, 100).toInt();
    final kis = ((toplam / 18000) * 55 + (balliCita * 8) + (kuluclukCita >= 6 ? 15 : 0)).round().clamp(0, 100).toInt();
    final ciftlesme = (scoreFrom(demografi['erkekOran'], 5) + (kuluclukCita >= 7 ? 10 : 0)).clamp(0, 100).toInt();

    return {
      'petekOrmePuani': petek,
      'yavruBakimPuani': yavruBakim,
      'nektarToplamaPuani': nektar,
      'balIslemePuani': balIsleme,
      'kisDayanimPuani': kis,
      'ciftlesmeDestegiPuani': ciftlesme,
      'petekOrmeDurumu': _kapasiteDurumu(petek),
      'yavruBakimDurumu': _kapasiteDurumu(yavruBakim),
      'nektarToplamaDurumu': _kapasiteDurumu(nektar),
      'balIslemeDurumu': _kapasiteDurumu(balIsleme),
      'kisDayanimDurumu': _kapasiteDurumu(kis),
      'genisletmeGuvenligi': _genisletmeGuvenligi(
        petek: petek,
        yavru: yavruBakim,
        kuluclukCita: kuluclukCita,
        ballikCita: ballikCita,
      ),
      'balAkimiKapasitesi': _balAkimiKapasitesi(
        nektar: nektar,
        balIsleme: balIsleme,
        ballikCita: ballikCita,
      ),
      'bakiciDengesi': _bakiciDengesi(
        yavru: yavruBakim,
        petek: petek,
      ),
      'hamPetekOnerisi': _hamPetekOnerisi(petek, kuluclukCita),
      'beslemeOnerisi': _beslemeOnerisi(petek, yavruBakim, nektar, gunlukMomentum),
      'temelSahaOnerisi': _temelSahaOnerisi(
        petek: petek,
        yavru: yavruBakim,
        nektar: nektar,
        balIsleme: balIsleme,
        kis: kis,
        kuluclukCita: kuluclukCita,
        ballikCita: ballikCita,
      ),
      'ozet': _kabiliyetOzeti(petek, yavruBakim, nektar, balIsleme, kis),
    };
  }


  static String _kapasiteDurumu(int puan) {
    if (puan >= 75) return 'güçlü';
    if (puan >= 55) return 'orta';
    if (puan >= 40) return 'sınırlı';
    return 'zayıf';
  }

  static String _genisletmeGuvenligi({
    required int petek,
    required int yavru,
    required int kuluclukCita,
    required int ballikCita,
  }) {
    if (kuluclukCita < 5) {
      return 'genişletme erken; önce sıkı düzen ve yavru ısısı korunmalı';
    }
    if (petek >= 75 && yavru >= 60) {
      return ballikCita > 0
          ? 'ballık yönetimi sürdürülebilir; yavru bloğu kesilmeden alan verilebilir'
          : 'kontrollü genişletme güvenli görünüyor';
    }
    if (petek >= 55 && yavru >= 55) {
      return 'sınırlı genişletme yapılabilir; kabarmış petek ham petekten daha güvenli olabilir';
    }
    if (yavru >= 70 && petek < 55) {
      return 'yavru bakım baskısı var; ham petek yerine kabarmış petek tercih edilmeli';
    }
    return 'aşırı genişletme riskli; önce iş gücü ve stok dengesi izlenmeli';
  }

  static String _balAkimiKapasitesi({
    required int nektar,
    required int balIsleme,
    required int ballikCita,
  }) {
    if (nektar >= 75 && balIsleme >= 65) {
      return ballikCita > 0
          ? 'bal akımı güçlü değerlendirilebilir; ballıkta sırlanma takibi öne alınmalı'
          : 'nektar kapasitesi güçlü; sıkışma başlamadan kat hazırlığı izlenmeli';
    }
    if (nektar >= 55 && balIsleme >= 55) {
      return 'bal akımı sınırlı değerlendirilebilir; alan ve sırlanma birlikte izlenmeli';
    }
    return 'bal akımı kapasitesi sınırlı; üretimden önce koloni organizasyonu güçlenmeli';
  }

  static String _bakiciDengesi({
    required int yavru,
    required int petek,
  }) {
    if (yavru >= 75 && petek >= 60) {
      return 'bakıcı arı dengesi güçlü; yavru alanı korunarak büyütme yapılabilir';
    }
    if (yavru >= 70 && petek < 55) {
      return 'bakıcı kapasitesi var fakat petek örme sınırlı; kabarmış petek daha güvenli';
    }
    if (yavru < 50) {
      return 'bakıcı kapasitesi sınırlı; aşırı yavru yükü veya sert genişletme risklidir';
    }
    return 'bakıcı dengesi orta bantta; genişletme kontrollü yapılmalı';
  }

  static String _hamPetekOnerisi(int petekPuani, int kuluclukCita) {
    if (petekPuani >= 75 && kuluclukCita >= 5) {
      return 'Yeterli genç işçi kapasitesi görünüyor; ham petek verilecekse yavru bloğunun dışına verilebilir.';
    }
    if (petekPuani >= 55) {
      return 'Ham petek sınırlı verilebilir; kabarmış petek daha güvenli olur.';
    }
    return 'Ham petek için genç işçi kapasitesi sınırlı; önce kabarmış petek veya sıkı düzen daha güvenli.';
  }

  static String _beslemeOnerisi(int petek, int yavru, int nektar, double momentum) {
    if (nektar >= 75 && momentum >= 0.07) return 'Nektar toplama kapasitesi iyi; bal akımında gereksiz şurup vermekten kaçın.';
    if (yavru >= 70 && momentum >= 0.07) return 'Yavru bakım kapasitesi iyi; polen/stok zayıfsa destek besleme düşünülebilir.';
    if (petek >= 70) return 'Petek örme kapasitesi var; akım yoksa hafif destek büyümeyi koruyabilir.';
    return 'Besleme kararı stok, hava ve süreç durumuna göre kontrollü verilmelidir.';
  }

  static String _temelSahaOnerisi({
    required int petek,
    required int yavru,
    required int nektar,
    required int balIsleme,
    required int kis,
    required int kuluclukCita,
    required int ballikCita,
  }) {
    if (kis < 45) return 'Öncelik hasat değil stok güvenliği ve kış dayanımıdır.';
    if (kuluclukCita < 5 && yavru < 60) return 'Öncelik genişletme değil yavru alanını ve ısı düzenini korumaktır.';
    if (petek >= 75 && yavru >= 65 && kuluclukCita >= 5) return 'Ham petek verilebilir; yavru bloğu kesilmeden dıştan genişlet.';
    if (nektar >= 75 && balIsleme >= 65) return ballikCita > 0
        ? 'Bal akımı değerlendirilebilir; ballıkta sırlanma takibi yap.'
        : 'Nektar kapasitesi güçlü; sıkışma artarsa kat hazırlığını değerlendir.';
    if (yavru >= 75 && petek < 55) return 'Yavru bakım güçlü ama petek örme sınırlı; kabarmış petek ham petekten daha güvenli.';
    return 'Koloniyi kontrollü büyüt; karar için son muayene, stok ve süreç durumunu birlikte oku.';
  }

  static String _kabiliyetOzeti(int petek, int yavru, int nektar, int balIsleme, int kis) {
    final liste = <String>[];
    if (petek >= 70) liste.add('petek örme güçlü');
    if (yavru >= 70) liste.add('yavru bakımı güçlü');
    if (nektar >= 70) liste.add('nektar toplama güçlü');
    if (balIsleme >= 70) liste.add('bal işleme güçlü');
    if (kis < 50) liste.add('kış stok/dayanım dikkat ister');
    if (liste.isEmpty) return 'Kabiliyetler orta bantta; aşırı genişletme veya ağır işlem yerine kontrollü ilerle.';
    return liste.join(', ') + '.';
  }

  static List<String> _ilgincBilgiler({
    required int tahminiGozMin,
    required int tahminiGozMax,
    required int tahminiAriMin,
    required int tahminiAriMax,
    required int tahminiYavruGozMin,
    required int tahminiYavruGozMax,
    required double hasatMin,
    required double hasatMax,
  }) {
    return <String>[
      'Bu kolonide tahmini $tahminiGozMin–$tahminiGozMax petek gözü kapasitesi bulunur.',
      'Tahmini arı nüfusu $tahminiAriMin–$tahminiAriMax aralığındadır.',
      'Yavru alanı tahmini $tahminiYavruGozMin–$tahminiYavruGozMax göz kapasitesindedir.',
      if (hasatMax > 0) 'Sırlı ve yavrusuz çıtalar uygunsa tahmini hasat potansiyeli ${_yuvarla(hasatMin)}–${_yuvarla(hasatMax)} kg bandındadır.',
      'Bu veriler kesin sayım değil; standart biyolojik koloni modeliyle üretilen saha projeksiyonudur.',
    ];
  }

  static String _yorumUret({
    required int toplamCita,
    required int kuluclukCita,
    required int ballikCita,
    required int kuluclukKapasitesi,
    required int balliCita,
    required double hasatPotansiyeliMaxKg,
    required Map<String, dynamic> kabiliyet,
    required String yavruBlok,
  }) {
    if (toplamCita <= 0) {
      return 'Model için çıta verisi yok. İlk muayene sonrası tahmini biyolojik düzen okunabilir.';
    }
    if (ballikCita > 0) {
      return 'Alt kuluçkalık $kuluclukKapasitesi çıta kabul edildi. Üstteki $ballikCita çıta ballık/kat alanı olarak yorumlandı. Merkez yavru bloğu ($yavruBlok) korunmalı.';
    }
    if (kuluclukCita <= 4) {
      return 'Küçük koloni. Merkez yavru bloğu ve ısı düzeni korunmalı; gereksiz hacim bırakılmamalı.';
    }
    if (kuluclukCita < kuluclukKapasitesi) {
      return '${kabiliyet['hamPetekOnerisi']} Merkez yavru bloğu ($yavruBlok) korunmalı.';
    }
    return 'Kuluçkalık dolu kabul edilir. Kat, sıkışıklık ve oğul baskısı birlikte izlenmeli. ${kabiliyet['ozet']}';
  }

  static bool _toBool(dynamic deger) {
    if (deger == true) return true;
    if (deger is int) return deger == 1;
    final s = (deger ?? '').toString().trim().toLowerCase();
    return s == '1' || s == 'true' || s == 'evet' || s == 'var';
  }

  static int _pozitifInt(dynamic deger) {
    final v = _toInt(deger);
    return v < 0 ? 0 : v;
  }

  static int _toInt(dynamic deger) {
    if (deger == null) return 0;
    if (deger is int) return deger;
    if (deger is double) return deger.round();
    return int.tryParse(deger.toString()) ?? 0;
  }

  static double _toDouble(dynamic deger) {
    if (deger == null) return 0.0;
    if (deger is num) return deger.toDouble();
    return double.tryParse(deger.toString()) ?? 0.0;
  }

  static double _yuvarla(double v) => double.parse(v.toStringAsFixed(1));
}
