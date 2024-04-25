import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_baraka/data/remote/model/response/region_response.dart';
import 'package:job_baraka/generated/locale_keys.g.dart';

import '../presentation/ui/sign_up/bloc/sign_up_bloc.dart';

class EditRegion extends StatefulWidget {
  const EditRegion({super.key});

  @override
  State<EditRegion> createState() => _EditRegionState();
}

class _EditRegionState extends State<EditRegion> {
  final List<RegionData> regions = [];
  final _bloc = SignUpBloc();
  String  text = "";
  @override
  void initState() {
    _bloc.add(GetAllRegionEvent());
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
          title: Text(LocaleKeys.region_text_in_profile.tr(),
              style: const TextStyle(fontFamily: 'Mulish', fontSize: 20, fontWeight: FontWeight.w600, color: Color.fromRGBO(42, 50, 75, 1))),
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

              case GetAllRegionsState():
                {
                  regions.addAll(state.response.data);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: ListView.builder(
                      itemCount: regions.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context, regions[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Builder(



                              builder: (context) {

                                if(context.locale == const Locale('en')) {
                                  text = regions[index].name.en;
                                }
                                if(context.locale == const Locale('ru')) {
                                  text = regions[index].name.ru;
                                }
                                if(context.locale == Locale('es')) {
                                  text = regions[index].name.kar;
                                }
                                if(context.locale == Locale('uz', 'Latn')) {
                                  text = regions[index].name.uzLatin;
                                }
                                if(context.locale == Locale('uz', 'Cyrl')) {
                                  text = regions[index].name.uzKiril;
                                }


                                return Text(text,
                                    style:  const TextStyle(fontFamily: 'Mulish',fontSize: 16, fontWeight: FontWeight.w500, color: Color.fromRGBO(48, 48, 48, 1)));
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
