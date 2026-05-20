import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api_client.dart';

class AuthService with ChangeNotifier {
  final Dio _api = ApiClient().dio;
  bool _isLoggedIn = false;

  bool get isAuthenticated => _isLoggedIn;

  // Inscription vers Spring Boot
  Future<void> register(String name, String email, String password) async {
    try {
      await _api.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
    } on DioException catch (e) {
      if (e.response != null && e.response?.data['error'] != null) {
        throw e.response?.data['error'];
      }
      throw "Erreur lors de l'inscription";
    }
  }

  // Connexion vers Spring Boot (Retourne un JWT)
  Future<void> login(String email, String password) async {
    try {
      final response = await _api.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      
      final token = response.data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      
      _isLoggedIn = true;
      notifyListeners();
    } on DioException catch (e) {
      if (e.response != null && e.response?.data['error'] != null) {
        throw e.response?.data['error'];
      }
      throw "Email ou mot de passe incorrect";
    }
  }

  // Déconnexion
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    _isLoggedIn = false;
    notifyListeners();
  }

  // Vérifier si l'utilisateur est connecté localement
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.containsKey('jwt_token');
    return _isLoggedIn;
  }

  // Récupérer les données de l'utilisateur actuel (via serveur Java)
  Future<Map<String, dynamic>> getUserData() async {
    try {
      final response = await _api.get('/auth/me');
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour le nom
  Future<void> updateUserName(String newName) async {
    try {
      await _api.put('/auth/update-name', data: {'name': newName});
    } catch (e) {
      rethrow;
    }
  }
}
