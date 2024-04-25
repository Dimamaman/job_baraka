import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:job_baraka/data/local/shared_preferences.dart';
import 'package:job_baraka/generated/locale_keys.g.dart';
import 'package:job_baraka/presentation/ui/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'on_boarding_content.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  List<OnboardingContent> contents = [];
  int currentIndex = 0;
  late PageController _controller;
  late SharedPreferences pref;


  @override
  void initState() {
    pref = SharedPref.instance;
    contents.add(OnboardingContent(
        image: "assets/images/slide_1.svg", title: LocaleKeys.slide_1_title.tr(), description: LocaleKeys.slide_1_description.tr()));
    contents.add(OnboardingContent(
        image: "assets/images/slide_2.svg", title: LocaleKeys.slide_2_title.tr(), description: LocaleKeys.slide_2_description.tr()));
    _controller = PageController(initialPage: 0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: contents.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 160, left: 20, right: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 150,
                          child: SvgPicture.asset(
                            contents[i].image,
                          ),
                        ),
                        const SizedBox(
                          height: 36,
                        ),
                        Text(
                          contents[i].title,
                          style: const TextStyle(
                            color: Color.fromRGBO(48, 48, 48, 1),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        Text(
                          contents[i].description,
                          style: const TextStyle(
                            color: Color.fromRGBO(48, 48, 48, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                    (index) => buildDot(index, context),
              ),
            ),

            const SizedBox(
              height: 40,
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    child: GestureDetector(
                      onTap: () {
                        print("${currentIndex} -----------index");
                        if (currentIndex == 0) {
                          print("${currentIndex} -----------kirdi");

                          pref.setBool("INTRO", true);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                                  (route) => false);


                        }
                        _controller.previousPage(
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeOut,
                        );
                      },
                      child: Text(
                        currentIndex == contents.length - 1 ? LocaleKeys.slide_2_button_back_1.tr() : LocaleKeys.slide_1_button_back_1.tr(),
                        style: const TextStyle(color: Color.fromRGBO(42, 50, 75, 1), fontSize: 16),
                      ),
                    ),
                  ),
                  FilledButton(
                      onPressed: () {
                        if (currentIndex == contents.length - 1) {
                          pref.setBool("INTRO", true);

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                                  (route) => false);
                        }
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeIn,
                        );
                      },
                      style: ButtonStyle(
                          backgroundColor: const MaterialStatePropertyAll<Color>(Color.fromRGBO(42, 50, 75, 1)),
                          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
                          shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ))),
                      child: Text(
                        currentIndex == contents.length - 1 ? LocaleKeys.slide_2_button_next_1.tr() : LocaleKeys.slide_1_button_next_1.tr(),
                        style: const TextStyle(fontSize: 16),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );


  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromRGBO(118, 123, 145, 1),
      ),
    );
  }
}
