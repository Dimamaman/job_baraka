import 'package:job_baraka/data/local/shared_preferences.dart';
import 'package:job_baraka/data/remote/api/api_login.dart';
import 'package:job_baraka/data/remote/api/api_profil.dart';
import 'package:job_baraka/data/remote/model/response/call_history_response.dart';
import 'package:job_baraka/data/remote/model/response/get_all_services_response.dart';
import 'package:job_baraka/data/remote/model/response/get_workers_response.dart';
import 'package:job_baraka/data/remote/model/response/log_out_response.dart';
import 'package:job_baraka/presentation/ui/main/repository/main_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainRepositoryImpl extends MainRepository {
  final _apiLogin = ApiLogin();
  final _apiProfile = ApiProfile();
  final SharedPreferences pref = SharedPref.instance;

  @override
  Future<LogOutResponse> logOut() async {
    final token = pref.getString("TOKEN");
    final response = await _apiLogin.logOut(token!);

    print(token);
    pref.setBool("LOGIN", false);
    print("response -> ${response.response}");
    return response;
  }

  @override
  Future<GetAllServicesResponse> getAllServices() async {

    final token = pref.getString("TOKEN");

    final response = await _apiProfile.getAllService(token!);

    return response;
  }

  @override
  Future<GetWorkersResponse> getWorkers(int serviceId, double lat, lng) async {

    final token = pref.getString("TOKEN");

    final response = await _apiProfile.getWorkers(serviceId,lat,lng,token!);

    return response;
  }

  @override
  callWorker(int workerId) {
    final token = pref.getString("TOKEN");

    final response =  _apiProfile.callWorker(workerId,token!);

  }

  @override
  Future<List<CallHistoryData>> getCallHistory() async {
    final token = pref.getString("TOKEN");
    final response = await  _apiProfile.getCallHistory(token!);

    return response;
  }


}
