// services/exercise_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/config.dart';
import '../models/exercise.dart';
import '../services/TokenStorageService.dart';


class ExerciseService {
  static Future<ExercisesResponse> getExercisesBySubject(String subjectId) async {
    final token = await TokenStorageService.getToken();

    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await http.get(
      Uri.parse(ApiEndpoints.exercisesBySubject(subjectId)), // Utilisation du endpoint configuré
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return ExercisesResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load exercises. Status code: ${response.statusCode}');
    }
  }
}