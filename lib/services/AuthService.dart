import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/config.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiEndpoints.signIn}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);
    return {'statusCode': response.statusCode, 'data': data};
  }
}
