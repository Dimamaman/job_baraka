class VerifyRequest {
  final String phone;
  final String code;

  VerifyRequest({
    required this.phone,
    required this.code,
  });

  Map<String, dynamic> toJson() => {'phone': phone, 'code': code};
}
