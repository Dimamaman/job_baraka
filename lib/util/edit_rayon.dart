import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_baraka/generated/locale_keys.g.dart';

import '../presentation/ui/sign_up/bloc/sign_up_bloc.dart';

class EditDistrict extends StatefulWidget {
  final String regionId;

  const EditDistrict({super.key, required this.regionId});

  @override
  State<EditDistrict> createState() => _EditDistrictState();
}

class _EditDistrictState extends State<EditDistrict> {
  final _bloc = SignUpBloc();

  @override
  void initState() {
    _bloc.add(GetAllDistrictEvent(regionId: widget.regionId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: Text(LocaleKeys.district_text_in_profile.tr(),
              style: const TextStyle(fontFamily:'Mulish',fontSize: 20, fontWeight: FontWeight.w600, color: Color.fromRGBO(42, 50, 75, 1))),
        ),
        body: BlocBuilder<SignUpBloc, SignUpState>(
          builder: (context, state) {
            switch (state) {
              case SignUpLoadingState():
                {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

              case GetAllDistrictState():
                {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: ListView.builder(
                      itemCount: state.list.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context, state.list[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Builder(
                              builder: (context) {
                                if(context.locale == const Locale('en')) {
                                  return Text(state.list[index].name.en,
                                      style:const TextStyle(fontFamily: 'Mulish',fontSize: 16, fontWeight: FontWeight.w500, color: Color.fromRGBO(48, 48, 48, 1)));
                                }
                                else if(context.locale == const Locale('ru')) {
                                  return Text(state.list[index].name.ru,
                                      style:const TextStyle(fontFamily: 'Mulish',fontSize: 16, fontWeight: FontWeight.w500, color: Color.fromRGBO(48, 48, 48, 1)));
                                }
                                else if(context.locale == const Locale('es')) {
                                  return Text(state.list[index].name.kar,
                                      style:const TextStyle(fontFamily: 'Mulish',fontSize: 16, fontWeight: FontWeight.w500, color: Color.fromRGBO(48, 48, 48, 1)));
                                }
                                else if(context.locale == const Locale('uz','Latn')) {
                                  return Text(state.list[index].name.uzLatin,
                                      style:const TextStyle(fontFamily: 'Mulish',fontSize: 16, fontWeight: FontWeight.w500, color: Color.fromRGBO(48, 48, 48, 1)));
                                }


                                return Text(state.list[index].name.uzKiril,
                                    style:const TextStyle(fontFamily: 'Mulish',fontSize: 16, fontWeight: FontWeight.w500, color: Color.fromRGBO(48, 48, 48, 1)));
                              }
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
            }

            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Center(
                child: Text('Please check connected to the internet'),
              ),
            );
          },
        ),
      ),
    );
  }
}
