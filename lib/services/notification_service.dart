import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/config.dart';
import '../models/notification_model.dart';
import 'TokenStorageService.dart';

class NotificationService {
  static Future<List<NotificationModel>> getNotifications() async {
    final token = await TokenStorageService.getToken();

    final response = await http.get(
      Uri.parse(ApiEndpoints.notification),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData['success'] == true) {
        final List<dynamic> notifications = jsonData['notifications'];
        return notifications.map((e) => NotificationModel.fromJson(e)).toList();
      } else {
        throw Exception('Erreur de chargement des notifications');
      }
    } else {
      throw Exception('Erreur ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  static Future<void> downloadAttachment(String notificationId, String filename) async {
    final token = await TokenStorageService.getToken();
    final url = ApiEndpoints.downloadAttachment(notificationId, filename);
    final uri = Uri.parse(url);

    try {
      // Demander la permission de stockage
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        print("Permission de stockage refusée");
        return;
      }

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Obtenir le dossier de téléchargement
        final dir = await getExternalStorageDirectory();
        final downloadsPath = Directory('${dir!.path}/Download');
        if (!await downloadsPath.exists()) {
          await downloadsPath.create(recursive: true);
        }

        final file = File('${downloadsPath.path}/$filename');
        await file.writeAsBytes(response.bodyBytes);

        print("✅ Fichier téléchargé dans : ${file.path}");
      } else {
        print("❌ Erreur: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print("⚠️ Exception: $e");
    }
  }}