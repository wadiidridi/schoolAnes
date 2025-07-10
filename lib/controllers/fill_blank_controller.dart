import '../models/AnswerResponse.dart';
import '../models/fillblank/FillBlankQuestion.dart';
import '../models/fillblank/fillblank.dart';
import '../services/FillBlank.dart';

class FillBlankController {
  static Future<List<FillBlankQuestion>> getQuestions(String exerciseId) async {
    try {
      return await FillBlankService.getQuestions(exerciseId);
    } catch (e) {
      print('Error fetching questions: $e');
      rethrow;
    }
  }

  static Future<AnswerResponse> submitAnswers(
      String exerciseId,
      List<List<String>> answers
      ) async {
    try {
      return await FillBlankService.submitAnswers(exerciseId, answers);
    } catch (e) {
      print('Error submitting answers: $e');
      rethrow;
    }
  }
}