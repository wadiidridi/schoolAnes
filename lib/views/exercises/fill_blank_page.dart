// pages/FillBlankPage.dart
import 'package:flutter/material.dart';
import '../../constants/theme.dart';
import '../../controllers/fill_blank_controller.dart';
import '../../models/fillblank/FillBlankQuestion.dart';

class FillBlankPage extends StatefulWidget {
  final String exerciseId;
  final String exerciseTitle;

  const FillBlankPage({
    super.key,
    required this.exerciseId,
    required this.exerciseTitle,
  });

  @override
  State<FillBlankPage> createState() => _FillBlankPageState();
}

class _FillBlankPageState extends State<FillBlankPage> {
  late Future<List<FillBlankQuestion>> _futureQuestions;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() {
    setState(() {
      _futureQuestions = FillBlankController.getQuestions(widget.exerciseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(widget.exerciseTitle),
        backgroundColor: AppTheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadQuestions();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<FillBlankQuestion>>(
        future: _futureQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucune question trouvée."));
          }

          final questions = snapshot.data!;
          final firstQuestion = questions[0];
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              return Card(
                color: AppTheme.accent,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildSentenceWithBlanks(question),
                ),
              );
            },
          );

        },
      ),
    );
  }

  /// Affiche la phrase avec les blancs soulignés "____"
  Widget _buildSentenceWithBlanks(FillBlankQuestion question) {
    final sentenceParts = question.sentence.split('___');
    final blanks = question.blanks;

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 20),
        children: [
          for (int i = 0; i < sentenceParts.length; i++) ...[
            TextSpan(text: sentenceParts[i]),
            if (i < blanks.length)
              const TextSpan(
                text: '____',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
