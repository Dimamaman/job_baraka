
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job_baraka/generated/locale_keys.g.dart';

class FilledButtonInProfile extends StatelessWidget {

  final String text;
  final Color bgColor;
  final dynamic Function()? onPress;
  final Color textColor;
  const FilledButtonInProfile(
      {super.key, required this.onPress, required this.text, required this.bgColor, required this.textColor}
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(


      width: MediaQuery.of(context).size.width / 2 - 16,
      child: FilledButton(


          style: ButtonStyle(
              backgroundColor:  MaterialStateProperty.all(bgColor),
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
          child: Text(text, style: TextStyle(fontSize: 16.0, color: textColor, fontWeight: FontWeight.w600,fontFamily: 'Mulish'),)),
    );
  }
}
