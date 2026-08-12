import '../models/master_model.dart';
import '../services/master_service.dart';

class MasterRepository {
  final MasterService _service = MasterService();

  Future<List<MasterModel>> getMasters(String tableName) async {
    return await _service.getMasters(tableName);
  }

  Future<MasterModel> addMaster(String tableName, String name) async {
    return await _service.addMaster(tableName, name);
  }

  Future<MasterModel> updateMaster(
    String tableName,
    int id,
    String name,
    bool status,
  ) async {
    return await _service.updateMaster(tableName, id, name, status);
  }

  Future<void> deleteMaster(String tableName, int id) async {
    await _service.deleteMaster(tableName, id);
  }

  Future<void> toggleStatus(String tableName, int id, bool status) async {
    await _service.toggleStatus(tableName, id, status);
  }
}
