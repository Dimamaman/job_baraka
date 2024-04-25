class ResponseData {
  final bool? success;
  String? error;

  ResponseData({
    required this.success,
    this.error
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(success: json['success']);
  }
}
