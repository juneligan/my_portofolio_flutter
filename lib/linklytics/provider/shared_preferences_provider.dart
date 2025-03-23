import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider for SharedPreferencesService
final sharedPreferencesProvider = FutureProvider<SharedPreferencesService>((ref) async {

  final prefs = await SharedPreferences.getInstance();
  return SharedPreferencesService(prefs); // Load SharedPreferences asynchronously
});

class SharedPreferencesService {
  static final String jwtTokenKey = 'jwt_token';
  final SharedPreferences _prefs;

  SharedPreferencesService(this._prefs);

  // Save a string value (e.g., JWT token)
  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  // Retrieve a string value
  String? getString(String key) {
    return _prefs.getString(key);
  }

  // Remove a key
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  // Clear all stored data (useful for logout)
  Future<void> clear() async {
    await _prefs.clear();
  }

  // Check if a token exists and is valid
  bool isTokenValid(String key) {
    final token = getString(key);
    return token != null && token.isNotEmpty;
  }

  String? getJwtToken() => _prefs.getString(jwtTokenKey);

  Future<void> setJwtToken(String token) async {
    await _prefs.setString(jwtTokenKey, token);
  }

  Future<void> removeJwtToken() async {
    await _prefs.remove(jwtTokenKey);
  }
}
