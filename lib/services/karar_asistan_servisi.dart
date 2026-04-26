import 'koloni_karar_motoru.dart';
import 'ari_biyoloji_servisi.dart';
import 'surec_motoru.dart';
import 'veritabani_servisi.dart';

class KararAsistanServisi {
  static void tumCacheTemizle() {
    KoloniKararMotoru.tumCacheTemizle();
  }

  static void arilikCacheTemizle(int? arilikId) {
    KoloniKararMotoru.arilikCacheTemizle(arilikId);
  }

  static Future<Map<String, dynamic>> arilikOzetGetir(int arilikId) {
    return KoloniKararMotoru.arilikOzetGetir(arilikId);
  }

  static Future<Map<String, String>> anaKararUret(
      int koloniId,
      Map<String, dynamic> koloni, {
        List<Map<String, dynamic>>? siraliDonorler,
        bool forceRefresh = false,
      }) async {
    final sonuc = await KoloniKararMotoru.kararUret(
      koloniId,
      koloni,
      siraliDonorler: siraliDonorler,
      forceRefresh: forceRefresh,
    );
    return sonuc.toAnaKararMap();
  }

  static Future<bool> gercekDamizlikMi(
      int koloniId,
      Map<String, dynamic> koloni, {
        List<Map<String, dynamic>>? siraliDonorler,
        bool forceRefresh = false,
      }) async {
    final sonuc = await KoloniKararMotoru.kararUret(
      koloniId,
      koloni,
      siraliDonorler: siraliDonorler,
      forceRefresh: forceRefresh,
    );
    return sonuc.gercekDamizlik;
  }

  static Future<Map<String, String>> secilimDurumuGetir(
      int koloniId,
      Map<String, dynamic> koloni, {
        List<Map<String, dynamic>>? siraliDonorler,
        bool forceRefresh = false,
      }) async {
    final sonuc = await KoloniKararMotoru.kararUret(
      koloniId,
      koloni,
      siraliDonorler: siraliDonorler,
      forceRefresh: forceRefresh,
    );
    return sonuc.toSecilimMap();
  }

  static Future<List<Map<String, String>>> aksiyonOnerileriUret(
      int koloniId,
      Map<String, dynamic> koloni, {
        List<Map<String, dynamic>>? siraliDonorler,
        bool forceRefresh = false,
      }) async {
    final sonuc = await KoloniKararMotoru.kararUret(
      koloniId,
      koloni,
      siraliDonorler: siraliDonorler,
      forceRefresh: forceRefresh,
    );
    return sonuc.aksiyonKartlari;
  }

  static Future<List<Map<String, dynamic>>> donorAdaylariSiraliGetir({
    int? arilikId,
    bool forceRefresh = false,
  }) {
    return KoloniKararMotoru.donorAdaylariSiraliGetir(
      arilikId: arilikId,
      forceRefresh: forceRefresh,
    );
  }


  static Future<Map<String, dynamic>> surecDurumuGetir(int koloniId) async {
    final sonuc = await SurecMotoru.durumGetir(koloniId);
    return sonuc.toMap();
  }

  static Future<Map<String, dynamic>> biyolojiDurumuGetir(int koloniId) async {
    final sonuc = await AriBiyolojiServisi.analizYap(koloniId);
    return sonuc.toMap();
  }

  static Future<Map<String, dynamic>> kararVeBiyolojiBirlesikGetir(
      int koloniId,
      Map<String, dynamic> koloni, {
        List<Map<String, dynamic>>? siraliDonorler,
        bool forceRefresh = false,
      }) async {
    final karar = await KoloniKararMotoru.kararUret(
      koloniId,
      koloni,
      siraliDonorler: siraliDonorler,
      forceRefresh: forceRefresh,
    );
    final biyoloji = await AriBiyolojiServisi.analizYap(koloniId);

    return {
      'anaKarar': karar.toAnaKararMap(),
      'secilim': karar.toSecilimMap(),
      'gercekDamizlik': karar.gercekDamizlik,
      'donorSkoru': karar.donorSkoru,
      'donorSirasi': karar.donorSirasi,
      'donorVeto': karar.donorVeto,
      'aksiyonKartlari': karar.aksiyonKartlari,
      'profil': karar.profil,
      'biyoloji': biyoloji.toMap(),
    };
  }

