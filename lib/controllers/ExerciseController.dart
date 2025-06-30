// controllers/exercise_controller.dart
import '../models/exercise.dart';
import '../services/ExerciseService.dart';

class ExerciseController {
  static Future<List<Exercise>> getExercisesBySubject(String subjectId) async {
    try {
      final response = await ExerciseService.getExercisesBySubject(subjectId);
      return response.exercises;
    } catch (e) {
      rethrow;
    }
  }
}