import 'package:flutter/material.dart';
import 'package:gurukulam/models/signup_model.dart';
import 'package:gurukulam/repositories/signup_repo.dart';

class SignUpViewModel extends ChangeNotifier {
  final SignUpRepository _repository;

  SignUpViewModel({
    SignUpRepository? repository,
  }) : _repository = repository ?? SignUpRepository();

  // ==========================================
  // State Variables
  // ==========================================

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;
  SignUpModel? _user;

  // Dropdown data
  List<dynamic> _industries = [];
  List<dynamic> _locations = [];
  bool _isLoadingDropdowns = false;

  // ==========================================
  // Getters
  // ==========================================

  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  String? get errorMessage => _errorMessage;
  SignUpModel? get user => _user;
  List<dynamic> get industries => _industries;
  List<dynamic> get locations => _locations;
  bool get isLoadingDropdowns => _isLoadingDropdowns;

  // ==========================================
  // Password Visibility
  // ==========================================

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  // ==========================================
  // Load Industries & Locations
  // ==========================================

  Future<void> loadIndustryAndLoc() async {
    _isLoadingDropdowns = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _repository.getIndustryAndLoc();

      if (data.containsKey('industries')) {
        _industries = data['industries'] ?? [];
      }

      if (data.containsKey('locations')) {
        _locations = data['locations'] ?? [];
      }

      print('Industries loaded: ${_industries.length}');
      print('Locations loaded: ${_locations.length}');
    } catch (e) {
      _errorMessage = 'Failed to load data. Please try again.';
      print('Error loading dropdowns: $e');
    } finally {
      _isLoadingDropdowns = false;
      notifyListeners();
    }
  }

  // ==========================================
  // Sign Up
  // ==========================================

  Future<bool> signUp({
    required String name,
    required String mobile,
    required String email,
    required String password,
    int? industryId,
    int? locationId,
  }) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _repository.signUp(
        name: name.trim(),
        mobile: mobile.trim(),
        email: email.trim(),
        password: password.trim(),
        industryId: industryId,
        locationId: locationId,
      );

      if (response.success && response.user != null) {
        _user = response.user;
        return true;
      }

      _errorMessage = _getSignUpErrorMessage(response.message);
      return false;
    } catch (e) {
      _errorMessage = _getUserFriendlyError(e.toString());
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
  // Error Messages
  // ==========================================

  String _getSignUpErrorMessage(String message) {
    final error = message.toLowerCase();

    if (error.contains('duplicate') || error.contains('already exists')) {
      return 'User already exists. Please try with different credentials.';
    }

    if (error.contains('mobile')) {
      return 'Invalid mobile number. Please enter a 10-digit number.';
    }

    if (error.contains('email')) {
      return 'Invalid email address. Please enter a valid email.';
    }

    if (error.contains('password')) {
      return 'Password must be at least 8 characters with letters and numbers.';
    }

    if (error.contains('industry') || error.contains('role')) {
      return 'Please select a valid role.';
    }

    if (error.contains('location')) {
      return 'Please select a valid location.';
    }

    return message.isNotEmpty ? message : 'Sign up failed. Please try again.';
  }

  String _getUserFriendlyError(String error) {
    final errorLower = error.toLowerCase();

    if (errorLower.contains('timeout')) {
      return 'Connection timeout. Please check your internet connection.';
    }

    if (errorLower.contains('socket') ||
        errorLower.contains('network') ||
        errorLower.contains('connection')) {
      return 'Network error. Please check your internet connection.';
    }

    if (errorLower.contains('ssl') || errorLower.contains('certificate')) {
      return 'SSL connection error. Please contact support.';
    }

    if (errorLower.contains('404') || errorLower.contains('not found')) {
      return 'Server endpoint not found. Please contact support.';
    }

    if (errorLower.contains('500') || errorLower.contains('internal server')) {
      return 'Server error. Please try again later.';
    }

    return 'Unable to connect to server. Please check your internet connection.';
  }
}