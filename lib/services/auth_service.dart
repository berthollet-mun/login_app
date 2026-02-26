import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _baseUrl = 'https://api.example.com';
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  final http.Client _client;
  final SharedPreferences _prefs;
  final bool useMockAuth; // Set to true for demo mode

  AuthService({
    http.Client? client,
    required SharedPreferences prefs,
    this.useMockAuth = true, // Default to mock auth for testing
  }) : _client = client ?? http.Client(),
       _prefs = prefs;

  Future<User> login(String email, String password) async {
    if (useMockAuth) {
      return _mockLogin(email, password);
    }
    return _realLogin(email, password);
  }

  Future<User> _mockLogin(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Demo credentials: any email with password "password123"
    if (password.length < 6) {
      throw AuthException('Invalid credentials. Try password: password123');
    }

    final user = User(
      id: 'mock-user-001',
      email: email,
      name: email.split('@')[0],
      phoneNumber: '+1234567890',
      avatarUrl: null,
    );

    final token = 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}';

    await _saveToken(token);
    await _saveUser(user);

    return user;
  }

  Future<User> _realLogin(String email, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data['user'] as Map<String, dynamic>);
        final token = data['token'] as String;

        await _saveToken(token);
        await _saveUser(user);

        return user;
      } else {
        final error = jsonDecode(response.body);
        throw AuthException(error['message'] ?? 'Login failed');
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: ${e.toString()}');
    }
  }

  Future<User> register(String email, String password, String name) async {
    if (useMockAuth) {
      return _mockRegister(email, password, name);
    }
    return _realRegister(email, password, name);
  }

  Future<User> _mockRegister(String email, String password, String name) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (password.length < 6) {
      throw AuthException('Password must be at least 6 characters');
    }

    final user = User(
      id: 'mock-user-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name,
      phoneNumber: null,
      avatarUrl: null,
    );

    final token = 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}';

    await _saveToken(token);
    await _saveUser(user);

    return user;
  }

  Future<User> _realRegister(String email, String password, String name) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password, 'name': name}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data['user'] as Map<String, dynamic>);
        final token = data['token'] as String;

        await _saveToken(token);
        await _saveUser(user);

        return user;
      } else {
        final error = jsonDecode(response.body);
        throw AuthException(error['message'] ?? 'Registration failed');
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: ${e.toString()}');
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw AuthException(error['message'] ?? 'Failed to send reset email');
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_userKey);
  }

  Future<bool> isAuthenticated() async {
    final token = _prefs.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  Future<User?> getCurrentUser() async {
    final userJson = _prefs.getString(_userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<void> updateProfile(User user) async {
    try {
      final token = _prefs.getString(_tokenKey);
      if (token == null) throw AuthException('Not authenticated');

      final response = await _client.put(
        Uri.parse('$_baseUrl/users/${user.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        await _saveUser(user);
      } else {
        final error = jsonDecode(response.body);
        throw AuthException(error['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: ${e.toString()}');
    }
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final token = _prefs.getString(_tokenKey);
      if (token == null) throw AuthException('Not authenticated');

      final response = await _client.post(
        Uri.parse('$_baseUrl/auth/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw AuthException(error['message'] ?? 'Failed to change password');
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Network error: ${e.toString()}');
    }
  }

  Future<void> _saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  Future<void> _saveUser(User user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
