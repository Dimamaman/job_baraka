import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_baraka/data/local/model/id_name_data_in.dart';
import 'package:job_baraka/generated/locale_keys.g.dart';
import 'package:job_baraka/presentation/ui/aboutme/bloc/about_me_bloc.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final bloc = AboutMeBloc();
  String textOut = "";
  String textIn = "";

  @override
  void initState() {
    super.initState();

    bloc.add(AboutMeGetAllEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => bloc,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              LocaleKeys.service_page_title.tr(),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Color.fromRGBO(42, 50, 75, 1), fontFamily: 'Mulish'),
            ),
          ),
          body: BlocBuilder<AboutMeBloc, AboutMeState>(
            builder: (context, state) {
              if (state is AboutMeLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is AboutMeGetAllServicesState) {
                return ListView.builder(
                  itemCount: state.services.length,
                  itemBuilder: (context, outerIndex) {
                    if (context.locale == const Locale('en')) {
                      textOut = state.services[outerIndex].categoryName.en;
                    }
                    if (context.locale == const Locale('ru')) {
                      textOut = state.services[outerIndex].categoryName.ru;
                    }
                    if (context.locale ==const Locale('es')) {
                      textOut = state.services[outerIndex].categoryName.kar;
                    }
                    if (context.locale ==const Locale('uz', 'Latn')) {
                      textOut = state.services[outerIndex].categoryName.uzLatin;
                    }
                    if (context.locale ==const Locale('uz', 'Cyrl')) {
                      textOut = state.services[outerIndex].categoryName.uzKiril;
                    }
                    return Column(
                      children: [
                        ListTile(
                            onTap: () {
                              setState(() {
                                state.services[outerIndex].isOpen = !state.services[outerIndex].isOpen;
                              });
                            },
                            title: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(textOut,
                                  style: const TextStyle(fontFamily: 'Mulish',fontSize: 18, fontWeight: FontWeight.w700, color: Color.fromRGBO(48, 48, 48, 1))),
                            )),
                        if (state.services[outerIndex].isOpen)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.services[outerIndex].services.length,
                            itemBuilder: (context, innerIndex) {
                              if (context.locale == const Locale('en')) {
                                textIn = state.services[outerIndex].services[innerIndex].name.en;
                              }
                              if (context.locale == const Locale('ru')) {
                                textIn = state.services[outerIndex].services[innerIndex].name.ru;
                              }
                              if (context.locale ==const Locale('es')) {
                                textIn = state.services[outerIndex].services[innerIndex].name.kar;
                              }
                              if (context.locale ==const Locale('uz', 'Latn')) {
                                textIn = state.services[outerIndex].services[innerIndex].name.uzLatin;
                              }
                              if (context.locale ==const Locale('uz', 'Cyrl')) {
                                textIn = state.services[outerIndex].services[innerIndex].name.uzKiril;
                              }

                              return ListTile(
                                onTap: () {
                                  bloc.add(EditJobEvent(serviceId: state.services[outerIndex].services[innerIndex].id));

                                  Navigator.pop(
                                      context,
                                      Dates(
                                          id: state.services[outerIndex].services[innerIndex].id,
                                          serviceName: state.services[outerIndex].services[innerIndex].name.ru));
                                },
                                title: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 36.0),
                                  child: Text(
                                    textIn,
                                    style:
                                         const TextStyle(
                                            fontFamily: 'Mulish', fontSize: 16, fontWeight: FontWeight.w400, color: Color.fromRGBO(48, 48, 48, 1)),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    );
                  },
                );
              }

              return const Center(
                child: Text("Qate"),
              );
            },
          ),
        ));
  }
}
