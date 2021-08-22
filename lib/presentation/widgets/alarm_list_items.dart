import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_alarm/shared/providers.dart';

class AlarmListItem extends ConsumerWidget {
  const AlarmListItem({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmData = ref.watch(currentAlarmItem);
    return Container(
      
    );
  }
}