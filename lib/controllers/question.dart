// controllers/question_controller.dart
import '../models/question.dart';
import '../models/questions.dart';
import '../services/QuestionService.dart';

class QuestionController {
  static Future<ExerciseWithQuestions> getQuestions(String exerciseId) async {
    try {
      return await QuestionService.getQuestions(exerciseId);
    } catch (e) {
      rethrow;
    }
  }
}