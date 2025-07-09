class FillBlankSubmission {
  final List<FillBlankAnswer> answers;

  FillBlankSubmission({required this.answers});

  Map<String, dynamic> toJson() => {
    'answers': answers.map((answer) => answer.toJson()).toList(),
  };
}

class FillBlankAnswer {
  final List<String> blanks;

  FillBlankAnswer({required this.blanks});

  Map<String, dynamic> toJson() => {
    'blanks': blanks,
  };
}