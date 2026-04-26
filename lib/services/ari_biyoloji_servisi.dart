import 'veritabani_servisi.dart';

class BiyolojiAnalizSonucu {
  final bool veriVarMi;

  final bool anaUretimGirisimVarMi;
  final bool anasizBirakildiMi;
  final int anasizlikGunSayisi;

  final bool zamanKritik;
  final bool mudahaleGerekli;

  // Bu üç alan geriye dönük API uyumluluğu için tutulur.
  // Kullanıcıdan larva yaşı / erkek arı durumu / çiftleşme durumu alınmaz;
  // bu nedenle bu alanlar artık karar, skor ve yorum üretiminde kullanılmaz.
  final bool erkekHazirlikYetersiz;
  final bool memeTakibiGecikmis;
  final bool larvaKalitesiDusuk;
  final bool anaUretimIcinUygun;

  final String durumKodu;
  final String baslik;
  final String mesaj;

  // Geriye dönük API uyumluluğu için nötr değer döner.
  final String larvaKaliteSinifi;
  final String memeTakipDurumu;
  final String erkekHazirlikDurumu;
  final String ciftlesmeDurumu;

  final List<String> notlar;
  final Map<String, dynamic> hamVeri;

  const BiyolojiAnalizSonucu({
    required this.veriVarMi,
    required this.anaUretimGirisimVarMi,
    required this.anasizBirakildiMi,
    required this.anasizlikGunSayisi,
    required this.zamanKritik,
    required this.mudahaleGerekli,
    required this.erkekHazirlikYetersiz,
    required this.memeTakibiGecikmis,
    required this.larvaKalitesiDusuk,
    required this.anaUretimIcinUygun,
    required this.durumKodu,
    required this.baslik,
    required this.mesaj,
    required this.larvaKaliteSinifi,
    required this.memeTakipDurumu,
    required this.erkekHazirlikDurumu,
    required this.ciftlesmeDurumu,
    required this.notlar,
    required this.hamVeri,
  });

  Map<String, dynamic> toMap() {
    return {
      'veriVarMi': veriVarMi,
      'anaUretimGirisimVarMi': anaUretimGirisimVarMi,
      'anasizBirakildiMi': anasizBirakildiMi,
      'anasizlikGunSayisi': anasizlikGunSayisi,
      'zamanKritik': zamanKritik,
      'mudahaleGerekli': mudahaleGerekli,
      'erkekHazirlikYetersiz': erkekHazirlikYetersiz,
      'memeTakibiGecikmis': memeTakibiGecikmis,
      'larvaKalitesiDusuk': larvaKalitesiDusuk,
      'anaUretimIcinUygun': anaUretimIcinUygun,
      'durumKodu': durumKodu,
      'baslik': baslik,
      'mesaj': mesaj,
      'larvaKaliteSinifi': larvaKaliteSinifi,
      'memeTakipDurumu': memeTakipDurumu,
      'erkekHazirlikDurumu': erkekHazirlikDurumu,
      'ciftlesmeDurumu': ciftlesmeDurumu,
      'notlar': notlar,
      'hamVeri': hamVeri,
    };
  }
}

