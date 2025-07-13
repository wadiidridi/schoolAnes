import 'package:flutter/material.dart';
import '../views/auth/sign_in.dart';
import '../views/navbar/mainScreen.dart'; // 👈 la bonne page d’accueil après login

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const SignInScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const MainScreen()); // ✅ ici

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route non définie: ${settings.name}')),
          ),
        );
    }
  }
}
