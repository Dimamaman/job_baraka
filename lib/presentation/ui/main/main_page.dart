import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

import 'package:another_flushbar/flushbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:job_baraka/data/remote/model/response/call_history_response.dart';
import 'package:job_baraka/data/remote/model/response/get_all_services_response.dart';
import 'package:job_baraka/data/remote/model/response/get_workers_response.dart';
import 'package:job_baraka/generated/locale_keys.g.dart';
import 'package:job_baraka/presentation/ui/login/login_page.dart';
import 'package:job_baraka/presentation/ui/main/bloc/main_bloc.dart';
import 'package:job_baraka/presentation/ui/main/widgets/filled_button_main.dart';
import 'package:job_baraka/presentation/ui/profile/profile_page.dart';
import 'package:job_baraka/presentation/ui/profile/widgets/button_in_profile.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late GoogleMapController _controller;

  final Location _location = Location();

  final _bloc = MainBloc();
  String searchText = '';
  List<Service> searchResults = [];
  final TextEditingController _searchController = TextEditingController();
  final List<Service> services = [];
  final Set<Marker> _markers = {};
  late Locale currentLocale;
  String lat = "";
  String lng = "";

  @override
  void initState() {
    _bloc.add(GetAllServicesEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocListener<MainBloc, MainState>(
        listener: (context, state) {
          if (state is MainLogOutState) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
                    (route) => false);
          }
          if (state is GetAllServicesState) {
            for (var element in state.services) {
              for (var it in element.services) {
                services.add(it);
              }
            }
          }
          if (state is GetWorkersState) {
            _markers.clear();
            double minDistance = 10000000;

            if (state.response.data.isEmpty) {
              _showSnackBar(LocaleKeys.not_worker_bottom_snackbar_main.tr());
            } else {
              _showSnackBar("`${state.response.data.length} ${LocaleKeys.has_worker_bottom_snackbar_main.tr()}");

              state.response.data.forEach((worker) async {
                dynamic avatar = await circleCropImage('assets/icons/ic_user.png', 100, false);
                if (worker.avatar.isNotEmpty) {
                  avatar = await circleCropImage(worker.avatar, 100, true);
                }

                if (double.parse(worker.distance) <= minDistance) {
                  minDistance = double.parse(worker.distance);
                  lat = worker.lat;
                  lng = worker.lng;
                }

                final marker = Marker(
                  markerId: MarkerId("${worker.hashCode}"),
                  position: LatLng(double.parse(worker.lat), double.parse(worker.lng)),
                  icon: BitmapDescriptor.fromBytes(avatar as Uint8List),

                  //icon: worker.avatar.isNotEmpty ? BitmapDescriptor.fromBytes(avatar as Uint8List) : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
                  onTap: () {
                    _showWorkerInfoBottomSheet(context, worker);
                  },
                );

                _markers.add(marker);
              });

              _controller.animateCamera(
                CameraUpdate.newLatLngZoom(
                  LatLng(double.parse(lat), double.parse(lng)),
                  12.0,
                ),
              );
            }

            setState(() {});

          }

          if (state is CallHistoryState) {
            Navigator.of(context).pop();
            _showCallHistoryBottomSheet(context, state.response);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: AnnotatedRegion(
              value: const SystemUiOverlayStyle(
                statusBarColor: Color(0xfff5f5f5),
                statusBarIconBrightness: Brightness.dark,
              ),
              child: Stack(
                children: [
                  GoogleMap(
                    markers: _markers,
                    initialCameraPosition: const CameraPosition(target: LatLng(0, 0)),
                    mapType: MapType.normal,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    onMapCreated: _onMapCreated,
                    scrollGesturesEnabled: true,
                    zoomGesturesEnabled: true,
                    myLocationEnabled: true,
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: IconButton(
                        padding: const EdgeInsets.all(16),
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                        icon: SvgPicture.asset(
                          'assets/icons/ic.svg',
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () {
                          _showMenuBottomSheet(context);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)), // Установка радиуса
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.only(left: 24.0, top: 24.0, right: 16.0, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (searchResults.isNotEmpty)
                            Container(
                              height: 160.0,
                              margin: const EdgeInsets.only(bottom: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ListView.builder(
                                padding: const EdgeInsets.only(top: 0),
                                itemCount: searchResults.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Builder(
                                      builder: (context) {
                                        if(context.locale == const Locale('ru')) {
                                          return Text(searchResults[index].name.ru,
                                              style: const TextStyle(
                                                  fontFamily: 'Mulish', fontSize: 16, fontWeight: FontWeight.w600, color: Color.fromRGBO(48, 48, 48, 1)));
                                        }
                                        else  if(context.locale == const Locale('en')) {
                                          return Text(searchResults[index].name.en,
                                              style: const TextStyle(
                                                  fontFamily: 'Mulish', fontSize: 16, fontWeight: FontWeight.w600, color: Color.fromRGBO(48, 48, 48, 1)));
                                        }
                                        else  if(context.locale == const Locale('uz', 'Latn')) {
                                          return Text(searchResults[index].name.uzLatin,
                                              style: const TextStyle(
                                                  fontFamily: 'Mulish', fontSize: 16, fontWeight: FontWeight.w600, color: Color.fromRGBO(48, 48, 48, 1)));
                                        }
                                        else  if(context.locale == const Locale('uz', 'Cyrl')) {
                                          return Text(searchResults[index].name.uzLatin,
                                              style: const TextStyle(
                                                  fontFamily: 'Mulish', fontSize: 16, fontWeight: FontWeight.w600, color: Color.fromRGBO(48, 48, 48, 1)));
                                        }

                                        return Text(searchResults[index].name.kar,
                                            style: const TextStyle(
                                                fontFamily: 'Mulish', fontSize: 16, fontWeight: FontWeight.w600, color: Color.fromRGBO(48, 48, 48, 1)));
                                      }
                                    ),
                                    onTap: () async {
                                      final current = await _location.getLocation();

                                      _bloc.add(GetWorkersEvent(serviceId: searchResults[index].id, lat: current.latitude!, lng: current.longitude!));
                                      setState(() {
                                        searchText = '';
                                        searchResults.clear();
                                        _searchController.clear();
                                        FocusScope.of(context).unfocus();
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          TextField(
                            controller: _searchController,
                            onChanged: (value) => search(value),
                            decoration: InputDecoration(
                              hintText: LocaleKeys.search_text_in_main.tr(),
                              border: const OutlineInputBorder(borderSide: BorderSide(), borderRadius: BorderRadius.all(Radius.circular(12))),
                              suffixIcon: searchText.isNotEmpty
                                  ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    searchText = '';
                                    searchResults.clear();
                                    _searchController.clear();
                                  });
                                },
                              )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 280,
                      right: 16,
                      bottom: 0,
                      child: GestureDetector(
                        child: Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _controller.animateCamera(
                                    CameraUpdate.zoomIn(),
                                  );
                                },
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Color.fromRGBO(118, 123, 145, 1),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _controller.animateCamera(
                                    CameraUpdate.zoomOut(),
                                  );
                                },
                                child: Container(
                                  height: 44,
                                  width: 44,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    color: Color.fromRGBO(118, 123, 145, 1),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              GestureDetector(
                                onTap: () {
                                  animateToUserLocation();
                                },
                                child: Container(
                                  height: 44,
                                  width: 44,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(100)),
                                  ),
                                  child: const Icon(
                                    Icons.my_location_outlined,
                                    color: Color.fromRGBO(118, 123, 145, 1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void search(String query) {
    setState(() {
      searchText = query;
      if (query.isEmpty) {
        searchResults = [];
      } else {


        if (context.locale == const Locale('en')) {


          searchResults = services.where((service) => service.name.en.toLowerCase().contains(query.toLowerCase())).toList();
        } else if (context.locale == const Locale('ru')) {


          searchResults = services.where((service) => service.name.ru.toLowerCase().contains(query.toLowerCase())).toList();
        } else if (context.locale == const Locale('es')) {

          searchResults = services.where((service) {

            return service.name.kar.toLowerCase().contains(query.toLowerCase());

          }).toList();

        } else if (context.locale == const Locale('uz', 'Latn')) {


          searchResults = services.where((service) => service.name.uzLatin.toLowerCase().contains(query.toLowerCase())).toList();
        } else if (context.locale == const Locale('uz', 'Cyrl')) {

          searchResults = services.where((service) => service.name.uzKiril.toLowerCase().contains(query.toLowerCase())).toList();
        }
      }
    });
  }

  void animateToUserLocation() async {
    // Получение текущего местоположения пользователя
    var location = await Location().getLocation();
    // Анимация перемещения к местоположению пользователя
    _controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(location.latitude!, location.longitude!),
        15.0, // Установите желаемый уровень масштабирования
      ),
    );
  }



  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    animateToUserLocation();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  void _showMenuBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 16,
              ),
              ListTile(
                leading: SvgPicture.asset('assets/icons/ic_edit_profile.svg'),
                title: Text(
                  LocaleKeys.profile_text_bottom_sheet.tr(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color.fromRGBO(48, 48, 48, 1), fontFamily: 'Mulish'),
                ),
                onTap: () {
                  // Действия при нажатии на раздел "Профиль"
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ));

                  // Здесь можно добавить код для открытия профиля
                },
              ),
              const SizedBox(
                height: 8,
              ),
              ListTile(
                leading: SvgPicture.asset('assets/icons/ic_change_language.svg'),
                title: Text(
                  LocaleKeys.change_language_text_bottom_sheet.tr(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color.fromRGBO(48, 48, 48, 1), fontFamily: 'Mulish'),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _showChangeLanguageSheet(context);
                },
              ),
              const SizedBox(
                height: 8,
              ),
              ListTile(
                leading: SvgPicture.asset('assets/icons/ic_call_history.svg'),
                title: Text(
                  LocaleKeys.cal_history_text_bottom_sheet.tr(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color.fromRGBO(48, 48, 48, 1), fontFamily: 'Mulish'),
                ),
                onTap: () {
                  _bloc.add(CallHistoryEvent());
                  //List<CallHistoryData> listss = [CallHistoryData(id: id, name: name, service: service, status: status, date: date)]
                  // Navigator.of(context).pop();
                },
              ),
              const SizedBox(
                height: 8,
              ),
              ListTile(
                leading: SvgPicture.asset('assets/icons/ic_log_out.svg'),
                title: Text(
                  LocaleKeys.log_out_text_bottom_sheet.tr(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color.fromRGBO(48, 48, 48, 1), fontFamily: 'Mulish'),
                ),
                onTap: () {
                  // Действия при нажатии на раздел "Выход из профиля"
                  Navigator.of(context).pop();

                  _showLogOutBottomSheet(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showChangeLanguageSheet(BuildContext context) {
    currentLocale = context.locale;

    showModalBottomSheet(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            currentLocale == const Locale('es') ? const Color.fromRGBO(225, 229, 238, 1) : const Color.fromRGBO(247, 244, 251, 1)),
                        padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
                        shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ))),
                    onPressed: () {
                      setState(() {
                        context.setLocale(const Locale('es'));
                      });

                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Qaraqalpaqsha",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color.fromRGBO(48, 48, 48, 1), fontFamily: 'Mulish'),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        currentLocale == const Locale('es')
                            ? const Icon(
                          Icons.check_circle,
                          color: Color.fromRGBO(42, 50, 75, 1),
                          size: 20,
                        )
                            : const SizedBox()
                      ],
                    )),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(currentLocale == const Locale('uz', 'Latn')
                            ? const Color.fromRGBO(225, 229, 238, 1)
                            : const Color.fromRGBO(247, 244, 251, 1)),
                        padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
                        shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ))),
                    onPressed: () {
                      setState(() {
                        context.setLocale(const Locale('uz', 'Latn'));
                      });
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "O`zbekcha",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color.fromRGBO(48, 48, 48, 1), fontFamily: 'Mulish'),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        currentLocale == const Locale('uz', 'Latn')
                            ? const Icon(
                          Icons.check_circle,
                          color: Color.fromRGBO(42, 50, 75, 1),
                          size: 20,
                        )
                            : const SizedBox()
                      ],
                    )),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(currentLocale == const Locale('uz', 'Cyrl')
                            ? const Color.fromRGBO(225, 229, 238, 1)
                            : const Color.fromRGBO(247, 244, 251, 1)),
                        padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
                        shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ))),
                    onPressed: () {
                      setState(() {
                        context.setLocale(const Locale('uz', 'Cyrl'));
                      });
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Узбекча",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color.fromRGBO(48, 48, 48, 1), fontFamily: 'Mulish'),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        currentLocale == const Locale('uz', 'Cyrl')
                            ? const Icon(
                          Icons.check_circle,
                          color: Color.fromRGBO(42, 50, 75, 1),
                          size: 20,
                        )
                            : const SizedBox()
                      ],
                    )),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            currentLocale == const Locale('ru') ? const Color.fromRGBO(225, 229, 238, 1) : const Color.fromRGBO(247, 244, 251, 1)),
                        padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
                        shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ))),
                    onPressed: () {
                      setState(() {
                        context.setLocale(const Locale('ru'));
                      });
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Русский",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color.fromRGBO(48, 48, 48, 1), fontFamily: 'Mulish'),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        currentLocale == const Locale('ru')
                            ? const Icon(
                          Icons.check_circle,
                          color: Color.fromRGBO(42, 50, 75, 1),
                          size: 20,
                        )
                            : const SizedBox()
                      ],
                    )),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            currentLocale == const Locale('en') ? const Color.fromRGBO(225, 229, 238, 1) : const Color.fromRGBO(247, 244, 251, 1)),
                        padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
                        shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ))),
                    onPressed: () {
                      setState(() {
                        context.setLocale(const Locale('en'));
                      });
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "English",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color.fromRGBO(48, 48, 48, 1), fontFamily: 'Mulish'),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        currentLocale == const Locale('en')
                            ? const Icon(
                          Icons.check_circle,
                          color: Color.fromRGBO(42, 50, 75, 1),
                          size: 20,
                        )
                            : const SizedBox()
                      ],
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWorkerInfoBottomSheet(BuildContext context, Worker worker) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(left: 16, top: 24, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: worker.avatar.isNotEmpty ? NetworkImage(worker.avatar) : null,
                    child: worker.avatar.isNotEmpty
                        ? null
                        : const Icon(
                      Icons.person,
                      size: 80,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    worker.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color.fromRGBO(48, 48, 48, 1), fontFamily: 'Mulish'),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.worker_info_speciality_text.tr(),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color.fromRGBO(48, 48, 48, 1), fontFamily: 'Mulish'),
                      ),
                      Text(
                        worker.service.ru,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color.fromRGBO(48, 48, 48, 1), fontFamily: 'Mulish'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.login_text_text.tr(),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color.fromRGBO(48, 48, 48, 1), fontFamily: 'Mulish'),
                      ),
                      Text(
                        worker.phone,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color.fromRGBO(48, 48, 48, 1), fontFamily: 'Mulish'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      worker.description,
                      style: const TextStyle( fontFamily: 'Mulish',
                        fontSize: 18.0,
                        color: Color.fromRGBO(48, 48, 48, 1),
                        fontWeight: FontWeight.w400,
                      ),
                      softWrap: true, // Устанавливаем перенос текста на следующую строку
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              worker.isWorking
                  ? FilledButtonMain(onPress: () async {
                _makePhoneCall(worker.phone);

                _bloc.add(CallWorkerEvent(workerId: worker.id));
              })
                  : Text(
                LocaleKeys.worker_doesnt_accepting_orders.tr(),

                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color.fromRGBO(216, 75, 75, 1), fontFamily: 'Mulish'),

                softWrap: true, // Устанавливаем перенос текста на следующую строку
              ),
              const SizedBox(
                height: 12,
              )
            ],
          ),
        );
      },
    );
  }

  void _showCallHistoryBottomSheet(BuildContext context, List<CallHistoryData> response) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 450,
                  minHeight: constraints.minHeight,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        LocaleKeys.call_history_text.tr(),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color.fromRGBO(48, 48, 48, 1), fontFamily: 'Mulish'),
                      ),
                      const SizedBox(height: 16),
                      response.isEmpty
                          ? Text(
                        textAlign: TextAlign.center,
                        LocaleKeys.call_empty_text.tr(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400, color: Color.fromRGBO(48, 48, 48, 1), fontFamily: 'Mulish'),
                      )
                          : const SizedBox(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          response.length,
                              (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      response[index].name,
                                      style: const TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.w600, color: Color.fromRGBO(48, 48, 48, 1), fontFamily: 'Mulish'),
                                    ),
                                    Text(
                                      "${response[index].date.day}/${response[index].date.month}/${response[index].date.year}",
                                      style: const TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.w400, color: Color.fromRGBO(48, 48, 48, 1), fontFamily: 'Mulish'),
                                    ),
                                  ],
                                ),
                                Text(
                                  response[index].service.ru,
                                  style: const TextStyle(
                                      fontSize: 14, fontWeight: FontWeight.w400, color: Color.fromRGBO(48, 48, 48, 1), fontFamily: 'Mulish'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showSnackBar(
      String text,
      ) {
    Flushbar(
      animationDuration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.only(left: 16, right: 32, top: 24, bottom: 24),
      message: text,
      duration: const Duration(milliseconds: 1500),
    ).show(context);
  }

  Future<Uint8List> _convertImageToUint8List(Image image) async {
    Completer<Uint8List> completer = Completer();

    // Create a listener for the ImageStream
    ImageStreamListener listener = ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) async {
      // Convert the ImageInfo to ByteData
      ByteData? byteData = await imageInfo.image.toByteData(format: ImageByteFormat.png);

      // Access the ByteData buffer as Uint8List
      Uint8List? bytes = byteData?.buffer.asUint8List();

      completer.complete(bytes!);
    });

    // Add the listener to the image stream
    image.image.resolve(const ImageConfiguration()).addListener(listener);

    // Return the Uint8List when it's ready
    return completer.future;
  }

  Future<Uint8List> circleCropImage(String imageUrl, int size, bool isNetwork) async {
    // Load the image from the network URL
    Image image = Image.asset(
      imageUrl,
      width: 100,
      height: 100,
      cacheHeight: 100,
      cacheWidth: 100,
    );
    if (isNetwork) {
      image = Image.network(
        imageUrl,
        width: 100,
        height: 100,
        cacheHeight: 100,
        cacheWidth: 100,
      );
    }

    // Load the image from network
    Uint8List imageData = await _convertImageToUint8List(image);

    // Decode the image using the image package
    img.Image originalImage = img.decodeImage(imageData)!;

    // Crop the image to a circle using the image package
    img.Image croppedImage = img.copyCropCircle(originalImage);

    // Resize the cropped image to the desired size
    img.Image resizedImage = img.copyResize(croppedImage, width: size, height: size);

    // Encode the resized image back to Uint8List
    Uint8List resizedImageData = img.encodePng(resizedImage);

    return resizedImageData;
  }

  void _showLogOutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                textAlign: TextAlign.center,
                LocaleKeys.log_out_title.tr(),
                style: const TextStyle(fontSize: 16.0, color: Color.fromRGBO(48, 48, 48, 1), fontWeight: FontWeight.w600, fontFamily: 'Mulish'),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  FilledButtonInProfile(
                      onPress: () {
                        Navigator.of(context).pop();
                      },
                      text: LocaleKeys.log_out_button_no.tr(),
                      bgColor: Colors.transparent,
                      textColor: const Color.fromRGBO(48, 48, 48, 1)),
                  FilledButtonInProfile(
                    text: LocaleKeys.log_out_title_yes.tr(),
                    bgColor: const Color.fromRGBO(216, 75, 75, 1),
                    onPress: () {
                      _bloc.add(MainLogOutEvent());
                      Navigator.of(context).pop();
                    },
                    textColor: Colors.white,
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
