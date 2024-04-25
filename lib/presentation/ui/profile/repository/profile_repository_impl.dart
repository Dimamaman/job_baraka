import 'package:job_baraka/data/local/shared_preferences.dart';
import 'package:job_baraka/data/remote/api/api_login.dart';
import 'package:job_baraka/data/remote/api/api_profil.dart';
import 'package:job_baraka/data/remote/model/request/add_worker_location_request.dart';
import 'package:job_baraka/data/remote/model/request/create_job_request.dart';
import 'package:job_baraka/data/remote/model/request/edit_avatart_request.dart';
import 'package:job_baraka/data/remote/model/request/edit_description_request.dart';
import 'package:job_baraka/data/remote/model/request/edit_district_request.dart';
import 'package:job_baraka/data/remote/model/request/edit_is_working_request.dart';
import 'package:job_baraka/data/remote/model/request/edit_name_request.dart';
import 'package:job_baraka/data/remote/model/response/edit_district_response.dart';
import 'package:job_baraka/data/remote/model/response/edit_name_response.dart';
import 'package:job_baraka/data/remote/model/response/get_current_location_response.dart';
import 'package:job_baraka/data/remote/model/response/me_details_response.dart';
import 'package:job_baraka/presentation/ui/profile/repository/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final _api = ApiProfile();
  final SharedPreferences pref = SharedPref.instance;
  @override
  Future<MyDetailsResponse> getMeDetails() async {

    final token = pref.getString("TOKEN");

    final response = await _api.getMeDetails(token!);

    return response;

  }

  @override
  Future<ResponseData> editDistrictByRegion(int regionId) async {
    final token = pref.getString("TOKEN");

    final districts = await _api.getAllDistrict(token!);

    int districtId = 0;

    for(int i = 0; i < districts.data.length; i++) {
      if(districts.data[i].regionId == regionId.toString()) {
        districtId = districts.data[i].id;
        break;
      }
    }

    final response = await  _api.editDistrict(EditDistrictRequest(districtId: districtId), token);

    return response;
  }

  @override
  Future<ResponseData> editDistrictByDistrict(int districtId) async {
    final token = pref.getString("TOKEN");

    final response = await  _api.editDistrict(EditDistrictRequest(districtId: districtId), token!);

    return response;

  }



  @override
  Future<DefaultResponse> editName(EditNameRequest request) async {

    final token = pref.getString("TOKEN");

    final response = await _api.editName(request,token!);

    return response;
  }

  @override
  Future<ResponseData> editAvatar(EditAvatarRequest request) async {

    final token = pref.getString("TOKEN");


    final response = await _api.editAvatar(request, token!);

    return response;
  }

  @override
  Future<bool> editIsWorking(EditIsWorkingRequest request) async{

    final token = pref.getString("TOKEN");

    final response = await _api.editIsWorking(request,token);

    return response;
  }

  @override
  Future<DefaultResponse> editDescription(EditDescriptionRequest request) async {

    final token = pref.getString("TOKEN");

    final response = await _api.editDescription(request,token);
    return response;
  }

  @override
  Future<bool> addWorkerLocation(AddWorkerLocationRequest request) async {
    final token = pref.getString("TOKEN");

    final response = await _api.addWorkerLocationRequest(request,token!);
    return response;
  }

  @override
  Future<GetCurrentLocationResponse> getCurrentUserLocation() async {
    final token = pref.getString("TOKEN");

    final response = await _api.getCurrentUserLocation(token!);
    return response;

  }

  @override
  Future<bool> removeUserLocation(int id) async {
    final token = pref.getString("TOKEN");

    final response = await _api.removeUserLocation(id,token!);
    return response;
  }



}