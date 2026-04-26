import 'package:flutter/material.dart';
import 'veritabani_servisi.dart';

class EsikTanim {
  final String anahtar;
  final String baslik;
  final String aciklama;
  final int varsayilan;
  final int min;
  final int max;

  const EsikTanim({
    required this.anahtar,
    required this.baslik,
    required this.aciklama,
    required this.varsayilan,
    required this.min,
    required this.max,
  });
}

class EsikServisi {
  /// Genel anahtarlar korunuyor.
  /// Ayarlar ekranı ve mevcut çağrılar bozulmasın diye bunları tutuyoruz.
  static const Map<String, EsikTanim> tanimlar = {
    'destek_max_maks_cita': EsikTanim(
      anahtar: 'destek_max_maks_cita',
      baslik: 'Destek Koloni Üst Sınırı (Çıta)',
      aciklama:
      'Bu değer ve altındaki koloniler zayıf/destek grubuna düşer. '
          'Sistem destek ve müdahale yorumlarında bu sınırı dikkate alır.',
      varsayilan: 4,
      min: 2,
      max: 6,
    ),
    'orta_koloni_max_cita': EsikTanim(
      anahtar: 'orta_koloni_max_cita',
      baslik: 'Orta Koloni Üst Sınırı (Çıta)',
      aciklama:
      'Destek ile güçlü grup arasındaki ara bandı tanımlar. '
          'Bu sınır, arılık sağlık panelindeki orta grup sayımını etkiler.',
      varsayilan: 6,
      min: 4,
      max: 10,
    ),
    'guclu_koloni_min_cita': EsikTanim(
      anahtar: 'guclu_koloni_min_cita',
      baslik: 'Güçlü Koloni Alt Sınırı (Çıta)',
      aciklama:
      'Bu değerin üstündeki koloniler güçlü kabul edilir. '
          'Panel ve rapor tarafında sınıflamayı etkiler.',
      varsayilan: 7,
      min: 6,
      max: 12,
    ),
    'bolme_adayi_min_cita': EsikTanim(
      anahtar: 'bolme_adayi_min_cita',
      baslik: 'Bölme Adayı Alt Sınırı (Çıta)',
      aciklama:
      'Bölme kararı için gereken minimum mevcut koloni gücüdür. '
          'Sistem ayrıca maksimum kapasite ve trendi de birlikte okur.',
      varsayilan: 12,
      min: 8,
      max: 18,
    ),
    'ana_degisim_sezon_esigi': EsikTanim(
      anahtar: 'ana_degisim_sezon_esigi',
      baslik: 'Ana Değişim Yaşı Eşiği (Yıl)',
      aciklama:
      'Bu yaşa gelen veya geçen analar, performans zayıflıyorsa '
          'ana değişim değerlendirme grubuna alınır.',
      varsayilan: 2,
      min: 1,
      max: 4,
    ),
    'mudahale_min_skor': EsikTanim(
      anahtar: 'mudahale_min_skor',
      baslik: 'Müdahale / Düşük Skor Eşiği',
      aciklama:
      'Skor bu eşikten düşükse ve trend olumsuzsa sistem müdahale önerir. '
          'Aynı zamanda zayıf kolonilerin destek yorumunu da etkiler.',
      varsayilan: 45,
      min: 30,
      max: 60,
    ),
    'uretim_min_skor': EsikTanim(
      anahtar: 'uretim_min_skor',
      baslik: 'Üretim Kolonisi Minimum Skoru',
      aciklama:
      'Skor bu eşik ve üstündeyse, trend bozulmuyorsa sistem koloniyi '
          'üretim hattında değerlendirebilir.',
      varsayilan: 70,
      min: 60,
      max: 85,
    ),
    'damizlik_min_skor': EsikTanim(
      anahtar: 'damizlik_min_skor',
      baslik: 'Damızlık Minimum Skoru',
      aciklama:
      'Skor bu eşiğin üstündeyse, trend yükselişteyse ve ana yaşı uygunsa '
          'koloni damızlık adayı olarak işaretlenebilir.',
      varsayilan: 85,
      min: 75,
      max: 95,
    ),
  };

