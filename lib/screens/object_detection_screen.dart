import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ObjectDetectionScreen extends StatefulWidget {
  const ObjectDetectionScreen({super.key});

  @override
  _ObjectDetectionScreenState createState() => _ObjectDetectionScreenState();
}

class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {
  File? _image;
  List? _recognitions;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    String? res = await Tflite.loadModel(
      model: "assets/models/1.tflite",
      labels:
          "assets/models/labelmap.txt", // Update this if you have a label map file
    );
    print(res);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _detectObjects(_image!);
    }
  }

  Future<void> _detectObjects(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
      path: image.path,
      model: "YOLO",
      threshold: 0.5,
      numResultsPerClass: 1,
    );

    setState(() {
      _recognitions = recognitions;
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Object Detection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null ? Text('No image selected.') : Image.file(_image!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            _recognitions == null
                ? Container()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _recognitions!.length,
                      itemBuilder: (context, index) {
                        final recognition = _recognitions![index];
                        return ListTile(
                          title: Text(recognition['detectedClass']),
                          subtitle: Text(
                              'Confidence: ${(recognition['confidenceInClass'] * 100).toStringAsFixed(2)}%'),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
