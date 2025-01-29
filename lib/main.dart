import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Import HomeScreen

void main() {
  runApp(const AidifyApp());
}

class AidifyApp extends StatelessWidget {
  const AidifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aidify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(), // Navigate to HomeScreen
    );
  }
}
