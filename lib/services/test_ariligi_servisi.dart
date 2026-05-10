import 'veritabani_servisi.dart';
import 'karar_asistan_servisi.dart';
import 'arilik_uyari_servisi.dart';

class TestAriligiSonucu {
  final int arilikId;
  final int koloniSayisi;
  final bool oncekiTestAriligiSilindi;

  const TestAriligiSonucu({
    required this.arilikId,
    required this.koloniSayisi,
    required this.oncekiTestAriligiSilindi,
  });
}

class TestAriligiServisi {
  static const String testAriligiAdi = 'ITOGENA_TEST_ARILIGI';

  static Future<TestAriligiSonucu> olusturVeyaYenile() async {
    final mevcutlar = await VeritabaniServisi.ariliklariGetir();
    bool silindi = false;

    for (final arilik in mevcutlar) {
      final ad = (arilik['ad'] ?? '').toString().trim();
      final id = _toInt(arilik['id']);
      if (ad == testAriligiAdi && id > 0) {
        await VeritabaniServisi.arilikSil(id);
        silindi = true;
      }
    }

    final arilikId = await VeritabaniServisi.arilikEkle(
      testAriligiAdi,
      konum: 'Test verisi - gerçek arılık değildir',
      kurulusTarihi: _iso(_gun(DateTime.now()).subtract(const Duration(days: 460))),
    );

    final olusturulanIdler = <int>[];

    Future<int> ekle({
      required String no,
      required int sira,
      required String kaynakTipi,
      int? kaynakKoloniId,
      required int anaYili,
      required int sonCita,
      required int maxCita,
      int balCita = 0,
      String mizac = 'Sakin',
      String yavruDuzeni = 'Normal',
      String durum = 'aktif',
      int olusturmaGunOnce = 260,
      String not = '',
      List<Map<String, dynamic>> muayeneler = const [],
    }) async {
      final olusturma = _gun(DateTime.now()).subtract(Duration(days: olusturmaGunOnce));
      final id = await VeritabaniServisi.koloniEkle({
        'arilikId': arilikId,
        'kovanNo': no,
        'ilkKovanNo': no,
        'anaYili': anaYili.toString(),
        'kaynakTipi': kaynakTipi,
        'kaynakKoloni': kaynakKoloniId != null && kaynakKoloniId > 0 ? kaynakKoloniId.toString() : '',
        'kaynakKoloniId': kaynakKoloniId,
        'ebeveynKoloniId': kaynakKoloniId,
        'anaKazanmaYontemi': kaynakTipi == 'Bölme' ? 'kendi_anasi' : '',
        'genetik': '',
        'rol': 'Test',
        'durum': durum,
        'olusturmaTarihi': _iso(olusturma),
        'sonCita': sonCita,
        'maxCitaKapasiye': maxCita,
        'bal_cita': balCita,
        'skor': 0,
        'sahaSirasi': sira,
        'notMetni': 'TEST SENARYOSU: $not',
      });

      for (final m in muayeneler) {
        final veri = _muayene(
          koloniId: id,
          gunOnce: _toInt(m['gunOnce']),
          cita: _toInt(m['cita']),
          bal: _toInt(m['bal']),
          yavrulu: _toInt(m['yavrulu']),
          yavruDuzeni: (m['yavruDuzeni'] ?? yavruDuzeni).toString(),
          mizac: (m['mizac'] ?? mizac).toString(),
          besleme: (m['besleme'] ?? 'Yok').toString(),
          varroa: (m['varroa'] ?? 'Yok').toString(),
          anaAriGoruldu: m.containsKey('anaAriGoruldu') ? _toInt(m['anaAriGoruldu']) : 1,
          varroaGoruldu: _toInt(m['varroaGoruldu']),
          ogulBelirtisi: _toInt(m['ogulBelirtisi']),
          ogulAtti: _toInt(m['ogulAtti']),
          bolmeYapildi: _toInt(m['bolmeYapildi']),
          kovanSondu: _toInt(m['kovanSondu']),
          anasizBirakildiMi: _toInt(m['anasizBirakildiMi']),
          anaKazanmaYontemi: (m['anaKazanmaYontemi'] ?? 'kendi_anasi').toString(),
          kapaliYavruluCitaAktarildi: _toInt(m['kapaliYavruluCitaAktarildi']),
          disaridanHazirAnaVerildi: _toInt(m['disaridanHazirAnaVerildi']),
          gunlukKapaliYavruGoruldu: _toInt(m['gunlukKapaliYavruGoruldu']),
          anaDegisimPlanlandiMi: _toInt(m['anaDegisimPlanlandiMi']),
          memeDurumu: (m['memeDurumu'] ?? '').toString(),
          notlar: (m['notlar'] ?? not).toString(),
        );
        await VeritabaniServisi.muayeneEkle(veri);
      }

      olusturulanIdler.add(id);
      return id;
    }

    final temizDonor = await ekle(
      no: 'T01', sira: 1, kaynakTipi: 'Ana Hat', anaYili: 2025,
      sonCita: 11, maxCita: 12, balCita: 4, not: 'Veri güveni yüksek, temiz soy, donör aday kontrolü.',
      muayeneler: _gelisimSerisi(11, 4, 6),
    );

    final ogulGecmisliKok = await ekle(
      no: 'T02', sira: 2, kaynakTipi: 'Ana Hat', anaYili: 2025,
      sonCita: 11, maxCita: 12, balCita: 4, not: 'Güçlü ama oğul atmış; donör veto, üretimde kullanılabilir.',
      muayeneler: [
        ..._gelisimSerisi(11, 4, 5),
        {'gunOnce': 18, 'cita': 11, 'bal': 2, 'yavrulu': 7, 'ogulAtti': 1, 'notlar': 'Oğul attı geçmişi.'},
      ],
    );

    await ekle(no: 'T03', sira: 3, kaynakTipi: 'Ana Hat', anaYili: 2025, sonCita: 3, maxCita: 3, not: '3 çıta zayıf koloni.', muayeneler: _gelisimSerisi(3, 0, 2));
    await ekle(no: 'T04', sira: 4, kaynakTipi: 'Ana Hat', anaYili: 2025, sonCita: 5, maxCita: 5, not: '5 çıta; bölme kesin uygun değil.', muayeneler: _gelisimSerisi(5, 0, 2));
    await ekle(no: 'T05', sira: 5, kaynakTipi: 'Ana Hat', anaYili: 2025, sonCita: 7, maxCita: 7, not: '7 çıta; bölme biyolojik olarak mümkün görünse de sistem önermemeli.', muayeneler: _gelisimSerisi(7, 1, 3));
    await ekle(no: 'T06', sira: 6, kaynakTipi: 'Ana Hat', anaYili: 2025, sonCita: 8, maxCita: 8, not: '8 çıta sınır; riskli, bölme önerilmemeli.', muayeneler: _gelisimSerisi(8, 1, 3));
    await ekle(no: 'T07', sira: 7, kaynakTipi: 'Ana Hat', anaYili: 2025, sonCita: 9, maxCita: 9, not: '9 çıta; güvenli bölme adayı.', muayeneler: _gelisimSerisi(9, 2, 4));
    await ekle(no: 'T08', sira: 8, kaynakTipi: 'Ana Hat', anaYili: 2025, sonCita: 10, maxCita: 10, not: '10 çıta güçlü bölme adayı.', muayeneler: _gelisimSerisi(10, 3, 5));
    await ekle(no: 'T09', sira: 9, kaynakTipi: 'Ana Hat', anaYili: 2024, sonCita: 10, maxCita: 11, mizac: 'Saldırgan', not: 'Güçlü ama saldırgan; mizaç tamamen nötrlenmemeli.', muayeneler: _gelisimSerisi(10, 3, 5, mizac: 'Saldırgan'));
    await ekle(no: 'T10', sira: 10, kaynakTipi: 'Oğul', kaynakKoloniId: ogulGecmisliKok, anaYili: 2025, sonCita: 10, maxCita: 11, balCita: 3, not: 'Oğul kökenli güçlü koloni; donör veto, üretim uygun.', muayeneler: _gelisimSerisi(10, 3, 5));
    await ekle(no: 'T11', sira: 11, kaynakTipi: 'Bölme', kaynakKoloniId: ogulGecmisliKok, anaYili: 2025, sonCita: 10, maxCita: 10, not: 'Atasal hatta oğul izi; donör veto kontrolü.', muayeneler: _gelisimSerisi(10, 2, 5));
    await ekle(no: 'T12', sira: 12, kaynakTipi: 'Bölme', kaynakKoloniId: temizDonor, anaYili: 2025, sonCita: 8, maxCita: 8, not: 'Temiz soy ama 8 çıta; donör/bölme ayrımı kontrolü.', muayeneler: _gelisimSerisi(8, 1, 4));

    await ekle(no: 'T13', sira: 13, kaynakTipi: 'Ana Hat', anaYili: 2025, sonCita: 8, maxCita: 8, not: 'Besleme var ve gelişim var; ceza yok, küçük yönetim sinyali.', muayeneler: [
      {'gunOnce': 24, 'cita': 5, 'bal': 0, 'yavrulu': 3, 'besleme': '1:1 Şurup'},
      {'gunOnce': 12, 'cita': 7, 'bal': 0, 'yavrulu': 4, 'besleme': '1:1 Şurup'},
      {'gunOnce': 2, 'cita': 8, 'bal': 1, 'yavrulu': 5, 'besleme': 'Yok'},
    ]);
    await ekle(no: 'T14', sira: 14, kaynakTipi: 'Ana Hat', anaYili: 2025, sonCita: 4, maxCita: 4, not: 'Besleme var ama gelişim yok; olumlu okunmamalı.', muayeneler: [
      {'gunOnce': 28, 'cita': 4, 'bal': 0, 'yavrulu': 2, 'besleme': '1:1 Şurup'},
      {'gunOnce': 14, 'cita': 4, 'bal': 0, 'yavrulu': 2, 'besleme': '1:1 Şurup'},
      {'gunOnce': 2, 'cita': 4, 'bal': 0, 'yavrulu': 2, 'besleme': '1:1 Şurup'},
    ]);
    await ekle(no: 'T15', sira: 15, kaynakTipi: 'Ana Hat', anaYili: 2025, sonCita: 9, maxCita: 9, balCita: 0, not: 'Kıştan güçlü çıkan, bal düşük; kışta bal performans olmamalı.', olusturmaGunOnce: 430, muayeneler: [
      {'gunOnce': 170, 'cita': 6, 'bal': 0, 'yavrulu': 1},
      {'gunOnce': 45, 'cita': 9, 'bal': 0, 'yavrulu': 3},
    ]);
    await ekle(no: 'T16', sira: 16, kaynakTipi: 'Ana Hat', anaYili: 2024, sonCita: 3, maxCita: 4, balCita: 5, not: 'Bal çok ama canlı güç zayıf; kış skorunda bal etkisiz olmalı.', olusturmaGunOnce: 430, muayeneler: [
      {'gunOnce': 170, 'cita': 4, 'bal': 5, 'yavrulu': 1},
      {'gunOnce': 45, 'cita': 3, 'bal': 5, 'yavrulu': 1},
    ]);

    await ekle(no: 'T17', sira: 17, kaynakTipi: 'Ana Hat', anaYili: 2025, sonCita: 6, maxCita: 6, not: 'Ana görülmedi açık işaretli koloni.', muayeneler: [
      {'gunOnce': 5, 'cita': 6, 'bal': 0, 'yavrulu': 0, 'anaAriGoruldu': 0, 'notlar': 'Ana görülmedi açık işaretli.'},
    ]);
    await ekle(no: 'T18', sira: 18, kaynakTipi: 'Ana Hat', anaYili: 2025, sonCita: 6, maxCita: 6, not: 'Eski kayıt anaAriGoruldu 0; otomatik ağır ceza üretmemeli.', muayeneler: [
      {'gunOnce': 90, 'cita': 6, 'bal': 0, 'yavrulu': 4, 'anaAriGoruldu': 0, 'notlar': 'Eski kayıt simülasyonu.'},
    ]);
    await ekle(no: 'T19', sira: 19, kaynakTipi: 'Ana Hat', anaYili: 2025, sonCita: 7, maxCita: 7, not: 'Günlük/kapalı yavru görüldü; ana varlığı dolaylı kabul.', muayeneler: [
      {'gunOnce': 20, 'cita': 6, 'bal': 0, 'yavrulu': 0, 'anasizBirakildiMi': 1, 'anaKazanmaYontemi': 'kendi_anasi'},
      {'gunOnce': 1, 'cita': 7, 'bal': 0, 'yavrulu': 4, 'gunlukKapaliYavruGoruldu': 1},
    ]);

    await ekle(no: 'T20', sira: 20, kaynakTipi: 'Bölme', kaynakKoloniId: temizDonor, anaYili: 2026, sonCita: 4, maxCita: 4, olusturmaGunOnce: 5, not: 'Bölme sonrası 5. gün; kapalı meme kontrolü.', muayeneler: [
      {'gunOnce': 5, 'cita': 4, 'bal': 0, 'yavrulu': 2, 'anasizBirakildiMi': 1, 'anaKazanmaYontemi': 'kendi_anasi'},
    ]);
    await ekle(no: 'T21', sira: 21, kaynakTipi: 'Bölme', kaynakKoloniId: temizDonor, anaYili: 2026, sonCita: 4, maxCita: 4, olusturmaGunOnce: 20, not: 'Bölme sonrası 20. gün; kovanı gereksiz açmama dönemi.', muayeneler: [
      {'gunOnce': 20, 'cita': 4, 'bal': 0, 'yavrulu': 2, 'anasizBirakildiMi': 1, 'anaKazanmaYontemi': 'kendi_anasi'},
    ]);
    await ekle(no: 'T22', sira: 22, kaynakTipi: 'Ana Hat', anaYili: 2026, sonCita: 5, maxCita: 5, olusturmaGunOnce: 3, not: 'Anasız 3. gün.', muayeneler: [
      {'gunOnce': 3, 'cita': 5, 'bal': 0, 'yavrulu': 2, 'anasizBirakildiMi': 1, 'anaKazanmaYontemi': 'kendi_anasi'},
    ]);
    await ekle(no: 'T23', sira: 23, kaynakTipi: 'Ana Hat', anaYili: 2026, sonCita: 5, maxCita: 5, olusturmaGunOnce: 16, not: 'Anasız 16. gün; ana çıkışı beklenen pencere.', muayeneler: [
      {'gunOnce': 16, 'cita': 5, 'bal': 0, 'yavrulu': 2, 'anasizBirakildiMi': 1, 'anaKazanmaYontemi': 'kendi_anasi'},
    ]);
    await ekle(no: 'T24', sira: 24, kaynakTipi: 'Ana Hat', anaYili: 2026, sonCita: 5, maxCita: 5, olusturmaGunOnce: 27, not: 'Anasız 27. gün; yumurtlama kontrolü yaklaşır.', muayeneler: [
      {'gunOnce': 27, 'cita': 5, 'bal': 0, 'yavrulu': 1, 'anasizBirakildiMi': 1, 'anaKazanmaYontemi': 'kendi_anasi'},
    ]);
    await ekle(no: 'T25', sira: 25, kaynakTipi: 'Ana Hat', anaYili: 2026, sonCita: 5, maxCita: 5, olusturmaGunOnce: 2, not: 'Hazır ana 2. gün; kabul kontrolü.', muayeneler: [
      {'gunOnce': 2, 'cita': 5, 'bal': 0, 'yavrulu': 2, 'disaridanHazirAnaVerildi': 1, 'anaKazanmaYontemi': 'hazir_ana'},
    ]);
    await ekle(no: 'T26', sira: 26, kaynakTipi: 'Ana Hat', anaYili: 2026, sonCita: 5, maxCita: 5, olusturmaGunOnce: 8, not: 'Hazır ana 8. gün; yumurtlama kontrol penceresi.', muayeneler: [
      {'gunOnce': 8, 'cita': 5, 'bal': 0, 'yavrulu': 2, 'disaridanHazirAnaVerildi': 1, 'anaKazanmaYontemi': 'hazir_ana'},
    ]);
    await ekle(no: 'T27', sira: 27, kaynakTipi: 'Ana Hat', anaYili: 2026, sonCita: 5, maxCita: 5, olusturmaGunOnce: 18, not: 'Kapalı meme 18. gün; yumurtlama kontrolü.', muayeneler: [
      {'gunOnce': 18, 'cita': 5, 'bal': 0, 'yavrulu': 2, 'memeDurumu': 'Kapalı Ana Memesi', 'anaKazanmaYontemi': 'kapali_meme'},
    ]);

    await ekle(no: 'T28', sira: 28, kaynakTipi: 'Ana Hat', anaYili: 2025, sonCita: 9, maxCita: 9, balCita: 4, not: 'Hasat sonrası 10. gün; bakım süreci açık kalmalı.', muayeneler: [
      {'gunOnce': 10, 'cita': 9, 'bal': 4, 'yavrulu': 5, 'notlar': 'Hasat / bal çıtası alındı.'},
    ]);
    await ekle(no: 'T29', sira: 29, kaynakTipi: 'Ana Hat', anaYili: 2025, sonCita: 9, maxCita: 9, balCita: 4, not: 'Hasat sonrası varroa yapılmış; bakım süreci hafiflemeli/kapanmalı.', muayeneler: [
      {'gunOnce': 10, 'cita': 9, 'bal': 4, 'yavrulu': 5},
      {'gunOnce': 2, 'cita': 9, 'bal': 0, 'yavrulu': 5, 'varroa': 'Amitraz'},
    ]);
    await ekle(no: 'T30', sira: 30, kaynakTipi: 'Ana Hat', anaYili: 2025, sonCita: 8, maxCita: 9, balCita: 3, not: 'Hasat sonrası besleme yapılmış; bakım süreci hafiflemeli.', muayeneler: [
      {'gunOnce': 10, 'cita': 8, 'bal': 3, 'yavrulu': 5},
      {'gunOnce': 2, 'cita': 8, 'bal': 0, 'yavrulu': 5, 'besleme': '2:1 Şurup'},
    ]);

    await ekle(no: 'T31', sira: 31, kaynakTipi: 'Ana Hat', anaYili: 2025, sonCita: 6, maxCita: 6, not: 'Tek muayeneli koloni; karar var ama veri güveni düşük.', muayeneler: []);
    await ekle(no: 'T32', sira: 32, kaynakTipi: 'Ana Hat', anaYili: 2025, sonCita: 7, maxCita: 7, not: '3 muayeneli koloni; izlenmeli veri güveni.', muayeneler: _gelisimSerisi(7, 1, 3).take(2).toList());
    await ekle(no: 'T33', sira: 33, kaynakTipi: 'Ana Hat', anaYili: 2025, sonCita: 9, maxCita: 9, not: '6 muayeneli koloni; veri güveni yüksek.', muayeneler: _gelisimSerisi(9, 2, 6));
    await ekle(no: 'T34', sira: 34, kaynakTipi: 'Ana Hat', anaYili: 2025, sonCita: 5, maxCita: 6, yavruDuzeni: 'Kambur', not: 'Kambur yavru; özel risk uyarısı beklenir.', muayeneler: [
      {'gunOnce': 2, 'cita': 5, 'bal': 0, 'yavrulu': 3, 'yavruDuzeni': 'Kambur'},
    ]);
    await ekle(no: 'T35', sira: 35, kaynakTipi: 'Ana Hat', anaYili: 2025, sonCita: 6, maxCita: 6, yavruDuzeni: 'Dağınık', not: 'Dağınık yavru; uyarı üretmeli.', muayeneler: [
      {'gunOnce': 2, 'cita': 6, 'bal': 0, 'yavrulu': 3, 'yavruDuzeni': 'Dağınık'},
    ]);
    await ekle(no: 'T36', sira: 36, kaynakTipi: 'Ana Hat', anaYili: 2025, sonCita: 10, maxCita: 10, yavruDuzeni: 'Blok', not: 'Blok yavrulu güçlü koloni.', muayeneler: _gelisimSerisi(10, 3, 5, yavruDuzeni: 'Blok'));
    final sonen = await ekle(no: 'T37', sira: 37, kaynakTipi: 'Ana Hat', anaYili: 2024, sonCita: 0, maxCita: 5, durum: 'sondu', not: 'Sönen koloni.', muayeneler: [
      {'gunOnce': 3, 'cita': 0, 'bal': 0, 'yavrulu': 0, 'kovanSondu': 1},
    ]);
    await ekle(no: 'T38', sira: 38, kaynakTipi: 'Bölme', kaynakKoloniId: sonen, anaYili: 2025, sonCita: 7, maxCita: 8, not: 'Sönen kaynak hattından yaşayan devam; soy ağacı görünümü testi.', muayeneler: _gelisimSerisi(7, 1, 4));
    await ekle(no: 'T39', sira: 39, kaynakTipi: 'Ana Hat', anaYili: 2023, sonCita: 9, maxCita: 10, not: '2 yaş üstü ana; ana değişim stratejik uyarı testi.', muayeneler: _gelisimSerisi(9, 2, 5));
    await ekle(no: 'T40', sira: 40, kaynakTipi: 'Ana Hat', anaYili: 2025, sonCita: 8, maxCita: 9, not: 'Varroa görülmüş ama mücadele yok; sağlık/risk uyarısı.', muayeneler: [
      {'gunOnce': 12, 'cita': 8, 'bal': 1, 'yavrulu': 5, 'varroaGoruldu': 1},
      {'gunOnce': 2, 'cita': 8, 'bal': 1, 'yavrulu': 5, 'varroaGoruldu': 1},
    ]);

    KararAsistanServisi.tumCacheTemizle();
    ArilikUyariServisi.cacheTemizle(arilikId: arilikId);

    return TestAriligiSonucu(
      arilikId: arilikId,
      koloniSayisi: olusturulanIdler.length,
      oncekiTestAriligiSilindi: silindi,
    );
  }