  /// Sezon bazlı tanımlar.
  /// Ayarlar ekranında ikinci adımda bunları da göstereceğiz.
  static const Map<String, EsikTanim> sezonTanimlar = {
    // KIŞ
    'kis_destek_max_maks_cita': EsikTanim(
      anahtar: 'kis_destek_max_maks_cita',
      baslik: 'Kış: Destek Koloni Üst Sınırı (Çıta)',
      aciklama:
      'Kışlama / dayanıklılık döneminde bu değer ve altı destek grubu kabul edilir.',
      varsayilan: 3,
      min: 2,
      max: 6,
    ),
    'kis_orta_koloni_max_cita': EsikTanim(
      anahtar: 'kis_orta_koloni_max_cita',
      baslik: 'Kış: Orta Koloni Üst Sınırı (Çıta)',
      aciklama:
      'Kış döneminde orta bant üst sınırıdır.',
      varsayilan: 5,
      min: 3,
      max: 9,
    ),
    'kis_guclu_koloni_min_cita': EsikTanim(
      anahtar: 'kis_guclu_koloni_min_cita',
      baslik: 'Kış: Güçlü Koloni Alt Sınırı (Çıta)',
      aciklama:
      'Kış döneminde bu değerin üstü güçlü kabul edilir.',
      varsayilan: 6,
      min: 4,
      max: 10,
    ),
    'kis_bolme_adayi_min_cita': EsikTanim(
      anahtar: 'kis_bolme_adayi_min_cita',
      baslik: 'Kış: Bölme Adayı Alt Sınırı (Çıta)',
      aciklama:
      'Kış döneminde pratikte bölme önerilmez. Bu değer güvenlik için yüksek tutulur.',
      varsayilan: 18,
      min: 12,
      max: 30,
    ),
    'kis_ana_degisim_sezon_esigi': EsikTanim(
      anahtar: 'kis_ana_degisim_sezon_esigi',
      baslik: 'Kış: Ana Değişim Yaşı Eşiği (Yıl)',
      aciklama:
      'Kış döneminde ana değişim değerlendirmesi için yaş eşiği.',
      varsayilan: 2,
      min: 1,
      max: 4,
    ),
    'kis_mudahale_min_skor': EsikTanim(
      anahtar: 'kis_mudahale_min_skor',
      baslik: 'Kış: Müdahale / Düşük Skor Eşiği',
      aciklama:
      'Kış döneminde düşük skor yorumu için kullanılan eşik.',
      varsayilan: 50,
      min: 35,
      max: 65,
    ),
    'kis_uretim_min_skor': EsikTanim(
      anahtar: 'kis_uretim_min_skor',
      baslik: 'Kış: Üretim Kolonisi Minimum Skoru',
      aciklama:
      'Kış döneminde üretim hattı yorumu daha geri planda tutulur.',
      varsayilan: 72,
      min: 60,
      max: 90,
    ),
    'kis_damizlik_min_skor': EsikTanim(
      anahtar: 'kis_damizlik_min_skor',
      baslik: 'Kış: Damızlık Minimum Skoru',
      aciklama:
      'Kış döneminde damızlık eşiği daha seçici tutulur.',
      varsayilan: 88,
      min: 75,
      max: 98,
    ),

    // ÜRETİM
    'uretim_destek_max_maks_cita': EsikTanim(
      anahtar: 'uretim_destek_max_maks_cita',
      baslik: 'Üretim: Destek Koloni Üst Sınırı (Çıta)',
      aciklama:
      'Gelişim / üretim döneminde destek grubu üst sınırıdır.',
      varsayilan: 4,
      min: 2,
      max: 6,
    ),
    'uretim_orta_koloni_max_cita': EsikTanim(
      anahtar: 'uretim_orta_koloni_max_cita',
      baslik: 'Üretim: Orta Koloni Üst Sınırı (Çıta)',
      aciklama:
      'Gelişim / üretim döneminde orta bant üst sınırıdır.',
      varsayilan: 6,
      min: 4,
      max: 10,
    ),
    'uretim_guclu_koloni_min_cita': EsikTanim(
      anahtar: 'uretim_guclu_koloni_min_cita',
      baslik: 'Üretim: Güçlü Koloni Alt Sınırı (Çıta)',
      aciklama:
      'Gelişim / üretim döneminde bu değerin üstü güçlü kabul edilir.',
      varsayilan: 7,
      min: 5,
      max: 12,
    ),
    'uretim_bolme_adayi_min_cita': EsikTanim(
      anahtar: 'uretim_bolme_adayi_min_cita',
      baslik: 'Üretim: Bölme Adayı Alt Sınırı (Çıta)',
      aciklama:
      'Gelişim / üretim döneminde bölme için minimum mevcut güç.',
      varsayilan: 12,
      min: 8,
      max: 18,
    ),
    'uretim_ana_degisim_sezon_esigi': EsikTanim(
      anahtar: 'uretim_ana_degisim_sezon_esigi',
      baslik: 'Üretim: Ana Değişim Yaşı Eşiği (Yıl)',
      aciklama:
      'Gelişim / üretim döneminde ana değişim değerlendirmesi için yaş eşiği.',
      varsayilan: 2,
      min: 1,
      max: 4,
    ),
    'uretim_mudahale_min_skor': EsikTanim(
      anahtar: 'uretim_mudahale_min_skor',
      baslik: 'Üretim: Müdahale / Düşük Skor Eşiği',
      aciklama:
      'Gelişim / üretim döneminde düşük skor yorumu için eşik.',
      varsayilan: 45,
      min: 30,
      max: 60,
    ),
    'uretim_uretim_min_skor': EsikTanim(
      anahtar: 'uretim_uretim_min_skor',
      baslik: 'Üretim: Üretim Kolonisi Minimum Skoru',
      aciklama:
      'Gelişim / üretim döneminde üretim hattı eşiği.',
      varsayilan: 70,
      min: 60,
      max: 85,
    ),
    'uretim_damizlik_min_skor': EsikTanim(
      anahtar: 'uretim_damizlik_min_skor',
      baslik: 'Üretim: Damızlık Minimum Skoru',
      aciklama:
      'Gelişim / üretim döneminde damızlık seçilim eşiği.',
      varsayilan: 85,
      min: 75,
      max: 95,
    ),
  };

