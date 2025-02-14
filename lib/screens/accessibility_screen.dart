import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import '../services/settings_service.dart';
import '../services/accessibility_service.dart';
import '../services/object_detection_service.dart';
import '../services/supabase_service.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  final AccessibilityService _accessibilityService = AccessibilityService();
  final ObjectDetectionService _objectDetectionService = ObjectDetectionService();
  final TextEditingController _textController = TextEditingController();
  String _recognizedText = '';
  List<String> _detectedObjects = [];
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await _accessibilityService.initialize();
    await _objectDetectionService.initialize();
    if (mounted) {
      setState(() {
        _isCameraInitialized = _objectDetectionService.isInitialized;
      });
    }
  }

  Widget _buildObjectDetectionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Object Detection', 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 8),
            if (_isCameraInitialized && _objectDetectionService.cameraController != null)
              SizedBox(
                height: 200,
                child: CameraPreview(_objectDetectionService.cameraController!),
              )
            else
              const Center(
                child: Text('Camera initialization failed'),
              ),
            const SizedBox(height: 8),
            Text('Detected Objects: ${_detectedObjects.join(", ")}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsService>(
      builder: (context, settings, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Accessibility Features'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await SupabaseService.signOut();
                  if (mounted) {
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Settings Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SwitchListTile(
                          title: const Text('Dark Mode'),
                          value: settings.isDarkMode,
                          onChanged: (value) => settings.toggleDarkMode(),
                        ),
                        SwitchListTile(
                          title: const Text('Voice Commands'),
                          value: settings.isVoiceCommandEnabled,
                          onChanged: (value) => settings.toggleVoiceCommand(),
                        ),
                        ListTile(
                          title: const Text('Speech Rate'),
                          subtitle: Slider(
                            value: settings.speechRate,
                            min: 0.5,
                            max: 2.0,
                            onChanged: (value) => settings.setSpeechRate(value),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Text-to-Speech Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Text to Speech', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            hintText: 'Enter text to speak',
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => _accessibilityService.speak(_textController.text, settings.speechRate),
                          child: const Text('Speak'),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Speech-to-Text Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Speech to Text', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Recognized: $_recognizedText'),
                        ElevatedButton(
                          onPressed: () => _accessibilityService.startListening(
                            (text) => setState(() => _recognizedText = text),
                          ),
                          child: Text(_accessibilityService.isListening ? 'Stop Listening' : 'Start Listening'),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Object Detection Section
                _buildObjectDetectionSection(),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _objectDetectionService.dispose();
    super.dispose();
  }
} 