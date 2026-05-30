import 'karar_sinyali_modeli.dart';

/// İTOGENA Karar Orkestratörü
///
/// Bu sınıf yeni karar üretmez.
/// Mevcut motorlardan gelen süreç, yönetim, risk, projeksiyon, genetik ve bilgi
/// sinyallerini tek disipline sokar:
///
/// - öncelik verir
/// - çakışmaları yumuşatır
/// - tek ana kararı seçer
/// - grid ve detay görünürlüğünü ayırır
///
/// Amaç kullanıcıyı çok sesli uyarı kalabalığına boğmadan,
/// o an sahada en önemli olan kararı görünür kılmaktır.
class KararOrkestratoru {
  static Map<String, dynamic> orkestreEt({
    required List<Map<String, dynamic>> sinyaller,
    bool gridModu = false,
  }) {
    final List<Map<String, dynamic>> temiz = sinyaller
        .map(_normalize)
        .where((s) => (s['baslik'] ?? '').toString().trim().isNotEmpty)
        .toList();

    if (temiz.isEmpty) {
      return const <String, dynamic>{
        'anaKarar': <String, dynamic>{},
        'detayKararlari': <Map<String, dynamic>>[],
        'gridKarari': <String, dynamic>{},
        'bastirilanlar': <Map<String, dynamic>>[],
      };
    }

    final List<Map<String, dynamic>> sirali = List<Map<String, dynamic>>.from(temiz)
      ..sort((a, b) => _toInt(b['oncelik']).compareTo(_toInt(a['oncelik'])));

    final Map<String, dynamic> anaKarar = Map<String, dynamic>.from(sirali.first);
    final List<Map<String, dynamic>> detayKararlari = <Map<String, dynamic>>[];
    final List<Map<String, dynamic>> bastirilanlar = <Map<String, dynamic>>[];

    for (final sinyal in sirali) {
      if (_bastirilmaliMi(anaKarar, sinyal)) {
        bastirilanlar.add({
          ...sinyal,
          'bastirilmaNedeni': _bastirmaNedeni(anaKarar, sinyal),
        });
        continue;
      }

      if (sinyal['detayGoster'] != false) {
        detayKararlari.add(sinyal);
      }
    }

    final Map<String, dynamic> gridKarari = _gridKarariSec(sirali, anaKarar);

    return {
      'anaKarar': anaKarar,
      'detayKararlari': detayKararlari,
      'gridKarari': gridKarari,
      'bastirilanlar': bastirilanlar,
    };
  }

  static Map<String, dynamic> sinyal({
    required String kaynak,
    required String kod,
    required String baslik,
    required String mesaj,
    int oncelik = 50,
    String risk = 'dusuk',
    bool kritikMi = false,
    bool gridGoster = true,
    bool detayGoster = true,
    bool sessizlestirilebilir = true,
    String grup = '',
    String onerilenEylem = '',
  }) {
    return _normalize({
      'kaynak': kaynak,
      'kod': kod,
      'grup': grup,
      'baslik': baslik,
      'mesaj': mesaj,
      'oncelik': oncelik,
      'risk': risk,
      'kritikMi': kritikMi,
      'gridGoster': gridGoster,
      'detayGoster': detayGoster,
      'sessizlestirilebilir': sessizlestirilebilir,
      'onerilenEylem': onerilenEylem,
    });
  }

  static Map<String, dynamic> _normalize(Map<String, dynamic> ham) {
    final String kaynak = (ham['kaynak'] ?? ham['katman'] ?? '').toString();
    final String kod = (ham['kod'] ?? '').toString();
    final String grup = (ham['grup'] ?? '').toString();
    final String baslik = (ham['baslik'] ?? ham['title'] ?? '').toString();
    final String mesaj = (ham['mesaj'] ?? ham['message'] ?? '').toString();

    int oncelik = _toInt(ham['oncelik']);
    if (oncelik <= 0) {
      oncelik = _varsayilanOncelik(kaynak, kod, grup, baslik);
    }

    final bool kritikMi = ham['kritikMi'] == true ||
        (ham['tip'] ?? '').toString().toLowerCase() == 'kritik' ||
        oncelik >= 90;

    final standart = KararSinyaliModeli.standartlastir({
      ...ham,
      'kaynak': kaynak,
      'kod': kod,
      'grup': grup,
      'baslik': baslik,
      'mesaj': mesaj,
      'oncelik': oncelik,
      'risk': (ham['risk'] ?? (kritikMi ? 'yuksek' : 'dusuk')).toString(),
      'kritikMi': kritikMi,
      'gridGosterilebilir': ham['gridGoster'] ?? ham['gridGosterilebilir'] ?? true,
      'detayGosterilebilir': ham['detayGoster'] ?? ham['detayGosterilebilir'] ?? true,
      'bastirilabilir': ham['bastirilabilir'] ?? ham['sessizlestirilebilir'] ?? !kritikMi,
    });

    return {
      ...standart,
      'gridGoster': standart['gridGosterilebilir'] ?? true,
      'detayGoster': standart['detayGosterilebilir'] ?? true,
      'sessizlestirilebilir': standart['bastirilabilir'] ?? !kritikMi,
      'onerilenEylem': (ham['onerilenEylem'] ?? ham['eylem'] ?? '').toString(),
    };
  }

