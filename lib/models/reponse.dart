// models/answer_submission.dart
class AnswerSubmission {
  final List<String> answers;

  AnswerSubmission({required this.answers});

  Map<String, dynamic> toJson() {
    return {
      'answers': answers,
    };
  }
}