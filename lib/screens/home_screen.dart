import 'package:flutter/material.dart';
import 'package:aidify/services/supabase_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
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
        child: Column(
          children: [
            const Text(
              'Quick Access to Features',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildFeatureCard(
                  context,
                  'Color Detection',
                  Icons.color_lens,
                  'Identify colors in real-time',
                  () => Navigator.pushNamed(context, '/color-detection'),
                ),
                _buildFeatureCard(
                  context,
                  'OCR',
                  Icons.text_fields,
                  'Extract text from images',
                  () => Navigator.pushNamed(context, '/ocr'),
                ),
                _buildFeatureCard(
                  context,
                  'Translation',
                  Icons.translate,
                  'Translate text in real-time',
                  () => Navigator.pushNamed(context, '/translation'),
                ),
                _buildFeatureCard(
                  context,
                  'Sign Language Recognition',
                  Icons.handyman,
                  'Recognize sign language gestures',
                  () => Navigator.pushNamed(context, '/sign-language'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Recent Activities',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Placeholder for recent activities
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Example count
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Activity ${index + 1}'),
                    subtitle: Text('Details about activity ${index + 1}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement voice assistant functionality
              },
              child: const Text('🎙 Voice Assistant'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Navigate to accessibility settings
                Navigator.pushNamed(context, '/settings');
              },
              child: const Text('🏷 Personalized Accessibility Settings'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Implement multi-user profiles functionality
              },
              child: const Text('📂 Multi-User Profiles'),
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
