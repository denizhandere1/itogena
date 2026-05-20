class IsGucuMotoru {
  static Map<String, dynamic> hesapla({
    required Map<String, dynamic> demografi,
    required int kuluclukCita,
    required int ballikCita,
    required int balliCita,
    required double aktivasyonOrani,
    required bool balAkimiAktif,
    required Map<String, dynamic> sezonBiyoloji,
    required bool yavruYokMu,
  }) {
    final int gencIsci =
        (demografi['gencIsci'] ?? 0) as int;

    final int bakiciAri =
        (demografi['bakiciAri'] ?? 0) as int;

    final int tarlaci =
        (demografi['tarlaci'] ?? 0) as int;

    final int icIsci =
        (demografi['icIsci'] ?? 0) as int;

    final int bekci =
        (demografi['bekci'] ?? 0) as int;

    final double sezonKatsayisi =
        ((sezonBiyoloji['aktivasyonKatsayisi'] ?? 1.0) as num)
            .toDouble();

    final double petekOrme =
        ((gencIsci * 0.45) +
                    (icIsci * 0.15)) *
                aktivasyonOrani *
                sezonKatsayisi /
            1000;

    final double yavruBakim =
        ((bakiciAri * 0.55) +
                    (gencIsci * 0.10)) *
                sezonKatsayisi /
            1000;

    final double nektarToplama =
        ((tarlaci * 0.60) +
                    (bekci * 0.05)) *
                (balAkimiAktif ? 1.25 : 0.80) /
            1000;

    final double balIsleme =
        ((icIsci * 0.35) +
                    (tarlaci * 0.20)) *
                aktivasyonOrani /
            1000;

    final double savunma =
        ((bekci * 0.50) +
                    (tarlaci * 0.10)) /
            1000;

    final double toparlanma =
        ((gencIsci * 0.30) +
                    (bakiciAri * 0.20)) *
                (yavruYokMu ? 0.55 : 1.0) /
            1000;

    final double kisDayanimi =
        ((balliCita * 0.35) +
                    (icIsci * 0.15) +
                    (bekci * 0.10)) /
            10;

    final double ciftlesmeDestegi =
        ((tarlaci * 0.20) +
                    (bekci * 0.05)) /
            1000;

    return {
      'petekOrmeKapasitesi':
          _siniflandir(petekOrme),

      'yavruBakimKapasitesi':
          _siniflandir(yavruBakim),

      'nektarToplamaKapasitesi':
          _siniflandir(nektarToplama),

      'balIslemeKapasitesi':
          _siniflandir(balIsleme),

      'savunmaKapasitesi':
          _siniflandir(savunma),

      'toparlanmaKapasitesi':
          _siniflandir(toparlanma),

      'kisDayanimi':
          _siniflandir(kisDayanimi),

      'ciftlesmeDestegi':
          _siniflandir(ciftlesmeDestegi),

      'hamSkorlar': {
        'petekOrme': petekOrme,
        'yavruBakim': yavruBakim,
        'nektarToplama': nektarToplama,
        'balIsleme': balIsleme,
        'savunma': savunma,
        'toparlanma': toparlanma,
        'kisDayanimi': kisDayanimi,
        'ciftlesmeDestegi': ciftlesmeDestegi,
      }
    };
  }

  static String _siniflandir(double skor) {
    if (skor >= 8) return 'çok güçlü';
    if (skor >= 5) return 'güçlü';
    if (skor >= 3) return 'orta';
    if (skor >= 1.5) return 'zayıf';
    return 'kritik';
  }
}
