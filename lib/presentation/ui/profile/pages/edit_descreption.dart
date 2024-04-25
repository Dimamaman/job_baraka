import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:job_baraka/generated/locale_keys.g.dart';

class EditDescription extends StatefulWidget {
  final String currentDescription;

  const EditDescription({super.key, required this.currentDescription});

  @override
  State<EditDescription> createState() => _EditDescriptionState();
}

class _EditDescriptionState extends State<EditDescription> {
  final TextEditingController _controller = TextEditingController();


  @override
  void initState() {
    super.initState();

    _controller.text = widget.currentDescription;
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
        title: Text(LocaleKeys.about_us_text_title.tr(),
            style:  const TextStyle(fontFamily:'Mulish',fontSize: 20, fontWeight: FontWeight.w600, color: Color.fromRGBO(42, 50, 75, 1))),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context,_controller.text);
                },
                icon: const Icon(Icons.check)),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
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
          style:
               const TextStyle(fontFamily: 'Mulish',fontSize: 16, fontWeight: FontWeight.w600, color: Color.fromRGBO(48, 48, 48, 1)),
        ),
      ),
    );
  }
}
