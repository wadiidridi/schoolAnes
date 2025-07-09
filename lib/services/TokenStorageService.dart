import 'package:shared_preferences/shared_preferences.dart';

class TokenStorageService {
  static const _tokenKey = 'auth_token';
  static const _nameKey = 'name';

  // ✅ Sauvegarde du token et nom
  static Future<void> saveToken(String token, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_nameKey, name);
  }

  // ✅ Lire le token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // ✅ Lire le nom de l'utilisateur
  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }

  // ✅ Supprimer toutes les infos
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // await prefs.remove(_nameKey);
  }
}
