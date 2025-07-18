import 'package:flutter/material.dart';
import '../model/protein_data.dart';

class SavedProteinsProvider with ChangeNotifier {
  final List<Protein> _savedProteins = [];

  List<Protein> get savedProteins => List.unmodifiable(_savedProteins);

  bool isProteinSaved(Protein protein) {
    return _savedProteins.any((p) => p.name == protein.name);
  }

  void toggleSaveProtein(Protein protein) {
    final isAlreadySaved = isProteinSaved(protein);

    if (isAlreadySaved) {
      _savedProteins.removeWhere((p) => p.name == protein.name);
    } else {
      _savedProteins.add(protein);
    }

    notifyListeners();
  }
}
