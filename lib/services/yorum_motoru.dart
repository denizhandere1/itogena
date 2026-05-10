class YorumMotoru {
  static String soyYorumUret({
    required double yasamaOrani,
    required int toplamTureyen,
    required int aktifTureyen,
    required int muayeneSayisi,
    bool veriYetersizMi = false,
  }) {
    if (toplamTureyen <= 0) {
      return 'Henüz değerlendirilebilir türeyen koloni verisi yok.';
    }

    final yuzde = (yasamaOrani * 100).round();

    String yorum;
    if (yasamaOrani >= 0.75) {
      yorum = 'Güçlü soy';
    } else if (yasamaOrani >= 0.50) {
      yorum = 'Orta seviye soy';
    } else if (yasamaOrani >= 0.30) {
      yorum = 'Zayıf soy';
    } else {
      yorum = 'Hat zayıf';
    }

    int veriPuani = 0;

    if (toplamTureyen >= 10) {
      veriPuani += 3;
    } else if (toplamTureyen >= 5) {
      veriPuani += 2;
    } else if (toplamTureyen >= 2) {
      veriPuani += 1;
    }

    if (aktifTureyen >= 5) {
      veriPuani += 2;
    } else if (aktifTureyen >= 2) {
      veriPuani += 1;
    }

    if (muayeneSayisi >= 20) {
      veriPuani += 2;
    } else if (muayeneSayisi >= 10) {
      veriPuani += 1;
    }

    final buffer = StringBuffer('%$yuzde devamlılık. $yorum.');

    if (veriYetersizMi || veriPuani <= 2) {
      buffer.write(' Veri zayıf, dikkatli değerlendirilmeli.');
    } else if (veriPuani <= 4) {
      buffer.write(' Veri sınırlı, izlenmeli.');
    }

    return buffer.toString();
  }

  static String veriGuveniCumlesiUret(int muayeneSayisi) {
    if (muayeneSayisi <= 0) {
      return 'Veri yok; karar yalnızca kimlik ve kaynak bilgisine göre sınırlıdır.';
    }
    if (muayeneSayisi == 1) {
      return 'Veri çok sınırlı; sistem karar verir ama güven düzeyi düşüktür.';
    }
    if (muayeneSayisi <= 4) {
      return 'Veri izlenmeli; karar var ama sonraki muayenelerle güçlenmelidir.';
    }
    return 'Veri güveni yeterli; değerlendirme güvenilir banda girmiştir.';
  }

  static String kararCumlesiUret({
    required String secilimBaslik,
    required String kararBaslik,
    String? vetoNedeni,
  }) {
    final temizSecilim = secilimBaslik.trim();
    final temizKarar = kararBaslik.trim();
    final temizVeto = (vetoNedeni ?? '').trim();

    if (temizSecilim.isEmpty && temizKarar.isEmpty) {
      return 'Karar üretmek için yeterli veri yok.';
    }

    if (temizVeto.isNotEmpty && temizSecilim.isNotEmpty && temizKarar.isNotEmpty) {
      return '$temizSecilim ($temizVeto). $temizKarar. Ana üretme; üretim, destek veya saha kullanımı ayrıca değerlendirilebilir.';
    }

    if (temizSecilim.isNotEmpty && temizKarar.isNotEmpty) {
      return '$temizSecilim. $temizKarar.';
    }

    if (temizKarar.isNotEmpty) {
      return '$temizKarar.';
    }

    return '$temizSecilim.';
  }
}
