// models/answer_response.dart
class AnswerResponse {
  final String message;
  final int score;
  final int totalPoints;
  final int accuracy;
  final int remainingAttempts;

  AnswerResponse({
    required this.message,
    required this.score,
    required this.totalPoints,
    required this.accuracy,
    required this.remainingAttempts,
  });

  factory AnswerResponse.fromJson(Map<String, dynamic> json) {
    final progress = json['progress'] ?? {};
    return AnswerResponse(
      message: json['message'] ?? 'Exercise submitted successfully',
      score: progress['totalPointsEarned'] ?? 0,
      totalPoints: progress['maxPossiblePoints'] ?? 0,
      accuracy: progress['accuracyPercentage'] ?? 0,
      remainingAttempts: progress['attemptNumber'] != null
          ? (json['maxAttempts'] ?? 0) - progress['attemptNumber']
          : 0,
    );
  }
}