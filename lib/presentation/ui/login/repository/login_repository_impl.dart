import 'package:job_baraka/data/remote/api/api_login.dart';
import 'package:job_baraka/data/remote/model/request/login_request.dart';
import 'package:job_baraka/data/remote/model/request/verify_request.dart';
import 'package:job_baraka/data/remote/model/response/log_out_response.dart';
import 'package:job_baraka/data/remote/model/response/login_response.dart';
import 'package:job_baraka/data/remote/model/response/verify_reponse.dart';
import 'package:job_baraka/presentation/ui/login/repository/login_repository.dart';

class LoginRepositoryImpl extends LoginRepository {

  final _api = ApiLogin();

  @override
  Future<LoginResponse> login(LoginRequest request) async{
    final response =  await _api.login(request);

    return response;
  }

  @override
  Future<VerifyResponse> verifyNumber(VerifyRequest request)  async{
    final response = await _api.verifyNumber(request);

    return response;
  }



}