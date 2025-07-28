// widgets/app_bar_global.dart
import 'package:flutter/material.dart';

import '../../constants/theme.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? additionalActions;

  const GlobalAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.additionalActions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(title),
      backgroundColor: AppTheme.background,
      foregroundColor: Colors.black,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      )
          : null,
      actions: [
        const Icon(Icons.mail_outline),
        const SizedBox(width: 16),
        const Icon(Icons.notifications_none),
        const SizedBox(width: 16),
        ...?additionalActions,
      ],
    );
  }
}