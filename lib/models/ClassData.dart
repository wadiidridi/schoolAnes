class ClassData {
  final String id;
  final String name;
  final String grade;
  final String academicYear;

  ClassData({
    required this.id,
    required this.name,
    required this.grade,
    required this.academicYear,
  });

  factory ClassData.fromJson(Map<String, dynamic> json) {
    return ClassData(
      id: json['_id'],
      name: json['name'],
      grade: json['grade'],
      academicYear: json['academicYear'],
    );
  }
}
