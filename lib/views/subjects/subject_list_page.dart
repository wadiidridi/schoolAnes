import 'package:flutter/material.dart';
import '../../controllers/subject_controller.dart';
import '../../constants/theme.dart';
import '../../models/subject.dart';
import '../exercises/exercise.dart';


class SubjectListPage extends StatefulWidget {
  const SubjectListPage({super.key});

  @override
  State<SubjectListPage> createState() => _SubjectListPageState();
}

class _SubjectListPageState extends State<SubjectListPage> {
  late Future<List<Subject>> _futureSubjects;

  @override
  void initState() {
    super.initState();
    _futureSubjects = SubjectController.getSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("Choisir une matière"),
        backgroundColor: AppTheme.primary,
      ),
      body: FutureBuilder<List<Subject>>(
        future: _futureSubjects,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucune matière trouvée"));
          } else {
            final subjects = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: subjects.map((subject) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accent,
                        foregroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
// Update the onPressed in your SubjectListPage
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ExercisesListPage(
                              subjectId: subject.id,
                              subjectName: subject.name,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        subject.name,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
