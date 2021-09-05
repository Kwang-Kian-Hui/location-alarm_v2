import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class AlarmSettingsScreen extends ConsumerWidget {
  const AlarmSettingsScreen({Key? key}) : super(key: key);
  static const routeName = 'alarm-settings-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var dropdownItems = ["Alarm & Vibrate", "Alarm Only", "Vibrate Only"];
    String dropdownValue = "";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Container(
        height: height,
        width: width,
        child: Column(
          children: [
            // Flexible(
            //   child: ListTile(
            //     title: Text("Settings"),
            //     trailing: DropdownButton(
            //       value: dropdownValue,
            //       items: dropdownItems
            //           .map(
            //             (String item) => DropdownMenuItem<String>(
            //               child: Text(item),
            //             ),
            //           )
            //           .toList(),
            //       onChanged: (String? value) {
            //         if (value != null) dropdownValue = value;
            //       },
            //     ),
            //   ),
            // ),
            const Flexible(child: ListTile()),
            const Flexible(child: ListTile()),
          ],
        ),
      ),
    );
  }
}
