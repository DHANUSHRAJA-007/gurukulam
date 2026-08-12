import 'package:shared_preferences/shared_preferences.dart';

import 'package:gurukulam/core/constant/app_constant.dart';
import 'package:gurukulam/models/login_model.dart';
import 'package:gurukulam/services/login_service.dart';

class LoginRepository {
  final LoginService _loginService;

  LoginRepository({
    LoginService? loginService,
  }) : _loginService =
            loginService ?? LoginService();

 

  // ==========================================
  // Login
  // ==========================================

  Future<LoginResponseModel> login({
    required String username,
    required String password,
  }) async {
    final response =
        await _loginService.login(
      username: username,
      password: password
    );

    return LoginResponseModel.fromJson(
      response,
    );
  }

  // ==========================================
  // Save User Session
  // ==========================================

  Future<void> saveUserData(
    UserModel user,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      AppConstants.userId,
      user.id,
    );

    await prefs.setString(
      AppConstants.username,
      user.name,
    );

    await prefs.setString(
      AppConstants.userType,
      user.userType,
    );

    await prefs.setBool(
      AppConstants.isLoggedIn,
      true,
    );
  }
}