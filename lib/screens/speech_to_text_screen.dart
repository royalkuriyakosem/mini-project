import 'package:flutter/material.dart';
import '../services/accessibility_service.dart';

class SpeechToTextScreen extends StatefulWidget {
  const SpeechToTextScreen({super.key});

  @override
  State<SpeechToTextScreen> createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  final AccessibilityService _accessibilityService = AccessibilityService();
  String _recognizedText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech to Text'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _recognizedText.isEmpty ? 'Speak something...' : _recognizedText,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _accessibilityService.startListening(
                  (text) => setState(() => _recognizedText = text),
                );
              },
              icon: const Icon(Icons.mic),
              label: Text(
                _accessibilityService.isListening ? 'Stop' : 'Start Listening',
              ),
            ),
          ],
        ),
      ),
    );
  }
} 