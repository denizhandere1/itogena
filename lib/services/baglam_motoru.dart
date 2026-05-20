import 'surec_motoru.dart';
import 'karar_sinyali_modeli.dart';


class KararKilitDurumu {
  final bool aktif;
  final String kod;
  final String baslik;
  final String mesaj;
  final int oncelik;
  final bool eylemEngeli;
  final bool beslemeEngeli;
  final bool katEngeli;
  final bool bolmeEngeli;
  final bool varroaEngeli;

  const KararKilitDurumu({
    required this.aktif,
    this.kod = '',
    this.baslik = '',
    this.mesaj = '',
    this.oncelik = 0,
    this.eylemEngeli = false,
    this.beslemeEngeli = false,
    this.katEngeli = false,
    this.bolmeEngeli = false,
    this.varroaEngeli = false,
  });

  static const yok = KararKilitDurumu(aktif: false);

  Map<String, dynamic> toMap() {
    return {
      'aktif': aktif,
      'kod': kod,
      'baslik': baslik,
      'mesaj': mesaj,
      'oncelik': oncelik,
      'eylemEngeli': eylemEngeli,
      'beslemeEngeli': beslemeEngeli,
      'katEngeli': katEngeli,
      'bolmeEngeli': bolmeEngeli,
      'varroaEngeli': varroaEngeli,
    };
  }
}

