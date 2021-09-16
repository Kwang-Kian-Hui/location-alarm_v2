import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_alarm/presentation/addedit_alarm_screen.dart';
import 'package:location_alarm/shared/providers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: 100.h,
      width: 410.w,
      child: ListTile(
        contentPadding: null,
        leading: Text(
          alarmData.alarmName,
          style: textTheme.bodyText1,
        ),
        title: Text(
          'Radius: ${alarmData.alarmRadius.toStringAsFixed(2)} m',
          style: textTheme.bodyText2,
          overflow: TextOverflow.clip,
        ),
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
              return Container(
                height: 45.h,
                width: 165.w,
                alignment: Alignment.topLeft,
                child: Text(_getDistanceString(distance),
                    style: textTheme.bodyText2, overflow: TextOverflow.clip),
              );
            }),
        trailing: Container(
          height: 90.h,
          width: 85.w,
          alignment: Alignment.center,
          child: Row(
            children: [
              Container(
                width: 60.w,
                padding: EdgeInsets.only(bottom: 10.h),
                child: Switch(
                  value: ref.watch(currentAlarmItem).alarmStatus,
                  onChanged: (newAlarmStatus) {
                    ref.read(alarmListNotifierProvider.notifier).updateAlarm(
                        alarmData.copyWith(
                            alarmStatus: !alarmData.alarmStatus));
                    setState(() {
                      ref.read(currentAlarmItem).alarmStatus = newAlarmStatus;
                    });
                  },
                ),
              ),
              Container(
                width: 25.w,
                padding: EdgeInsets.only(bottom: 10.h),
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
                      await ref
                          .read(alarmListNotifierProvider.notifier)
                          .getAlarmsList();
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(child: Text("Edit"), value: MenuOptions.Edit),
                    PopupMenuItem(
                        child: Text("Delete"), value: MenuOptions.Delete),
                  ],
                ),
              ),
            ],
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
