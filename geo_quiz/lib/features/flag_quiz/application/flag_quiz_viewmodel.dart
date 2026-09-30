import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:geo_quiz/data/models/country.dart';
import 'package:geo_quiz/data/repositories/countries_repository.dart';

class FlagQuizViewModel extends ChangeNotifier {
  FlagQuizViewModel(this._repo) {
    _initQuiz();
  }

  final CountriesRepository _repo;

  List<Country> countries = [];
  bool isLoading = true;
  String? error;
  bool _disposed = false;

  List<Country> options = [];
  Country? answer;
  Country? selected;
  final Random _random = Random();

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

  Future<void> _initQuiz() async {
    try {
      countries = await _repo.getCountries();
      _pickQuestion(); // <-- now runs on real data
    } catch (e, st) {
      error = 'Could not load countries';
      debugPrint('$e\n$st');
    } finally {
      isLoading = false;
      _safeNotify();
    }
  }

  void _pickQuestion() {
    options = ([...countries]..shuffle()).take(4).toList();
    answer = options.isNotEmpty
        ? options[_random.nextInt(options.length)]
        : null;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (_disposed) return;
    notifyListeners();
  }
}
