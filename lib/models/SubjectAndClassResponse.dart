import 'package:untitled/models/subject.dart';

import 'ClassData.dart';

class SubjectAndClassResponse {
  final ClassData classData;
  final List<Subject> subjects;

  SubjectAndClassResponse({
    required this.classData,
    required this.subjects,
  });

  factory SubjectAndClassResponse.fromJson(Map<String, dynamic> json) {
    return SubjectAndClassResponse(
      classData: ClassData.fromJson(json['class']),
      subjects: (json['subjects'] as List)
          .map((s) => Subject.fromJson(s))
          .toList(),
    );
  }
}
