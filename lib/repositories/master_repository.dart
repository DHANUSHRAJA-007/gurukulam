import '../models/master_model.dart';
import '../services/master_service.dart';

class MasterRepository {
  final MasterService _service = MasterService();

  Future<List<MasterModel>> getMasters(String tableName) async {
    return await _service.getMasters(tableName);
  }

  Future<bool> addMaster({
  required String masterType,
  required String value,
}) async {
  return await _service.insertMaster(
    masterType: masterType,
    value: value,
  );
}

  Future<bool> updateMaster({
  required String masterType,
  required int id,
  required String value,
}) async {
  return await _service.updateMaster(
    masterType: masterType,
    id: id,
    value: value,
  );
}

  Future<bool> deleteMaster({
  required String masterType,
  required int id,
}) async {
  return await _service.deleteMaster(
    masterType: masterType,
    id: id,
  );
}

  Future<void> toggleStatus(String tableName, int id, bool status) async {
    await _service.toggleStatus(tableName, id, status);
  }
}
