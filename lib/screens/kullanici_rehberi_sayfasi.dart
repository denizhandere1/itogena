import 'package:flutter/material.dart';
import 'ana_sayfa_kisayol.dart';

class KullaniciRehberiSayfasi extends StatelessWidget {
  const KullaniciRehberiSayfasi({super.key});

  Widget _baslik(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: Colors.brown,
        ),
      ),
    );
  }

  Widget _madde(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, height: 1.45),
            ),
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
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kutu(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          height: 1.5,
          color: Colors.black87,
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
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        children: [
          // Başlık satırı
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    'Özellik',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(
                  width: 64,
                  child: Center(
                    child: Text(
                      'Ücretsiz',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 48,
                  child: Center(
                    child: Text(
                      'PRO',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFFFB300),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Satırlar
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
                    ? const BorderRadius.vertical(bottom: Radius.circular(15))
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      satir[0] as String,
                      style: const TextStyle(fontSize: 12.5, height: 1.3),
                    ),
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
                        color: pro ? const Color(0xFFFFB300) : Colors.grey.shade300,
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
        title: const Text(
          'KULLANICI REHBERİ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [AnaSayfaKisayol.aksiyon(context)],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          _baslik('1. İTOGENA NE YAPAR?'),
          _kutu(
            'İTOGENA, basit saha verisini zaman, süreç, soy, performans ve arılık kalibrasyonu ile birlikte okuyarak uygulanabilir koloni kararı üretir. Amaç yalnızca kayıt tutmak değil; arıcıya neyi, neden ve ne zaman yapacağını anlaşılır biçimde göstermektir.',
          ),
          _madde(
            'Sistem tetik → süreç → öneri → saha eylemi → yeni muayene → kapanış mantığıyla çalışır.',
          ),
          _madde(
            'Koloni sınıfı tek biyolojik kaynaktan üretilir: işlevsel üretim çıtası 0–3 ise zayıf, 4–7 ise gelişim, 8–9 ise üretim, 10 ve üzeri ise hasat sınıfıdır. Yönetim, besleme, kat ve hasat yorumları bu ortak sınıfa göre filtrelenir.',
          ),
          _madde(
            'Her süreç için ayrıca onay istemez; sonucu sonraki muayene verisinden anlamaya çalışır.',
          ),
          _madde(
            'Koloni detay ekranı hızlı açılır; ağır analizler arka planda yüklenir.',
          ),
          _madde(
            'Sistem fiziksel çıta ile işlevsel üretim kapasitesini ayrı okumaya çalışır. Hızlı genişleme, temel petek yüklenmesi veya hasat sonrası hacim değişimleri doğrudan güçlü koloni kabul edilmez.',
          ),
          _madde(
            'Hacim aktivasyonu kullanıcıya toplam fiziksel hacim üzerinden gösterilir. Örneğin 16 fiziksel çıtanın 15.6 çıtası işlevsel okunuyorsa sistem bunu yaklaşık %98 toplam hacim aktivasyonu olarak yansıtır.',
          ),
          _madde(
            'Aynı koloni için süreç ve biyolojik model hesapları tek oturum içinde önbelleğe alınır; besleme, performans ve biyolojik model sekmeleri aynı hesabı tekrar tekrar üretmez.',
          ),
          _madde(
            'Koloni detayında bağlam önceliği kullanılır. Canlı biyolojik süreç varsa ana karar alanında o konuşur; hasat sonrası gibi bakım süreçleri yaşamaya devam eder ama gerekiyorsa alt sıraya düşer.',
          ),
          _madde(
            'Koloni detay genel durum ekranında dört ana başlık birlikte gösterilir: Süreç, Biyoloji, Yönetim ve Genetik. Kartlar kompakt özet verir; kullanıcı karta dokunduğunda alttaki detay paneli doğrudan o başlığın açıklamasını gösterir.',
          ),
          _madde(
            'Yönetim kartı artık beslemeyi ayrı bir ikinci karar motoru gibi okumaz. Besleme, kat, alan, varroa, kış ve hasat sonrası bakım kararları aynı yönetim listesinde standartlaştırılır; çelişen kararlar bağlam uzlaştırıcı tarafından bastırılır. Şurupluk kaldırma kullanıcıya karar olarak gösterilmez; biyolojik model içinde kapasite verisi olarak kullanılır.',
          ),
          _madde(
            'Koloni grid kartı artık kendi içinde yavru yok, alarm veya yönetim kararı hesaplamaz. Grid hafif context üzerinden yalnızca özet sinyali gösterir; ağır biyolojik model ve detaylı karar hesapları koloni detay ekranında kalır.',
          ),
          _madde(
            'Faz 1 sadeleşmesinde detay context, grid context, karar orkestratörü ve bağlam kilidi ayrıştırıldı. Bağlam Motoru yalnızca veto/kilit/engel mantığını taşır; hangi kararın görünür olacağı Karar Orkestratörü tarafından belirlenir.',
          ),
          _madde(
            'Muayene, koloni veya arılık verisi değiştiğinde karar, biyoloji, performans, detay context ve grid context önbellekleri birlikte temizlenir. Böylece eski kararın ekranda kalma riski azaltılır.',
          ),
          _madde(
            'Süreç kartı zaman hassasiyeti olan uyarıları öne çıkarır. Koloniyi açma, ana kazanma, oğul sonrası hassas dönem gibi bilgiler genetik değerlendirme içinde kaybolmaz; ayrı süreç alanında görünür.',
          ),
          _madde(
            'Yavru düzeni “Yok” seçilirse sistem bunu doğrudan anasızlık alarmı saymaz. Önce aktif bölme, oğul sonrası veya ana kazanma penceresini ve geçen günü okur; erken dönemde normal biyolojik bekleme, gecikmiş dönemde ise yavrusuzluk tanısı üretir.',
          ),
          _madde(
            'Yavrusuzluk tanısı yeni servis açmadan Süreç Motoru içinde çalışır. Sistem çıta gücü, ardışık yavrusuz kayıt, gelişim yönü, bal akımı, arı kuşu riski, erkek yavru/kambur yavru ve yalancı ana şüphesini birlikte değerlendirir.',
          ),
          _madde(
            'Küçük ve uzun süredir yavrusuz kolonilerde sistem yoğun emek harcatmak yerine geri dönüş kapasitesini sorgular; gerekirse birleştirme veya sınırlı müdahale yönünde saha diliyle uyarı üretir.',
          ),
          _madde(
            'Sistem aynı anda oluşan süreçleri tarih, biyolojik önem ve aktiflik durumuna göre sıralar. En yeni ve en kritik olay ana karar alanında görünür; eski ama devam eden süreçler daha alt sıraya düşebilir.',
          ),
          _madde(
            'Süreçler tamamen silinmez; başlangıç tarihi, kapanış tetikleri ve süre aşımıyla arka planda izlenir. Kullanıcı yalnızca o anda en doğru saha bilgisini görür.',
          ),
          _madde(
            'Bir süreç görünürlüğünü kaybetse bile tamamen kapanmış olmayabilir. Sistem daha kritik biyolojik olay oluştuğunda eski süreçleri arka plana düşürebilir.',
          ),
          _madde(
            'Hasat sonrası bakım kartı bal çıtası kaydıyla başlar. İlk günlerde sıkışık düzen, stres azaltma, besleme ihtiyacı ve varroa penceresi öne çıkar; bakım veya süre tamamlandıkça geri plana düşer.',
          ),

          _madde(
            'Level 2 karar mimarisinde sistem her koloni için hedef sınıfını içeriden hesaplar: bal ana kolonisi, genetik çoğaltma adayı, bölme sonrası toparlanma, riskli ana süreci, zayıf destek, hasat kolonisi, kısa hazırlık veya kış hedefi. Kullanıcıdan yeni veri girişi istenmez.',
          ),
          _madde(
            'Beklenmeyen durumlar ayrı ve dağınık uyarılar olarak değil, ana sezon senaryosunun olasılık dalları olarak okunur. Örneğin bölme sonrası yavru görülmez ve güç düşerse sistem bunu “bölme toparlanmıyor” sapması olarak yorumlar.',
          ),
          _madde(
            'Karar uzlaştırıcı; hedef, süreç, biyoloji, yönetim ve genetik sinyalleri ekrana çıkmadan önce çelişki açısından süzer. Müdahale edilmemesi gereken pencere açıksa kat, bölme veya yoğun besleme gibi eylemler bastırılır.',
          ),

          _madde(
            'Level 3 karar sözlüğü ile hedef, süreç, yönetim, biyoloji, genetik, sapma ve kilit sinyalleri aynı ortak anahtarlarla standartlaştırılır. Bu yeni ekran veya yeni veri girişi değildir; mevcut kararların ekrana çıkmadan önce aynı disipline girmesidir.',
          ),
          _madde(
            'Karar sinyalleri artık yalnızca metin olarak değil; katman, karar tipi, öncelik, bastırılabilirlik ve grid/detay görünürlüğüyle birlikte değerlendirilir. Böylece “bekle” penceresi açıkken kat, bölme, yoğun besleme veya kalıntı riski taşıyan işlemler sahaya çelişkili öneri olarak çıkmaz.',
          ),

          _madde(
            'Level 5 skor mimarisinde genetik çoğaltma değeri basit performans puanı olmaktan çıkarıldı. Sistem biyolojik kapasite, yavru istikrarı, gelişim yönü, aktivasyon kalitesi, süreç güvenliği ve kış/stok güvenliğini birlikte okuyarak çoğaltma değerini hesaplar.',
          ),
          _madde(
            'Bu skor operasyon kararı değildir. Koloni genetik olarak değerli görünse bile bölme, kat, besleme veya bekleme kararı sezon penceresi ve karar uzlaştırıcı tarafından ayrıca süzülür.',
          ),
          _madde(
            'Level 6 saha sadeleştirmesinde koloni grid kartlarında fiziksel çıta ve işlevsel/aktivasyon bilgisi tekrar görünür hale getirildi. Kısa karar etiketi bu bilginin yerine geçmez; yalnızca ikinci satırda destek sinyali olarak görünür.',
          ),
          _madde(
            'Bal akımı döneminde zayıf koloniler hasat kolonisi gibi okunmaz. Bu koloniler için bakım, stok ve gelişim takibi öne çıkar; kış vurgusu yalnızca sonbahar/kış hazırlık döneminde kullanılır.',
          ),
          _madde(
            'Karar metinleri uygulamanın kendi işleyişini anlatmak yerine doğrudan saha sonucunu ve kısa gerekçesini verir. Tekrarlayan besleme/varroa uyarıları uzlaştırıcı tarafından tekilleştirilir.',
          ),

          _baslik('2. ÜCRETSİZ VE PRO'),
          _kutu(
            'ITOGENA\'yı muayene kaydı ve temel koloni takibi için ücretsiz kullanabilirsin. Derin analiz, risk izleme, hasat tahmini ve raporlama PRO kapsamındadır.',
          ),
          _proTablosu(),

          _baslik('3. SİSTEM ÇITADAN NE ANLAR?'),
          _madde(
            'Çıta sayısı koloni gücünün temel saha göstergesidir; tek başına kesin karar değildir.',
          ),
          _madde(
            'Son çıta mevcut canlı gücü, maksimum çıta sezon içi kapasiteyi, bal çıtası ise üretim dönemindeki verimi anlatır.',
          ),
          _madde(
            'Kışta çıta gücü dayanıklılık için önemlidir; bal çıtası kış performansı gibi okunmaz.',
          ),
          _madde(
            'Sistem çıta sayısını yalnızca sayı olarak değil, tahmini biyolojik kapasite olarak okur: arı nüfusu, göz kapasitesi, yavru/stok alanı, ana bölgesi ve hasat potansiyeli bu veriden türetilir.',
          ),
          _madde(
            'Bu değerler kesin ölçüm değildir. Uluslararası akademik kabuller, saha uygulamaları ve ortalama biyolojik projeksiyonlar üzerinden hesaplanan yardımcı kararlardır; iklim, flora, arı ırkı, sezon ve yönetim farkları sonucu değiştirebilir.',
          ),
          _madde(
            'Langstroth varsayılan referanstır. Dadant seçilirse aynı biyolojik düzen korunur ancak çıta kapasitesi daha yüksek katsayıyla hesaplanır.',
          ),
          _madde(
            'Şurupluk varsa alt kuluçkalık 9 çıta, yoksa 10 çıta kabul edilir. Bu sınırın üstündeki çıtalar sistem tarafından kat/ballık alanı olarak yorumlanır.',
          ),
          _madde(
            'Biyolojik momentum artık yalnızca fiziksel çıta farkını gün sayısına bölmez. Hasat, bölme, kat geçişi, hızlı hacim açma ve aktivasyon oranı birlikte okunur; ani sıçramalar gerçek büyüme sayılmadan önce normalleştirilir.',
          ),

          _baslik('2B. İŞLEVSEL ÇITA VE HACİM AKTİVASYONU'),
          _madde(
            'İTOGENA fiziksel çıta ile işlevsel çıtayı ayrı okur. Kovandaki çıta sayısı fiziksel hacmi, koloninin gerçekten kullanabildiği alan ise işlevsel biyolojik kapasiteyi anlatır.',
          ),
          _madde(
            'Yeni verilen çıta hemen tam kapasite sayılmaz. Sistem temel petek veya kabarmış petek ayrımına, geçen gün sayısına, yavru düzenine, koloni gücüne ve bal akımı penceresine göre aktivasyon süresi hesaplar.',
          ),
          _madde(
            'Sistem sıkışık düzen varsayımıyla çalışır. Bir muayenede +1 çıta normal, +2 çıta kontrollü genişleme, +3 ve üzeri ise kat geçişi dışında uyarı sebebidir.',
          ),
          _madde(
            'Kat/ballık kullanıcı işaretiyle girilmez. Sistem şurupluk durumunu iç veri olarak kullanır: şurupluk varsa alt kuluçkalık 9 çıta, şurupluk kaldırıldıysa 10 çıta kabul edilir.',
          ),
          _madde(
            'Şurupluk + 9 çıta veya şurupluksuz 10 çıta %95 ve üzeri aktivasyona ulaşırsa sistem bunu normal alan açma değil “Kat ver” eşiği olarak okur.',
          ),
          _madde(
            'Şurupluk + 10 çıta veya şurupluksuz 11 çıta görüldüğünde sistem koloniyi katlı koloni kabul eder. Bu aşamadan sonra ballık hacmi içinde normal alan açma uyarıları devam eder.',
          ),
          _madde(
            'Şurupluk + 19 çıta veya şurupluksuz 20 çıta %95 ve üzeri aktivasyona ulaşırsa sistem “3. kat ver” uyarısı üretir. Şurupluk + 20 veya şurupluksuz 21 çıta artık 3 katlı koloni olarak okunur.',
          ),
          _madde(
            'Kata geçiş tek başına hızlı artış riski sayılmaz. Ancak kata çıkıldıktan sonra bal akımı tarih aralığı içinde değilse hızlı üst hacim artışı otomatik normalleştirilmez; sistem temkinli yaklaşır.',
          ),
          _madde(
            'Kata çıkılmış, aktivasyon sağlıklı ve bal akımı aktifse hızlı üst hacim artışı üretim genişlemesi olarak okunur. Bu durumda artış koloninin bal işleme/depolama davranışının parçası kabul edilir.',
          ),
          _madde(
            'Hasat kaydıyla birlikte oluşan hızlı çıta düşüşü biyolojik çöküş sayılmaz; sistem bunu hasat kaynaklı hacim daralması olarak normalleştirir.',
          ),
          _madde(
            '6 çıtadan 12 çıtaya çıkış kat atma olarak normalleştirilmez. Sistem bunu aşırı genişletme veya veri kontrolü gerektiren durum olarak uyarır.',
          ),
          _madde(
            'Besleme, hasat ve bölme kararlarında yalnızca kovana konan hacim değil, koloninin o hacmi biyolojik olarak taşıyabilme kapasitesi dikkate alınır.',
          ),

          _baslik('2C. SEZON BİYOLOJİ MATRİSİ'),
          _madde(
            'İTOGENA sezonu yalnızca takvim adı olarak okumaz. Her sezon için yavru beklentisi, stok baskısı, polen/arı ekmeği beklentisi, ana amaç ve aktivasyon katsayısı birlikte değerlendirilir.',
          ),
          _madde(
            'Sistem kış, kış çıkışı, ilkbahar gelişimi, bal akımı öncesi, bal akımı, hasat sonrası, sonbahar hazırlık ve geç sonbahar evrelerini ayrı biyolojik davranışlar olarak ele alır.',
          ),
          _madde(
            'Bu matris koloniye doğrudan emir vermez; aktivasyon, kabiliyet, besleme, hasat ve bölme kararlarına biyolojik bağlam sağlar. Örneğin bal akımı döneminde üretim ve bal kalitesi öne çıkar; geç sonbaharda genişletme değil hacim ve stok güvenliği öne çıkar.',
          ),
          _madde(
            'Sezon bilgisi yerel bal akımı kalibrasyonu ile birlikte okunur. Bu nedenle aynı tarih her arılıkta aynı karar anlamına gelmeyebilir.',
          ),

          _baslik('2D. KOLONİ GİDİŞATI VE NORMALİZE MOMENTUM'),
          _madde(
            'Koloni Gidişatı, koloninin yalnız bugünkü gücünü değil hangi yöne gittiğini anlatır. Teknik karşılığı biyolojik yöndür. Momentum bu hesabın içinde yaşar; kullanıcıya ayrı bir ana performans metriği gibi gösterilmez.',
          ),
          _madde(
            'Momentum artık ham çıta artışı değildir. Hasat sonrası hızlı düşüş biyolojik çöküş sayılmaz; bölme sonrası düşüş işlem kaynaklı okunur; kat atılması ise fiziksel hacim artışı olduğu için aktivasyon tamamlanmadan tam büyüme kabul edilmez.',
          ),
          _madde(
            'Kat geçişi, riskli hızlı genişleme, düşük aktivasyon ve bal akımı içindeki sağlıklı üst hacim genişlemesi ayrı ayrı normalize edilir. Böylece kısa dönem sıçrama uyarı sinyali olarak kalır ama sistemi yanlış yöne sürüklemez.',
          ),
          _madde(
            'Performans sekmesindeki Koloni Gidişatı; gelişim yönü, üretim yönü, alan baskısı, toparlanma potansiyeli, çöküş riski ve normalize momentumu birlikte okur. Amaç “koloni nereye gidiyor?” sorusunu kısa saha diliyle cevaplamaktır.',
          ),


          _baslik('2D. DEMOGRAFİ MOTORU'),
          _madde(
            'Demografi motoru kesin arı sayımı yapmaz; çıta gücü, yavru yükü, sezon ve gelişim yönünden koloni içindeki iş gücü dağılımını tahmin eder.',
          ),
          _madde(
            'Sistem genç işçi, bakıcı arı, petek işleyici, iç işçi, bekçi, tarlacı ve erkek arı dağılımını saha kararı için ayrı ayrı okur.',
          ),
          _madde(
            'Genç işçi kapasitesi ham petek ve yavru bakım kararlarında; tarlacı kapasitesi bal akımı ve üretim kararlarında; bakıcı dengesi ise aşırı genişletme riskinde kullanılır.',
          ),
          _madde(
            'Demografi çıktısı “kesin nüfus” değildir. İklim, flora, ırk ve yönetim farklılıkları sonucu değiştirebilir; bu nedenle sistem bunu biyolojik olasılık ve saha projeksiyonu olarak gösterir.',
          ),



          _baslik('2E. İŞ GÜCÜ VE KABİLİYET MOTORU'),
          _madde(
            'İTOGENA yalnızca kaç arı olduğunu değil, bu arıların hangi işi yapabilecek biyolojik kapasitede olduğunu yorumlamaya çalışır.',
          ),
          _madde(
            'Petek örme, yavru bakım, nektar toplama, bal işleme, savunma, toparlanma, kış dayanımı ve çiftleşme desteği ayrı iş gücü alanları olarak değerlendirilir.',
          ),
          _madde(
            'Aynı çıta sayısına sahip iki koloni farklı iş gücü kapasitesine sahip olabilir. Genç işçi oranı düşük koloniler geniş görünse bile hızlı petek işleme veya yavru büyütmede zorlanabilir.',
          ),
          _madde(
            'İş gücü motoru demografi, sezon, aktivasyon ve yavru durumunu birlikte okur. Böylece ham petek verme, kat açma, hasat, toparlanma ve kış hazırlığı kararları yalnız fiziksel çıta sayısına bağlanmaz.',
          ),
          _madde(
            'Bu motor kesin biyolojik ölçüm yapmaz; saha kararını destekleyen açıklanabilir biyolojik eğilim modeli üretir.',
          ),



          _baslik('2F. RİSK MOTORU VE DOĞAL RİSK FRENLERİ'),
          _madde(
            'Risk motoru koloniyi korkutucu uyarılarla yönetmez; sezonun doğal risk primini ve koloninin biyolojik kırılganlığını birlikte okuyarak dengeli karar freni üretir.',
          ),
          _madde(
            'Varroa, arı kuşu, eşek arısı, yağmacılık, nem/kış, aşırı genişleme, yavrusuzluk/yaşlanma ve bal kalitesi riski aynı merkezde değerlendirilir.',
          ),
          _madde(
            'Doğal riskler koloni hatası değildir. Örneğin hasat sonrası varroa ve yağmacılık riski doğal olarak yükselir; güçlü kolonide fren düşük, zayıf kolonide fren daha yüksek olur.',
          ),
          _madde(
            'Risk freni kararları doğrudan yasaklamaz. Genişletme, bölme, besleme, hasat ve müdahale önerilerini küçük ve dengeli katsayılarla temkinli hale getirir.',
          ),
          _madde(
            'Bu sistem kesin hastalık veya zararlı teşhisi koymaz. Saha gözlemi, sezon bilgisi, koloni gücü, demografi, aktivasyon ve süreç verilerinden açıklanabilir risk eğilimi üretir.',
          ),



          _baslik('2H. KARAR ORKESTRATÖRÜ'),
          _madde(
            'Karar orkestratörü yeni karar üretmez; süreç, yönetim, risk, projeksiyon ve genetik sinyallerini tek öncelik düzeninde sıralar.',
          ),
          _madde(
            'Amaç aynı anda çok sayıda doğru bilginin kullanıcıyı yormasını engellemektir. Sistem o anda sahada en önemli olan tek ana sesi öne çıkarır.',
          ),
          _madde(
            'Kritik ana kazanma, yavrusuzluk veya oğul baskısı gibi süreçler açıkken genetik övgü, arka plan bilgi veya düşük öncelikli projeksiyonlar geri plana alınabilir.',
          ),
          _madde(
            'Orkestrasyon bastırma değil, bağlam yönetimidir. Bilgi tamamen kaybolmaz; yalnızca daha kritik karar varken ana kartta konuşmaz.',
          ),

          _baslik('3. BÖLME NEDEN 9 ÇITA ALTINDA ÖNERİLMEZ?'),
          _madde(
            '6 çıta biyolojik olarak mümkün olabilir; fakat güvenli saha önerisi değildir.',
          ),
          _madde(
            'İTOGENA mümkün olanı değil, arıcıyı koloni kaybı riskinden koruyan doğru öneriyi verir.',
          ),
          _madde(
            'Bölme önerisi için güvenli eşik 9 çıtadır. Ana koloni bölmeden sonra en az 5 çıta kalabilmeli, yeni bölme en az 4 çıta başlayabilmelidir.',
          ),
          _madde(
            '6–8 çıta arası riskli kabul edilir; sistem bölme önermek yerine önce güçlendirmeyi söyler.',
          ),
          _madde('Kış döneminde bölme önerisi üretilmez.'),
          _madde(
            'Bölme kararı zaman bağlamıyla okunur. Bal akımına 57 günden fazla varsa güçlü kolonide bölme anlamlıdır; 57 günden az kaldıysa standart bölme üretim gücünü düşürebilir.',
          ),
          _madde(
            'Bölme sonrası toparlanma süreci yalnızca gün sayısıyla açık kalmaz. Yavrunun geri dönmesi ve koloninin yeniden üretim hacmine yaklaşması gerekir.',
          ),
          _madde(
            'Bölme toparlanması için ana kapanış sinyali 7 çıta ve gerçek yavru dönüşüdür. Kullanıcı günlük/kapalı yavru gördüğünü işaretlediyse 6 çıta ve üzerindeki kolonilerde süreç yönetim katmanına devredilebilir.',
          ),
          _madde(
            'Ayrılan yeni bölmede yavru görülmesi ana başarısını gösterdiği için hâlâ en güçlü kapanış kriteridir. Bölünen ana kolonide ise yalnızca tarih değil; yavru dönüşü, çıta gücü ve toparlanma birlikte okunur.',
          ),
          _madde(
            'Bal akımı içinde standart bölme önerisi verilmez. Yalnızca bilinçli üretim stratejisinde yavru azaltma amaçlı özel bölme ayrıca değerlendirilebilir.',
          ),

          _baslik('4. KIŞTA BAL NEDEN PERFORMANS DEĞİLDİR?'),
          _madde(
            'Kışta bırakılan bal arıcının bölge, iklim ve yönetim tercihine bağlıdır.',
          ),
          _madde(
            'Bazı yörelerde bal soğuktan çözülemediği için arı tarafından kullanılamayabilir.',
          ),
          _madde(
            'Bu nedenle kış skorunda bal/verim metriği kullanılmaz; canlı arı gücü, sağlık, ana yaşı, varroa yönetimi ve kıştan çıkış gücü dikkate alınır.',
          ),

          _baslik('5. BESLEME NEDEN CEZA DEĞİLDİR?'),
          _madde('Besleme performans değildir; iyi yönetim sinyalidir.'),
          _madde('Besleme yapıldı diye bal/verim skoru düşürülmez.'),
          _madde(
            'Son muayenelerde besleme yapılmış ve koloni sağlıklı gelişiyorsa küçük olumlu bakım sinyali oluşabilir.',
          ),
          _madde(
            'Beslemeye rağmen gelişim yoksa sistem bunu olumlu okumaz; “beslemeye rağmen gelişim zayıf” şeklinde yorumlayabilir.',
          ),

          _baslik('6. DONÖR SKORU İLE GENEL SKOR FARKI NEDİR?'),
          _madde('Genel skor koloninin saha performansıdır.'),
          _madde('Donör skoru ana üretimi ve genetik seçilim değeridir.'),
          _madde(
            '85 genel skor tek başına donörlük anlamına gelmez. Oğul izi/genetik filtre, soy devamlılığı, üreme gücü, dayanıklılık ve veri güveni ayrıca okunur.',
          ),
          _madde(
            'Güçlü ama genetik filtreye takılan koloni üretimde veya kapalı yavru desteğinde değerlendirilebilir; ana üretim havuzuna alınmaz.',
          ),

          _baslik('7. OĞUL İZİ NEDEN GENETİK FİLTREDİR?'),
          _madde(
            'Oğul sağlık problemi değildir; bu nedenle sağlık skorunu düşürmez.',
          ),
          _madde('Oğul, genetik istikrar ve donör seçimi konusudur.'),
          _madde(
            'Oğul kökenli, oğul atmış veya atasal hatta oğul izi taşıyan koloni donör havuzuna girmez.',
          ),
          _madde(
            'Sistem bu koloniler için açık dil kullanır: ana üretme, üretimde değerlendirilebilir, genetik seçim havuzunda değil.',
          ),

          _baslik('7B. OĞUL SONRASI SÜREÇ NASIL OKUNUR?'),
          _madde(
            'Oğul attı işaretlenirse koloni geçici olarak üretim/hasat kolonisi gibi okunmaz. Sistem bu dönemi ana ve nüfus kurtarma süreci olarak ele alır.',
          ),
          _madde(
            '0–7. gün arası artçı oğul riski en yüksektir. Sistem üretim, kat ve hasat dilini geri plana alır; amaç koloniyi tekrar böldürmemektir.',
          ),
          _madde(
            '8–16. gün arası artçı oğul riski azalır ama bitmiş kabul edilmez. Yeni meme, huzursuzluk veya tekrar çıkış belirtisi yoksa ana sürecini bozmadan bekleme mantığı çalışır.',
          ),
          _madde(
            '17–30. gün arası yeni ana çıkışı, olgunlaşma ve çiftleşme penceresidir. Bu dönemde yavru görülmemesi tek başına çöküş sayılmaz; dış uçuş, polen gelişi ve koloni sakinliği destek sinyali olarak okunur.',
          ),
          _madde(
            '31–45. gün arası yumurtlama artık netleşmelidir. Günlük veya kapalı yavru görülürse süreç kapanır. Hâlâ yavru yoksa sistem bunu normal bekleme olarak değil; ana başarısızlığı, çiftleşme kaybı veya yalancı ana riski olarak değerlendirir.',
          ),
          _madde(
            'Oğul sonrası süreç yalnızca gün sayısıyla kapanmaz. Kapanış için günlük yavru, kapalı yavru veya anlamlı yavru düzeni gerekir. Süre doldu ama yavru yoksa süreç kapanmaz; yavru-yok tanısına devredilir.',
          ),

          _baslik('7C. YAVRU YOK ALARMI VE KARAR ÖNCELİĞİ'),
          _madde(
            'Yavru yok en kritik biyolojik alarmlardan biridir. Sistem önce bunun aktif bölme, oğul sonrası veya ana kazanma penceresinde normal bekleme olup olmadığını kontrol eder.',
          ),
          _madde(
            'Bekleme penceresi aşılmışsa yavru yok; varroa, besleme, alan veya hasat gibi rutin yönetim kararlarının önüne geçer. Grid kartta önce koloni devamlılığı konuşur.',
          ),
          _madde(
            'Yalancı ana şüphesi, erkek yavru baskısı, ardışık yavrusuz kayıt ve güç düşüşü birlikte görülürse sistem bunu yüksek öncelikli ana problemi olarak ele alır.',
          ),
          _madde(
            'Bal akımı içinde güçlü bal baskısı varsa yavru yokluğu hemen anasızlık sayılmaz; önce alan ve bal baskısı değerlendirilir. Ancak bu durum yine de takip dışına bırakılmaz.',
          ),

          _baslik('7D. GELİŞİM KOLONİSİNDE KALINTI UYARISI'),
          _madde(
            '8 çıta altındaki gelişim kolonileri hasat kolonisi gibi okunmaz. Bu nedenle bal dönemi kalıntı uyarısı kullanıcıya gereksiz karar olarak gösterilmez.',
          ),
          _madde(
            'Varroa ve sezon riski sistem içinde biyolojik model ve risk hesabı için yaşamaya devam eder. Ancak kullanıcıya kalıntı dili yalnızca hasat/üretim eşiğine yaklaşan kolonilerde anlamlı olduğunda gösterilir.',
          ),

          _baslik('8. ANA KAZANMA SÜRECİ NASIL OKUNUR?'),
          _madde(
            'Ana kazanma süreci anasız bırakıldı, bölme, kapalı ana memesi veya hazır ana gibi tetiklerle başlar.',
          ),
          _madde(
            'Kendi anasını yapacak kolonide 5. gün kapalı memeler bozulur; açık/kapanmamış kaliteli memeler bırakılır. Amaç erken kapanmış zayıf memeleri elemek, tüm memeleri yok etmek değildir.',
          ),
          _madde(
            'Hazır ana verilen kolonide süreç kabul ve yumurtlama kontrolüne göre okunur.',
          ),
          _madde(
            'Günlük veya kapalı yavru görüldüğünde ana varlığı dolaylı kabul edilir ve ilgili ana kazanma süreci kapanabilir.',
          ),

          _baslik('9. HASAT SONRASI SÜREÇ NEDEN BAKIM SÜRECİDİR?'),
          _madde(
            'Hasat sonrası dönem biyolojik ana kazanma süreci değildir; kışa hazırlık bakım sürecidir.',
          ),
          _madde(
            'Bu süreç günlük/kapalı yavru görüldü diye kapanmaz.',
          ),
          _madde(
            'Varroa mücadelesi, besleme ve ileride eklenecek sıkıştırma gibi bakım eylemleri süreci hafifletir veya kapatır.',
          ),
          _madde(
            'Hasat sonrası ilk amaç koloniyi sıkışık düzene almak ve stresi azaltmaktır.',
          ),
          _madde(
            'Arı basmayan petekler ve gereksiz hacim azaltılarak savunma, ısı yönetimi ve yağmacılık kontrolü kolaylaştırılır.',
          ),
          _madde(
            'Hafif 1:1 besleme bazı durumlarda destekleyici olabilir; ağır stok beslemesi ise ayrı değerlendirilir.',
          ),
          _madde(
            'Hasat sonrası güçlü görünen koloni bile varroa ve bakım ihmal edilirse kışa zayıf girebilir.',
          ),

          _baslik('10. BAL AKIMI 57/42 GÜN MANTIĞI NEDİR?'),
          _madde(
            '42 gün yumurtadan tarlacı arıya uzanan biyolojik süredir.',
          ),
          _madde(
            '57 gün saha planlama eşiğidir: 42 günlük biyolojiye yaklaşık 15 gün güvenlik payı eklenir.',
          ),
          _madde(
            'Arılık uyarıları bal akımına yetişme hesabında 57 günü kullanabilir; formüller ekranı biyolojik 42 günü ayrıca açıklar. Bu iki değer çelişmez.',
          ),
          _madde(
            'Karar motoru bölme önerisini bu 57 günlük saha penceresine göre ciddiye alır. Zaman uygun değilse güçlü koloni bile otomatik bölme adayı yapılmaz.',
          ),

          _madde(
            'Bal akımına 35–45 gün kala güçlü, istikrarlı ve genetik olarak değerli koloni kontrollü bölme adayı olabilir. Bu karar çıta sayısı kadar bal akımına kalan süre, büyüme yönü, yavru düzeni, aktivasyon ve oğul riskiyle birlikte verilir.',
          ),
          _madde(
            'Bal akımına 24 gün veya daha az kaldığında bölme hedefi geri çekilir. Bu dönemde alan, kat, kalıntı güvenliği ve oğul kontrolü öne çıkar. Şurupluk bilgisi kullanıcıya ayrı karar olarak gösterilmez; muayene verisi biyolojik modele yansır.',
          ),
          _madde(
            'Ana değişimi için en güçlü karar penceresi hasat sonrası / sonbahara giriş dönemidir. Bal akımı öncesi veya sırasında planlı ana değişimi zorunlu değilse ertelenir.',
          ),

          _baslik('11. VARROA UYARILARI NASIL ÇALIŞIR?'),
          _madde(
            'Varroa uyarıları sezon ve bal akımı penceresiyle birlikte okunur.',
          ),
          _madde(
            'Bal akımı öncesi ve sırasında kalıntı riski dikkate alınır.',
          ),
          _madde(
            'Hasat sonrası / yaz sonu erken sonbahar dönemi kışı taşıyacak arıların sağlığı için kritik kabul edilir.',
          ),
          _madde(
            'Oksalik, timol, amitraz, formik ve benzeri uygulamalarda ürün etiketi, ruhsat durumu ve yerel mevzuat esas alınmalıdır.',
          ),

          _baslik('12. VERİ GÜVENİ NE DEMEKTİR?'),
          _madde(
            'Tek muayeneli kolonide sistem karar verir ama veri güveni düşük der.',
          ),
          _madde('2–4 muayene izleme bandıdır.'),
          _madde(
            '5 ve üzeri muayene güvenilir değerlendirme başlangıcıdır.',
          ),
          _madde(
            'Veri güveni, kararın neden güçlü veya sınırlı olduğunu açıklamak için gösterilir; kullanıcıyı kararsız bırakmak için değildir.',
          ),

          _baslik('13. BİYOLOJİK MODEL VE KABİLİYET ANALİZİ NEDİR?'),
          _madde(
            'İTOGENA çıta sayısını yalnızca sayı olarak okumaz; standart koloni organizasyonu üzerinden tahmini kuluçkalık dizilimi, yavru bloğu, stok alanı ve hasat adayı dış çıtaları yorumlar.',
          ),
          _madde(
            'Kovan tipi Langstroth veya Dadant olarak seçilebilir. Şurupluk varsa alt kuluçkalık 9 çıta, yoksa 10 çıta kabul edilir; bunun üzerindeki çıtalar kat/ballık alanı olarak yorumlanır.',
          ),
          _madde(
            'Temporal polyethism mantığıyla işçi arıların yaşa bağlı görev dağılımı tahmin edilir: bakıcı arı, petek örücü, iç işçi, tarlacı ve erkek arı yoğunluğu kesin sayı değil kabiliyet puanı olarak kullanılır.',
          ),
          _madde(
            'Petek örme, yavru bakımı, nektar toplama, bal işleme, kış dayanımı ve çiftleşme desteği gibi kabiliyetler sezon, süreç, normalize biyolojik momentum, yavru düzeni ve çıta yoğunluğu birlikte okunarak hesaplanır.',
          ),
          _madde(
            'Sistem “şu çıtaları hasat et” derken kesin hüküm vermez; yalnızca tahmini yerleşime göre yavrusuz ve sırlı olması halinde hasat için değerlendirilebilecek dış/ballık çıtaları işaret eder.',
          ),

          _baslik('14. KIŞ YÖNETİMİ NASIL ÇALIŞIR?'),
          _madde(
            'Kış döneminde ana hedef üretim değil yaşatmadır. Sistem gereksiz kovan açmayı önleyecek şekilde dış gözlem, ağırlık hissi, uçuş deliği, nem ve su girişi kontrolünü öne alır.',
          ),
          _madde(
            'Stok çok düşük görünüyorsa açlık riski minimum müdahale kuralından daha yüksek öncelik alır. Bu durumda hava ve saha koşulu uygunsa hızlı ve sınırlı stok desteği/kek değerlendirilebilir.',
          ),
          _madde(
            'Fiziksel hacim yüksek ama işlevsel arı gücü düşükse sistem boş hacim ve ısı kaybı riskini belirtir. Kış başarısı, sonraki sezon genetik istikrar ve sürdürülebilirlik yorumuna veri sağlar.',
          ),

          _baslik('15. GENETİK ÇOĞALTMA DEĞERİ NASIL OKUNUR?'),
          _madde(
            'Genetik çoğaltma değeri yalnızca bal veya çıta sayısı değildir. İşlevsel kapasite, yavru düzeni, gelişim yönü, aktivasyon, risk, stok/kış güvenliği ve oğul izi birlikte okunur.',
          ),
          _madde(
            'Oğul kökeni veya oğul izi görülen koloniler üretimde değerli olabilir; ancak temiz genetik yayılım adayı olarak otomatik öne çıkarılmaz. Üretim değeri ile çoğaltma değeri ayrı tutulur.',
          ),
          _madde(
            'Bu skor kesin damızlık hükmü değildir; çoğaltmaya değer kolonileri izleme ve doğru zamanda kontrollü bölme kararını destekleyen stratejik sinyaldir.',
          ),

          _baslik('16. EKONOMİK DEĞER NEYİ İFADE EDER?'),
          _madde(
            'Ekonomik değer ekranı kesin gelir hesabı değil, yaklaşık arılık varlığı ve tahmini bal potansiyeli projeksiyonudur.',
          ),
          _madde(
            'Aktif kovan sayısı, toplam arılı çıta, boş kovan, kabarmış petek ve tahmini hasat edilebilir bal potansiyeli birlikte okunur.',
          ),
          _madde(
            'Kullanıcı bal kg satış fiyatını girer; sistem tahmini hasat potansiyelini bu fiyatla çarpar ve potansiyel değer bandı üretir.',
          ),
          _madde(
            'Bal verimi flora, hava, hasat zamanı, bırakılacak stok ve arıcının yönetimine bağlı olarak değişir. Bu nedenle sonuç yön gösteren tahmindir.',
          ),

          _baslik('17. BESLEME KARAR MOTORU NASIL ÇALIŞIR?'),
          _madde(
            'Besleme önerileri kesin stok ölçümü değildir; çıta gücü, yavru alanı, sezon, aktif süreç, bal akımı penceresi ve kullanıcının muayene gözlemi birlikte değerlendirilir.',
          ),
          _madde(
            'Sistem kesin reçete vermez; tahmini ml/L veya gram bandı üretir. Bu bant saha gözlemi, hava, flora ve yağmacılık riskiyle birlikte değerlendirilmelidir.',
          ),
          _madde(
            '1:1 şurup daha çok gelişim desteği; 2:1 şurup stok tamamlama; polenli destek ise yalnızca polen baskısı sahada doğrulanırsa anlamlı kabul edilir.',
          ),
          _madde(
            'Bal akımına 20 gün veya daha az kalmışsa ve koloni hasat hedefindeyse şeker bazlı besleme önerilmez. Çünkü şurup veya şekerli yem nektar akımıyla birlikte bala taşınabilir; bu da balın doğallığı, lezzeti ve güvenilirliği açısından risk oluşturur.',
          ),
          _madde(
            'Bu dönemde sistem hasat hedefli kolonilerde açıkça “besleme önerilmez” der. Üretim kolonilerinde öncelik alan, kat ve hasat hazırlığıdır. Şurupluk kaldırma kararı ekranda konuşmaz; yalnızca kapasite/hacim hesabını etkiler.',
          ),
          _madde(
            'Düşük çıtalı gelişim kolonilerinde hasat baskısı uygulanmaz. Sistem “stok yeterli” gibi kesin hüküm vermez; stok zayıf görülürse ölçülü destek, güçlü nektar/polen gelişi varsa takip arıcı tarafından değerlendirilir.',
          ),

          _baslik('18. KARAR UZLAŞTIRICI NEYİ ÖNCELİKLENDİRİR?'),
          _madde(
            'Karar uzlaştırıcı aynı anda üretilen süreç, yönetim, biyoloji ve genetik sinyallerini sahaya çıkmadan önce çelişki açısından süzer.',
          ),
          _madde(
            'Müdahale edilmemesi gereken ana kazanma, bölme sonrası hassas dönem, oğul sonrası, yavru yok tanı süreci ve kış dönemi gibi pencerelerde kat, bölme, yoğun besleme ve gereksiz muayene önerileri bastırılır.',
          ),
          _madde(
            'Veto veya bekleme kararları eylem sayılmaz. Bu nedenle “besleme önerilmez”, “bal akımı içinde kimyasal mücadele planlama” veya “gereksiz açma yok” gibi koruyucu kararlar ekranda kalabilir.',
          ),
          _madde(
            'Kışta genel kural gereksiz müdahaleyi kesmektir; ancak açlık riski yaşatma önceliği olduğu için kış kilidi altında bile görünür kalır.',
          ),


          _baslik('19. SÜREÇ VE GENETİK KATMANI NASIL AYRILIR?'),
          _madde(
            'Aktif ana kazanma, oğul sonrası, bölme sonrası veya yavru yok süreci varsa süreç bilgisi Süreç kartında gösterilir. Bu bilgi genetik/seçilim kartının yerine geçmez.',
          ),
          _madde(
            'Genetik kartı yalnızca donör uygunluğu, oğul izi/genetik filtre, soy devamlılığı, üretim değeri ve seçilim sonucunu gösterir. “Kovanı açma”, “müdahale etme” gibi süreç dili genetik kartına taşınmaz.',
          ),
          _madde(
            'Bu ayrım sayesinde kullanıcı aynı anda hem sahadaki acil biyolojik süreci hem de koloninin uzun vadeli genetik değerini ayrı okuyabilir.',
          ),
          _madde(
            'Süreç kapanışı artık tek standartla okunur: günlük/kapalı yavru işareti, açık yavrulu çıta kaydı veya “Yok” dışında anlamlı yavru düzeni görülürse ana/oğul/bölme kaynaklı biyolojik süreç kapanabilir.',
          ),
          _madde(
            'Bu kural eski kayıtlarda kapanış kutusu işaretlenmemiş olsa bile sistemin açık yavru verisini biyolojik sonuç olarak okumasını sağlar. Ama yavru düzeni “Yok” ise süreç kapatılmaz; yavru yok tanısı devreye girer.',
          ),

          _baslik('20. İTOGENA KARAR SÖZLÜĞÜ'),
          _kutu(
            'Bu bölüm, ekranda görülen kavramların ne anlama geldiğini açıklar. Amaç teknik terimleri ezberletmek değil; arıcının ekrandaki kararı sahada doğru yorumlamasını sağlamaktır.',
          ),
          _madde(
            'Koloni Gidişatı: Koloninin yalnız bugünkü gücünü değil, hangi yöne ilerlediğini anlatır. Gelişim, üretim, toparlanma, risk, alan baskısı, aktivasyon ve normalize momentum birlikte okunur. Teknik karşılığı biyolojik yöndür.',
          ),
          _madde(
            'Koloni Gücü: Son muayenedeki canlı arı ve çıta gücünü anlatır. Bu değer mevcut durumu gösterir; tek başına gelecek yönünü garanti etmez.',
          ),
          _madde(
            'Koloni Sağlığı: Yavru düzeni, ana süreci, yavrusuzluk, zaman kritikliği, varroa dönemi, davranış ve risk sinyallerinin birlikte okunmasıdır. Uygulama veteriner teşhisi koymaz; saha riskini yorumlar.',
          ),
          _madde(
            'Gelişim Yönü: Koloninin büyüme, duraklama, toparlanma veya zayıflama tarafına gidip gitmediğini gösterir. Ani sıçramalar kat, hasat, bölme ve aktivasyonla normalleştirilir.',
          ),
          _madde(
            'İşlevsel Çıta: Kovandaki fiziksel çıta sayısı değil, arının gerçekten kullandığı biyolojik kapasitedir. Yeni verilen çıta hemen tam güç sayılmaz.',
          ),
          _madde(
            'Hacim Aktivasyonu: Verilen çıta veya katın koloni tarafından ne kadar kullanılır hale geldiğini anlatır. Koloni gücü, genç işçi kapasitesi, yavru düzeni, sezon ve bal akımı bu hesabı etkiler.',
          ),
          _madde(
            'Normalize Momentum: Kısa dönem çıta artışı veya düşüşünü ham şekilde okumaz. Hasat sonrası düşüş, bölme, kat geçişi ve riskli hızlı genişleme ayrılır; gerçek gelişim ile yönetim kaynaklı hacim değişimi karıştırılmaz.',
          ),
          _madde(
            'Genetik Filtre: Koloninin üretimde değerli olabileceği halde ana üretme havuzuna alınmamasıdır. Oğul kökeni, oğul izi veya atasal oğul davranışı buna sebep olabilir. Bu filtre genel performans cezası değildir.',
          ),
          _madde(
            'Yönetim Kararı: Besleme, kat, alan, hasat sonrası bakım, varroa ve kış hazırlığı gibi arıcının sahada yapacağı işleri anlatır. Şurupluk kaldırma bu listede kullanıcı kararı olarak konuşmaz; biyolojik modelin kapasite bilgisidir.',
          ),
          _madde(
            'Süreç: Ana kazanma, bölme sonrası toparlanma, oğul sonrası, yavru yok tanısı veya hasat sonrası bakım gibi zamana bağlı biyolojik/yönetim penceresidir. Süreç açıkken bazı eylemler bastırılabilir.',
          ),
          _madde(
            'Kilit / Bekle: Müdahale edilmemesi gereken hassas pencereyi anlatır. Örneğin ana kazanma döneminde kovanı gereksiz açmamak, bazen yapılacak en doğru iştir.',
          ),
          _madde(
            'Veri Güveni: Kararın kaç muayeneye dayandığını anlatır. Tek muayene karar üretir ama güveni sınırlıdır; 5 ve üzeri muayene daha sağlam değerlendirme sağlar.',
          ),

          _baslik('21. UYGULAMA HANGİ KONULARDA KESİN HÜKÜM VERMEZ?'),
          _uyari(
            'İTOGENA veterinerlik, ruhsatlı ilaç kullanımı veya resmi mevzuat yerine geçmez.',
          ),
          _uyari(
            'Kimyasal mücadelede ürün etiketi, ruhsatlı kullanım talimatı, koruyucu ekipman ve yerel mevzuat esas alınmalıdır.',
          ),
          _uyari(
            'Hava, flora, yöresel nektar akımı, arıcı deneyimi ve koloni davranışı sahada ayrıca gözlenmelidir.',
          ),
          _uyari(
            'Sistem doğru kararı destekler; son sorumluluk sahadaki arıcıdadır.',
          ),

          _baslik('SESLİ NOT'),
          _madde(
            'Not alanında mikrofon ikonuna basarak konuşarak not girebilirsiniz.',
          ),
          _madde(
            'Konuşma otomatik olarak metne çevrilir ve not alanına eklenir.',
          ),
          _uyari(
            'Rüzgar, arı sesi, cihaz mikrofonu ve bazı cihazlarda internet bağlantısı algılamayı etkileyebilir.',
          ),
        ],
      ),
    );
  }
}