import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  Map<String, dynamic>? _user;

  bool get isLoggedIn => _token != null;
  Map<String, dynamic>? get user => _user;

  Future<bool> login(String email, String password) async {
    final res = await ApiService.post('/login', {
      'email': email,
      'password': password,
    });

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      _token = data['token'];
      await ApiService.setToken(_token!);
      await fetchUser();
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<bool> register(String name, String email, String password, String role) async {
    final res = await ApiService.post('/register', {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    });

    return res.statusCode == 201;
  }

  Future<void> fetchUser() async {
    final res = await ApiService.get('/user', auth: true);
    if (res.statusCode == 200) {
      _user = jsonDecode(res.body)['user'];
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    await ApiService.clearToken();
    notifyListeners();
  }
}
