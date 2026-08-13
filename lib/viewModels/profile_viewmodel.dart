import 'package:flutter/material.dart';

import '../models/master_model.dart';
import '../models/user_model.dart';
import '../services/master_service.dart';
import '../services/profile_api_service.dart';

class ProfileViewModel extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  List<MasterModel> _industries = [];
  List<MasterModel> _locations = [];
  bool _isLoadingMasters = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;
  List<MasterModel> get locations => _locations;
  List<MasterModel> get industries => _industries;
  bool get isLoadingMasters => _isLoadingMasters;

  Future<void> loadIndustryAndLoc() async {
    _isLoadingMasters = true;
    notifyListeners();

    try {
      final res = await Future.wait([
        MasterService().getMasters('industry'),
        MasterService().getMasters('location'),
      ]);
      _locations = res[1];
      _industries = res[0];
    } catch (e) {
      _errorMessage = 'Failed to load industries and locations';
    } finally {
      _isLoadingMasters = false;
      notifyListeners();
    }
  }

  Future<bool> loadUserProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await ProfileApiService.getUserProfile();

    _isLoading = false;

    if (response.success && response.data != null) {
      _user = response.data;
      notifyListeners();
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }

  // Update Profile
  Future<bool> updateProfile(Map<String, dynamic> updates) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await ProfileApiService.updateProfile(updates);

    _isLoading = false;

    if (response.success) {
      // Refresh user data
      await loadUserProfile();
      return true;
    } else {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }
  }

  // Update single field
  Future<bool> updateField(String key, dynamic value) async {
    return await updateProfile({key: value});
  }

  // Get industry name by ID
  String? getIndustryName(int? id) {
    if (id == null) return null;
    return _industries
        .firstWhere(
          (industry) => industry.id == id,
          orElse: () => MasterModel(id: 0, name: '', status: false),
        )
        .name;
  }

  // Get location name by ID
  String? getLocationName(int? id) {
    if (id == null) return null;
    return _locations
        .firstWhere(
          (location) => location.id == id,
          orElse: () => MasterModel(id: 0, name: '', status: false),
        )
        .name;
  }
}
