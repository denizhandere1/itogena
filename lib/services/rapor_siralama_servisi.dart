import 'veritabani_servisi.dart';
import 'karar_asistan_servisi.dart';
import 'koloni_karar_motoru.dart';

class RaporListeKaydi {
  final Map<String, dynamic> koloni;
  final int sira;
  final int genelSkor;
  final int sonCita;
  final int uremeHam;
  final int uretimHam;
  final bool donorMu;
  final int donorSirasi;
  final bool vetoVarMi;
  final String durumMetni;
  final String durumKodu;

  const RaporListeKaydi({
    required this.koloni,
    required this.sira,
    required this.genelSkor,
    required this.sonCita,
    required this.uremeHam,
    required this.uretimHam,
    required this.donorMu,
    required this.donorSirasi,
    required this.vetoVarMi,
    required this.durumMetni,
    required this.durumKodu,
  });
}

class _RaporHamKaydi {
  final Map<String, dynamic> koloni;
  final int genelSkor;
  final int sonCita;
  final int uremeHam;
  final int uretimHam;
  final bool donorMu;
  final int donorSirasi;
  final bool vetoVarMi;
  final String durumMetni;
  final String durumKodu;

  const _RaporHamKaydi({
    required this.koloni,
    required this.genelSkor,
    required this.sonCita,
    required this.uremeHam,
    required this.uretimHam,
    required this.donorMu,
    required this.donorSirasi,
    required this.vetoVarMi,
    required this.durumMetni,
    required this.durumKodu,
  });
}

class RaporSiralamaServisi {
  static const String tipGucludenZayifa = 'gucluden_zayifa';
  static const String tipZayiftanGucluye = 'zayiftan_gucluye';
  static const String tipDonorAdaylari = 'donor_adaylari';
  static const String tipGenetikVeto = 'genetik_veto';

  static Future<List<RaporListeKaydi>> listeGetir(
      String raporTipi, {
        required int arilikId,
      }) async {
    final tumKoloniler = await VeritabaniServisi.kovanlariAriligaGoreGetir(
      arilikId,
    );

    if (tumKoloniler.isEmpty) {
      return const <RaporListeKaydi>[];
    }

    final koloniIdleri = tumKoloniler
        .map((k) => _toInt(k['id']))
        .where((id) => id > 0)
        .toList(growable: false);

    final aktiflikHaritasi =
    await VeritabaniServisi.koloniAktiflikHaritasiGetir(koloniIdleri);

    final aktifKoloniler = tumKoloniler.where((koloni) {
      final koloniId = _toInt(koloni['id']);
      return koloniId > 0 && aktiflikHaritasi[koloniId] == true;
    }).toList(growable: false);

    if (aktifKoloniler.isEmpty) {
      return const <RaporListeKaydi>[];
    }

    final donorler = await KararAsistanServisi.donorAdaylariSiraliGetir(
      arilikId: arilikId,
    );
    final donorMap = <int, int>{
      for (final d in donorler)
        _toInt(d['koloniId']): _toInt(d['sira']),
    };

    final hamKayitlar = await Future.wait(
      aktifKoloniler.map((koloni) async {
        final koloniId = _toInt(koloni['id']);
        final donorSirasi = donorMap[koloniId] ?? 0;
        final donorMu = donorSirasi > 0;

        final karar = await KoloniKararMotoru.kararUret(
          koloniId,
          koloni,
          siraliDonorler: donorler,
        );

        final profil = karar.profil;
        final int genelSkor = _toInt(profil['skor']);
        final int sonCita = _toInt(
          profil['islevselToplamCita'] ?? profil['sonCita'],
        );
        final int uremeHam = _toInt(profil['uremePuani']);
        final int uretimHam = _toInt(profil['uretimPuani']);
        final bool vetoVarMi = karar.donorVeto;

        return _RaporHamKaydi(
          koloni: koloni,
          genelSkor: genelSkor,
          sonCita: sonCita,
          uremeHam: uremeHam,
          uretimHam: uretimHam,
          donorMu: donorMu,
          donorSirasi: donorSirasi,
          vetoVarMi: vetoVarMi,
          durumMetni: _durumMetniOlustur(
            sonCita: sonCita,
            donorMu: donorMu,
            donorSirasi: donorSirasi,
            vetoVarMi: vetoVarMi,
          ),
          durumKodu: _durumKoduOlustur(
            sonCita: sonCita,
            donorMu: donorMu,
            vetoVarMi: vetoVarMi,
          ),
        );
      }),
    );

    final filtreli = hamKayitlar.where((k) {
      switch (raporTipi) {
        case tipDonorAdaylari:
          return k.donorMu;
        case tipGenetikVeto:
          return k.vetoVarMi;
        case tipGucludenZayifa:
        case tipZayiftanGucluye:
        default:
          return true;
      }
    }).toList();

    filtreli.sort((a, b) => _sirala(a, b, raporTipi));

    final sonuc = <RaporListeKaydi>[];
    for (int i = 0; i < filtreli.length; i++) {
      final k = filtreli[i];
      sonuc.add(
        RaporListeKaydi(
          koloni: k.koloni,
          sira: i + 1,
          genelSkor: k.genelSkor,
          sonCita: k.sonCita,
          uremeHam: k.uremeHam,
          uretimHam: k.uretimHam,
          donorMu: k.donorMu,
          donorSirasi: k.donorSirasi,
          vetoVarMi: k.vetoVarMi,
          durumMetni: k.durumMetni,
          durumKodu: k.durumKodu,
        ),
      );
    }

    return sonuc;
  }

