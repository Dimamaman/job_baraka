part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}
class ProfileLoadingState extends ProfileState {}

class ProfileGetMeDetailsState extends ProfileState {
  final MyDetailsResponse response;
  ProfileGetMeDetailsState({required this.response});}

class ProfileEditNameState extends ProfileState {
  final DefaultResponse  response;

  ProfileEditNameState({required this.response});


  }
class ProfileDescriptionNameState extends ProfileState {
  final DefaultResponse  response;

  ProfileDescriptionNameState({required this.response});



  }
class QiziqState extends ProfileState {
  final String response;

  QiziqState({required this.response});
}

