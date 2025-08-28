import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // Security settings
  bool _biometricEnabled = false;
  bool _sslPinningEnabled = true;
  bool _debugModeEnabled = false;
  bool _rootDetectionEnabled = true;
  bool _emulatorDetectionEnabled = true;
  
  // Security status
  bool _isDeviceSecure = true;
  bool _isNetworkSecure = true;
  List<String> _securityWarnings = [];
  List<String> _securityVulnerabilities = [];

  // Getters
  bool get biometricEnabled => _biometricEnabled;
  bool get sslPinningEnabled => _sslPinningEnabled;
  bool get debugModeEnabled => _debugModeEnabled;
  bool get rootDetectionEnabled => _rootDetectionEnabled;
  bool get emulatorDetectionEnabled => _emulatorDetectionEnabled;
  bool get isDeviceSecure => _isDeviceSecure;
  bool get isNetworkSecure => _isNetworkSecure;
  List<String> get securityWarnings => _securityWarnings;
  List<String> get securityVulnerabilities => _securityVulnerabilities;

  SecurityProvider() {
    _loadSecuritySettings();
    _performSecurityChecks();
  }

  // Load security settings from secure storage
  Future<void> _loadSecuritySettings() async {
    try {
      _biometricEnabled = await _secureStorage.read(key: 'biometric_enabled') == 'true';
      _sslPinningEnabled = await _secureStorage.read(key: 'ssl_pinning_enabled') != 'false';
      _debugModeEnabled = await _secureStorage.read(key: 'debug_mode_enabled') == 'true';
      _rootDetectionEnabled = await _secureStorage.read(key: 'root_detection_enabled') != 'false';
      _emulatorDetectionEnabled = await _secureStorage.read(key: 'emulator_detection_enabled') != 'false';
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading security settings: $e');
    }
  }

  // Save security settings to secure storage
  Future<void> _saveSecuritySettings() async {
    try {
      await _secureStorage.write(key: 'biometric_enabled', value: _biometricEnabled.toString());
      await _secureStorage.write(key: 'ssl_pinning_enabled', value: _sslPinningEnabled.toString());
      await _secureStorage.write(key: 'debug_mode_enabled', value: _debugModeEnabled.toString());
      await _secureStorage.write(key: 'root_detection_enabled', value: _rootDetectionEnabled.toString());
      await _secureStorage.write(key: 'emulator_detection_enabled', value: _emulatorDetectionEnabled.toString());
    } catch (e) {
      debugPrint('Error saving security settings: $e');
    }
  }

  // Perform security checks
  Future<void> _performSecurityChecks() async {
    _securityWarnings.clear();
    _securityVulnerabilities.clear();

    // Check for debug mode
    if (_debugModeEnabled) {
      _securityWarnings.add('Debug mode is enabled - this may expose sensitive information');
    }

    // Check for root/jailbreak (simulated)
    if (_rootDetectionEnabled) {
      final isRooted = await _checkForRoot();
      if (isRooted) {
        _securityVulnerabilities.add('Device appears to be rooted/jailbroken');
        _isDeviceSecure = false;
      }
    }

    // Check for emulator (simulated)
    if (_emulatorDetectionEnabled) {
      final isEmulator = await _checkForEmulator();
      if (isEmulator) {
        _securityWarnings.add('App is running on an emulator');
      }
    }

    // Check SSL pinning
    if (!_sslPinningEnabled) {
      _securityWarnings.add('SSL pinning is disabled - network traffic may be vulnerable to MITM attacks');
    }

    notifyListeners();
  }

  // Simulated root detection
  Future<bool> _checkForRoot() async {
    // In a real app, this would check for root indicators
    // For demo purposes, we'll simulate this
    await Future.delayed(const Duration(milliseconds: 100));
    return false; // Simulate no root detected
  }

  // Simulated emulator detection
  Future<bool> _checkForEmulator() async {
    // In a real app, this would check for emulator indicators
    // For demo purposes, we'll simulate this
    await Future.delayed(const Duration(milliseconds: 100));
    return false; // Simulate no emulator detected
  }

  // Update security settings
  Future<void> updateSecuritySetting(String setting, bool value) async {
    switch (setting) {
      case 'biometric_enabled':
        _biometricEnabled = value;
        break;
      case 'ssl_pinning_enabled':
        _sslPinningEnabled = value;
        break;
      case 'debug_mode_enabled':
        _debugModeEnabled = value;
        break;
      case 'root_detection_enabled':
        _rootDetectionEnabled = value;
        break;
      case 'emulator_detection_enabled':
        _emulatorDetectionEnabled = value;
        break;
    }
    
    await _saveSecuritySettings();
    await _performSecurityChecks();
    notifyListeners();
  }

  // Add security warning
  void addSecurityWarning(String warning) {
    if (!_securityWarnings.contains(warning)) {
      _securityWarnings.add(warning);
      notifyListeners();
    }
  }

  // Add security vulnerability
  void addSecurityVulnerability(String vulnerability) {
    if (!_securityVulnerabilities.contains(vulnerability)) {
      _securityVulnerabilities.add(vulnerability);
      notifyListeners();
    }
  }

  // Clear security warnings
  void clearSecurityWarnings() {
    _securityWarnings.clear();
    notifyListeners();
  }

  // Clear security vulnerabilities
  void clearSecurityVulnerabilities() {
    _securityVulnerabilities.clear();
    notifyListeners();
  }

  // Get security score (0-100)
  int getSecurityScore() {
    int score = 100;
    
    // Deduct points for warnings
    score -= _securityWarnings.length * 5;
    
    // Deduct points for vulnerabilities
    score -= _securityVulnerabilities.length * 20;
    
    // Deduct points for disabled security features
    if (!_sslPinningEnabled) score -= 15;
    if (_debugModeEnabled) score -= 10;
    if (!_rootDetectionEnabled) score -= 5;
    if (!_emulatorDetectionEnabled) score -= 5;
    
    return score.clamp(0, 100);
  }

  // Get security status
  String getSecurityStatus() {
    final score = getSecurityScore();
    if (score >= 90) return 'Excellent';
    if (score >= 75) return 'Good';
    if (score >= 60) return 'Fair';
    if (score >= 40) return 'Poor';
    return 'Critical';
  }

  // Get security recommendations
  List<String> getSecurityRecommendations() {
    final recommendations = <String>[];
    
    if (!_sslPinningEnabled) {
      recommendations.add('Enable SSL pinning to prevent MITM attacks');
    }
    
    if (_debugModeEnabled) {
      recommendations.add('Disable debug mode in production builds');
    }
    
    if (!_rootDetectionEnabled) {
      recommendations.add('Enable root detection to prevent unauthorized access');
    }
    
    if (!_emulatorDetectionEnabled) {
      recommendations.add('Enable emulator detection for additional security');
    }
    
    if (_securityVulnerabilities.isNotEmpty) {
      recommendations.add('Address identified security vulnerabilities immediately');
    }
    
    return recommendations;
  }
}
