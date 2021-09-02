import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_alarm/shared/providers.dart';

class AlarmListItem extends ConsumerWidget {
  const AlarmListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmData = ref.watch(currentAlarmItem);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
        height: height * 0.1,
        width: width,
        child: ListTile(
      leading: Text(alarmData.alarmName),
      title: Text('${alarmData.alarmRadius.toStringAsFixed(2)} m'),
      subtitle: Text('${alarmData.destLat} + ${alarmData.destLng}'),
      trailing: Container(
        width: width * 0.3,
        child: ListTile(
            leading: Container(
              width: width * 0.15,
              child: Switch(
                value: alarmData.alarmStatus,
                onChanged: (newAlarmStatus) {}, //TODO: do change alarmStatus
              ),
            ),
            trailing: Container(
              width: width * 0.1,
              child: Icon(Icons.more_vert),
            ), //TODO: do menu for edit and delete
          ),
      ),
      ),
    );
  }
}
