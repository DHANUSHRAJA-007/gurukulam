import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/job_model.dart';
import '../models/master_model.dart';
import '../services/job_dashboard_api_service.dart';
import '../services/master_service.dart';

class JobDashboardViewModel extends ChangeNotifier {
  final JobDashboardApiService _apiService = JobDashboardApiService();

  List<JobsModel> _jobs = [];
  List<JobsModel> _filteredJobs = [];
  bool _isLoading = false;
  String? _error;
  String _username = 'User';

  // Filter properties
  MasterModel? _selectedIndustry;
  MasterModel? _selectedLocation;
  String? _searchQuery;
  List<MasterModel> _industries = [];
  List<MasterModel> _locations = [];

  List<JobsModel> get jobs => _filteredJobs;
  bool get isLoading => _isLoading;
  String? get error => _error;
  MasterModel? get selectedIndustry => _selectedIndustry;
  MasterModel? get selectedLocation => _selectedLocation;
  String? get searchQuery => _searchQuery;
  String get username => _username;
  List<MasterModel> get locations => _locations;
  List<MasterModel> get industries => _industries;

  Future<void> loadIndustryAndLoc() async {
    try {
      final res = await Future.wait([
        MasterService().getMasters('industry'),
        MasterService().getMasters('location'),
      ]);
      _locations = res[1];
      _industries = res[0];
    } catch (e) {
      // _errorMessage = 'Failed to load industries and locations';
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchJobs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _username = prefs.getString('username') ?? 'User';
      _jobs = await _apiService.fetchJobs();

      _filteredJobs = List.from(_jobs);
      _applyFilters();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
      loadIndustryAndLoc();
    }
  }

  void setIndustryFilter(MasterModel? industry) {
    _selectedIndustry = industry;
    _applyFilters();
  }

  void setLocationFilter(MasterModel? location) {
    _selectedLocation = location;
    _applyFilters();
  }

  void setSearchQuery(String? query) {
    _searchQuery = query;
    _applyFilters();
  }

  void clearFilters() {
    _selectedIndustry = null;
    _selectedLocation = null;
    _searchQuery = null;
    _filteredJobs = List.from(_jobs);
    notifyListeners();
  }

  void _applyFilters() {
    _filteredJobs = _jobs.where((job) {
      // Fix: Compare industry name string with selected industry's string value
      bool matchesIndustry =
          _selectedIndustry == null ||
          (job.industryName != null &&
              _selectedIndustry != null &&
              job.industryName!.toLowerCase() ==
                  _selectedIndustry!.toString().toLowerCase());

      // Fix: Compare location string with selected location's string value
      bool matchesLocation =
          _selectedLocation == null ||
          (job.location != null &&
              _selectedLocation != null &&
              job.location!.toLowerCase() ==
                  _selectedLocation!.toString().toLowerCase());

      // Fix: Search query should check if any field contains the search term
      bool matchesSearch =
          _searchQuery == null ||
          _searchQuery!.isEmpty ||
          (job.jobRoleName != null &&
              job.jobRoleName!.toLowerCase().contains(
                _searchQuery!.toLowerCase(),
              )) ||
          (job.industryName != null &&
              job.industryName!.toLowerCase().contains(
                _searchQuery!.toLowerCase(),
              )) ||
          (job.jobDescription != null &&
              job.jobDescription!.toLowerCase().contains(
                _searchQuery!.toLowerCase(),
              )) ||
          (job.location != null &&
              job.location!.toLowerCase().contains(
                _searchQuery!.toLowerCase(),
              ));

      return matchesIndustry && matchesLocation && matchesSearch;
    }).toList();

    notifyListeners();
  }
}
