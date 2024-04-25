
import 'package:job_baraka/data/remote/model/request/create_job_request.dart';
import 'package:job_baraka/data/remote/model/response/create_job_response.dart';
import 'package:job_baraka/data/remote/model/response/get_all_services_response.dart';

abstract class AboutMeRepository {

  Future<GetAllServicesResponse> getAllServices();
  Future<CreateJobResponse> createJob(CreateJobRequest request);
  Future<void> editJob(int serviceId);

}