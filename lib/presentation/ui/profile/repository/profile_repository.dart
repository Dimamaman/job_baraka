import 'package:job_baraka/data/remote/model/request/add_worker_location_request.dart';
import 'package:job_baraka/data/remote/model/request/edit_avatart_request.dart';
import 'package:job_baraka/data/remote/model/request/edit_description_request.dart';
import 'package:job_baraka/data/remote/model/request/edit_is_working_request.dart';
import 'package:job_baraka/data/remote/model/request/edit_name_request.dart';
import 'package:job_baraka/data/remote/model/response/edit_district_response.dart';
import 'package:job_baraka/data/remote/model/response/edit_name_response.dart';
import 'package:job_baraka/data/remote/model/response/get_current_location_response.dart';
import 'package:job_baraka/data/remote/model/response/me_details_response.dart';

abstract class ProfileRepository {
  Future<MyDetailsResponse> getMeDetails();
  Future<ResponseData> editDistrictByRegion(int regionId);
  Future<ResponseData> editDistrictByDistrict(int districtId);
  Future<DefaultResponse> editName(EditNameRequest request);
  Future<ResponseData> editAvatar(EditAvatarRequest request);
  Future<bool> editIsWorking(EditIsWorkingRequest request);
  Future<DefaultResponse> editDescription(EditDescriptionRequest request);
  Future<bool> addWorkerLocation(AddWorkerLocationRequest request);
  Future<GetCurrentLocationResponse> getCurrentUserLocation();
  Future<bool> removeUserLocation(int id);
}