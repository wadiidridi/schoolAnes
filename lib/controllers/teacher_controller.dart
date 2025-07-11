import '../models/teacher.dart';
import '../services/teacher_service.dart';

class TeacherController {
  static Future<List<TeacherData>> getTeachers(String classId) async {
    return await TeacherService.fetchTeachers(classId);
  }
}
