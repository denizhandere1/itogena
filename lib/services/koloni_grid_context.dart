class KoloniGridContext {
  final int koloniId;
  final bool aktifMi;

  final int skor;
  final int sonCita;

  final bool anaMemesiKritik;
  final bool anaMemesiTakip;
  final bool ogulAtti;
  final bool yavruYok;

  final String yonetimEtiketi;
  final int fizikselCita;
  final int islevselUretimCita;
  final int aktivasyonYuzde;

  const KoloniGridContext({
    required this.koloniId,
    required this.aktifMi,
    required this.skor,
    required this.sonCita,
    required this.anaMemesiKritik,
    required this.anaMemesiTakip,
    required this.ogulAtti,
    required this.yavruYok,
    required this.yonetimEtiketi,
    required this.fizikselCita,
    required this.islevselUretimCita,
    required this.aktivasyonYuzde,
  });

  bool get anaMemesiAlarmi => anaMemesiKritik || anaMemesiTakip;

  bool get hasatAdayi {
    if (!aktifMi) return false;
    return sonCita >= 8;
  }

  String get citaGridMetni {
    final fiziksel = fizikselCita > 0 ? fizikselCita : sonCita;
    if (fiziksel <= 0) return '- çıta';
    if (islevselUretimCita > 0) return '$fiziksel çıta • $islevselUretimCita işl.';
    if (aktivasyonYuzde > 0) return '$fiziksel çıta • %$aktivasyonYuzde';
    return '$fiziksel çıta';
  }

  static KoloniGridContext bos({
    required int koloniId,
    required bool aktifMi,
    int skor = 0,
    int sonCita = 0,
  }) {
    return KoloniGridContext(
      koloniId: koloniId,
      aktifMi: aktifMi,
      skor: skor,
      sonCita: sonCita,
      anaMemesiKritik: false,
      anaMemesiTakip: false,
      ogulAtti: false,
      yavruYok: false,
      yonetimEtiketi: '',
      fizikselCita: sonCita,
      islevselUretimCita: 0,
      aktivasyonYuzde: 0,
    );
  }
}
