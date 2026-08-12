class DepartmentModel {
  final String id;
  final String name;
  final String? companyId;

  DepartmentModel({
    required this.id,
    required this.name,
    this.companyId,
  });

  factory DepartmentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DepartmentModel(
      id: json['id'].toString(),
      name: json['department'] ??
          json['name'] ??
          'Unknown',
      companyId:
          json['companyid']?.toString(),
    );
  }
}

class UserModel {
  final String id;
  final String name;
  final String userType;

  final String departmentId;
  final String departmentName;

  final String companyId;
  final String companyName;

  final bool dashboard;
  final bool treatmentMaster;
  final bool categoryMaster;
  final bool salesEntry;

  final bool expensesEntry;
  final bool expensesCategory;
  final bool salesEntryReport;

  UserModel({
    required this.id,
    required this.name,
    required this.userType,
    required this.departmentId,
    required this.departmentName,
    required this.companyId,
    required this.companyName,
    required this.dashboard,
    required this.treatmentMaster,
    required this.categoryMaster,
    required this.salesEntry,
    required this.expensesEntry,
    required this.expensesCategory,
    required this.salesEntryReport,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserModel(
      id: json['id'].toString(),

      name: json['name']?.toString() ?? '',

      userType:
          json['user_type']?.toString() ?? '',

      departmentId:
          json['department'].toString(),

      departmentName:
          json['department_name']
                  ?.toString() ??
              '',

      companyId:
          json['company'].toString(),

      companyName:
          json['company_name']
                  ?.toString() ??
              '',

      dashboard:
          _toBool(json['dashboard']),

      treatmentMaster:
          _toBool(json['treatment_master']),

      categoryMaster:
          _toBool(json['category_master']),

      salesEntry:
          _toBool(json['sales_entry']),

      expensesEntry:
          _toBool(json['expenses_entry']),

      expensesCategory:
          _toBool(json['expenses_category']),

      salesEntryReport:
          _toBool(json['sales_entry_report']),
    );
  }

  static bool _toBool(dynamic value) {
    if (value == true) {
      return true;
    }

    if (value == 1) {
      return true;
    }

    if (value == '1') {
      return true;
    }

    return false;
  }
}

class LoginResponseModel {
  final bool success;
  final String message;
  final UserModel? user;

  LoginResponseModel({
    required this.success,
    required this.message,
    this.user,
  });

  factory LoginResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LoginResponseModel(
      success: json['success'] == true,

      message:
          json['message']?.toString() ?? '',

      user: json['user'] != null
          ? UserModel.fromJson(
              Map<String, dynamic>.from(
                json['user'],
              ),
            )
          : null,
    );
  }
}