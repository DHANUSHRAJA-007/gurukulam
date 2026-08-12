class MasterModel {
  final int id;
  final String name;
  final bool status;

  MasterModel({
    required this.id,
    required this.name,
    required this.status,
  });

  factory MasterModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MasterModel(
      id: int.tryParse(
            json['id'].toString(),
          ) ??
          0,

      name: json['name']?.toString() ?? '',

      status:
          json['status'].toString() == '1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status ? 1 : 0,
    };
  }

  MasterModel copyWith({
    int? id,
    String? name,
    bool? status,
  }) {
    return MasterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }
}

// lib/models/master_type.dart
enum MasterType {
  industry('industry_master', 'Industry'),
  category('category_master', 'Category'),
  subCategory('sub_category_master', 'Sub Category'),
  brand('brand_master', 'Brand'),
  unit('unit_master', 'Unit'),
  tax('tax_master', 'Tax');

  final String tableName;
  final String displayName;

  const MasterType(this.tableName, this.displayName);
}
