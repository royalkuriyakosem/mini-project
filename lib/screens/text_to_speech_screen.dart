import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechScreen extends StatefulWidget {
  const TextToSpeechScreen({super.key});

  @override
  _TextToSpeechScreenState createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  final TextEditingController _textController = TextEditingController();

  Future<void> _speakText() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(_textController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text to Speech'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLines: 5, // Enlarge the text area
              decoration: const InputDecoration(
                labelText: 'Enter text to convert to speech',
                labelStyle: TextStyle(fontSize: 20), // Enlarge the label text
                border: OutlineInputBorder(), // Add border to the text field
              ),
              style: const TextStyle(fontSize: 18), // Enlarge the input text
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _speakText,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12), // Enlarge the button
              ),
              child: const Text(
                'Convert to Speech',
                style: TextStyle(fontSize: 18), // Enlarge the button text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
