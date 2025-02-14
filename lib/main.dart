import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/settings_service.dart';
import 'services/supabase_service.dart';
import 'services/auth_state_handler.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/text_to_speech_screen.dart';
import 'screens/speech_to_text_screen.dart';
import 'screens/object_detection_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  try {
    await SupabaseService.initialize();
    final settingsService = SettingsService();
    await settingsService.initialize();

    runApp(
      ChangeNotifierProvider(
        create: (_) => settingsService,
        child: const AidifyApp(),
      ),
    );
  } catch (e) {
    print('Initialization error: $e');
    // Handle initialization error
  }
}

class AidifyApp extends StatelessWidget {
  const AidifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aidify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AuthStateHandler(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/text-to-speech': (context) => const TextToSpeechScreen(),
        '/speech-to-text': (context) => const SpeechToTextScreen(),
        '/object-detection': (context) => const ObjectDetectionScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
