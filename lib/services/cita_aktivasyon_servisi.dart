import 'dart:math' as math;

class CitaAktivasyonServisi {
  static const String petekTipiTemel = 'Temel petek';
  static const String petekTipiKabarmis = 'Kabarmış petek';
  static const String petekTipiKarisik = 'Karışık petek';
  static const String petekTipiBalli = 'Ballı/stoklu petek';
  static const String petekTipiYavrulu = 'Yavrulu destek çıtası';

  static Map<String, dynamic> hesapla({
    required Map<String, dynamic>? sonMuayene,
    required Map<String, dynamic>? oncekiMuayene,
    Map<String, dynamic>? trend,
    Map<String, dynamic>? suruplukPenceresi,
  }) {
    final int fizikselCita = _pozitifInt(sonMuayene?['citaSayisi']);
    final int oncekiCita = _pozitifInt(oncekiMuayene?['citaSayisi']);
    final int yavruluCita = _pozitifInt(sonMuayene?['yavruluCita']);
    final int balCita = _pozitifInt(sonMuayene?['bal_cita']);
    final String yavruDuzeni =
        (sonMuayene?['yavruDuzeni'] ?? '').toString().trim();
    final int kayitliTemelPetek = _pozitifInt(sonMuayene?['eklenenTemelPetek']);
    final int kayitliKabarmisPetek =
        _pozitifInt(sonMuayene?['eklenenKabarmisPetek']);
    final String petekTipi =
        _petekTipiNormalize(sonMuayene?['eklenenPetekTipi']);
    final DateTime? sonTarih = _tarihParse(sonMuayene?['tarih']);
    final DateTime? oncekiTarih = _tarihParse(oncekiMuayene?['tarih']);

    if (fizikselCita <= 0) {
      return _sonuc(
        fizikselCita: fizikselCita,
        oncekiCita: oncekiCita,
        eklenenCita: 0,
        gecenGun: 0,
        aktivasyonSuresiGun: 0,
        aktivasyonOrani: 1.0,
        islevselCitaMin: 0,
        islevselCitaMax: 0,
        petekTipi: petekTipi,
        aniArtisVar: false,
        katGecisiVar: false,
        uyariSeviyesi: 'yok',
        mesaj: 'Çıta verisi yok.',
      );
    }

    if (oncekiCita <= 0 || oncekiMuayene == null) {
      return _sonuc(
        fizikselCita: fizikselCita,
        oncekiCita: oncekiCita,
        eklenenCita: 0,
        gecenGun: 0,
        aktivasyonSuresiGun: 0,
        aktivasyonOrani: 1.0,
        islevselCitaMin: fizikselCita.toDouble(),
        islevselCitaMax: fizikselCita.toDouble(),
        petekTipi: petekTipi,
        aniArtisVar: false,
        katGecisiVar: fizikselCita >= 11,
        uyariSeviyesi: 'yok',
        mesaj:
            'İlk/başlangıç kaydı sıkışık düzen kabulüyle mevcut kapasite olarak okunur.',
      );
    }

    final int eklenenCita = math.max(0, fizikselCita - oncekiCita);
    final _PetekDagilimi petekDagilimi = _petekDagilimiOlustur(
      eklenenCita: eklenenCita,
      kayitliTemel: kayitliTemelPetek,
      kayitliKabarmis: kayitliKabarmisPetek,
      fallbackTip: petekTipi,
    );
    if (eklenenCita <= 0) {
      return _sonuc(
        fizikselCita: fizikselCita,
        oncekiCita: oncekiCita,
        eklenenCita: 0,
        gecenGun: _gunFarki(oncekiTarih, sonTarih),
        aktivasyonSuresiGun: 0,
        aktivasyonOrani: 1.0,
        islevselCitaMin: fizikselCita.toDouble(),
        islevselCitaMax: fizikselCita.toDouble(),
        petekTipi: petekTipi,
        aniArtisVar: false,
        katGecisiVar: fizikselCita >= 11,
        uyariSeviyesi: 'yok',
        mesaj: 'Yeni hacim artışı yok; mevcut çıta sayısı doğrudan okunur.',
      );
    }

    final int gecenGun = math.max(0, _gunFarki(oncekiTarih, sonTarih));
    final bool katGecisiVar = oncekiCita >= 9 && fizikselCita >= 11;
    final bool aniArtisVar = eklenenCita >= 3 && !katGecisiVar;
    final int aktivasyonSuresi = _aktivasyonSuresiGun(
      petekTipi: petekDagilimi.ozetTip,
      temelPetekAdedi: petekDagilimi.temel,
      kabarmisPetekAdedi: petekDagilimi.kabarmis,
      oncekiCita: oncekiCita,
      fizikselCita: fizikselCita,
      eklenenCita: eklenenCita,
      yavruluCita: yavruluCita,
      balCita: balCita,
      yavruDuzeni: yavruDuzeni,
      trend: trend,
      suruplukPenceresi: suruplukPenceresi,
      katGecisiVar: katGecisiVar,
      aniArtisVar: aniArtisVar,
    );

    final double oran = aktivasyonSuresi <= 0
        ? 1.0
        : (gecenGun / aktivasyonSuresi).clamp(0.0, 1.0).toDouble();
    final double belirsizlik = eklenenCita >= 3 ? 0.12 : 0.08;
    final double oranMin = (oran - belirsizlik).clamp(0.0, 1.0).toDouble();
    final double oranMax = (oran + belirsizlik).clamp(0.0, 1.0).toDouble();
    final double islevselMin = math.min(
      fizikselCita.toDouble(),
      oncekiCita + eklenenCita * oranMin,
    );
    final double islevselMax = math.min(
      fizikselCita.toDouble(),
      oncekiCita + eklenenCita * oranMax,
    );

    final String uyariSeviyesi =
        aniArtisVar ? 'kritik' : (eklenenCita >= 2 ? 'uyari' : 'not');

    final String mesaj;
    if (aniArtisVar) {
      mesaj =
          'Son muayeneye göre $eklenenCita çıta artış var. Bu artış kat geçişi dışında yüksek kabul edilir; sistem yeni hacmin tamamını hemen işlevsel saymaz.';
    } else if (katGecisiVar) {
      mesaj =
          'Koloni 9–10 çıta eşiğinden 11+ çıtaya çıktığı için kat/ballık geçişi kabul edildi. Yeni üst hacim kademeli aktive edilir.';
    } else if (eklenenCita >= 2) {
      mesaj =
          'Son muayeneye göre 2 çıta artış var. Muayene aralığı ve koloni gücü dikkate alınarak kontrollü genişleme kabul edilir.';
    } else {
      mesaj =
          'Yeni verilen çıta kademeli olarak işlevsel kapasiteye dahil edilir.';
    }

    return _sonuc(
      fizikselCita: fizikselCita,
      oncekiCita: oncekiCita,
      eklenenCita: eklenenCita,
      gecenGun: gecenGun,
      aktivasyonSuresiGun: aktivasyonSuresi,
      aktivasyonOrani: oran,
      islevselCitaMin: islevselMin,
      islevselCitaMax: islevselMax,
      petekTipi: petekDagilimi.ozetTip,
      temelPetekAdedi: petekDagilimi.temel,
      kabarmisPetekAdedi: petekDagilimi.kabarmis,
      aniArtisVar: aniArtisVar,
      katGecisiVar: katGecisiVar,
      uyariSeviyesi: uyariSeviyesi,
      mesaj: mesaj,
    );
  }

