import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_alarm/presentation/alarm_list_screen.dart';

class ProminentDisclosureScreen extends StatelessWidget {
  const ProminentDisclosureScreen({Key? key}) : super(key: key);
  static const routeName = 'prominent-disclosure-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: TextButton(
        child: Text(
          "I Understand",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () =>
            Navigator.pushReplacementNamed(context, AlarmListScreen.routeName),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 100.h, left: 20.w, right: 20.w),
        child: Text(
          "This app collects location data to enable the app to calculate the distance between " +
              "your destination and your device's location even when the app is minimised or the " +
              "screen is off.",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
