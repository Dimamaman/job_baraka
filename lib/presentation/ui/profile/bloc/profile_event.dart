part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class GetMeDetailsEvent extends ProfileEvent{}
class EditDistrictByRegionEvent extends ProfileEvent{
  final int regionId;
  EditDistrictByRegionEvent({required this.regionId});}
class EditDistrictByDistrictEvent extends ProfileEvent{
  final int districtId;

  EditDistrictByDistrictEvent({required this.districtId});

}
class EditNameEvent extends ProfileEvent{
  final String name;

  EditNameEvent({required this.name});


}
class EditAvatarEvent extends ProfileEvent{
  final File avatar;

  EditAvatarEvent({required this.avatar});




}
class EditIsWorkingEvent extends ProfileEvent{
  final EditIsWorkingRequest request;

  EditIsWorkingEvent({required this.request});


}


class EditDescriptionEvent extends ProfileEvent{
  final String description;

  EditDescriptionEvent({required this.description});


}




