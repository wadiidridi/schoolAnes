class FillBlankQuestion {
  final String sentence;
  final List<String> blanks; // uniquement les réponses, car on ne montre pas les réponses acceptables
  final int points;

  FillBlankQuestion({
    required this.sentence,
    required this.blanks,
    required this.points,
  });

  factory FillBlankQuestion.fromJson(Map<String, dynamic> json) {
    return FillBlankQuestion(
      sentence: json['sentence'],
      points: json['points'],
      blanks: List<String>.from(json['blanks'].map((b) => b['correctAnswer'])),
    );
  }
}
