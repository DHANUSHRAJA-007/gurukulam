import 'package:flutter/material.dart';
import '../repositories/job_repository.dart';

class JobViewModel extends ChangeNotifier {
  final JobRepository _repository;

  JobViewModel({
    JobRepository? repository,
  }) : _repository =
            repository ?? JobRepository();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage =>
      _errorMessage;

  Future<bool> createJob(
    Map<String, dynamic> data,
  ) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final result =
          await _repository.createJob(data);

      return result;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}