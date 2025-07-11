class TeacherResponse {
  final List<TeacherData> teachers;

  TeacherResponse({required this.teachers});

  factory TeacherResponse.fromJson(Map<String, dynamic> json) {
    return TeacherResponse(
      teachers: (json['teachers'] as List)
          .map((e) => TeacherData.fromJson(e))
          .toList(),
    );
  }
}

class TeacherData {
  final Teacher teacher;
  final List<SubjectBasic> subjects;

  TeacherData({required this.teacher, required this.subjects});

  factory TeacherData.fromJson(Map<String, dynamic> json) {
    return TeacherData(
      teacher: Teacher.fromJson(json['teacher']),
      subjects: (json['subjects'] as List)
          .map((e) => SubjectBasic.fromJson(e))
          .toList(),
    );
  }
}

class Teacher {
  final String id;
  final String email;
  final String name;

  Teacher({required this.id, required this.email, required this.name});

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['_id'],
      email: json['email'],
      name: json['name'],
    );
  }
}

class SubjectBasic {
  final String id;
  final String name;

  SubjectBasic({required this.id, required this.name});

  factory SubjectBasic.fromJson(Map<String, dynamic> json) {
    return SubjectBasic(
      id: json['_id'],
      name: json['name'],
    );
  }
}
