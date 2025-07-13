import '../models/grade.dart';
import '../services/grade_service.dart';

class GradeController {
  static Future<List<GradeData>> getGrades({
    required String studentId,
    String? subjectId,
    String? trimester,
    String? academicYear,
  }) async {
    return await GradeService.fetchGrades(
      studentId,
      subjectId: subjectId,
      trimester: trimester,
      academicYear: academicYear,
    );
  }
}

