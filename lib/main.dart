import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:job_baraka/data/remote/model/response/get_all_services_response.dart';
import 'package:job_baraka/presentation/ui/language/select_language.dart';
import 'package:job_baraka/presentation/ui/login/login_page.dart';
import 'package:job_baraka/presentation/ui/main/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'data/local/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SharedPref.init();

  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(GetAllServicesResponseAdapter());
  Hive.registerAdapter(ServiceDataAdapter());
  Hive.registerAdapter(NameAdapter());
  Hive.registerAdapter(ServiceAdapter());

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) => runApp(
        EasyLocalization(
            supportedLocales: const [Locale('en'), Locale('ru'), Locale('es'), Locale('uz', 'Latn'), Locale('uz', 'Cyrl')],
            path: 'assets/translations',
            fallbackLocale: Locale('en'),
            saveLocale: true,
            child: const MyApp()),
      ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SharedPreferences pref;

  @override
  void initState() {
    pref = SharedPref.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Job Baraka',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: pref.getBool("INTRO") == true ? (pref.getBool('LOGIN') == true ? MainPage() : LoginPage()) : SelectLangauge(),
    );
  }
}
