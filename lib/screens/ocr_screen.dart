import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // Ensure you have the camera package
import 'package:flutter_tts/flutter_tts.dart'; // For text-to-speech functionality
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:translator/translator.dart'; // For translation functionality

class OCRScreen extends StatefulWidget {
  const OCRScreen({super.key});

  @override
  _OCRScreenState createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final FlutterTts _flutterTts = FlutterTts();
  String extractedText = '';
  final translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
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
      setState(() {
        extractedText = "Extracted text from image"; // Placeholder
      });
    }
  }

  Future<void> _translateText() async {
    final translation = await translator.translate(extractedText,
        to: 'es'); // Example: Translate to Spanish
    setState(() {
      extractedText = translation.text;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Reader (OCR)'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: CameraPreview(_controller),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text('Upload Image'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _speakText(extractedText);
                        },
                        child: const Text('Read Text Aloud'),
                      ),
                      ElevatedButton(
                        onPressed: _translateText,
                        child: const Text('Translate Text'),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        extractedText,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
