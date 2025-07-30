import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
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
      throw Exception(
          'Erreur ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  static Future<void> downloadAttachment(String notificationId, String filename) async {
    final token = await TokenStorageService.getToken();
    final url = ApiEndpoints.downloadAttachment(notificationId, filename);
    final uri = Uri.parse(url);

    try {
      print("🔗 URL appelée : $url");

      // Détection de la version Android
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt ?? 0;

      // Demande de permission adaptée
      PermissionStatus status;
      if (sdkInt >= 33) {
        // Android 13+
        final images = await Permission.photos.request(); // images
        final videos = await Permission.videos.request();
        final audio = await Permission.audio.request();
        if (!images.isGranted && !videos.isGranted && !audio.isGranted) {
          print("❌ Permissions média refusées");
          return;
        }
      } else if (sdkInt >= 30) {
        // Android 11+
        status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          print("❌ Permission refusée (manageExternalStorage)");
          return;
        }
      } else {
        // Android <= 10
        status = await Permission.storage.request();
        if (!status.isGranted) {
          print("❌ Permission refusée (storage)");
          return;
        }
      }

      // Requête HTTP pour le fichier
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('📥 Status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final downloadsPath = Directory('/storage/emulated/0/Download');
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
  }
  static Future<void> markAsRead(String notificationId) async {
    final token = await TokenStorageService.getToken();
    final url = '${ApiEndpoints.notification}/$notificationId/read';

    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur lors du marquage comme lu');
    }
  }

}