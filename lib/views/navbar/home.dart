// views/home_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/notification_model.dart';
import '../../services/notification_service.dart';
import '../NotificationDetailDialog.dart';
import '../all_notifications_page.dart';
import 'app_bar_global.dart';
import 'app_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = 'Utilisateur';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadNotifications();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name');
    if (name != null) {
      setState(() {
        _userName = name;
      });
    }
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

  void _navigateToAllNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationsPage(),
      ),
    );
  }

  // Helper methods
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
        return Colors.red[800]!;
      case 'high':
        return Colors.orange[800]!;
      case 'medium':
        return Colors.blue[800]!;
      default:
        return Colors.grey[800]!;
    }
  }

  Color _getCardColorForPriority(String priority) {
    switch (priority) {
      case 'urgent':
        return Colors.red[50]!;
      case 'high':
        return Colors.orange[50]!;
      case 'medium':
        return Colors.blue[50]!;
      default:
        return Colors.grey[50]!;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final latestNotifications = _notifications.take(3).toList();
    final hasMoreNotifications = _notifications.length > 3;

    return Scaffold(
      key: _scaffoldKey,
      appBar: const GlobalAppBar(title: ''),
      // drawer: const AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    // IconButton(
                    //   icon: const Icon(Icons.menu, size: 28),
                    //   onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    // ),
                    const SizedBox(width: 12),
                    Text(
                      'Accueil',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // User greeting
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bonjour!',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _userName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Notifications section
                Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '📣 Dernières notifications',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (hasMoreNotifications)
                              TextButton(
                                onPressed: _navigateToAllNotifications,
                                child: const Text('Voir plus'),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        if (_isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (_errorMessage != null)
                          Center(
                            child: Column(
                              children: [
                                Text(_errorMessage!),
                                const SizedBox(height: 10),
                                TextButton(
                                  onPressed: _loadNotifications,
                                  child: const Text('Réessayer'),
                                ),
                              ],
                            ),
                          )
                        else if (latestNotifications.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 24.0),
                                child: Text(
                                  'Aucune notification disponible',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )
                          else
                            Column(
                              children: [
                                ...latestNotifications.map((notif) =>
                                    _buildNotificationCard(notif)
                                ),
                                if (hasMoreNotifications)
                                  Center(
                                    child: TextButton(
                                      onPressed: _navigateToAllNotifications,
                                      child: const Text('Voir toutes les notifications'),
                                    ),
                                  ),
                              ],
                            ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notif) {
    return Card(
      color: _getCardColorForPriority(notif.priority),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: _getColorForPriority(notif.priority).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => NotificationDetailDialog(notification: notif),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getCardColorForPriority(notif.priority),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIconForType(notif.type),
                  color: _getColorForPriority(notif.priority),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notif.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: _getColorForPriority(notif.priority),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notif.content,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (notif.publishDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _formatDate(notif.publishDate!),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}