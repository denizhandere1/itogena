import 'package:flutter/material.dart';
import 'package:itogena_v45/services/veritabani_servisi.dart';

class DilServisi {
  static Locale? _secilenDil;
  static void Function()? _yenidenOlustur;

  static Locale? get secilenDil => _secilenDil;

  static void _baglantiyiKur(void Function() yenidenOlustur) {
    _yenidenOlustur = yenidenOlustur;
  }

  static Future<void> yukle() async {
    final kod = await VeritabaniServisi.ayarStringGetir('dil_kodu', varsayilan: '');
    _secilenDil = _lokalAyarla(kod);
  }

  static Future<void> dilAyarla(String? kod) async {
    await VeritabaniServisi.ayarKaydet('dil_kodu', kod ?? '');
    _secilenDil = _lokalAyarla(kod);
    _yenidenOlustur?.call();
  }

  static Locale? _lokalAyarla(String? kod) {
    if (kod == 'en') return const Locale('en', 'US');
    if (kod == 'tr') return const Locale('tr', 'TR');
    return null; // sistem dili
  }

  static String secilenKod() {
    return _secilenDil?.languageCode ?? 'sistem';
  }

  // ItogenaApp tarafından çağrılır
  static void init(void Function() yenidenOlustur) {
    _baglantiyiKur(yenidenOlustur);
  }
}
