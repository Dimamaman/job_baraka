part of 'worker_location_bloc.dart';

@immutable
sealed class WorkerLocationEvent {}

class AddWorkerLocationEvent extends WorkerLocationEvent{
  final AddWorkerLocationRequest request;
  AddWorkerLocationEvent({required this.request});
}

class GetCurrentLocationEvent extends WorkerLocationEvent{
}
class RemoveLocationEvent extends WorkerLocationEvent{
  final int id;

  RemoveLocationEvent({required this.id});

}