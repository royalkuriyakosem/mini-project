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

  String _colorToName(Color color) {
    // Define a map of color names to their approximate RGB values
    const colorNames = {
      'Black': Color(0xFF000000),
      'White': Color(0xFFFFFFFF),
      'Red': Color(0xFFFF0000),
      'Green': Color(0xFF00FF00),
      'Blue': Color(0xFF0000FF),
      'Yellow': Color(0xFFFFFF00),
      'Cyan': Color(0xFF00FFFF),
      'Magenta': Color(0xFFFF00FF),
      'Gray': Color(0xFF808080),
      'Maroon': Color(0xFF800000),
      'Olive': Color(0xFF808000),
      'Purple': Color(0xFF800080),
      'Teal': Color(0xFF008080),
      'Navy': Color(0xFF000080),
    };

    // Find the closest color name
    String closestColorName = 'Unknown';
    double closestDistance = double.infinity;

    colorNames.forEach((name, value) {
      double distance = _colorDistance(color, value);
      if (distance < closestDistance) {
        closestDistance = distance;
        closestColorName = name;
      }
    });

    return closestColorName;
  }

  double _colorDistance(Color c1, Color c2) {
    return sqrt(pow(c1.red - c2.red, 2) +
        pow(c1.green - c2.green, 2) +
        pow(c1.blue - c2.blue, 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Detection'),
      ),
      body: Center(
        child: SingleChildScrollView(
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
                  : Column(
                      children: [
                        Container(
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
                        const SizedBox(height: 10),
                        Text(
                          'Color: ${_colorToName(_detectedColor!)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _detectedColor,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
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
