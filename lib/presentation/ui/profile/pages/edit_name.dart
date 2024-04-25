import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:job_baraka/generated/locale_keys.g.dart';

class EditName extends StatefulWidget {
  String currentName;

  EditName({super.key, required this.currentName});

  @override
  State<EditName> createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller.text = widget.currentName;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(LocaleKeys.text_hint_edit_name_page.tr(),
            style: const TextStyle(fontFamily: 'Mulish', fontSize: 20, fontWeight: FontWeight.w600, color: Color.fromRGBO(42, 50, 75, 1))),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context, _controller.text);
                },
                icon: Icon(Icons.check)),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelStyle: TextStyle(color: Colors.blue),
            // Цвет текста
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color.fromRGBO(42, 50, 75, 1)),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            labelText: '',
            contentPadding: EdgeInsets.symmetric(vertical: -10),
          ),
          style:const TextStyle(fontFamily: 'Mulish',fontSize: 16, fontWeight: FontWeight.w600, color: Color.fromRGBO(48, 48, 48, 1)),
        ),
      ),
    );
  }
}
