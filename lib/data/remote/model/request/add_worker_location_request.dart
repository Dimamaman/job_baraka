class AddWorkerLocationRequest {
  String title;
  String lat;
  String lng;

  AddWorkerLocationRequest({
    required this.title,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toJson() => {
    'title' : title,
    'lat' : lat,
    'lng' : lng
  };
}
