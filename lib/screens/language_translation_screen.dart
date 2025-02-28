import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // For text-to-speech functionality
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:translator/translator.dart'; // For translation functionality

class LanguageTranslationScreen extends StatefulWidget {
  const LanguageTranslationScreen({super.key});

  @override
  _LanguageTranslationScreenState createState() =>
      _LanguageTranslationScreenState();
}

class _LanguageTranslationScreenState extends State<LanguageTranslationScreen> {
  final TextEditingController _textController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  final translator = GoogleTranslator();
  String translatedText = '';

  Future<void> _translateText() async {
    final translation = await translator.translate(_textController.text,
        to: 'es'); // Example: Translate to Spanish
    setState(() {
      translatedText = translation.text;
    });
  }

  Future<void> _speakText(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Implement OCR processing on the picked image
      // For example, use a library like Tesseract to extract text
      String extractedText = "Extracted text from image"; // Placeholder
      _textController.text =
          extractedText; // Set extracted text to the text field
      await _translateText(); // Automatically translate the extracted text
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Translation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Enter text to translate',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _translateText,
              child: const Text('Translate Text'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _speakText(translatedText);
              },
              child: const Text('Read Translated Text Aloud'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Upload Image for OCR'),
            ),
            const SizedBox(height: 20),
            Text(
              translatedText,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
