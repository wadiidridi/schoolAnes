// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../constants/config.dart';
// import '../models/fillblank/FillBlankQuestion.dart';
// import 'TokenStorageService.dart';
//
// class FillBlankQuestionService {
//   static Future<List<FillBlankQuestion>> getQuestions(String exerciseId) async {
//     final token = await TokenStorageService.getToken();
//
//     final response = await http.get(
//       Uri.parse(ApiEndpoints.exerciseDetails(exerciseId)),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final questions = data['exercise']['fillBlankQuestions'] as List;
//
//       return questions.map((json) => FillBlankQuestion.fromJson(json)).toList();
//     } else {
//       throw Exception('Erreur lors du chargement des questions : ${response.body}');
//     }
//   }
// }
