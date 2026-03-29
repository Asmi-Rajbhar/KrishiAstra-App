import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Static key names to prevent typos
  static const String tokenKey = 'user_auth_token';
  static const String userIdKey = 'user_id';

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  /// Saves a value securely
  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Reads a value securely, returns null if not found
  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Deletes a specific key
  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Clears all secure storage (useful for Logout)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Specialized method for Auth Token
  static Future<void> saveToken(String token) async {
    await write(tokenKey, token);
  }

  static Future<String?> getToken() async {
    return await read(tokenKey);
  }
}
