import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:job_baraka/data/remote/model/request/add_worker_location_request.dart';
import 'package:job_baraka/data/remote/model/request/create_job_request.dart';
import 'package:job_baraka/data/remote/model/request/edit_avatart_request.dart';
import 'package:job_baraka/data/remote/model/request/edit_description_request.dart';
import 'package:job_baraka/data/remote/model/request/edit_district_request.dart';
import 'package:job_baraka/data/remote/model/request/edit_is_working_request.dart';
import 'package:job_baraka/data/remote/model/request/edit_name_request.dart';
import 'package:job_baraka/data/remote/model/response/call_history_response.dart';
import 'package:job_baraka/data/remote/model/response/create_job_response.dart';
import 'package:job_baraka/data/remote/model/response/district_response.dart';
import 'package:job_baraka/data/remote/model/response/edit_district_response.dart';
import 'package:job_baraka/data/remote/model/response/edit_name_response.dart';
import 'package:job_baraka/data/remote/model/response/get_all_services_response.dart';
import 'package:job_baraka/data/remote/model/response/get_current_location_response.dart';
import 'package:job_baraka/data/remote/model/response/get_workers_response.dart';
import 'package:job_baraka/data/remote/model/response/me_details_response.dart';
import 'package:job_baraka/data/remote/model/response/region_response.dart';

class ApiProfile {
  final _dio = Dio(BaseOptions(baseUrl: 'https://api.jobbaraka.uz/api/'));

