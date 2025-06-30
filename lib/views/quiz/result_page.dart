import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int score;
  final int total;
  const ResultPage({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Résultat")),
      body: Center(
        child: Text("Votre score : $score / $total", style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
