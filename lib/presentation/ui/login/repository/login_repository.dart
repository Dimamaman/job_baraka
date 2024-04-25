import 'package:job_baraka/data/remote/model/request/login_request.dart';
import 'package:job_baraka/data/remote/model/request/verify_request.dart';
import 'package:job_baraka/data/remote/model/response/log_out_response.dart';
import 'package:job_baraka/data/remote/model/response/login_response.dart';
import 'package:job_baraka/data/remote/model/response/verify_reponse.dart';

abstract class LoginRepository {
    Future<LoginResponse> login(LoginRequest request);
    Future<VerifyResponse> verifyNumber(VerifyRequest request);

}