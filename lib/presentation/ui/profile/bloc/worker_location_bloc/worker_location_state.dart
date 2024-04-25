part of 'worker_location_bloc.dart';

@immutable
sealed class WorkerLocationState {}

final class WorkerLocationInitial extends WorkerLocationState {}

class BackToProfileScreenState extends WorkerLocationState {
  final bool  response;

  BackToProfileScreenState({required this.response});



}

class GetCurrentLocationState extends WorkerLocationState {
  final GetCurrentLocationResponse  response;

  GetCurrentLocationState({required this.response});





}