import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    int alarmType = ModalRoute.of(context)!.settings.arguments as int;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
              child: Container(
                width: width,
                height: height * 0.1,
                  child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: TextButton(
                      child: Text(
                        'Alarm Only',
                      ),
                      onPressed: () async {
                        final pref = await SharedPreferences.getInstance();
                        // might want to shift this elsewhere to test
                        await pref.setInt('alarmType', 1);
                      },
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: TextButton(
                      child: Text(
                        'Alarm & Vibrate',
                      ),
                      onPressed: () async {
                        final pref = await SharedPreferences.getInstance();
                        // might want to shift this elsewhere to test
                        await pref.setInt('alarmType', 2);
                      },
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: TextButton(
                      child: Text(
                        'Vibrate Only',
                      ),
                      onPressed: () async {
                        final pref = await SharedPreferences.getInstance();
                        // might want to shift this elsewhere to test
                        await pref.setInt('alarmType', 3);
                      },
                    ),
                  ),
                ],
              )
                  // title: Text("Settings"),
                  // trailing: DropdownButton(
                  //   value: dropdownValue,
                  //   icon: const Icon(Icons.arrow_drop_down),
                  //   items: dropdownItems
                  //       .map(
                  //         (item) => DropdownMenuItem<String>(
                  //           value: item,
                  //           child: Text(item),
                  //         ),
                  //       )
                  //       .toList(),
                  //   onChanged: (String? value) {
                  //     if (value != null)
                  //       setState(() async {
                  //         int alarmTypeVal;
                  //         value == 'Alarm & Vibrate'
                  //             ? alarmTypeVal = 0
                  //             : value == 'Alarm Only'
                  //                 ? alarmTypeVal = 1
                  //                 : value == 'Vibrate Only'
                  //                     ? alarmTypeVal = 2
                  //                     : alarmTypeVal = 3;
                  //         dropdownValue = value;
                  //         final pref = await SharedPreferences.getInstance();
                  //         // might want to shift this elsewhere to test
                  //         await pref.setInt('alarmType', alarmTypeVal);
                  //       });
                  //   },
                  // ),
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
