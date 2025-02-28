import 'package:flutter/material.dart';

class ObjectDetectionScreen extends StatelessWidget {
  const ObjectDetectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Object Detection'),
      ),
      body: Center(
        child: Text(
          'Object Detection Screen',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}