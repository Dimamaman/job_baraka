import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_baraka/data/local/shared_preferences.dart';
import 'package:job_baraka/generated/locale_keys.g.dart';
import 'package:job_baraka/presentation/ui/language/widgets/filled_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/login_page.dart';
import '../onboarding/on_boarding_page.dart';

class SelectLangauge extends StatefulWidget {
  const SelectLangauge({super.key});

  @override
  State<SelectLangauge> createState() => _SelectLangaugeState();
}

class _SelectLangaugeState extends State<SelectLangauge> {


  List<String> items = ["O`zbekcha,Ўзбекча,Qaraqalpaqsha", "Русский", "English"];
  String? selectedLanguage; // Изначально не выбран язык


  @override
  void initState() {


    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: SafeArea(
        
        child: AnnotatedRegion(
          value: const SystemUiOverlayStyle(
            statusBarColor: Color(0xfff5f5f5),
            statusBarIconBrightness: Brightness.dark,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Выбор языка', style: TextStyle(color: Color.fromRGBO(48, 48, 48, 1), fontSize: 20, fontWeight: FontWeight.w700)),
              Container(
                margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                child:  Container(
          
                  width: MediaQuery.of(context).size.width, // Расширяем на всю доступную ширину
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // Добавляем границу
                    borderRadius: BorderRadius.circular(8.0), // Закругляем углы
                  ),
                  child: DropdownButton<String>(
          
                    value: selectedLanguage,
                    hint: Text("Не выбран"),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    underline: Container(color: Colors.white,),
                    onChanged: (String? value) {
                      setState(() {
                        selectedLanguage = value;
                      });
                    },
          
                    isExpanded: true,
                    icon: Icon(Icons.menu),
          
                    items: [
                      'O`zbekcha',
                      'Ўзбекча',
                      'Qaraqalpaqsha',
                      'Русский',
                      'English',
          
          
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
          
                        value: value,
                        child: SizedBox(
                          width: 200,
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: FilledButtonInLanguage(
                  onPress: selectedLanguage == null ? null :() {
          
          
          
                    switch(selectedLanguage) {
                      case "Qaraqalpaqsha" : {
                        context.setLocale(Locale('es'));
          
          
          
                      }
          
                      case "O`zbekcha" : {
                        context.setLocale(Locale('uz','Latn'));
          
          
          
                      }
                      case "Ўзбекча" : {
                        context.setLocale(Locale('uz','Cyrl'));
                      ;
          
          
                      }
          
          
                      case "Русский" : {
          
          
                        context.setLocale(Locale('ru'));
          
          
                      }
                      case "English" : {
                        context.setLocale(Locale('en'));
          
                      }
          
          
                    }
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => OnBoardingPage(),));
                  },
                  st: selectedLanguage== null ? "":selectedLanguage.toString(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
