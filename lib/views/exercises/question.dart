// views/questions_page.dart
import 'package:flutter/material.dart';
import '../../constants/theme.dart';
import '../../controllers/ExerciseController.dart';
import '../../controllers/question.dart';
import '../../models/questions.dart';

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

  @override
  void initState() {
    super.initState();
    _futureQuestions = QuestionController.getQuestions(widget.exerciseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(widget.exerciseTitle),
        backgroundColor: AppTheme.primary,
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
          _selectedOptions = List.filled(exercise.questions.length, null);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: exercise.questions.length,
              itemBuilder: (context, index) {
                return _buildQuestionCard(exercise.questions[index], index);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionCard(Question question, int questionIndex) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
                onChanged: (value) {
                  setState(() {
                    _selectedOptions[questionIndex] = value;
                  });
                },
                activeColor: AppTheme.primary,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}