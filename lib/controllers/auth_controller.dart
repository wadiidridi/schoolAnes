import '../services/AuthService.dart';
import '../services/TokenStorageService.dart';

class AuthController {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await AuthService.login(email, password);

    if (response['statusCode'] == 200 && response['data']['message'] == 'Login successful') {
      final token = response['data']['token'];
      final user = response['data']['user'];

      await TokenStorageService.saveToken(token, user['name']);
      await TokenStorageService.saveUserId(user['id']); // ✅ On sauvegarde l'ID ici

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
