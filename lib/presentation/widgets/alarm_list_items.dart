import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_alarm/shared/providers.dart';

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
        title: Text('${alarmData.alarmRadius.toStringAsFixed(2)} m'),
        subtitle: ValueListenableBuilder<Position>(
                valueListenable: ref.read(alarmListNotifierProvider.notifier).currentPosition,
                builder: (ctx, value, child) => Text(
                  _getDistanceString(
                    Geolocator.distanceBetween(
                      value.latitude,
                      value.longitude,
                      alarmData.destLat,
                      alarmData.destLng,
                    ),
                  ),
                ),
              ),
          // builder: (context, snapshot) {
          //   return snapshot.data != null
          //   ? Text('Distance: ${Geolocator.distanceBetween(
          //           snapshot.data!.latitude,
          //           snapshot.data!.longitude,
          //           alarmData.destLat,
          //           alarmData.destLng)
          //       .toStringAsFixed(2)}m')
          //   : Text("");
          // },),
        // currentPosition != null
        //     ? Text('Distance: ${Geolocator.distanceBetween(
        //             currentPosition.latitude,
        //             currentPosition.longitude,
        //             alarmData.destLat,
        //             alarmData.destLng)
        //         .toStringAsFixed(2)}m')
        //     : null,
        // subtitle: Text('${alarmData.destLat} + ${alarmData.destLng}'),
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
              child: Icon(Icons.more_vert),
            ), //TODO: do menu for edit and delete
          ),
        ),
      ),
    );
  }
}

String _getDistanceString(double dist) {
    if (dist >= 1000) {
      return (dist / 1000).toStringAsFixed(2) + "km";
    }
    return dist.toStringAsFixed(2) + "m";
  }