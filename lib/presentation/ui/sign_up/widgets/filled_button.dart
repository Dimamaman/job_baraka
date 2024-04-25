
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job_baraka/generated/locale_keys.g.dart';

class FilledButtonInSignUp extends StatelessWidget {
  final bool isSelected;

  final dynamic Function()? onPress;

  const FilledButtonInSignUp(
      {super.key, required this.onPress, required this.isSelected}
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(


      width: MediaQuery.of(context).size.width,
      child: FilledButton(


          style: ButtonStyle(
              backgroundColor: onPress != null ? MaterialStateProperty.all(const Color.fromRGBO(42, 50, 75, 1)): MaterialStateProperty.all(const Color.fromRGBO(199, 204, 219, 1)),
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
          child: Text(LocaleKeys.login_text_button.tr(), style: const TextStyle(fontFamily: 'Mulish',fontWeight: FontWeight.w600, fontSize: 16,color: Colors.white),)),
    );
  }
}