  /// Mevcut çağrılar bozulmasın diye isim aynı kaldı.
  /// Artık aktif sezona göre doğru eşikleri döndürür.
  static Future<Map<String, int>> tumEsikleriYukle({DateTime? tarih}) async {
    final sezon = await VeritabaniServisi.aktifSezonKoduGetir(tarih);
    return sezonEsikleriniYukle(sezonKodu: sezon);
  }

  /// Belirli sezon için eşikleri yükler.
  static Future<Map<String, int>> sezonEsikleriniYukle({
    required String sezonKodu,
  }) async {
    final Map<String, int> sonuc = {};
    final bool kis = sezonKodu == 'kis';

    sonuc['destek_max_maks_cita'] = await _sezonluAyarGetir(
      sezonAnahtar: kis ? 'kis_destek_max_maks_cita' : 'uretim_destek_max_maks_cita',
      genelAnahtar: 'destek_max_maks_cita',
      tanim: kis
          ? sezonTanimlar['kis_destek_max_maks_cita']!
          : sezonTanimlar['uretim_destek_max_maks_cita']!,
      genelTanim: tanimlar['destek_max_maks_cita']!,
    );

    sonuc['orta_koloni_max_cita'] = await _sezonluAyarGetir(
      sezonAnahtar: kis ? 'kis_orta_koloni_max_cita' : 'uretim_orta_koloni_max_cita',
      genelAnahtar: 'orta_koloni_max_cita',
      tanim: kis
          ? sezonTanimlar['kis_orta_koloni_max_cita']!
          : sezonTanimlar['uretim_orta_koloni_max_cita']!,
      genelTanim: tanimlar['orta_koloni_max_cita']!,
    );

    sonuc['guclu_koloni_min_cita'] = await _sezonluAyarGetir(
      sezonAnahtar: kis ? 'kis_guclu_koloni_min_cita' : 'uretim_guclu_koloni_min_cita',
      genelAnahtar: 'guclu_koloni_min_cita',
      tanim: kis
          ? sezonTanimlar['kis_guclu_koloni_min_cita']!
          : sezonTanimlar['uretim_guclu_koloni_min_cita']!,
      genelTanim: tanimlar['guclu_koloni_min_cita']!,
    );

    sonuc['bolme_adayi_min_cita'] = await _sezonluAyarGetir(
      sezonAnahtar: kis ? 'kis_bolme_adayi_min_cita' : 'uretim_bolme_adayi_min_cita',
      genelAnahtar: 'bolme_adayi_min_cita',
      tanim: kis
          ? sezonTanimlar['kis_bolme_adayi_min_cita']!
          : sezonTanimlar['uretim_bolme_adayi_min_cita']!,
      genelTanim: tanimlar['bolme_adayi_min_cita']!,
    );

    sonuc['ana_degisim_sezon_esigi'] = await _sezonluAyarGetir(
      sezonAnahtar: kis ? 'kis_ana_degisim_sezon_esigi' : 'uretim_ana_degisim_sezon_esigi',
      genelAnahtar: 'ana_degisim_sezon_esigi',
      tanim: kis
          ? sezonTanimlar['kis_ana_degisim_sezon_esigi']!
          : sezonTanimlar['uretim_ana_degisim_sezon_esigi']!,
      genelTanim: tanimlar['ana_degisim_sezon_esigi']!,
    );

    sonuc['mudahale_min_skor'] = await _sezonluAyarGetir(
      sezonAnahtar: kis ? 'kis_mudahale_min_skor' : 'uretim_mudahale_min_skor',
      genelAnahtar: 'mudahale_min_skor',
      tanim: kis
          ? sezonTanimlar['kis_mudahale_min_skor']!
          : sezonTanimlar['uretim_mudahale_min_skor']!,
      genelTanim: tanimlar['mudahale_min_skor']!,
    );

    sonuc['uretim_min_skor'] = await _sezonluAyarGetir(
      sezonAnahtar: kis ? 'kis_uretim_min_skor' : 'uretim_uretim_min_skor',
      genelAnahtar: 'uretim_min_skor',
      tanim: kis
          ? sezonTanimlar['kis_uretim_min_skor']!
          : sezonTanimlar['uretim_uretim_min_skor']!,
      genelTanim: tanimlar['uretim_min_skor']!,
    );

    sonuc['damizlik_min_skor'] = await _sezonluAyarGetir(
      sezonAnahtar: kis ? 'kis_damizlik_min_skor' : 'uretim_damizlik_min_skor',
      genelAnahtar: 'damizlik_min_skor',
      tanim: kis
          ? sezonTanimlar['kis_damizlik_min_skor']!
          : sezonTanimlar['uretim_damizlik_min_skor']!,
      genelTanim: tanimlar['damizlik_min_skor']!,
    );

    return sonuc;
  }

