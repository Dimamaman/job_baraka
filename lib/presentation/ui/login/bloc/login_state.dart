part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}
class LoginLoadingState extends LoginState {}
class SendSmsState extends LoginState {}
class VerifySmsState extends LoginState {
  final VerifyResponse response;

  VerifySmsState({required this.response});
}

