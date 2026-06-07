import 'package:itogena_v45/gen_l10n/app_localizations.dart';

/// Servis katmanından gelen sabit Türkçe string'leri UI lokalizasyonuna çevirir.
///
/// Servisler (koloni_karar_motoru, karar_asistan_servisi vb.) iç mantık dili
/// olarak Türkçe string döndürür. Bu utility, ekran katmanında o string'leri
/// aktif locale'e göre gösterir. Servis koduna dokunmadan genişletilebilir:
/// yeni bir servis string'i görünce buraya ekle.
class ServisMetinLokalizer {
  ServisMetinLokalizer._();

  /// Verilen Türkçe servis metnini lokalize eder.
  /// Bilinmeyen metinlerde orijinal string geri döner (güvenli fallback).
  static String cevir(String trMetin, AppLocalizations l) {
    if (trMetin.isEmpty) return trMetin;
    final temiz = trMetin.trim();
    return _harita(l)[temiz] ?? _kismiEsles(temiz, l) ?? temiz;
  }

  /// Koloni listesi grid etiketlerini lokalize eder (yonetimEtiketi).
  static String gridEtiketi(String trMetin, AppLocalizations l) {
    if (trMetin.isEmpty) return trMetin;
    switch (trMetin.trim()) {
      case 'Yavru yok':         return l.kolonGridYavruYok;
      case 'Meme kontrolü':     return l.kolonGridMemeKontrol;
      case 'Yalancı ana riski': return l.kolonGridYalanciAna;
      case 'Bekleme süreci':    return l.kolonGridBeklemeSureci;
      case 'Süreç izleniyor':   return l.kolonGridSurecIzleniyor;
      case '3. kat ver':        return l.kolonGridUcuncuKat;
      case 'Alan aç':           return l.kolonGridAlanAc;
      case 'Kat ver':           return l.kolonGridKatVer;
      default:                  return trMetin;
    }
  }

  // ── Tam eşleşme tablosu ──────────────────────────────────────────────────

