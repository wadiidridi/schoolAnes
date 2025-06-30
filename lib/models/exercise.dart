// models/exercise.dart
class Exercise {
  final String id;
  final String title;
  final String type;
  final String difficulty;
  final int totalPoints;
  final DateTime createdAt;
  final Metadata metadata;
  final StudentProgress? studentProgress;
  final String status;
  final int remainingAttempts;

  Exercise({
    required this.id,
    required this.title,
    required this.type,
    required this.difficulty,
    required this.totalPoints,
    required this.createdAt,
    required this.metadata,
    this.studentProgress,
    required this.status,
    required this.remainingAttempts,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['_id'],
      title: json['title'],
      type: json['type'],
      difficulty: json['difficulty'],
      totalPoints: json['totalPoints'],
      createdAt: DateTime.parse(json['createdAt']),
      metadata: Metadata.fromJson(json['metadata']),
      studentProgress: json['studentProgress'] != null
          ? StudentProgress.fromJson(json['studentProgress'])
          : null,
      status: json['status'],
      remainingAttempts: json['remainingAttempts'],
    );
  }
}

class Metadata {
  final String instructions;
  final int estimatedTime;
  final int maxAttempts;
  final bool showAnswersAfterCompletion;
  final bool shuffleQuestions;
  final bool shuffleOptions;

  Metadata({
    required this.instructions,
    required this.estimatedTime,
    required this.maxAttempts,
    required this.showAnswersAfterCompletion,
    required this.shuffleQuestions,
    required this.shuffleOptions,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      instructions: json['instructions'],
      estimatedTime: json['estimatedTime'],
      maxAttempts: json['maxAttempts'],
      showAnswersAfterCompletion: json['showAnswersAfterCompletion'],
      shuffleQuestions: json['shuffleQuestions'],
      shuffleOptions: json['shuffleOptions'],
    );
  }
}

class StudentProgress {
  final int attemptNumber;
  final int score;
  final int accuracy;
  final DateTime completedAt;
  final String status;

  StudentProgress({
    required this.attemptNumber,
    required this.score,
    required this.accuracy,
    required this.completedAt,
    required this.status,
  });

  factory StudentProgress.fromJson(Map<String, dynamic> json) {
    return StudentProgress(
      attemptNumber: json['attemptNumber'],
      score: json['score'],
      accuracy: json['accuracy'],
      completedAt: DateTime.parse(json['completedAt']),
      status: json['status'],
    );
  }
}

class ExercisesResponse {
  final List<Exercise> exercises;
  final Pagination pagination;

  ExercisesResponse({
    required this.exercises,
    required this.pagination,
  });

  factory ExercisesResponse.fromJson(Map<String, dynamic> json) {
    return ExercisesResponse(
      exercises: List<Exercise>.from(
          json['exercises'].map((x) => Exercise.fromJson(x))),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalExercises;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalExercises,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      totalExercises: json['totalExercises'],
    );
  }
}