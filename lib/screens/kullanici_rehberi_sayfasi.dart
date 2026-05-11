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
            'Her süreç için ayrıca onay istemez; sonucu sonraki muayene verisinden anlamaya çalışır.',
          ),
          _madde(
            'Koloni detay ekranı hızlı açılır; ağır analizler arka planda yüklenir.',
          ),
          _madde(
            'Aynı koloni için süreç ve biyolojik model hesapları tek oturum içinde önbelleğe alınır; besleme, performans ve biyolojik model sekmeleri aynı hesabı tekrar tekrar üretmez.',
          ),
          _madde(
            'Koloni detayında bağlam önceliği kullanılır. Canlı biyolojik süreç varsa ana karar alanında o konuşur; hasat sonrası gibi bakım süreçleri yaşamaya devam eder ama gerekiyorsa alt sıraya düşer.',
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

          _baslik('2. SİSTEM ÇITADAN NE ANLAR?'),
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
            'Büyüme momentumu çıta farkını gün sayısına bölerek hesaplanır. Böylece +3 çıtanın 7 günde mi, 40 günde mi gerçekleştiği ayrı yorumlanır.',
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
            'Kat/ballık kullanıcı işaretiyle girilmez. Langstroth kovan 10 çıtalık kapasite kabulüyle okunur; toplam çıta 11 ve üzerine çıktığında sistem üst kat/ballık oluştuğunu kabul eder.',
          ),
          _madde(
            '6 çıtadan 12 çıtaya çıkış kat atma olarak normalleştirilmez. Sistem bunu aşırı genişletme veya veri kontrolü gerektiren durum olarak uyarır.',
          ),
          _madde(
            'Besleme, hasat ve bölme kararlarında yalnızca kovana konan hacim değil, koloninin o hacmi biyolojik olarak taşıyabilme kapasitesi dikkate alınır.',
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
            '85 genel skor tek başına donörlük anlamına gelmez. Oğul veto, soy devamlılığı, üreme gücü, dayanıklılık ve veri güveni ayrıca okunur.',
          ),
          _madde(
            'Güçlü ama genetik veto alan koloni üretimde veya kapalı yavru desteğinde değerlendirilebilir; ana üretim havuzuna alınmaz.',
          ),

          _baslik('7. OĞUL İZİ NEDEN VETO SEBEBİDİR?'),
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
            'Petek örme, yavru bakımı, nektar toplama, bal işleme, kış dayanımı ve çiftleşme desteği gibi kabiliyetler sezon, süreç, büyüme momentumu, yavru düzeni ve çıta yoğunluğu birlikte okunarak hesaplanır.',
          ),
          _madde(
            'Sistem “şu çıtaları hasat et” derken kesin hüküm vermez; yalnızca tahmini yerleşime göre yavrusuz ve sırlı olması halinde hasat için değerlendirilebilecek dış/ballık çıtaları işaret eder.',
          ),

          _baslik('14. EKONOMİK DEĞER NEYİ İFADE EDER?'),
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

          _baslik('15. BESLEME KARAR MOTORU NASIL ÇALIŞIR?'),
          _madde(
            'Besleme önerileri çıta sayısı, tahmini arı nüfusu, yavru alanı, stok baskısı, sezon, aktif süreç ve bal akımı penceresi birlikte okunarak üretilir.',
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
            'Bu dönemde sistem “besleme baskısı yok” demek yerine açıkça “besleme önerilmez” der. Üretim kolonilerinde öncelik alan, kat, şurupluk kaldırma ve hasat hazırlığıdır.',
          ),
          _madde(
            'Düşük çıtalı gelişim kolonilerinde hasat baskısı uygulanmaz; destek beslemesi arıcının hedefi ve saha koşullarına göre sürdürülebilir.',
          ),

          _baslik('16. UYGULAMA HANGİ KONULARDA KESİN HÜKÜM VERMEZ?'),
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