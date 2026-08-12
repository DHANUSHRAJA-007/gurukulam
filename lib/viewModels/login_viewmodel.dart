import 'package:flutter/material.dart';

import 'package:gurukulam/models/login_model.dart';
import 'package:gurukulam/repositories/login_repo.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginRepository _repository;

  LoginViewModel({
    LoginRepository? repository,
  }) : _repository =
            repository ?? LoginRepository();

  // ==========================================
  // State Variables
  // ==========================================

  bool _isLoading = false;
  bool _obscurePassword = true;

  String? _errorMessage;


  UserModel? _user;

  // ==========================================
  // Getters
  // ==========================================

  bool get isLoading => _isLoading;

  
  bool get obscurePassword =>
      _obscurePassword;

  

  String? get errorMessage =>
      _errorMessage;


  UserModel? get user => _user;

  // ==========================================
  // Password Visibility
  // ==========================================

  void togglePasswordVisibility() {
    _obscurePassword =
        !_obscurePassword;

    notifyListeners();
  }

 
  
  

  // ==========================================
  // Login
  // ==========================================

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _errorMessage = null;


    _isLoading = true;

    notifyListeners();

    try {
      final response =
          await _repository.login(
        username: username.trim(),
        password: password.trim(),

      );

      if (response.success &&
          response.user != null) {
        _user = response.user;

        await _repository.saveUserData(
          _user!,
        );

        return true;
      }

      _errorMessage =
          _getLoginErrorMessage(
        response.message,
      );

      return false;
    } catch (e) {
      _errorMessage =
          _getUserFriendlyError(
        e.toString(),
      );

      return false;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // ==========================================
  // Clear Error
  // ==========================================

  void clearError() {
    _errorMessage = null;

    notifyListeners();
  }

  // ==========================================
  // Login Error
  // ==========================================

  String _getLoginErrorMessage(
    String message,
  ) {
    final error =
        message.toLowerCase();

    if (error.contains('invalid') ||
        error.contains('incorrect') ||
        error.contains('wrong')) {
      return 'Invalid username or password. Please try again.';
    }

    if (error.contains('not found') ||
        error.contains('no user')) {
      return 'User not found. Please check your username.';
    }

    if (error.contains('inactive') ||
        error.contains('disabled')) {
      return 'Your account is inactive. Please contact administrator.';
    }

    

    return message.isNotEmpty
        ? message
        : 'Login failed. Please try again.';
  }

  // ==========================================
  // Network Error
  // ==========================================

  String _getUserFriendlyError(
    String error,
  ) {
    final errorLower =
        error.toLowerCase();

    if (errorLower.contains('timeout')) {
      return 'Connection timeout. Please check your internet connection.';
    }

    if (errorLower.contains('socket') ||
        errorLower.contains('network') ||
        errorLower.contains('connection')) {
      return 'Network error. Please check your internet connection.';
    }

    if (errorLower.contains('ssl') ||
        errorLower.contains('certificate')) {
      return 'SSL connection error. Please contact support.';
    }

    if (errorLower.contains('404') ||
        errorLower.contains('not found')) {
      return 'Server endpoint not found. Please contact support.';
    }

    if (errorLower.contains('500') ||
        errorLower.contains('internal server')) {
      return 'Server error. Please try again later.';
    }

    return 'Unable to connect to server. Please check your internet connection.';
  }
}