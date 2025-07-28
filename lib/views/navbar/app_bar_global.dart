import 'package:flutter/material.dart';
import '../../constants/theme.dart';

import '../all_notifications_page.dart'; // <-- change si le chemin est différent

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
        IconButton(
          icon: const Icon(Icons.mail_outline),
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const MessagesPage()),
            // );
          },
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationsPage()),
            );
          },
        ),
        const SizedBox(width: 8),
        ...?additionalActions,
      ],
    );
  }
}
