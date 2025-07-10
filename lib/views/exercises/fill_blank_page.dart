import 'package:flutter/material.dart';
import 'package:untitled/views/exercises/result_page.dart';
import '../../constants/theme.dart';
import '../../controllers/fill_blank_controller.dart';
import '../../models/fillblank/FillBlankQuestion.dart';
import '../../models/AnswerResponse.dart';
import '../../models/fillblank/fillblank.dart';

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
  List<List<TextEditingController>> _controllersPerQuestion = [];
  AnswerResponse? _lastSubmissionResponse;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() {
    setState(() {
      _futureQuestions = FillBlankController.getQuestions(widget.exerciseId);
      _futureQuestions.then((questions) {
        _controllersPerQuestion = questions
            .map((q) => List.generate(q.blanks.length, (_) => TextEditingController()))
            .toList();
      });
      _lastSubmissionResponse = null;
    });
  }

  Future<void> _submitAnswers() async {
    try {
      final answers = _controllersPerQuestion.map((controllerList) {
        return controllerList.map((ctrl) => ctrl.text.trim()).toList();
      }).toList();

      final response = await FillBlankController.submitAnswers(widget.exerciseId, answers);

      setState(() => _lastSubmissionResponse = response);

      // ✅ Redirection vers la page de résultats
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QcmResultPage(
            score: response.score,
            total: response.totalPoints,
            message: response.message,
            accuracy: response.accuracy,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la soumission : $e")),
      );
      print('❌ Erreur lors de la soumission : $e');
    }
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
            onPressed: _loadQuestions,
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
          return Column(
            children: [
              if (_lastSubmissionResponse != null)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Résultat : ${_lastSubmissionResponse!.score}/${_lastSubmissionResponse!.totalPoints} '
                        '- ${_lastSubmissionResponse!.accuracy}%',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final question = questions[index];
                    return Card(
                      color: AppTheme.accent,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: _buildSentenceWithBlanks(question, index),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _submitAnswers,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Soumettre les réponses"),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildSentenceWithBlanks(FillBlankQuestion question, int index) {
    final sentenceParts = question.sentence.split('___');
    final controllers = _controllersPerQuestion[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Question ${index + 1}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          children: [
            for (int i = 0; i < sentenceParts.length; i++) ...[
              Text(
                sentenceParts[i],
                style: const TextStyle(fontSize: 16),
              ),
              if (i < controllers.length)
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: controllers[i],
                    decoration: const InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      isDense: true,
                      hintText: '...?',

                      // Optionnel : amélioration visuelle
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Points: ${question.points}',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