  static List<Map<String, dynamic>> _gelisimSerisi(
    int sonCita,
    int bal,
    int adet, {
    String mizac = 'Sakin',
    String yavruDuzeni = 'Normal',
  }) {
    final sonuc = <Map<String, dynamic>>[];
    final count = adet <= 0 ? 1 : adet;
    for (int i = 0; i < count; i++) {
      final ters = count - i;
      final cita = (sonCita - ters + 1).clamp(2, sonCita);
      sonuc.add({
        'gunOnce': 7 + (ters * 14),
        'cita': cita,
        'bal': i == count - 1 ? bal : 0,
        'yavrulu': (cita - 2).clamp(0, cita),
        'mizac': mizac,
        'yavruDuzeni': yavruDuzeni,
      });
    }
    sonuc.add({
      'gunOnce': 2,
      'cita': sonCita,
      'bal': bal,
      'yavrulu': (sonCita - 3).clamp(0, sonCita),
      'mizac': mizac,
      'yavruDuzeni': yavruDuzeni,
    });
    return sonuc;
  }

  static Map<String, dynamic> _muayene({
    required int koloniId,
    required int gunOnce,
    required int cita,
    required int bal,
    required int yavrulu,
    required String yavruDuzeni,
    required String mizac,
    required String besleme,
    required String varroa,
    required int anaAriGoruldu,
    required int varroaGoruldu,
    required int ogulBelirtisi,
    required int ogulAtti,
    required int bolmeYapildi,
    required int kovanSondu,
    required int anasizBirakildiMi,
    required String anaKazanmaYontemi,
    required int kapaliYavruluCitaAktarildi,
    required int disaridanHazirAnaVerildi,
    required int gunlukKapaliYavruGoruldu,
    required int anaDegisimPlanlandiMi,
    required String memeDurumu,
    required String notlar,
  }) {
    return {
      'koloniId': koloniId,
      'tarih': _iso(_gun(DateTime.now()).subtract(Duration(days: gunOnce))),
      'citaSayisi': cita,
      'bal_cita': bal,
      'yavruluCita': yavrulu,
      'yavruDuzeni': yavruDuzeni,
      'mizac': mizac,
      'beslemeTipi': besleme,
      'beslemeYapildi': besleme == 'Yok' ? 0 : 1,
      'varroaMucadele': varroa,
      'anaAriGoruldu': anaAriGoruldu,
      'varroaGoruldu': varroaGoruldu,
      'ogulBelirtisi': ogulBelirtisi,
      'ogulAtti': ogulAtti,
      'bolmeYapildi': bolmeYapildi,
      'kovanSondu': kovanSondu,
      'anasizBirakildiMi': anasizBirakildiMi,
      'anasizBaslangicTarihi': anasizBirakildiMi == 1 ? _iso(_gun(DateTime.now()).subtract(Duration(days: gunOnce))) : null,
      'anaKazanmaYontemi': anaKazanmaYontemi,
      'memeDurumu': memeDurumu.isEmpty ? null : memeDurumu,
      'erkekAriDurumu': null,
      'ciftlesmeDurumu': null,
      'anaDegisimPlanlandiMi': anaDegisimPlanlandiMi,
      'kapaliYavruluCitaAktarildi': kapaliYavruluCitaAktarildi,
      'disaridanHazirAnaVerildi': disaridanHazirAnaVerildi,
      'gunlukKapaliYavruGoruldu': gunlukKapaliYavruGoruldu,
      'varroaSecimleri': varroa == 'Yok' ? null : varroa,
      'notlar': 'TEST SENARYOSU: $notlar',
    };
  }

  static DateTime _gun(DateTime tarih) => DateTime(tarih.year, tarih.month, tarih.day);

  static String _iso(DateTime tarih) {
    return '${tarih.year.toString().padLeft(4, '0')}-${tarih.month.toString().padLeft(2, '0')}-${tarih.day.toString().padLeft(2, '0')}';
  }

  static int _toInt(dynamic deger) {
    if (deger == null) return 0;
    if (deger is int) return deger;
    if (deger is double) return deger.round();
    return int.tryParse(deger.toString()) ?? 0;
  }
}
