class CreateJobResponse {
  final bool? success;

  CreateJobResponse({
    required this.success,
  });

  factory CreateJobResponse.fromJson(Map<String, dynamic> json) {
    return CreateJobResponse(success: json['success']);
  }
}