  static Future<int> _sezonluAyarGetir({
    required String sezonAnahtar,
    required String genelAnahtar,
    required EsikTanim tanim,
    required EsikTanim genelTanim,
  }) async {
    final sezonDeger = await VeritabaniServisi.ayarIntGetir(
      sezonAnahtar,
      varsayilan: tanim.varsayilan,
    );

    // Sezon değeri yoksa yine de genel değerden düşmesin diye destek.
    final genelDeger = await VeritabaniServisi.ayarIntGetir(
      genelAnahtar,
      varsayilan: genelTanim.varsayilan,
    );

    final aday = sezonDeger == 0 ? genelDeger : sezonDeger;
    return _siniraZorla(aday, tanim.min, tanim.max);
  }

  /// Mevcut ayarlar ekranı için genel eşikleri yükleme.
  /// Bu metot özellikle ayarlar ekranını kırmamak için tutuldu.
  static Future<Map<String, int>> genelEsikleriYukle() async {
    final Map<String, int> sonuc = {};

    for (final entry in tanimlar.entries) {
      final tanim = entry.value;
      final ham = await VeritabaniServisi.ayarIntGetir(
        tanim.anahtar,
        varsayilan: tanim.varsayilan,
      );
      sonuc[tanim.anahtar] = _siniraZorla(ham, tanim.min, tanim.max);
    }

    return sonuc;
  }

