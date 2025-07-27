import 'package:flutter/material.dart';
import '../../controllers/teacher_controller.dart';
import '../../models/teacher.dart';
import '../../constants/theme.dart';

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Liste des professeurs"),
        // backgroundColor: AppTheme.primary,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<List<TeacherData>>(
        future: _futureTeachers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun enseignant trouvé"));
          }

          final teachers = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: teachers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final teacher = teachers[index];

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ Avatar placeholder
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppTheme.secondary,
                        backgroundImage: const AssetImage("assets/images/teacher_avatar.png"), // Remplace si tu veux dynamique
                      ),
                      const SizedBox(width: 16),

                      // ✅ Infos prof
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              teacher.teacher.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              teacher.teacher.email,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 12),

                            // ✅ Matières enseignées
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: teacher.subjects.map((subject) {
                                return Chip(
                                  label: Text(subject.name),
                                  backgroundColor: AppTheme.accent.withOpacity(0.2),
                                  labelStyle: const TextStyle(fontWeight: FontWeight.w500),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
