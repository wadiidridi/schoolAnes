import '../models/AnswerResponse.dart';
import '../services/reponseService.dart';

class AnswerController {
  // QCM
  static Future<AnswerResponse> submitQcmAnswers(
      String exerciseId,
      List<String> answerIds,
      ) async {
    try {
      return await AnswerService.submitQcmAnswers(exerciseId, answerIds);
    } catch (e) {
      rethrow;
    }
  }

  // Fill in the blanks
  static Future<String> submitFillBlankAnswers(
      String exerciseId,
      List<List<String>> answers,
      ) async {
    try {
      return await AnswerService.submitFillBlankAnswers(exerciseId, answers);
    } catch (e) {
      rethrow;
    }
  }
}
