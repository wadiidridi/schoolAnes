import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/config.dart';
import '../models/AnswerResponse.dart';
import '../models/reponse.dart';
import 'TokenStorageService.dart';

class AnswerService {
  // Pour QCM
  static Future<AnswerResponse> submitQcmAnswers(
      String exerciseId,
      List<String> answerIds,
      ) async {
    final token = await TokenStorageService.getToken();

    if (token == null) {
      throw Exception('No authentication token found');
    }

    final uri = Uri.parse(ApiEndpoints.submitAnswers(exerciseId));
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = json.encode(AnswerSubmission(answers: answerIds).toJson());

    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final jsonBody = json.decode(response.body);
        return AnswerResponse.fromJson(jsonBody);
      } catch (e) {
        throw Exception('Erreur de parsing JSON : ${e.toString()}');
      }
    } else {
      try {
        final jsonBody = json.decode(response.body);
        final errorMessage = jsonBody['message'] ?? 'Erreur inconnue';
        throw Exception(errorMessage);
      } catch (_) {
        throw Exception(json.decode(response.body)['message'] ?? 'Erreur inattendue');
      }
    }
  }

  // Pour Fill in the blanks
  static Future<String> submitFillBlankAnswers(
      String exerciseId,
      List<List<String>> answers,
      ) async {
    final token = await TokenStorageService.getToken();

    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await http.post(
      Uri.parse(ApiEndpoints.submitAnswers(exerciseId)),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "answers": answers.map((blanks) => {"blanks": blanks}).toList(),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body)["message"];
    } else {
      try {
        final jsonBody = json.decode(response.body);
        final errorMessage = jsonBody['message'] ?? 'Erreur inconnue';
        throw Exception(errorMessage);
      } catch (_) {
        throw Exception('Erreur inattendue :  ${response.body}',);
      }
    }
  }
}
