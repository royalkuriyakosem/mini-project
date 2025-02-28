import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // For text-to-speech functionality

class SignLanguageRecognitionScreen extends StatefulWidget {
  const SignLanguageRecognitionScreen({super.key});

  @override
  _SignLanguageRecognitionScreenState createState() =>
      _SignLanguageRecognitionScreenState();
}

class _SignLanguageRecognitionScreenState
    extends State<SignLanguageRecognitionScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  String recognizedText = 'Recognized Sign Language will appear here';

  // Placeholder for live sign-to-text conversion
  void _recognizeSignLanguage() {
    // Implement sign language recognition logic here
    setState(() {
      recognizedText = "Hello"; // Example recognized text
    });
  }

  Future<void> _speakText(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Language Recognition'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _recognizeSignLanguage,
              child: const Text('Start Recognizing Sign Language'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _speakText(recognizedText);
              },
              child: const Text('Convert to Speech'),
            ),
            const SizedBox(height: 20),
            Text(
              recognizedText,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            // Placeholder for training mode
            ElevatedButton(
              onPressed: () {
                // Navigate to training mode
              },
              child: const Text('Training Mode'),
            ),
          ],
        ),
      ),
    );
  }
}
