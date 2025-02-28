import 'package:flutter/material.dart';
import 'package:aidify/services/supabase_service.dart';
import 'translate_screen.dart'; // Add this import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _logout(BuildContext context) async {
    await SupabaseService.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildGridItem(context, Icons.home, 'Home', '/home'),
          _buildGridItem(
              context, Icons.text_fields, 'Text to Speech', '/text_to_speech'),
          _buildGridItem(
              context, Icons.mic, 'Speech to Text', '/speech_to_text'),
          _buildGridItem(context, Icons.document_scanner, 'Object Detection',
              '/object_detection'),
          _buildGridItem(context, Icons.translate, 'Translate',
              '/translate'), // Add this line
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.text_fields), label: 'Text to Speech'),
          BottomNavigationBarItem(
              icon: Icon(Icons.mic),
              label: 'Speech to Text'), // Change Payments to Speech to Text
          BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner), label: 'Doc'),
        ],
        currentIndex: 1, // Set the current index to Text to Speech
        onTap: (index) {
          // Handle bottom navigation tap
        },
      ),
    );
  }

  Widget _buildGridItem(
      BuildContext context, IconData icon, String label, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
