import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStateHandler extends StatefulWidget {
  const AuthStateHandler({super.key});

  @override
  _AuthStateHandlerState createState() => _AuthStateHandlerState();
}

class _AuthStateHandlerState extends State<AuthStateHandler> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final session = Supabase.instance.client.auth.currentSession;
    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenGettingStarted =
        prefs.getBool('hasSeenGettingStarted') ?? false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (session != null) {
        // User is logged in, navigate to HomeScreen
        Navigator.of(context).pushReplacementNamed('/home');
      } else if (!hasSeenGettingStarted) {
        // User has not seen Getting Started, navigate to Getting Started Screen
        Navigator.of(context).pushReplacementNamed('/getting-started');
      } else {
        // User is not logged in and has seen Getting Started, navigate to LoginScreen
        Navigator.of(context).pushReplacementNamed('/login');
      }
      setState(() {
        _initialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(); // This will not be used as navigation happens in _initialize
  }
}
