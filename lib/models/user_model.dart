class User {
  final int id;
  final String name;
  final String userType;
  final String email;
  final String mobile;
  final String role;
  final int? industryId;
  final int? locationId;
  final String status;
  final String? industryName;
  final String? locationName;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.userType,
    required this.email,
    required this.mobile,
    required this.role,
    this.industryId,
    this.locationId,
    required this.status,
    this.industryName,
    this.locationName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      userType: json['user_type'],
      email: json['email'],
      mobile: json['mobile'],
      role: json['role'],
      industryId: int.parse(json['industry_id'].toString()),
      locationId: int.parse(json['location_id'].toString()),
      status: json['status'],
      industryName: json['industry_name'],
      locationName: json['location_name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'user_type': userType,
      'email': email,
      'mobile': mobile,
      'role': role,
      'industry_id': industryId,
      'location_id': locationId,
      'status': status,
      'industry_name': industryName,
      'location_name': locationName,
    };
  }
}
