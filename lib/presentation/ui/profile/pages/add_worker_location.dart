import 'dart:async';
import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:job_baraka/data/local/shared_preferences.dart';
import 'package:job_baraka/data/remote/model/request/add_worker_location_request.dart';
import 'package:job_baraka/generated/locale_keys.g.dart';
import 'package:job_baraka/presentation/ui/profile/bloc/worker_location_bloc/worker_location_bloc.dart';
import 'package:job_baraka/presentation/ui/profile/widgets/button_in_profile.dart';
import 'package:job_baraka/util/filled_button_all.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:image/image.dart' as img;

class AddWorkerLocation extends StatefulWidget {
  const AddWorkerLocation({super.key});

  @override
  State<AddWorkerLocation> createState() => _AddWorkerLocationState();
}

class _AddWorkerLocationState extends State<AddWorkerLocation> {
  late GoogleMapController _controller;
  late LocationData _currentLocation = LocationData.fromMap({
    'latitude': 0.0,
    'longitude': 0.0,
  });
  final Location _location = Location();
  double _buttonScale1 = 1.0;
  double _buttonScale2 = 1.0;
  double _buttonScale3 = 1.0;

  final Set<Marker> _markers = {};
  bool _isVisibleCircular = true;
  final TextEditingController _controllerTextField = TextEditingController();
  final _bloc = WorkerLocationBloc();
  final SharedPreferences pref = SharedPref.instance;

  @override
  void initState() {
    super.initState();
    currentLocation();

    _bloc.add(GetCurrentLocationEvent());
  }

  void _animateMyLocation() async {
    _location.getLocation().then((value) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(value.latitude ?? 0, value.longitude ?? 0),
          zoom: 15,
        ),
      ));
    });
  }

  void currentLocation() async {
    _currentLocation = await Location().getLocation();

    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(
          _currentLocation.latitude ?? 0,
          _currentLocation.longitude ?? 0,
        ),
        zoom: 15,
      ),
    ));

    await _location.getLocation().then((value) {
      _currentLocation = value;

      _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(value.latitude ?? 0, value.longitude ?? 0),
          zoom: 15,
        ),
      ));
    });
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

  Future<Uint8List> circleCropImage(String imageUrl, int size) async {

    // Load the image from the network URL
    Image image = Image.network(
      imageUrl,
      width: 120,
      height: 120,
      cacheHeight: 120,
      cacheWidth: 120,

    );



    // Load the image from network
    Uint8List imageData = await  _convertImageToUint8List(image);



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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocListener<WorkerLocationBloc, WorkerLocationState>(
          listener: (context, state) {
            if (state is BackToProfileScreenState) {
              Navigator.pop(context);
            }
            if (state is GetCurrentLocationState) {
              setState(() async {
                _isVisibleCircular = false;
                final Uint8List markerIcon = await circleCropImage(state.response.data[0].avatar, 120);
                //BitmapDescriptor customIcon2 = await circleCropImage(state.response.data[0].avatar);

                for (var element in state.response.data) {
                  String latString = element.lat;
                  double lat = double.parse(latString);
                  String lngString = element.lng;
                  double lng = double.parse(lngString);

                  _markers.add(
                    Marker(
                      markerId: MarkerId('${element.hashCode}'),
                      position: LatLng(lat, lng),


                      onTap: () {
                        if(_markers.length == 1) {
                          _showSnackBar(LocaleKeys.remove_location_last_location_text.tr());

                        }else {
                          _showRemoveBottomSheet(context, element.hashCode.toString(), element.id);
                        }
                      },
                      icon: BitmapDescriptor.fromBytes(markerIcon,),

                    ),
                  );
                }

                setState(() {});
              });
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(LocaleKeys.edit_location_title.tr()
                  ,style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Color.fromRGBO(42, 50, 75, 1), fontFamily: 'Mulish'),

              ),
            ),

            body: SafeArea(
              child: BlocBuilder<WorkerLocationBloc, WorkerLocationState>(
                builder: (context, state) {
                  return Stack(
                    children: [
                      GoogleMap(
                        markers: _markers,
                        mapType: MapType.normal,

                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        onMapCreated: (controller) {
                          setState(() {
                            _controller = controller;
                            _animateMyLocation();
                          });
                        },
                        onTap: (argument) {

                          if(_markers.length < 2) {

                            _showAddBottomSheet(context, argument.latitude.toString(), argument.longitude.toString());
                          }else {

                            _showSnackBar(LocaleKeys.ikki_tuqtadan_ortiq_belgilash_mumkun_emas.tr());

                          }

                        },
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            _currentLocation.latitude ?? 0.0,
                            _currentLocation.longitude ?? 0.0,
                          ),
                        ),
                      ),
                      _isVisibleCircular == true ? const Center(child: CircularProgressIndicator()) : const SizedBox(),
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
                                  SizedBox(height: 16,),
                                  GestureDetector(
                                    onTap: () {
                                      _animateMyLocation();
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
                  );
                },
              ),
            ),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controllerTextField.dispose();
    _controller.dispose();
  }

  void _showAddBottomSheet(BuildContext context, String lat, String lng) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(left: 16, top: 24, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                LocaleKeys.add_location_title.tr(),
                style: const TextStyle(fontFamily: 'Mulish',fontSize: 20.0, color: Color.fromRGBO(48, 48, 48, 1), fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 24,
              ),
              TextField(
                controller: _controllerTextField,
                maxLines: 1,
                decoration:  InputDecoration(
                  label: Text(LocaleKeys.add_location_header.tr()),
                  isDense: true,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              FilledButtonAll(onPress: () {
                _bloc.add(AddWorkerLocationEvent(request: AddWorkerLocationRequest(title: _controllerTextField.text.toString(), lat: lat, lng: lng)));
                setState(() {
                  _isVisibleCircular = true;
                });
                Navigator.of(context).pop();
              })
            ],
          ),
        );
      },
    );
  }

  void _showRemoveBottomSheet(BuildContext context, String element, int id) {
    showModalBottomSheet(
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
                LocaleKeys.remove_location_title.tr(),
                style: const TextStyle(fontFamily:'Mulish',fontSize: 18.0, color: Color.fromRGBO(48, 48, 48, 1), fontWeight: FontWeight.w600),
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
                      text: LocaleKeys.remove_location_button_no.tr(),
                      bgColor: Colors.transparent,
                      textColor: const Color.fromRGBO(48, 48, 48, 1)),
                  FilledButtonInProfile(
                    text: LocaleKeys.remove_location_button_yes.tr(),
                    bgColor: const Color.fromRGBO(216, 75, 75, 1),
                    onPress: () {
                      setState(() {
                        //_isVisibleCircular = true;
                      });

                      setState(() {
                        _isVisibleCircular = true;

                        _markers.removeWhere((marker) {
                          if (marker.markerId.value == element) {

                            _bloc.add(RemoveLocationEvent(id: id));
                          }

                          return marker.markerId.value == '${element.hashCode}';
                        });
                      });

                      setState(() {});
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

  void _showSnackBar(String text,) {
    Flushbar(
      animationDuration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.only(left: 16,right: 32,top: 24,bottom: 24),


      message:  text,
      duration:  const Duration(milliseconds: 1500),
    ).show(context);
  }



}
