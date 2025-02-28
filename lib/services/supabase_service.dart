import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://ughgxfagtdxfzyjsyaeu.supabase.co',
      anonKey: 'YOUR_SUPABASE_ANON_KEY', // 🔒 Store this securely!
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
    return await client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
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
      print('Error signing in: $e');
      rethrow; // Propagate the error
    }
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static Future<String?> getUserName() async {
    final user = client.auth.currentUser;
    if (user != null) {
      try {
        final response = await client
            .from('users') // Replace with your actual table name
            .select('name')
            .eq('id', user.id)
            .single(); // Fetch a single record

        return response['name']; // Correct way to access the name field
      } catch (error) {
        print("Error fetching user name: $error");
        return null;
      }
    }
    return null;
  }
}
