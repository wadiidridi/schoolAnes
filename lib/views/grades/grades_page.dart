import 'package:flutter/material.dart';
import '../../controllers/grade_controller.dart';
import '../../models/grade.dart';
import '../../services/TokenStorageService.dart';
import '../navbar/app_bar_global.dart';

class GradesPage extends StatefulWidget {
  final String subjectId;
  final String subjectName;

  const GradesPage({
    super.key,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  late Future<List<GradeData>> _futureGrades;
  String? studentId;

  // 🔽 Filtres
  String? selectedTrimester;
  String? selectedYear;

  final trimesters = ['1er Trimestre', '2ème Trimestre', '3ème Trimestre'];
  final years = ['2024', '2025'];

  double? average;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    studentId = await TokenStorageService.getUserId();
    _loadGrades();
  }

  void _loadGrades() {
    setState(() {
      _futureGrades = GradeController.getGrades(
        studentId: studentId ?? '',
        subjectId: widget.subjectId,
        trimester: selectedTrimester,
        academicYear: selectedYear,
      );
    });
  }

  IconData _getExamIcon(String examType) {
    switch (examType.toLowerCase()) {
      case 'oral':
        return Icons.record_voice_over;
      case 'controle':
        return Icons.edit_note;
      case 'examen':
        return Icons.school;
      default:
        return Icons.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Notes : ${widget.subjectName}')),
      appBar: GlobalAppBar(title: 'Notes : ${widget.subjectName}',
        showBackButton: true, // Active la flèche de retour
      ),

      body: Column(
        children: [
          // 🔽 Filtres
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: selectedTrimester,
                  hint: const Text("Trimestre"),
                  onChanged: (value) {
                    setState(() => selectedTrimester = value);
                    _loadGrades();
                  },
                  items: trimesters.map((t) => DropdownMenuItem(
                    value: t,
                    child: Text(t),
                  )).toList(),
                ),
                const SizedBox(width: 20),
                DropdownButton<String>(
                  value: selectedYear,
                  hint: const Text("Année"),
                  onChanged: (value) {
                    setState(() => selectedYear = value);
                    _loadGrades();
                  },
                  items: years.map((y) => DropdownMenuItem(
                    value: y,
                    child: Text(y),
                  )).toList(),
                ),
              ],
            ),
          ),

          // 🔢 FutureBuilder
          Expanded(
            child: FutureBuilder<List<GradeData>>(
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

                  // 🔢 Calcul de moyenne
                  final sum = grades.fold(0.0, (a, b) => a + b.grade);
                  average = (sum / grades.length);

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "📊 Moyenne : ${average!.toStringAsFixed(2)} / 20",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: grades.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final grade = grades[index];
                            return ListTile(
                              leading: Icon(_getExamIcon(grade.examType), color: Colors.blue),
                              title: Text('${grade.examName} (${grade.examType})'),
                              subtitle: Text(
                                'Note : ${grade.grade} / Coeff: ${grade.coefficient}\nAppréciation: ${grade.appreciation}',
                              ),
                              isThreeLine: true,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
