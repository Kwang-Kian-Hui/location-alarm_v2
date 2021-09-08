import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_alarm/presentation/addedit_alarm_screen.dart';
import 'package:location_alarm/presentation/alarm_list_screen.dart';
import 'package:location_alarm/presentation/settings_screen.dart';
import 'package:location_alarm/shared/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationApp extends StatefulWidget {
  const LocationApp({Key? key}) : super(key: key);

  @override
  _LocationAppState createState() => _LocationAppState();
}

class _LocationAppState extends State<LocationApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final pref = await SharedPreferences.getInstance();
      alarmType = pref.getInt('alarmType');
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Location Alarm',
      theme: ThemeData(
        fontFamily: 'Comfortaa',
        // brightness: Brightness.dark,
        // primaryColor: Colors.black,
        // primaryColorLight: Colors.white,
        // accentColor: Colors.grey,
        textTheme: TextTheme(
          bodyText1:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          bodyText2: TextStyle(color: Colors.black),
        ),
      ),
      home: AlarmListScreen(),
      routes: {
        AlarmListScreen.routeName: (context) => AlarmListScreen(),
        AlarmSettingsScreen.routeName: (context) => AlarmSettingsScreen(),
        AddEditAlarmScreen.routeName: (context) =>
            ProviderScope(child: AddEditAlarmScreen()),
      },
    );
  }
}
