import 'package:flutter/material.dart';
import 'package:untitled/views/exercises/result_page.dart';
import '../../constants/theme.dart';
import '../../controllers/question.dart';
import '../../controllers/reponseController.dart';
import '../../models/AnswerResponse.dart';
import '../../models/questions.dart';
import '../quiz/result_page.dart';

class QuestionsPage extends StatefulWidget {
  final String exerciseId;
  final String exerciseTitle;

  const QuestionsPage({
    super.key,
    required this.exerciseId,
    required this.exerciseTitle,
  });

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  late Future<ExerciseWithQuestions> _futureQuestions;
  List<int?> _selectedOptions = [];
  bool _isSubmitting = false;
  AnswerResponse? _lastSubmissionResponse;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() {
    setState(() {
      _futureQuestions = QuestionController.getQuestions(widget.exerciseId);
      _selectedOptions = [];
      _lastSubmissionResponse = null;
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
            onPressed: _loadQuestions,
          ),
        ],
      ),
      body: FutureBuilder<ExerciseWithQuestions>(
        future: _futureQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No questions found'));
          }

          final exercise = snapshot.data!;
          if (_selectedOptions.isEmpty) {
            _selectedOptions = List.filled(exercise.questions.length, null);
          }

          return Column(
            children: [
              if (_lastSubmissionResponse != null)
                _buildResultBanner(_lastSubmissionResponse!),
              Expanded(
                child: ListView.builder(
                  itemCount: exercise.questions.length,
                  itemBuilder: (context, index) {
                    return _buildQuestionCard(exercise.questions[index], index);
                  },
                ),
              ),
              _buildSubmitButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResultBanner(AnswerResponse response) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: response.score == response.totalPoints
          ? Colors.green.withOpacity(0.2)
          : Colors.orange.withOpacity(0.2),
      child: Column(
        children: [
          Text(
            'Score: ${response.score}/${response.totalPoints}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('Accuracy: ${response.accuracy}%'),
          if (response.remainingAttempts > 0)
            Text('Remaining attempts: ${response.remainingAttempts}'),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Question question, int questionIndex) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: AppTheme.accent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${questionIndex + 1}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(question.questionText),
            const SizedBox(height: 12),
            ...question.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              return RadioListTile<int>(
                title: Text(option.text),
                value: index,
                groupValue: _selectedOptions[questionIndex],
                onChanged: (value) => setState(() {
                  _selectedOptions[questionIndex] = value;
                }),
                activeColor: AppTheme.primary,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: _isSubmitting ? null : _submitAnswers,
        child: _isSubmitting
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Submit Answers'),
      ),
    );
  }

  Future<void> _submitAnswers() async {
    if (_selectedOptions.any((option) => option == null)) {
      // Remplacer SnackBar par une belle popup
      await showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: const Text('Attention'),
              content: const Text('Veuillez répondre à toutes les questions.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final exercise = await _futureQuestions;
      final answerIds = _selectedOptions
          .asMap()
          .entries
          .map((entry) {
        final questionIndex = entry.key;
        final optionIndex = entry.value!;
        return exercise.questions[questionIndex].options[optionIndex].id;
      }).toList();

      final response = await AnswerController.submitQcmAnswers(
        widget.exerciseId,
        answerIds,
      );

      setState(() => _lastSubmissionResponse = response);

      // ✅ Redirection vers ResultPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              QcmResultPage (
                score: response.score,
                total: response.totalPoints,
                message: response.message,
                  accuracy : response.accuracy,

              ),
        ),
      );
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: const Text('Erreur'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }
  // Future<void> _showResultDialog(AnswerResponse response) async {
  //   return showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       backgroundColor: AppTheme.background,
  //       title: Text('Résultats', style: TextStyle(color: AppTheme.primary)),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(response.message, style: const TextStyle(color: Colors.black)),
  //           const SizedBox(height: 16),
  //           Text('⭐ Score : ${response.score}/${response.totalPoints}'),
  //           Text('🎯 Précision : ${response.accuracy}%'),
  //           if (response.remainingAttempts > 0)
  //             Text('🔁 Tentatives restantes : ${response.remainingAttempts}'),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: const Text('OK'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  // Future<void> _showResultDialog(AnswerResponse response) async {
  //   return showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => Dialog(
  //       insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //       child: Padding(
  //         padding: const EdgeInsets.all(24),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const Text('Task Results',
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //             const SizedBox(height: 16),
  //             ScoreCircle(score: response.score, total: response.totalPoints),
  //             const SizedBox(height: 24),
  //             // if (response.incorrectAnswers != null &&
  //             //     response.incorrectAnswers!.isNotEmpty)
  //             //   Column(
  //             //     crossAxisAlignment: CrossAxisAlignment.start,
  //             //     children: [
  //             //       const Text(
  //             //         'Incorrect Answers',
  //             //         style: TextStyle(
  //             //           fontWeight: FontWeight.bold,
  //             //           fontSize: 16,
  //             //         ),
  //             //       ),
  //             //       const SizedBox(height: 12),
  //                   // ...response.incorrectAnswers!.asMap().entries.map((entry) {
  //                   //   final i = entry.key + 1;
  //                   //   final incorrect = entry.value;
  //                   //   return Padding(
  //                   //     padding: const EdgeInsets.symmetric(vertical: 4),
  //                   //     child: RichText(
  //                   //       text: TextSpan(
  //                   //         style: const TextStyle(color: Colors.black),
  //                   //         children: [
  //                   //           TextSpan(
  //                   //               text: 'Question $i: ${incorrect['question']}\n'),
  //                   //           TextSpan(
  //                   //             text:
  //                   //             'Correct Answer: ${incorrect['correctAnswer']}',
  //                   //             style: const TextStyle(color: Colors.blue),
  //                   //           ),
  //                   //         ],
  //                   //       ),
  //                   //     ),
  //                   //   );
  //                   // }
  //                   // ),
  //               //   ],
  //               // ),
  //             const SizedBox(height: 24),
  //             SizedBox(
  //               width: double.infinity,
  //               child: ElevatedButton(
  //                 onPressed: () => Navigator.of(context).pop(),
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.blue,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(30),
  //                   ),
  //                   padding: const EdgeInsets.symmetric(vertical: 16),
  //                 ),
  //                 child: const Text('Review Task'),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

}
// class ScoreCircle extends StatelessWidget {
//   final int score;
//   final int total;
//
//   const ScoreCircle({super.key, required this.score, required this.total});
//
//   @override
//   Widget build(BuildContext context) {
//     double percent = score / total;
//
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         SizedBox(
//           height: 140,
//           width: 140,
//           child: CircularProgressIndicator(
//             value: percent,
//             strokeWidth: 10,
//             backgroundColor: Colors.grey.shade200,
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
//           ),
//         ),
//         Text(
//           '$score/$total',
//           style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }
// }