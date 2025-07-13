class GradeData {
  final String id;
  final String examName;
  final String examType;
  final double grade;
  final int coefficient;
  final String examDate;
  final String subjectName;
  final String teacherName;
  final String trimester;
  final String appreciation;
  final String comments;

  GradeData({
    required this.id,
    required this.examName,
    required this.examType,
    required this.grade,
    required this.coefficient,
    required this.examDate,
    required this.subjectName,
    required this.teacherName,
    required this.trimester,
    required this.appreciation,
    required this.comments,
  });

  factory GradeData.fromJson(Map<String, dynamic> json) {
    return GradeData(
      id: json['_id'],
      examName: json['examName'],
      examType: json['examType'],
      grade: (json['grade'] as num).toDouble(),
      coefficient: json['coefficient'],
      examDate: json['examDate'],
      subjectName: json['subject']['name'],
      teacherName: json['teacher']['name'],
      trimester: json['trimester'],
      appreciation: json['appreciation'],
      comments: json['comments'],
    );
  }
}
