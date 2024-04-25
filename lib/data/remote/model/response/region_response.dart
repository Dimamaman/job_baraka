class RegionDataResponse {
  final List<RegionData> data;
  final String status;

  RegionDataResponse({required this.data, required this.status});

  factory RegionDataResponse.fromJson(Map<String, dynamic> json, String status) {
    return RegionDataResponse( data: ((json['data'] )  as List  ).map((data) => RegionData.fromJson(data)).toList(),status: status,);
  }
}

class RegionData {
  final int id;
  final RegionName name;

  RegionData({
    required this.id,
    required this.name,
  });

  factory RegionData.fromJson(Map<String, dynamic> json) {
    return RegionData(id: json['id'], name: RegionName.fromJson(json['name']));
  }
}

class RegionName {
  final String kar;
  final String uzKiril;
  final String uzLatin;
  final String ru;
  final String en;

  RegionName({
    required this.kar,
    required this.uzKiril,
    required this.uzLatin,
    required this.ru,
    required this.en,
  });

  factory RegionName.fromJson(Map<String, dynamic> json) {
    return RegionName(kar: json['kar'], uzKiril: json['uz_kiril'], uzLatin: json['uz_latin'], ru: json['ru'], en: json['en']);
  }
}

