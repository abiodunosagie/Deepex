// lib/models/auth/auth_state.dart
import 'package:deepex/models/auth/user_model.dart';

class AuthState {
  final bool isAuthenticated;
  final UserModel? user;
  final String? token;
  final String? error;
  final bool isLoading;

  AuthState({
    this.isAuthenticated = false,
    this.user,
    this.token,
    this.error,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    UserModel? user,
    String? token,
    String? error,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      token: token ?? this.token,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
