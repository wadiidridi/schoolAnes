import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/config.dart';
import '../models/AnswerResponse.dart';
import '../models/fillblank/FillBlankQuestion.dart';
import '../models/fillblank/fillblank.dart';
import 'TokenStorageService.dart';

class FillBlankService {
  static Future<List<FillBlankQuestion>> getQuestions(String exerciseId) async {
    final token = await TokenStorageService.getToken();
    if (token == null) throw Exception('No authentication token found');

    final response = await http.get(
      Uri.parse(ApiEndpoints.exerciseDetails(exerciseId)),
      headers: _buildHeaders(token),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return (jsonData['exercise']['fillBlankQuestions'] as List)
          .map((json) => FillBlankQuestion.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load questions. Status: ${response.statusCode}');
    }
  }

  static Future<AnswerResponse> submitAnswers(
      String exerciseId,
      List<List<String>> answers,
      ) async {
    final token = await TokenStorageService.getToken();
    if (token == null) throw Exception('No authentication token found');

    // ✅ Construction du bon format JSON attendu par le backend
    final requestBody = {
      'answers': answers.map((blanks) => {
        'blanks': blanks,
      }).toList()
    };

    // 🔍 Debug : affichage du JSON envoyé
    print('📤 JSON envoyé au backend :');
    print(jsonEncode(requestBody));

    final response = await http.post(
      Uri.parse(ApiEndpoints.submitAnswers(exerciseId)),
      headers: _buildHeaders(token),
      body: jsonEncode(requestBody),
    );

    // 🔍 Debug : affichage de la réponse
    print('📥 Status Code: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AnswerResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Submission failed. Status: ${response.statusCode}');
    }
  }

  static Map<String, String> _buildHeaders(String token) => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };
}
