import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://ughgxfagtdxfzyjsyaeu.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVnaGd4ZmFndGR4Znp5anN5YWV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkyMTI2MTAsImV4cCI6MjA1NDc4ODYxMH0.U70iFiHDvv75ITyLDK_hylHrp51i-R7S3K9wP4qegOg',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;

  static bool isLoggedIn() {
    return client.auth.currentSession != null;
  }

  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      print('SignIn Response: ${response.user}');
      return response;
    } catch (e) {
      print('SignIn Error: $e');
      rethrow;
    }
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }
}
