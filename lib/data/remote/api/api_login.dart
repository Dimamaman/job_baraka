import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:job_baraka/data/remote/model/request/login_request.dart';
import 'package:job_baraka/data/remote/model/request/verify_request.dart';
import 'package:job_baraka/data/remote/model/response/log_out_response.dart';

import '../model/response/login_response.dart';
import '../model/response/verify_reponse.dart';

class ApiLogin {
  final _dio = Dio(BaseOptions(baseUrl: 'https://api.jobbaraka.uz/api'));

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      print("aaaaaaaaaaa ------------->>> ${request.toJson()}");

      final response = await _dio.post('/register', data: request.toJson());

      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return LoginResponse(message: "succes");
      } else {
        return LoginResponse(message: "error");
      }
    } catch (e) {
      return LoginResponse(message: e.toString());
    }
  }

  Future<VerifyResponse> verifyNumber(VerifyRequest request) async {
    try {
      print("aaaaaaaaaaa ------------->>> ${request.toJson()}");

      final response = await _dio.put('/verified-code', data: request.toJson());

      print("status code----->> ${response.statusCode}");
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return VerifyResponse.fromJson(response.data);
      }
    } catch (e) {
      print("catchqa tusti ->>>>>>>>> ${e.toString()}");

      return VerifyResponse(token: '', firstRegistered: false);
    }
    print("aqirna tusit->>>>>>>>> ");

    return VerifyResponse(token: '', firstRegistered: false);
  }

  Future<LogOutResponse> logOut(String token) async {
    try {
      print("api");

      final response = await _dio.post(
        "/logout",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print(response.statusCode);

     return LogOutResponse(response: true);
    } catch (e) {
      print("catchqa tusti ->>>>>>>>> ${e.toString()}");

      return LogOutResponse(response: false);

    }

  }
}

main() async {
  final api = ApiLogin();

  final request1 = await api.logOut('600|yjKpcVFmITHCGz6GwUJkOE5PtPB12XgE8KnKTCnK805a22bc');
  print("${request1.response}");
}
