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

  void nextQuestion() {
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