  /// Eski ayarlar ekranı bozulmasın diye isim korunuyor.
  /// Şimdilik sadece genel eşikleri kaydediyor.
  static Future<void> tumEsikleriKaydet(Map<String, int> esikler) async {
    final duzeltilmis = _duzeltVeSinirla(esikler, tanimlar);
    final hata = dogrulamaHatasi(duzeltilmis);

    if (hata != null) {
      throw Exception(hata);
    }

    for (final entry in duzeltilmis.entries) {
      await VeritabaniServisi.ayarKaydet(entry.key, entry.value.toString());
    }
  }

  /// Yeni: sezon bazlı ayarları kaydet
  static Future<void> sezonEsikleriniKaydet({
    required String sezonKodu,
    required Map<String, int> esikler,
  }) async {
    final bool kis = sezonKodu == 'kis';

    final map = <String, int>{
      kis ? 'kis_destek_max_maks_cita' : 'uretim_destek_max_maks_cita':
      esikler['destek_max_maks_cita'] ?? (kis ? 3 : 4),
      kis ? 'kis_orta_koloni_max_cita' : 'uretim_orta_koloni_max_cita':
      esikler['orta_koloni_max_cita'] ?? (kis ? 5 : 6),
      kis ? 'kis_guclu_koloni_min_cita' : 'uretim_guclu_koloni_min_cita':
      esikler['guclu_koloni_min_cita'] ?? (kis ? 6 : 7),
      kis ? 'kis_bolme_adayi_min_cita' : 'uretim_bolme_adayi_min_cita':
      esikler['bolme_adayi_min_cita'] ?? (kis ? 18 : 12),
      kis ? 'kis_ana_degisim_sezon_esigi' : 'uretim_ana_degisim_sezon_esigi':
      esikler['ana_degisim_sezon_esigi'] ?? 2,
      kis ? 'kis_mudahale_min_skor' : 'uretim_mudahale_min_skor':
      esikler['mudahale_min_skor'] ?? (kis ? 50 : 45),
      kis ? 'kis_uretim_min_skor' : 'uretim_uretim_min_skor':
      esikler['uretim_min_skor'] ?? (kis ? 72 : 70),
      kis ? 'kis_damizlik_min_skor' : 'uretim_damizlik_min_skor':
      esikler['damizlik_min_skor'] ?? (kis ? 88 : 85),
    };

    final tanimMap = kis
        ? {
      'kis_destek_max_maks_cita': sezonTanimlar['kis_destek_max_maks_cita']!,
      'kis_orta_koloni_max_cita': sezonTanimlar['kis_orta_koloni_max_cita']!,
      'kis_guclu_koloni_min_cita': sezonTanimlar['kis_guclu_koloni_min_cita']!,
      'kis_bolme_adayi_min_cita': sezonTanimlar['kis_bolme_adayi_min_cita']!,
      'kis_ana_degisim_sezon_esigi': sezonTanimlar['kis_ana_degisim_sezon_esigi']!,
      'kis_mudahale_min_skor': sezonTanimlar['kis_mudahale_min_skor']!,
      'kis_uretim_min_skor': sezonTanimlar['kis_uretim_min_skor']!,
      'kis_damizlik_min_skor': sezonTanimlar['kis_damizlik_min_skor']!,
    }
        : {
      'uretim_destek_max_maks_cita': sezonTanimlar['uretim_destek_max_maks_cita']!,
      'uretim_orta_koloni_max_cita': sezonTanimlar['uretim_orta_koloni_max_cita']!,
      'uretim_guclu_koloni_min_cita': sezonTanimlar['uretim_guclu_koloni_min_cita']!,
      'uretim_bolme_adayi_min_cita': sezonTanimlar['uretim_bolme_adayi_min_cita']!,
      'uretim_ana_degisim_sezon_esigi': sezonTanimlar['uretim_ana_degisim_sezon_esigi']!,
      'uretim_mudahale_min_skor': sezonTanimlar['uretim_mudahale_min_skor']!,
      'uretim_uretim_min_skor': sezonTanimlar['uretim_uretim_min_skor']!,
      'uretim_damizlik_min_skor': sezonTanimlar['uretim_damizlik_min_skor']!,
    };

    final duzeltilmis = _duzeltVeSinirla(map, tanimMap);

    final genelMap = <String, int>{
      'destek_max_maks_cita':
      duzeltilmis[kis ? 'kis_destek_max_maks_cita' : 'uretim_destek_max_maks_cita']!,
      'orta_koloni_max_cita':
      duzeltilmis[kis ? 'kis_orta_koloni_max_cita' : 'uretim_orta_koloni_max_cita']!,
      'guclu_koloni_min_cita':
      duzeltilmis[kis ? 'kis_guclu_koloni_min_cita' : 'uretim_guclu_koloni_min_cita']!,
      'bolme_adayi_min_cita':
      duzeltilmis[kis ? 'kis_bolme_adayi_min_cita' : 'uretim_bolme_adayi_min_cita']!,
      'ana_degisim_sezon_esigi':
      duzeltilmis[kis ? 'kis_ana_degisim_sezon_esigi' : 'uretim_ana_degisim_sezon_esigi']!,
      'mudahale_min_skor':
      duzeltilmis[kis ? 'kis_mudahale_min_skor' : 'uretim_mudahale_min_skor']!,
      'uretim_min_skor':
      duzeltilmis[kis ? 'kis_uretim_min_skor' : 'uretim_uretim_min_skor']!,
      'damizlik_min_skor':
      duzeltilmis[kis ? 'kis_damizlik_min_skor' : 'uretim_damizlik_min_skor']!,
    };

    final hata = dogrulamaHatasi(genelMap);
    if (hata != null) {
      throw Exception(hata);
    }

    for (final entry in duzeltilmis.entries) {
      await VeritabaniServisi.ayarKaydet(entry.key, entry.value.toString());
    }
  }

