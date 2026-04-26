
import 'performans_ozeti_servisi.dart';
import 'karar_asistan_servisi.dart';
import 'veritabani_servisi.dart';

class KarsilastirmaKoloniOzet {
  final int koloniId;
  final String kovanNo;

  final int genelSkor;
  final bool donorMu;
  final int? donorSirasi;

  final bool vetoVarMi;
  final String vetoOzeti;

  final int donorSkoru;
  final String sistemYorumu;

  final Map<String, int> kriterSkorlari;
  final Map<String, String> kriterYorumlari;

  final String kisCikisYorumu;
  final String secilimBaslik;
  final String secilimMesaji;
  final String anaKararBaslik;
  final String anaKararMesaji;

  final String biyolojiBaslik;
  final String biyolojiMesaji;
  final String biyolojiDurumKodu;
  final String erkekHazirlikDurumu;
  final String memeTakipDurumu;
  final String larvaKaliteSinifi;
  final String ciftlesmeDurumu;
  final int anasizlikGunSayisi;
  final bool biyolojiZamanKritik;
  final bool biyolojiAnaUretimineUygun;

  const KarsilastirmaKoloniOzet({
    required this.koloniId,
    required this.kovanNo,
    required this.genelSkor,
    required this.donorMu,
    required this.donorSirasi,
    required this.vetoVarMi,
    required this.vetoOzeti,
    required this.donorSkoru,
    required this.sistemYorumu,
    required this.kriterSkorlari,
    required this.kriterYorumlari,
    required this.kisCikisYorumu,
    required this.secilimBaslik,
    required this.secilimMesaji,
    required this.anaKararBaslik,
    required this.anaKararMesaji,
    required this.biyolojiBaslik,
    required this.biyolojiMesaji,
    required this.biyolojiDurumKodu,
    required this.erkekHazirlikDurumu,
    required this.memeTakipDurumu,
    required this.larvaKaliteSinifi,
    required this.ciftlesmeDurumu,
    required this.anasizlikGunSayisi,
    required this.biyolojiZamanKritik,
    required this.biyolojiAnaUretimineUygun,
  });
}

class KarsilastirmaHucre {
  final String deger;
  final int renkSkoru;
  final String yorum;

  const KarsilastirmaHucre({
    required this.deger,
    required this.renkSkoru,
    required this.yorum,
  });
}

class KarsilastirmaSatiri {
  final String baslik;
  final List<KarsilastirmaHucre> hucreler;

  const KarsilastirmaSatiri({
    required this.baslik,
    required this.hucreler,
  });
}

class KarsilastirmaSonucu {
  final List<KarsilastirmaKoloniOzet> koloniler;
  final List<KarsilastirmaSatiri> satirlar;
  final List<String> sistemYorumu;

  const KarsilastirmaSonucu({
    required this.koloniler,
    required this.satirlar,
    required this.sistemYorumu,
  });
}

