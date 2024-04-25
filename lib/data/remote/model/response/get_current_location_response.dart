class GetCurrentLocationResponse {
  List<CurrentUserLocationData> data;
  String? message;

  GetCurrentLocationResponse({
    required this.data,
    this.message
  });

  factory GetCurrentLocationResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'];
    List<CurrentUserLocationData> parsedDataList = dataList.map((item) => CurrentUserLocationData.fromJson(item)).toList();

    return GetCurrentLocationResponse(data: parsedDataList);
  }

  factory GetCurrentLocationResponse.errorResponse(String message) {

    return GetCurrentLocationResponse(data: [],message: message);
  }
}

class CurrentUserLocationData {
  int id;
  String title;
  String lat;
  String lng;
  String avatar;

  CurrentUserLocationData({
    required this.id,
    required this.title,
    required this.lat,
    required this.lng,
    required this.avatar,
  });

  factory CurrentUserLocationData.fromJson(Map<String, dynamic> json) {
    return CurrentUserLocationData(
      id: json['id'],
      title: json['title'],
      lat: json['lat'],
      lng: json['lng'],
      avatar: json['avatar'],
    );
  }
}