  static Map<String, int> _duzeltVeSinirla(
      Map<String, int> esikler,
      Map<String, EsikTanim> tanimMap,
      ) {
    final sonuc = <String, int>{};

    for (final entry in tanimMap.entries) {
      final tanim = entry.value;
      final deger = esikler[tanim.anahtar] ?? tanim.varsayilan;
      sonuc[tanim.anahtar] = _siniraZorla(deger, tanim.min, tanim.max);
    }

    return sonuc;
  }

  static int _siniraZorla(int deger, int min, int max) {
    if (deger < min) return min;
    if (deger > max) return max;
    return deger;
  }

  static String? dogrulamaHatasi(Map<String, int> e) {
    final destek = e['destek_max_maks_cita'] ?? 4;
    final orta = e['orta_koloni_max_cita'] ?? 6;
    final guclu = e['guclu_koloni_min_cita'] ?? 7;
    final dusukSkor = e['mudahale_min_skor'] ?? 45;
    final uretimSkor = e['uretim_min_skor'] ?? 70;
    final damizlikSkor = e['damizlik_min_skor'] ?? 85;
    final bolmeCita = e['bolme_adayi_min_cita'] ?? 12;

    if (destek >= orta) {
      return 'Destek sınırı, orta koloni sınırından küçük olmalıdır.';
    }

    if (orta >= guclu) {
      return 'Orta koloni sınırı, güçlü koloni sınırından küçük olmalıdır.';
    }

    if (dusukSkor >= uretimSkor) {
      return 'Müdahale skoru, üretim skorundan düşük olmalıdır.';
    }

    if (uretimSkor >= damizlikSkor) {
      return 'Üretim skoru, damızlık skorundan düşük olmalıdır.';
    }

    if (bolmeCita <= guclu) {
      return 'Bölme çıta eşiği, güçlü koloni çıta sınırından büyük olmalıdır.';
    }

    return null;
  }

  static Color skorRengi(int skor, Map<String, int> e) {
    final damizlik = e['damizlik_min_skor'] ?? 85;
    final uretim = e['uretim_min_skor'] ?? 70;
    final dusuk = e['mudahale_min_skor'] ?? 45;

    if (skor >= damizlik) return Colors.purple;
    if (skor >= uretim) return Colors.green;
    if (skor >= dusuk) return Colors.orange;
    return Colors.red;
  }

