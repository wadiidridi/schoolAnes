import 'package:flutter/material.dart';

import '../../constants/theme.dart';

class helpPage extends StatelessWidget {
  const helpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false, // ✅ bonne position ici

        title: const Text('Plus'),

        actions: const [
          Icon(Icons.mail_outline),
          SizedBox(width: 16),
          Icon(Icons.notifications_none),
          SizedBox(width: 16),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Support',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildCardTile(Icons.help_outline, 'Help & Support'),
          const SizedBox(height: 24),
          const Text(
            'App',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildCardTile(Icons.settings_outlined, 'App Preferences'),
          const SizedBox(height: 8),
          _buildCardTile(Icons.info_outline, 'About'),
        ],
      ),
    );
  }

  Widget _buildCardTile(IconData icon, String title) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0.5,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: () {
          // TODO: handle navigation
        },
      ),
    );
  }
}
