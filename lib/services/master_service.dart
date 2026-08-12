import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../core/utils/config.dart';
import '../models/master_model.dart';

class MasterService {
  // Future<List<MasterModel>> getMasters(String tableName) async {
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/master_list.php?master=$tableName'),
  //   );

  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     return data.map((json) => MasterModel.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load masters');
  //   }
  // }
  Future<List<MasterModel>> getMasters(String masterType) async {
    final url = Uri.parse('$baseUrl/master_list.php?master=$masterType');

    debugPrint('MASTER API: $url');

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json'},
    );

    debugPrint('MASTER STATUS: ${response.statusCode}');

    debugPrint('MASTER RESPONSE: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load masters: '
        '${response.statusCode}',
      );
    }

    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (responseData['success'] != true) {
      throw Exception(responseData['message'] ?? 'Failed to load masters');
    }

    final List<dynamic> data = responseData['data'] ?? [];

    return data.map((item) {
      return MasterModel.fromJson(item as Map<String, dynamic>);
    }).toList();
  }

  Future<bool> insertMaster({
  required String masterType,
  required String value,
}) async {
  final response = await http.post(
    Uri.parse(
      '$baseUrl/master_insert.php',
    ),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'master': masterType,
      'value': value,
    },
  );

  debugPrint('INSERT STATUS: ${response.statusCode}');
  debugPrint('INSERT RESPONSE: ${response.body}');

  if (response.statusCode != 200) {
    throw Exception(
      'Failed to insert ${value}',
    );
  }

  final Map<String, dynamic> data =
      jsonDecode(response.body);

  if (data['success'] == true) {
    return true;
  }

  throw Exception(
    data['message'] ?? 'Failed to add record',
  );
}

  Future<bool> updateMaster({
  required String masterType,
  required int id,
  required String value,
}) async {
  final url = Uri.parse(
    '$baseUrl/master_update.php',
  );

  debugPrint('UPDATE URL: $url');
  debugPrint('UPDATE MASTER: $masterType');
  debugPrint('UPDATE ID: $id');
  debugPrint('UPDATE VALUE: $value');

  final response = await http.post(
    url,
    headers: {
      'Content-Type':
          'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    },
    body: {
      'master': masterType,
      'id': id.toString(),
      'value': value,
    },
  );

  debugPrint(
    'UPDATE STATUS: ${response.statusCode}',
  );

  debugPrint(
    'UPDATE RESPONSE: ${response.body}',
  );

  if (response.statusCode != 200) {
    throw Exception(
      'Update failed: HTTP ${response.statusCode}',
    );
  }

  final Map<String, dynamic> data =
      jsonDecode(response.body);

  if (data['success'] == true) {
    return true;
  }

  throw Exception(
    data['message'] ??
        'Failed to update record',
  );
}

  Future<bool> deleteMaster({
  required String masterType,
  required int id,
}) async {
  final url = Uri.parse(
    '$baseUrl/master_delete.php',
  );

  debugPrint('DELETE URL: $url');
  debugPrint('DELETE MASTER: $masterType');
  debugPrint('DELETE ID: $id');

  final response = await http.post(
    url,
    headers: {
      'Content-Type':
          'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    },
    body: {
      'master': masterType,
      'id': id.toString(),
    },
  );

  debugPrint(
    'DELETE STATUS: ${response.statusCode}',
  );

  debugPrint(
    'DELETE RESPONSE: ${response.body}',
  );

  if (response.statusCode != 200) {
    throw Exception(
      'Delete failed: HTTP ${response.statusCode}',
    );
  }

  final Map<String, dynamic> data =
      jsonDecode(response.body);

  if (data['success'] == true) {
    return true;
  }

  throw Exception(
    data['message'] ??
        'Failed to delete record',
  );
}

  Future<void> toggleStatus(
  String masterType,
  int id,
  bool status,
) async {
  final response = await http.post(
    Uri.parse(
      '$baseUrl/master_update_status.php',
    ),
    headers: {
      'Content-Type':
          'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    },
    body: {
      'master': masterType,
      'id': id.toString(),
      'status': status ? '1' : '0',
    },
  );

  debugPrint(
    'STATUS UPDATE: ${response.statusCode}',
  );

  debugPrint(
    'STATUS RESPONSE: ${response.body}',
  );

  if (response.statusCode != 200) {
    throw Exception(
      'Failed to update status',
    );
  }

  final data =
      jsonDecode(response.body);

  if (data['success'] != true) {
    throw Exception(
      data['message'] ??
          'Failed to update status',
    );
  }
}
}
