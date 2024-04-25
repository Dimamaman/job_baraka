import 'package:flutter/material.dart';

class FilledButtonInLanguage extends StatelessWidget {
  final String st;

  final dynamic Function()? onPress;

  const FilledButtonInLanguage(
      {super.key, required this.onPress, required this.st}
      );
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: FilledButton(

          style: ButtonStyle(
              backgroundColor: st.isNotEmpty ? MaterialStateProperty.all(const Color.fromRGBO(42, 50, 75, 1)): MaterialStateProperty.all(const Color.fromRGBO(199, 204, 219, 1)),
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
          child: const Text("Следующий", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16,color: Colors.white),)),
    );
  }
}
