// views/main_screen.dart
import 'package:flutter/material.dart';
import 'package:untitled/views/navbar/settingPage.dart';

import '../../constants/theme.dart';
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
  late int _currentIndex ;

  final List<Widget> _pages = [
    const HomePage(),          // Home
    const SubjectListPage(),   // Marks (remplacé par SubjectList)
    const SettingsPage(),      // AI Tutor (remplacé par Settings)
    const helpPage(),          // More (remplacé par Help)
  ];
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }
  @override
  Widget build(BuildContext context) {
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
        type: BottomNavigationBarType.fixed, // Pour plus de 3 éléments
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment), // Icône pour "Tasks"
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grade), // Icône pour "Marks"
            label: 'Marks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school), // Icône pour "AI Tutor"
            label: 'AI Tutor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz), // Icône pour "More"
            label: 'More',
          ),
        ],
      ),
    );
  }
}