class AriBiyolojiServisi {
  static Future<BiyolojiAnalizSonucu> analizYap(int koloniId) async {
    final koloni = await VeritabaniServisi.koloniOzetiGetir(koloniId);
    final muayeneler = await VeritabaniServisi.muayeneleriGetir(koloniId);

    if (koloni.isEmpty || muayeneler.isEmpty) {
      return const BiyolojiAnalizSonucu(
        veriVarMi: false,
        anaUretimGirisimVarMi: false,
        anasizBirakildiMi: false,
        anasizlikGunSayisi: 0,
        zamanKritik: false,
        mudahaleGerekli: false,
        erkekHazirlikYetersiz: false,
        memeTakibiGecikmis: false,
        larvaKalitesiDusuk: false,
        anaUretimIcinUygun: false,
        durumKodu: 'VERI_YOK',
        baslik: 'Biyolojik analiz için veri yok',
        mesaj:
            'Bu koloni için yeterli biyolojik zamanlama verisi bulunmuyor. Yeni muayene kayıtları geldikçe analiz netleşir.',
        larvaKaliteSinifi: 'Kullanılmıyor',
        memeTakipDurumu: 'Bilinmiyor',
        erkekHazirlikDurumu: 'Kullanılmıyor',
        ciftlesmeDurumu: 'Kullanılmıyor',
        notlar: <String>[
          'Henüz muayene verisi yok.',
          'Biyolojik zamanlama yorumları için son muayene kaydı gerekir.',
        ],
        hamVeri: <String, dynamic>{},
      );
    }

    final Map<String, dynamic> son = muayeneler.first;
    // Ana üretim girişimi alanı kullanıcı akışından çıkarıldı.
    // Geriye dönük API uyumu için sonuç modelinde alan korunur, ancak karar üretiminde kullanılmaz.
    const bool anaUretimGirisimVarMi = false;
    final bool anasizBirakildiMi =
        _boolAlan(son, 'anasizBirakildiMi', varsayilan: false);

    final String anasizBaslangicTarihi =
        _stringAlan(son, 'anasizBaslangicTarihi');
    final String memeDurumu = _normalizeMemeDurumu(_stringAlan(son, 'memeDurumu'));
    final String anaKazanmaYontemi = _normalizeAnaKazanmaYontemi(
      _stringAlan(son, 'anaKazanmaYontemi').isNotEmpty
          ? _stringAlan(son, 'anaKazanmaYontemi')
          : (koloni['anaKazanmaYontemi'] ?? '').toString(),
    );

    final int anasizlikGunSayisi = anasizBirakildiMi
        ? anasizlikGunSayisiHesapla(anasizBaslangicTarihi, referans: _simdi())
        : 0;

    final String memeTakipDurumu = anaKazanmaYontemi == 'kapali_meme'
        ? 'Kapalı Meme Takibi'
        : (anaKazanmaYontemi == 'hazir_ana'
            ? 'Hazır Ana Takibi'
            : _memeTakipDurumuHesapla(
                anasizlikGunSayisi: anasizlikGunSayisi,
                memeDurumu: memeDurumu,
                anasizBirakildiMi: anasizBirakildiMi,
              ));

    final bool memeTakibiGecikmis =
        memeTakipDurumu == 'Gecikmiş' || memeTakipDurumu == 'Kritik';
    final int kritikGun = anaKazanmaYontemi == 'hazir_ana'
        ? 10
        : (anaKazanmaYontemi == 'kapali_meme' ? 30 : 8);
    final int mudahaleGun = anaKazanmaYontemi == 'hazir_ana'
        ? 10
        : (anaKazanmaYontemi == 'kapali_meme' ? 30 : 6);

    final bool zamanKritik =
        (anasizBirakildiMi && anasizlikGunSayisi >= kritikGun) || memeTakibiGecikmis;
    final bool mudahaleGerekli =
        zamanKritik || (anasizBirakildiMi && anasizlikGunSayisi >= mudahaleGun);

    final bool anaUretimIcinUygun = anasizBirakildiMi &&
        !memeTakibiGecikmis &&
        !zamanKritik &&
        !mudahaleGerekli;

    final List<String> notlar = <String>[];

    if (!anasizBirakildiMi) {
      notlar.add(
        'Son muayenede anasız bırakma tetiklenmemiş. Biyolojik takvim yalnızca aktif süreç varsa çalışır.',
      );
    }

    if (anasizBirakildiMi) {
      notlar.add('Koloni anasız bırakılmış görünüyor.');
      notlar.add('Anasızlık süresi: $anasizlikGunSayisi gün.');
      if (anaKazanmaYontemi == 'kapali_meme') {
        notlar.add('Ana kazanma yöntemi: kapalı ana memesi. Takvim ileri aşamadan başlatılır.');
      } else if (anaKazanmaYontemi == 'hazir_ana') {
        notlar.add('Ana kazanma yöntemi: hazır çiftleşmiş ana. Meme takvimi çalışmaz.');
      } else {
        notlar.add('Ana kazanma yöntemi: kendi anasını yapacak. Takvim sıfırdan başlatılır.');
      }
    }

    if (memeDurumu != 'Bilinmiyor') {
      notlar.add('Meme durumu: $memeDurumu.');
      notlar.add('Meme takip yorumu: $memeTakipDurumu.');
    } else if (anasizBirakildiMi) {
      notlar.add('Meme durumu girilmediği için zamanlama yorumu sınırlı.');
    }

    final _DurumPaketi durum = _durumUret(
      anasizBirakildiMi: anasizBirakildiMi,
      anasizlikGunSayisi: anasizlikGunSayisi,
      anaUretimIcinUygun: anaUretimIcinUygun,
      mudahaleGerekli: mudahaleGerekli,
      zamanKritik: zamanKritik,
      memeTakibiGecikmis: memeTakibiGecikmis,
    );

    return BiyolojiAnalizSonucu(
      veriVarMi: true,
      anaUretimGirisimVarMi: anaUretimGirisimVarMi,
      anasizBirakildiMi: anasizBirakildiMi,
      anasizlikGunSayisi: anasizlikGunSayisi,
      zamanKritik: zamanKritik,
      mudahaleGerekli: mudahaleGerekli,
      erkekHazirlikYetersiz: false,
      memeTakibiGecikmis: memeTakibiGecikmis,
      larvaKalitesiDusuk: false,
      anaUretimIcinUygun: anaUretimIcinUygun,
      durumKodu: durum.kod,
      baslik: durum.baslik,
      mesaj: durum.mesaj,
      larvaKaliteSinifi: 'Kullanılmıyor',
      memeTakipDurumu: memeTakipDurumu,
      erkekHazirlikDurumu: 'Kullanılmıyor',
      ciftlesmeDurumu: 'Kullanılmıyor',
      notlar: notlar,
      hamVeri: <String, dynamic>{
        'koloniId': koloniId,
        'koloni': koloni,
        'sonMuayene': son,
        'anaUretimGirisimVarMi': anaUretimGirisimVarMi,
        'anasizBirakildiMi': anasizBirakildiMi,
        'anasizBaslangicTarihi': anasizBaslangicTarihi,
        'anasizlikGunSayisi': anasizlikGunSayisi,
        'memeDurumu': memeDurumu,
        'anaKazanmaYontemi': anaKazanmaYontemi,
      },
    );
  }

