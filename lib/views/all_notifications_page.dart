import 'package:flutter/material.dart';
import '../../models/notification_model.dart';
import '../../services/notification_service.dart';
import '../constants/theme.dart';
import 'NotificationDetailDialog.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final notifications = await NotificationService.getNotifications();
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur de chargement des notifications';
        _isLoading = false;
      });
      debugPrint('Erreur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text(
          'Toutes les notifications',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : _notifications.isEmpty
          ? const Center(child: Text('Aucune notification disponible'))
          : ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notif = _notifications[index];
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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      notif.title,
                      style: TextStyle(
                        fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold,
                        color: _getColorForPriority(notif.priority),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (!notif.isRead)
                    const Icon(Icons.circle, color: Colors.red, size: 10),
                ],
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
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                ],
              ),
                onTap: () async {
                  if (!notif.isRead) {
                    try {
                      await NotificationService.markAsRead(notif.id);

                      setState(() {
                        _notifications[index] = NotificationModel(
                          id: notif.id,
                          title: notif.title,
                          content: notif.content,
                          type: notif.type,
                          priority: notif.priority,
                          publishDate: notif.publishDate,
                          attachments: notif.attachments,
                          isRead: true, // ✅ maintenant c’est lu
                        );
                      });
                    } catch (e) {
                      debugPrint('❌ Erreur lors du marquage comme lu : $e');
                      // optionnel : afficher un snackbar
                    }
                  }

                  // ✅ Toujours afficher le détail, même si déjà lu
                  showDialog(
                    context: context,
                    builder: (context) => NotificationDetailDialog(notification: _notifications[index]),
                  );
                }

          ));
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
