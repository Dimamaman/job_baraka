// models.dart
import 'package:hive/hive.dart';

part 'get_all_services_response.g.dart';

@HiveType(typeId: 0)
class GetAllServicesResponse {
  @HiveField(0)
  final List<ServiceData> data;

  GetAllServicesResponse({
    required this.data,
  });

  factory GetAllServicesResponse.fromJson(Map<String, dynamic> json) {
    return GetAllServicesResponse(
      data: ((json['data']) == null
          ? []
          : (json['data'] as List).map((data) => ServiceData.fromJson(data)).toList()),
    );
  }
}

@HiveType(typeId: 1)
class ServiceData {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final Name categoryName;
  @HiveField(2)
  final List<Service> services;
  @HiveField(3)
  bool isOpen;

  ServiceData({
    required this.id,
    required this.categoryName,
    required this.services,
    this.isOpen = false,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      id: json['id'],
      categoryName: Name.fromJson(json['category_name']),
      services: (json['services'] as List).map((services) => Service.fromJson(services)).toList(),
    );
  }
}

@HiveType(typeId: 2)
class Name {
  @HiveField(0)
  final String kar;
  @HiveField(1)
  final String uzKiril;
  @HiveField(2)
  final String uzLatin;
  @HiveField(3)
  final String ru;
  @HiveField(4)
  final String en;

  Name({
    required this.kar,
    required this.uzKiril,
    required this.uzLatin,
    required this.ru,
    required this.en,
  });

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      kar: json['kar'],
      uzKiril: json['uz_kiril'],
      uzLatin: json['uz_latin'],
      ru: json['ru'],
      en: json['en'],
    );
  }
}

@HiveType(typeId: 3)
class Service {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String categoryId;
  @HiveField(2)
  final Name name;

  Service({
    required this.id,
    required this.categoryId,
    required this.name,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      categoryId: json['category_id'],
      name: Name.fromJson(json['name']),
    );
  }
}
