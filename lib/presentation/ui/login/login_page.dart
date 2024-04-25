import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_baraka/data/remote/model/request/login_request.dart';
import 'package:job_baraka/generated/locale_keys.g.dart';
import 'package:job_baraka/presentation/ui/login/bloc/login_bloc.dart';
import 'package:job_baraka/presentation/ui/login/widgets/filled_button.dart';
import 'package:job_baraka/presentation/ui/login/verify_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isDisableButton = true;
  final _bloc = LoginBloc();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc.add(LoginLoadingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: BlocProvider(
            create: (context) => _bloc,
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {

                switch(state) {


                  case LoginLoadingState() :{

                    return const Center(child: CircularProgressIndicator());
                  }
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(LocaleKeys.login_text_title.tr(),
                        style: TextStyle(color: Color.fromRGBO(48, 48, 48, 1), fontSize: 20, fontWeight: FontWeight.w700)),
                    Container(
                      margin: const EdgeInsets.only(top: 24, right: 16, left: 16),
                      child: TextFormField(
                        controller: _controller,
                        maxLines: 1,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(9),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          setState(() {
                            _isDisableButton = value.length == 9 ? false : true;
                          });
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixText: '+998 ',
                          label: Text(LocaleKeys.login_text_text.tr()),
                          isDense: true,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 24, right: 16, left: 16),
                      child: FilledButtonInLogin(
                        controller: _controller,
                        onPress: _controller.text.isNotEmpty ? () {
                          // _bloc.add(SendSmsEvent(phone: '+998${_controller.text}'));

                        //  _bloc.add(SendSmsEvent(request: LoginRequest(phone: '998${_controller.text}')));
                          Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyPage(phone: '998${_controller.text}',)));

                        } : null,
                      ),
                    ),

                  ],
                );
              },
            ),
          )),
    );
  }


}
