import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_alarm/presentation/addedit_alarm_screen.dart';
import 'package:location_alarm/presentation/alarm_list_screen.dart';
import 'package:location_alarm/presentation/settings_screen.dart';
import 'package:location_alarm/presentation/themes/color_themes.dart';
import 'package:location_alarm/presentation/themes/text_themes.dart';

class LocationApp extends StatefulWidget {
  const LocationApp({Key? key}) : super(key: key);

  @override
  _LocationAppState createState() => _LocationAppState();
}

class _LocationAppState extends State<LocationApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      designSize: const Size(411, 731),
      builder: () => MaterialApp(
        title: 'Location Alarm',
        theme: ThemeData(
          fontFamily: 'Comfortaa',
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: appBarTheme,
          brightness: Brightness.light,
          primarySwatch: MaterialColor(0xFFF86B6B, appColorSwatch),
          canvasColor: Colors.white,
          textTheme: appTextTheme,
        ),
        home: AlarmListScreen(),
        routes: {
          AlarmListScreen.routeName: (context) => AlarmListScreen(),
          AlarmSettingsScreen.routeName: (context) => AlarmSettingsScreen(),
          AddEditAlarmScreen.routeName: (context) =>
              ProviderScope(child: AddEditAlarmScreen()),
        },
      ),
    );
  }
}

