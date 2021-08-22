import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_alarm/shared/providers.dart';

class AlarmListItem extends ConsumerWidget {
  const AlarmListItem({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmData = ref.watch(currentAlarmItem);
    return ListTile(
      leading: Text(alarmData.alarmName),
      title: Text('${alarmData.alarmRadius.toStringAsFixed(2)} m'),
      subtitle: Text('${alarmData.destLat} + ${alarmData.destLng}'),
      trailing: ListTile(
        leading: Switch(
          value: alarmData.alarmStatus,
          onChanged: (newAlarmStatus){}, //TODO: do change alarmStatus
        ),
        trailing: Container(), //TODO: do menu for edit and delete
      ),
    );
  }
}