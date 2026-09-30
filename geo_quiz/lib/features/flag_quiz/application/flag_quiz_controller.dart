import 'package:flutter/material.dart';

import '../../../data/countries.dart';

class FlagQuizViewModel extends ChangeNotifier {
  List<Country> options = [];
  bool isLoading = false;

  FlagQuizViewModel() {
    setOptions();
  }

  Future<void> setOptions() async {
    isLoading = true;
    notifyListeners();

    try {
      options = ([...allCountries]..shuffle()).take(4).toList();
    } catch (e) {
      print('Error loading countries');
      options = [];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> reset() async {
    setOptions();
  }
}
