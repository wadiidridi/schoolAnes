import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/config.dart';
import '../models/teacher.dart';
import 'TokenStorageService.dart';

class TeacherService {
  static Future<List<TeacherData>> fetchTeachers(String classId) async {
    final token = await TokenStorageService.getToken();
    final url = Uri.parse(ApiEndpoints.teacher(classId));

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('📦 [TeacherService] Response body: ${response.body}'); // ✅ Impression du body JSON

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final teacherResponse = TeacherResponse.fromJson(jsonBody);
      return teacherResponse.teachers;
    } else {
      print('❌ [TeacherService] Erreur ${response.statusCode} : ${response.body}');
      throw Exception('Erreur de chargement des enseignants');
    }
  }
}
