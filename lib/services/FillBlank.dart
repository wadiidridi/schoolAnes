// services/FillBlankService.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/config.dart';
import '../models/fillblank/fillblank.dart';
import 'TokenStorageService.dart';

class FillBlankService {
  static Future<List<FillBlankQuestion>> getQuestions(String exerciseId) async {
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
      final List<dynamic> questionsJson = jsonData['exercise']['fillBlankQuestions'];
      return questionsJson.map((json) => FillBlankQuestion.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load questions. Status: ${response.statusCode}');
    }
  }
}

