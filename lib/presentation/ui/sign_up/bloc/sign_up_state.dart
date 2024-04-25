part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}
class SignUpLoadingState extends SignUpState{}
class GetAllRegionsState extends SignUpState {
  final RegionDataResponse response;

  GetAllRegionsState({required this.response});
}
class GetAllDistrictState extends SignUpState {
  final List<DistrictData> list;

  GetAllDistrictState({required this.list});

}

class SendDistrictState extends SignUpState {
  final bool? succes;

  SendDistrictState({required this.succes});



}

