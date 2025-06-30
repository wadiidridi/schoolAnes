import '../services/AuthService.dart';
import '../services/TokenStorageService.dart';

class AuthController {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await AuthService.login(email, password);

    if (response['statusCode'] == 200 && response['data']['message'] == 'Login successful') {
      final token = response['data']['token'];
      await TokenStorageService.saveToken(token); // Sauvegarde du token

      return {
        'success': true,
        'message': 'Connexion réussie',
        'data': response['data'],
      };
    } else {
      return {
        'success': false,
        'message': response['data']['message'] ?? 'Erreur inconnue',
      };
    }
  }
}
