import 'package:flutter/material.dart';
import 'package:itogena_v45/gen_l10n/app_localizations.dart';
import 'ana_sayfa.dart';

class AnaSayfaKisayol {
  static Widget aksiyon(BuildContext context) {
    return IconButton(
      tooltip: AppLocalizations.of(context).anaSayfa,
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
