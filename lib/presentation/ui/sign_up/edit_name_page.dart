import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_baraka/data/local/shared_preferences.dart';
import 'package:job_baraka/data/remote/model/request/edit_name_request.dart';
import 'package:job_baraka/generated/locale_keys.g.dart';
import 'package:job_baraka/presentation/ui/aboutme/select_service_page.dart';
import 'package:job_baraka/presentation/ui/login/bloc/login_bloc.dart';
import 'package:job_baraka/presentation/ui/main/main_page.dart';
import 'package:job_baraka/presentation/ui/sign_up/bloc/sign_up_bloc.dart';
import 'package:job_baraka/presentation/ui/sign_up/widgets/filled_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditNamePage extends StatefulWidget {
  const EditNamePage({super.key});

  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  final TextEditingController _controller = TextEditingController();
  bool _isDisableButton = true;
  final _bloc = SignUpBloc();
  late final SharedPreferences pref ;
  late bool role ;


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    pref = SharedPref.instance;
    role = pref.getBool("ROLE_CLIENT")!;
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
          child: BlocProvider(
            create: (context) => _bloc,
            child: BlocBuilder<SignUpBloc, SignUpState>(
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(LocaleKeys.title_edit_name_page.tr(), style: const TextStyle(fontFamily: 'Mulish',color: Color.fromRGBO(48, 48, 48, 1), fontSize: 20, fontWeight: FontWeight.w700)),
                    Container(
                      margin: const EdgeInsets.only(top: 24, right: 16, left: 16),
                      child: TextFormField(
                        controller: _controller,

                        maxLines: 1,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(24),
                        ],
                        onChanged: (value) {
                          setState(() {
                            if (_controller.text.isNotEmpty) {
                              _isDisableButton = true;
                            } else {
                              _isDisableButton = false;
                            }
                          });
                        },
                        keyboardType: TextInputType.text,
                        decoration:  InputDecoration(
                          label: Text(LocaleKeys.text_hint_edit_name_page.tr()),
                          isDense: true,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 24, right: 16, left: 16),
                      child: FilledButtonInSignUp(
                        onPress: _controller.text.isNotEmpty
                            ? () async {
                          _bloc.add(SendNameEvent(request: EditNameRequest(name: _controller.text))); // danniy jiberiw kk

                          final navigator = Navigator.of(context, rootNavigator: true);

                          if(role) {
                            navigator.pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => MainPage()),
                                  (route) => false,
                            );
                          }
                          else {
                            navigator.push(MaterialPageRoute(builder: (context) {
                              return const SelectServicePage();
                            },));
                          }



                        }
                            : null,
                        isSelected: _isDisableButton,
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
