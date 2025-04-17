import 'package:flutter/material.dart';

class AccessibilityScreen extends StatelessWidget {
  const AccessibilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility'),
      ),
      body: const Center(
        child: Text('Accessibility Screen'),
      ),
    );
  }
}
