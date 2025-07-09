import 'package:flutter/material.dart';

import 'app_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Accueil'),
        backgroundColor: Theme.of(context).primaryColor,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre Bonjour
              Text(
                'Bonjour!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),

              // Sous-titre Good Student
              Text(
                'Good Student',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 24),

              // Section Messagerie Rapide



              // Section Tâches

            ],
          ),
        ),
      ),
    );
  }
}

// Widget pour les chips des enseignants
class _TeacherChip extends StatelessWidget {
  final String name;

  const _TeacherChip({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          name,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}

// Widget pour les éléments de tâche
class _TaskItem extends StatelessWidget {
  final String deadline;
  final String title;
  final String status;

  const _TaskItem({
    required this.deadline,
    required this.title,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Échéance : $deadline',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Statut : $status',
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Démarrer'),
          ),
        ),
      ],
    );
  }
}