import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

/// Service d'authentification connecté au backend Node.js (Prisma)
class AuthService {
  static const String baseUrl = 'http://localhost:3000/api';
  
  bool _isLoggedIn = false;
  UserModel? _currentUser;

  bool get isLoggedIn => _isLoggedIn;
  UserModel? get currentUser => _currentUser;

  Future<void> init() async {
    // Si JWT implémenté, vérifier le token ici.
    // Pour l'instant, pas de token stocké au refresh.
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        _isLoggedIn = true;
        _currentUser = UserModel.fromMap(data['user']);
        return AuthResult(success: true, user: _currentUser);
      } else {
        return AuthResult(success: false, errorMessage: data['errorMessage'] ?? 'Erreur inconnue.');
      }
    } catch (e) {
      return AuthResult(success: false, errorMessage: 'Erreur réseau : $e');
    }
  }

  Future<AuthResult> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    String? companyName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'phone': phone,
          'password': password,
          'companyName': companyName,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        _isLoggedIn = true;
        _currentUser = UserModel.fromMap(data['user']);
        return AuthResult(success: true, user: _currentUser);
      } else {
        return AuthResult(success: false, errorMessage: data['errorMessage'] ?? 'Erreur inconnue.');
      }
    } catch (e) {
      return AuthResult(success: false, errorMessage: 'Erreur réseau : $e');
    }
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/auth/profile'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedUser.toMap()),
      );
      if (response.statusCode == 200) {
        _currentUser = updatedUser;
      }
    } catch (e) {
      // Ignore network errors in this demo, local profile updates
      _currentUser = updatedUser;
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _currentUser = null;
  }
}

class AuthResult {
  final bool success;
  final UserModel? user;
  final String? errorMessage;

  AuthResult({required this.success, this.user, this.errorMessage});
}
