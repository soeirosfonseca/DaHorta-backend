// ignore_for_file: file_names
import 'package:flutter/material.dart';
// ignore: unused_import
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _name;
  User? _email;
  User? _token;

  var user;

  User? get name => _name;
  User? get email => _email;
  User? get token => _token;

  bool get isLoggedIn => _token != null;

  void setUser({required User name, required User email, required User token}) {
    _name = name;
    _email = email;
    _token = token;
    notifyListeners();
  }

  void clearUser() {
    _name = null;
    _email = null;
    _token = null;
    notifyListeners();
  }
}
