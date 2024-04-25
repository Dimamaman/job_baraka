class EditIsWorkingRequest {

  final bool isWorking;

  EditIsWorkingRequest({required this.isWorking});


  Map<String, dynamic> toJson() {
    return {
      'is_working': isWorking,
    };
  }
}
