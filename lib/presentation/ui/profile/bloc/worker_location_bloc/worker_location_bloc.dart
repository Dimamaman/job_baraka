import 'package:bloc/bloc.dart';
import 'package:job_baraka/data/remote/model/request/add_worker_location_request.dart';
import 'package:job_baraka/data/remote/model/response/get_current_location_response.dart';
import 'package:job_baraka/presentation/ui/profile/repository/profile_repository.dart';
import 'package:job_baraka/presentation/ui/profile/repository/profile_repository_impl.dart';
import 'package:meta/meta.dart';

part 'worker_location_event.dart';

part 'worker_location_state.dart';

class WorkerLocationBloc extends Bloc<WorkerLocationEvent, WorkerLocationState> {
  final ProfileRepository repository = ProfileRepositoryImpl();

  WorkerLocationBloc() : super(WorkerLocationInitial()) {
    on<WorkerLocationEvent>((event, emit) async {
      switch (event) {
        case AddWorkerLocationEvent():
          {
            await _addWorkerLocationEvent(event.request, emit);
          }
        case GetCurrentLocationEvent():
          {
            await _getCurrentLocationEvent(emit);
          }
        case RemoveLocationEvent():
          {
            await _removeUserLocationEvent(event.id,emit);
          }
      }
    });
  }

  _addWorkerLocationEvent(AddWorkerLocationRequest request, Emitter<WorkerLocationState> emit) async {
    final response = await repository.addWorkerLocation(request);

    emit(BackToProfileScreenState(response: response));
  }

  _getCurrentLocationEvent(Emitter<WorkerLocationState> emit) async {
    final response = await repository.getCurrentUserLocation();

    emit(GetCurrentLocationState(response: response));

  }

  _removeUserLocationEvent(int id, Emitter<WorkerLocationState> emit) async {
    final response = await repository.removeUserLocation(id);
    emit(BackToProfileScreenState(response: response));
  }
}