  static int _sirala(_RaporHamKaydi a, _RaporHamKaydi b, String raporTipi) {
    if (raporTipi == tipDonorAdaylari) {
      if (a.donorSirasi != b.donorSirasi) {
        return a.donorSirasi.compareTo(b.donorSirasi);
      }
    } else if (raporTipi == tipZayiftanGucluye) {
      if (a.genelSkor != b.genelSkor) {
        return a.genelSkor.compareTo(b.genelSkor);
      }
    } else {
      if (a.genelSkor != b.genelSkor) {
        return b.genelSkor.compareTo(a.genelSkor);
      }
    }

    if (a.uremeHam != b.uremeHam) {
      return b.uremeHam.compareTo(a.uremeHam);
    }
    if (a.uretimHam != b.uretimHam) {
      return b.uretimHam.compareTo(a.uretimHam);
    }
    if (a.donorMu != b.donorMu) {
      return a.donorMu ? -1 : 1;
    }
    if (a.sonCita != b.sonCita) {
      return b.sonCita.compareTo(a.sonCita);
    }

    final aNo = (a.koloni['kovanNo'] ?? '').toString();
    final bNo = (b.koloni['kovanNo'] ?? '').toString();
    return aNo.compareTo(bNo);
  }

  static String _durumMetniOlustur({
    required int sonCita,
    required bool donorMu,
    required int donorSirasi,
    required bool vetoVarMi,
  }) {
    if (vetoVarMi) return 'Genetik veto';
    if (donorMu) return 'Donör $donorSirasi';
    if (sonCita <= 4) return 'Çok zayıf';
    if (sonCita <= 7) return 'Gelişmekte';
    if (sonCita <= 11) return 'Üretim';
    if (sonCita <= 15) return 'Güçlü';
    return 'Çok güçlü';
  }

  static String _durumKoduOlustur({
    required int sonCita,
    required bool donorMu,
    required bool vetoVarMi,
  }) {
    if (vetoVarMi) return 'veto';
    if (donorMu) return 'donor';
    if (sonCita <= 4) return 'cok_zayif';
    if (sonCita <= 7) return 'gelismekte';
    if (sonCita <= 11) return 'uretim';
    if (sonCita <= 15) return 'guclu';
    return 'cok_guclu';
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }
}
