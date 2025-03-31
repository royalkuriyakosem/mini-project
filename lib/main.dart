// filepath: /C:/Edge/StepUp/lib/main.dart
import 'package:aidify/screens/home_screen.dart';
import 'package:aidify/screens/speech_to_text_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/settings_service.dart';
import 'services/supabase_service.dart';
import 'services/auth_state_handler.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/getting_started_screen.dart';
import 'screens/color_detection_screen.dart';
import 'screens/language_translation_screen.dart';
import 'screens/text_to_speech_screen.dart';

import 'screens/translate_screen.dart';
// Import the new screen
import 'package:shared_preferences/shared_preferences.dart';

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

class AidifyApp extends StatefulWidget {
  const AidifyApp({super.key});

  @override
  _AidifyAppState createState() => _AidifyAppState();
}

class _AidifyAppState extends State<AidifyApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aidify',
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: const AuthStateHandler(),
      routes: {
        '/getting-started': (context) => const GettingStartedScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/splash': (context) => const SplashScreen(),
        '/color-detection': (context) => const ColorDetectionScreen(),
        '/language-translation': (context) => const LanguageTranslationScreen(),

        '/text_to_speech': (context) => const TextToSpeechScreen(),

        '/translate': (context) => const TranslateScreen(),
        '/speech_to_text': (context) =>
            const SpeechToTextScreen(), // Add the route for Speech to Text
      },
    );
  }
}
