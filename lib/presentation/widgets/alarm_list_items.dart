import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_alarm/presentation/addedit_alarm_screen.dart';
import 'package:location_alarm/shared/providers.dart';

enum MenuOptions {
  Edit,
  Delete,
}

class AlarmListItem extends ConsumerStatefulWidget {
  const AlarmListItem({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AlarmListItemState();
}

class _AlarmListItemState extends ConsumerState<AlarmListItem> {
  @override
  Widget build(BuildContext context) {
    var alarmData = ref.watch(currentAlarmItem);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.1,
      width: width,
      child: ListTile(
        leading: Text(alarmData.alarmName),
        title:
            Text('Alarm radius: ${alarmData.alarmRadius.toStringAsFixed(2)} m'),
        subtitle: ValueListenableBuilder<Position>(
            valueListenable:
                ref.read(alarmListNotifierProvider.notifier).currentPosition,
            builder: (ctx, value, child) {
              double distance = Geolocator.distanceBetween(
                value.latitude,
                value.longitude,
                alarmData.destLat,
                alarmData.destLng,
              );
              return Text(
                _getDistanceString(distance),
              );
            }),
        trailing: Container(
          width: width * 0.3,
          child: ListTile(
            leading: Container(
              width: width * 0.15,
              child: Switch(
                value: ref.watch(currentAlarmItem).alarmStatus,
                onChanged: (newAlarmStatus) {
                  ref.read(alarmListNotifierProvider.notifier).updateAlarm(
                      alarmData.copyWith(alarmStatus: !alarmData.alarmStatus));
                  setState(() {
                    ref.read(currentAlarmItem).alarmStatus = newAlarmStatus;
                  });
                },
              ),
            ),
            trailing: Container(
              width: width * 0.1,
              child: PopupMenuButton(
                onSelected: (MenuOptions selectedValue) async {
                  if (selectedValue == MenuOptions.Edit) {
                    Navigator.of(context).pushNamed(
                        AddEditAlarmScreen.routeName,
                        arguments: alarmData);
                  } else {
                    await ref
                        .read(alarmListNotifierProvider.notifier)
                        .deleteAlarm(alarmData.alarmId!);
                    await ref.read(alarmListNotifierProvider.notifier).getAlarmsList();
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(child: Text("Edit"), value: MenuOptions.Edit),
                  PopupMenuItem(
                      child: Text("Delete"), value: MenuOptions.Delete),
                ],
              ),
            ), //TODO: do menu for edit and delete
          ),
        ),
      ),
    );
  }
}

String _getDistanceString(double dist) {
  if (dist >= 1000) {
    return "Distance: " + (dist / 1000).toStringAsFixed(2) + "km";
  }
  return "Distance: " + dist.toStringAsFixed(2) + "m";
}