  static int _aktivasyonSuresiGun({
    required String petekTipi,
    required int temelPetekAdedi,
    required int kabarmisPetekAdedi,
    required int oncekiCita,
    required int fizikselCita,
    required int eklenenCita,
    required int yavruluCita,
    required int balCita,
    required String yavruDuzeni,
    required Map<String, dynamic>? trend,
    required Map<String, dynamic>? suruplukPenceresi,
    required bool katGecisiVar,
    required bool aniArtisVar,
  }) {
    int gun;
    final int toplamPetek = temelPetekAdedi + kabarmisPetekAdedi;
    if (toplamPetek > 0) {
      final int toplamGun = (temelPetekAdedi * 24) + (kabarmisPetekAdedi * 9);
      gun = (toplamGun / toplamPetek).round();
    } else {
      switch (petekTipi) {
        case petekTipiKabarmis:
          gun = 9;
          break;
        case petekTipiBalli:
          gun = 4;
          break;
        case petekTipiYavrulu:
          gun = 3;
          break;
        case petekTipiTemel:
        default:
          gun = 24;
          break;
      }
    }

    final String duzen = yavruDuzeni.toLowerCase();
    final double momentum = _toDouble(trend?['gunlukMomentum']);
    final String momentumEtiketi =
        (trend?['momentumEtiketi'] ?? '').toString().toLowerCase();
    final bool balAkimiPenceresi = suruplukPenceresi?['aktif'] == true;

    if (oncekiCita >= 8) gun -= 2;
    if (yavruluCita >= 5) gun -= 2;
    if (duzen.contains('blok')) gun -= 2;
    if (duzen.contains('normal')) gun -= 1;
    if (balAkimiPenceresi || balCita > 0) gun -= 2;
    if (momentum > 0.08 ||
        momentumEtiketi.contains('güç') ||
        momentumEtiketi.contains('iyi')) gun -= 2;
    if (katGecisiVar) gun += 2;
    if (aniArtisVar) gun += 5;
    if (eklenenCita >= 5) gun += 3;
    if (duzen.contains('dağınık') ||
        duzen.contains('daginik') ||
        duzen.contains('kambur')) gun += 4;
    if (oncekiCita <= 5 && eklenenCita >= 2) gun += 3;

    return gun.clamp(3, 32).toInt();
  }

