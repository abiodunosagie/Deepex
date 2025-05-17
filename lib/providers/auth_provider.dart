// lib/providers/auth_provider.dart
import 'package:deepex/models/auth/auth_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth/user_model.dart';
import '../services/auth_service.dart';

// Extended AuthState class with OTP fields
class AuthStateExtended extends AuthState {
  final bool isOtpVerified;
  final String? pendingEmail;

  AuthStateExtended({
    bool isAuthenticated = false,
    UserModel? user,
    String? token,
    String? error,
    bool isLoading = false,
    this.isOtpVerified = false,
    this.pendingEmail,
  }) : super(
          isAuthenticated: isAuthenticated,
          user: user,
          token: token,
          error: error,
          isLoading: isLoading,
        );

  @override
  AuthStateExtended copyWith({
    bool? isAuthenticated,
    UserModel? user,
    String? token,
    String? error,
    bool? isLoading,
    bool? isOtpVerified,
    String? pendingEmail,
  }) {
    return AuthStateExtended(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      token: token ?? this.token,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
      pendingEmail: pendingEmail ?? this.pendingEmail,
    );
  }
}

// The auth provider definition
final authProvider =
    StateNotifierProvider<AuthNotifier, AuthStateExtended>((ref) {
  return AuthNotifier(AuthService());
});

// Extension method to clear pendingEmail
extension AuthNotifierExtension on AuthNotifier {
  void clearPendingEmail() {
    state = state.copyWith(pendingEmail: null);
  }
}

class AuthNotifier extends StateNotifier<AuthStateExtended> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthStateExtended()) {
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
          isOtpVerified: true, // Assume saved tokens are from verified accounts
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
        isOtpVerified: true,
        // Assume login only works for verified accounts
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

  // Modified to store email pending verification instead of authenticating
  Future<void> register(String name, String email, String password) async {
    // First, clear any existing verification state
    state = state.copyWith(
      isOtpVerified: false,
      pendingEmail: null,
      error: null,
      isLoading: true,
    );

    try {
      // Instead of storing the token immediately, just store the pending email
      // This will send the user to the OTP verification screen
      final result = await _authService.register(name, email, password);

      // Store the email that needs verification
      state = state.copyWith(
        isLoading: false,
        pendingEmail: email,
        // Ensure these are explicitly set
        isAuthenticated: false,
        isOtpVerified: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        // Clear pending email if registration fails
        pendingEmail: null,
      );
    }
  }

  // Method to verify OTP
  Future<void> verifyOtp(String otp) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // In a real app, you would call an API to verify the OTP
      await Future.delayed(const Duration(seconds: 1));

      // For demo, just simulate verification for "123456"
      if (otp == "123456") {
        // Create mock result
        final mockUser = UserModel(
          id: "temp_id",
          email: state.pendingEmail ?? "",
          name: "New User",
        );
        const mockToken = "mock_verified_token";

        // Update state to verified but NOT authenticated
        state = state.copyWith(
          isOtpVerified: true,
          user: mockUser,
          isLoading: false,
          pendingEmail: null, // Clear pending email
          // IMPORTANT: Don't set isAuthenticated to true
        );
      } else {
        // Invalid OTP code
        state = state.copyWith(
          isLoading: false,
          error: "Invalid verification code. Please try again.",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Method to resend OTP
  Future<void> resendOtp() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Make sure we have an email to resend to
      if (state.pendingEmail == null) {
        throw Exception("No pending verification found");
      }

      // Just simulate a delay for now
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(isLoading: false);
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

    state = AuthStateExtended();
  }
}