class KarsilastirmaOzetiServisi {
  static Future<KarsilastirmaSonucu> getir(List<int> koloniIdleri) async {
    final secilenler = koloniIdleri.toSet().where((e) => e > 0).take(3).toList();

    if (secilenler.isEmpty) {
      return const KarsilastirmaSonucu(
        koloniler: [],
        satirlar: [],
        sistemYorumu: [],
      );
    }

    final List<KarsilastirmaKoloniOzet> koloniler = [];

    for (final koloniId in secilenler) {
      final koloni = await VeritabaniServisi.koloniOzetiGetir(koloniId);
      final performans = await PerformansOzetiServisi.getir(koloniId);
      final anaKarar = await KararAsistanServisi.anaKararUret(koloniId, koloni);
      final secilim =
      await KararAsistanServisi.secilimDurumuGetir(koloniId, koloni);
      final biyoloji = await KararAsistanServisi.biyolojiDurumuGetir(koloniId);

      final Map<String, int> kriterSkorlari = {};
      final Map<String, String> kriterYorumlari = {};

      for (final kriter in performans.kriterler) {
        kriterSkorlari[kriter.ad] = kriter.skor;
        kriterYorumlari[kriter.ad] = kriter.yorum;
      }

      koloniler.add(
        KarsilastirmaKoloniOzet(
          koloniId: koloniId,
          kovanNo: (koloni['kovanNo'] ?? '-').toString(),
          genelSkor: performans.genelSkor,
          donorMu: performans.donorMu,
          donorSirasi: performans.donorSirasi,
          vetoVarMi: performans.vetoVarMi,
          vetoOzeti: _vetoOzetiGetir(performans),
          donorSkoru: performans.donorSkoru,
          sistemYorumu: performans.genelYorum,
          kriterSkorlari: kriterSkorlari,
          kriterYorumlari: kriterYorumlari,
          kisCikisYorumu: _kisCikisYorumuGetir(performans),
          secilimBaslik: (secilim['baslik'] ?? '-').toString(),
          secilimMesaji: (secilim['mesaj'] ?? '').toString(),
          anaKararBaslik: (anaKarar['baslik'] ?? '-').toString(),
          anaKararMesaji: (anaKarar['mesaj'] ?? '').toString(),
          biyolojiBaslik: (biyoloji['baslik'] ?? '-').toString(),
          biyolojiMesaji: (biyoloji['mesaj'] ?? '').toString(),
          biyolojiDurumKodu: (biyoloji['durumKodu'] ?? '-').toString(),
          erkekHazirlikDurumu:
          (biyoloji['erkekHazirlikDurumu'] ?? 'Bilinmiyor').toString(),
          memeTakipDurumu:
          (biyoloji['memeTakipDurumu'] ?? 'Bilinmiyor').toString(),
          larvaKaliteSinifi:
          (biyoloji['larvaKaliteSinifi'] ?? 'Bilinmiyor').toString(),
          ciftlesmeDurumu:
          (biyoloji['ciftlesmeDurumu'] ?? 'Bilinmiyor').toString(),
          anasizlikGunSayisi: _toInt(biyoloji['anasizlikGunSayisi']),
          biyolojiZamanKritik: biyoloji['zamanKritik'] == true,
          biyolojiAnaUretimineUygun: biyoloji['anaUretimIcinUygun'] == true,
        ),
      );
    }

    final satirlar = <KarsilastirmaSatiri>[
      _genetikSecilimSatiri(koloniler),
      _performansSatiri(koloniler),
      _kriterSatiri(koloniler, 'Üreme'),
      _kriterSatiri(koloniler, 'Üretim'),
      _kriterSatiri(koloniler, 'Dayanıklılık'),
      _kriterSatiri(koloniler, 'Kıştan Çıkış'),
      _kriterSatiri(koloniler, 'Davranış'),
      _kriterSatiri(koloniler, 'Hat Gücü'),
      _kriterSatiri(koloniler, 'Veri Güveni'),
      _biyolojiDurumuSatiri(koloniler),
      _memeTakipSatiri(koloniler),
      _anasizlikSatiri(koloniler),
      _genetikVetoSatiri(koloniler),
    ];

    return KarsilastirmaSonucu(
      koloniler: koloniler,
      satirlar: satirlar,
      sistemYorumu: _siralamaYorumuUret(koloniler),
    );
  }

  static KarsilastirmaSatiri _genetikSecilimSatiri(
      List<KarsilastirmaKoloniOzet> koloniler,
      ) {
    return KarsilastirmaSatiri(
      baslik: 'Genetik Seçilim',
      hucreler: koloniler.map((k) {
        final String deger;
        final String yorum;

        if (k.vetoVarMi) {
          deger = 'Veto';
          yorum = k.vetoOzeti.isEmpty
              ? 'Temiz donör havuzuna giremez'
              : k.vetoOzeti;
        } else if (k.donorMu && k.donorSirasi != null) {
          deger = '#${k.donorSirasi}';
          yorum = 'Temiz donör havuzunda';
        } else {
          deger = 'Uygun değil';
          yorum = 'Genetik seçilimde ilk sırada değil';
        }

        return KarsilastirmaHucre(
          deger: deger,
          renkSkoru: _donorRenkSkoru(k),
          yorum: yorum,
        );
      }).toList(),
    );
  }