  static bool _bastirilmaliMi(
    Map<String, dynamic> ana,
    Map<String, dynamic> aday,
  ) {
    if (identical(ana, aday)) return false;
    if (aday['sessizlestirilebilir'] == false) return false;

    final int anaOncelik = _toInt(ana['oncelik']);
    final int adayOncelik = _toInt(aday['oncelik']);

    final String anaKatman = _norm(ana['katman']);
    final String adayKatman = _norm(aday['katman']);
    final String anaKategori = _norm(ana['kategori']);
    final String adayKategori = _norm(aday['kategori']);
    final String anaTip = _norm(ana['kararTipi']);
    final String adayTip = _norm(aday['kararTipi']);
    final String anaKod = _norm(ana['kod']);
    final String adayKod = _norm(aday['kod']);

    final bool anaSurec = anaKatman == _norm(KararKatmani.surec) ||
        anaKategori == _norm(KararKatmani.surec);
    final bool adayGenetik = adayKatman == _norm(KararKatmani.genetik) ||
        adayKategori == _norm(KararKatmani.genetik) ||
        adayTip == _norm(KararTipi.genetik);
    final bool adayBilgi = adayKatman == _norm(KararKatmani.bilgi) ||
        adayKategori == _norm(KararKatmani.bilgi) ||
        adayTip == _norm(KararTipi.bilgi);
    final bool adayProjeksiyon = adayKatman == _norm(KararKatmani.biyoloji) ||
        adayKategori == _norm(KararKatmani.biyoloji) ||
        _norm(aday['kaynak']).contains('PROJEKSIYON');

    // Kritik süreç açıkken genetik ve arka plan bilgi ana kartta konuşmaz.
    if (anaSurec && anaOncelik >= 90) {
      if (adayGenetik || adayBilgi || adayProjeksiyon) {
        return true;
      }
    }

    // Bal kalitesi/kalıntı riski varken besleme ve şurupluk dili geri çekilir.
    if (_balKalitesiKilidiMi(ana)) {
      if (adayKod.contains('BESLEME') || adayKod.contains('SURUPLUK')) {
        return true;
      }
    }

    // Yavrusuzluk/anasızlık ana karar ise üretim/hasat veya genetik övgü geri çekilir.
    if (_anaYavruSureciMi(ana)) {
      if (adayGenetik ||
          adayKod.contains('HASAT') ||
          adayKod.contains('URETIM') ||
          adayKod.contains('BAL_ANA')) {
        return true;
      }
    }

    // Bekle/veto ana kararları, düşük öncelikli eylem önerilerini ana akıştan çeker.
    if ((anaTip == _norm(KararTipi.bekle) || anaTip == _norm(KararTipi.veto)) &&
        KararSinyaliModeli.eylemMi(aday) &&
        anaOncelik >= adayOncelik) {
      return true;
    }

    // Öncelik farkı çok yüksekse düşük öncelikli bilgi detayda kalabilir ama ana akışı bozmaz.
    if (anaOncelik - adayOncelik >= 35 && adayBilgi) {
      return true;
    }

    return false;
  }


  static bool _balKalitesiKilidiMi(Map<String, dynamic> sinyal) {
    final birlesik = _norm([
      sinyal['kod'],
      sinyal['kategori'],
      sinyal['katman'],
      sinyal['baslik'],
      sinyal['mesaj'],
    ].where((e) => e != null).join(' '));
    return birlesik.contains('BAL KALITESI') ||
        birlesik.contains('KALINTI') ||
        birlesik.contains('BAL_AKIMI_ONCESI_BESLEME_KILIDI');
  }

  static bool _anaYavruSureciMi(Map<String, dynamic> sinyal) {
    final birlesik = _norm([
      sinyal['kod'],
      sinyal['kategori'],
      sinyal['katman'],
      sinyal['baslik'],
      sinyal['mesaj'],
    ].where((e) => e != null).join(' '));
    return birlesik.contains('YAVRU') ||
        birlesik.contains('ANASIZ') ||
        birlesik.contains('ANA SURECI') ||
        birlesik.contains('ANA_SURECI') ||
        birlesik.contains('ANA_KAZANMA');
  }

  static String _norm(dynamic v) => KararSinyaliModeli.normalize(v);



