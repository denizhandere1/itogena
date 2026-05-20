class ProjeksiyonMotoru {
  static Map<String, dynamic> hesapla({
    required Map<String, dynamic> demografi,
    required Map<String, dynamic> kabiliyet,
    required Map<String, dynamic> riskAnalizi,
    required Map<String, dynamic> sezonBiyoloji,
    required Map<String, dynamic> citaAktivasyon,
    required bool balAkimiAktif,
    required bool yavruYokMu,
    required int toplamCita,
    required int balliCita,
    required int tahminiYavruCita,
    required int tahminiStokCita,
    required double aktivasyonOrani,
    required double gunlukMomentum,
    required String momentumEtiketi,
  }) {
    final int riskPuani =
        (riskAnalizi['genelRiskPuani'] ?? 0) as int;

    final int toparlanmaPuani =
        _toInt(kabiliyet['toparlanmaPuani']);

    final int uretimPuani =
        _toInt(kabiliyet['balIslemePuani']);

    final int petekPuani =
        _toInt(kabiliyet['petekOrmePuani']);

    final int yavruBakimPuani =
        _toInt(kabiliyet['yavruBakimPuani']);

    final String sezonKod =
        (sezonBiyoloji['kod'] ?? '').toString();

    final bool riskliSisirme =
        citaAktivasyon['riskliSisirme'] == true;

    final bool alanBaskisi =
        aktivasyonOrani < 0.55 && toplamCita >= 8;

    final String gelisimYonu =
        _gelisimYonu(
          momentum: gunlukMomentum,
          risk: riskPuani,
          yavruYokMu: yavruYokMu,
        );

    final String toparlanmaYonu =
        _toparlanmaYonu(
          toparlanmaPuani: toparlanmaPuani,
          risk: riskPuani,
        );

    final String uretimYonu =
        _uretimYonu(
          balAkimiAktif: balAkimiAktif,
          uretimPuani: uretimPuani,
          balliCita: balliCita,
          risk: riskPuani,
        );

    final String yaslanmaYonu =
        _yaslanmaYonu(
          yavruYokMu: yavruYokMu,
          yavruBakimPuani: yavruBakimPuani,
          momentum: gunlukMomentum,
        );

    final String kisYonu =
        _kisYonu(
          sezonKod: sezonKod,
          stok: tahminiStokCita,
          risk: riskPuani,
        );

    final String alanYonu =
        _alanYonu(
          alanBaskisi: alanBaskisi,
          riskliSisirme: riskliSisirme,
          petekPuani: petekPuani,
        );

    return {
      'gelisimYonu': gelisimYonu,
      'toparlanmaYonu': toparlanmaYonu,
      'uretimYonu': uretimYonu,
      'yaslanmaYonu': yaslanmaYonu,
      'kisYonu': kisYonu,
      'alanYonu': alanYonu,
      'projeksiyonOzeti': _ozet(
        gelisimYonu: gelisimYonu,
        toparlanmaYonu: toparlanmaYonu,
        uretimYonu: uretimYonu,
        yaslanmaYonu: yaslanmaYonu,
      ),
      'not':
          'Projeksiyon motoru kesin gelecek tahmini yapmaz; biyolojik yön ve eğilim üretir.',
    };
  }

  static String _gelisimYonu({
    required double momentum,
    required int risk,
    required bool yavruYokMu,
  }) {
    if (yavruYokMu && risk >= 70) {
      return 'gelişim baskılanıyor';
    }

    if (momentum >= 0.08 && risk < 45) {
      return 'gelişim hızlanıyor';
    }

    if (momentum >= 0.02) {
      return 'gelişim sürüyor';
    }

    if (momentum <= -0.04) {
      return 'gelişim geriliyor';
    }

    return 'gelişim dengeli';
  }

  static String _toparlanmaYonu({
    required int toparlanmaPuani,
    required int risk,
  }) {
    if (toparlanmaPuani >= 70 && risk < 45) {
      return 'toparlanma güçlü';
    }

    if (toparlanmaPuani >= 50) {
      return 'toparlanma mümkün';
    }

    if (toparlanmaPuani <= 30) {
      return 'toparlanma zayıf';
    }

    return 'toparlanma sınırlı';
  }

  static String _uretimYonu({
    required bool balAkimiAktif,
    required int uretimPuani,
    required int balliCita,
    required int risk,
  }) {
    if (balAkimiAktif &&
        uretimPuani >= 70 &&
        balliCita >= 3 &&
        risk < 45) {
      return 'üretim yönü güçlü';
    }

    if (balAkimiAktif && uretimPuani >= 45) {
      return 'üretim sürüyor';
    }

    if (!balAkimiAktif && risk >= 70) {
      return 'üretim baskılanıyor';
    }

    return 'üretim dengeli';
  }

  static String _yaslanmaYonu({
    required bool yavruYokMu,
    required int yavruBakimPuani,
    required double momentum,
  }) {
    if (yavruYokMu && yavruBakimPuani <= 35) {
      return 'yaşlanma baskısı artıyor';
    }

    if (momentum < -0.03) {
      return 'nüfus desteği yavaşlıyor';
    }

    return 'yaş dengesi korunuyor';
  }

  static String _kisYonu({
    required String sezonKod,
    required int stok,
    required int risk,
  }) {
    final bool kisDonemi =
        sezonKod.contains('kis') ||
        sezonKod.contains('sonbahar');

    if (!kisDonemi) {
      return 'kış baskısı düşük';
    }

    if (stok <= 1 || risk >= 70) {
      return 'kış güvenliği zayıf';
    }

    if (stok >= 3 && risk < 45) {
      return 'kış güvenliği güçlü';
    }

    return 'kış hazırlığı izlenmeli';
  }

  static String _alanYonu({
    required bool alanBaskisi,
    required bool riskliSisirme,
    required int petekPuani,
  }) {
    if (riskliSisirme) {
      return 'hacim genişlemesi riskli';
    }

    if (alanBaskisi && petekPuani < 45) {
      return 'alan baskısı artıyor';
    }

    if (petekPuani >= 70) {
      return 'hacim yönetimi güçlü';
    }

    return 'alan dengesi korunuyor';
  }

  static String _ozet({
    required String gelisimYonu,
    required String toparlanmaYonu,
    required String uretimYonu,
    required String yaslanmaYonu,
  }) {
    return '$gelisimYonu, $toparlanmaYonu, $uretimYonu. $yaslanmaYonu.';
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }
}
