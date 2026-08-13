import 'dart:convert';

import 'package:gurukulam/core/utils/config.dart';
import 'package:http/http.dart' as http;

class LoginService {
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/login.php');

    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {'username': username, 'password': password},
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception('Invalid Username or Password.');
    }
    print(response.body);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
