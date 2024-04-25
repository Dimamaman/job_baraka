part of 'about_me_bloc.dart';

@immutable
abstract class AboutMeEvent {}

class AboutMeGetAllEvent  extends AboutMeEvent{}
class CreateJobEvent  extends AboutMeEvent{
  final CreateJobRequest request;

  CreateJobEvent({required this.request});

}

class EditJobEvent extends AboutMeEvent {
  final int serviceId;

  EditJobEvent({required this.serviceId});
}

