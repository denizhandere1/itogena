/// ITOGENA Level 3 karar sözlüğü.
///
/// Amaç yeni UI veya yeni veri alanı açmak değil; mevcut servislerden gelen
/// karar/süreç/yönetim/biyoloji/genetik sinyallerini aynı anahtarlarla
/// standartlaştırmaktır. Böylece BaglamMotoru çelişki, veto ve öncelik
/// kararlarını string dağınıklığına düşmeden daha güvenli yönetir.
class KararKatmani {
  static const String hedef = 'hedef';
  static const String surec = 'surec';
  static const String yonetim = 'yonetim';
  static const String biyoloji = 'biyoloji';
  static const String genetik = 'genetik';
  static const String sapma = 'sapma';
  static const String kilit = 'kilit';
  static const String uyari = 'uyari';
  static const String bilgi = 'bilgi';
}

class KararTipi {
  static const String eylem = 'EYLEM';
  static const String bekle = 'BEKLE';
  static const String uyari = 'UYARI';
  static const String bilgi = 'BILGI';
  static const String veto = 'VETO';
  static const String genetik = 'GENETIK';
}

class KararKodu {
  static const String kararKilit = 'KARAR_KILIT';
  static const String anaSureciKilidi = 'ANA_SURECI_KILIDI';
  static const String ogulSonrasiKilidi = 'OGUL_SONRASI_KILIDI';
  static const String bolmeSonrasiKilidi = 'BOLME_SONRASI_KILIDI';
  static const String yavruYokTaniKilidi = 'YAVRU_YOK_TANI_KILIDI';
  static const String ogulBaskisiKilidi = 'OGUL_BASKISI_KILIDI';
  static const String balAkimiKilidi = 'BAL_AKIMI_KILIDI';
  static const String balAkimiOncesiBeslemeKilidi = 'BAL_AKIMI_ONCESI_BESLEME_KILIDI';
  static const String kisMudahaleKilidi = 'KIS_MUDAHALE_KILIDI';

  static const String balAnaKoloni = 'BAL_ANA_KOLONI';
  static const String genetikCogaltmaAdayi = 'GENETIK_COGALTMA_ADAYI';
  static const String bolmeSonrasiToparlanma = 'BOLME_SONRASI_TOPARLANMA';
  static const String riskliAnaSureci = 'RISKLI_ANA_SURECI';
  static const String zayifDestek = 'ZAYIF_DESTEK';
  static const String hasatKolonisi = 'HASAT_KOLONISI';
  static const String kisaHazirlik = 'KISA_HAZIRLIK';
  static const String kisHazirlik = 'KIS_HAZIRLIK';
  static const String kisDonemi = 'KIS_DONEMI';

  static const String beslemeGerekli = 'BESLEME_GEREKLI';
  static const String beslemeOnerilmez = 'BESLEME_ONERILMEZ';
  static const String suruplukKaldir = 'SURUPLUK_KALDIR';
  static const String katAdayi = 'KAT_ADAYI';
  static const String kontrolluBolmeAdayi = 'KONTROLLU_BOLME_ADAYI';
  static const String sinirliBolmeDegerlendir = 'SINIRLI_BOLME_DEGERLENDIR';
  static const String hasatSonrasiBakim = 'HASAT_SONRASI_BAKIM';
  static const String kisAclikRiski = 'KIS_ACLIK_RISKI';
  static const String kisHacimRiski = 'KIS_HACIM_RISKI';
  static const String varroaTakip = 'VARROA_TAKIP';
  static const String varroaRisk = 'VARROA_RISK';
  static const String genetikCogaltmaVeto = 'GENETIK_COGALTMA_VETO';
}


class KararSinyaliModeli {
  const KararSinyaliModeli._();

