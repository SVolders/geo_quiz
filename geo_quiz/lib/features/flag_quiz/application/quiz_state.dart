import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geo_quiz/data/models/country.dart';
import 'package:geo_quiz/features/flag_quiz/domain/question.dart';

part 'quiz_state.freezed.dart';

/// Immutable snapshot of one round of the quiz.
///
/// [question] is non-nullable: a state without a question cannot be
/// constructed, so the UI never has to check for one.
@freezed
abstract class QuizState with _$QuizState {
  const factory QuizState({
    required List<Country> countries,
    required Question question,
    Country? selected,
    @Default(0) int score,
    @Default(0) int asked,
  }) = _QuizState;

  const QuizState._();

  bool get hasAnswered => selected != null;

  bool get isCorrect {
    final choice = selected;
    return choice != null && choice.code == question.answer.code;
  }
}
