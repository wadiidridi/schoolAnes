import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/grade.dart';
import '../constants/config.dart';
import 'TokenStorageService.dart';

class GradeService {
  static Future<List<GradeData>> fetchGrades(
      String studentId, {
        String? subjectId,
        String? trimester,
        String? academicYear,
      }) async {
    final token = await TokenStorageService.getToken();

    // Construction de l’URL avec queryParams
    final queryParams = <String, String>{};
    if (subjectId != null) queryParams['subject'] = subjectId;
    if (trimester != null) queryParams['trimester'] = trimester;
    if (academicYear != null) queryParams['academicYear'] = academicYear;

    final uri = Uri.parse("${ApiEndpoints.baseUrl}/grades/student/$studentId")
        .replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final gradesJson = data['grades'] as List;
      return gradesJson.map((g) => GradeData.fromJson(g)).toList();
    } else {
      print("❌ [GradeService] ${response.statusCode}: ${response.body}");
      throw Exception('Erreur lors du chargement des notes');
    }
  }
}
