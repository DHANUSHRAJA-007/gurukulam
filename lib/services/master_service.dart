import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/utils/config.dart';
import '../models/master_model.dart';

class MasterService {
  Future<List<MasterModel>> getMasters(String tableName) async {
    final response = await http.get(
      Uri.parse('$baseUrl/master_list.php?master=$tableName'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => MasterModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load masters');
    }
  }

  Future<MasterModel> addMaster(String tableName, String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/master_insert.php?master=$tableName'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name}),
    );

    if (response.statusCode == 201) {
      return MasterModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add master');
    }
  }

  Future<MasterModel> updateMaster(
    String tableName,
    int id,
    String name,
    bool status,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/master_update.php?master=$tableName'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': id, 'status': status ? 1 : 0}),
    );

    if (response.statusCode == 200) {
      return MasterModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update master');
    }
  }

  Future<void> deleteMaster(String tableName, int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/master_delete.php?master=$tableName'),
      body: json.encode({'id': id}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete master');
    }
  }

  Future<void> toggleStatus(String tableName, int id, bool status) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/master_update_status.php?master=$tableName'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': id, 'status': status ? 1 : 0}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to toggle status');
    }
  }
}
