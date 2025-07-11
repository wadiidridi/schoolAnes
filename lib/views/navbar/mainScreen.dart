import 'package:flutter/material.dart';
import 'package:untitled/views/navbar/settingPage.dart';

import '../../constants/theme.dart';
import '../../controllers/subject_controller.dart';
import '../../services/TokenStorageService.dart';
import '../exercises/exercise.dart';
import '../subjects/subject_list_page.dart';
import 'helpPage.dart';
import 'home.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  String? _classId;
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _loadClassIdAndBuildPages();
  }

  Future<void> _loadClassIdAndBuildPages() async {
    try {
      // 🔄 On récupère les sujets, et ça sauvegarde le classId automatiquement
      await SubjectController.getSubjects();

      // 🧠 Ensuite, on récupère le classId depuis SharedPreferences
      String? classId = await TokenStorageService.getClassId();
      print('📥 classId récupéré dans MainScreen : $classId');

      if (classId == null || classId.isEmpty) {
        print('❌ Aucun classId disponible.');
        return;
      }

      setState(() {
        _classId = classId;
        _pages = [
          const HomePage(),
          const SubjectListPage(),
          TeacherListPage(classId: classId),
          const helpPage(),
        ];
      });
    } catch (e) {
      print('⚠️ Erreur dans _loadClassIdAndBuildPages : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Affiche un loader tant que classId n’est pas encore récupéré
    if (_pages.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Teachers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'AI Tutor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
