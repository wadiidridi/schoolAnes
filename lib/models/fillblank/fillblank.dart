class FillBlankQuestion {
  final String id;
  final String sentence;
  final List<Blank> blanks;
  final int points;

  FillBlankQuestion({
    required this.id,
    required this.sentence,
    required this.blanks,
    required this.points,
  });

  factory FillBlankQuestion.fromJson(Map<String, dynamic> json) {
    return FillBlankQuestion(
      id: json['_id'],
      sentence: json['sentence'],
      blanks: (json['blanks'] as List)
          .map((blank) => Blank.fromJson(blank))
          .toList(),
      points: json['points'],
    );
  }
}

class Blank {
  final int position;
  final String correctAnswer;
  final List<String> acceptableAnswers;

  Blank({
    required this.position,
    required this.correctAnswer,
    required this.acceptableAnswers,
  });

  factory Blank.fromJson(Map<String, dynamic> json) {
    return Blank(
      position: json['position'],
      correctAnswer: json['correctAnswer'],
      acceptableAnswers: List<String>.from(json['acceptableAnswers'] ?? []),
    );
  }
}