import 'veritabani_servisi.dart';

class ArilikUyari {
  final String kod;
  final String baslik;
  final String mesaj;
  final int oncelik;

  const ArilikUyari({
    required this.kod,
    required this.baslik,
    required this.mesaj,
    required this.oncelik,
  });
}

class ArilikRiskTanim {
  final String kod;
  final String baslik;
  final String baslangicAnahtar;
  final String bitisAnahtar;
  final String varsayilanBaslangic;
  final String varsayilanBitis;

  const ArilikRiskTanim({
    required this.kod,
    required this.baslik,
    required this.baslangicAnahtar,
    required this.bitisAnahtar,
    required this.varsayilanBaslangic,
    required this.varsayilanBitis,
  });
}

class ArilikUyariServisi {
  static List<ArilikRiskTanim> get riskTanimlari {
    return VeritabaniServisi.riskTakvimiTanimlari.map((tanim) {
      final baslangicAnahtar = tanim['baslangicAnahtar'] ?? '';
      final bitisAnahtar = tanim['bitisAnahtar'] ?? '';
      return ArilikRiskTanim(
        kod: tanim['kod'] ?? '',
        baslik: tanim['baslik'] ?? '',
        baslangicAnahtar: baslangicAnahtar,
        bitisAnahtar: bitisAnahtar,
        varsayilanBaslangic:
            VeritabaniServisi.varsayilanAyarDegeri(baslangicAnahtar),
        varsayilanBitis:
            VeritabaniServisi.varsayilanAyarDegeri(bitisAnahtar),
      );
    }).toList(growable: false);
  }

  static final Map<String, List<ArilikUyari>> _uyariCache = {};

  static void cacheTemizle({int? arilikId}) {
    if (arilikId != null && arilikId > 0) {
      final prefix = 'arilik_${arilikId}_';
      _uyariCache.removeWhere((key, value) => key.startsWith(prefix));
      return;
    }
    _uyariCache.clear();
  }

  static Future<List<ArilikUyari>> uyarilariGetir(
    DateTime bugun, {
    int? arilikId,
  }) async {
    final gun = _gun(bugun);
    final cacheKey = '${arilikId != null && arilikId > 0 ? 'arilik_$arilikId' : 'global'}_${gun.year}_${gun.month}_${gun.day}';

    final cacheli = _uyariCache[cacheKey];
    if (cacheli != null) return cacheli;

    final List<ArilikUyari> liste = [];

    final varroaUyarisi = await _varroaAkimiOncesiUyarisiGetir(
      bugun,
      arilikId: arilikId,
    );
    if (varroaUyarisi != null &&
        !await sezonlukGizliMi(varroaUyarisi.kod, bugun, arilikId: arilikId)) {
      liste.add(varroaUyarisi);
    }

    final balAkimiUyarisi = await _balAkimiBolmeUyarisiGetir(
      bugun,
      arilikId: arilikId,
    );
    if (balAkimiUyarisi != null &&
        !await sezonlukGizliMi(balAkimiUyarisi.kod, bugun, arilikId: arilikId)) {
      liste.add(balAkimiUyarisi);
    }

    for (final risk in riskTanimlari) {
      final baslangic = await _ayarGetir(
        risk.baslangicAnahtar,
        varsayilan: risk.varsayilanBaslangic,
        arilikId: arilikId,
      );
      final bitis = await _ayarGetir(
        risk.bitisAnahtar,
        varsayilan: risk.varsayilanBitis,
        arilikId: arilikId,
      );

      if (!_tarihAraliktaMi(bugun, baslangic, bitis)) continue;
      if (await sezonlukGizliMi(risk.kod, bugun, arilikId: arilikId)) continue;

      final uyari = _uyariUret(risk.kod);
      if (uyari != null) liste.add(uyari);
    }

    liste.sort((a, b) => b.oncelik.compareTo(a.oncelik));
    _uyariCache[cacheKey] = List<ArilikUyari>.unmodifiable(liste);
    return liste;
  }

  static Future<void> sezonlukGizle(
    String kod,
    DateTime bugun, {
    int? arilikId,
  }) async {
    await _ayarKaydet(_gizlemeAnahtari(kod, bugun.year, arilikId: arilikId), '1');
    cacheTemizle(arilikId: arilikId);
  }

  static Future<bool> sezonlukGizliMi(
    String kod,
    DateTime bugun, {
    int? arilikId,
  }) async {
    final deger = await _ayarGetir(
      _gizlemeAnahtari(kod, bugun.year, arilikId: arilikId),
      varsayilan: '0',
      arilikId: null,
    );
    return deger == '1';
  }

