import 'package:flutter/material.dart';

import '../models/master_model.dart';
import '../repositories/master_repository.dart';

class MasterViewModel extends ChangeNotifier {
  final MasterRepository _repository = MasterRepository();
  final String tableName;
  final String title;

  List<MasterModel> _masters = [];
  bool _isLoading = false;
  String? _errorMessage;

  MasterViewModel({required this.tableName, required this.title});

  List<MasterModel> get masters => _masters;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Future<void> loadMasters() async {
  //   print("call");
  //   _isLoading = true;
  //   _errorMessage = null;
  //   _masters = [];
  //   notifyListeners();
  //
  //   try {
  //     _masters = await _repository.getMasters(tableName);
  //     _isLoading = false;
  //     notifyListeners();
  //   } catch (e) {
  //     _isLoading = false;
  //     _errorMessage = 'Failed to load ${title.toLowerCase()}s';
  //     notifyListeners();
  //     rethrow;
  //   }
  // }
  // In MasterViewModel.dart
  Future<void> loadMasters() async {
    print("🔄 Loading masters for table: $tableName");
    _isLoading = true;
    _errorMessage = null;
    _masters = [];
    notifyListeners();

    try {
      _masters = await _repository.getMasters(tableName);
      print("✅ Loaded ${_masters.length} masters");
      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      print("❌ Error loading masters: $e");
      print("Stack trace: $stackTrace");
      _isLoading = false;
      _errorMessage = 'Failed to load ${title.toLowerCase()}s: $e';
      notifyListeners();
      // Don't rethrow here - let the UI show the error
    }
  }

  Future<void> addMaster(String value) async {
    try {
      await _repository.addMaster(masterType: tableName, value: value);

      await loadMasters();
    } catch (e) {
      debugPrint('Add master error: $e');

      rethrow;
    }
  }

  Future<void> updateMaster(int id, String value, bool status) async {
    try {
      await _repository.updateMaster(
        masterType: tableName,
        id: id,
        value: value,
      );

      await loadMasters();
    } catch (e) {
      debugPrint('Update master error: $e');

      rethrow;
    }
  }

  Future<void> deleteMaster(int id) async {
    try {
      await _repository.deleteMaster(masterType: tableName, id: id);

      await loadMasters();
    } catch (e) {
      debugPrint('Delete master error: $e');

      rethrow;
    }
  }

  Future<void> toggleStatus(int id, bool currentStatus) async {
    try {
      await _repository.toggleStatus(tableName, id, !currentStatus);
      final index = _masters.indexWhere((m) => m.id == id);
      if (index != -1) {
        _masters[index] = _masters[index].copyWith(status: !currentStatus);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to toggle status';
      notifyListeners();
      rethrow;
    }
  }
}
