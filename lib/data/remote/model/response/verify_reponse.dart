class VerifyResponse {
  final String token;
  final bool firstRegistered;

  VerifyResponse({
    required this.token,
    required this.firstRegistered,
  });

  factory VerifyResponse.fromJson(Map<String,dynamic> json) {
    return VerifyResponse(
        token: json['token'],
        firstRegistered: json['first_registered']);
  }



}
