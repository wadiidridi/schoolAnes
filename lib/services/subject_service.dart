import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/config.dart';
import '../models/subject.dart';
import 'TokenStorageService.dart';


class SubjectService {
  static Future<List<Subject>> fetchSubjects() async {
    final token = await TokenStorageService.getToken();
    final url = Uri.parse(ApiEndpoints.subject);

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final List<dynamic> subjectsJson = jsonBody['subjects'];
      return subjectsJson.map((s) => Subject.fromJson(s)).toList();
    } else {
      throw Exception('Erreur de chargement des matières');
    }
  }
}
