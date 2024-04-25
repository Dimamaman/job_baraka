class DefaultResponse {
  final bool? success;

  DefaultResponse({
    required this.success,
  });

  factory DefaultResponse.fromJson(Map<String, dynamic> json) {
    return DefaultResponse(success: json['success']);
  }
}
