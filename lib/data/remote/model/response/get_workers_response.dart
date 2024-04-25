class GetWorkersResponse {
  List<Worker> data;
  String? message;
  GetWorkersResponse({
    required this.data,
    this.message
  });

  factory GetWorkersResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'] ?? [];
    List<Worker> workers = dataList.map((data) => Worker.fromJson(data)).toList();
    return GetWorkersResponse(data: workers);
  }



  factory GetWorkersResponse.errorResponse(String message) {

    return GetWorkersResponse(data: [],message: message);
  }
}

class Worker {
  int id;
  String name;
  String phone;
  String description;
  bool isWorking;
  ServiceName service;
  String location;
  String lat;
  String lng;
  String avatar;
  String distance;

  Worker({
    required this.id,
    required this.name,
    required this.phone,
    required this.description,
    required this.isWorking,
    required this.service,
    required this.location,
    required this.lat,
    required this.lng,
    required this.avatar,
    required this.distance,
  });

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      description: json['description'] ?? '',
      isWorking: json['is_working'] ?? false,
      service: ServiceName.fromJson(json['service'] ?? {}),
      location: json['location'] ?? '',
      lat: json['lat'] ?? '',
      lng: json['lng'] ?? '',
      avatar: json['avatar'] ?? '',
      distance: json['distance'] ?? '',
    );
  }


}

class ServiceName {
  String kar;
  String uzKiril;
  String uzLatin;
  String ru;
  String en;

  ServiceName({
    required this.kar,
    required this.uzKiril,
    required this.uzLatin,
    required this.ru,
    required this.en,
  });

  factory ServiceName.fromJson(Map<String, dynamic> json) {
    return ServiceName(
      kar: json['kar'] ?? '',
      uzKiril: json['uz_kiril'] ?? '',
      uzLatin: json['uz_latin'] ?? '',
      ru: json['ru'] ?? '',
      en: json['en'] ?? '',
    );
  }


}
