import '../models/fillblank/FillBlankQuestion.dart';
import '../services/fillblank_question_service.dart';
import '../services/reponseService.dart'; // contient AnswerService

class FillBlankController {
  static Future<List<FillBlankQuestion>> getQuestions(String exerciseId) async {
    return await FillBlankQuestionService.getQuestions(exerciseId);
  }

  static Future<String> submitAnswers(
      String exerciseId, List<List<String>> answers) async {
    return await AnswerService.submitFillBlankAnswers(exerciseId, answers);
  }
}
