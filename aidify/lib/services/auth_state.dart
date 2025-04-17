import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthState extends StatefulWidget {
  const AuthState({super.key});

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<AuthState> {
  final SupabaseClient supabase = Supabase.instance.client;
  
  @override
  void initState() {
    super.initState();
    
    // Listen for authentication state changes
    supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;

      if (!mounted) return;

      switch (event) {
        case AuthChangeEvent.signedIn:
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
          break;
        case AuthChangeEvent.signedOut:
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
          break;
        case AuthChangeEvent.passwordRecovery:
          // Handle password recovery if needed
          break;
        case AuthChangeEvent.userUpdated:
          // Handle user updates
          break;
        default:
          break;
      }
    });
  }

  void showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()), // Placeholder UI
    );
  }
}