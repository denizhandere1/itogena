import 'surec_motoru.dart';

class BaglamMotoru {
  static const Set<String> _kritikBiyolojikGruplar = {
    'ANASIZLIK',
    'OGUL',
    'OGUL_SONRASI',
    'BOLME',
    'GELISIM',
  };

  static bool surecAnaKarariBastirirMi(SurecUyarisi? surec) {
    if (surec == null) return false;
    final grup = _normalize(surec.grup);
    final kod = _normalize(surec.kod);

    if (_kritikBiyolojikGruplar.contains(grup)) return true;

    // Hasat sonrası bakım, aktif biyolojik süreç yoksa ana kart olabilir.
    // Canlı ana/oğul/bölme süreci varken aynı süreç listesinde alt bağlama düşer.
    if (grup == 'HASAT' || kod.contains('HASAT')) return true;

    return false;
  }

  static SurecUyarisi? dominantSurecSec(List<SurecUyarisi> surecler) {
    final sirali = sirala(surecler);
    return sirali.isEmpty ? null : sirali.first;
  }

  static List<SurecUyarisi> sirala(List<SurecUyarisi> surecler) {
    final liste = List<SurecUyarisi>.from(surecler);
    liste.sort(_karsilastir);
    return liste;
  }

  static int _karsilastir(SurecUyarisi a, SurecUyarisi b) {
    final aKat = _kategoriSirasi(a);
    final bKat = _kategoriSirasi(b);
    if (aKat != bKat) return aKat.compareTo(bKat);

    final aTarih = tarihParse(a.referansTarihMetni);
    final bTarih = tarihParse(b.referansTarihMetni);
    if (aTarih != null && bTarih != null) {
      final tarihKarsilastir = bTarih.compareTo(aTarih);
      if (tarihKarsilastir != 0) return tarihKarsilastir;
    } else if (aTarih != null) {
      return -1;
    } else if (bTarih != null) {
      return 1;
    }

    final oncelikKarsilastir = b.oncelik.compareTo(a.oncelik);
    if (oncelikKarsilastir != 0) return oncelikKarsilastir;

    return a.baslik.compareTo(b.baslik);
  }

  static int _kategoriSirasi(SurecUyarisi surec) {
    final grup = _normalize(surec.grup);
    final kod = _normalize(surec.kod);

    if (grup == 'ANASIZLIK' || kod.contains('ANASIZLIK')) return 1;
    if (grup == 'OGUL' || kod.contains('OGUL_BELIRTISI')) return 2;
    if (grup == 'OGUL_SONRASI' || kod.contains('OGUL_SONRASI')) return 3;
    if (grup == 'BOLME' || kod.contains('BOLME')) return 4;
    if (grup == 'GELISIM' || kod.contains('GELISIM')) return 5;
    if (grup == 'HASAT' || kod.contains('HASAT')) return 8;
    return 20;
  }

  static List<Map<String, dynamic>> gorunurSurecleriSirala(
    List<Map<String, dynamic>> surecler, {
    Map<String, String>? anaKarar,
  }) {
    final filtreli = surecler.where((surec) {
      return !anaKartlaAyniSurecMi(anaKarar, surec);
    }).toList(growable: false);

    final tekil = <String, Map<String, dynamic>>{};
    for (final surec in filtreli) {
      final anahtar = _konuAnahtari(surec);
      final mevcut = tekil[anahtar];
      if (mevcut == null || _mapKarsilastir(surec, mevcut) < 0) {
        tekil[anahtar] = surec;
      }
    }

    final sonuc = tekil.values.toList(growable: false);
    sonuc.sort(_mapKarsilastir);
    return sonuc;
  }

  static bool anaKartlaAyniSurecMi(
    Map<String, String>? anaKarar,
    Map<String, dynamic> surec,
  ) {
    final anaKod = _normalize(anaKarar?['kod']);
    final surecKod = _normalize(surec['kod']);
    final anaBaslik = _normalize(anaKarar?['baslik']);
    final surecBaslik = _normalize(surec['baslik']);
    final anaMesaj = _normalize(anaKarar?['mesaj']);
    final surecMesaj = _normalize(surec['mesaj']);

    if (surecKod.isNotEmpty && anaKod == 'SUREC_$surecKod') return true;
    if (anaBaslik.isNotEmpty && anaBaslik == surecBaslik) return true;
    if (anaMesaj.isNotEmpty && anaMesaj == surecMesaj) return true;

    final anaKonu = _konuAnahtari({
      'kod': anaKarar?['kod'],
      'grup': '',
      'baslik': anaKarar?['baslik'],
      'mesaj': anaKarar?['mesaj'],
    });
    final surecKonu = _konuAnahtari(surec);

    if (anaKonu.isNotEmpty && anaKonu == surecKonu) return true;
    return false;
  }

