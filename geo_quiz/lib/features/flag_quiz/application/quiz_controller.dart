import 'dart:math';

import 'package:geo_quiz/data/models/country.dart';
import 'package:geo_quiz/data/providers/countries_provider.dart';
import 'package:geo_quiz/features/flag_quiz/application/quiz_state.dart';
import 'package:geo_quiz/features/flag_quiz/domain/question.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_controller.g.dart';

const _optionCount = 4;

@riverpod
class QuizController extends _$QuizController {
  final Random _random = Random();

  @override
  Future<QuizState> build() async {
    final countries = await ref.watch(countriesProvider.future);

    if (countries.length < _optionCount) {
      throw StateError(
        'Need at least $_optionCount countries, got ${countries.length}',
      );
    }

    return _newRound(countries);
  }

  void selectAnswer(Country country) {
    final current = state.value;
    if (current == null || current.hasAnswered) return;

    state = AsyncData(
      current.copyWith(
        selected: country,
        asked: current.asked + 1,
        score:
            current.score +
            (country.code == current.question.answer.code ? 1 : 0),
      ),
    );
  }

  void nextQuestion() {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(
      _newRound(
        current.countries,
        score: current.score,
        asked: current.asked,
      ),
    );
  }

  void restart() {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(_newRound(current.countries));
  }

  /// Builds a fresh state rather than using `copyWith`, because freezed's
  /// `copyWith` cannot set a nullable field back to `null` — passing
  /// `selected: null` is indistinguishable from omitting it.
  QuizState _newRound(
    List<Country> countries, {
    int score = 0,
    int asked = 0,
  }) {
    return QuizState(
      countries: countries,
      question: _newQuestion(countries),
      score: score,
      asked: asked,
    );
  }

  Question _newQuestion(List<Country> countries) {
    final options = ([...countries]..shuffle(_random))
        .take(_optionCount)
        .toList();

    return PickFlagQuestion(
      options: options,
      answer: options[_random.nextInt(options.length)],
    );
  }
}
