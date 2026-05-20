/// ITOGENA koloni bağlam modeli.
///
/// Amaç: Aynı koloni için temel verinin farklı ekran ve servislerde tekrar
/// tekrar okunmasını azaltmak; süreç, karar ve saha görünümünü aynı veri
/// bağlamı üzerinden taşımaktır.
///
/// Bu sınıf bilinçli olarak hafif tutulur. Performans özeti, soy analizi,
/// hat analizi, ekonomik değer ve karşılaştırma gibi ağır analizler bu ilk
/// bağlamın parçası değildir. Onlar ilgili sekme/ekran açıldığında lazy-load
/// çalışmaya devam etmelidir.
class KoloniContext {
  final int koloniId;
  final int? arilikId;

  /// Veritabanından gelen güncel koloni özeti.
  final Map<String, dynamic> koloni;

  /// Yeni tarihten eski tarihe sıralı muayene listesi.
  final List<Map<String, dynamic>> muayeneler;

  /// Muayeneler boş değilse ilk kayıt.
  final Map<String, dynamic>? sonMuayene;

  /// Muayeneler en az iki kayıt içeriyorsa ikinci kayıt.
  final Map<String, dynamic>? oncekiMuayene;

  /// SurecMotoru / KararAsistanServisi üzerinden gelen süreç durumu.
  /// Beklenen alanlar: aktifSurecler, dominantSurec.
  final Map<String, dynamic> surecDurumu;

  /// Koloni ana karar kartı için standart çıktı.
  final Map<String, String> anaKarar;

  /// Genetik/seçilim kartı için standart çıktı.
  final Map<String, String> secilim;

  /// Grid ve genel durum tarafında kullanılan yönetim özeti.
  final Map<String, dynamic> yonetimOzeti;

  /// Detay ekranında gösterilen yönetim kararları.
  /// Besleme, kat, şurupluk, hasat sonrası bakım ve benzeri yönetim
  /// çıktıları burada liste halinde taşınır.
  final List<Map<String, dynamic>> yonetimKararlari;

  /// Aktif bal akımı bilgisi. Veri yoksa boş map döner.
  final Map<String, dynamic> balAkimi;

  /// Biyolojik model ağır hesap sayıldığı için varsayılan context içinde
  /// zorunlu değildir. İsteyen ekran/sekme ayrıca yükleyebilir.
  final Map<String, dynamic>? biyolojikModel;

  const KoloniContext({
    required this.koloniId,
    required this.arilikId,
    required this.koloni,
    required this.muayeneler,
    required this.sonMuayene,
    required this.oncekiMuayene,
    required this.surecDurumu,
    required this.anaKarar,
    required this.secilim,
    required this.yonetimOzeti,
    required this.yonetimKararlari,
    required this.balAkimi,
    this.biyolojikModel,
  });

  bool get veriVarMi => koloni.isNotEmpty;

  bool get muayeneVarMi => muayeneler.isNotEmpty;

  bool get biyolojikModelVarMi => biyolojikModel != null && biyolojikModel!.isNotEmpty;

  List<Map<String, dynamic>> get aktifSurecler {
    final ham = surecDurumu['aktifSurecler'];
    if (ham is! Iterable) return const <Map<String, dynamic>>[];
    return ham
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList(growable: false);
  }

  Map<String, dynamic>? get dominantSurec {
    final ham = surecDurumu['dominantSurec'];
    if (ham is! Map) return null;
    return Map<String, dynamic>.from(ham);
  }

  DateTime? get sonMuayeneTarihi => _tarihParse(sonMuayene?['tarih']);

  int get sonCita => _toInt(sonMuayene?['citaSayisi'] ?? koloni['sonCita']);

  int get sonBalCita => _toInt(sonMuayene?['bal_cita'] ?? koloni['bal_cita']);

  int get sonYavruluCita => _toInt(sonMuayene?['yavruluCita']);

  String get kovanNo {
    final metin = (koloni['kovanNo'] ?? '').toString().trim();
    return metin.isEmpty ? '-' : metin;
  }

  KoloniContext copyWith({
    Map<String, dynamic>? koloni,
    List<Map<String, dynamic>>? muayeneler,
    Map<String, dynamic>? sonMuayene,
    Map<String, dynamic>? oncekiMuayene,
    Map<String, dynamic>? surecDurumu,
    Map<String, String>? anaKarar,
    Map<String, String>? secilim,
    Map<String, dynamic>? yonetimOzeti,
    List<Map<String, dynamic>>? yonetimKararlari,
    Map<String, dynamic>? balAkimi,
    Map<String, dynamic>? biyolojikModel,
  }) {
    final yeniKoloni = koloni ?? this.koloni;
    return KoloniContext(
      koloniId: koloniId,
      arilikId: _nullableInt(yeniKoloni['arilikId']) ?? arilikId,
      koloni: yeniKoloni,
      muayeneler: muayeneler ?? this.muayeneler,
      sonMuayene: sonMuayene ?? this.sonMuayene,
      oncekiMuayene: oncekiMuayene ?? this.oncekiMuayene,
      surecDurumu: surecDurumu ?? this.surecDurumu,
      anaKarar: anaKarar ?? this.anaKarar,
      secilim: secilim ?? this.secilim,
      yonetimOzeti: yonetimOzeti ?? this.yonetimOzeti,
      yonetimKararlari: yonetimKararlari ?? this.yonetimKararlari,
      balAkimi: balAkimi ?? this.balAkimi,
      biyolojikModel: biyolojikModel ?? this.biyolojikModel,
    );
  }

  static int _toInt(dynamic deger) {
    if (deger == null) return 0;
    if (deger is int) return deger;
    if (deger is double) return deger.round();
    return int.tryParse(deger.toString()) ?? 0;
  }

  static int? _nullableInt(dynamic deger) {
    if (deger == null) return null;
    if (deger is int) return deger;
    if (deger is double) return deger.round();
    return int.tryParse(deger.toString());
  }

  static DateTime? _tarihParse(dynamic deger) {
    final metin = (deger ?? '').toString().trim();
    if (metin.isEmpty) return null;
    final dt = DateTime.tryParse(metin);
    if (dt == null) return null;
    return DateTime(dt.year, dt.month, dt.day);
  }
}