  static String skorSeviyesi(int skor, Map<String, int> e) {
    final damizlik = e['damizlik_min_skor'] ?? 85;
    final uretim = e['uretim_min_skor'] ?? 70;
    final dusuk = e['mudahale_min_skor'] ?? 45;

    if (skor >= damizlik) return 'Damızlık Seviyesi';
    if (skor >= uretim) return 'Üretim Seviyesi';
    if (skor >= dusuk) return 'İzleme Seviyesi';
    return 'Riskli Seviye';
  }

  static bool anaDegisimAdayi({
    required int anaYasi,
    required int skor,
    required Map<String, int> e,
  }) {
    final yasEsik = e['ana_degisim_sezon_esigi'] ?? 2;
    final uretimSkor = e['uretim_min_skor'] ?? 70;
    return anaYasi >= yasEsik && skor < uretimSkor;
  }

  static bool bolmeAdayi({
    required int sonCita,
    required int maxCita,
    required String trend,
    required Map<String, int> e,
  }) {
    final bolmeCita = e['bolme_adayi_min_cita'] ?? 12;
    final minMaksCita = bolmeCita + 2;
    return sonCita >= bolmeCita && maxCita >= minMaksCita && trend != 'Düşüş';
  }

  static bool damizlikAdayi({
    required int skor,
    required String trend,
    required int anaYasi,
    required Map<String, int> e,
  }) {
    final damizlikSkor = e['damizlik_min_skor'] ?? 85;
    final yasEsik = e['ana_degisim_sezon_esigi'] ?? 2;
    return skor >= damizlikSkor && trend == 'Yükseliş' && anaYasi <= yasEsik;
  }

  static bool uretimKolonisi({
    required int skor,
    required String trend,
    required Map<String, int> e,
  }) {
    final uretimSkor = e['uretim_min_skor'] ?? 70;
    return skor >= uretimSkor && trend != 'Düşüş';
  }

  static bool mudahaleGerekli({
    required int skor,
    required String trend,
    required Map<String, int> e,
  }) {
    final dusukSkor = e['mudahale_min_skor'] ?? 45;
    return skor < dusukSkor && trend == 'Düşüş';
  }

  static bool destekGerekli({
    required int skor,
    required int sonCita,
    required Map<String, int> e,
  }) {
    final dusukSkor = e['mudahale_min_skor'] ?? 45;
    final destekCita = e['destek_max_maks_cita'] ?? 4;
    return skor < dusukSkor || sonCita <= destekCita;
  }

  static String sistemYontemiOzeti() {
    return '''
ITOGENA karar motoru sabit tek kuralla çalışmaz; çoklu veri okuması yapar.

Kullandığı yöntem:
• Skor = gelişim, verim, sağlık ve mizaç bileşenlerinin birleşik sonucudur.
• Trend = son muayene serisindeki yön bilgisidir.
• Karar = skor + çıta gücü + trend + ana yaşı birlikte okunarak üretilir.
• Sezon = aynı veri farklı mevsimde farklı anlam üreteceği için eşikler aktif sezona göre yorumlanır.
• Bölme kararı sadece anlık güçle değil, maksimum kapasite ile birlikte değerlendirilir.
• Damızlık kararı sadece yüksek skorla değil; yükselen trend ve uygun ana yaşı ile verilir.
• Kullanıcı eşikleri değiştirebilir; ancak sistem omurgasını korumak için her alan kontrollü sınırlar içinde tutulur.
''';
  }

  static List<String> kararRehberiMaddeleri() {
    return const [
      "Sistem tek veriye bakmaz; skor, çıta, trend ve ana yaşı birlikte okunur.",
      "Aynı veri farklı sezonda farklı anlam taşıyabileceği için aktif sezon eşikleri kullanılır.",
      "Düşük skor + düşüş trendi birleşirse müdahale önceliği oluşur.",
      "Ana yaşı eşiği aşılmış ve performans üretim düzeyine çıkamıyorsa ana değişimi değerlendirilir.",
      "Bölme kararı için yalnızca mevcut çıta değil, geçmişte ulaşılan maksimum kapasite de dikkate alınır.",
      "Damızlık kararı için yüksek skor tek başına yetmez; yükseliş trendi ve uygun ana yaşı da gerekir.",
      "Kullanıcı eşikleri değiştirebilir; ancak sistemin anlamını korumak için her eşik güvenli sınırlar içinde tutulur.",
    ];
  }
}