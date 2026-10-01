import 'package:geo_quiz/data/models/country.dart';

/// One question, independent of which game mode produced it.
///
/// Variants describe the *shape of the ask* — what the prompt is and what the
/// options look like — not the mode. Several modes can share one shape.
///
/// Sealed, and every subtype lives in this file, so `switch` over a [Question]
/// is checked for exhaustiveness. Adding a variant makes the compiler point at
/// each place that has to handle it.
sealed class Question {
  const Question({required this.options, required this.answer});

  /// The choices shown, always including [answer].
  final List<Country> options;

  /// The country the player has to identify.
  final Country answer;
}

/// Prompt is a country name, options are flags.
///
/// "Find the flag for **Belgium**" → four flag tiles.
final class PickFlagQuestion extends Question {
  const PickFlagQuestion({required super.options, required super.answer});

  String get prompt => answer.name;
}
