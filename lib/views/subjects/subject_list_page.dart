import 'package:flutter/material.dart';
import '../../controllers/subject_controller.dart';
import '../../constants/theme.dart';
import '../../models/SubjectAndClassResponse.dart';
import '../../models/subject.dart';
import '../exercises/exercise.dart';

class SubjectListPage extends StatefulWidget {
  const SubjectListPage({super.key});

  @override
  State<SubjectListPage> createState() => _SubjectListPageState();
}

class _SubjectListPageState extends State<SubjectListPage> {
  late Future<SubjectAndClassResponse> _futureResponse;

  @override
  void initState() {
    super.initState();
    _futureResponse = SubjectController.getSubjects()
      ..then((response) {
        print('✅ ID Classe : ${response.classData.id}');
        for (var subject in response.subjects) {
          print('📚 Matière : ${subject.name} (ID: ${subject.id})');
        }
      });
  }

  IconData _getSubjectIcon(String subjectName) {
    switch (subjectName.toLowerCase()) {
      case 'math':
      case 'mathematics':
      case 'maths':
        return Icons.calculate;
      case 'science':
        return Icons.science;
      case 'history':
        return Icons.history;
      case 'english':
      case 'français':
      case 'french':
        return Icons.menu_book;
      default:
        return Icons.school;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: FutureBuilder<SubjectAndClassResponse>(
        future: _futureResponse,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.subjects.isEmpty) {
            return const Center(child: Text("Aucune matière trouvée"));
          } else {
            final response = snapshot.data!;
            final subjects = response.subjects;
            final classId = response.classData.id; // 👉 disponible ici

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      "Subjects",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...subjects.map((subject) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ExercisesListPage(
                              subjectId: subject.id,
                              subjectName: subject.name,
                              classId: classId, // 👉 si tu veux le transmettre
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          children: [
                            Icon(
                              _getSubjectIcon(subject.name),
                              color: AppTheme.primary,
                              size: 28,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              subject.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
