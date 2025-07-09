import 'package:flutter/material.dart';

class helpPage extends StatelessWidget {
  const helpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'help ',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
