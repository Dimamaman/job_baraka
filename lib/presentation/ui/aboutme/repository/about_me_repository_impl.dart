import 'package:job_baraka/data/local/shared_preferences.dart';
import 'package:job_baraka/data/remote/api/api_profil.dart';
import 'package:job_baraka/data/remote/model/request/create_job_request.dart';
import 'package:job_baraka/data/remote/model/response/create_job_response.dart';
import 'package:job_baraka/data/remote/model/response/get_all_services_response.dart';
import 'package:job_baraka/presentation/ui/aboutme/repository/about_me_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutMeRepositoryImpl extends AboutMeRepository{
  final _api = ApiProfile();
  final pref = SharedPref.instance;


  @override
  Future<GetAllServicesResponse> getAllServices() async {

    final token = pref.getString("TOKEN");

    final response = await _api.getAllService(token!);

    return response;
  }

  @override
  Future<CreateJobResponse> createJob(CreateJobRequest request) async {

    final token = pref.getString("TOKEN");

    final response = await _api.createJob(request, token!);

    return response;
  }

  @override
  Future<void> editJob(int serviceId) async {

    final token = pref.getString("TOKEN");

    final response = await _api.editJob(serviceId, token!);


  }

}