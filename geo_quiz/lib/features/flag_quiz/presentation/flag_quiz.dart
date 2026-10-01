import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geo_quiz/data/providers/countries_provider.dart';
import 'package:geo_quiz/features/flag_quiz/application/quiz_controller.dart';
import 'package:geo_quiz/features/flag_quiz/application/quiz_state.dart';
import 'package:geo_quiz/features/flag_quiz/presentation/widgets/flag_button.dart';

class FlagQuiz extends ConsumerWidget {
  const FlagQuiz({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GeoQuiz'),
        actions: [
          IconButton(
            onPressed: state.hasValue
                ? ref.read(quizControllerProvider.notifier).restart
                : null,
            tooltip: 'Restart',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _ErrorView(
            message: '$error',
            onRetry: () => ref.invalidate(countriesProvider),
          ),
          data: (quiz) => _QuizBody(quiz),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 40,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizBody extends ConsumerWidget {
  const _QuizBody(this.quiz);

  final QuizState quiz;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(quizControllerProvider.notifier);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildScore(context),
              const SizedBox(height: 20),
              _buildQuestion(context),
              const SizedBox(height: 28),
              _buildOptions(controller),
              const SizedBox(height: 20),
              _buildFeedback(context),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: quiz.hasAnswered ? controller.nextQuestion : null,
                child: const Text('Next question'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScore(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'SCORE',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: 1.4,
          ),
        ),
        Text(
          '${quiz.score} / ${quiz.asked}',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestion(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Find the flag for',
          style: textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          quiz.answer.name,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildOptions(QuizController controller) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: quiz.options.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (context, index) {
        final country = quiz.options[index];
        return FlagButton(
          country: country,
          isSelected: quiz.selected?.code == country.code,
          isCorrect: country.code == quiz.answer.code,
          isRevealed: quiz.hasAnswered,
          onPressed: () => controller.selectAnswer(country),
        );
      },
    );
  }

  Widget _buildFeedback(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      !quiz.hasAnswered
          ? ''
          : quiz.isCorrect
          ? 'Correct!'
          : 'Not quite — the highlighted flag was right.',
      textAlign: TextAlign.center,
      style: theme.textTheme.titleMedium?.copyWith(
        color: quiz.isCorrect
            ? theme.colorScheme.primary
            : theme.colorScheme.error,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
