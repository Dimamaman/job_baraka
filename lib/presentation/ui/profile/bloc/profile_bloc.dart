import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:job_baraka/data/remote/model/request/add_worker_location_request.dart';
import 'package:job_baraka/data/remote/model/request/edit_avatart_request.dart';
import 'package:job_baraka/data/remote/model/request/edit_description_request.dart';
import 'package:job_baraka/data/remote/model/request/edit_is_working_request.dart';
import 'package:job_baraka/data/remote/model/request/edit_name_request.dart';
import 'package:job_baraka/data/remote/model/response/edit_name_response.dart';
import 'package:job_baraka/data/remote/model/response/me_details_response.dart';
import 'package:job_baraka/presentation/ui/profile/repository/profile_repository.dart';
import 'package:job_baraka/presentation/ui/profile/repository/profile_repository_impl.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository = ProfileRepositoryImpl();

  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) async {
      switch (event) {
        case GetMeDetailsEvent():
          {
            await _getMeDetailsEvent(emit);
          }

        case EditDistrictByRegionEvent():
          {
            await _editDistrictByRegionEvent(event.regionId, emit);
          }

        case EditDistrictByDistrictEvent():
          {
            await _editDistrictByDistrictEvent(event.districtId, emit);
          }
        case EditNameEvent():
          {
            await _editNameEvent(event.name, emit);
          }

        case EditAvatarEvent():
          {
            await _editAvatarEvent(event.avatar, emit);
          }

        case EditIsWorkingEvent():
          {
            await _editIsWorkingEvent(event.request, emit);
          }
        case EditDescriptionEvent():
          {
            await _editDescriptionEvent(event.description, emit);
          }



      }
    });
  }

  _getMeDetailsEvent(Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());

    final response = await repository.getMeDetails();

    emit(ProfileGetMeDetailsState(response: response));
  }

  _editDistrictByRegionEvent(int regionId, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());

    final response = await repository.editDistrictByRegion(regionId);

    final response1 = await repository.getMeDetails();

    emit(ProfileGetMeDetailsState(response: response1));
  }

  _editDistrictByDistrictEvent(int districtId, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());

    final response1 = await repository.editDistrictByDistrict(districtId);

    final response = await repository.getMeDetails();

    emit(ProfileGetMeDetailsState(response: response));
  }

  _editNameEvent(String name, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());

    final response1 = await repository.editName(EditNameRequest(name: name));

    final response = await repository.getMeDetails();

    emit(ProfileGetMeDetailsState(response: response));
  }

  _editAvatarEvent(File avatar, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());

    final List<File> image = [];

    image.add(avatar);

    final response1 = await repository.editAvatar(EditAvatarRequest(fileAvatar: image,path: avatar.path));

    print("NNNNN -> ${response1.error}");

    final response = await repository.getMeDetails();

    emit(ProfileGetMeDetailsState(response: response));
  }

  _editIsWorkingEvent(EditIsWorkingRequest request, Emitter<ProfileState> emit) async {
    final response = await repository.editIsWorking(request);
  }

  _editDescriptionEvent(String description, Emitter<ProfileState> emit) async {


    await repository.editDescription(EditDescriptionRequest(description: description));



  }





}


