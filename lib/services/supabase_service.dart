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

  // For simple DB-based auth against public.profiles (username/password in plain text)
  static Future<Map<String, dynamic>?> getProfileByCredentials({
    required String username,
    required String password,
  }) async {
    final data = await client
        .from('profiles')
        .select('id, full_name, username, role')
        .eq('username', username)
        .eq('password', password)
        .maybeSingle();
    return data;
  }

  static Future<Map<String, dynamic>?> getProfileByUsername({
    required String username,
  }) async {
    final data = await client
        .from('profiles')
        .select('id, full_name, username, role, created_at')
        .eq('username', username)
        .maybeSingle();
    return data;
  }

  static Future<bool> verifyProfileCredentials({
    required String username,
    required String password,
  }) async {
    final data = await client
        .from('profiles')
        .select('id')
        .eq('username', username)
        .eq('password', password)
        .maybeSingle();
    return data != null;
  }

  static Future<void> updateProfilePassword({
    required String username,
    required String newPassword,
  }) async {
    await client
        .from('profiles')
        .update({'password': newPassword})
        .eq('username', username);
  }
}


