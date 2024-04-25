import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:job_baraka/data/remote/model/request/create_job_request.dart';
import 'package:job_baraka/data/remote/model/response/create_job_response.dart';
import 'package:job_baraka/data/remote/model/response/get_all_services_response.dart';
import 'package:job_baraka/presentation/ui/aboutme/repository/about_me_repository.dart';
import 'package:job_baraka/presentation/ui/aboutme/repository/about_me_repository_impl.dart';

part 'about_me_event.dart';

part 'about_me_state.dart';

class AboutMeBloc extends Bloc<AboutMeEvent, AboutMeState> {
  final AboutMeRepository _repository = AboutMeRepositoryImpl();

  AboutMeBloc() : super(AboutMeInitial()) {
    on<AboutMeEvent>((event, emit) async {
      switch (event) {
        case AboutMeGetAllEvent():
          {
            await _aboutMeEvent(emit);
          }

        case CreateJobEvent():
          {
            await _createJobEvent(event.request, emit);
          }

        case EditJobEvent():
          {
            print("kirdiicaseqa-----------");
            await _editJobEvent(event.serviceId, emit);
          }
      }
    });
  }

  _aboutMeEvent(Emitter<AboutMeState> emit) async {
    emit(AboutMeLoadingState());

    final response =  _repository.getAllServices();

    final hive = await Hive.openBox('servicesBox');


    final data = hive.get('servicesData') as GetAllServicesResponse?;

    if(data == null || data.data.isEmpty) {

      final response =  await _repository.getAllServices();
      emit(AboutMeGetAllServicesState(services: response.data));

    }
    emit(AboutMeGetAllServicesState(services: data!.data));
    print('baripturrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');


  //  emit(AboutMeGetAllServicesState(services: response.data));
  }

  _createJobEvent(CreateJobRequest request, Emitter<AboutMeState> emit) async {
    emit(AboutMeLoadingState());

    final response = await _repository.createJob(request);

    emit(CreateJobState(response: response));



  }

  _editJobEvent(int serviceId, Emitter<AboutMeState> emit) async {

    final response1 = await _repository.editJob(serviceId);


  }
}
