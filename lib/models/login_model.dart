class UserModel {
  final String id;
  final String name;
  final String userType;

  UserModel({
    required this.id,
    required this.name,
    required this.userType,
   
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserModel(
      id: json['id'].toString(),

      name: json['name']?.toString() ?? '',

      userType:
          json['user_type']?.toString() ?? '',

    );
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