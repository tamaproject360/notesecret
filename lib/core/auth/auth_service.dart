import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart'; // Fixed import for iOS/macOS

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  static const String _pinKey = 'user_pin';
  static const String _biometricEnabledKey = 'biometric_enabled';

  // Check if device supports biometrics
  Future<bool> get isBiometricAvailable async {
    try {
      final bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();
      return canAuthenticate;
    } on PlatformException {
      return false;
    }
  }

  // Authenticate with Biometrics
  Future<bool> authenticateWithBiometrics() async {
    try {
      final isAvailable = await isBiometricAvailable;
      if (!isAvailable) return false;

      return await _localAuth.authenticate(
        localizedReason: 'Scan your fingerprint or face to unlock your vault',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Unlock NoteSecret Vault',
            cancelButton: 'Cancel',
          ),
          IOSAuthMessages(
            cancelButton: 'Cancel',
          ),
        ],
      );
    } on PlatformException {
      return false;
    }
  }

  // PIN Management
  Future<void> setPin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
  }

  Future<bool> verifyPin(String inputPin) async {
    final storedPin = await _storage.read(key: _pinKey);
    return storedPin == inputPin;
  }

  Future<bool> hasPin() async {
    final pin = await _storage.read(key: _pinKey);
    return pin != null && pin.isNotEmpty;
  }

  Future<void> removePin() async {
    await _storage.delete(key: _pinKey);
  }

  // Biometric Preference
  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(key: _biometricEnabledKey, value: enabled.toString());
  }

  Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: _biometricEnabledKey);
    return value == 'true';
  }
}
