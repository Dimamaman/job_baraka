part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginLoadingEvent extends LoginEvent{

}

class SendSmsEvent extends LoginEvent{
  final LoginRequest request;
  SendSmsEvent({required this.request});

}

class VerifySmsEvent extends LoginEvent{
 final VerifyRequest request;

  VerifySmsEvent({required this.request});
}




