import 'dart:convert';
import 'package:gurukulam/core/utils/config.dart';
import 'package:http/http.dart' as http;

class SignUpService {
  // ==========================================
  // GET MASTERS (Industry & Location) - USING master_list.php ✅
  // ==========================================

  Future<List<Map<String, dynamic>>> getMasters(String tableName) async {
    try {
      // Use master_list.php like your backend expects
      final uri = Uri.parse('$baseUrl/master_list.php');

      final response = await http
          .post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'table': tableName},
      )
          .timeout(const Duration(seconds: 30));

      print('Get Masters URL: $uri');
      print('Get Masters Status: ${response.statusCode}');
      print('Get Masters Body: ${response.body}');

      if (response.statusCode != 200) {
        return [];
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      // Check different response formats
      if (data['success'] == true && data['data'] != null) {
        return List<Map<String, dynamic>>.from(data['data']);
      }

      if (data['data'] != null) {
        return List<Map<String, dynamic>>.from(data['data']);
      }

      // If data is directly the list
      if (data is List) {
        return List<Map<String, dynamic>>.from(data as Iterable<dynamic>);
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

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (data['success'] == false) {
      throw Exception(data['message'] ?? 'Sign up failed');
    }

    return data;
  }
}