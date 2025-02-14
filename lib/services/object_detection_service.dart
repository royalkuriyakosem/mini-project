import 'package:camera/camera.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:flutter/services.dart';

class ObjectDetectionService {
  CameraController? cameraController;
  ObjectDetector? _objectDetector;
  bool isInitialized = false;

  Future<void> initialize() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await cameraController?.initialize();
    
    final options = ObjectDetectorOptions(
      mode: DetectionMode.stream,
      classifyObjects: true,
      multipleObjects: true,
    );
    _objectDetector = ObjectDetector(options: options);
    
    isInitialized = true;
  }

  Future<List<String>> detectObjects() async {
    if (!isInitialized || cameraController == null) return [];

    final image = await cameraController!.takePicture();
    final inputImage = InputImage.fromFilePath(image.path);
    
    final objects = await _objectDetector?.processImage(inputImage) ?? [];
    return objects.map((obj) => obj.labels.first.text).toList();
  }

  void dispose() {
    cameraController?.dispose();
    _objectDetector?.close();
  }
} 