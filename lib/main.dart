import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:pcw_admin/src/models/setting.dart';
import 'package:pcw_admin/src/route_generator.dart';
import 'package:pcw_admin/src/theme.dart';

import 'src/repository/settings_repository.dart' as settingRepo;
import 'src/repository/user_repository.dart' as userRepo;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset('configurations');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    settingRepo.initSettings();
    userRepo.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: settingRepo.setting,
        builder: (context, Setting _setting, _) {
          return MaterialApp(
            title: 'Flutter Demo',
            initialRoute: '/Splash',
            onGenerateRoute: RouteGenerator.generateRoute,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Scanno',
              primaryColor: const Color(0xFF2e3092),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  elevation: 0, foregroundColor: Colors.white),
              bottomSheetTheme: BottomSheetThemeData(
                  backgroundColor: Colors.black.withOpacity(0.8)),
              dialogTheme: DialogTheme(
                backgroundColor: Colors.black.withOpacity(0.8),
              ),
              primarySwatch: Colors.blue,
              // brightness: brightness,
              scaffoldBackgroundColor: Colors.transparent.withOpacity(1),
              accentColor: const Color(0xFF83bae5),
              dividerColor: const Color(0xFF409cd0),
              focusColor: const Color(0xFF3e87b7),
              hintColor: Colors.white, //Color(0xFF409cd0),
              textTheme: const TextTheme(
                bodyText1: TextStyle(fontSize: 14.0, color: Color(0xFF2e3092)),
                bodyText2: TextStyle(fontSize: 14.0, color: Color(0xFF409cd0)),
                button: TextStyle(fontSize: 14.0, color: Color(0xFF409cd0)),
                subtitle1: TextStyle(fontSize: 16.0, color: Color(0xFF409cd0)),
                subtitle2: TextStyle(fontSize: 16.0, color: Color(0xFF409cd0)),
                overline: TextStyle(fontSize: 16.0, color: Color(0xFF409cd0)),
                caption: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF83bae5)),
              ),
            ),
          );
        });
  }
}
