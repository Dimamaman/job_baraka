import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_baraka/data/local/model/id_name_data_in.dart';
import 'package:job_baraka/data/remote/model/request/edit_is_working_request.dart';
import 'package:job_baraka/data/remote/model/response/me_details_response.dart';
import 'package:job_baraka/data/remote/model/response/region_response.dart';
import 'package:job_baraka/generated/locale_keys.g.dart';
import 'package:job_baraka/presentation/ui/aboutme/services_page.dart';
import 'package:job_baraka/presentation/ui/profile/bloc/profile_bloc.dart';
import 'package:job_baraka/presentation/ui/profile/pages/add_worker_location.dart';
import 'package:job_baraka/presentation/ui/profile/pages/edit_name.dart';
import 'package:job_baraka/util/edit_rayon.dart';
import 'package:job_baraka/util/edit_region.dart';

import 'pages/edit_descreption.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  bool _isFirstButtonSelected = true;
  late bool _isWorking;
  final _bloc = ProfileBloc();
  final bloc = ProfileBloc();
  String _region = 'Region';
  String _district = 'District';
  int _regionId = 0;
  int _districtId = 0;

  String _serviceName = "";
  String _description = "";
  dynamic img = const AssetImage('assets/icons/ic_user.png');
  MyDetailsResponse? data;

  void _previousPage() {
    if (_currentPageIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.ease,
      );
      setState(() {
        _currentPageIndex--;
        _isFirstButtonSelected = true;
      });
    }
  }

  void _nextPage() {
    if (_currentPageIndex < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.ease,
      );
      setState(() {
        _currentPageIndex++;
        _isFirstButtonSelected = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(GetMeDetailsEvent());
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.xodim_profili_text_in_profile.tr(),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Color.fromRGBO(42, 50, 75, 1), fontFamily: 'Mulish'),
        ),
        backgroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (context) => _bloc,
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileGetMeDetailsState) {

              if(context.locale == const Locale('en')) {
                _region = state.response.data.region!.name.en;
                _district = state.response.data.district!.name.en;
                _serviceName = state.response.data.service!.name.en;
              }
              if(context.locale == const Locale('ru')) {
                _region = state.response.data.region!.name.ru;
                _district = state.response.data.district!.name.ru;
                _serviceName = state.response.data.service!.name.ru;
              }
              if(context.locale == const Locale('es')) {
                _region = state.response.data.region!.name.kar;
                _district = state.response.data.district!.name.kar;
                _serviceName = state.response.data.service!.name.kar;
              }
              if(context.locale ==const Locale('uz', 'Latn')) {
                _region = state.response.data.region!.name.uzLatin;
                _district = state.response.data.district!.name.uzLatin;
                _serviceName = state.response.data.service!.name.uzLatin;
              }
              if(context.locale ==const Locale('uz', 'Cyrl')) {
                _region = state.response.data.region!.name.uzKiril;
                _district = state.response.data.district!.name.uzKiril;
                _serviceName = state.response.data.service!.name.uzKiril;
              }


              _regionId = state.response.data.region!.id;
              _districtId = state.response.data.district!.id;
              _isWorking = state.response.data.isWorking;
              _description = state.response.data.description!;



              setState(() {
                data = state.response;
                img= NetworkImage(data!.data.avatar.toString());
              });
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return data == null
                  ? const Center(
                      child: Text("Error"),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();
                            XFile? image = await picker.pickImage(source: ImageSource.gallery);
                            File file = File(image!.path);

                            _bloc.add(EditAvatarEvent(avatar: file));
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 50,

                                backgroundImage: img ,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                LocaleKeys.edit_photo_text_in_profile.tr(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16, color: Color.fromRGBO(42, 50, 75, 1), fontFamily: 'Mulish'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FilledButton(
                              onPressed: () {
                                _previousPage();
                                setState(() {
                                  _isFirstButtonSelected = true;
                                });
                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  )),
                                  backgroundColor: MaterialStatePropertyAll(
                                      _isFirstButtonSelected ? const Color.fromRGBO(229, 229, 238, 1) : const Color.fromRGBO(229, 229, 238, 0.3))),
                              child: Text(LocaleKeys.kontakt_text_in_profile.tr(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: _isFirstButtonSelected ? const Color.fromRGBO(42, 50, 75, 1) : const Color.fromRGBO(118, 123, 145, 1),
                                      fontFamily: 'Mulish')

                                  // GoogleFonts.mulish(

                                  ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            FilledButton(
                              onPressed: () {
                                _nextPage();
                                setState(() {
                                  _isFirstButtonSelected = false;
                                });
                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  )),
                                  backgroundColor: MaterialStatePropertyAll(
                                      !_isFirstButtonSelected ? const Color.fromRGBO(229, 229, 238, 1) : const Color.fromRGBO(229, 229, 238, 0.3))),
                              child: Text(
                                LocaleKeys.xodim_profili_text_in_profile.tr(),
                                style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: !_isFirstButtonSelected ? const Color.fromRGBO(42, 50, 75, 1) : const Color.fromRGBO(118, 123, 145, 1)),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: PageView(
                            controller: _pageController,
                            children: [
                              // Содержимое первой страницы
                              Padding(
                                padding: const EdgeInsets.only(right: 16, left: 16, top: 48, bottom: 16),
                                child: ListView(
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromRGBO(42, 50, 75, 1), // Border color
                                          width: 1.0, // Border width
                                        ),
                                        borderRadius: BorderRadius.circular(10.0), // Border radius
                                      ),
                                      child: Text(
                                        data!.data.phone,
                                        style: const TextStyle(
                                            fontFamily: 'Mulish',
                                            fontSize: 16.0,
                                            color: Color.fromRGBO(144, 146, 152, 1),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ), // phone number
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final result = await Navigator.push(context, MaterialPageRoute(
                                          builder: (context) {
                                            return EditName(
                                              currentName: "${data!.data.name}",
                                            );
                                          },
                                        ));

                                        _bloc.add(EditNameEvent(name: result as String));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color.fromRGBO(42, 50, 75, 1), // Border color
                                            width: 1.0, // Border width
                                          ),
                                          borderRadius: BorderRadius.circular(10.0), // Border radius
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${data!.data.name}",
                                              style: const TextStyle(fontSize: 16.0, color: Color.fromRGBO(144, 146, 152, 1), fontWeight: FontWeight.w500,fontFamily: "Mulish"),
                                            ),
                                            SvgPicture.asset('assets/icons/ic_next.svg')
                                          ],
                                        ),
                                      ),
                                    ), // user name
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final result = await Navigator.push(context, MaterialPageRoute(
                                          builder: (context) {
                                            return const EditRegion();
                                          },
                                        ));

                                        _bloc.add(EditDistrictByRegionEvent(regionId: (result as RegionData).id));

                                        setState(() {
                                          _region = (result).name.ru;
                                          _regionId = (result).id;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color.fromRGBO(42, 50, 75, 1), // Border color
                                            width: 1.0, // Border width
                                          ),
                                          borderRadius: BorderRadius.circular(10.0), // Border radius
                                        ),
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _region,
                                                style: const TextStyle(fontFamily: 'Mulish',
                                                    fontSize: 16.0, color: Color.fromRGBO(144, 146, 152, 1), fontWeight: FontWeight.w500),
                                              ),
                                              SvgPicture.asset('assets/icons/ic_next.svg')
                                            ],
                                          ),
                                        ),
                                      ),
                                    ), // region
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final result = await Navigator.push(context, MaterialPageRoute(
                                          builder: (context) {
                                            return EditDistrict(regionId: _regionId.toString());
                                          },
                                        ));

                                        setState(() {
                                          _district = (result).name.ru;
                                          _districtId = (result).id;
                                        });

                                        _bloc.add(EditDistrictByDistrictEvent(districtId: _districtId));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color.fromRGBO(42, 50, 75, 1), // Border color
                                            width: 1.0, // Border width
                                          ),
                                          borderRadius: BorderRadius.circular(10.0), // Border radius
                                        ),
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _district,
                                                style: const TextStyle(fontFamily: 'Mulish',
                                                    fontSize: 16.0, color: Color.fromRGBO(144, 146, 152, 1), fontWeight: FontWeight.w500),
                                              ),
                                              SvgPicture.asset('assets/icons/ic_next.svg')
                                            ],
                                          ),
                                        ),
                                      ),
                                    ), // district
                                  ],
                                ),
                              ),
                              // Содержимое второй страницы
                              Padding(
                                padding: const EdgeInsets.only(right: 16, left: 16, top: 24, bottom: 16),
                                child: ListView(
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16.0),
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(229, 229, 238, 1),

                                        borderRadius: BorderRadius.circular(10.0), // Border radius
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            LocaleKeys.xodim_rejimi_text_in_profile.tr(),
                                            style: const TextStyle(fontFamily: 'Mulish',
                                                fontSize: 16.0, color: Color.fromRGBO(48, 48, 48, 1), fontWeight: FontWeight.w600),
                                          ),
                                          Switch.adaptive(
                                            inactiveThumbColor: const Color.fromRGBO(118, 123, 145, 1),
                                            inactiveTrackColor: const Color.fromRGBO(199, 204, 219, 1),
                                            activeColor: Colors.green,
                                            value: _isWorking,
                                            onChanged: (value) {
                                              _bloc.add(EditIsWorkingEvent(request: EditIsWorkingRequest(isWorking: !_isWorking)));

                                              setState(() {
                                                if (_isWorking) {
                                                  _isWorking = false;
                                                } else {
                                                  _isWorking = true;
                                                }
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final res = await Navigator.push(context, MaterialPageRoute(
                                          builder: (context) {
                                            return const AddWorkerLocation();
                                          },
                                        ));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(16.0),
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(229, 229, 238, 1),

                                          borderRadius: BorderRadius.circular(10.0), // Border radius
                                        ),
                                        child: const Icon(
                                          size: 32,
                                          Icons.add_location_alt,
                                          color: Color.fromRGBO(118, 123, 145, 1),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final res = await Navigator.push(context, MaterialPageRoute(
                                          builder: (context) {
                                            return const ServicesPage();
                                          },
                                        ));

                                        setState(() {
                                          _serviceName = (res as Dates).serviceName;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color.fromRGBO(42, 50, 75, 1), // Border color
                                            width: 1.0, // Border width
                                          ),
                                          borderRadius: BorderRadius.circular(10.0), // Border radius
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _serviceName,
                                              style: const TextStyle(fontFamily: 'Mulish',
                                                  fontSize: 16.0, color: Color.fromRGBO(194, 194, 194, 1), fontWeight: FontWeight.w600),
                                            ),
                                            SvgPicture.asset('assets/icons/ic_next.svg')
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: GestureDetector(
                                        onTap: () async {
                                          final result = await Navigator.push(context, MaterialPageRoute(
                                            builder: (context) {
                                              return EditDescription(
                                                currentDescription: "${data!.data.description}",
                                              );
                                            },
                                          ));

                                          String description = result as String;

                                          _bloc.add(EditDescriptionEvent(description: description));

                                          setState(() {
                                            _description = description;
                                          });
                                        },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  LocaleKeys.about_us_text_in_profile.tr(),
                                                  style: const TextStyle(fontFamily: 'Mulish',
                                                      fontSize: 14.0, color: Color.fromRGBO(144, 146, 152, 1), fontWeight: FontWeight.w400),
                                                ),
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                SvgPicture.asset(
                                                  'assets/icons/ic_next.svg',
                                                  width: 16,
                                                  height: 16,
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8),
                                              child: Text(
                                                _description,
                                                style: const TextStyle(fontFamily: 'Mulish',
                                                    fontSize: 16.0, color: Color.fromRGBO(48, 48, 48, 1), fontWeight: FontWeight.w400),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onPageChanged: (int index) {
                              setState(() {
                                _currentPageIndex = index;
                                _isFirstButtonSelected = index == 0;
                              });
                            },
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}
