import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:gurukulam/core/utils/config.dart';

class LoginService {
  // ==========================================
  // Get departments by username
  // ==========================================

  Future<Map<String, dynamic>> getDepartments(
    String username,
  ) async {
    final uri = Uri.parse(
      '$baseUrl/get_user_department.php'
      '?username=${Uri.encodeComponent(username)}',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Server error: ${response.statusCode}',
      );
    }

    return jsonDecode(response.body)
        as Map<String, dynamic>;
  }

  // ==========================================
  // Login
  // ==========================================

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    required String department,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/login1.php',
    );

    final response = await http
        .post(
          uri,
          headers: {
            'Content-Type':
                'application/x-www-form-urlencoded',
          },
          body: {
            'username': username,
            'password': password,
            'department': department,
          },
        )
        .timeout(
          const Duration(seconds: 30),
        );

    if (response.statusCode != 200) {
      throw Exception(
        'Invalid Username or Password.',
      );
    }

    return jsonDecode(response.body)
        as Map<String, dynamic>;
  }
}