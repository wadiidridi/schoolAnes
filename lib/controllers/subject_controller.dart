import '../models/SubjectAndClassResponse.dart';
import '../models/subject.dart';
import '../services/subject_service.dart';
import '../services/TokenStorageService.dart';

class SubjectController {
  static Future<SubjectAndClassResponse> getSubjects() async {
    final response = await SubjectService.fetchSubjects();

    final classId = response.classData.id; // ou response.classData._id selon ton modèle

    if (classId != null && classId.isNotEmpty) {
      await TokenStorageService.saveClassId(classId);
      print('✅ classId sauvegardé depuis SubjectController : $classId');
    } else {
      print('⚠️ Aucun classId trouvé dans la réponse');
    }

    return response;
  }
}
