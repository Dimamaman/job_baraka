import 'package:job_baraka/data/remote/model/request/edit_district_request.dart';
import 'package:job_baraka/data/remote/model/request/edit_name_request.dart';
import 'package:job_baraka/data/remote/model/response/district_response.dart';
import 'package:job_baraka/data/remote/model/response/edit_district_response.dart';
import 'package:job_baraka/data/remote/model/response/edit_name_response.dart';
import 'package:job_baraka/data/remote/model/response/region_response.dart';

abstract class SignUpRepository {
   Future<RegionDataResponse> getAllRegion();
   Future<DistrictDataResponse> getAllDistrict();
   Future<ResponseData> sendEditDistrict(EditDistrictRequest request);
   Future<DefaultResponse> sendEditName(EditNameRequest request);
}
