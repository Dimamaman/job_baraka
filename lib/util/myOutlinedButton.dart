import 'package:flutter/material.dart';

class MyOutlinedButton extends StatelessWidget {
  final String text;
  final Function onPress;
  const MyOutlinedButton({super.key, required this.text, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all(BorderSide(color: Theme.of(context).colorScheme.secondary)),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.all(16)),
              shape:
              MaterialStateProperty.all(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ))),
          onPressed: () {
            onPress();
          },

          child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),)),
    );
  }
}
