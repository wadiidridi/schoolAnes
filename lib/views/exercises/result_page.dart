// views/exercises/result_page.dart
import 'package:flutter/material.dart';

import '../navbar/mainScreen.dart';
import '../subjects/subject_list_page.dart';

class QcmResultPage  extends StatelessWidget {
  final int score;
  final int total;
  final String message;
  final int accuracy;

  const QcmResultPage ({
    super.key,
    required this.score,
    required this.total,
    required this.message,
    required this.accuracy,
  });

  @override
  Widget build(BuildContext context) {
    double percent = score / total;

    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              "Task Results",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Accuracy: $accuracy%',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 140,
                  width: 140,
                  child: CircularProgressIndicator(
                    value: percent,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                  ),
                ),
                Text(
                  '$score/$total',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen(initialIndex: 1)),
                  );

                },                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Review Task', style: TextStyle(color: Colors.white), ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