  static Future<Map<String, dynamic>> kararAciklamaGetir(
      int koloniId,
      Map<String, dynamic> koloni, {
        List<Map<String, dynamic>>? siraliDonorler,
        bool forceRefresh = false,
      }) async {
    final sonuc = await KoloniKararMotoru.kararUret(
      koloniId,
      koloni,
      siraliDonorler: siraliDonorler,
      forceRefresh: forceRefresh,
    );

    final profil = sonuc.profil;
    final List<String> gerekceler = [];
    final List<String> riskler = [];
    final List<String> oneriler = [];

    void ekle(List<String> hedef, String? metin) {
      final temiz = (metin ?? '').trim();
      if (temiz.isEmpty) return;
      if (!hedef.contains(temiz)) hedef.add(temiz);
    }

    final int sonCita = _toInt(profil['sonCita']);
    final int maxCita = _toInt(profil['maxCita']);
    final int balCita = _toInt(profil['balCita']);
    final int anaYasi = _toInt(profil['anaYasi']);
    final int muayeneSayisi = _toInt(profil['muayeneSayisi']);
    final String trend = _metin(profil['trend'], 'Stabil');
    final String mizac = _metin(profil['mizac'], 'Bilinmiyor');
    final String vetoKod = _metin(profil['vetoKodu'], '');
    final String vetoReferansKoloniNo = _metin(profil['vetoReferansKoloniNo'], '');
    final String biyolojiBaslik = _metin(profil['biyolojiBaslik'], '');
    final String biyolojiMesaj = _metin(profil['biyolojiMesaj'], '');
    final String kisCikisYorum = _metin(profil['kisCikisYorum'], '');

    if (sonuc.donorVeto) {
      if (vetoKod == 'DOGRUDAN_OGUL' || vetoKod == 'KAYNAK_TIPI_OGUL') {
        ekle(gerekceler, 'Koloni oğul kökenli olduğu için temiz donör havuzuna alınmadı.');
      } else if (vetoKod == 'KENDISI_OGUL_ATTI') {
        ekle(gerekceler, 'Koloni kendi geçmişinde oğul attığı için donör değerlendirmesinde veto aldı.');
      } else if (vetoKod == 'ATA_HATTA_OGUL' && vetoReferansKoloniNo.isNotEmpty) {
        ekle(gerekceler, '$vetoReferansKoloniNo hattında oğul izi bulunduğu için temiz donör havuzuna alınmadı.');
      } else if (vetoKod == 'ATA_HATTA_OGUL') {
        ekle(gerekceler, 'Atasal hatta oğul izi bulunduğu için temiz donör havuzuna alınmadı.');
      }
    } else if (sonuc.donorSirasi > 0) {
      ekle(gerekceler, 'Temiz donör havuzunda ${sonuc.donorSirasi}. sırada görünüyor.');
    }

    if (sonCita > 0) {
      ekle(gerekceler, 'Son muayenede koloni $sonCita çıta gücünde görünüyor.');
    }
    if (maxCita > 0) {
      ekle(gerekceler, 'Bu sezon gördüğü en yüksek güç $maxCita çıta.');
    }
    if (balCita > 0) {
      ekle(gerekceler, 'Bal taşıma sinyali $balCita ballı çıta ile görülüyor.');
    }

    if (trend == 'Yükselişte') {
      ekle(gerekceler, 'Son muayenelerde gelişim yönü yukarı.');
    } else if (trend == 'Düşüşte') {
      ekle(riskler, 'Son muayenelerde güç kaybı eğilimi görülüyor.');
    } else {
      ekle(gerekceler, 'Gidişat stabil görünüyor.');
    }

    if (anaYasi >= 2) {
      ekle(riskler, 'Ana yaşı $anaYasi yıl olduğu için verim ve düzen düşüşü riski taşıyor.');
    }

    if (mizac == 'Saldırgan' || mizac == 'Sinirli') {
      ekle(riskler, 'Mizaç verisi saha yönetimini zorlaştırabilir.');
    }

    if (kisCikisYorum.isNotEmpty && !kisCikisYorum.toLowerCase().contains('yetersiz')) {
      ekle(gerekceler, kisCikisYorum);
    }

    if (profil['biyolojiVeriVarMi'] == true && biyolojiBaslik.isNotEmpty) {
      if (profil['biyolojiZamanKritik'] == true || profil['biyolojiMudahaleGerekli'] == true) {
        ekle(riskler, biyolojiBaslik);
        if (biyolojiMesaj.isNotEmpty) {
          ekle(riskler, biyolojiMesaj);
        }
      } else if (profil['biyolojiAnaUretimIcinUygun'] == true) {
        ekle(gerekceler, biyolojiBaslik);
      } else if (biyolojiMesaj.isNotEmpty) {
        ekle(gerekceler, biyolojiMesaj);
      }
    }

    if (muayeneSayisi < 3) {
      ekle(riskler, 'Karar az veriyle üretildiği için güven payı düşüktür.');
    }

    for (final kart in sonuc.aksiyonKartlari) {
      final baslik = _metin(kart['baslik'], '');
      final mesaj = _metin(kart['mesaj'], '');
      if (mesaj.isEmpty) continue;
      if (baslik == 'Ne yap') {
        ekle(oneriler, mesaj);
      } else if (baslik == 'Sahada Öncelik' || baslik == 'Biyolojik Not') {
        ekle(oneriler, mesaj);
      }
    }

    switch (sonuc.kararKodu) {
      case 'BOLME':
      case 'BOLME_ICIN_UYGUN':
        ekle(oneriler, 'Bölme yapacaksan koloniyi 7 çıtanın altına düşürmeden planla.');
        break;
      case 'DONOR_1':
      case 'DONOR_2':
      case 'DONOR_3':
      case 'SARTLI_DONOR':
        ekle(oneriler, 'Ana üretiminde bu koloniyi aday havuzunda öncelikli düşün.');
        break;
      case 'ANA_DEGISIM':
      case 'ANA_DEGISIM_DUSUN':
        ekle(oneriler, 'Ana değişimini aktif dönemin sonuna yakın planlamak genelde daha güvenli olur.');
        break;
      case 'GUCLENDIR_VE_IZLE':
      case 'DESTEK_KOLONISI':
        ekle(oneriler, 'Kapalı yavru, besleme ve düzenli muayene ile güçlenme yönünü izle.');
        break;
      case 'URETIM':
      case 'URETIM_IZLE':
      case 'URETIMDE_DEGERLENDIR':
        ekle(oneriler, 'Üretimde tut; bal akımı yaklaşırken alan ve kat yönetimini öne al.');
        break;
      case 'PASIF_KAYIT':
        ekle(oneriler, 'Koloniyi aktif üretimden çok soy ve geçmiş kaydı olarak değerlendir.');
        break;
    }

    final String ozet = sonuc.kararMesaji.trim().isNotEmpty
        ? sonuc.kararMesaji.trim()
        : sonuc.secilimMesaji.trim();

    return {
      'karar': sonuc.kararBaslik,
      'ozet': ozet,
      'secilimBaslik': sonuc.secilimBaslik,
      'secilimMesaji': sonuc.secilimMesaji,
      'gerekceler': gerekceler,
      'riskler': riskler,
      'oneriler': oneriler,
    };
  }


