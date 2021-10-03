import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmSettingsScreen extends ConsumerStatefulWidget {
  const AlarmSettingsScreen({Key? key}) : super(key: key);
  static const routeName = 'alarm-settings-screen';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AlarmSettingsScreenState();
}

class _AlarmSettingsScreenState extends ConsumerState<AlarmSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    // int alarmType = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Container(
        height: 730.h,
        width: 410.w,
        child: Column(
          children: [
            Flexible(
              child: Container(
                height: 30.h,
                width: 410.w,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 15.w, top: 15.h),
                      child: Text(
                        "Alarm type:",
                        style: ThemeData().textTheme.bodyText1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.w, top: 8.h),
                      child: Tooltip(
                          message:
                              "Ringtone plays the default ringtone of device",
                          child: Icon(Icons.help_outlined)),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Container(
                height: 70.h,
                width: 410.w,
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Card(
                        elevation: 1,
                        child: Container(
                          height: 50.h,
                          child: TextButton(
                            child: Text(
                              'Ringtone Only',
                              style: ThemeData().textTheme.bodyText2,
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () async {
                              final pref = await SharedPreferences.getInstance();
                              // might want to shift this elsewhere to test
                              await pref.setInt('alarmType', 1);
                            },
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Card(
                        elevation: 1,
                        child: Container(
                          height: 50.h,
                          child: TextButton(
                            child: Text(
                              'Ringtone & Vibrate',
                              style: ThemeData().textTheme.bodyText2,
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () async {
                              final pref = await SharedPreferences.getInstance();
                              // might want to shift this elsewhere to test
                              await pref.setInt('alarmType', 2);
                            },
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Card(
                        elevation: 1,
                        child: Container(
                          height: 50.h,
                          child: TextButton(
                            child: Text(
                              'Vibrate Only',
                              style: ThemeData().textTheme.bodyText2,
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () async {
                              final pref = await SharedPreferences.getInstance();
                              // might want to shift this elsewhere to test
                              await pref.setInt('alarmType', 3);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Flexible(child: ListTile()),
            const Flexible(child: ListTile()),
          ],
        ),
      ),
    );
  }
}
