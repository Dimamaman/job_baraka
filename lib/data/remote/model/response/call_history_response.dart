

class CallHistoryData {
  int id;
  String name;
  ServiceCallHistory service;
  String status;
  DateTime date;

  CallHistoryData({
    required this.id,
    required this.name,
    required this.service,
    required this.status,
    required this.date,
  });

  factory CallHistoryData.fromJson(Map<String, dynamic> json) => CallHistoryData(
        id: json["id"],
        name: json["name"],
        service: ServiceCallHistory.fromJson(json["service"]),
        status: json["status"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "service": service.toJson(),
        "status": status,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      };
}

class ServiceCallHistory {
  String kar;
  String uzKiril;
  String uzLatin;
  String ru;
  String en;

  ServiceCallHistory({
    required this.kar,
    required this.uzKiril,
    required this.uzLatin,
    required this.ru,
    required this.en,
  });

  factory ServiceCallHistory.fromJson(Map<String, dynamic> json) => ServiceCallHistory(
        kar: json["kar"],
        uzKiril: json["uz_kiril"],
        uzLatin: json["uz_latin"],
        ru: json["ru"],
        en: json["en"],
      );

  Map<String, dynamic> toJson() => {
        "kar": kar,
        "uz_kiril": uzKiril,
        "uz_latin": uzLatin,
        "ru": ru,
        "en": en,
      };
}
