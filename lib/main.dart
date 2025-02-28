import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/settings_service.dart';
import 'services/supabase_service.dart';
import 'services/auth_state_handler.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/getting_started_screen.dart';
import 'screens/color_detection_screen.dart';
import 'screens/ocr_screen.dart';
import 'screens/language_translation_screen.dart';
import 'screens/sign_language_recognition_screen.dart';
import 'screens/accessibility_settings_screen.dart';
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
        '/settings': (context) => const AccessibilitySettingsScreen(),
        '/splash': (context) => const SplashScreen(),
        '/color-detection': (context) => const ColorDetectionScreen(),
        '/ocr': (context) => const OCRScreen(),
        '/language-translation': (context) => const LanguageTranslationScreen(),
        '/sign-language-recognition': (context) =>
            const SignLanguageRecognitionScreen(),
      },
    );
  }
}
