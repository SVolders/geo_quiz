import 'package:flutter/material.dart';
import 'package:geo_quiz/data/countries.dart';

class FlagQuizViewModel extends ChangeNotifier {
  List<Country> options = [];
  Country? answer;

  bool isLoading = false;

  FlagQuizViewModel() {
    reset();
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

  Future<void> setAnswer() async {
    answer = options.isNotEmpty ? (options..shuffle()).first : null;
  }

  Future<void> reset() async {
    setOptions();
    setAnswer();
  }
}
