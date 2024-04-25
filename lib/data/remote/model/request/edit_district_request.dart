class EditDistrictRequest {
  final int districtId;

  EditDistrictRequest({
    required this.districtId,
  });

  Map<String, dynamic> toJson() => {'district_id': districtId};
}
