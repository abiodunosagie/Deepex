// lib/services/auth_service.dart
import 'dart:convert';

import 'package:deepex/models/auth/user_model.dart';
import 'package:deepex/utilities/app_constants.dart';
import 'package:http/http.dart' as http;

class AuthResult {
  final UserModel user;
  final String token;

  AuthResult({required this.user, required this.token});
}

class AuthService {
  final String baseUrl = AppConstants.baseUrl;

  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AuthResult(
          user: UserModel.fromJson(data['user']),
          token: data['token'],
        );
      } else {
        final error = json.decode(response.body)['message'] ?? 'Login failed';
        throw Exception(error);
      }
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<AuthResult> register(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return AuthResult(
          user: UserModel.fromJson(data['user']),
          token: data['token'],
        );
      } else {
        final error =
            json.decode(response.body)['message'] ?? 'Registration failed';
        throw Exception(error);
      }
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<UserModel> getUserProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserModel.fromJson(data['user']);
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      throw Exception('Failed to load user profile: ${e.toString()}');
    }
  }
}
