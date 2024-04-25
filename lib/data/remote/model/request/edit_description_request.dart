class EditDescriptionRequest {
  final String description;

  EditDescriptionRequest({
    required this.description,
  });

  Map<String, dynamic> toJson() => {'description': description};
}
