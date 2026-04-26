import 'package:flutter/material.dart';
import 'ana_sayfa_kisayol.dart';

class KullaniciRehberiSayfasi extends StatelessWidget {
  const KullaniciRehberiSayfasi({super.key});

  Widget _bolumBaslik(String metin) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Text(
        metin,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: Colors.brown,
        ),
      ),
    );
  }

  Widget _madde(String metin) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 3),
            child: Icon(
              Icons.check_circle_outline,
              size: 18,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              metin,
              style: const TextStyle(
                fontSize: 13,
                height: 1.45,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _uyari(String metin) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 3),
            child: Icon(
              Icons.info_outline,
              size: 18,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              metin,
              style: const TextStyle(
                fontSize: 13,
                height: 1.45,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ustBilgiKutusu() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: const Text(
        'İTOGENA, muayene kayıtlarını sadece saklayan değil; olayları, süreçleri ve zamanı birlikte okuyarak koloni için ne yapılması gerektiğini söyleyen bir arılık yönetim sistemidir.',
        style: TextStyle(
          fontSize: 13,
          height: 1.5,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _ornekKararKutusu() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ÖRNEK KARAR DİLİ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Colors.brown,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '20.04.2026 tarihinde kapalı ana memelerini boz.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Kontrolsüz ana çıkışı koloniyi böler.',
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final altBosluk = MediaQuery.of(context).padding.bottom + 110;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: const Text(
          'DETAYLI BİLGİ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [AnaSayfaKisayol.aksiyon(context)],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, altBosluk),
          children: [
            _ustBilgiKutusu(),
            _bolumBaslik('1. İTOGENA NE YAPAR?'),
            _madde(
              'İTOGENA, kritik tetikleri algılar; aktif süreci belirler ve kısa, net yönlendirme üretir.',
            ),
            _madde(
              'Sistem kullanıcıyı gereksiz veriyle yormaz. Basit veriyi kullanıcıdan alır, derin anlamı kendi üretir.',
            ),
            _madde(
              'Amaç daha fazla veri toplamak değil; doğru zamanda doğru müdahaleyi görünür hale getirmektir.',
            ),
            _bolumBaslik('2. MUAYENE EKRANI NASIL ÇALIŞIR?'),
            _madde(
              'Muayene ekranında sabit alanlar, tetik alanları ve yalnızca gerektiğinde görünen süreç alanları birlikte çalışır.',
            ),
            _madde(
              'Sabit alanlar tarih, çıta, yavru, Bal/Hasat, yavru düzeni, mizaç, besleme, varroa mücadelesi ve nottur.',
            ),
            _madde(
              'Tetik alanları oğul belirtisi, bölme, anasız bırakma, oğul attı, kovan söndü ve hasat gibi olayları sisteme bildirir.',
            ),
            _madde(
              'Süreç alanları ise yalnızca ilgili süreç anlamlıysa görünür. Böylece ekran sade kalır.',
            ),
            _bolumBaslik('3. KARAR NASIL ÜRETİLİR?'),
            _madde(
              'İTOGENA tek bir veriye bakıp hüküm vermez. Muayene geçmişini, olayları, sezonu, zamanı ve soy bilgisini birlikte okur.',
            ),
            _madde(
              'Temel akış şu mantıkla çalışır: tetik oluşur, süreç açılır, sistem ne yapılacağını söyler, sonucu bir sonraki muayeneden anlamaya çalışır.',
            ),
            _madde(
              'Aynı anda birden fazla süreç aktif olabilir; ama aynı anlamı tekrar eden kartlar yerine aktif süreçler tek yerde toplanır.',
            ),
            _bolumBaslik('4. SÜREÇ KARTLARI NASIL KONUŞUR?'),
            _madde(
              'Süreç kartları uzun teknik açıklamalarla değil, iki kısa cümle ile çalışır.',
            ),
            _madde(
              'Önce yapılacak iş yazılır, ardından kısa gerekçe verilir.',
            ),
            _madde(
              'Kartlarda gereksiz sistem açıklamaları, referans satırları ve uzun paragraflar gösterilmez.',
            ),
            _ornekKararKutusu(),
            _bolumBaslik('5. ANASIZLIK SÜRECİ NASIL İLERLER?'),
            _madde(
              'Anasızlık süreci tek bir sabit uyarı değildir. Başlangıç tarihinden itibaren gün farkına göre faz değiştirir.',
            ),
            _madde(
              'İlk günlerde kapalı meme bozma uyarısı gelir; sonra dokunmama, ana çıkış, çiftleşme ve yumurtlama kontrol pencereleri sırayla öne çıkar.',
            ),
            _madde(
              'Bu sayede sistem her gün aynı şeyi tekrar etmez; biyolojik aşamaya göre konuşur.',
            ),
            _uyari(
              'Kaynağı bölme olan yeni kolonilerde sistem, anasızlık sürecini oluşturma tarihinden başlatabilir.',
            ),
            _bolumBaslik('6. SÜREÇLER NEDEN SONSUZA KADAR AÇIK KALMAZ?'),
            _madde(
              'Kullanıcı her zaman kapanış verisi girmeyebilir. Bu yüzden sistem süreçleri sonsuza kadar açık bırakmaz.',
            ),
            _madde(
              'Günlük veya kapalı yavru görüldü gibi açık kapanış sinyalleri varsa süreç kapanır.',
            ),
            _madde(
              'Kapanış verisi yoksa da, biyolojik ve pratik süreler aşıldığında süreç aktif listeden düşer.',
            ),
            _uyari(
              'Bu davranış hata değil; eski kayıtların bugünü kirletmesini önleyen temel güvenlik kuralıdır.',
            ),
            _bolumBaslik('7. SEZON VE ZAMAN NEDEN ÖNEMLİ?'),
            _madde(
              'Aynı olay farklı zamanda farklı anlam taşır. Sistem yalnızca olay oldu mu diye değil, ne zaman oldu diye de bakar.',
            ),
            _madde(
              'Hasat, bölme, oğul sonrası ve varroa uyarıları aktif sezon ve makul süre içinde değerlendirilir.',
            ),
            _madde(
              'Geçen sezon yaşanmış bir olay, bugün hâlâ aktif süreç gibi görünmez.',
            ),
            _bolumBaslik('8. VARROA YÖNETİMİ NASIL OKUNUR?'),
            _madde(
              'Varroa müdahalesi yalnızca seçim yapıldı diye doğru kabul edilmez. Sistem seçimi zaman ve bağlamla birlikte okur.',
            ),
            _madde(
              'Muayene ekranında kullanıcı yalnızca müdahale tipini seçer; doğru zaman ve doğru yöntem değerlendirmesini sistem yapar.',
            ),
            _madde(
              'Varroa alanında drone kesimi, bölme, timol, amitraz, formik ve oksalik gibi seçenekler kullanılır.',
            ),
            _uyari(
              'Sistem, yanlış zamanda yapılan müdahaleyi kapanmış süreç gibi kabul etmez; gerekirse uyarı üretir.',
            ),
            _bolumBaslik('9. MUAYENE LİSTESİ NEDEN OLAY GÖRÜNÜMÜNE DÖNDÜ?'),
            _madde(
              'Muayene listesinde artık yalnızca genel bilgiler değil, kritik tetikler görünür.',
            ),
            _madde(
              'Böylece bölme ne zaman yapıldı, oğul belirtisi hangi kayıtta görüldü, hasat hangi tarihte işlendi gibi olaylar tek bakışta bulunabilir.',
            ),
            _madde(
              'Mizaç ve yavru düzeni gibi detaylar liste yerine muayene detay ekranında korunur.',
            ),
            _bolumBaslik('10. BAL/HASAT ALANI NEYİ TEMSİL EDER?'),
            _madde(
              'Bal/Hasat alanı, kovandaki anlık bal stoğunu değil; hasat bağlamında girilen ballı çıta bilgisini temsil eder.',
            ),
            _madde(
              'Sistem bu veriyi hasat sonrası toparlanma, üretim referansı ve skor tarafında birlikte kullanır.',
            ),
            _madde(
              'Alanın anlamı bu nedenle süreç ve performans açısından önemlidir.',
            ),
            _bolumBaslik('11. PERFORMANS VE GENETİK SEÇİLİM AYNI ŞEY Mİ?'),
            _madde(
              'Hayır. Performans katmanı her kolonide güç, gelişim, üretim ve dayanıklılığı okur.',
            ),
            _madde(
              'Genetik seçilim katmanı ise donör havuzuna kimin gireceğini belirler.',
            ),
            _madde(
              'Bir koloni güçlü olabilir; ama genetik veto nedeniyle donör olmaya yine de uygun olmayabilir.',
            ),
            _uyari(
              'Oğul izi sistemde puan cezası değil, genetik veto olarak ele alınır.',
            ),
            _bolumBaslik('12. SIKIŞIK DÜZEN NEDEN TEMEL İLKEDİR?'),
            _madde(
              'İTOGENA, sıkışık düzeni temel koloni yönetim ilkelerinden biri olarak kabul eder.',
            ),
            _madde(
              'Sıkışık düzen brood ısısını, savunmayı ve enerji yönetimini destekler.',
            ),
            _madde(
              'Bu nedenle sistem özellikle zayıf, yeni, anasız veya toparlanma sürecindeki kolonilerde sıkışık düzeni öne çıkarır.',
            ),
            _bolumBaslik('13. AYARLAR NEDEN SINIRLIDIR?'),
            _madde(
              'Kullanıcı saha gerçekliğini ayarlayabilir; ama sistemin biyolojik çekirdeği ve karar omurgası serbestçe bozulmaz.',
            ),
            _madde(
              'Sezon tarihleri, bal akımı pencereleri ve bazı saha referansları kullanıcıya açıktır.',
            ),
            _madde(
              'Bu denge, sistemin hem esnek hem güvenilir kalmasını sağlar.',
            ),
            _bolumBaslik('14. SİSTEMİN NİHAİ HEDEFİ'),
            _madde(
              'İTOGENA’nın amacı yalnızca kayıt toplamak değil; arıcıya sahada güvenilir karar zemini oluşturmaktır.',
            ),
            _madde(
              'Sistem kritik tetikleri görünür kılar, aktif süreci belirler, kısa yönlendirme verir ve eski kayıtların bugünü bozmasını engeller.',
            ),
            _madde(
              'Kısacası İTOGENA, kayıt uygulamasından çok süreç okuyan ve karar destekleyen bir arılık yönetim sistemi olarak çalışır.',
            ),
          ],
        ),
      ),
    );
  }
}
