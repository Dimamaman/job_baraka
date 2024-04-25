import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:job_baraka/data/remote/model/request/login_request.dart';
import 'package:job_baraka/data/remote/model/request/verify_request.dart';
import 'package:job_baraka/data/remote/model/response/verify_reponse.dart';
import 'package:job_baraka/presentation/ui/login/repository/login_repository.dart';
import 'package:job_baraka/presentation/ui/login/repository/login_repository_impl.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository = LoginRepositoryImpl();

  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      switch (event) {
        case SendSmsEvent():
          {
            await _sendSmsEvent(event.request, emit);
          }

        case VerifySmsEvent():
          {
            await _verifySmsCodeEvent(event.request,emit);
          }



      }
    });
  }

  Future<void> _sendSmsEvent(LoginRequest request, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    await repository.login(request);

    emit(SendSmsState());
  }

  Future<void> _verifySmsCodeEvent(VerifyRequest request, Emitter<LoginState> emit) async{
    //emit(LoginLoadingState());

    final response = await repository.verifyNumber(request);


    print("token ----------->>${response.token}");
    emit(VerifySmsState(response: response));



  }


}
