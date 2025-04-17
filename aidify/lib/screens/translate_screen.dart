import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({super.key});

  @override
  _TranslateScreenState createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _translatedTextController =
      TextEditingController();
  final GoogleTranslator _translator = GoogleTranslator();
  final FlutterTts _flutterTts = FlutterTts();
  String _selectedLanguage = 'es'; // Default to Spanish

  final Map<String, String> _languages = {
    'Spanish': 'es',
    'French': 'fr',
    'German': 'de',
    'Chinese': 'zh',
    'Japanese': 'ja',
    'Korean': 'ko',
    'Hindi': 'hi',
    'Arabic': 'ar',
  };

  Future<void> _translateText() async {
    if (_textController.text.isEmpty) return;

    final translation = await _translator.translate(_textController.text,
        to: _selectedLanguage);
    setState(() {
      _translatedTextController.text = translation.text;
    });
  }

  Future<void> _speakText() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(_translatedTextController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Translate'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter text to translate',
              ),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                });
              },
              items: _languages.entries.map<DropdownMenuItem<String>>((entry) {
                return DropdownMenuItem<String>(
                  value: entry.value,
                  child: Text(entry.key),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _translateText,
              child: Text('Translate'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _translatedTextController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Translated text',
              ),
            ),
            SizedBox(height: 20),
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
