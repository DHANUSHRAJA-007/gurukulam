import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class JobService {
  final String baseUrl =
      'https://gurukulamapi.futureinfotechservices.in';

  Future<bool> createJob(
    Map<String, dynamic> data,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/job_insert.php'),
      headers: {
        'Content-Type':
            'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(data),
    );

    debugPrint(
      'CREATE JOB STATUS: ${response.statusCode}',
    );

    debugPrint(
      'CREATE JOB RESPONSE: ${response.body}',
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to create job',
      );
    }

    final result =
        jsonDecode(response.body);

    if (result['success'] == true) {
      return true;
    }

    throw Exception(
      result['message'] ??
          'Failed to create job',
    );
  }

  Future<List<dynamic>> getJobs() async {
  final response = await http.get(
    Uri.parse(
      '$baseUrl/job_list.php',
    ),
  );

  debugPrint(
    'JOB LIST STATUS: ${response.statusCode}',
  );

  debugPrint(
    'JOB LIST RESPONSE: ${response.body}',
  );

  if (response.statusCode != 200) {
    throw Exception(
      'Failed to load jobs',
    );
  }

  final result =
      jsonDecode(response.body);

  if (result['success'] == true) {
    return result['data'] ?? [];
  }

  throw Exception(
    result['message'] ??
        'Failed to load jobs',
  );
}
}