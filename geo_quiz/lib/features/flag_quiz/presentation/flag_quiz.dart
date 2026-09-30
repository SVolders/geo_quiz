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
  Country? selected;

  void _onReset() {
    setState(() => selected = null);
    viewModel.nextQuestion();
  }

  void _onOptionPressed(Country country) {
    setState(() => selected = country);
  }

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
              _buildQuestion(context, answer),
              const SizedBox(height: 28),
              _buildOptions(answer),
              const SizedBox(height: 20),
              _buildFeedback(context, answer),
            ],
          ),
        ),
      ),
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
          onPressed: _onReset,
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
          isSelected: selected?.code == country.code,
          isCorrect: country.code == answer.code,
          onPressed: () => _onOptionPressed(country),
        );
      },
    );
  }

  Widget _buildFeedback(BuildContext context, Country answer) {
    final choice = selected;
    if (choice == null) return const SizedBox.shrink();

    final isCorrect = choice.code == answer.code;
    final colors = Theme.of(context).colorScheme;

    return Text(
      isCorrect ? 'Correct!' : 'Not quite. Try another flag.',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: isCorrect ? colors.primary : colors.error,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
