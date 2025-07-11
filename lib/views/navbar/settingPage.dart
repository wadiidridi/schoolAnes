import 'package:flutter/material.dart';
import '../../controllers/teacher_controller.dart';
import '../../models/teacher.dart';

class TeacherListPage extends StatefulWidget {
  final String classId;

  const TeacherListPage({super.key, required this.classId});

  @override
  State<TeacherListPage> createState() => _TeacherListPageState();
}

class _TeacherListPageState extends State<TeacherListPage> {
  late Future<List<TeacherData>> _futureTeachers;

  @override
  void initState() {
    super.initState();
    _futureTeachers = TeacherController.getTeachers(widget.classId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Liste des enseignants")),
      body: FutureBuilder<List<TeacherData>>(
        future: _futureTeachers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun enseignant trouvé"));
          } else {
            final teachers = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: teachers.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final teacher = teachers[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          teacher.teacher.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(teacher.teacher.email),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: teacher.subjects.map((subject) {
                            return Chip(
                              label: Text(subject.name),
                              backgroundColor: Colors.blue.shade50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
