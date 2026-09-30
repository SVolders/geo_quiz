import 'package:flutter/material.dart';
import 'package:geo_quiz/data/countries.dart';
import 'package:geo_quiz/features/flag_quiz/application/flag_quiz_viewmodel.dart';
import 'package:geo_quiz/features/flag_quiz/presentation/widgets/flag_button.dart';

class FlagQuiz extends StatefulWidget {
  const FlagQuiz({super.key});

  @override
  State<FlagQuiz> createState() => _FlagQuizState();
}

class _FlagQuizState extends State<FlagQuiz> {
  final FlagQuizViewModel viewModel = FlagQuizViewModel();

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GeoQuiz')),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) => _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final answer = viewModel.answer;
    if (answer == null || viewModel.options.isEmpty) {
      return const Center(child: Text('No flags available'));
    }

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
              _buildQuestion(context, answer),
              const SizedBox(height: 28),
              _buildOptions(answer),
              const SizedBox(height: 20),
              _buildFeedback(context),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: viewModel.hasAnswered
                    ? viewModel.nextQuestion
                    : null,
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
          '${viewModel.score} / ${viewModel.asked}',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestion(BuildContext context, Country answer) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
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
              answer.name,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () => viewModel.restart(),
          tooltip: 'New question',
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  Widget _buildOptions(Country answer) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.options.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (context, index) {
        final country = viewModel.options[index];
        return FlagButton(
          country: country,
          isSelected: viewModel.selected?.code == country.code,
          isCorrect: country.code == answer.code,
          isRevealed: viewModel.hasAnswered,
          onPressed: () => viewModel.selectAnswer(country),
        );
      },
    );
  }

  Widget _buildFeedback(BuildContext context) {
    final theme = Theme.of(context);
    final isCorrect = viewModel.isCorrect;

    return Text(
      !viewModel.hasAnswered
          ? ''
          : isCorrect
          ? 'Correct!'
          : 'Not quite — the highlighted flag was right.',
      textAlign: TextAlign.center,
      style: theme.textTheme.titleMedium?.copyWith(
        color: isCorrect ? theme.colorScheme.primary : theme.colorScheme.error,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
