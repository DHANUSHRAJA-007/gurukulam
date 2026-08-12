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
    required String department,
  }) async {
    final response =
        await _loginService.login(
      username: username,
      password: password,
      department: department,
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

    await prefs.setString(
      AppConstants.departmentId,
      user.departmentId,
    );

    await prefs.setString(
      AppConstants.departmentName,
      user.departmentName,
    );

    await prefs.setString(
      AppConstants.companyId,
      user.companyId,
    );

    await prefs.setString(
      AppConstants.companyName,
      user.companyName,
    );

    await prefs.setBool(
      AppConstants.dashboard,
      user.dashboard,
    );

    await prefs.setBool(
      AppConstants.treatmentMaster,
      user.treatmentMaster,
    );

    await prefs.setBool(
      AppConstants.categoryMaster,
      user.categoryMaster,
    );

    await prefs.setBool(
      AppConstants.salesEntry,
      user.salesEntry,
    );

    await prefs.setBool(
      AppConstants.expensesEntry,
      user.expensesEntry,
    );

    await prefs.setBool(
      AppConstants.expensesCategory,
      user.expensesCategory,
    );

    await prefs.setBool(
      AppConstants.salesEntryReport,
      user.salesEntryReport,
    );

    await prefs.setBool(
      AppConstants.isLoggedIn,
      true,
    );
  }
}