  static KarsilastirmaSatiri _performansSatiri(
      List<KarsilastirmaKoloniOzet> koloniler,
      ) {
    return KarsilastirmaSatiri(
      baslik: 'Performans',
      hucreler: koloniler.map((k) {
        return KarsilastirmaHucre(
          deger: k.genelSkor.toString(),
          renkSkoru: k.genelSkor,
          yorum: _genelSkorYorumu(k.genelSkor),
        );
      }).toList(),
    );
  }

  static KarsilastirmaSatiri _kriterSatiri(
      List<KarsilastirmaKoloniOzet> koloniler,
      String kriterAdi,
      ) {
    return KarsilastirmaSatiri(
      baslik: kriterAdi,
      hucreler: koloniler.map((k) {
        final skor = k.kriterSkorlari[kriterAdi] ?? 0;
        final yorum = k.kriterYorumlari[kriterAdi] ?? '-';
        return KarsilastirmaHucre(
          deger: skor.toString(),
          renkSkoru: skor,
          yorum: yorum,
        );
      }).toList(),
    );
  }

  static KarsilastirmaSatiri _biyolojiDurumuSatiri(
      List<KarsilastirmaKoloniOzet> koloniler,
      ) {
    return KarsilastirmaSatiri(
      baslik: 'Biyoloji Durumu',
      hucreler: koloniler.map((k) {
        int skor = 50;
        if (k.biyolojiZamanKritik) skor = 10;
        if (k.biyolojiAnaUretimineUygun) skor = 92;
        if (!k.biyolojiZamanKritik &&
            !k.biyolojiAnaUretimineUygun &&
            k.biyolojiDurumKodu != 'VERI_YOK') {
          skor = 60;
        }
        return KarsilastirmaHucre(
          deger: k.biyolojiBaslik,
          renkSkoru: skor,
          yorum: k.biyolojiMesaji.isEmpty ? '-' : k.biyolojiMesaji,
        );
      }).toList(),
    );
  }


  static KarsilastirmaSatiri _memeTakipSatiri(
      List<KarsilastirmaKoloniOzet> koloniler,
      ) {
    return KarsilastirmaSatiri(
      baslik: 'Meme Takibi',
      hucreler: koloniler.map((k) {
        return KarsilastirmaHucre(
          deger: k.memeTakipDurumu,
          renkSkoru: _biyolojiMetinSkoru(k.memeTakipDurumu),
          yorum: 'Zamanlama ve meme gelişimi',
        );
      }).toList(),
    );
  }


  static KarsilastirmaSatiri _anasizlikSatiri(
      List<KarsilastirmaKoloniOzet> koloniler,
      ) {
    return KarsilastirmaSatiri(
      baslik: 'Anasızlık (gün)',
      hucreler: koloniler.map((k) {
        final deger =
        k.anasizlikGunSayisi <= 0 ? '-' : k.anasizlikGunSayisi.toString();
        final renk = k.anasizlikGunSayisi >= 8
            ? 10
            : k.anasizlikGunSayisi >= 6
            ? 35
            : k.anasizlikGunSayisi > 0
            ? 60
            : 70;
        return KarsilastirmaHucre(
          deger: deger,
          renkSkoru: renk,
          yorum: k.anasizlikGunSayisi > 0
              ? 'Anasızlık süresi biyolojik karar için kritiktir'
              : 'Aktif anasızlık verisi yok',
        );
      }).toList(),
    );
  }


  static KarsilastirmaSatiri _genetikVetoSatiri(
      List<KarsilastirmaKoloniOzet> koloniler,
      ) {
    return KarsilastirmaSatiri(
      baslik: 'Genetik Veto',
      hucreler: koloniler.map((k) {
        return KarsilastirmaHucre(
          deger: k.vetoVarMi ? 'Var' : 'Yok',
          renkSkoru: k.vetoVarMi ? 10 : 90,
          yorum: k.vetoVarMi ? k.vetoOzeti : 'Temiz donör havuzunda',
        );
      }).toList(),
    );
  }

