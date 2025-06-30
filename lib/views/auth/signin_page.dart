import 'package:flutter/material.dart';
import 'package:untitled/views/auth/sign_in.dart';
import '../subjects/subject_list_page.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
            );
          },
          child: const Text("Se connecter"),
        ),
      ),
    );
  }
}
