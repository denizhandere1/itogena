import 'package:flutter/material.dart';
import 'ana_sayfa_kisayol.dart';

class KullaniciRehberiSayfasi extends StatelessWidget {
  const KullaniciRehberiSayfasi({super.key});

  Widget _madde(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13, height: 1.45)),
          ),
        ],
      ),
    );
  }

  Widget _uyari(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: Colors.deepOrange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13, height: 1.45)),
          ),
        ],
      ),
    );
  }

  Widget _kutu(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.black87),
      ),
    );
  }

  Widget _bolum(String baslik, List<Widget> icerik, {bool acik = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: ExpansionTile(
          initiallyExpanded: acik,
          tilePadding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
          childrenPadding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white,
          title: Text(
            baslik,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w900,
              color: Colors.brown,
            ),
          ),
          children: icerik,
        ),
      ),
    );
  }

  Widget _proTablosu() {
    const satirlar = [
      ['Sınırsız koloni kaydı', true, true],
      ['Muayene formu ve geçmiş', true, true],
      ['Kovan yerleşim görseli', true, true],
      ['Tahmini arı sayısı', true, true],
      ['Özet yorum (tek cümle)', true, true],
      ['Yönetim kararı detayı', false, true],
      ['Risk analizi (Varroa, arı kuşu…)', false, true],
      ['Hasat projeksiyonu ve miktar', false, true],
      ['Ekonomik değer tahmini', false, true],
      ['Demografi ve kabiliyet skorları', false, true],
      ['Koloni projeksiyonu', false, true],
      ['Performans raporları', false, true],
      ['Hat analizi', false, true],
      ['Koloni karşılaştırma', false, true],
      ['Soy ağacı', false, true],
      ['Formüller ve hesaplamalar', false, true],
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text('Özellik',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Colors.black54)),
                ),
                SizedBox(
                  width: 64,
                  child: Center(
                    child: Text('Ücretsiz',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: Colors.black54)),
                  ),
                ),
                SizedBox(
                  width: 48,
                  child: Center(
                    child: Text('PRO',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFFFB300))),
                  ),
                ),
              ],
            ),
          ),
          ...satirlar.asMap().entries.map((e) {
            final i = e.key;
            final satir = e.value;
            final ucretsiz = satir[1] as bool;
            final pro = satir[2] as bool;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: i.isOdd ? Colors.grey.shade50 : Colors.white,
                borderRadius: i == satirlar.length - 1
                    ? const BorderRadius.vertical(bottom: Radius.circular(11))
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(satir[0] as String,
                        style: const TextStyle(fontSize: 12.5, height: 1.3)),
                  ),
                  SizedBox(
                    width: 64,
                    child: Center(
                      child: Icon(
                        ucretsiz ? Icons.check_circle : Icons.remove,
                        size: 18,
                        color: ucretsiz ? Colors.green : Colors.grey.shade300,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    child: Center(
                      child: Icon(
                        pro ? Icons.check_circle : Icons.remove,
                        size: 18,
                        color: pro
                            ? const Color(0xFFFFB300)
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: const Text('KULLANICI REHBERİ',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [AnaSayfaKisayol.aksiyon(context)],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 120),
        children: [

          // ── 1. İTOGENA NE YAPAR? ──────────────────────────────────────
          _bolum('1. İTOGENA Ne Yapar?', [
            _kutu('İTOGENA, basit saha verisini zaman, süreç, soy, performans ve arılık kalibrasyonu ile birlikte okuyarak uygulanabilir koloni kararı üretir. Amaç yalnızca kayıt tutmak değil; arıcıya neyi, neden ve ne zaman yapacağını anlaşılır biçimde göstermektir.'),
            _madde('Sistem tetik → süreç → öneri → saha eylemi → yeni muayene → kapanış mantığıyla çalışır.'),
            _madde('Koloni sınıfı tek biyolojik kaynaktan üretilir: işlevsel üretim çıtası 0–3 ise zayıf, 4–7 ise gelişim, 8–9 ise üretim, 10 ve üzeri ise hasat sınıfıdır.'),
            _madde('Her süreç için ayrıca onay istemez; sonucu sonraki muayene verisinden anlamaya çalışır.'),
            _madde('Koloni detay ekranı hızlı açılır; ağır analizler arka planda yüklenir.'),
            _madde('Sistem fiziksel çıta ile işlevsel üretim kapasitesini ayrı okur. Hızlı genişleme, temel petek yüklenmesi veya hasat sonrası hacim değişimleri doğrudan güçlü koloni kabul edilmez.'),
            _madde('Koloni detay genel durum ekranında dört ana başlık gösterilir: Süreç, Biyoloji, Yönetim ve Genetik.'),
            _madde('Yönetim kartı besleme, kat, alan, varroa, kış ve hasat sonrası bakım kararlarını aynı yönetim listesinde standartlaştırır.'),
            _madde('Muayene, koloni veya arılık verisi değiştiğinde tüm önbellekler birlikte temizlenir; eski kararın ekranda kalma riski azaltılır.'),
          ], acik: true),

          // ── 2. ÜCRETSİZ VE PRO ───────────────────────────────────────
          _bolum('2. Ücretsiz ve PRO', [
            _kutu('ITOGENA\'yı muayene kaydı ve temel koloni takibi için ücretsiz kullanabilirsin. Derin analiz, risk izleme, hasat tahmini ve raporlama PRO kapsamındadır.'),
            _proTablosu(),
          ], acik: true),

          // ── 3. ÇITA ──────────────────────────────────────────────────
          _bolum('3. Sistem Çıtadan Ne Anlar?', [
            _madde('Çıta sayısı koloni gücünün temel saha göstergesidir; tek başına kesin karar değildir.'),
            _madde('Son çıta mevcut canlı gücü, maksimum çıta sezon içi kapasiteyi, bal çıtası ise üretim dönemindeki verimi anlatır.'),
            _madde('Kışta çıta gücü dayanıklılık için önemlidir; bal çıtası kış performansı gibi okunmaz.'),
            _madde('Sistem çıta sayısını yalnızca sayı olarak değil, tahmini biyolojik kapasite olarak okur: arı nüfusu, göz kapasitesi, yavru/stok alanı, ana bölgesi ve hasat potansiyeli bu veriden türetilir.'),
            _madde('Bu değerler kesin ölçüm değildir; iklim, flora, arı ırkı, sezon ve yönetim farkları sonucu değiştirebilir.'),
            _madde('Langstroth varsayılan referanstır. Dadant seçilirse aynı biyolojik düzen korunur ancak çıta kapasitesi daha yüksek katsayıyla hesaplanır.'),
            _madde('Şurupluk varsa alt kuluçkalık 9 çıta, yoksa 10 çıta kabul edilir. Bu sınırın üstündeki çıtalar kat/ballık alanı olarak yorumlanır.'),
          ]),

          // ── 3B. HACİM AKTİVASYONU ────────────────────────────────────
          _bolum('3B. İşlevsel Çıta ve Hacim Aktivasyonu', [
            _madde('İTOGENA fiziksel çıta ile işlevsel çıtayı ayrı okur. Kovandaki çıta sayısı fiziksel hacmi, koloninin gerçekten kullanabildiği alan ise işlevsel biyolojik kapasiteyi anlatır.'),
            _madde('Yeni verilen çıta hemen tam kapasite sayılmaz. Sistem temel petek veya kabarmış petek ayrımına, geçen gün sayısına, yavru düzenine, koloni gücüne ve bal akımı penceresine göre aktivasyon süresi hesaplar.'),
            _madde('Sistem sıkışık düzen varsayımıyla çalışır. Bir muayenede +1 çıta normal, +2 çıta kontrollü genişleme, +3 ve üzeri ise kat geçişi dışında uyarı sebebidir.'),
            _madde('Şurupluk + 9 çıta veya şurupluksuz 10 çıta %95 ve üzeri aktivasyona ulaşırsa sistem bunu "Kat ver" eşiği olarak okur.'),
            _madde('Şurupluk + 19 çıta veya şurupluksuz 20 çıta %95 ve üzeri aktivasyona ulaşırsa sistem "3. kat ver" uyarısı üretir.'),
            _madde('Hasat kaydıyla birlikte oluşan hızlı çıta düşüşü biyolojik çöküş sayılmaz; sistem bunu hasat kaynaklı hacim daralması olarak normalleştirir.'),
          ]),

          // ── 3C. SEZON BİYOLOJİ MATRİSİ ──────────────────────────────
          _bolum('3C. Sezon Biyoloji Matrisi', [
            _madde('İTOGENA sezonu yalnızca takvim adı olarak okumaz. Her sezon için yavru beklentisi, stok baskısı, polen/arı ekmeği beklentisi, ana amaç ve aktivasyon katsayısı birlikte değerlendirilir.'),
            _madde('Sistem kış, kış çıkışı, ilkbahar gelişimi, bal akımı öncesi, bal akımı, hasat sonrası, sonbahar hazırlık ve geç sonbahar evrelerini ayrı biyolojik davranışlar olarak ele alır.'),
            _madde('Bu matris koloniye doğrudan emir vermez; aktivasyon, kabiliyet, besleme, hasat ve bölme kararlarına biyolojik bağlam sağlar.'),
            _madde('Sezon bilgisi yerel bal akımı kalibrasyonu ile birlikte okunur. Bu nedenle aynı tarih her arılıkta aynı karar anlamına gelmeyebilir.'),
          ]),

          // ── 3D. KOLONİ GİDİŞATI ──────────────────────────────────────
          _bolum('3D. Koloni Gidişatı ve Normalize Momentum', [
            _madde('Koloni Gidişatı, koloninin yalnız bugünkü gücünü değil hangi yöne gittiğini anlatır. Momentum bu hesabın içinde yaşar.'),
            _madde('Momentum artık ham çıta artışı değildir. Hasat sonrası hızlı düşüş biyolojik çöküş sayılmaz; bölme sonrası düşüş işlem kaynaklı okunur; kat atılması ise fiziksel hacim artışı olduğu için aktivasyon tamamlanmadan tam büyüme kabul edilmez.'),
            _madde('Kat geçişi, riskli hızlı genişleme, düşük aktivasyon ve bal akımı içindeki sağlıklı üst hacim genişlemesi ayrı ayrı normalize edilir.'),
            _madde('Performans sekmesindeki Koloni Gidişatı; gelişim yönü, üretim yönü, alan baskısı, toparlanma potansiyeli, çöküş riski ve normalize momentumu birlikte okur.'),
          ]),

          // ── 3E. DEMOGRAFİ MOTORU ─────────────────────────────────────
          _bolum('3E. Demografi Motoru', [
            _madde('Demografi motoru kesin arı sayımı yapmaz; çıta gücü, yavru yükü, sezon ve gelişim yönünden koloni içindeki iş gücü dağılımını tahmin eder.'),
            _madde('Sistem genç işçi, bakıcı arı, petek işleyici, iç işçi, bekçi, tarlacı ve erkek arı dağılımını saha kararı için ayrı ayrı okur.'),
            _madde('Genç işçi kapasitesi ham petek ve yavru bakım kararlarında; tarlacı kapasitesi bal akımı ve üretim kararlarında kullanılır.'),
            _madde('Demografi çıktısı "kesin nüfus" değildir; biyolojik olasılık ve saha projeksiyonudur.'),
          ]),

          // ── 3F. İŞ GÜCÜ VE KABİLİYET MOTORU ────────────────────────
          _bolum('3F. İş Gücü ve Kabiliyet Motoru', [
            _madde('İTOGENA yalnızca kaç arı olduğunu değil, bu arıların hangi işi yapabilecek biyolojik kapasitede olduğunu yorumlamaya çalışır.'),
            _madde('Petek örme, yavru bakım, nektar toplama, bal işleme, savunma, toparlanma, kış dayanımı ve çiftleşme desteği ayrı iş gücü alanları olarak değerlendirilir.'),
            _madde('Aynı çıta sayısına sahip iki koloni farklı iş gücü kapasitesine sahip olabilir. Genç işçi oranı düşük koloniler geniş görünse bile hızlı petek işleme veya yavru büyütmede zorlanabilir.'),
            _madde('Bu motor kesin biyolojik ölçüm yapmaz; saha kararını destekleyen açıklanabilir biyolojik eğilim modeli üretir.'),
          ]),

          // ── 3G. RİSK MOTORU ──────────────────────────────────────────
          _bolum('3G. Risk Motoru ve Doğal Risk Frenleri', [
            _madde('Risk motoru koloniyi korkutucu uyarılarla yönetmez; sezonun doğal risk primini ve koloninin biyolojik kırılganlığını birlikte okuyarak dengeli karar freni üretir.'),
            _madde('Varroa, arı kuşu, eşek arısı, yağmacılık, nem/kış, aşırı genişleme, yavrusuzluk/yaşlanma ve bal kalitesi riski aynı merkezde değerlendirilir.'),
            _madde('Risk freni kararları doğrudan yasaklamaz. Genişletme, bölme, besleme, hasat ve müdahale önerilerini küçük katsayılarla temkinli hale getirir.'),
            _madde('Bu sistem kesin hastalık veya zararlı teşhisi koymaz; açıklanabilir risk eğilimi üretir.'),
          ]),

          // ── 3H. KARAR ORKESTRATÖRÜ ───────────────────────────────────
          _bolum('3H. Karar Orkestratörü', [
            _madde('Karar orkestratörü yeni karar üretmez; süreç, yönetim, risk, projeksiyon ve genetik sinyallerini tek öncelik düzeninde sıralar.'),
            _madde('Amaç aynı anda çok sayıda doğru bilginin kullanıcıyı yormasını engellemektir. Sistem o anda sahada en önemli olan tek ana sesi öne çıkarır.'),
            _madde('Kritik süreçler açıkken genetik övgü veya düşük öncelikli projeksiyonlar geri plana alınabilir.'),
            _madde('Orkestrasyon bastırma değil, bağlam yönetimidir. Bilgi tamamen kaybolmaz.'),
          ]),

          // ── 4. BÖLME ─────────────────────────────────────────────────
          _bolum('4. Bölme Neden 9 Çıta Altında Önerilmez?', [
            _madde('6 çıta biyolojik olarak mümkün olabilir; fakat güvenli saha önerisi değildir.'),
            _madde('İTOGENA mümkün olanı değil, arıcıyı koloni kaybı riskinden koruyan doğru öneriyi verir.'),
            _madde('Bölme önerisi için güvenli eşik 9 çıtadır. Ana koloni bölmeden sonra en az 5 çıta kalabilmeli, yeni bölme en az 4 çıta başlayabilmelidir.'),
            _madde('6–8 çıta arası riskli kabul edilir; sistem bölme önermek yerine önce güçlendirmeyi söyler.'),
            _madde('Kış döneminde bölme önerisi üretilmez.'),
            _madde('Bölme kararı zaman bağlamıyla okunur. Bal akımına 57 günden fazla varsa güçlü kolonide bölme anlamlıdır; 57 günden az kaldıysa standart bölme üretim gücünü düşürebilir.'),
          ]),

          // ── 5. KIŞ ───────────────────────────────────────────────────
          _bolum('5. Kışta Bal Neden Performans Değildir?', [
            _madde('Kışta bırakılan bal arıcının bölge, iklim ve yönetim tercihine bağlıdır.'),
            _madde('Bazı yörelerde bal soğuktan çözülemediği için arı tarafından kullanılamayabilir.'),
            _madde('Bu nedenle kış skorunda bal/verim metriği kullanılmaz; canlı arı gücü, sağlık, ana yaşı, varroa yönetimi ve kıştan çıkış gücü dikkate alınır.'),
          ]),

          // ── 6. BESLEME ───────────────────────────────────────────────
          _bolum('6. Besleme Neden Ceza Değildir?', [
            _madde('Besleme performans değildir; iyi yönetim sinyalidir.'),
            _madde('Besleme yapıldı diye bal/verim skoru düşürülmez.'),
            _madde('Son muayenelerde besleme yapılmış ve koloni sağlıklı gelişiyorsa küçük olumlu bakım sinyali oluşabilir.'),
            _madde('Beslemeye rağmen gelişim yoksa sistem bunu "beslemeye rağmen gelişim zayıf" şeklinde yorumlayabilir.'),
          ]),

          // ── 7. DONÖR SKORU ────────────────────────────────────────────
          _bolum('7. Donör Skoru ile Genel Skor Farkı Nedir?', [
            _madde('Genel skor koloninin saha performansıdır.'),
            _madde('Donör skoru ana üretimi ve genetik seçilim değeridir.'),
            _madde('85 genel skor tek başına donörlük anlamına gelmez. Oğul izi/genetik filtre, soy devamlılığı, üreme gücü, dayanıklılık ve veri güveni ayrıca okunur.'),
            _madde('Güçlü ama genetik filtreye takılan koloni üretimde veya kapalı yavru desteğinde değerlendirilebilir; ana üretim havuzuna alınmaz.'),
          ]),

          // ── 8. OĞUL ─────────────────────────────────────────────────
          _bolum('8. Oğul İzi ve Oğul Sonrası Süreç', [
            _madde('Oğul sağlık problemi değildir; bu nedenle sağlık skorunu düşürmez.'),
            _madde('Oğul kökeni veya oğul izi taşıyan koloni donör havuzuna girmez.'),
            _madde('Oğul attı işaretlenirse koloni geçici olarak üretim/hasat kolonisi gibi okunmaz. 0–7. gün arası artçı oğul riski en yüksektir.'),
            _madde('8–16. gün arası artçı oğul riski azalır. 17–30. gün yeni ana çıkışı, olgunlaşma ve çiftleşme penceresidir.'),
            _madde('31–45. gün arası yumurtlama artık netleşmelidir. Hâlâ yavru yoksa sistem bunu ana başarısızlığı veya yalancı ana riski olarak değerlendirir.'),
          ]),

          // ── 9. YAVRU YOK ─────────────────────────────────────────────
          _bolum('9. Yavru Yok Alarmı ve Karar Önceliği', [
            _madde('Yavru yok en kritik biyolojik alarmlardan biridir. Sistem önce bunun aktif bölme, oğul sonrası veya ana kazanma penceresinde normal bekleme olup olmadığını kontrol eder.'),
            _madde('Bekleme penceresi aşılmışsa yavru yok; varroa, besleme ve hasat gibi rutin kararların önüne geçer. Grid kartta önce koloni devamlılığı konuşur.'),
            _madde('Yalancı ana şüphesi, erkek yavru baskısı, ardışık yavrusuz kayıt ve güç düşüşü birlikte görülürse sistem bunu yüksek öncelikli ana problemi olarak ele alır.'),
            _madde('Bal akımı içinde güçlü bal baskısı varsa yavru yokluğu hemen anasızlık sayılmaz; önce alan ve bal baskısı değerlendirilir.'),
          ]),

          // ── 10. ANA KAZANMA ───────────────────────────────────────────
          _bolum('10. Ana Kazanma Süreci Nasıl Okunur?', [
            _madde('Ana kazanma süreci anasız bırakıldı, bölme, kapalı ana memesi veya hazır ana gibi tetiklerle başlar.'),
            _madde('Kendi anasını yapacak kolonide 5. gün kapalı memeler bozulur; açık/kapanmamış kaliteli memeler bırakılır.'),
            _madde('Hazır ana verilen kolonide süreç kabul ve yumurtlama kontrolüne göre okunur.'),
            _madde('Günlük veya kapalı yavru görüldüğünde ana varlığı dolaylı kabul edilir ve ilgili ana kazanma süreci kapanabilir.'),
          ]),

          // ── 11. HASAT SONRASI ─────────────────────────────────────────
          _bolum('11. Hasat Sonrası Süreç Neden Bakım Sürecidir?', [
            _madde('Hasat sonrası dönem biyolojik ana kazanma süreci değildir; kışa hazırlık bakım sürecidir.'),
            _madde('Bu süreç günlük/kapalı yavru görüldü diye kapanmaz. Varroa mücadelesi, besleme ve sıkıştırma gibi bakım eylemleri süreci hafifletir veya kapatır.'),
            _madde('Hasat sonrası ilk amaç koloniyi sıkışık düzene almak ve stresi azaltmaktır.'),
            _madde('Hasat sonrası güçlü görünen koloni bile varroa ve bakım ihmal edilirse kışa zayıf girebilir.'),
          ]),

          // ── 12. BAL AKIMI ─────────────────────────────────────────────
          _bolum('12. Bal Akımı 57/42 Gün Mantığı Nedir?', [
            _madde('42 gün yumurtadan tarlacı arıya uzanan biyolojik süredir.'),
            _madde('57 gün saha planlama eşiğidir: 42 günlük biyolojiye yaklaşık 15 gün güvenlik payı eklenir.'),
            _madde('Karar motoru bölme önerisini bu 57 günlük saha penceresine göre ciddiye alır. Zaman uygun değilse güçlü koloni bile otomatik bölme adayı yapılmaz.'),
            _madde('Bal akımına 24 gün veya daha az kaldığında alan, kat, kalıntı güvenliği ve oğul kontrolü öne çıkar.'),
            _madde('Ana değişimi için en güçlü karar penceresi hasat sonrası / sonbahara giriş dönemidir.'),
          ]),

          // ── 13. VARROA ────────────────────────────────────────────────
          _bolum('13. Varroa Uyarıları Nasıl Çalışır?', [
            _madde('Varroa uyarıları sezon ve bal akımı penceresiyle birlikte okunur.'),
            _madde('Bal akımı öncesi ve sırasında kalıntı riski dikkate alınır.'),
            _madde('Hasat sonrası / yaz sonu erken sonbahar dönemi kışı taşıyacak arıların sağlığı için kritik kabul edilir.'),
            _madde('Oksalik, timol, amitraz, formik ve benzeri uygulamalarda ürün etiketi, ruhsat durumu ve yerel mevzuat esas alınmalıdır.'),
          ]),

          // ── 14. VERİ GÜVENİ ───────────────────────────────────────────
          _bolum('14. Veri Güveni Ne Demektir?', [
            _madde('Tek muayeneli kolonide sistem karar verir ama veri güveni düşük der.'),
            _madde('2–4 muayene izleme bandıdır. 5 ve üzeri muayene güvenilir değerlendirme başlangıcıdır.'),
            _madde('Veri güveni, kararın neden güçlü veya sınırlı olduğunu açıklamak için gösterilir; kullanıcıyı kararsız bırakmak için değildir.'),
          ]),

          // ── 15. BİYOLOJİK MODEL ──────────────────────────────────────
          _bolum('15. Biyolojik Model ve Kabiliyet Analizi Nedir?', [
            _madde('İTOGENA çıta sayısını yalnızca sayı olarak okumaz; standart koloni organizasyonu üzerinden tahmini kuluçkalık dizilimi, yavru bloğu, stok alanı ve hasat adayı dış çıtaları yorumlar.'),
            _madde('Kovan tipi Langstroth veya Dadant olarak seçilebilir. Şurupluk varsa alt kuluçkalık 9 çıta, yoksa 10 çıta kabul edilir.'),
            _madde('Temporal polyethism mantığıyla işçi arıların yaşa bağlı görev dağılımı tahmin edilir: bakıcı arı, petek örücü, iç işçi, tarlacı ve erkek arı yoğunluğu kabiliyet puanı olarak kullanılır.'),
            _madde('Sistem "şu çıtaları hasat et" derken kesin hüküm vermez; yalnızca tahmini yerleşime göre yavrusuz ve sırlı olması halinde hasat için değerlendirilebilecek dış/ballık çıtaları işaret eder.'),
          ]),

          // ── 16. KIŞ YÖNETİMİ ─────────────────────────────────────────
          _bolum('16. Kış Yönetimi Nasıl Çalışır?', [
            _madde('Kış döneminde ana hedef üretim değil yaşatmadır. Sistem gereksiz kovan açmayı önleyecek şekilde dış gözlem, ağırlık hissi ve nem/su girişi kontrolünü öne alır.'),
            _madde('Stok çok düşük görünüyorsa açlık riski minimum müdahale kuralından daha yüksek öncelik alır.'),
            _madde('Fiziksel hacim yüksek ama işlevsel arı gücü düşükse sistem boş hacim ve ısı kaybı riskini belirtir.'),
          ]),

          // ── 17. GENETİK ÇOĞALTMA ─────────────────────────────────────
          _bolum('17. Genetik Çoğaltma Değeri Nasıl Okunur?', [
            _madde('Genetik çoğaltma değeri yalnızca bal veya çıta sayısı değildir. İşlevsel kapasite, yavru düzeni, gelişim yönü, aktivasyon, risk, stok/kış güvenliği ve oğul izi birlikte okunur.'),
            _madde('Oğul kökeni veya oğul izi görülen koloniler üretimde değerli olabilir; ancak temiz genetik yayılım adayı olarak otomatik öne çıkarılmaz.'),
            _madde('Bu skor kesin damızlık hükmü değildir; çoğaltmaya değer kolonileri izleme ve doğru zamanda kontrollü bölme kararını destekleyen stratejik sinyaldir.'),
          ]),

          // ── 18. EKONOMİK DEĞER ───────────────────────────────────────
          _bolum('18. Ekonomik Değer Neyi İfade Eder?', [
            _madde('Ekonomik değer ekranı kesin gelir hesabı değil, yaklaşık arılık varlığı ve tahmini bal potansiyeli projeksiyonudur.'),
            _madde('Aktif kovan sayısı, toplam arılı çıta, boş kovan, kabarmış petek ve tahmini hasat edilebilir bal potansiyeli birlikte okunur.'),
            _madde('Kullanıcı bal kg satış fiyatını girer; sistem tahmini hasat potansiyelini bu fiyatla çarpar ve potansiyel değer bandı üretir.'),
            _madde('Bal verimi flora, hava, hasat zamanı, bırakılacak stok ve arıcının yönetimine bağlı olarak değişir.'),
          ]),

          // ── 19. BESLEME KARAR MOTORU ──────────────────────────────────
          _bolum('19. Besleme Karar Motoru Nasıl Çalışır?', [
            _madde('Besleme önerileri kesin stok ölçümü değildir; çıta gücü, yavru alanı, sezon, aktif süreç, bal akımı penceresi ve kullanıcının muayene gözlemi birlikte değerlendirilir.'),
            _madde('Sistem kesin reçete vermez; tahmini ml/L veya gram bandı üretir.'),
            _madde('1:1 şurup daha çok gelişim desteği; 2:1 şurup stok tamamlama; polenli destek ise yalnızca polen baskısı sahada doğrulanırsa anlamlı kabul edilir.'),
            _madde('Bal akımına 20 gün veya daha az kalmışsa ve koloni hasat hedefindeyse şeker bazlı besleme önerilmez.'),
          ]),

          // ── 20. KARAR UZLAŞTIRICI ────────────────────────────────────
          _bolum('20. Karar Uzlaştırıcı Neyi Önceliklendirir?', [
            _madde('Karar uzlaştırıcı aynı anda üretilen süreç, yönetim, biyoloji ve genetik sinyallerini sahaya çıkmadan önce çelişki açısından süzer.'),
            _madde('Müdahale edilmemesi gereken ana kazanma, bölme sonrası hassas dönem, oğul sonrası, yavru yok tanı süreci ve kış dönemi gibi pencerelerde kat, bölme ve yoğun besleme önerileri bastırılır.'),
            _madde('Veto veya bekleme kararları eylem sayılmaz. Bu nedenle "besleme önerilmez" veya "gereksiz açma yok" gibi koruyucu kararlar ekranda kalabilir.'),
          ]),

          // ── 21. KARAR SÖZLÜĞÜ ────────────────────────────────────────
          _bolum('21. İTOGENA Karar Sözlüğü', [
            _kutu('Bu bölüm, ekranda görülen kavramların ne anlama geldiğini açıklar.'),
            _madde('Koloni Gidişatı: Koloninin yalnız bugünkü gücünü değil, hangi yöne ilerlediğini anlatır.'),
            _madde('Koloni Gücü: Son muayenedeki canlı arı ve çıta gücünü anlatır.'),
            _madde('Koloni Sağlığı: Yavru düzeni, ana süreci, yavrusuzluk, varroa dönemi, davranış ve risk sinyallerinin birlikte okunmasıdır.'),
            _madde('İşlevsel Çıta: Kovandaki fiziksel çıta sayısı değil, arının gerçekten kullandığı biyolojik kapasitedir.'),
            _madde('Hacim Aktivasyonu: Verilen çıta veya katın koloni tarafından ne kadar kullanılır hale geldiğini anlatır.'),
            _madde('Normalize Momentum: Kısa dönem çıta artışı veya düşüşünü ham şekilde okumaz. Hasat sonrası düşüş, bölme, kat geçişi ve riskli hızlı genişleme ayrılır.'),
            _madde('Genetik Filtre: Koloninin üretimde değerli olabileceği halde ana üretme havuzuna alınmamasıdır.'),
            _madde('Yönetim Kararı: Besleme, kat, alan, hasat sonrası bakım, varroa ve kış hazırlığı gibi arıcının sahada yapacağı işleri anlatır.'),
            _madde('Süreç: Ana kazanma, bölme sonrası toparlanma, oğul sonrası veya yavru yok tanısı gibi zamana bağlı biyolojik/yönetim penceresidir.'),
            _madde('Kilit / Bekle: Müdahale edilmemesi gereken hassas pencereyi anlatır.'),
            _madde('Veri Güveni: Kararın kaç muayeneye dayandığını anlatır.'),
          ]),

          // ── 22. KESİN HÜKÜM VERMEDİĞİ KONULAR ───────────────────────
          _bolum('22. Uygulama Hangi Konularda Kesin Hüküm Vermez?', [
            _uyari('İTOGENA veterinerlik, ruhsatlı ilaç kullanımı veya resmi mevzuat yerine geçmez.'),
            _uyari('Kimyasal mücadelede ürün etiketi, ruhsatlı kullanım talimatı, koruyucu ekipman ve yerel mevzuat esas alınmalıdır.'),
            _uyari('Hava, flora, yöresel nektar akımı, arıcı deneyimi ve koloni davranışı sahada ayrıca gözlenmelidir.'),
            _uyari('Sistem doğru kararı destekler; son sorumluluk sahadaki arıcıdadır.'),
          ]),

          // ── 23. SESLİ NOT ─────────────────────────────────────────────
          _bolum('23. Sesli Not', [
            _madde('Not alanında mikrofon ikonuna basarak konuşarak not girebilirsiniz.'),
            _madde('Konuşma otomatik olarak metne çevrilir ve not alanına eklenir.'),
            _uyari('Rüzgar, arı sesi, cihaz mikrofonu ve bazı cihazlarda internet bağlantısı algılamayı etkileyebilir.'),
          ]),
        ],
      ),
    );
  }
}