  static List<String> _siralamaYorumuUret(
      List<KarsilastirmaKoloniOzet> koloniler,
      ) {
    if (koloniler.isEmpty) return [];

    final List<String> yorumlar = [];

    final performansSirali = [...koloniler]
      ..sort((a, b) => b.genelSkor.compareTo(a.genelSkor));
    final performansLideri = performansSirali.first;
    yorumlar.add(
      'Genel performans lideri şu an Kovan ${performansLideri.kovanNo} görünüyor.',
    );

    if (performansLideri.vetoVarMi) {
      yorumlar.add(
        'Ancak bu koloni genetik seçilimde veto aldığı için, performans lideri olsa bile temiz donör havuzuna giremez.',
      );
    }

    final temizDonorler = koloniler
        .where((k) => !k.vetoVarMi && k.donorMu)
        .toList()
      ..sort((a, b) {
        final aSira = a.donorSirasi ?? 999;
        final bSira = b.donorSirasi ?? 999;
        if (aSira != bSira) return aSira.compareTo(bSira);
        return b.genelSkor.compareTo(a.genelSkor);
      });

    if (temizDonorler.isNotEmpty) {
      final lider = temizDonorler.first;
      yorumlar.add(
        'Temiz donör havuzunda önde görünen koloni Kovan ${lider.kovanNo}${lider.donorSirasi != null ? ' (#${lider.donorSirasi})' : ''}.',
      );

      if (lider.biyolojiZamanKritik) {
        yorumlar.add(
          'Bu koloni genetik seçilimde önde görünse de biyolojik zamanlama kritik uyarısı taşıyor; saha kontrolü yapılmadan ana üretimi kararı verilmemelidir.',
        );
      } else if (lider.biyolojiAnaUretimineUygun) {
        yorumlar.add(
          'Bu koloni biyolojik zamanlama açısından da uygun göründüğü için ana üretimi tarafında güçlü adaydır.',
        );
      }
    } else {
      yorumlar.add(
        'Seçilen koloniler içinde temiz donör havuzunda öne çıkan bir koloni görünmüyor.',
      );
    }

    for (final k in koloniler) {
      if (k.vetoVarMi) {
        yorumlar.add(
          'Kovan ${k.kovanNo}, ${k.vetoOzeti.isEmpty ? 'genetik veto' : k.vetoOzeti} nedeniyle donör havuzunun dışında kalıyor.',
        );
      }
    }

    return yorumlar;
  }

  static String _vetoOzetiGetir(PerformansOzeti performans) {
    final vetoMetni = (performans.vetoNedeni ?? '').trim();
    if (vetoMetni.isEmpty) return '';

    final dusuk = vetoMetni.toLowerCase();

    if (dusuk.contains('oğul attığı') || dusuk.contains('ogul attigi')) {
      return 'Kendisi oğul attı';
    }
    if (dusuk.contains('oğul kökenli') || dusuk.contains('ogul kokenli')) {
      return 'Oğul kökenli';
    }
    if (dusuk.contains('soy hattında') || dusuk.contains('üst soydaki')) {
      return 'Ata hatta oğul izi';
    }

    return 'Genetik veto';
  }

  static String _kisCikisYorumuGetir(PerformansOzeti performans) {
    final yorum =
    (performans.hamProfil['kisCikisYorum'] ?? '').toString().trim();
    if (yorum.isNotEmpty) return yorum;

    final veriVar =
        (performans.hamProfil['kisCikisVeriYeterliMi'] ?? false) == true;
    return veriVar ? '-' : 'Veri yok';
  }

  static int _donorRenkSkoru(KarsilastirmaKoloniOzet k) {
    if (k.vetoVarMi) return 10;
    if (k.donorMu && (k.donorSirasi ?? 99) <= 3) return 95;
    if (k.donorMu) return 80;
    return 45;
  }

  static String _genelSkorYorumu(int skor) {
    if (skor >= 85) return 'Çok güçlü';
    if (skor >= 70) return 'Güçlü';
    if (skor >= 50) return 'Orta';
    return 'Zayıf';
  }

  static int _biyolojiMetinSkoru(String metin) {
    final t = metin.trim().toLowerCase();
    if (t.contains('uygun')) return 90;
    if (t.contains('kritik') || t.contains('müdahale')) return 10;
    if (t.contains('dikkat')) return 40;
    if (t.contains('izlenmeli')) return 55;
    if (t.contains('yetersiz')) return 25;
    return 50;
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }
}
