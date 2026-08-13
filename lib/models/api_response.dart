class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({required this.success, required this.message, this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }

  // factory ApiResponse.fromJsonList(
  //     Map<String, dynamic> json,
  //     T Function(dynamic) fromJsonT,
  //     ) {
  //   final dataList = json['data'] as List?;
  //   return ApiResponse(
  //     success: json['success'],
  //     message: json['message'],
  //     data: dataList != null
  //         ? dataList.map((item) => fromJsonT(item)).toList().cast<T>()
  //         : null,
  //   );
  // }
}
