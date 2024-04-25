class MyDetailsResponse {
  final MyDetailsData data;
  final String? status;



  factory MyDetailsResponse.fromJson(Map<String, dynamic> json,String status) {

    return MyDetailsResponse(data: MyDetailsData.fromJson(json), status: status);
  }

  MyDetailsResponse({required this.data, required this.status});

}


class MyDetailsData {
  final int id;
  final String? name;
  final String phone;
  final String? language;
  final String role;
  final int roleId;
  final bool isWorking;
  final District? region;
  final District? district;
  final District? service;
  final String? description;
  final String? avatar;
  final List<Location>? locations;


  MyDetailsData({
    required this.id,
     this.name,
    required this.phone,
     this.language,
    required this.role,
    required this.roleId,
    required this.isWorking,
     this.region,
     this.district,
     this.service,
     this.description,
     this.avatar,
     this.locations,

  });

  factory MyDetailsData.fromJson(Map<String, dynamic> json) {

    return MyDetailsData(
      id: json['id'] ?? 0,
      name: json['name'],
      phone: json['phone'] ?? "",
      language: json['language'] ?? "",
      role: json['role'] ?? "",
      roleId: json['role_id'] ?? 0,
      isWorking: json['is_working'] ?? false,
      region: District.fromJson(json['region'] ?? {}),
      district: District.fromJson(json['district']?? {}),
      service: District.fromJson(json['service']?? {}),
      description: json['description'] ?? "",
      avatar: json['avatar']?? "",
      locations: (json['locations'] as List).map((location) => Location.fromJson(location)).toList(),


    );
  }
}



class District {
  final int id;
  final Name name;

  District({
    required this.id,
    required this.name,
  });

  factory District.fromJson(Map<String,dynamic> json) {
    return District(
        id: json['id'] ?? 0,
        name: Name.fromJson(json['name'] ?? {})
    );
  }

}

class Name {
  final String kar;
  final String uzKiril;
  final String uzLatin;
  final String ru;
  final String en;

  Name({
    required this.kar,
    required this.uzKiril,
    required this.uzLatin,
    required this.ru,
    required this.en,
  });

  factory Name.fromJson(Map<String,dynamic> json) {
    return Name(
      kar: json['kar'] ?? "",
      uzKiril: json['uz_kiril']?? "",
      uzLatin: json['uz_latin']?? "",
      ru:  json['ru']?? "",
      en: json['en']?? ""
    );
  }

}

class Location {
  final int id;
  final String title;
  final String lat;
  final String lng;

  Location({
    required this.id,
    required this.title,
    required this.lat,
    required this.lng,
  });


  factory Location.fromJson(Map<String,dynamic> json) {
    return Location(
        id: json['id'] ?? 0,
        title: json['title'] ?? "",
        lat: json['lat']?? "",
        lng: json['lng']?? "");
  }

}
