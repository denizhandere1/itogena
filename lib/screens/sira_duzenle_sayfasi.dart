import 'package:flutter/material.dart';
import 'package:itogena_v45/gen_l10n/app_localizations.dart';
import '../services/veritabani_servisi.dart';

class SiraDuzenleSayfasi extends StatefulWidget {
  final int arilikId;
  final List<Map<String, dynamic>> aktifKoloniler;

  const SiraDuzenleSayfasi({
    super.key,
    required this.arilikId,
    required this.aktifKoloniler,
  });

  @override
  State<SiraDuzenleSayfasi> createState() => _SiraDuzenleSayfasiState();
}

class _SiraDuzenleSayfasiState extends State<SiraDuzenleSayfasi> {
  late List<Map<String, dynamic>> _liste;
  bool _kaydediliyor = false;
  bool _degisti = false;

  @override
  void initState() {
    super.initState();
    _liste = List.from(widget.aktifKoloniler);
  }

  Future<void> _kaydet() async {
    if (!_degisti) {
      Navigator.pop(context, false);
      return;
    }
    setState(() => _kaydediliyor = true);
    try {
      final idler = _liste.map((k) => _toInt(k['id'])).where((id) => id > 0).toList();
      await VeritabaniServisi.sahaSiralariKaydet(widget.arilikId, idler);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).siraDuzenleKaydedildi)),
      );
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _kaydediliyor = false);
    }
  }

  int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF3F1E6),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        title: Text(
          l.siraDuzenleBaslik,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        actions: [
          if (_kaydediliyor)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))),
            )
          else
            TextButton(
              onPressed: _kaydet,
              child: Text(
                l.kaydet,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
            child: Text(
              l.siraDuzenleAciklama,
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.brown.shade700,
                height: 1.45,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.only(bottom: 32),
              itemCount: _liste.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = _liste.removeAt(oldIndex);
                  _liste.insert(newIndex, item);
                  _degisti = true;
                });
              },
              itemBuilder: (context, i) {
                final k = _liste[i];
                final kovanNo = (k['kovanNo'] ?? '-').toString();
                final anaYili = (k['anaYili'] ?? '').toString();
                final kaynakTipi = (k['kaynakTipi'] ?? '').toString();
                return ListTile(
                  key: ValueKey(_toInt(k['id'])),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  leading: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.amber.shade700,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  title: Text(
                    kovanNo,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                  subtitle: anaYili.isNotEmpty || kaynakTipi.isNotEmpty
                      ? Text(
                          [if (kaynakTipi.isNotEmpty) kaynakTipi, if (anaYili.isNotEmpty) anaYili].join(' · '),
                          style: const TextStyle(fontSize: 12),
                        )
                      : null,
                  trailing: const Icon(Icons.drag_handle, color: Colors.brown),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
