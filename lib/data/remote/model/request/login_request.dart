class LoginRequest {
  final String phone;

  LoginRequest({
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
    'phone' : phone
  };
}
