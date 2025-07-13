import 'package:flutter/material.dart';
import '../../controllers/grade_controller.dart';
import '../../models/grade.dart';
import '../../services/TokenStorageService.dart';

class GradesPage extends StatefulWidget {

  final String subjectId;
  final String subjectName;

  const GradesPage({
    super.key,
    required this.subjectId,
    required this.subjectName
  });

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  late Future<List<GradeData>> _futureGrades;

  @override
  void initState() {
    super.initState();
    _loadGrades();
  }

  Future<void> _loadGrades() async {
    final studentId = await TokenStorageService.getUserId();
    setState(() {
      _futureGrades = GradeController.getGrades(
        studentId: studentId ?? '',
        subjectId: widget.subjectId,
        // trimester: '2ème Trimestre',       // facultatif
        // academicYear: '2025',              // facultatif
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Notes')),
      body: FutureBuilder<List<GradeData>>(
        future: _futureGrades,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucune note trouvée"));
          } else {
            final grades = snapshot.data!;
            return ListView.separated(
              itemCount: grades.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final grade = grades[index];
                return ListTile(
                  title: Text('${grade.examName} (${grade.subjectName})'),
                  subtitle: Text(
                    'Note : ${grade.grade} / Coeff: ${grade.coefficient}\nAppréciation: ${grade.appreciation}',
                  ),
                  trailing: Text('${grade.examType}'),
                  isThreeLine: true,
                );
              },
            );
          }
        },
      ),
    );
  }
}
