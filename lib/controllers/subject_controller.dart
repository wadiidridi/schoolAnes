import '../models/subject.dart';
import '../services/subject_service.dart';

class SubjectController {
  static Future<List<Subject>> getSubjects() async {
    return await SubjectService.fetchSubjects();
  }
}
