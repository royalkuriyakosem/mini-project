import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // Ensure you have the camera package
import 'package:flutter_tts/flutter_tts.dart'; // For text-to-speech functionality

class ColorDetectionScreen extends StatefulWidget {
  const ColorDetectionScreen({super.key});

  @override
  _ColorDetectionScreenState createState() => _ColorDetectionScreenState();
}

class _ColorDetectionScreenState extends State<ColorDetectionScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final FlutterTts _flutterTts = FlutterTts();
  bool _isColorBlindMode = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
    setState(() {}); // Update the state after initialization
  }

  Future<void> _speakColor(String color) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak("Detected color is $color");
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
        title: const Text('Color Detection'),
        actions: [
          IconButton(
            icon: Icon(
                _isColorBlindMode ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _isColorBlindMode = !_isColorBlindMode;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_controller),
                if (_isColorBlindMode) _buildColorBlindOverlay(),
                _buildControls(),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildColorBlindOverlay() {
    return Container(
      color:
          Colors.black.withOpacity(0.5), // Example overlay for color blind mode
      child: const Center(
        child: Text(
          'Color Blind Mode Activated',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              // Implement image upload functionality
            },
            child: const Text('Upload Image'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement color detection logic
              String detectedColor = "Red"; // Example detected color
              _speakColor(detectedColor);
            },
            child: const Text('Detect Color'),
          ),
        ],
      ),
    );
  }
}
