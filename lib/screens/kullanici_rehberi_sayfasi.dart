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

          /// GENEL
          _baslik('İTOGENA NE YAPAR'),
          const Text(
            'İTOGENA, arıcının girdiği basit saha verisini zaman, süreç, soy ve arılık kalibrasyonu ile birlikte okuyarak uygulanabilir koloni kararı üretir.',
            style: TextStyle(fontSize: 13, height: 1.5),
          ),

          /// MUAYENE
          _baslik('MUAYENE KAYDI'),
          _madde('Muayene ekranı sistemin ana veri giriş noktasıdır.'),
          _madde('Girilen her veri sistemde süreçleri tetikler.'),
          _madde('Sistem sizden teyit istemez, sonucu sonraki muayeneden anlar.'),

          /// SESLİ NOT
          _baslik('SESLİ NOT (YENİ)'),
          _madde('Not alanında mikrofon ikonuna basarak konuşarak not girebilirsiniz.'),
          _madde('Konuşma otomatik olarak metne çevrilir ve not alanına eklenir.'),
          _madde('Dilerseniz metni sonradan düzenleyebilirsiniz.'),

          _uyari('Sesli not özelliği cihazın mikrofonuna ve konuşma tanıma altyapısına bağlıdır.'),
          _uyari('Rüzgar, arı sesi ve gürültü algılamayı etkileyebilir.'),
          _uyari('İnternet bağlantısı bazı cihazlarda gerekli olabilir.'),

          /// SÜREÇ MANTIĞI
          _baslik('SÜREÇ MANTIĞI'),
          _madde('Sistem tetik → pencere → öneri mantığı ile çalışır.'),
          _madde('Aynı konuda birden fazla uyarı üretmez.'),
          _madde('Tarihli ve net öneriler verir.'),

          /// GENETİK SEÇİM
          _baslik('GENETİK SEÇİM'),
          _madde('Donör seçiminde oğul izi veto sebebidir.'),
          _madde('Performans ve genetik seçim ayrı değerlendirilir.'),
          _madde('Sakinlik varsayılan tercih edilir ancak ayarlardan değiştirilebilir.'),

          /// HIZ VE DAVRANIŞ
          _baslik('SİSTEM DAVRANIŞI'),
          _madde('Koloni detay ekranı hızlı açılır.'),
          _madde('Ağır analizler arka planda yüklenir.'),
          _madde('Liste ekranları hızlı ve akıcı çalışacak şekilde optimize edilmiştir.'),

        ],
      ),
    );
  }
}