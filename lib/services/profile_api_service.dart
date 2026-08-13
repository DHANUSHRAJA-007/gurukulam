import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constant/app_constant.dart';
import '../core/utils/config.dart';
import '../models/api_response.dart';
import '../models/user_model.dart';

class ProfileApiService {
  static Future<ApiResponse<User>> getUserProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(AppConstants.userId);
      final response = await http.get(
        Uri.parse('$baseUrl/get_user_profile.php?user_id=$userId'),

        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return ApiResponse(
          success: true,
          message: data['message'],
          data: User.fromJson(data['data']),
        );
      } else {
        return ApiResponse(
          success: false,
          message: data['message'] ?? 'Failed to fetch profile',
        );
      }
    } catch (e) {
      print(e);
      return ApiResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  static Future<ApiResponse> updateProfile(Map<String, dynamic> updates) async {
    try {
      print(updates);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(AppConstants.userId);
      final response = await http.post(
        Uri.parse('$baseUrl/update_user_profile.php?user_id=$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updates),
      );

      final data = jsonDecode(response.body);

      return ApiResponse(
        success: response.statusCode == 200 && data['success'],
        message: data['message'] ?? 'Profile update failed',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }
}
