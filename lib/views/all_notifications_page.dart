// views/notifications_page.dart
import 'package:flutter/material.dart';
import '../../models/notification_model.dart';

import '../constants/theme.dart';
import 'NotificationDetailDialog.dart'; // <-- Assure-toi que le chemin est correct

class NotificationsPage extends StatelessWidget {
  final List<NotificationModel> notifications;

  const NotificationsPage({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Toutes les notifications', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: notifications.isEmpty
          ? const Center(child: Text('Aucune notification disponible'))
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Card(
            color: _getCardColorForPriority(notif.priority),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: AppTheme.secondary,
                child: Icon(
                  _getIconForType(notif.type),
                  color: Colors.white,
                ),
              ),
              title: Text(
                notif.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getColorForPriority(notif.priority),
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    notif.content,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  if (notif.publishDate != null)
                    Text(
                      _formatDate(notif.publishDate!),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      NotificationDetailDialog(notification: notif),
                );
              },
            ),
          );
        },
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'announcement':
        return Icons.campaign;
      case 'exam':
        return Icons.assignment;
      case 'reminder':
        return Icons.notifications;
      default:
        return Icons.info;
    }
  }

  Color _getColorForPriority(String priority) {
    switch (priority) {
      case 'urgent':
        return Colors.red;
      case 'high':
        return Colors.deepOrange;
      case 'medium':
        return AppTheme.primary;
      default:
        return Colors.grey;
    }
  }

  Color _getCardColorForPriority(String priority) {
    switch (priority) {
      case 'urgent':
        return Colors.red[50]!;
      case 'high':
        return Colors.orange[50]!;
      case 'medium':
        return AppTheme.background;
      default:
        return Colors.white;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
