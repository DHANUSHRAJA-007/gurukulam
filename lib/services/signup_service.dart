import 'dart:convert';
import 'package:gurukulam/core/utils/config.dart';
import 'package:http/http.dart' as http;

class SignUpService {
  // ==========================================
  // GET MASTERS (Industry & Location)
  // ==========================================

  Future<List<dynamic>> getMasters(String tableName) async {
    try {
      final uri = Uri.parse('$baseUrl/get_masters.php?table=$tableName');

      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 30));

      print('Get Masters Response: ${response.body}');

      if (response.statusCode != 200) {
        return [];
      }

      final data = jsonDecode(response.body);

      if (data['success'] == true && data['data'] != null) {
        return data['data'] as List<dynamic>;
      }

      return [];
    } catch (e) {
      print('Error loading $tableName: $e');
      return [];
    }
  }

  // ==========================================
  // SIGN UP
  // ==========================================

  Future<Map<String, dynamic>> signUp({
    required String name,
    required String mobile,
    required String email,
    required String password,
    int? industryId,
    int? locationId,
  }) async {
    final uri = Uri.parse('$baseUrl/signup.php');

    final body = {
      'name': name,
      'mobile': mobile,
      'email': email,
      'password': password,
      'industry_id': industryId?.toString() ?? '',
      'location_id': locationId?.toString() ?? '',
    };

    print('SignUp Request Body: $body');

    final response = await http
        .post(
      uri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    )
        .timeout(const Duration(seconds: 30));

    print('SignUp Response: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Sign up failed. Please try again.');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}