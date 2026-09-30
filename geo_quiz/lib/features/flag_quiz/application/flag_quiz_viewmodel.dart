import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geo_quiz/data/countries.dart';

class FlagQuizViewModel extends ChangeNotifier {
  List<Country> options = [];
  Country? answer;

  bool isLoading = false;

  FlagQuizViewModel() {
    setOptions();
  }

  Future<void> setOptions() async {
    isLoading = true;
    notifyListeners();

    try {
      options = ([...allCountries]..shuffle()).take(4).toList();
      answer = options.isNotEmpty
          ? options[Random().nextInt(options.length)]
          : null;
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
