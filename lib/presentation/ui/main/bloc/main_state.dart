part of 'main_bloc.dart';

@immutable
abstract class MainState {}

class MainInitial extends MainState {}

class MainLoadingState extends MainState {}

class MainLogOutState extends MainState {
  final LogOutResponse response;

  MainLogOutState({required this.response});
}

class NavigateToLoginScreenState extends MainState {
  final bool response;

  NavigateToLoginScreenState({required this.response});
}

class GetAllServicesState extends MainState {
  final List<ServiceData> services;

  GetAllServicesState({required this.services});
}

class GetWorkersState extends MainState {
  final GetWorkersResponse response;

  GetWorkersState({required this.response});
}

class CallHistoryState extends MainState {
  final List<CallHistoryData> response;

  CallHistoryState({required this.response});

}
