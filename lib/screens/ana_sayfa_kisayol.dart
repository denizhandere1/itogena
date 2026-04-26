import 'package:flutter/material.dart';
import 'ana_sayfa.dart';

class AnaSayfaKisayol {
  static Widget aksiyon(BuildContext context) {
    return IconButton(
      tooltip: 'Ana sayfa',
      onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AnaSayfa()),
              (route) => false,
        );
      },
      icon: const Icon(Icons.home_rounded, color: Colors.black),
    );
  }
}
