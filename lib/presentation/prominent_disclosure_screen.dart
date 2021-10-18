import 'package:flutter/material.dart';
import 'package:location_alarm/presentation/alarm_list_screen.dart';

class ProminentDisclosureScreen extends StatelessWidget {
  const ProminentDisclosureScreen({Key? key}) : super(key: key);
  static const routeName = 'prominent-disclosure-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GestureDetector(
        onTap: () =>
            Navigator.pushReplacementNamed(context, AlarmListScreen.routeName),
        child: Text("I understand"),
      ),
      body: Text(
        "This app collects location data to enable the app to calculate the distance between" +
            "your destination and your device's location even when the app is minimised or the" +
            "screen is off.",
      ),
    );
  }
}
