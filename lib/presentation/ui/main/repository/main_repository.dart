import 'package:job_baraka/data/remote/model/response/call_history_response.dart';
import 'package:job_baraka/data/remote/model/response/get_all_services_response.dart';
import 'package:job_baraka/data/remote/model/response/get_workers_response.dart';
import 'package:job_baraka/data/remote/model/response/log_out_response.dart';

abstract class MainRepository{
  Future<LogOutResponse> logOut();
  Future<GetAllServicesResponse> getAllServices();

  Future<GetWorkersResponse> getWorkers(int serviceId, double lat, lng);

  callWorker(int workerId);

  Future<List<CallHistoryData>>  getCallHistory();

}