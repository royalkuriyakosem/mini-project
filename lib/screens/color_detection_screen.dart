// filepath: /C:/Edge/StepUp/lib/screens/color_detection_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:palette_generator/palette_generator.dart';

class ColorDetectionScreen extends StatefulWidget {
  const ColorDetectionScreen({super.key});

  @override
  _ColorDetectionScreenState createState() => _ColorDetectionScreenState();
}

class _ColorDetectionScreenState extends State<ColorDetectionScreen> {
  File? _image;
  Color? _detectedColor;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _detectColor(File(pickedFile.path));
    }
  }

  Future<void> _detectColor(File image) async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      FileImage(image),
    );
    setState(() {
      _detectedColor = paletteGenerator.dominantColor?.color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Detection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null
                ? const Text('No image selected.')
                : Image.file(_image!),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 20),
            _detectedColor == null
                ? Container()
                : Container(
                    width: 100,
                    height: 100,
                    color: _detectedColor,
                    child: Center(
                      child: Text(
                        'Detected Color',
                        style: TextStyle(
                          color: useWhiteForeground(_detectedColor!)
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  bool useWhiteForeground(Color backgroundColor, {double bias = 1.0}) {
    int v = sqrt(pow(backgroundColor.red, 2) * 0.299 +
            pow(backgroundColor.green, 2) * 0.587 +
            pow(backgroundColor.blue, 2) * 0.114)
        .round();
    return v < 130 * bias ? true : false;
  }
}
