import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  CustomSwitch({required this.value, required this.onChanged});

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Container(
        width: 50.0, // Ширина бегунка
        height: 30.0, // Высота бегунка
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: widget.value ? Colors.green : Colors.grey, // Цвет бегунка в зависимости от состояния
        ),
        alignment: widget.value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 25.0, // Ширина трека
          height: 25.0, // Высота трека
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}