  static Future<Map<String, dynamic>> analizMapiGetir(int koloniId) async {
    final sonuc = await analizYap(koloniId);
    return sonuc.toMap();
  }

  static int anasizlikGunSayisiHesapla(
    String? anasizBaslangicTarihi, {
    DateTime? referans,
  }) {
    final metin = (anasizBaslangicTarihi ?? '').trim();
    if (metin.isEmpty) return 0;

    final DateTime? baslangic = _guvenliTarihParse(metin);
    if (baslangic == null) return 0;

    final DateTime bugun = _temizTarih(referans ?? _simdi());
    final int fark = bugun.difference(_temizTarih(baslangic)).inDays;
    return fark < 0 ? 0 : fark;
  }

  static DateTime _simdi() => DateTime.now();

  static DateTime _temizTarih(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  static DateTime? _guvenliTarihParse(String metin) {
    final temiz = metin.trim();
    if (temiz.isEmpty) return null;

    final dogrudan = DateTime.tryParse(temiz);
    if (dogrudan != null) {
      return DateTime(dogrudan.year, dogrudan.month, dogrudan.day);
    }

    if (temiz.contains('.')) {
      final p = temiz.split('.');
      if (p.length == 3) {
        final gun = int.tryParse(p[0]) ?? 1;
        final ay = int.tryParse(p[1]) ?? 1;
        final yil = int.tryParse(p[2]) ?? DateTime.now().year;
        return DateTime(yil, ay, gun);
      }
    }

    return null;
  }

  static String _normalizeAnaKazanmaYontemi(dynamic deger) {
    final temiz = (deger ?? '').toString().trim().toLowerCase();
    if (temiz == 'kapali_meme' || temiz == 'kapalı ana memesi var' || temiz == 'kapali ana memesi var') {
      return 'kapali_meme';
    }
    if (temiz == 'hazir_ana' || temiz == 'hazır çiftleşmiş ana verildi' || temiz == 'hazir ciftlesmis ana verildi') {
      return 'hazir_ana';
    }
    return 'kendi_anasi';
  }

  static String _memeTakipDurumuHesapla({
    required int anasizlikGunSayisi,
    required String memeDurumu,
    required bool anasizBirakildiMi,
  }) {
    if (!anasizBirakildiMi) {
      return 'Takip Yok';
    }

    if (anasizlikGunSayisi <= 0) {
      return 'Yeni Başladı';
    }

    if (anasizlikGunSayisi <= 2) {
      return 'Erken Pencere';
    }

    if (anasizlikGunSayisi <= 5) {
      if (memeDurumu == 'Yok' || memeDurumu == 'Bilinmiyor') {
        return 'Dikkat';
      }
      return 'Takipte';
    }

    if (anasizlikGunSayisi <= 7) {
      if (memeDurumu == 'Kapalı' || memeDurumu == 'Açık + Kapalı') {
        return 'Yakın Takip';
      }
      if (memeDurumu == 'Yok') {
        return 'Gecikmiş';
      }
      return 'Takipte';
    }

    if (memeDurumu == 'Yok' || memeDurumu == 'Bilinmiyor') {
      return 'Kritik';
    }

    return 'Gecikmiş';
  }

  static _DurumPaketi _durumUret({
    required bool anasizBirakildiMi,
    required int anasizlikGunSayisi,
    required bool anaUretimIcinUygun,
    required bool mudahaleGerekli,
    required bool zamanKritik,
    required bool memeTakibiGecikmis,
  }) {
    if (!anasizBirakildiMi) {
      return const _DurumPaketi(
        kod: 'TAKIP_YOK',
        baslik: 'Biyolojik zamanlama takibi pasif',
        mesaj:
            'Bu koloni için son muayenede anasız bırakma süreci işaretlenmemiş. Biyolojik takvim yalnızca süreç tetikleri üzerinden yorum üretir.',
      );
    }

    if (zamanKritik) {
      return _DurumPaketi(
        kod: 'ZAMAN_KRITIK',
        baslik: 'Zamanlama kritik',
        mesaj:
            'Anasızlık süresi $anasizlikGunSayisi güne ulaşmış olabilir veya meme takibi gecikmiş görünüyor. Bu koloni sahada öncelikli kontrol edilmelidir.',
      );
    }

    if (mudahaleGerekli) {
      return const _DurumPaketi(
        kod: 'MUDAHALE_GEREKLI',
        baslik: 'Biyolojik müdahale gerekli',
        mesaj:
            'Süreç normal akışından çıkmış görünüyor. Ana durumu, günlük/kapalı yavru ve meme takibi sahada yeniden doğrulanmalıdır.',
      );
    }

    if (memeTakibiGecikmis) {
      return const _DurumPaketi(
        kod: 'MEME_TAKIP_DIKKAT',
        baslik: 'Meme takibi dikkat istiyor',
        mesaj:
            'Meme gelişim süreci takvime göre yeniden kontrol edilmelidir. Gecikme veya gözden kaçma riski vardır.',
      );
    }

    if (anaUretimIcinUygun) {
      return const _DurumPaketi(
        kod: 'UYGUN',
        baslik: 'Ana üretimi için zamanlama uygun',
        mesaj:
            'Mevcut kayıtlar temel zamanlama açısından sorun göstermiyor. Süreç sahada takvime uygun ilerliyor olabilir.',
      );
    }

    return const _DurumPaketi(
      kod: 'IZLE',
      baslik: 'Biyolojik süreç izlenmeli',
      mesaj:
          'Süreç tamamen olumsuz görünmüyor; karar için yeni muayene verisiyle zaman penceresi izlenmelidir.',
    );
  }

  static bool _boolAlan(
    Map<String, dynamic> veri,
    String anahtar, {
    bool varsayilan = false,
  }) {
    final dynamic deger = veri[anahtar];
    if (deger == null) return varsayilan;
    if (deger is bool) return deger;
    if (deger is int) return deger == 1;
    if (deger is double) return deger.round() == 1;

    final metin = deger.toString().trim().toLowerCase();
    if (metin == '1' || metin == 'true' || metin == 'evet') return true;
    if (metin == '0' || metin == 'false' || metin == 'hayir' || metin == 'hayır') {
      return false;
    }
    return varsayilan;
  }

  static String _stringAlan(Map<String, dynamic> veri, String anahtar) {
    return (veri[anahtar] ?? '').toString().trim();
  }

  static String _normalizeMemeDurumu(String deger) {
    final temiz = deger.trim().toLowerCase();
    if (temiz.isEmpty) return 'Bilinmiyor';
    if (temiz == 'yok') return 'Yok';
    if (temiz == 'açık' || temiz == 'acik') return 'Açık';
    if (temiz == 'kapalı' || temiz == 'kapali') return 'Kapalı';
    if (temiz == 'açık+kapalı' ||
        temiz == 'acik+kapali' ||
        temiz == 'açık + kapalı' ||
        temiz == 'acik + kapali') {
      return 'Açık + Kapalı';
    }
    return 'Bilinmiyor';
  }
}

class _DurumPaketi {
  final String kod;
  final String baslik;
  final String mesaj;

  const _DurumPaketi({
    required this.kod,
    required this.baslik,
    required this.mesaj,
  });
}
