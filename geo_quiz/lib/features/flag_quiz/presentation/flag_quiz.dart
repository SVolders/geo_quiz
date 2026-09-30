import 'package:flutter/material.dart';
import 'package:geo_quiz/features/flag_quiz/application/flag_quiz_viewmodel.dart';

class FlagQuiz extends StatefulWidget {
  const FlagQuiz({super.key});

  @override
  State<FlagQuiz> createState() => _FlagQuizState();
}

class _FlagQuizState extends State<FlagQuiz> {
  final FlagQuizViewModel viewModel = FlagQuizViewModel();

  void _onReset() {
    viewModel.reset();
  }

  void _onOptionPressed(int index) {
    print(viewModel.options[index].name);
  }

  @override
  void initState() {
    super.initState();
    viewModel.setOptions();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => _onOptionPressed(0),
                            child: Text(viewModel.options[0].name),
                          ),
                          TextButton(
                            onPressed: () => _onOptionPressed(1),
                            child: Text(viewModel.options[1].name),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => _onOptionPressed(2),
                            child: Text(viewModel.options[2].name),
                          ),
                          TextButton(
                            onPressed: () => _onOptionPressed(3),
                            child: Text(viewModel.options[3].name),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Text(viewModel.answer?.name ?? 'No answer'),
                TextButton(onPressed: _onReset, child: Text("Reset")),
              ],
            ),
          ),
        );
      },
    );
  }
}
