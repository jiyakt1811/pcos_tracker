import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  static const String _tokenKey = 'auth_token';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  
  bool _isAuthenticated = false;
  String? _userName;
  String? _userEmail;
  
  bool get isAuthenticated => _isAuthenticated;
  String? get userName => _userName;
  String? get userEmail => _userEmail;

  AuthService() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token != null) {
      _isAuthenticated = true;
      _userName = prefs.getString(_userNameKey);
      _userEmail = prefs.getString(_userEmailKey);
      notifyListeners();
    }
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Here you would typically make an API call to your backend
      // For now, we'll simulate a successful signup
      await Future.delayed(const Duration(seconds: 1));

      // Validate email format
      if (!email.contains('@') || !email.contains('.')) {
        throw 'Invalid email format';
      }

      // Validate password strength
      if (password.length < 6) {
        throw 'Password must be at least 6 characters';
      }

      // Validate name
      if (name.trim().split(' ').length < 2) {
        throw 'Please enter your full name';
      }

      // Store user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, 'dummy_token');
      await prefs.setString(_userNameKey, name);
      await prefs.setString(_userEmailKey, email);

      _isAuthenticated = true;
      _userName = name;
      _userEmail = email;
      notifyListeners();
    } catch (e) {
      throw 'Failed to create account: $e';
    }
  }

  Future<void> login(String email, String password) async {
    try {
      // Here you would typically make an API call to your backend
      // For now, we'll simulate a successful login
      await Future.delayed(const Duration(seconds: 1));

      // Validate email format
      if (!email.contains('@') || !email.contains('.')) {
        throw 'Invalid email format';
      }

      // Validate password
      if (password.length < 6) {
        throw 'Invalid password';
      }

      // Store user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, 'dummy_token');
      await prefs.setString(_userEmailKey, email);
      
      // In a real app, you would get the user's name from the backend
      final name = email.split('@')[0];
      await prefs.setString(_userNameKey, name);

      _isAuthenticated = true;
      _userName = name;
      _userEmail = email;
      notifyListeners();
    } catch (e) {
      throw 'Failed to login: $e';
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userNameKey);
      await prefs.remove(_userEmailKey);

      _isAuthenticated = false;
      _userName = null;
      _userEmail = null;
      notifyListeners();
    } catch (e) {
      throw 'Failed to logout: $e';
    }
  }
} 