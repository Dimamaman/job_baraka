import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job_baraka/data/local/shared_preferences.dart';
import 'package:job_baraka/generated/locale_keys.g.dart';
import 'package:job_baraka/presentation/ui/sign_up/widgets/filled_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_location_page_client.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});


  @override
  State<SignUpPage> createState() => _SignUpPageState();

}

class _SignUpPageState extends State<SignUpPage> {
  bool _isEmployerSelected = false;
  bool _isWorkerSelected = false;
  final SharedPreferences pref = SharedPref.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LocaleKeys.sign_up_i.tr(),
              style: const TextStyle(fontFamily:'Mulish',fontWeight: FontWeight.w600, fontSize: 20, color: Color.fromRGBO(48, 48, 48, 1)),
            ),
            const SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isWorkerSelected = false;
                          _isEmployerSelected = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        decoration:  ShapeDecoration(
                            shape: OutlineInputBorder(
                                borderSide: _isEmployerSelected == true ? const BorderSide(color: Color.fromRGBO(42, 50, 75, 1)) :const BorderSide(color: Color.fromRGBO(194, 194, 194, 1)),
                                borderRadius: const BorderRadius.all(Radius.circular(16)))),
                        child: SvgPicture.asset('assets/icons/ic_employer.svg',color : _isEmployerSelected == true ? const Color.fromRGBO(42, 50, 75, 1): Color.fromRGBO(194, 194, 194, 1),),
                      ),
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      LocaleKeys.sign_up_employer.tr(),

                      style: const TextStyle(fontFamily:'Mulish',fontWeight: FontWeight.w400, fontSize: 14, color: Color.fromRGBO(48, 48, 48, 1)),
                    )
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isWorkerSelected = true;
                          _isEmployerSelected = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        decoration:  ShapeDecoration(
                            shape: OutlineInputBorder(
                                borderSide: _isWorkerSelected == true ? const BorderSide(color: Color.fromRGBO(42, 50, 75, 1)) :const BorderSide(color: Color.fromRGBO(194, 194, 194, 1)),
                                borderRadius:const BorderRadius.all(Radius.circular(16)))),
                        child: SvgPicture.asset('assets/icons/ic_worker.svg',color : _isWorkerSelected == true ? const Color.fromRGBO(42, 50, 75, 1): const Color.fromRGBO(194, 194, 194, 1),),
                      ),
                    ),

                    const SizedBox(height: 8,),
                    Text(
                      LocaleKeys.sign_up_worker.tr(),

                      style: const TextStyle(fontFamily:'Mulish',fontWeight: FontWeight.w400, fontSize: 14, color: Color.fromRGBO(48, 48, 48, 1)),
                    )
                  ],
                ),

              ],
            ),
            const   SizedBox(
              height: 36,
            ),
            FilledButtonInSignUp(onPress: () {
              if(_isEmployerSelected ) {

                pref.setBool("ROLE_CLIENT", true);
              }

              else if(_isWorkerSelected ) {
                pref.setBool("ROLE_CLIENT", false);

              }

              Navigator.push(context, MaterialPageRoute(builder: (context) => const EditLocationPageClient(),));

            }, isSelected: _isEmployerSelected ?_isEmployerSelected :_isWorkerSelected ,)
          ],
        ),
      ),
    );
  }
}
