class CreateJobRequest {
  final String description;
  final int serviceId;

  CreateJobRequest({
    required this.description,
    required this.serviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'service_id': serviceId,
    };
  }
}
