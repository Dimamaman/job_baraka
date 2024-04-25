import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:job_baraka/data/remote/model/response/call_history_response.dart';
import 'package:job_baraka/data/remote/model/response/get_all_services_response.dart';
import 'package:job_baraka/data/remote/model/response/get_workers_response.dart';
import 'package:job_baraka/data/remote/model/response/log_out_response.dart';
import 'package:job_baraka/presentation/ui/main/repository/main_repository.dart';
import 'package:job_baraka/presentation/ui/main/repository/main_repository_impl.dart';
import 'package:meta/meta.dart';

part 'main_event.dart';

part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {

  final MainRepository repository = MainRepositoryImpl();
  MainBloc() : super(MainInitial()) {
    on<MainEvent>((event, emit) async {
      switch (event) {
        case NavigateToLoginScreenEvent():
          {
           await  _navigateProfileScreen(event.request,emit);
          }
        case MainLogOutEvent():
          {
            await _logOutEvent(emit);
          }

        case GetAllServicesEvent():
          {
            await _getAllServicesEvent(emit);
          }

        case GetWorkersEvent():
          {
            await _getWorkersEvent(event.serviceId,event.lat,event.lng,emit);
          }
        case CallWorkerEvent():
          {
            await  _callWorkerEvent(event.workerId,emit);
          }
        case CallHistoryEvent():
          {
            await  _callHistoryEvent(emit);
          }

      }
    });
  }

   _navigateProfileScreen(bool request,Emitter<MainState> emit) async {

    emit(MainLoadingState());
    emit(NavigateToLoginScreenState(response: true));
  }


  _logOutEvent(Emitter<MainState> emit) async {



    final response = await repository.logOut();


    emit(MainLogOutState(response: response));



  }

  _getAllServicesEvent(Emitter<MainState> emit) async {
    final response =  repository.getAllServices();


    final hive = await Hive.openBox('servicesBox');


    final data = hive.get('servicesData') as GetAllServicesResponse?;

    if(data == null || data.data.isEmpty) {

      final response =  await repository.getAllServices();

      emit(GetAllServicesState(services: response.data));

    }
    emit(GetAllServicesState(services: data!.data));


  }

  _getWorkersEvent(int serviceId, double lat, lng, Emitter<MainState> emit) async{

    final response = await repository.getWorkers(serviceId,lat,lng);
    print(response.data.length);



    emit(GetWorkersState(response: response));



  }

  _callWorkerEvent(int workerId, Emitter<MainState> emit) async {

    final response = repository.callWorker(workerId);
  }

  _callHistoryEvent(Emitter<MainState> emit) async {

    final response = await repository.getCallHistory();

    emit(CallHistoryState(response: response));
  }







}

