// views/exercises_list_page.dart
import 'package:flutter/material.dart';
import 'package:untitled/views/exercises/question.dart';
import '../../constants/theme.dart';
import '../../controllers/ExerciseController.dart';
import '../../models/exercise.dart';
import 'fill_blank_page.dart';


class ExercisesListPage extends StatefulWidget {
  final String subjectId;
  final String subjectName;

  const ExercisesListPage({
    super.key,
    required this.subjectId,
    required this.subjectName, required String classId,
  });

  @override
  State<ExercisesListPage> createState() => _ExercisesListPageState();
}

class _ExercisesListPageState extends State<ExercisesListPage> {
  late Future<List<Exercise>> _futureExercises;

  @override
  void initState() {
    super.initState();
    _futureExercises = ExerciseController.getExercisesBySubject(widget.subjectId);
  }

  void _refreshExercises() {
    setState(() {
      _futureExercises = ExerciseController.getExercisesBySubject(widget.subjectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(widget.subjectName),
        backgroundColor: AppTheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshExercises,
          ),
        ],
      ),
      body: FutureBuilder<List<Exercise>>(
        future: _futureExercises,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No exercises found"));
          } else {
            final exercises = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return _buildExerciseCard(exercise, context);
                },
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppTheme.background,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Type: ${exercise.type.toUpperCase()}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Difficulty: ${exercise.difficulty}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Points: ${exercise.totalPoints}',
              style: const TextStyle(fontSize: 14),
            ),
            if (exercise.studentProgress != null) ...[
              const SizedBox(height: 8),
              Text(
                'Status: ${exercise.studentProgress!.status}',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'Score: ${exercise.studentProgress!.score}/${exercise.totalPoints}',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'Attempts: ${exercise.studentProgress!.attemptNumber}/${exercise.metadata.maxAttempts}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              // Dans votre liste d'exercises
              onPressed: () {
                if (exercise.type == "qcm") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuestionsPage(
                        exerciseId: exercise.id,
                        exerciseTitle: exercise.title,
                      ),
                    ),
                  );
                } else if (exercise.type == "fill_blanks") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FillBlankPage(
                        exerciseId: exercise.id,
                        exerciseTitle: exercise.title,
                      ),
                    ),
                  );
                } else {
                  // Optionnel : gérer d'autres types ou afficher un message d'erreur
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Type d'exercice non supporté")),
                  );
                }
              },

              child: Text(
                exercise.studentProgress == null
                    ? 'Start Exercise'
                    : exercise.remainingAttempts > 0
                    ? 'Try Again'
                    : 'View Results',
              ),
            ),
          ],
        ),
      ),
    );
  }
}