  static bool arkaPlanSureciMi(Map<String, dynamic> surec) {
    final konu = _konuAnahtari(surec);
    return konu == 'HASAT_SONRASI' || konu == 'GENEL_BAKIM';
  }

  static int _mapKarsilastir(Map<String, dynamic> a, Map<String, dynamic> b) {
    final aKat = _mapKategoriSirasi(a);
    final bKat = _mapKategoriSirasi(b);
    if (aKat != bKat) return aKat.compareTo(bKat);

    final aTarih = tarihParse((a['referansTarihMetni'] ?? '').toString());
    final bTarih = tarihParse((b['referansTarihMetni'] ?? '').toString());
    if (aTarih != null && bTarih != null) {
      final tarihKarsilastir = bTarih.compareTo(aTarih);
      if (tarihKarsilastir != 0) return tarihKarsilastir;
    } else if (aTarih != null) {
      return -1;
    } else if (bTarih != null) {
      return 1;
    }

    final aOncelik = _toInt(a['oncelik']);
    final bOncelik = _toInt(b['oncelik']);
    final oncelikKarsilastir = bOncelik.compareTo(aOncelik);
    if (oncelikKarsilastir != 0) return oncelikKarsilastir;

    return (a['baslik'] ?? '').toString().compareTo(
          (b['baslik'] ?? '').toString(),
        );
  }

  static int _mapKategoriSirasi(Map<String, dynamic> surec) {
    final grup = _normalize(surec['grup']);
    final kod = _normalize(surec['kod']);

    if (grup == 'ANASIZLIK' || kod.contains('ANASIZLIK')) return 1;
    if (grup == 'OGUL' || kod.contains('OGUL_BELIRTISI')) return 2;
    if (grup == 'OGUL_SONRASI' || kod.contains('OGUL_SONRASI')) return 3;
    if (grup == 'BOLME' || kod.contains('BOLME')) return 4;
    if (grup == 'GELISIM' || kod.contains('GELISIM')) return 5;
    if (grup == 'HASAT' || kod.contains('HASAT')) return 8;
    return 20;
  }

  static String _konuAnahtari(Map<String, dynamic> surec) {
    final birlesik = _normalize([
      surec['kod'],
      surec['grup'],
      surec['baslik'],
      surec['mesaj'],
    ].where((e) => e != null).join(' '));

    if (birlesik.contains('ANASIZLIK') ||
        birlesik.contains('ANA_KAZANMA') ||
        birlesik.contains('HAZIR_ANA') ||
        birlesik.contains('KAPALI_MEME')) {
      return 'ANA_SURECI';
    }
    if (birlesik.contains('OGUL_SONRASI')) return 'OGUL_SONRASI';
    if (birlesik.contains('OGUL_BELIRTISI') || birlesik.contains('OGUL RISKI')) {
      return 'OGUL_RISKI';
    }
    if (birlesik.contains('BOLME_SONRASI')) return 'BOLME_SONRASI';
    if (birlesik.contains('BOLME')) return 'BOLME';
    if (birlesik.contains('HASAT')) return 'HASAT_SONRASI';
    if (birlesik.contains('GELISIM')) return 'GELISIM';
    if (birlesik.contains('VARROA')) return 'VARROA';
    if (birlesik.contains('BAKIM')) return 'GENEL_BAKIM';
    return birlesik.isEmpty ? '' : birlesik;
  }

  static DateTime? tarihParse(String metin) {
    final temiz = metin.trim();
    if (temiz.isEmpty) return null;

    final iso = DateTime.tryParse(temiz);
    if (iso != null) return DateTime(iso.year, iso.month, iso.day);

    final nokta = temiz.split('.');
    if (nokta.length == 3) {
      final gun = int.tryParse(nokta[0]);
      final ay = int.tryParse(nokta[1]);
      final yil = int.tryParse(nokta[2]);
      if (gun != null && ay != null && yil != null) {
        return DateTime(yil, ay, gun);
      }
    }
    return null;
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }

  static String _normalize(dynamic deger) {
    return (deger ?? '')
        .toString()
        .trim()
        .toUpperCase()
        .replaceAll('İ', 'I')
        .replaceAll('İ', 'I')
        .replaceAll('Ğ', 'G')
        .replaceAll('Ü', 'U')
        .replaceAll('Ş', 'S')
        .replaceAll('Ö', 'O')
        .replaceAll('Ç', 'C')
        .replaceAll('Â', 'A')
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}
