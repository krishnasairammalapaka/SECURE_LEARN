import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._();

  static SupabaseClient get client => Supabase.instance.client;

  static Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(email: email, password: password);
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static Future<String?> getUserRoleByUserId(String userId) async {
    final response = await client
        .from('profiles')
        .select('role')
        .eq('id', userId)
        .maybeSingle();
    if (response == null) return null;
    final role = response['role'] as String?;
    return role?.toLowerCase();
  }
}