  Future<MyDetailsResponse> getMeDetails(String token) async {
    try {
      final response = await _dio.get(
        "/getme",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json', // Необязательно
          },
        ),
      );

      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        print("success");
        return MyDetailsResponse.fromJson(response.data['data'], "succes");
      } else {
        print("error");

        return MyDetailsResponse.fromJson({}, "error");
      }
    } catch (e) {
      print("catch");

      return MyDetailsResponse.fromJson({}, e.toString());
    }
  }

  Future<RegionDataResponse> getAllRegion(String token) async {
    try {
      final response = await _dio.get(
        "/get-regions",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json', // Необязательно
          },
        ),
      );

      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return RegionDataResponse.fromJson(response.data, "success");
      } else {
        return RegionDataResponse.fromJson({}, "error");
      }
    } catch (e) {
      return RegionDataResponse.fromJson({}, e.toString());
    }
  }

  Future<DistrictDataResponse> getAllDistrict(String token) async {
    try {
      final response = await _dio.get(
        "/get-districts",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json', // Необязательно
          },
        ),
      );

      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return DistrictDataResponse.fromJson(response.data, "success");
      } else {
        return DistrictDataResponse.fromJson({}, "error");
      }
    } catch (e) {
      return DistrictDataResponse.fromJson({}, e.toString());
    }
  }

  Future<ResponseData> editDistrict(EditDistrictRequest request, String token) async {
    try {
      final response = await _dio.put(
        "/edit-district",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json', // Необязательно
          },
        ),
        data: request.toJson(),
      );

      print(response.data['data']);

      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return ResponseData.fromJson(response.data['data']);
      } else {
        return ResponseData.fromJson({});
      }
    } catch (e) {
      return ResponseData.fromJson({});
    }
  }

  Future<DefaultResponse> editName(EditNameRequest request, String token) async {
    try {
      final response = await _dio.put(
        "/edit-name",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json', // Необязательно
          },
        ),
        data: request.toJson(),
      );

      print(response.data['data']);

      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return DefaultResponse.fromJson(response.data['data']);
      } else {
        return DefaultResponse.fromJson({});
      }
    } catch (e) {
      return DefaultResponse.fromJson({});
    }
  }

  Future<GetAllServicesResponse> getAllService(String token) async {
    try {
      final response = await _dio.get(
        "/get-category",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json', // Необязательно
          },
        ),
      );

      print(response.data);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        final data = GetAllServicesResponse.fromJson(response.data);

        final box = await Hive.openBox('servicesBox');
        await box.put('servicesData', data);

        print(response.data);
        return data;
      } else {
        return GetAllServicesResponse.fromJson({});
      }
    } catch (e) {
      return GetAllServicesResponse.fromJson({});
    }
  }

  Future<CreateJobResponse> createJob(CreateJobRequest request, String token) async {
    try {
      final response = await _dio.post(
        "/worker",
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json', // Необязательно
          },
        ),
      );

      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return CreateJobResponse.fromJson(response.data['data']);
      } else {
        return CreateJobResponse.fromJson({});
      }
    } catch (e) {
      return CreateJobResponse.fromJson({});
    }
  }

  Future<ResponseData> editAvatar(EditAvatarRequest request, String token) async {

    print("SSSiizee -> ${request.fileAvatar[0].path}");

    try {
      // Создаем экземпляр Dio с базовым URL
      final dio = Dio(BaseOptions(baseUrl: 'https://api.jobbaraka.uz'));

      // Добавляем токен в заголовок Authorization
      dio.options.headers['Authorization'] = 'Bearer $token';

      // Создаем FormData для передачи файлов
      FormData formData = FormData();
      //
      // // Добавляем каждое изображение в FormData
      for (int i = 0; i < request.fileAvatar.length; i++) {
        formData.files.add(MapEntry(
          'images[]',
          await MultipartFile.fromFile(request.fileAvatar[i].path, filename: request.fileAvatar[i].path.split('/').last),
        ));
      }

      // Отправляем POST-запрос
      Response response = await dio.post('/api/edit-avatar', data: formData);

      // Обрабатываем ответ сервера
      print('Server responseeeeee: ${response.extra}');
      print(response.data);
      return ResponseData(success: true);
    } catch (e) {
      print('Error uploading imagesssssss: $e');
      return ResponseData(success: false,error: e.toString());
    }
  }

  Future<bool> editIsWorking(EditIsWorkingRequest request, String? token) async {
    try {
      print("keldi");
      final response = await _dio.put(
        "/is-working",
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json', // Необязательно
          },
        ),
      );
      print(response.statusCode);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> addWorkerLocationRequest(AddWorkerLocationRequest request, String token) async {
    try {
      final response = await _dio.post(
        "/locations",
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json', // Необязательно
          },
        ),
      );

      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> editJob(int serviceId, String token) async {
    try {
      final response = await _dio.put(
        "/edit-service",
        data: {'service_id': serviceId},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json', // Необязательно
          },
        ),
      );
      print("${response.statusCode}statuscodeeeeeeeeeeeeeee");

      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());

      return false;
    }
  }

  Future<DefaultResponse> editDescription(EditDescriptionRequest request, String? token) async {
    try {
      final response = await _dio.put(
        "/edit-description",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: request.toJson(),
      );

      print(response.statusCode);

      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return DefaultResponse.fromJson(response.data['data']);
      }
    } catch (e) {
      return DefaultResponse.fromJson({});
    }

    return DefaultResponse.fromJson({});
  }

  Future<GetCurrentLocationResponse> getCurrentUserLocation(String? token) async {
    try {
      final response = await _dio.get(
        "/locations",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print(response.statusCode);

      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return GetCurrentLocationResponse.fromJson(response.data);
      }
    } catch (e) {
      return GetCurrentLocationResponse.errorResponse(e.toString());
    }
    return GetCurrentLocationResponse.errorResponse("Serverda nasozlik");
  }

  Future<bool> removeUserLocation(int id, String? token) async {
    try {
      final response = await _dio.delete(
        "/locations/$id",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print(response.statusCode);

      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<GetWorkersResponse> getWorkers(int serviceId, double lat, lng, String token) async {
    try {
      print('$serviceId  ');
      final response = await _dio.get(
        "/all-workers?lat=$lat&lng=$lng&service_id=$serviceId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print(response.statusCode);

      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return GetWorkersResponse.fromJson(response.data);
      }
    } catch (e) {
      return GetWorkersResponse.errorResponse(e.toString());
    }
    return GetWorkersResponse.errorResponse("Serverda nasozlik");
  }

  callWorker(int workerId, String token) async {
    try {
      final response = await _dio.post("/call-worker",
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
          data: {'worker_id': workerId});

      print(response.statusCode);

      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return GetWorkersResponse.fromJson(response.data);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<CallHistoryData>> getCallHistory(String token) async {
    final List<CallHistoryData> result = [];
    try {
      final response = await _dio.get(
        "/call-history",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        final list = response.data[0] as List;

        list.forEach((element) {
          final data = CallHistoryData.fromJson(element);
          result.add(data);
        });

        return result;
      }
    } catch (e) {
      print(e);
    }

    return result;
  }
}

Future<void> main() async {
  final api = ApiProfile();
  const token = "622|EzbigT3TzFhmhIyKkS5ajQbDEKVwnxD6pzO2Zbib3fc9b26b";

  final response = await api.getCallHistory(token);

  print(response.length);
}
