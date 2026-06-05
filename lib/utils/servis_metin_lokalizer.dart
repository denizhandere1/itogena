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
    // Karar motoru — karar başlıkları
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

    // Süreç başlıkları
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

    // Grid etiketleri (güvenli tekrar — gridEtiketi'nden farklı çağrılabilir)
    'Yavru yok':         l.kolonGridYavruYok,
    'Meme kontrolü':     l.kolonGridMemeKontrol,
    'Yalancı ana riski': l.kolonGridYalanciAna,
    'Bekleme süreci':    l.kolonGridBeklemeSureci,
    'Süreç izleniyor':   l.kolonGridSurecIzleniyor,
    '3. kat ver':        l.kolonGridUcuncuKat,
    'Alan aç':           l.kolonGridAlanAc,
    'Kat ver':           l.kolonGridKatVer,
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