  static Map<String, dynamic> varroaTakvimHatirlatmasiGetir(
      List<Map<String, dynamic>> muayeneler, {
        DateTime? bugun,
        DateTime? balAkimBaslangici,
      }) {
    final bugunTarih = _sadeceGun(bugun ?? DateTime.now());

    if (muayeneler.isEmpty) {
      return {
        'seviye': 'bilgi',
        'baslik': 'Varroa kaydı henüz yok.',
        'gerekce':
        'Takvimsel varroa hatırlatmaları ilk muayene kayıtlarından sonra daha anlamlı hale gelir.',
        'oneriler': <String>[
          'Muayenelerde yapılan varroa mücadelesini düzenli kaydet.',
        ],
        'sonKayitTarihi': '',
        'sonYontem': '',
      };
    }

    final sirali = List<Map<String, dynamic>>.from(muayeneler)
      ..sort((a, b) => _guvenliTarih(b['tarih']).compareTo(_guvenliTarih(a['tarih'])));

    Map<String, dynamic>? sonMucadele;
    for (final m in sirali) {
      final secimler = VeritabaniServisi.varroaSecimleriniGetir(m);
      final yontem = secimler.isEmpty ? _metin(m['varroaMucadele'], 'Yok') : secimler.join(', ');
      if (yontem != 'Yok' && yontem != '-') {
        sonMucadele = m;
        break;
      }
    }

    final sonTarih = sonMucadele == null ? null : _guvenliTarih(sonMucadele['tarih']);
    final sonYontem = sonMucadele == null
        ? ''
        : (() {
            final secimler = VeritabaniServisi.varroaSecimleriniGetir(sonMucadele!);
            return secimler.isEmpty ? _metin(sonMucadele['varroaMucadele'], '') : secimler.join(', ');
          })();

    bool sonKayitVarMi(int gun) {
      if (sonTarih == null) return false;
      return bugunTarih.difference(sonTarih).inDays <= gun;
    }

    String tarihMetni(DateTime? dt) {
      if (dt == null) return '';
      final gun = dt.day.toString().padLeft(2, '0');
      final ay = dt.month.toString().padLeft(2, '0');
      final yil = dt.year.toString();
      return '$gun.$ay.$yil';
    }

    final ay = bugunTarih.month;
    String seviye = 'bilgi';
    String baslik = 'Varroa takvimi izlenmeli.';
    String gerekce = 'Mevsime uygun varroa kaydı ve takip disiplini korunmalı.';
    final oneriler = <String>[];

    final temizBalAkimBaslangici = balAkimBaslangici == null
        ? null
        : _sadeceGun(balAkimBaslangici);
    final sonGuvenliMudahaleTarihi = temizBalAkimBaslangici == null
        ? null
        : _sadeceGun(temizBalAkimBaslangici.subtract(const Duration(days: 30)));
    final balAkiminaKalanGun = temizBalAkimBaslangici == null
        ? null
        : temizBalAkimBaslangici.difference(bugunTarih).inDays;
    final sonMudahaleBalAkimOncesiZamanindaMi =
        sonTarih != null &&
            sonGuvenliMudahaleTarihi != null &&
            !sonTarih.isAfter(sonGuvenliMudahaleTarihi);

    if (ay == 2 || ay == 3) {
      if (sonKayitVarMi(45)) {
        seviye = 'iyi';
        baslik = 'Erken ilkbahar varroa kaydı var.';
        gerekce =
        'Sezon başında yapılan mücadele kaydı görülüyor. Bu, ilkbahar gelişimine daha düşük baskıyla girmeyi destekler.';
        oneriler.add('Mücadele etkisini sonraki muayenelerde takip et.');
      } else {
        seviye = 'risk';
        baslik = 'İlkbahar varroa kontrolü planlanmalı.';
        gerekce =
        'Erken ilkbahar dönemi varroa baskısını sezon başında düşürmek için önemli bir penceredir.';
        oneriler.add('Kolonileri kontrol et; gerekirse erken ilkbahar müdahalesi planla.');
      }
    } else if (ay == 4 || ay == 5) {
      seviye = sonKayitVarMi(60) ? 'iyi' : 'bilgi';
      baslik = sonKayitVarMi(60)
          ? 'Bal akımı öncesi varroa kaydı görünüyor.'
          : 'Bal akımı öncesi varroa planı gözden geçirilmeli.';
      gerekce =
      'Bal akımı dönemine girerken varroa planının tamamlanmış olması daha güvenlidir.';
      oneriler.add('Bal akımı içinde değil, öncesinde planlama yap.');
    } else if (ay == 6 || ay == 7) {
      seviye = 'bilgi';
      baslik = 'Yaz döneminde varroa takibi sürdürülmeli.';
      gerekce =
      'Yaz ortasında amaç sürekli ilaçlama değil, düzenli izleme ve hasat sonrası döneme hazırlıktır.';
      oneriler.add('Muayenelerde varroa kaydını ve koloni gidişatını düzenli izle.');
    } else if (ay == 8 || ay == 9) {
      if (sonKayitVarMi(45)) {
        seviye = 'iyi';
        baslik = 'Kritik dönemde varroa mücadelesi kaydı var.';
        gerekce =
        'Yaz sonu–erken sonbahar, kış arısının oluştuğu ve varroa baskısının en kritik olduğu dönemdir.';
        oneriler.add('Hasat sonrası planı sürdür; etkinliği sonraki muayenede kontrol et.');
      } else {
        seviye = 'kritik';
        baslik = 'Hasat sonrası varroa mücadelesi gecikiyor.';
        gerekce =
        'Yaz sonu–erken sonbaharda kayıt görünmüyor. Bu dönem kış arısının sağlığı açısından en kritik pencere kabul edilir.';
        oneriler.add('Bal sağımı sonrası mücadeleyi geciktirme.');
        oneriler.add('Sonraki muayenede uygulamayı mutlaka kaydet.');
      }
    } else if (ay == 10 || ay == 11) {
      if (sonKayitVarMi(60)) {
        seviye = 'iyi';
        baslik = 'Kışa giriş öncesi varroa kaydı var.';
        gerekce =
        'Sonbahar sonunda kayıt görünmesi kışa daha düşük yükle girme açısından olumlu bir sinyaldir.';
        oneriler.add('Kışa girişten önce son genel durumu bir kez daha kontrol et.');
      } else {
        seviye = 'risk';
        baslik = 'Sonbahar varroa kaydı eksik görünüyor.';
        gerekce =
        'Kışa giriş öncesi dönemde mücadele kaydı görünmüyor. Sonbahar sonu kontrolü ihmal edilmemeli.';
        oneriler.add('Yavru faaliyeti azaldıysa mücadele gerekliliğini değerlendir.');
      }
    } else {
      if (sonKayitVarMi(90)) {
        seviye = 'bilgi';
        baslik = 'Sonbahar varroa kaydı görünüyor.';
        gerekce =
        'Kış döneminde esas amaç, sonbaharda düşürülmüş yükü koruyarak koloniyi gereksiz strese sokmamaktır.';
        oneriler.add('Kovanı gereksiz açmadan genel durumu izle.');
      } else {
        seviye = 'risk';
        baslik = 'Kış varroa durumu gözden geçirilmeli.';
        gerekce =
        'Kayıt uzun süredir yok. Yavru faaliyeti azaldıysa durum tekrar değerlendirilmelidir.';
        oneriler.add('Yavru durumu ve mevsim koşullarına göre kış kontrolü yap.');
      }
    }

    if (temizBalAkimBaslangici != null && balAkiminaKalanGun != null && balAkiminaKalanGun >= 0) {
      final sonGunMetni = tarihMetni(sonGuvenliMudahaleTarihi);
      final balAkimMetni = tarihMetni(temizBalAkimBaslangici);

      if (balAkiminaKalanGun <= 30) {
        if (sonMudahaleBalAkimOncesiZamanindaMi) {
          if (seviye != 'kritik') {
            seviye = 'iyi';
          }
          baslik = 'Bal akımı öncesi varroa planı tamamlanmış görünüyor.';
          gerekce =
          '$balAkimMetni tarihinde başlaması beklenen bal akımı öncesi en geç $sonGunMetni tarihine kadar mücadele tamamlanmalıydı. Kayıt buna uygun görünüyor.';
          ekOneri(oneriler, 'Bal akımı içinde yeni mücadele planlama.');
        } else {
          seviye = 'kritik';
          baslik = 'Bal akımı öncesi mücadele penceresi kapanıyor.';
          gerekce =
          '$balAkimMetni tarihinde başlaması beklenen bal akımı öncesi kalıntı riskini azaltmak için mücadele en geç $sonGunMetni tarihine kadar tamamlanmış olmalı.';
          oneriler.insert(0, 'Bu aşamada bal akımı öncesi kimyasal mücadele planlarken kalıntı riskini dikkate al.');
          ekOneri(oneriler, 'Geciktiysen yeni kimyasal uygulamayı bal akımı sonrasına bırakman daha güvenli olabilir.');
        }
      } else if (balAkiminaKalanGun <= 45) {
        if (!sonMudahaleBalAkimOncesiZamanindaMi) {
          if (seviye != 'kritik') {
            seviye = 'risk';
          }
          baslik = 'Bal akımı öncesi son varroa penceresine giriliyor.';
          gerekce =
          '$balAkimMetni tarihinde başlaması beklenen bal akımı için mücadele en geç $sonGunMetni tarihine kadar tamamlanmalı. Süre daralıyor.';
          oneriler.insert(0, 'Mücadele gerekiyorsa son güvenli tarihe bırakmadan planla.');
        }
      } else if (!sonMudahaleBalAkimOncesiZamanindaMi) {
        ekOneri(oneriler, 'Bal akımı öncesi son güvenli mücadele tarihi: $sonGunMetni.');
      }
    }

    if (sonTarih != null && sonYontem.isNotEmpty) {
      ekOneri(oneriler, 'Son kayıt: ${tarihMetni(sonTarih)} / $sonYontem.');
    }

    return {
      'seviye': seviye,
      'baslik': baslik,
      'gerekce': gerekce,
      'oneriler': oneriler,
      'sonKayitTarihi': tarihMetni(sonTarih),
      'sonYontem': sonYontem,
    };
  }


