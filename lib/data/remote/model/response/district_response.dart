class DistrictDataResponse {
  final List<DistrictData> data;
  final String status;

  DistrictDataResponse({required this.data, required this.status});

  factory DistrictDataResponse.fromJson(Map<String, dynamic> json, String status) {
    return DistrictDataResponse(
      data: ((json['data']) as List).map((data) => DistrictData.fromJson(data)).toList(),
      status: status,
    );
  }
}

class DistrictData {
  final int id;
  final String regionId;
  final DistrictName name;

  DistrictData({
    required this.id,
    required this.regionId,
    required this.name,
  });

  factory DistrictData.fromJson(Map<String, dynamic> json) {
    return DistrictData(
        id: json['id'],
        name: DistrictName.fromJson(json['name']),
        regionId: json['region_id']
    );
  }
}

class DistrictName {
  final String kar;
  final String uzKiril;
  final String uzLatin;
  final String ru;
  final String en;

  DistrictName({
    required this.kar,
    required this.uzKiril,
    required this.uzLatin,
    required this.ru,
    required this.en,
  });

  factory DistrictName.fromJson(Map<String, dynamic> json) {
    return DistrictName(kar: json['kar'], uzKiril: json['uz_kiril'], uzLatin: json['uz_latin'], ru: json['ru'], en: json['en']);
  }
}
