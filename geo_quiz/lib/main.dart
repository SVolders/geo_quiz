import 'package:flutter/material.dart';
import 'package:geo_quiz/features/flag_quiz/presentation/flag_quiz.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text('GeoQuiz'),
          ),
        ),
        body: Center(child: FlagQuiz()),
      ),
    );
  }
}