  /// Süreç sinyalinin ana karar alanını bastırıp bastırmayacağını belirler.
  ///
  /// Bu metod yeni karar üretmez; yalnızca görünürlük kuralını tek merkezde
  /// tutar. BaglamMotoru kilit/veto üretir, KararOrkestratoru ise hangi
  /// sinyalin ana alanda konuşacağını belirler.
  static bool surecAnaKarariBastirirMi(Map<String, dynamic>? surec) {
    if (surec == null || surec.isEmpty) return false;

    final sinyal = _normalize({
      ...surec,
      'kaynak': surec['kaynak'] ?? KararKatmani.surec,
      'katman': surec['katman'] ?? KararKatmani.surec,
      'kategori': surec['kategori'] ?? KararKatmani.surec,
      'baslik': surec['baslik'] ?? '',
      'mesaj': surec['mesaj'] ?? '',
    });

    final grup = _norm(sinyal['grup']);
    final kod = _norm(sinyal['kod']);
    final katman = _norm(sinyal['katman']);
    final kategori = _norm(sinyal['kategori']);
    final birlesik = _norm([
      sinyal['kod'],
      sinyal['grup'],
      sinyal['katman'],
      sinyal['kategori'],
      sinyal['baslik'],
      sinyal['mesaj'],
    ].where((e) => e != null).join(' '));

    final bool surecKatmani = katman == _norm(KararKatmani.surec) ||
        kategori == _norm(KararKatmani.surec);

    if (!surecKatmani) return false;

    if (grup == 'ANASIZLIK' ||
        grup == 'OGUL' ||
        grup == 'OGUL_SONRASI' ||
        grup == 'BOLME' ||
        grup == 'GELISIM' ||
        grup == 'YAVRU_YOK') {
      return true;
    }

    if (kod.contains('ANASIZLIK') ||
        kod.contains('ANA_KAZANMA') ||
        kod.contains('YAVRU_YOK') ||
        kod.contains('OGUL') ||
        kod.contains('BOLME') ||
        kod.contains('GELISIM')) {
      return true;
    }

    // Hasat sonrası bakım aktif biyolojik süreç yoksa ana karar olabilir;
    // daha kritik canlı süreçler orkestrasyon sıralamasında zaten öne geçer.
    if (grup == 'HASAT' || kod.contains('HASAT') || birlesik.contains('HASAT')) {
      return true;
    }

    return false;
  }

  static String _bastirmaNedeni(
    Map<String, dynamic> ana,
    Map<String, dynamic> aday,
  ) {
    final anaBaslik = (ana['baslik'] ?? '').toString();
    if (anaBaslik.isEmpty) return 'Daha yüksek öncelikli karar nedeniyle geri çekildi.';
    return '$anaBaslik daha yüksek öncelikli olduğu için geri plana alındı.';
  }

  static Map<String, dynamic> _gridKarariSec(
    List<Map<String, dynamic>> sirali,
    Map<String, dynamic> anaKarar,
  ) {
    for (final s in sirali) {
      if (s['gridGoster'] != false) return s;
    }
    return anaKarar;
  }

  static int _varsayilanOncelik(
    String kaynak,
    String kod,
    String grup,
    String baslik,
  ) {
    final k = '$kaynak $kod $grup $baslik'.toLowerCase();

    // Canlı süreçler rutin yönetim uyarılarının üstündedir.
    // Grid ve ana karar alanında önce koloni devamlılığı konuşur; varroa,
    // besleme, alan ve şurupluk gibi yönetim işleri bunun arkasına düşer.
    if (k.contains('yalancı ana') || k.contains('yalanci ana')) return 100;
    if (k.contains('anasız') || k.contains('anasiz')) return 100;
    if (k.contains('yavru yok') || k.contains('yavrusuz')) return 100;
    if (k.contains('oğul attı') || k.contains('ogul atti')) return 98;
    if (k.contains('artçı') || k.contains('artci')) return 96;
    if (k.contains('oğul') || k.contains('ogul') || k.contains('ana memesi')) {
      return 95;
    }
    if (k.contains('bölme') || k.contains('bolme')) return 90;
    if (k.contains('bal kalitesi') || k.contains('kalıntı') || k.contains('kalinti')) {
      return 72;
    }
    if (k.contains('kat') || k.contains('alan')) return 68;
    if (k.contains('varroa')) return 60;
    if (k.contains('eşek') || k.contains('esek') || k.contains('yağma') || k.contains('yagma')) {
      return 75;
    }
    if (k.contains('hasat sonrası') || k.contains('hasat sonrasi')) return 70;
    if (k.contains('donor') || k.contains('damızlık') || k.contains('damizlik')) {
      return 65;
    }
    return 50;
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    if (v is num) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }
}
