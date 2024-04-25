import 'package:bloc/bloc.dart';
import 'package:job_baraka/data/remote/model/request/edit_district_request.dart';
import 'package:job_baraka/data/remote/model/request/edit_name_request.dart';
import 'package:job_baraka/data/remote/model/response/district_response.dart';
import 'package:job_baraka/data/remote/model/response/edit_district_response.dart';
import 'package:job_baraka/data/remote/model/response/edit_name_response.dart';
import 'package:job_baraka/data/remote/model/response/region_response.dart';
import 'package:job_baraka/presentation/ui/sign_up/repository/sign_up_repository.dart';
import 'package:job_baraka/presentation/ui/sign_up/repository/sign_up_repository_impl.dart';
import 'package:meta/meta.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpRepository repository = SignUpRepositoryImpl();

  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpEvent>((event, emit) async {
      switch (event) {
        case LoadingSignUpEvent():
          {
            emit(SignUpLoadingState());
          }

        case GetAllRegionEvent():
          {
            await _getRegionEvent(emit);
          }

        case GetAllDistrictEvent():
          {
            await _getDistrictEvent(event.regionId, emit);
          }

        case SendDistrictEvent():
          {
            await _sendDistrictEvent(event.request, emit);
          }

        case SendNameEvent():
          {
            await _senNameEvent(event.request, emit);
          }
      }
    });
  }

  _getRegionEvent(Emitter<SignUpState> emit) async {
    emit(SignUpLoadingState());
    final regions = await repository.getAllRegion();

    if (regions.status == "success") {
      emit(GetAllRegionsState(response: regions));
    }
  }

  _getDistrictEvent(String regionId, Emitter<SignUpState> emit) async {
    emit(SignUpLoadingState());
    final districts = await repository.getAllDistrict();
    List<DistrictData> list = [];

    if (districts.status == "success") {
      for (int i = 0; i < districts.data.length; i++) {
        if (regionId.trim() == districts.data[i].regionId) {
          list.add(districts.data[i]);
        }
      }

      emit(GetAllDistrictState(list: list));
    }
  }

  _sendDistrictEvent(EditDistrictRequest request, Emitter<SignUpState> emit) async {
    emit(SignUpLoadingState());

    final response = await repository.sendEditDistrict(request);

    if (response.success == true) {
      return response;
    }
    return ResponseData(success: false);
  }

  _senNameEvent(EditNameRequest request, Emitter<SignUpState> emit) async {
    emit(SignUpLoadingState());

    final response = await repository.sendEditName(request);

    if (response.success == true) {
      return response;
    }
    return DefaultResponse(success: false);
  }

}

