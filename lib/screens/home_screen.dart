import 'package:flutter/material.dart';
import 'package:aidify/services/supabase_service.dart';
import 'accessibility_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aidify Features'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await SupabaseService.signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildFeatureCard(
              context,
              'Text to Speech',
              Icons.record_voice_over,
              'Convert text to spoken words',
              () => Navigator.pushNamed(context, '/text-to-speech'),
            ),
            _buildFeatureCard(
              context,
              'Speech to Text',
              Icons.mic,
              'Convert speech to written text',
              () => Navigator.pushNamed(context, '/speech-to-text'),
            ),
            _buildFeatureCard(
              context,
              'Object Detection',
              Icons.camera_alt,
              'Identify objects using camera',
              () => Navigator.pushNamed(context, '/object-detection'),
            ),
            _buildFeatureCard(
              context,
              'Settings',
              Icons.settings,
              'Customize app settings',
              () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon,
      String description, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
