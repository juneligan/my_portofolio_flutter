import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio_flutter/linklytics/provider/shared_preferences_provider.dart';
// JwtTokenNotifier Provider
final jwtTokenProvider =
StateNotifierProvider<JwtTokenNotifier, String?>((ref) {
  final sharedPrefsAsync = ref.watch(sharedPreferencesProvider);

  // If sharedPrefs is still loading, return a temporary instance that does nothing
  if (sharedPrefsAsync is AsyncLoading || !sharedPrefsAsync.hasValue) {
    return JwtTokenNotifier(null);
  }

  final sharedPrefs = sharedPrefsAsync.value!;
  return JwtTokenNotifier(sharedPrefs);
});

class JwtTokenNotifier extends StateNotifier<String?> {
  final SharedPreferencesService? _prefsService;

  JwtTokenNotifier(this._prefsService) : super(null) {
    _loadToken();
  }


  Future<void> _loadToken() async {
    if (_prefsService != null) {
      state = _prefsService.getJwtToken();
    }
  }

  Future<void> updateToken(String? token) async {
    if (_prefsService == null) return;

    if (token != null) {
      await _prefsService.setJwtToken(token);
    } else {
      await _prefsService.removeJwtToken();
    }

    state = token; // Notify listeners
  }

  Future<void> removeToken() async {
    await updateToken(null);
  }
}