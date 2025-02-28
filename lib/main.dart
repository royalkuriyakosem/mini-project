import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/settings_service.dart';
import 'services/supabase_service.dart';
import 'services/auth_state_handler.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/getting_started_screen.dart';
import 'screens/color_detection_screen.dart';
import 'screens/ocr_screen.dart';

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
        '/getting-started': (context) => const GettingStartedScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/splash': (context) => const SplashScreen(),
        '/color-detection': (context) => const ColorDetectionScreen(),
        '/ocr': (context) => const OCRScreen(),
      },
    );
  }
}
