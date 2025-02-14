import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsService>(
        builder: (context, settings, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Appearance'),
                      subtitle: const Text('Customize app appearance'),
                      leading: const Icon(Icons.palette),
                    ),
                    SwitchListTile(
                      title: const Text('Dark Mode'),
                      subtitle: const Text('Enable dark theme'),
                      value: settings.isDarkMode,
                      onChanged: (value) => settings.toggleDarkMode(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Speech Settings'),
                      subtitle: const Text('Configure speech options'),
                      leading: const Icon(Icons.record_voice_over),
                    ),
                    ListTile(
                      title: const Text('Speech Rate'),
                      subtitle: Slider(
                        value: settings.speechRate,
                        min: 0.0,
                        max: 2.0,
                        divisions: 20,
                        label: settings.speechRate.toStringAsFixed(2),
                        onChanged: (value) => settings.setSpeechRate(value),
                      ),
                    ),
                    ListTile(
                      title: const Text('Speech Pitch'),
                      subtitle: Slider(
                        value: settings.speechPitch,
                        min: 0.5,
                        max: 2.0,
                        divisions: 15,
                        label: settings.speechPitch.toStringAsFixed(2),
                        onChanged: (value) => settings.setSpeechPitch(value),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('About'),
                      subtitle: const Text('App information'),
                      leading: const Icon(Icons.info),
                    ),
                    const ListTile(
                      title: Text('Version'),
                      subtitle: Text('1.0.0'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
