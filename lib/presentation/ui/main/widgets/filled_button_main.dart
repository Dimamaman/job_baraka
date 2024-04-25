
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job_baraka/generated/locale_keys.g.dart';

class FilledButtonMain extends StatelessWidget {

  final dynamic Function()? onPress;

  const FilledButtonMain(
      {super.key, required this.onPress}
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(


      width: MediaQuery.of(context).size.width,
      child: FilledButton(


          style: ButtonStyle(
              backgroundColor:  MaterialStateProperty.all(const Color.fromRGBO(42, 50, 75, 1)),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.all(16)),
              shape:
              MaterialStateProperty.all(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ))),
          onPressed: onPress != null ? () {
            onPress!();
          } : null,
          child: Text(LocaleKeys.worker_info_button.tr(), style: const TextStyle(fontFamily:'Mulish',fontWeight: FontWeight.w600, fontSize: 16,color: Colors.white),)),
    );
  }
}
