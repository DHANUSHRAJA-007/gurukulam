class SignUpModel {
  final String id;
  final String name;
  final String mobile;
  final String email;
  final String userType;

  SignUpModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.userType,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      userType: json['user_type']?.toString() ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'email': email,
      'user_type': userType,
    };
  }
}

class SignUpResponseModel {
  final bool success;
  final String message;
  final SignUpModel? user;

  SignUpResponseModel({
    required this.success,
    required this.message,
    this.user,
  });

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    return SignUpResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      user: json['user'] != null
          ? SignUpModel.fromJson(Map<String, dynamic>.from(json['user']))
          : null,
    );
  }
}