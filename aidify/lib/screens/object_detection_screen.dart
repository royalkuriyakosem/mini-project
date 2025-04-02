import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LiveDetectionScreen extends StatefulWidget {
  @override
  _LiveDetectionScreenState createState() => _LiveDetectionScreenState();
}

class _LiveDetectionScreenState extends State<LiveDetectionScreen> {
  CameraController? _cameraController;
  bool _isDetecting = false;
  List<dynamic>? _detections;
  final FlutterTts _flutterTts = FlutterTts();
  String _lastSpokenObject = '';
  DateTime _lastSpeechTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setVolume(1.0);
  }

  Future<void> _initializeCamera() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  _cameraController = CameraController(
    cameras[0], // Use the first available camera (usually back)
    ResolutionPreset.medium,
    enableAudio: false,
  );

  await _cameraController!.initialize();
  if (!mounted) return;

  // Lock the camera preview to portrait mode
 await _cameraController!.lockCaptureOrientation();


  setState(() {});
  _startLiveDetection();
  }

  Future<void> _startLiveDetection() async {
    _isDetecting = true;
    while (_isDetecting) {
      await Future.delayed(Duration(milliseconds: 500)); // Capture every 500ms
      _captureAndDetect();
    }
  }

  Future<void> _captureAndDetect() async {
    if (!_cameraController!.value.isInitialized || !_isDetecting) return;

    final XFile image = await _cameraController!.takePicture();
    File imageFile = File(image.path);

    // Adjust the image orientation based on the device's orientation
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = '${tempDir.path}/temp.jpg';
    final File rotatedImage = await _rotateImage(imageFile, tempPath);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.0.102:8000/detect/'),
    );
    request.files.add(await http.MultipartFile.fromPath('file', rotatedImage.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);
      setState(() {
        _detections = jsonResponse['detections'];
      });
      
      // Speak the detected objects
      _speakDetectedObjects();
    } else {
      print("Error: ${response.reasonPhrase}");
    }
  }

  Future<void> _speakDetectedObjects() async {
    if (_detections == null || _detections!.isEmpty) return;
    
    // Get the object with highest confidence
    var highestConfidenceObject = _detections!.reduce((curr, next) => 
      (curr['confidence'] > next['confidence']) ? curr : next);
    
    String objectName = highestConfidenceObject['name'];
    double confidence = highestConfidenceObject['confidence'];
    
    // Only speak if it's a different object or if 3 seconds have passed since last speech
    DateTime now = DateTime.now();
    if (objectName != _lastSpokenObject || 
        now.difference(_lastSpeechTime).inSeconds > 3) {
      
      // Format the speech text
      String speechText = "Detected $objectName";
      
      // Speak the text
      await _flutterTts.speak(speechText);
      
      // Update tracking variables
      _lastSpokenObject = objectName;
      _lastSpeechTime = now;
    }
  }

  Future<File> _rotateImage(File imageFile, String targetPath) async {
    // Use an image processing library to rotate the image based on EXIF data
    // For example, you can use the 'image' package to handle this
    // This is a placeholder for the actual image rotation logic
    return imageFile; // Replace with actual rotation logic
  }

  @override
  void dispose() {
    _isDetecting = false;
    _cameraController?.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live Object Detection')),
      body: Column(
        children: [
          _cameraController != null && _cameraController!.value.isInitialized
              ? RotatedBox(
                quarterTurns: 1, // Adjust if needed (1 = 90°, 3 = 270°)
                child: CameraPreview(_cameraController!),
              )
              : Center(child: CircularProgressIndicator()),
          Expanded(
            child: _detections != null
                ? ListView.builder(
                    itemCount: _detections!.length,
                    itemBuilder: (context, index) {
                      var detection = _detections![index];
                      return ListTile(
                        title: Text("Object: ${detection['name']}"),
                        subtitle: Text("Confidence: ${(detection['confidence'] * 100).toStringAsFixed(2)}%"),
                      );
                    },
                  )
                : Center(child: Text("Detecting...")),
          ),
        ],
      ),
    );
  }
}
