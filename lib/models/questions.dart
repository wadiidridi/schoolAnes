// models/question.dart
import 'exercise.dart';

class Question {
  final String id;
  final String questionText;
  final List<Option> options;
  final int points;

  Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.points,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'],
      questionText: json['questionText'],
      options: List<Option>.from(json['options'].map((x) => Option.fromJson(x))),
      points: json['points'],
    );
  }
}

class Option {
  final String id;
  final String text;
  final bool isCorrect;

  Option({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['_id'],
      text: json['text'],
      isCorrect: json['isCorrect'],
    );
  }
}

class ExerciseWithQuestions {
  final String id;
  final String title;
  final String type;
  final List<Question> questions;
  final Metadata metadata;

  ExerciseWithQuestions({
    required this.id,
    required this.title,
    required this.type,
    required this.questions,
    required this.metadata,
  });

  factory ExerciseWithQuestions.fromJson(Map<String, dynamic> json) {
    return ExerciseWithQuestions(
      id: json['_id'],
      title: json['title'],
      type: json['type'],
      questions: List<Question>.from(
          json['qcmQuestions'].map((x) => Question.fromJson(x))),
      metadata: Metadata.fromJson(json['metadata']),
    );
  }
}