import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:geo_quiz/data/countries.dart';

class FlagQuizViewModel extends ChangeNotifier {
  FlagQuizViewModel() {
    _pickQuestion();
  }

  final Random _random = Random();

  List<Country> options = [];
  Country? answer;
  Country? selected;

  int score = 0;
  int asked = 0;

  bool get hasAnswered => selected != null;

  bool get isCorrect {
    final choice = selected;
    return choice != null && choice.code == answer?.code;
  }

  void selectAnswer(Country country) {
    if (hasAnswered) return;

    selected = country;
    asked++;
    if (country.code == answer?.code) score++;

    notifyListeners();
  }

  void nextQuestion() {
    selected = null;
    _pickQuestion();
    notifyListeners();
  }

  void restart() {
    score = 0;
    asked = 0;
    selected = null;
    _pickQuestion();
    notifyListeners();
  }

  void _pickQuestion() {
    options = ([...allCountries]..shuffle()).take(4).toList();
    answer = options.isNotEmpty
        ? options[_random.nextInt(options.length)]
        : null;
  }
}
