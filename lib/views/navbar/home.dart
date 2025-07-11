import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = 'Utilisateur';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // ← Ajouté

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name');
    if (name != null) {
      setState(() {
        _userName = name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // ← Ajouté
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bouton pour ouvrir le Drawer (à gauche)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.person, size: 28),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
              ),

              const SizedBox(height: 8),

              // Titre "Accueil"
              Text(
                'Accueil',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),                textAlign: TextAlign.center,

              ),


              const SizedBox(height: 16),

              // Titre Bonjour
              Text(
                'Bonjour!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),

              // Nom utilisateur
              Text(
                _userName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 24),

              // Tu peux ajouter ici d'autres sections (messagerie, tâches, etc.)
            ],
          ),
        ),
      ),
    );
  }
}
