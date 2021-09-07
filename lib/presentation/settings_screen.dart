import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:location_alarm/shared/providers.dart';
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
  void initState() {
    super.initState();
    // do i wanna shift the pref here?
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    List dropdownItems = ["Alarm & Vibrate", "Alarm Only", "Vibrate Only"];
    String dropdownValue = "";
    alarmType == 0
        ? dropdownValue = 'Alarm & Vibrate'
        : alarmType == 1
            ? dropdownValue = 'Alarm Only'
            : alarmType == 2
                ? dropdownValue = 'Vibrate Only'
                : dropdownValue = "";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Container(
        height: height,
        width: width,
        child: Column(
          children: [
            Flexible(
              child: ListTile(
                title: Text("Settings"),
                trailing: DropdownButton(
                  value: dropdownValue,
                  items: dropdownItems
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ),
                      )
                      .toList(),
                  onChanged: (String? value) {
                    if (value != null)
                      setState(() async {
                        int alarmTypeVal;
                        value == 'Alarm & Vibrate'
                            ? alarmTypeVal = 0
                            : value == 'Alarm Only'
                                ? alarmTypeVal = 1
                                : value == 'Vibrate Only'
                                    ? alarmTypeVal = 2
                                    : alarmTypeVal = 3;
                        dropdownValue = value;
                        final pref = await SharedPreferences.getInstance();
                        // might want to shift this elsewhere to test
                        await pref.setInt('alarmType', alarmTypeVal);
                      });
                  },
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