  static void ekOneri(List<String> hedef, String metin) {
    final temiz = metin.trim();
    if (temiz.isEmpty) return;
    if (!hedef.contains(temiz)) {
      hedef.add(temiz);
    }
  }

  static DateTime _guvenliTarih(dynamic deger) {
    final metin = (deger ?? '').toString().trim();
    if (metin.isEmpty) return DateTime(1900);

    final iso = DateTime.tryParse(metin);
    if (iso != null) {
      return DateTime(iso.year, iso.month, iso.day);
    }

    final parcalar = metin.split('.');
    if (parcalar.length == 3) {
      final gun = int.tryParse(parcalar[0]) ?? 1;
      final ay = int.tryParse(parcalar[1]) ?? 1;
      final yil = int.tryParse(parcalar[2]) ?? 1900;
      return DateTime(yil, ay, gun);
    }

    return DateTime(1900);
  }

  static DateTime _sadeceGun(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  static int _toInt(dynamic deger) {
    if (deger == null) return 0;
    if (deger is int) return deger;
    if (deger is double) return deger.round();
    return int.tryParse(deger.toString()) ?? 0;
  }

  static String _metin(dynamic deger, String varsayilan) {
    final metin = (deger ?? '').toString().trim();
    return metin.isEmpty ? varsayilan : metin;
  }
}
