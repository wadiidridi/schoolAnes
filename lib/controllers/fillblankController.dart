// controllers/fill_blank_controller.dart
import 'package:untitled/models/fillblank/fillblank.dart';

import '../services/FillBlank.dart';

class FillBlankController {
  static Future<List<FillBlankQuestion>> getQuestions(String exerciseId) async {
    try {
      return await FillBlankService.getQuestions(exerciseId);
    } catch (e) {
      print('[FILL BLANK CONTROLLER] Erreur: $e');
      rethrow;
    }
  }


}