// lib/providers/auth_provider.dart
import 'package:deepex/models/auth/auth_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(AuthService());
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState()) {
    // Check if user is already logged in
    _initialize();
  }

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      try {
        final user = await _authService.getUserProfile(token);
        state = state.copyWith(
          isAuthenticated: true,
          user: user,
          token: token,
        );
      } catch (e) {
        // Token might be expired or invalid
        await prefs.remove('auth_token');
      }
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authService.login(email, password);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', result.token);

      state = state.copyWith(
        isAuthenticated: true,
        user: result.user,
        token: result.token,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authService.register(name, email, password);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', result.token);

      state = state.copyWith(
        isAuthenticated: true,
        user: result.user,
        token: result.token,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');

    state = AuthState();
  }
}
