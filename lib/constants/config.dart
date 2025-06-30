// config.dart
class ApiEndpoints {
  static const String baseUrl = "https://47h2n5xh-5000.euw.devtunnels.ms/api";

  // Auth endpoints
  static const String signIn = "$baseUrl/users/login";
  static const String subject = "$baseUrl/classes/student/my-class";

  // Exercise endpoints
  static String exercisesBySubject(String subjectId) =>
      "$baseUrl/exercises/subject/$subjectId";

  static String exerciseDetails(String exerciseId) =>
      "$baseUrl/exercises/$exerciseId";
}