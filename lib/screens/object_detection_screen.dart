import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/object_detection_service.dart';

class ObjectDetectionScreen extends StatefulWidget {
  const ObjectDetectionScreen({super.key});

  @override
  State<ObjectDetectionScreen> createState() => _ObjectDetectionScreenState();
}

class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {
  final ObjectDetectionService _objectDetectionService = ObjectDetectionService();
  bool _isCameraInitialized = false;
  List<String> _detectedObjects = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await _objectDetectionService.initialize();
    if (mounted) {
      setState(() {
        _isCameraInitialized = _objectDetectionService.isInitialized;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Object Detection'),
      ),
      body: Column(
        children: [
          if (_isCameraInitialized && _objectDetectionService.cameraController != null)
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CameraPreview(_objectDetectionService.cameraController!),
                ),
              ),
            )
          else
            const Expanded(
              flex: 2,
              child: Center(
                child: Text('Initializing camera...'),
              ),
            ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detected Objects:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _detectedObjects.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.check_circle),
                          title: Text(_detectedObjects[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final objects = await _objectDetectionService.detectObjects();
          setState(() {
            _detectedObjects = objects;
          });
        },
        child: const Icon(Icons.camera),
      ),
    );
  }

  @override
  void dispose() {
    _objectDetectionService.dispose();
    super.dispose();
  }
} 