import 'veritabani_servisi.dart';

class EkonomikDegerOzeti {
  final int aktifKovanSayisi;
  final int toplamAriliCita;

  const EkonomikDegerOzeti({
    required this.aktifKovanSayisi,
    required this.toplamAriliCita,
  });
}

class EkonomikDegerServisi {
  static Future<EkonomikDegerOzeti> ozetGetir() async {
    final koloniler = await VeritabaniServisi.kolonileriGetir(
      sadeceAktifler: false,
    );

    final koloniIdleri = koloniler
        .map((k) => _toInt(k['id']))
        .where((id) => id > 0)
        .toList(growable: false);
    final aktiflikHaritasi =
    await VeritabaniServisi.koloniAktiflikHaritasiGetir(koloniIdleri);

    int aktifKovan = 0;
    int toplamAriliCita = 0;

    for (final koloni in koloniler) {
      final koloniId = _toInt(koloni['id']);
      if (koloniId <= 0) continue;
      if (aktiflikHaritasi[koloniId] != true) continue;

      aktifKovan++;
      toplamAriliCita += _toInt(koloni['sonCita']);
    }

    return EkonomikDegerOzeti(
      aktifKovanSayisi: aktifKovan,
      toplamAriliCita: toplamAriliCita,
    );
  }


  static int _toInt(dynamic deger) {
    if (deger == null) return 0;
    if (deger is int) return deger;
    if (deger is double) return deger.round();
    return int.tryParse(deger.toString()) ?? 0;
  }
}