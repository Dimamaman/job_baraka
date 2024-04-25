part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}

class NavigateToLoginScreenEvent extends MainEvent{
  final bool request;

  NavigateToLoginScreenEvent({required this.request});
}
class MainLogOutEvent extends MainEvent{}
class GetAllServicesEvent  extends MainEvent{}
class GetWorkersEvent extends MainEvent{
  final int serviceId;
  final double lat;
  final double lng;

  GetWorkersEvent({required this.serviceId, required this.lat, required this.lng});
}

class CallWorkerEvent extends MainEvent {
  final int workerId;

  CallWorkerEvent({required this.workerId});
}


class CallHistoryEvent extends MainEvent {


}