  static Map<String, String> _harita(AppLocalizations l) => {
    // ── Karar motoru — karar başlıkları ─────────────────────────────────
    'Bu koloni aktif değil':                        l.srvKoloniAktifDegil,
    'Pasif kayıt':                                  l.srvPasifKayit,
    'Donör havuzunda':                              l.srvDonorHavuzunda,
    'Bu koloni bölme için uygun görünüyor':         l.srvBolmeUygun,
    'Bölme için güç sınırında':                     l.srvBolmeSinirinda,
    'Bölme önerilmez':                              l.srvBolmeOnerilmez,
    'Güç var; standart bölme zamanı zayıf':         l.srvBolmeZayif,
    'Bu koloniye yakından bakmak gerekir':           l.srvYakindanBak,
    'İzleyerek karar ver':                          l.srvIzleyerek,
    'Destek / üretim rolü':                         l.srvDestekUretim,
    'Veri güveni düşük':                            l.srvVeriGuveniDusuk,
    'Karar var; veri güveni düşük':                 l.srvKararVarVeriDusuk,

    // ── Süreç başlıkları ─────────────────────────────────────────────────
    'Ana Kazanma':          l.srvAnaKazanma,
    'Bölme Sonrası':        l.srvBolmeSonrasi,
    'Kış Yönetimi':         l.srvKisYonetimi,
    'Bakım Süreci':         l.srvBakimSureci,
    'Gelişim Dönemi':       l.srvGelisimDonemi,
    'Üretim Dönemi':        l.srvUretimDonemi,
    'Hasat Hazırlığı':      l.srvHasatHazirlik,
    'Hasat Sonrası Bakım':  l.srvHasatSonrasiBakim,
    'Oğul Sonrası':         l.srvOgulSonrasi,
    'Varroa Yönetimi':      l.srvVarroaYonetimi,
    'Sahada Öncelik':       l.srvSahadaOncelik,
    'Biyolojik Not':        l.srvBiyolojikNot,

    // ── Grid etiketleri (güvenli tekrar) ─────────────────────────────────
    'Yavru yok':         l.kolonGridYavruYok,
    'Meme kontrolü':     l.kolonGridMemeKontrol,
    'Yalancı ana riski': l.kolonGridYalanciAna,
    'Bekleme süreci':    l.kolonGridBeklemeSureci,
    'Süreç izleniyor':   l.kolonGridSurecIzleniyor,
    '3. kat ver':        l.kolonGridUcuncuKat,
    'Alan aç':           l.kolonGridAlanAc,
    'Kat ver':           l.kolonGridKatVer,

    // ── trend_servisi — trend etiketleri ─────────────────────────────────
    'Veri Yok':                  l.trendVeriYok,
    'Stabil':                    l.trendStabil,
    'Yükseliş':                  l.trendYukselis,
    'Düşüş':                     l.trendDusus,
    'Sönmüş':                    l.trendSonmus,
    'Kontrollü Bölme':           l.trendKontrolluBolme,
    'Bölme Sonrası İzleme':      l.trendBolmeSonrasiIzleme,
    'Güçlü Biyolojik Yön':       l.trendGucluBiyolojikYon,
    'Hasat Sonrası Stabil':      l.trendHasatSonrasiStabil,
    'Yavaş Gelişim':             l.trendYavasGelisim,

    // ── trend_servisi — momentum açıklamaları ────────────────────────────
    'Henüz muayene verisi bulunmuyor.': l.trendHenuzMuayeneYok,
    'Kovan sönmüş işaretlendi; momentum gerçek biyolojik kayıp olarak okunur.':
        l.trendMomentumKovanSondu,
    'Bölme kaydı nedeniyle çıta düşüşü biyolojik zayıflama sayılmadı.':
        l.trendMomentumBolme,
    'Bal/hasat kaydı nedeniyle çıta düşüşü biyolojik momentum cezası sayılmadı.':
        l.trendMomentumHasat,
    'Fiziksel hacim değişmedi; momentum nötr okundu.':
        l.trendMomentumFizikselDegismedi,
    'Hızlı hacim artışı aktivasyon tamamlanmadan gerçek büyüme sayılmadı.':
        l.trendMomentumHizliArtis,
    'Kat/ballık geçişi fiziksel hacim artışı olarak görüldü; biyolojik momentum temkinli normalleştirildi.':
        l.trendMomentumKatGecisi,
    'Yeni hacmin aktivasyonu düşük olduğu için büyüme sinyali frenlendi.':
        l.trendMomentumDusukAktivasyon,
    'Bal akımı içinde sağlıklı üst hacim genişlemesi biyolojik üretim yönü olarak okundu.':
        l.trendMomentumBalAkimi,
    'Fiziksel artış işlevsel kapasiteye göre normalize edildi.':
        l.trendMomentumNormalize,

    // ── surec_motoru — süreç başlıkları ──────────────────────────────────
    'Oğul riski':                              l.surecOgulRiski,
    'Oğul riski takibi':                       l.surecOgulRiskiTakip,
    'Tekrarlayan oğul / nüfus kaybı riski':    l.surecTekrarlayanOgul,
    'Oğul sonrası artçı riski yüksek':         l.surecOgulSonrasiArtciYuksek,
    'Artçı oğul riski izleniyor':              l.surecArtciOgulIzleniyor,
    'Oğul sonrası ana / çiftleşme süreci':     l.surecOgulSonrasiAnaCiftlesme,
    'Oğul sonrası yumurtlama kontrolü':        l.surecOgulSonrasiYumurtlamaKontrol,
    'Bölme sonrası toparlanma':                l.surecBolmeSonrasiToparlanma,
    'Hasat sonrası bakım gerekli':             l.surecHasatSonrasiBakimGerekli,
    'Gelişim yavaş görünüyor':                 l.surecGelisimYavas,

    // ── surec_motoru — süreç mesajları ───────────────────────────────────
    'Ana memesi görüldü. Bu sağlık sorunu değil, oğul davranışı ve koloni sıkışıklığı işaretidir. Koloniyi sakin biçimde kontrol et; gerekiyorsa bölme yap veya 1–2 kaliteli meme bırakıp fazlasını azalt.':
        l.surecMesajOgulRiski1,
    'İlk hafta artçı oğul riski yüksektir. Meme sayısını kontrol et; birden fazla güçlü meme bırakmak koloniyi tekrar bölebilir. Gerekiyorsa bölme veya fazla memeleri azaltma kararı ver.':
        l.surecMesajOgulRiski2,
    'Oğul belirtisi takip döneminde. Yeni meme, sıkışıklık veya huzursuzluk yoksa süreç kendiliğinden sönümlenir; gereksiz tekrar uyarı üretmez.':
        l.surecMesajOgulRiskiTakip,
    'Oğul kaydı tekrar ediyor. Bu artık normal artçı takibi değil; koloni hızla nüfus kaybedebilir. Meme sayısı, kalan arı gücü, stok ve ana belirtisi birlikte okunmalı. Çok zayıfladıysa yoğun emek yerine birleştirme veya sınırlı destek daha doğru olabilir.':
        l.surecMesajTekrarlayanOgul,
    'Oğul sonrası ilk hafta artçı oğul riski yüksektir. Amaç koloniyi tekrar böldürmemektir. Kontrol gerekiyorsa kısa ve sakin yapılmalı; fazla meme bırakmak tekrar nüfus kaybı doğurabilir. Üretim/kat/hasat kararı geri plandadır.':
        l.surecMesajArtciYuksek,
    'Artçı oğul riski devam eder ama ilk haftaya göre azalır. Yeni meme, huzursuzluk veya tekrar çıkış belirtisi yoksa ana sürecini bozmadan beklemek daha doğrudur. Günlük veya kapalı yavru görülürse süreç kapanır.':
        l.surecMesajArtciIzleniyor,
    'Artçı riski büyük ölçüde kapanır. Bu dönem yeni ana çıkışı, olgunlaşma ve çiftleşme penceresidir. Yavru hâlâ görülmeyebilir; bu tek başına çöküş sayılmaz. Dış uçuş, polen gelişi ve sakinlik izlenir. Günlük veya kapalı yavru görülürse muayenede işaretle, süreç kapanır.':
        l.surecMesajAnaCiftlesme,
    'Oğul sonrası 31–45. gün arası artık yumurtlama netleşmelidir. Günlük veya kapalı yavru görülürse süreç kapanır. Hâlâ yavru yoksa bu süreç normal bekleme olmaktan çıkar; ana başarısızlığı, çiftleşme kaybı veya yalancı ana riski yavru-yok tanısı ile öne alınır.':
        l.surecMesajYumurtlamaKontrol,
    'Koloniyi sıkışık tut ve besleme yap. Yeni düzen kurulana kadar destek gerekir.':
        l.surecMesajBolmeErken,
    'Ana durumunu kontrol et. Toparlanma gecikmiş olabilir.':
        l.surecMesajBolmeGecikti,

    // ── koloni_karar_motoru — kabiliyet kartları ──────────────────────────
    'Biyolojik Kabiliyet':   l.kabiliyetBiyolojikBaslik,
    'Petek örme kapasitesi güçlü görünüyor. Ham petek verilecekse yavru bloğu kesilmeden dıştan genişletme daha güvenlidir.':
        l.kabiliyetBiyolojikMesaj,
    'Genişletme Riski':      l.kabiliyetGenisletmeRiskiBaslik,
    'Petek örme kapasitesi sınırlı görünüyor. Ham petek yerine kabarmış petek veya sıkı düzen daha güvenlidir.':
        l.kabiliyetGenisletmeRiskiMesaj,
    'Bal Akımı Kapasitesi':  l.kabiliyetBalAkimiBaslik,
    'Tarlacı ve bal işleme kapasitesi güçlü görünüyor. Bal akımı döneminde alan, kat ve sırlanma takibi öne alınmalı.':
        l.kabiliyetBalAkimiMesaj,
    'Bakıcı Dengesi':        l.kabiliyetBakiciDengeBaslik,
    'Yavru bakım kapasitesi iyi fakat petek örme sınırlı. Yavru alanını bozmayacak kabarmış petek, ham petekten daha güvenli olur.':
        l.kabiliyetBakiciDengeMesaj,
    'Kış Güvenliği':         l.kabiliyetKisGuvenligiBaslik,
    'Kış dayanımı sınırlı görünüyor. Öncelik hasat veya genişletme değil stok güvenliği ve sıkı düzendir.':
        l.kabiliyetKisGuvenligiMesaj,
    'Biyolojik Saha Notu':   l.kabiliyetBiyolojikSahaNotBaslik,

    // ── karar_asistan_servisi ─────────────────────────────────────────────
    'Biyolojik yön':         l.kararAsBiyolojikYon,

    // ── performans_ozeti_servisi — kriter adları ──────────────────────────
    'Üreme':                    l.perfKriterUreme,
    'Üretim':                   l.perfKriterUretim,
    'Dayanıklılık':             l.perfKriterDayaniklilik,
    'Davranış':                 l.perfKriterDavranis,
    'Hat Gücü':                 l.perfKriterHatGucu,
    'Veri Güveni':              l.perfKriterVeriGuveni,
    'Biyolojik Durum':          l.perfKriterBiyolojikDurum,
    'Koloni Gidişatı':          l.perfKriterKoloniGidisati,
    'Hacim Aktivasyonu':        l.perfKriterHacimAktivasyonu,
    'Petek Örme Kapasitesi':    l.perfKriterPetekOrme,
    'Yavru Bakım Kapasitesi':   l.perfKriterYavruBakim,

    // ── yorum_motoru — veri güveni cümleleri ─────────────────────────────
    'Veri yok; karar yalnızca kimlik ve kaynak bilgisine göre sınırlıdır.':
        l.yorumVeriYok,
    'Veri çok sınırlı; sistem karar verir ama güven düzeyi düşüktür.':
        l.yorumVeriCokSinirli,
    'Veri izlenmeli; karar var ama sonraki muayenelerle güçlenmelidir.':
        l.yorumVeriIzlenmeli,
    'Veri güveni yeterli; değerlendirme güvenilir banda girmiştir.':
        l.yorumVeriYeterli,
    'Henüz değerlendirilebilir türeyen koloni verisi yok.':
        l.yorumYetersizVeri,
    'Karar üretmek için yeterli veri yok.':
        l.yorumKararYetersiz,

    // ── soy_devamlilik_servisi — durum string'leri ────────────────────────
    'Veri Yetersiz':  l.soyDurumVeriYetersiz,
    'Güçlü Soy':      l.soyDurumGucluSoy,
    'Olumlu Soy':     l.soyDurumOlumluSoy,
    'Zayıf Soy':      l.soyDurumZayifSoy,
    'Riskli Soy':     l.soyDurumRiskliSoy,
    'Nötr':           l.soyDurumNotr,
    'Bu koloniden türeyen kayıtlı koloni görünmüyor.':
        l.soyYorumTureyenYok,
    'Türeyen koloniler var; ancak henüz en az 45 gün geçmiş yeterli veri oluşmamış.':
        l.soyYorumVeriYetersiz,

    // ── performans_ozeti_servisi — durum etiketleri ──────────────────────
    'Genetik Filtre':  l.perfDurumGenetikFiltre,
    'Şartlı Donör':   l.perfDurumSartliDonor,
    'Güçlü Üretim':   l.perfDurumGucluUretim,
    'İzlenmeli':      l.perfDurumIzlenmeli,
    'Müdahale':       l.perfDurumMudahale,

    // ── rapor_siralama_servisi — durum etiketleri ─────────────────────────
    'Genetik veto':  l.raporDurumGenetikVeto,
    'Donör 1':       l.raporDurumDonor1,
    'Donör 2':       l.raporDurumDonor2,
    'Donör 3':       l.raporDurumDonor3,
    'Çok zayıf':     l.raporDurumCokZayif,
    'Gelişmekte':    l.raporDurumGelismekte,
    'Güçlü':         l.raporDurumGuclu,
    'Çok güçlü':     l.raporDurumCokGuclu,

    // ── trend_servisi — momentum etiketi ─────────────────────────────────
    'Patlayıcı büyüme':   l.trendMomPatlaYici,
    'Güçlü büyüme':       l.trendMomGucluBuyume,
    'Sağlıklı gelişim':   l.trendMomSaglikliGelisim,
    'Yavaş gelişim':      l.trendMomYavasGelisim,
    'Duraklama':          l.trendMomDuraklama,

    // ── trend_servisi — trend açıklamaları ────────────────────────────────
    'Koloni genel olarak stabil görünüyor.':                        l.trendAciklamaStabil,
    'Son muayenede kovanın söndüğü işaretlenmiş.':                  l.trendAciklamaSonmus,
    'Bölme işaretli olduğu için çıta değişimi doğrudan zayıflama olarak okunmadı.':
        l.trendAciklamaBolme,
    'Koloni zamana göre güçlü biyolojik gelişim yönü gösteriyor.': l.trendAciklamaGucluYon,
    'Koloni zamana göre sağlıklı biyolojik gelişim yönünde.':      l.trendAciklamaYukselis,
    'Bal sinyali mevcut; küçük düşüşler üretim / hasat bağlamında okunuyor.':
        l.trendAciklamaHasatStabil,
    'Koloni zamana göre güç kaybı eğilimi gösteriyor.':            l.trendAciklamaDusus,
    'Koloni gelişiyor ancak momentum düşük.':                      l.trendAciklamaYavasGelisim,

    // ── trend_servisi — normalize açıklamaları (yeni) ──────────────────────
    'Hasat/bölme kaydı olmadan belirgin çıta düşüşü biyolojik zayıflama şüphesiyle okundu.':
        l.trendNormBiyolojikDusus,
    'Küçük çıta düşüşü tam çöküş sayılmadan temkinli okundu.':    l.trendNormKucukDusus,

    // ── koloni_biyolojik_model — koloni sınıfı etiket + açıklama ──────────
    'Zayıf':    l.biyoSinifZayif,
    'Gelişim':  l.biyoSinifGelisim,
    'Hasat':    l.biyoSinifHasat,
    'Öncelik yaşatma, sıkıştırma ve ölçülü destek.':                       l.biyoSinifAciklamaZayif,
    'Öncelik düzenli gelişim ve ana/yavru dengesinin korunması.':           l.biyoSinifAciklamaGelisim,
    'Koloni üretim gücüne girmiştir; alan, oğul riski ve bal akımı birlikte izlenir.':
        l.biyoSinifAciklamaUretim,
    'Koloni bal akımı ve hasat/alan yönetimi açısından güçlü banttadır.':  l.biyoSinifAciklamaHasat,

    // ── koloni_biyolojik_model — kovan yerleşim etiketleri ────────────────
    'Yavru/stok':                  l.biyoYerlesimYavruStok,
    'Ballı/polenli':               l.biyoYerlesimBalliPolenli,
    'Bal stoğu':                   l.biyoYerlesimBalStogu,
    'Yavru/polenli':               l.biyoYerlesimYavruPolenli,
    'Yavru':                       l.biyoYerlesimYavru,
    'Yavrulu/polenli':             l.biyoYerlesimYavruluPolenli,
    'Ballı/polenli geçiş alanı':  l.biyoYerlesimBalliPolenliGecis,
    'Ballık / bal alanı':          l.biyoYerlesimBallikBalAlani,
    'Yavru/stok geçiş alanı':     l.biyoYerlesimYavruStokGecis,

    // ── koloni_biyolojik_model — yavrusuzluk analizi ──────────────────────
    'Yavru verisi mevcut; biyolojik geri dönüş kapasitesi yavru üretimiyle destekleniyor.':
        l.biyoYavrusuzSahaNormal,
    'Normal biyolojik model akışıyla izle.':                        l.biyoYavrusuzOneriNormal,
    'Bu aşamada yavru görülmemesi normal olabilir. Koloni ana kazanma veya çiftleşme döneminde olabilir; gereksiz açma riski artırır.':
        l.biyoYavrusuzSahaBolme,
    'Kovanı gereksiz açma; yumurtlama kontrol penceresini bekle.':  l.biyoYavrusuzOneriBolme,
    'Yavru yokluğu tek başına anasızlık anlamına gelmez. Bal akımı ve ballı çıta baskısı yumurtlama alanını daraltmış olabilir.':
        l.biyoYavrusuzSahaBalBaskisi,
    'Önce alan ve bal baskısını değerlendir; erken ana müdahalesi yapma.':
        l.biyoYavrusuzOneriBalBaskisi,
    'Koloni uzun süredir yeni işçi üretmiyor. Bu güç seviyesinde mevcut nüfus yaşlanıyor olabilir; yoğun emek ve kaynak harcamak verimli olmayabilir.':
        l.biyoYavrusuzSahaDusukKap,
    'Güçlü koloniyle birleştirme veya sınırlı müdahale öncelikli değerlendirilmelidir.':
        l.biyoYavrusuzOneriDusukKap,
    'Yumurtlama beklenen döneme girilmiş. Yavru hâlâ yoksa geç çiftleşme, ana kaybı, bal baskısı veya zayıf koloni olasılıkları birlikte okunmalı.':
        l.biyoYavrusuzSahaGecikme,
    '5–7 gün içinde tekrar kontrol et; koloni zayıflıyorsa beklemeyi uzatma.':
        l.biyoYavrusuzOneriGecikme,
    'Yavru yokluğu izlenmeli; mevcut gün aralığında tek başına kesin anasızlık kararı verilmemelidir.':
        l.biyoYavrusuzSahaIzlenmeli,
    'Koloni davranışı, polen gelişi ve bir sonraki muayene ile birlikte değerlendir.':
        l.biyoYavrusuzOneriIzlenmeli,

    // ── performans_ozeti_servisi — biyoloji yorumu ────────────────────────
    'Biyolojik veri yetersiz':  l.perfBiyolojiVeriYetersiz,
    'Zaman kritik':             l.perfBiyolojiZamanKritik,
    'Müdahale gerekli':         l.perfBiyolojiMudahaleGerekli,
    'Uygun':                    l.perfBiyolojiUygun,
    'Dikkat':                   l.perfBiyolojiDikkat,

    // ── performans_ozeti_servisi — kabiliyet yorumu ───────────────────────
    'Yeterli':   l.perfKabiliyetYeterli,
    'Sınırlı':   l.perfKabiliyetSinirli,
    'Veri yok':  l.perfKabiliyetVeriYok,

    // ── performans_ozeti_servisi — donör sıralaması ───────────────────────
    '1. Donör Adayı':   l.perfDurum1DonorAdayi,
    '2. Donör Adayı':   l.perfDurum2DonorAdayi,
    '3. Donör Adayı':   l.perfDurum3DonorAdayi,

    // ── performans_ozeti_servisi — veri güveni etiketi ────────────────────
    'Güvenilir':         l.perfVeriGuveniGuvenilir,
    'Veri çok sınırlı':  l.perfVeriGuveniCokSinirli,

    // ── performans_ozeti_servisi — kış çıkış ─────────────────────────────
    'Kış çıkış verisi yetersiz.':  l.perfKisCikisVeriYetersiz,

    // ── aksiyon kartı başlıkları ──────────────────────────────────────────
    'Durum':          l.aksiyonDurum,
    'Ne yap':         l.aksiyonNeYap,
    'Neden':          l.aksiyonNeden,
    'Zaman Bağlamı':  l.aksiyonZamanBaglami,

    // ── performans_ozeti_servisi — skor yorumu ────────────────────────────
    'Orta':  l.perfYorumOrta,

    // ── karsilastirma_ozeti_servisi — satır başlıkları ─────────────────────
    'Genetik Seçilim':               l.karsilastirmaGenetikSecilim,
    'Kıştan Çıkış':                  l.karsilastirmaKistanCikis,
    'Biyoloji Durumu':               l.karsilastirmaBiyolojiDurumu,
    'Meme Takibi':                   l.karsilastirmaMemeTakibi,
    'Anasızlık (gün)':               l.karsilastirmaAnasizlikGun,
    'Genetik Veto':                  l.karsilastirmaGenetikVeto,
    'Temiz donör havuzuna giremez':  l.karsilastirmaHavuzaGiremez,
    'Zamanlama ve meme gelişimi':    l.karsilastirmaMemeTakipYorum,

    // ── hat_analiz_servisi — karar / gerekçe string'leri ─────────────────
    'Donör Hat':           l.hatKararDonor,
    'Güçlü Üretim Hattı':  l.hatKararGucluUretim,
    'Takip Edilmeli':      l.hatKararTakip,
    'Operasyonel Hat':     l.hatKararOperasyonel,
    'Riskli Hat':          l.hatKararRiskli,
    'Bu hat için güvenilir karar üretecek kadar yeterli koloni geçmişi oluşmamış.':
        l.hatGerekceVeriYetersiz,
    'Bu hatta oğul kökeni veya gerçekleşmiş oğul olayı bulunduğu için donör hat olarak kabul edilmez.':
        l.hatGerekceOperasyonel,
    'Bu hatta tekrar eden sönme veya yüksek sönme oranı görülüyor.':
        l.hatGerekceRiskli,
    'Hat; gelişim, üretim ve dayanıklılık açısından güçlü ve dengeli görünüyor.':
        l.hatGereceDonor,
    'Hat donör kadar temiz ve güçlü görünmese de üretim omurgası olarak değerlidir.':
        l.hatGerekceGucluUretim,
    'Hat tamamen zayıf görünmüyor; ancak çoğaltma kararı için daha net tekrar ve performans verisi gerekiyor.':
        l.hatGerekceTakip,
    // hat_analiz notlar
    'En az iki koloni ve daha fazla saha tekrarına ihtiyaç var.':   l.hatNotVeriIhtiyac,
    'Bu hat donör çoğaltma için öncelikli adaydır.':                l.hatNotDonorOncelikli,
    'Tekrarlayan sönmeler seçilim açısından güçlü negatif sinyaldir.': l.hatNotTekrarlayanSonme,
    'Tek sönme doğrudan eleme değildir, ama uyarı sinyalidir.':     l.hatNotTekSonme,
    'Hat içinde gelişim gücü olumlu görünüyor.':                    l.hatNotGelisimGuclu,
    'Ortalama bal performansı olumlu ayrışıyor.':                   l.hatNotBalPerformans,
    'Bu hat için izleme devam etmeli.':                             l.hatNotIzlemeDEvam,
    'Kıştan çıkış gücü olumlu görünüyor.':                         l.hatNotKisGuclu,
    // hat_analiz aksiyonlar
    'Bu hat için veri toplamaya devam et':          l.hatAksiyonVeriTopla,
    'Erken damızlık kararı verme':                  l.hatAksiyonErkenKarar,
    'Bu hattan ana üretme':                         l.hatAksiyonAnaUretme,
    'Yeni bölme üretimini sınırlı tut':             l.hatAksiyonSinirliUretim,
    'Üretim veya destek hattı olarak değerlendir':  l.hatAksiyonUretimDestek,
    'Bu hattan bölme yapma':                        l.hatAksiyonBolmeYapma,
    'Donör havuzuna alma':                          l.hatAksiyonDonorHavuzu,
    'Hat elemesini veya ana yenilemeyi değerlendir': l.hatAksiyonHatEleme,
    'Bu hattan ana üret':                           l.hatAksiyonAnaUret,
    'Temiz çoğaltma hattı olarak koru':             l.hatAksiyonTemizHat,
    'Donör havuzunda önceliklendir':                l.hatAksiyonDonorOncelik,
    'Bu hattı üretimde koru':                       l.hatAksiyonUretimdeKor,
    'Sınırlı ve kontrollü bölme düşün':             l.hatAksiyonSinirliKontrolluBolme,
    'Donör değil, üretim omurgası olarak değerlendir': l.hatAksiyonUretimOmurgasi,
    'İzlemeye devam et':                            l.hatAksiyonIzlemeDevam,
    'Kararı ertele, veri biriktir':                 l.hatAksiyonKarariErtele,
    'Kritik kolonilerde muayene sıklığını artır':   l.hatAksiyonMuayeneSiklik,
  };