  static String _gizlemeAnahtari(String kod, int yil, {int? arilikId}) {
    if (arilikId != null && arilikId > 0) {
      return 'arilik_${arilikId}_uyari_gizle_${kod}_$yil';
    }
    return 'arilik_uyari_gizle_${kod}_$yil';
  }

  static Future<ArilikUyari?> _varroaAkimiOncesiUyarisiGetir(
    DateTime bugun, {
    int? arilikId,
  }) async {
    final bugunGun = _gun(bugun);

    final akim = await VeritabaniServisi.aktifBalAkimGetir(
      tarih: bugunGun,
      arilikId: arilikId,
    );
    if (akim == null) return null;

    final baslangic = akim['bas'] as DateTime?;
    final bitis = akim['bit'] as DateTime?;
    final etiket = (akim['etiket'] ?? 'bal akımı').toString();

    if (baslangic == null || bitis == null) return null;
    if (bugunGun.isAfter(bitis)) return null;

    final kod = etiket.toLowerCase().contains('2.') ? 'AKIM2' : 'AKIM1';
    final planlamaBaslangici = baslangic.subtract(const Duration(days: 45));
    final kalintiGuvenlikEsigi = baslangic.subtract(const Duration(days: 30));

    if (bugunGun.isBefore(planlamaBaslangici)) return null;
    if (!bugunGun.isBefore(baslangic)) return null;

    if (bugunGun.isBefore(kalintiGuvenlikEsigi)) {
      return ArilikUyari(
        kod: 'VARROA_AKIM_ONCESI_PLAN_$kod',
        baslik: '$etiket öncesi varroa mücadelesini planla',
        mesaj:
            'Bal akımı yaklaşmadan önce varroa durumunu değerlendir. Kimyasal uygulama yapılacaksa kalıntı riskini hesaba katarak erken planla.',
        oncelik: 88,
      );
    }

    return ArilikUyari(
      kod: 'VARROA_AKIM_ONCESI_SON_$kod',
      baslik: 'Bal akımı öncesi varroa mücadelesi için son dönem',
      mesaj:
          '${_formatTarih(baslangic)} tarihinde başlaması beklenen $etiket öncesi kalıntı riskini azaltmak için varroa mücadelesi mümkünse ${_formatTarih(kalintiGuvenlikEsigi)} tarihine kadar tamamlanmış olmalı. Geciktiysen yeni kimyasal uygulamayı bal akımı sonrasına bırakman daha güvenli olabilir.',
      oncelik: 92,
    );
  }

  static Future<ArilikUyari?> _balAkimiBolmeUyarisiGetir(
    DateTime bugun, {
    int? arilikId,
  }) async {
    final bugunGun = _gun(bugun);

    final akim = await VeritabaniServisi.aktifBalAkimGetir(
      tarih: bugunGun,
      arilikId: arilikId,
    );
    if (akim == null) return null;

    final baslangic = akim['bas'] as DateTime?;
    final bitis = akim['bit'] as DateTime?;
    final etiket = (akim['etiket'] ?? 'bal akımı').toString();

    if (baslangic == null || bitis == null) return null;
    if (bugunGun.isAfter(bitis)) return null;

    final kod = etiket.toLowerCase().contains('2.') ? 'AKIM2' : 'AKIM1';
    final uyariBaslangici = baslangic.subtract(const Duration(days: 57));
    final kritikEsik = baslangic.subtract(const Duration(days: 42));

    if (bugunGun.isBefore(uyariBaslangici)) return null;

    if (bugunGun.isBefore(kritikEsik)) {
      return ArilikUyari(
        kod: 'BAL_AKIMI_BOLME_ERKEN_$kod',
        baslik: '$etiket yaklaşırken bölme kararına dikkat',
        mesaj:
            'Üretim hedefi korunacaksa bölme kararını dikkatli ver. Bal akımına güçlü işçi arı yetişmesi için zaman daralıyor.',
        oncelik: 90,
      );
    }

    return ArilikUyari(
      kod: 'BAL_AKIMI_BOLME_GEC_$kod',
      baslik: 'Bölme yapılacaksa dikkat',
      mesaj:
          'Bu tarihten sonra yapılan bölmeler bal verimini düşürebilir. Üretim hedefi korunacaksa bölme kararını ertele.',
      oncelik: 95,
    );
  }

