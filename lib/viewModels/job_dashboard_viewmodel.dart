import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/job_model.dart';
import '../services/job_dashboard_api_service.dart';

class JobDashboardViewModel extends ChangeNotifier {
  final JobDashboardApiService _apiService = JobDashboardApiService();

  List<JobsModel> _jobs = [];
  List<JobsModel> _filteredJobs = [];
  bool _isLoading = false;
  String? _error;
  String _username = 'User';
  // Filter properties
  String? _selectedIndustry;
  String? _selectedLocation;
  String? _searchQuery;

  List<JobsModel> get jobs => _filteredJobs.isEmpty ? _jobs : _filteredJobs;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get selectedIndustry => _selectedIndustry;
  String? get selectedLocation => _selectedLocation;
  String? get searchQuery => _searchQuery;
  String get username => _username;

  // Get unique industries and locations for filters
  List<String> get industries {
    final Set<String> uniqueIndustries = {};
    for (var job in _jobs) {
      if (job.industryName != null && job.industryName!.isNotEmpty) {
        uniqueIndustries.add(job.industryName!);
      }
    }
    return uniqueIndustries.toList()..sort();
  }

  List<String> get locations {
    final Set<String> uniqueLocations = {};
    for (var job in _jobs) {
      if (job.location != null && job.location!.isNotEmpty) {
        uniqueLocations.add(job.location!);
      }
    }
    return uniqueLocations.toList()..sort();
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
    }
  }

  void setIndustryFilter(String? industry) {
    _selectedIndustry = industry;
    _applyFilters();
  }

  void setLocationFilter(String? location) {
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
      bool matchesIndustry =
          _selectedIndustry == null ||
          _selectedIndustry!.isEmpty ||
          job.industryName == _selectedIndustry;

      bool matchesLocation =
          _selectedLocation == null ||
          _selectedLocation!.isEmpty ||
          job.location == _selectedLocation;

      bool matchesSearch =
          _searchQuery == null ||
          _searchQuery!.isEmpty ||
          job.jobRoleName?.toLowerCase().contains(
                _searchQuery!.toLowerCase(),
              ) ==
              true ||
          job.industryName?.toLowerCase().contains(
                _searchQuery!.toLowerCase(),
              ) ==
              true ||
          job.jobDescription?.toLowerCase().contains(
                _searchQuery!.toLowerCase(),
              ) ==
              true;

      return matchesIndustry && matchesLocation && matchesSearch;
    }).toList();

    notifyListeners();
  }
}
