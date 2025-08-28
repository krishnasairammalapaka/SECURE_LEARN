import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/supabase_service.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  // Temporary local-bypass for authentication during development
  static const bool _bypassAuthLocally = true; // set to false to use Supabase
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isAuthenticated = false;
  String? _currentUser;
  String? _userRole;

  bool get isAuthenticated => _isAuthenticated;
  String? get currentUser => _currentUser;
  String? get userRole => _userRole;

  AuthProvider() {
    _checkAuthStatus();
  }

  // Check if user is already authenticated
  Future<void> _checkAuthStatus() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      final user = await _secureStorage.read(key: 'current_user');
      final role = await _secureStorage.read(key: 'user_role');
      
      if (token != null && user != null) {
        _isAuthenticated = true;
        _currentUser = user;
        _userRole = role ?? 'student';
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error checking auth status: $e');
    }
  }

  // Secure login method with password hashing
  Future<bool> login(String username, String password) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Normalize input
      final normalizedUsername = username.trim().toLowerCase();
      final trimmedPassword = password.trim();

      // TEMP: Hardcoded local authentication bypass
      if (_bypassAuthLocally) {
        if (normalizedUsername.isNotEmpty && trimmedPassword.isNotEmpty) {
          _isAuthenticated = true;
          _currentUser = normalizedUsername;
          _userRole = _getUserRole(normalizedUsername);
          final token = _generateSecureToken(normalizedUsername);
          await _secureStorage.write(key: 'auth_token', value: token);
          await _secureStorage.write(key: 'current_user', value: normalizedUsername);
          await _secureStorage.write(key: 'user_role', value: _userRole);
          notifyListeners();
          return true;
        }
        return false;
      }

      // Hash password for comparison (in real app, this would be done server-side)
      final hashedPassword = _hashPassword(trimmedPassword);
      
      // Demo credentials (in real app, this would be validated against a server)
      final Map<String, String> validCredentials = {
        'admin': 'admin123',
        'student': 'student123',
        'teacher': 'teacher123',
        'developer': 'dev123',
        'tester': 'test123',
        // Temporary demo aliases
        'demo': 'demo123',
        'user': 'user123',
      };
      
      final expectedPassword = validCredentials[normalizedUsername] ?? '';
      final hashedValidPassword = _hashPassword(expectedPassword);
      
      if (hashedPassword == hashedValidPassword && validCredentials.containsKey(normalizedUsername)) {
        _isAuthenticated = true;
        _currentUser = normalizedUsername;
        _userRole = _getUserRole(normalizedUsername);
        // Generate a secure token (in real app, this would come from server)
        final token = _generateSecureToken(normalizedUsername);
        // Store credentials securely
        await _secureStorage.write(key: 'auth_token', value: token);
        await _secureStorage.write(key: 'current_user', value: normalizedUsername);
        await _secureStorage.write(key: 'user_role', value: _userRole);
        notifyListeners();
        return true;
      }
      
      // Fallback to Supabase password sign in (expects email usernames)
      final response = await SupabaseService.signInWithPassword(
        email: username,
        password: password,
      );
      if (response.user != null) {
        final user = response.user!;
        // Fetch role from profiles table (id must match auth user id)
        final fetchedRole = await SupabaseService.getUserRoleByUserId(user.id);
        _isAuthenticated = true;
        _currentUser = user.email ?? username;
        _userRole = (fetchedRole == 'admin' || fetchedRole == 'teacher' || fetchedRole == 'student')
            ? fetchedRole
            : 'student';
        final token = response.session?.accessToken ?? _generateSecureToken(_currentUser!);
        await _secureStorage.write(key: 'auth_token', value: token);
        await _secureStorage.write(key: 'current_user', value: _currentUser);
        await _secureStorage.write(key: 'user_role', value: _userRole);
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  // Secure logout method
  Future<void> logout() async {
    try {
      // Clear all stored credentials
      await _secureStorage.deleteAll();
      
      _isAuthenticated = false;
      _currentUser = null;
      _userRole = null;
      
      notifyListeners();
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }

  // Hash password using SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Generate a secure token
  String _generateSecureToken(String seed) {
    final random = DateTime.now().millisecondsSinceEpoch.toString();
    final token = _hashPassword('$random|$seed');
    return token;
  }

  // Get user role based on username
  String _getUserRole(String username) {
    switch (username.toLowerCase()) {
      case 'admin':
        return 'admin';
      case 'teacher':
        return 'teacher';
      case 'developer':
        return 'developer';
      case 'tester':
        return 'tester';
      default:
        return 'student';
    }
  }

  // Check if user has specific role
  bool hasRole(String role) {
    return _userRole == role;
  }

  // Check if user has any of the specified roles
  bool hasAnyRole(List<String> roles) {
    return roles.contains(_userRole);
  }

  // Get user permissions based on role
  List<String> getUserPermissions() {
    switch (_userRole) {
      case 'admin':
        return [
          'view_all_modules',
          'edit_modules',
          'delete_modules',
          'manage_users',
          'view_analytics',
          'export_data',
        ];
      case 'teacher':
        return [
          'view_all_modules',
          'edit_modules',
          'create_assignments',
          'grade_students',
          'view_course_analytics',
        ];
      case 'developer':
        return [
          'view_all_modules',
          'edit_modules',
          'view_analytics',
        ];
      case 'tester':
        return [
          'view_all_modules',
          'run_tests',
          'view_analytics',
        ];
      case 'student':
        return [
          'view_modules',
          'take_quizzes',
          'view_progress',
        ];
      default:
        return ['view_modules'];
    }
  }

  // Check if user has specific permission
  bool hasPermission(String permission) {
    return getUserPermissions().contains(permission);
  }
}
