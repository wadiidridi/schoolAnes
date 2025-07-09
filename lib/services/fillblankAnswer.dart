import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/config.dart';
import '../models/AnswerResponse.dart';
import '../models/fillblank/fill_blank_submission.dart';
import 'TokenStorageService.dart';


class AnswerService {
  static Future<AnswerResponse> submitFillBlankAnswers(
      String exerciseId,
      List<List<String>> answers,
      ) async {
    final token = await TokenStorageService.getToken();

    if (token == null) {
      throw Exception('No authentication token found');
    }

    final submission = FillBlankSubmission(
      answers: answers.map((blankAnswers) => FillBlankAnswer(blanks: blankAnswers)).toList(),
    );

    final response = await http.post(
      Uri.parse(ApiEndpoints.submitAnswers(exerciseId)),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(submission.toJson()),
    );

    if (response.statusCode == 200) {
      return AnswerResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to submit answers: ${response.body}');
    }
  }
}