// views/settings/settings_page.dart
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Page Paramètres',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
