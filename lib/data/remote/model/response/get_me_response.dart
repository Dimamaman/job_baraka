class GetMeResponse {
  final UserData data;
  final String status;

  GetMeResponse({
    required this.data,
    required this.status
  });

  factory GetMeResponse.fromJson(Map<String,dynamic> json,String status) {
    return GetMeResponse(data: json['data'], status: status);
  }

}

class UserData {
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

  UserData({
    required this.id,
    required this.name,
    required this.phone,
    required this.language,
    required this.role,
    required this.roleId,
    required this.isWorking,
    required this.region,
    required this.district,
    required this.service,
    required this.description,
    required this.avatar,
    required this.locations,
  });



}

class District {
  final int id;
  final Name name;

  District({
    required this.id,
    required this.name,
  });

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
    return Location(id: json['id'],title: json['title'],lat: json['lat'],lng: json['lng']);
  }
}
