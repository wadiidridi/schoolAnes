// services/question_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/config.dart';
import '../models/question.dart';
import '../models/questions.dart';
import 'TokenStorageService.dart';

class QuestionService {
  static Future<ExerciseWithQuestions> getQuestions(String exerciseId) async {
    final token = await TokenStorageService.getToken();

    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}/exercises/$exerciseId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return ExerciseWithQuestions.fromJson(jsonData['exercise']);
    } else {
      throw Exception('Failed to load questions. Status: ${response.statusCode}');
    }
  }
}