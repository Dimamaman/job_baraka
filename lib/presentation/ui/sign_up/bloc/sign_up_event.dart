part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpEvent {}

class LoadingSignUpEvent extends SignUpEvent{}
class GetAllRegionEvent extends SignUpEvent{}
class GetAllDistrictEvent extends SignUpEvent{
  final String regionId ;

  GetAllDistrictEvent({required this.regionId});
}
class SendDistrictEvent extends SignUpEvent{
  final EditDistrictRequest request ;

  SendDistrictEvent({required this.request});


}
class SendNameEvent extends SignUpEvent{
  final EditNameRequest request ;

  SendNameEvent({required this.request});



}