  static Map<String, dynamic> standartlastir(Map<String, dynamic> kaynak) {
    final sonuc = Map<String, dynamic>.from(kaynak);
    final kod = (sonuc['kod'] ?? '').toString().trim();
    final kategori = (sonuc['kategori'] ?? '').toString().trim();
    final katman = (sonuc['katman'] ?? '').toString().trim();

    sonuc['kod'] = kod.isEmpty ? KararKodu.kararKilit : kod;
    sonuc['kategori'] = kategori.isEmpty ? _kategoriTahminEt(sonuc) : kategori;
    sonuc['katman'] = katman.isEmpty ? _katmanTahminEt(sonuc) : katman;
    sonuc['kararTipi'] = (sonuc['kararTipi'] ?? _kararTipiTahminEt(sonuc)).toString();
    sonuc['oncelik'] = _toInt(sonuc['oncelik']);
    sonuc['bastirilabilir'] = sonuc['bastirilabilir'] ?? true;
    sonuc['gridGosterilebilir'] = sonuc['gridGosterilebilir'] ?? true;
    sonuc['detayGosterilebilir'] = sonuc['detayGosterilebilir'] ?? true;
    return sonuc;
  }

  static bool eylemMi(Map<String, dynamic> karar) {
    final tip = normalize(karar['kararTipi']);
    final kategori = normalize(karar['kategori']);
    final birlesik = normalize([
      karar['kod'],
      karar['kategori'],
      karar['katman'],
      karar['baslik'],
      karar['mesaj'],
    ].where((e) => e != null).join(' '));

    // Veto/bekle kararları eylem değil; tam tersine eylemi durdurur.
    // Bu ayrım müdahale kilidinde kritik: “besleme önerilmez” gibi
    // koruyucu kararlar, eylem engeli yüzünden yanlışlıkla kaybolmamalı.
    if (tip == KararTipi.bekle || tip == KararTipi.veto) return false;
    if (kategori == 'VETO' || kategori == 'KILIT') return false;

    if (tip == KararTipi.eylem) return true;
    if (kategori == 'EYLEM') return true;
    if (birlesik.contains('VER') ||
        birlesik.contains('YAP') ||
        birlesik.contains('BESLE') ||
        birlesik.contains('BOLME') ||
        birlesik.contains('KAT') ||
        birlesik.contains('SURUPLUK') ||
        birlesik.contains('VARROA')) {
      return true;
    }
    return false;
  }

  static String normalize(dynamic deger) {
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

  static String _kategoriTahminEt(Map<String, dynamic> karar) {
    final kod = normalize(karar['kod']);
    if (kod.contains('KILIT')) return KararKatmani.kilit;
    if (kod.startsWith('SAPMA')) return KararKatmani.sapma;
    if (kod.contains('GENETIK') || kod.contains('DONOR') || kod.contains('VETO')) {
      return KararKatmani.genetik;
    }
    if (kod.contains('KIS') || kod.contains('BESLEME') || kod.contains('KAT') || kod.contains('HASAT') || kod.contains('VARROA')) {
      return KararKatmani.yonetim;
    }
    if (kod.contains('BOLME') || kod.contains('ANA') || kod.contains('OGUL') || kod.contains('YAVRU')) {
      return KararKatmani.surec;
    }
    return KararKatmani.bilgi;
  }

  static String _katmanTahminEt(Map<String, dynamic> karar) {
    final kategori = (karar['kategori'] ?? '').toString().trim();
    if (kategori.isNotEmpty) return kategori;
    return _kategoriTahminEt(karar);
  }

  static String _kararTipiTahminEt(Map<String, dynamic> karar) {
    final kod = normalize(karar['kod']);
    final kategori = normalize(karar['kategori']);
    final metin = normalize([
      karar['kod'],
      karar['kategori'],
      karar['baslik'],
      karar['mesaj'],
    ].where((e) => e != null).join(' '));

    if (kod.contains('KILIT') || metin.contains('ONERILMEZ') || metin.contains('GEREKSIZ')) {
      return KararTipi.bekle;
    }
    if (kod.contains('VETO') || metin.contains('VETO')) return KararTipi.veto;
    if (kategori == 'GENETIK') return KararTipi.genetik;
    if (kategori == 'UYARI' || kategori == 'SAPMA' || metin.contains('RISK')) {
      return KararTipi.uyari;
    }
    if (eylemKelimesiVar(metin)) return KararTipi.eylem;
    return KararTipi.bilgi;
  }

  static bool eylemKelimesiVar(String normalizeMetin) {
    return normalizeMetin.contains(' ONER') ||
        normalizeMetin.contains(' DEGERLENDIR') ||
        normalizeMetin.contains(' PLANLA') ||
        normalizeMetin.contains(' KALDIR') ||
        normalizeMetin.contains(' VER') ||
        normalizeMetin.contains(' YAP');
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }
}
