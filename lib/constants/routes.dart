import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../views/auth/sign_in.dart';
import '../views/exercises/exercise.dart';

import 'package:flutter/material.dart';
import '../views/auth/signin_page.dart';


class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  // static const String support = '/support';
  // static const String exercises = '/exercises';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const SignInScreen());

      case home:
        return MaterialPageRoute(builder: (_) =>  SignInPage());
      // case exercises:
      //   final args = settings.arguments as Map<String, dynamic>;
      //   return MaterialPageRoute(
      //     builder: (_) => ExercisesListPage(
      //       subjectId: args['subjectId'],
      //       subjectName: args['subjectName'],
      //     ),
      //   );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route non définie: ${settings.name}')),
          ),
        );
    }
  }
}