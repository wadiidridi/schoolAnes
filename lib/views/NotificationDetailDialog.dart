// widgets/notification_detail_dialog.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationDetailDialog extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailDialog({super.key, required this.notification});
  Future<void> _openAttachment(BuildContext context, String url) async {
    final filename = url.split('/').last;
    final notificationId = notification.id;

    await NotificationService.downloadAttachment(notificationId, filename);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Téléchargement de $filename lancé.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          maxWidth: 600,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // En-tête avec titre et bouton de fermeture
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Type et priorité
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    Chip(
                      label: Text(notification.type.toUpperCase()),
                      backgroundColor: Colors.grey[200],
                    ),
                    Chip(
                      label: Text(
                        _formatPriority(notification.priority),
                        style: TextStyle(
                          color: _getPriorityTextColor(notification.priority),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: _getPriorityColor(notification.priority),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Contenu avec défilement indépendant
                Container(
                  constraints: const BoxConstraints(
                    minHeight: 50,
                    maxHeight: 300,
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      notification.content,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Date de publication
                if (notification.publishDate != null)
                  Text(
                    'Publié le: ${_formatDate(notification.publishDate!)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                const SizedBox(height: 20),

                // Pièces jointes
                if (notification.attachments != null && notification.attachments!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pièces jointes:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...notification.attachments!.map((attachment) =>
                          Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              leading: _getAttachmentIcon(attachment['mimetype']),
                              title: Text(
                                attachment['originalName'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              subtitle: Text('${_formatFileSize(attachment['size'])}'),
                              onTap: () => _openAttachment(context, attachment['url']),
                            ),
                          ),
                      ).toList(),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getAttachmentIcon(String mimeType) {
    IconData icon;
    Color color;

    if (mimeType.contains('image')) {
      icon = Icons.image;
      color = Colors.amber;
    } else if (mimeType.contains('pdf')) {
      icon = Icons.picture_as_pdf;
      color = Colors.red;
    } else if (mimeType.contains('word')) {
      icon = Icons.description;
      color = Colors.blue;
    } else {
      icon = Icons.insert_drive_file;
      color = Colors.grey;
    }
    return Icon(icon, color: color);
  }

  // Future<void> _openAttachment(BuildContext context, String url) async {
  //   final uri = Uri.parse(url);
  //   try {
  //     if (await canLaunchUrl(uri)) {
  //       await launchUrl(uri);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Impossible d\'ouvrir le fichier')),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Erreur: ${e.toString()}')),
  //     );
  //   }
  // }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / 1048576).toStringAsFixed(1)} MB';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatPriority(String priority) {
    switch (priority) {
      case 'urgent':
        return 'URGENT';
      case 'high':
        return 'IMPORTANT';
      case 'medium':
        return 'NORMAL';
      default:
        return priority.toUpperCase();
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'urgent':
        return Colors.red[100]!;
      case 'high':
        return Colors.orange[100]!;
      case 'medium':
        return Colors.blue[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  Color _getPriorityTextColor(String priority) {
    switch (priority) {
      case 'urgent':
        return Colors.red[800]!;
      case 'high':
        return Colors.orange[800]!;
      case 'medium':
        return Colors.blue[800]!;
      default:
        return Colors.grey[800]!;
    }
  }
}