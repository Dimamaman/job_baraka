import 'package:job_baraka/data/local/shared_preferences.dart';
import 'package:job_baraka/data/remote/api/api_profil.dart';
import 'package:job_baraka/data/remote/model/request/edit_district_request.dart';
import 'package:job_baraka/data/remote/model/request/edit_name_request.dart';
import 'package:job_baraka/data/remote/model/response/district_response.dart';
import 'package:job_baraka/data/remote/model/response/edit_district_response.dart';
import 'package:job_baraka/data/remote/model/response/edit_name_response.dart';
import 'package:job_baraka/data/remote/model/response/region_response.dart';
import 'package:job_baraka/presentation/ui/sign_up/repository/sign_up_repository.dart';

class SignUpRepositoryImpl extends SignUpRepository {

  final _api = ApiProfile();
  final pref = SharedPref.instance;

  @override
  Future<RegionDataResponse> getAllRegion() async {

    final token = pref.getString("TOKEN");

    final response = await _api.getAllRegion(token!);

    return response;
  }

  @override
  Future<DistrictDataResponse> getAllDistrict() async {
    final token = pref.getString("TOKEN");

    final response = await _api.getAllDistrict(token!);

    return response;
  }

  @override
  Future<ResponseData> sendEditDistrict(EditDistrictRequest request) async{
    final token = pref.getString("TOKEN");

    final response = await _api.editDistrict(request,token!);

    return response;

  }

  @override
  Future<DefaultResponse> sendEditName(EditNameRequest request) async {
    final token = pref.getString("TOKEN");

    final response = await _api.editName(request,token!);

    return response;
  }

}
