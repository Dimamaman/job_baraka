import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job_baraka/data/local/model/id_name_data_in.dart';
import 'package:job_baraka/generated/locale_keys.g.dart';
import 'package:job_baraka/presentation/ui/aboutme/about_me_edit_page.dart';

import 'services_page.dart';
import 'widgets/filled_button.dart';


class SelectServicePage extends StatefulWidget {
  const SelectServicePage({super.key});

  @override
  State<SelectServicePage> createState() => _SelectServicePageState();
}

class _SelectServicePageState extends State<SelectServicePage> {
  String _serviceName = LocaleKeys.worker_info_speciality_text.tr();
  int _serviceId = 0;
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LocaleKeys.service_page_title.tr(),
              style: const TextStyle(fontFamily: 'Mulish',fontWeight: FontWeight.w600, fontSize: 20, color: Color.fromRGBO(48, 48, 48, 1)),
            ),
            const SizedBox(
              height: 32,
            ),
            ListTile(
              onTap: () async {
                final res = await Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const ServicesPage();
                  },
                ));

                setState(() {
                  _serviceId = (res as Dates).id;
                  _serviceName = (res).serviceName;
                  _isSelected = true;
                });
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(
                  color: Color.fromRGBO(42, 50, 75, 1),
                  width: 1.0,
                ),
              ),
              title: Text(
                _serviceName,
                style: const TextStyle(fontFamily: 'Mulish',
                  fontSize: 16.0,
                  color: Color.fromRGBO(144, 146, 152, 1),
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: SvgPicture.asset('assets/icons/ic_next.svg'),
            ),
            const SizedBox(
              height: 16,
            ),
            FilledButtonInServicesPage(
              onPress: _isSelected == true
                  ? () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return AboutMeEditPage(
                            serviceId: _serviceId,
                          );
                        },
                      ));
                    }
                  : () {},
              isSelected: _isSelected,
            )
          ],
        ),
      ),
    );
  }
}