  static Map<String, dynamic> _sonuc({
    required int fizikselCita,
    required int oncekiCita,
    required int eklenenCita,
    required int gecenGun,
    required int aktivasyonSuresiGun,
    required double aktivasyonOrani,
    required double islevselCitaMin,
    required double islevselCitaMax,
    required String petekTipi,
    int temelPetekAdedi = 0,
    int kabarmisPetekAdedi = 0,
    required bool aniArtisVar,
    required bool katGecisiVar,
    required String uyariSeviyesi,
    required String mesaj,
  }) {
    final double orta = ((islevselCitaMin + islevselCitaMax) / 2)
        .clamp(0.0, fizikselCita.toDouble())
        .toDouble();
    final String ozet;
    if (eklenenCita <= 0) {
      ozet = mesaj;
    } else {
      ozet =
          '$fizikselCita çıta fiziksel olarak kayıtlı. Yeni eklenen $eklenenCita çıtanın aktivasyonu $petekTipi kabulüyle yaklaşık $aktivasyonSuresiGun gün içinde tamamlanır. Bugünkü işlevsel kapasite yaklaşık ${_fmt(islevselCitaMin)}–${_fmt(islevselCitaMax)} çıta aralığında okunur.';
    }

    return {
      'fizikselCita': fizikselCita,
      'oncekiCita': oncekiCita,
      'eklenenCita': eklenenCita,
      'gecenGun': gecenGun,
      'aktivasyonSuresiGun': aktivasyonSuresiGun,
      'aktivasyonOrani': aktivasyonOrani,
      'islevselCitaMin': double.parse(islevselCitaMin.toStringAsFixed(1)),
      'islevselCitaMax': double.parse(islevselCitaMax.toStringAsFixed(1)),
      'islevselCitaOrta': double.parse(orta.toStringAsFixed(1)),
      'petekTipi': petekTipi,
      'temelPetekAdedi': temelPetekAdedi,
      'kabarmisPetekAdedi': kabarmisPetekAdedi,
      'aniArtisVar': aniArtisVar,
      'katGecisiVar': katGecisiVar,
      'uyariSeviyesi': uyariSeviyesi,
      'mesaj': mesaj,
      'ozet': ozet,
    };
  }

  static _PetekDagilimi _petekDagilimiOlustur({
    required int eklenenCita,
    required int kayitliTemel,
    required int kayitliKabarmis,
    required String fallbackTip,
  }) {
    if (eklenenCita <= 0) {
      return const _PetekDagilimi(
          temel: 0, kabarmis: 0, ozetTip: petekTipiTemel);
    }

    int temel = kayitliTemel.clamp(0, eklenenCita).toInt();
    int kabarmis = kayitliKabarmis.clamp(0, eklenenCita).toInt();
    final int toplam = temel + kabarmis;

    if (toplam == 0) {
      if (fallbackTip == petekTipiKabarmis) {
        kabarmis = eklenenCita;
      } else {
        temel = eklenenCita;
      }
    } else if (toplam < eklenenCita) {
      temel += eklenenCita - toplam;
    } else if (toplam > eklenenCita) {
      // Toplam fazla girildiyse önce temel petekten düşülür.
      // Arıcı kabarmış peteği özellikle işaretlediyse bu bilgi aktivasyon süresi için daha değerlidir.
      int fazla = toplam - eklenenCita;
      final int temelAzalt = math.min(fazla, temel);
      temel -= temelAzalt;
      fazla -= temelAzalt;
      if (fazla > 0) kabarmis = math.max(0, kabarmis - fazla);
    }

    final String ozetTip;
    if (temel > 0 && kabarmis > 0) {
      ozetTip = petekTipiKarisik;
    } else if (kabarmis > 0) {
      ozetTip = petekTipiKabarmis;
    } else {
      ozetTip = petekTipiTemel;
    }

    return _PetekDagilimi(temel: temel, kabarmis: kabarmis, ozetTip: ozetTip);
  }

  static String _petekTipiNormalize(dynamic deger) {
    final temiz = (deger ?? '').toString().trim().toLowerCase();
    if (temiz.contains('kabar')) return petekTipiKabarmis;
    if (temiz.contains('ball') || temiz.contains('stok')) return petekTipiBalli;
    if (temiz.contains('yavru')) return petekTipiYavrulu;
    return petekTipiTemel;
  }

  static int _gunFarki(DateTime? onceki, DateTime? son) {
    if (onceki == null || son == null) return 0;
    return son.difference(onceki).inDays.abs();
  }

  static DateTime? _tarihParse(dynamic deger) {
    final metin = (deger ?? '').toString().trim();
    if (metin.isEmpty) return null;
    final dt = DateTime.tryParse(metin);
    if (dt == null) return null;
    return DateTime(dt.year, dt.month, dt.day);
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
    if (deger is double) return deger;
    if (deger is int) return deger.toDouble();
    return double.tryParse(deger.toString()) ?? 0.0;
  }

  static String _fmt(double v) {
    if ((v - v.round()).abs() < 0.05) return v.round().toString();
    return v.toStringAsFixed(1);
  }
}

class _PetekDagilimi {
  final int temel;
  final int kabarmis;
  final String ozetTip;

  const _PetekDagilimi({
    required this.temel,
    required this.kabarmis,
    required this.ozetTip,
  });
}
