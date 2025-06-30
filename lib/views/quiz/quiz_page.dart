// import 'package:flutter/material.dart';
// import '../../data/mock_data.dart';
// import '../../models/question.dart';
// import 'result_page.dart';
//
// class QuizPage extends StatefulWidget {
//   final String subjectId;
//   const QuizPage({super.key, required this.subjectId});
//
//   @override
//   State<QuizPage> createState() => _QuizPageState();
// }
//
// class _QuizPageState extends State<QuizPage> {
//   int currentIndex = 0;
//   int score = 0;
//   int? selectedIndex;
//   bool answered = false;
//
//   void nextQuestion(int selected) {
//     final questions = mockQuestions[widget.subjectId]!;
//     final correct = questions[currentIndex].correctIndex;
//
//     setState(() {
//       selectedIndex = selected;
//       answered = true;
//       if (selected == correct) {
//         score++;
//       }
//     });
//
//     // Attendre 1 seconde avant de passer à la question suivante
//     Future.delayed(const Duration(seconds: 1), () {
//       if (currentIndex < questions.length - 1) {
//         setState(() {
//           currentIndex++;
//           selectedIndex = null;
//           answered = false;
//         });
//       } else {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => ResultPage(score: score, total: questions.length),
//           ),
//         );
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final questions = mockQuestions[widget.subjectId]!;
//     final question = questions[currentIndex];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Question"),
//         backgroundColor: const Color(0xFF626F47),
//       ),
//       backgroundColor: const Color(0xFFF6EDD5),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               question.questionText,
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 24),
//             ...List.generate(question.options.length, (i) {
//               final isCorrect = i == question.correctIndex;
//               final isSelected = i == selectedIndex;
//
//               return GestureDetector(
//                 onTap: () {
//                   if (!answered) nextQuestion(i);
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//                   decoration: BoxDecoration(
//                     color: isSelected
//                         ? (isCorrect ? Colors.green[200] : Colors.red[200])
//                         : Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: const Color(0xFF626F47)),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         question.options[i],
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: isSelected ? Colors.black : const Color(0xFF626F47),
//                         ),
//                       ),
//                       if (answered && isCorrect)
//                         const Icon(Icons.arrow_forward, color: Colors.green),
//                       if (answered && isSelected && !isCorrect)
//                         const Icon(Icons.close, color: Colors.red),
//                     ],
//                   ),
//                 ),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }
