part of 'about_me_bloc.dart';

@immutable
abstract class AboutMeState {}

class AboutMeInitial extends AboutMeState {}
class AboutMeLoadingState extends AboutMeState {}
class AboutMeGetAllServicesState extends AboutMeState {
  final List<ServiceData> services;

  AboutMeGetAllServicesState({required this.services});
}
class CreateJobState extends AboutMeState {
  final CreateJobResponse response;

  CreateJobState({required this.response});

}
