import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/config.dart';
import '../models/SubjectAndClassResponse.dart';
import 'TokenStorageService.dart';

class SubjectService {
  static Future<SubjectAndClassResponse> fetchSubjects() async {
    final token = await TokenStorageService.getToken();
    final url = Uri.parse(ApiEndpoints.subject); // Assure-toi que c’est bien l’endpoint correct

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return SubjectAndClassResponse.fromJson(jsonBody);
    } else {
      throw Exception('Erreur de chargement des matières et de la classe');
    }
  }
}