  // ── Kısmi / prefix eşleşme ───────────────────────────────────────────────
  // Dinamik string'ler için (ör. "Bu koloni 1. donör adayı")

  static String? _kismiEsles(String temiz, AppLocalizations l) {
    final kucuk = temiz.toLowerCase();

    if (kucuk.contains('donör adayı') || kucuk.contains('donor adayi')) {
      return l.kolonDetayDonorAdayi;
    }
    if (kucuk.contains('donör havuzunda') || kucuk.contains('donor havuzunda')) {
      return l.srvDonorHavuzunda;
    }
    if (kucuk.contains('üretim kolonisi') || kucuk.contains('uretim kolonisi')) {
      return l.kolonDetayUretimKolonisi;
    }
    if (kucuk.contains('destek kolonisi')) {
      return l.kolonDetayDestekKolonisi;
    }
    if (kucuk.contains('bölme için uygun') || kucuk.contains('bolme icin uygun')) {
      return l.srvBolmeUygun;
    }
    if (kucuk.contains('bölme önerilmez') || kucuk.contains('bolme onerilmez')) {
      return l.srvBolmeOnerilmez;
    }
    if (kucuk.contains('veri güveni düşük') || kucuk.contains('veri guveni dusuk')) {
      return l.srvVeriGuveniDusuk;
    }

    return null;
  }
}
