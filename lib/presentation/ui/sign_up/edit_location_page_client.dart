import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job_baraka/data/remote/model/request/edit_district_request.dart';
import 'package:job_baraka/data/remote/model/response/district_response.dart';
import 'package:job_baraka/data/remote/model/response/region_response.dart';
import 'package:job_baraka/generated/locale_keys.g.dart';
import 'package:job_baraka/presentation/ui/sign_up/bloc/sign_up_bloc.dart';
import 'package:job_baraka/presentation/ui/sign_up/edit_name_page.dart';
import 'package:job_baraka/presentation/ui/sign_up/widgets/filled_button.dart';
import 'package:job_baraka/util/edit_rayon.dart';
import 'package:job_baraka/util/edit_region.dart';

class EditLocationPageClient extends StatefulWidget {
  const EditLocationPageClient({super.key});

  @override
  State<EditLocationPageClient> createState() => _EditLocationPageClientState();
}

class _EditLocationPageClientState extends State<EditLocationPageClient> {
  String region = 'Region';
  String district = 'District';
  String regionId = '';
  int districtId = 0;
  int count = 0;
  final bloc = SignUpBloc();
  final bool _circular = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _circular
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.region_text_in_profile.tr(),
                      style: const TextStyle(fontFamily: 'Mulish',fontWeight: FontWeight.w600, fontSize: 20, color: Color.fromRGBO(48, 48, 48, 1)),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const EditRegion();
                          },
                        ));
                        setState(() {
                          region = (result as RegionData).name.en;
                          regionId = (result).id.toString();
                          count++;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromRGBO(42, 50, 75, 1), // Border color
                            width: 1.0, // Border width
                          ),
                          borderRadius: BorderRadius.circular(10.0), // Border radius
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              region,
                              style: TextStyle(fontSize: 16.0,
                                  color: count > 0 ? const Color.fromRGBO(42, 50, 75, 1) : Color.fromRGBO(144, 146, 152, 1),
                                  fontWeight: FontWeight.w500,fontFamily: "Mulish"),
                            ),
                            SvgPicture.asset('assets/icons/ic_next.svg')
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return EditDistrict(regionId: regionId);
                          },
                        ));
                        setState(() {
                          district = (result as DistrictData).name.en;
                          districtId = (result).id;
                          count++;
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
                              district,
                              style: TextStyle(fontFamily: 'Mulish',
                                  fontSize: 16.0,
                                  color: count > 1 ? const Color.fromRGBO(42, 50, 75, 1) : const Color.fromRGBO(144, 146, 152, 1),
                                  fontWeight: FontWeight.w500),
                            ),
                            SvgPicture.asset('assets/icons/ic_next.svg')
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    FilledButtonInSignUp(
                      onPress: count >=2 ?  () {
                        print("COUNT$count");
                        bloc.add(SendDistrictEvent(request: EditDistrictRequest(districtId: districtId)));
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const EditNamePage();
                          },
                        ));
                      } : null,
                      isSelected: count >= 2 ? true : false,
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