class BaglamMotoru {
  static const Set<String> _kritikBiyolojikGruplar = {
    'ANASIZLIK',
    'OGUL',
    'OGUL_SONRASI',
    'BOLME',
    'GELISIM',
    'YAVRU_YOK',
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
    if (grup == 'YAVRU_YOK' || kod.contains('YAVRU_YOK')) return 2;
    if (grup == 'OGUL' || kod.contains('OGUL_BELIRTISI')) return 3;
    if (grup == 'OGUL_SONRASI' || kod.contains('OGUL_SONRASI')) return 4;
    if (grup == 'BOLME' || kod.contains('BOLME')) return 5;
    if (grup == 'GELISIM' || kod.contains('GELISIM')) return 6;
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
    if (grup == 'YAVRU_YOK' || kod.contains('YAVRU_YOK')) return 2;
    if (grup == 'OGUL' || kod.contains('OGUL_BELIRTISI')) return 3;
    if (grup == 'OGUL_SONRASI' || kod.contains('OGUL_SONRASI')) return 4;
    if (grup == 'BOLME' || kod.contains('BOLME')) return 5;
    if (grup == 'GELISIM' || kod.contains('GELISIM')) return 6;
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


  /// Süreç/yönetim/biyoloji kararları ekrana düşmeden önce ortak
  /// müdahale kilidinden geçer. Amaç yeni karar üretmek değil;
  /// çelişen eylemleri sahaya çıkmadan bastırmaktır.
  static KararKilitDurumu kararKilitDurumuGetir(
    List<SurecUyarisi> surecler, {
    bool balAkimiAktif = false,
    int? balAkiminaKalanGun,
    bool kisDonemi = false,
  }) {
    KararKilitDurumu enGuclu = KararKilitDurumu.yok;

    void adayEkle(KararKilitDurumu aday) {
      if (!aday.aktif) return;
      if (!enGuclu.aktif || aday.oncelik > enGuclu.oncelik) {
        enGuclu = aday;
      }
    }

    for (final surec in surecler) {
      final grup = _normalize(surec.grup);
      final kod = _normalize(surec.kod);
      final baslik = surec.baslik.trim().isEmpty ? 'Aktif süreç' : surec.baslik;
      final mesaj = surec.mesaj.trim().isEmpty
          ? 'Bu süreç kapanana kadar çelişen saha eylemleri önerilmez.'
          : surec.mesaj;

      if (grup == 'ANASIZLIK' ||
          kod.contains('ANASIZLIK') ||
          kod.contains('ANA_KAZANMA') ||
          kod.contains('HAZIR_ANA') ||
          kod.contains('KAPALI_MEME')) {
        adayEkle(KararKilitDurumu(
          aktif: true,
          kod: KararKodu.anaSureciKilidi,
          baslik: baslik,
          mesaj: '$mesaj Bu pencere açıkken kat, bölme ve gereksiz müdahale önerilmez.',
          oncelik: 100,
          eylemEngeli: true,
          katEngeli: true,
          bolmeEngeli: true,
        ));
      }

      if (grup == 'OGUL_SONRASI' || kod.contains('OGUL_SONRASI')) {
        adayEkle(KararKilitDurumu(
          aktif: true,
          kod: KararKodu.ogulSonrasiKilidi,
          baslik: baslik,
          mesaj: '$mesaj Yeni ana düzeni netleşmeden genişletme veya üretim kararı öne çıkarılmaz.',
          oncelik: 96,
          eylemEngeli: true,
          katEngeli: true,
          bolmeEngeli: true,
        ));
      }

      if (grup == 'BOLME' || kod.contains('BOLME_SONRASI')) {
        adayEkle(KararKilitDurumu(
          aktif: true,
          kod: KararKodu.bolmeSonrasiKilidi,
          baslik: baslik,
          mesaj: '$mesaj Bölme toparlanmadan yeni bölme veya agresif genişletme önerilmez.',
          oncelik: 92,
          eylemEngeli: true,
          katEngeli: true,
          bolmeEngeli: true,
        ));
      }

      if (grup == 'YAVRU_YOK' || kod.contains('YAVRU_YOK')) {
        adayEkle(KararKilitDurumu(
          aktif: true,
          kod: KararKodu.yavruYokTaniKilidi,
          baslik: baslik,
          mesaj: '$mesaj Yavru/ana durumu netleşmeden hasat, kat veya üretim baskısı önerilmez.',
          oncelik: 98,
          eylemEngeli: true,
          katEngeli: true,
          bolmeEngeli: true,
        ));
      }

      if (grup == 'OGUL' || kod.contains('OGUL_BELIRTISI') || kod.contains('ANA_MEMESI')) {
        adayEkle(KararKilitDurumu(
          aktif: true,
          kod: KararKodu.ogulBaskisiKilidi,
          baslik: baslik,
          mesaj: '$mesaj Normal kat önerisi tek başına verilmez; önce oğul baskısı yönetilir.',
          oncelik: 94,
          katEngeli: true,
        ));
      }
    }

    if (balAkimiAktif) {
      adayEkle(const KararKilitDurumu(
        aktif: true,
        kod: KararKodu.balAkimiKilidi,
        baslik: 'Bal akımı dönemi',
        mesaj: 'Bal akımı içinde şekerli besleme ve kalıntı riski taşıyan müdahaleler önerilmez.',
        oncelik: 88,
        beslemeEngeli: true,
        varroaEngeli: true,
      ));
    } else if (balAkiminaKalanGun != null &&
        balAkiminaKalanGun >= 0 &&
        balAkiminaKalanGun <= 20) {
      adayEkle(KararKilitDurumu(
        aktif: true,
        kod: KararKodu.balAkimiOncesiBeslemeKilidi,
        baslik: 'Besleme kesme penceresi',
        mesaj: 'Bal akımına $balAkiminaKalanGun gün kaldı. Şekerli besleme önerilmez; şurupluk ve alan yönetimi öne alınır.',
        oncelik: 86,
        beslemeEngeli: true,
      ));
    }

    if (kisDonemi) {
      adayEkle(const KararKilitDurumu(
        aktif: true,
        kod: KararKodu.kisMudahaleKilidi,
        baslik: 'Kış dönemi',
        mesaj: 'Kış döneminde gereksiz kovan açma önerilmez. Açlık riski dışında dış gözlem, ağırlık ve nem kontrolü önceliklidir.',
        oncelik: 84,
        eylemEngeli: true,
        katEngeli: true,
        bolmeEngeli: true,
      ));
    }

    return enGuclu;
  }

  static List<Map<String, dynamic>> kararCakismalariniUzlastir(
    List<Map<String, dynamic>> kararlar,
    KararKilitDurumu kilit,
  ) {
    final tekil = <String, Map<String, dynamic>>{};

    for (final hamKarar in kararlar) {
      final karar = KararSinyaliModeli.standartlastir(hamKarar);

      bool bastir = false;
      if (kilit.aktif &&
          karar['bastirilabilir'] != false &&
          !_kilitIstisnasiMi(karar)) {
        if (kilit.eylemEngeli && KararSinyaliModeli.eylemMi(karar)) {
          bastir = true;
        }
        if (kilit.beslemeEngeli && _beslemeKarariMi(karar)) {
          bastir = true;
        }
        if (kilit.katEngeli && _katBallikKarariMi(karar)) {
          bastir = true;
        }
        if (kilit.bolmeEngeli && _bolmeKarariMi(karar)) {
          bastir = true;
        }
        if (kilit.varroaEngeli && _varroaKarariMi(karar)) {
          bastir = true;
        }
      }

      if (bastir) continue;

      final anahtar = _uzlasmaAnahtari(karar);
      final mevcut = tekil[anahtar];
      if (mevcut == null || _mapKarsilastir(karar, mevcut) < 0) {
        tekil[anahtar] = karar;
      }
    }

    final sonuc = tekil.values.toList(growable: false);
    sonuc.sort(_mapKarsilastir);
    return sonuc;
  }

  static bool _kilitIstisnasiMi(Map<String, dynamic> karar) {
    // Veto/bekleme kararları kilidin parçasıdır; eylem engeli altında
    // kaybolursa sistem “ne yapılmamalı” bilgisini gösteremez.
    if (_kararTipiMi(karar, KararTipi.veto) ||
        _kararTipiMi(karar, KararTipi.bekle)) {
      return true;
    }
    if (_kategoriMi(karar, KararKatmani.kilit) ||
        _kategoriMi(karar, KararTipi.veto)) {
      return true;
    }

    // Kışta normal kural gereksiz müdahaleyi kesmektir; fakat açlık riski
    // yaşatma önceliğidir ve kış kilidi tarafından bastırılmamalıdır.
    if (_kodMu(karar, KararKodu.kisAclikRiski)) return true;

    return false;
  }

  static String _uzlasmaAnahtari(Map<String, dynamic> karar) {
    final kod = _normalize(karar['kod']);
    final konu = _konuAnahtari(karar);

    if (_beslemeKarariMi(karar)) return 'BESLEME';
    if (_varroaKarariMi(karar)) return 'VARROA';
    if (_suruplukKarariMi(karar)) return 'SURUPLUK';
    if (_katBallikKarariMi(karar)) return 'KAT_BALLIK';
    if (_bolmeKarariMi(karar) || konu == 'BOLME') {
      return 'BOLME_STRATEJISI';
    }
    if (_kisKarariMi(karar)) return 'KIS_YONETIMI';
    if (_genetikCogaltmaKarariMi(karar)) return 'GENETIK_COGALTMA';
    return kod.isNotEmpty ? kod : konu;
  }

  static bool _kararTipiMi(Map<String, dynamic> karar, String tip) {
    return _normalize(karar['kararTipi']) == _normalize(tip);
  }

  static bool _kategoriMi(Map<String, dynamic> karar, String kategori) {
    return _normalize(karar['kategori']) == _normalize(kategori) ||
        _normalize(karar['katman']) == _normalize(kategori);
  }

  static bool _kodMu(Map<String, dynamic> karar, String kod) {
    return _normalize(karar['kod']) == _normalize(kod);
  }

  static bool _kodIcerir(Map<String, dynamic> karar, String parca) {
    return _normalize(karar['kod']).contains(_normalize(parca));
  }

  static bool _metinIcerir(Map<String, dynamic> karar, String parca) {
    final birlesik = _normalize([
      karar['kod'],
      karar['kategori'],
      karar['katman'],
      karar['kararTipi'],
      karar['baslik'],
      karar['mesaj'],
    ].where((e) => e != null).join(' '));
    return birlesik.contains(_normalize(parca));
  }

  static bool _beslemeKarariMi(Map<String, dynamic> karar) {
    return _kodIcerir(karar, 'BESLEME') ||
        _metinIcerir(karar, 'BESLEME') ||
        _metinIcerir(karar, 'BESLE');
  }

  static bool _katBallikKarariMi(Map<String, dynamic> karar) {
    return _kodMu(karar, KararKodu.katAdayi) ||
        _metinIcerir(karar, 'KAT') ||
        _metinIcerir(karar, 'BALLIK');
  }

  static bool _bolmeKarariMi(Map<String, dynamic> karar) {
    return _kodMu(karar, KararKodu.kontrolluBolmeAdayi) ||
        _kodMu(karar, KararKodu.sinirliBolmeDegerlendir) ||
        _kodIcerir(karar, 'BOLME') ||
        _metinIcerir(karar, 'BOLME');
  }

  static bool _varroaKarariMi(Map<String, dynamic> karar) {
    return _kodMu(karar, KararKodu.varroaTakip) ||
        _kodMu(karar, KararKodu.varroaRisk) ||
        _metinIcerir(karar, 'VARROA');
  }

  static bool _suruplukKarariMi(Map<String, dynamic> karar) {
    return _kodMu(karar, KararKodu.suruplukKaldir) ||
        _metinIcerir(karar, 'SURUPLUK');
  }

  static bool _kisKarariMi(Map<String, dynamic> karar) {
    return _kodMu(karar, KararKodu.kisHazirlik) ||
        _kodMu(karar, KararKodu.kisDonemi) ||
        _kodMu(karar, KararKodu.kisAclikRiski) ||
        _kodMu(karar, KararKodu.kisHacimRiski) ||
        _kodIcerir(karar, 'KIS_');
  }

  static bool _genetikCogaltmaKarariMi(Map<String, dynamic> karar) {
    return _kodMu(karar, KararKodu.genetikCogaltmaAdayi) ||
        _kodMu(karar, KararKodu.genetikCogaltmaVeto) ||
        _kodIcerir(karar, 'GENETIK_COGALTMA');
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
