import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_baraka/data/remote/model/request/login_request.dart';
import 'package:job_baraka/data/remote/model/request/verify_request.dart';
import 'package:job_baraka/generated/locale_keys.g.dart';
import 'package:job_baraka/presentation/ui/login/bloc/login_bloc.dart';
import 'package:job_baraka/presentation/ui/main/main_page.dart';
import 'package:job_baraka/presentation/ui/sign_up/sign_up.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/local/shared_preferences.dart';

class VerifyPage extends StatefulWidget {
  final String phone;

  const VerifyPage({super.key, required this.phone});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  late final Timer timer;
  late SharedPreferences pref;
  bool isError = false;

  int _time = 60;
  bool _isClicked = false;

  final _bloc = LoginBloc();

  @override
  void initState() {
    pref = SharedPref.instance;
    _sendAgain();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
      child: AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarColor: Color(0xfff5f5f5),
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
        
          body: BlocProvider(
            create: (context) => _bloc,
            child: SafeArea(child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                switch (state) {
                  case LoginLoadingState():
                    {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
        
                  case VerifySmsState():
                    {
        
                      if (state.response.token.isNotEmpty) {
                        pref.setBool("LOGIN", true);
                        pref.setString("TOKEN", state.response.token);
                        //_bloc.add(LoginLoadingEvent());
        
                        WidgetsBinding.instance.addPostFrameCallback((_) {
        
                          if (state.response.firstRegistered) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(),
                                ),
                                (route) => false);
                          } else {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainPage(),
                                ),
                                (route) => false);
                          }
                        });
                      }else {
                      }
                    }
                }
        
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        LocaleKeys.confirm_text_title.tr(),
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _myPinPut(state),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: TextButton(
                        onPressed: _isClicked
                            ? null
                            : () {
                                _sendAgain();
                              },
                        child: Text(
                          _isClicked
                              ? '00:${_time < 10 ? "0" : ""}${_time} ${LocaleKeys.confirm_text_ask_sms.tr()}'
                              : LocaleKeys.confirm_text_send_again.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                );
              },
            )),
          ),
        ),
      ),
    );
  }

  void _sendAgain() {

    _bloc.add(SendSmsEvent(request: LoginRequest(phone: widget.phone)));

    setState(() {
      _isClicked = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        print("$_time");
        if (_time > 0) {
          _time--;
        } else {
          _isClicked = false;
          _time = 60;
          timer.cancel();
        }
      });
    });
  }

  Widget _myPinPut(LoginState state) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(201, 201, 201, 1.0)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final errorPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(234, 116, 116, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 116, 116, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Theme.of(context).colorScheme.primary),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    switch (state) {}

    return Pinput(
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      errorPinTheme: errorPinTheme,
      validator: (s) {

      //  return isError  ? null : 'Nadurıs kod';
      },
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,

      errorTextStyle: const TextStyle(color: Color.fromRGBO(232, 110, 110, 1.0)),

      onCompleted: (pin) {


        _bloc.add(VerifySmsEvent(request: VerifyRequest(phone: widget.phone, code: pin)));
      },
    );
  }
}