  static ArilikUyari? _uyariUret(String kod) {
    switch (kod) {
      case 'ARI_KUSU':
        return const ArilikUyari(
          kod: 'ARI_KUSU',
          baslik: 'Arı kuşu baskısı görülebilir',
          mesaj:
              'Uçuş hattını gözle. Yoğun geçiş varsa korkuluk veya görsel caydırıcı önlemler kullan.',
          oncelik: 70,
        );
      case 'ESEK_ARISI':
        return const ArilikUyari(
          kod: 'ESEK_ARISI',
          baslik: 'Eşek arısı baskısı artabilir',
          mesaj:
              'Kovan girişlerini daralt, zayıf kolonileri koru. Yoğun baskıda tuzak kurulması değerlendirilebilir.',
          oncelik: 80,
        );
      case 'YAGMACILIK':
        return const ArilikUyari(
          kod: 'YAGMACILIK',
          baslik: 'Yağmacılık riski artabilir',
          mesaj:
              'Kovan açma süresini kısa tut. Girişleri daralt, zayıf kolonileri koru.',
          oncelik: 75,
        );
      case 'MUM_GUVESI':
        return const ArilikUyari(
          kod: 'MUM_GUVESI',
          baslik: 'Mum güvesi riski artabilir',
          mesaj:
              'Zayıf kolonide fazla petek bırakma. Boş petekleri korumalı sakla.',
          oncelik: 60,
        );
      case 'FARE':
        return const ArilikUyari(
          kod: 'FARE',
          baslik: 'Fare riski başlayabilir',
          mesaj:
              'Kovan girişlerini daralt. Fare girişini engellemek için önlem al.',
          oncelik: 65,
        );
      default:
        return null;
    }
  }

  static bool _tarihAraliktaMi(
    DateTime tarih,
    String baslangicMmDd,
    String bitisMmDd,
  ) {
    final t = _gun(tarih);
    final bas = _mmDdToDate(tarih.year, baslangicMmDd);
    final bit = _mmDdToDate(tarih.year, bitisMmDd);

    final basSira = _mmDdSirasi(baslangicMmDd);
    final bitSira = _mmDdSirasi(bitisMmDd);

    if (basSira <= bitSira) {
      return !t.isBefore(bas) && !t.isAfter(bit);
    }

    final bitErtesiYil = _mmDdToDate(tarih.year + 1, bitisMmDd);
    final basOncekiYil = _mmDdToDate(tarih.year - 1, baslangicMmDd);

    final buYilAralik = !t.isBefore(bas) && !t.isAfter(bitErtesiYil);
    final gecenYilAralik = !t.isBefore(basOncekiYil) && !t.isAfter(bit);
    return buYilAralik || gecenYilAralik;
  }

  static String _formatTarih(DateTime tarih) {
    final gun = tarih.day.toString().padLeft(2, '0');
    final ay = tarih.month.toString().padLeft(2, '0');
    return '$gun.$ay.${tarih.year}';
  }

  static DateTime _gun(DateTime tarih) {
    return DateTime(tarih.year, tarih.month, tarih.day);
  }

  static DateTime _mmDdToDate(int yil, String mmDd) {
    final parcalar = mmDd.split('-');
    final ay = int.tryParse(parcalar.first) ?? 1;
    final gun = int.tryParse(parcalar.last) ?? 1;
    return DateTime(yil, ay, gun);
  }

  static int _mmDdSirasi(String mmDd) {
    final parcalar = mmDd.split('-');
    final ay = int.tryParse(parcalar.first) ?? 1;
    final gun = int.tryParse(parcalar.last) ?? 1;
    return ay * 100 + gun;
  }

  static Future<String> _ayarGetir(
    String anahtar, {
    required String varsayilan,
    int? arilikId,
  }) async {
    if (varsayilan.isEmpty && anahtar.startsWith('arilik_uyari_gizle_')) {
      return VeritabaniServisi.ayarStringGetir(anahtar, varsayilan: '0');
    }

    if (anahtar.contains('_uyari_gizle_')) {
      return VeritabaniServisi.ayarStringGetir(anahtar, varsayilan: varsayilan);
    }

    return VeritabaniServisi.kalibrasyonAyarGetir(
      anahtar,
      arilikId: arilikId,
    );
  }

  static Future<void> _ayarKaydet(String anahtar, String deger) async {
    await VeritabaniServisi.ayarKaydet(anahtar, deger);
  }
}
