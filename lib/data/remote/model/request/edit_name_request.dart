class EditNameRequest {
  final String name;

  EditNameRequest({
    required this.name,
  });

  Map<String, dynamic> toJson() => {'name': name};
}
