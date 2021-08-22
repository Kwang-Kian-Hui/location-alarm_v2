import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_alarm/application/alarm.dart';
import 'package:location_alarm/application/alarm_list_notifier.dart';
import 'package:location_alarm/application/alarm_list_state.dart';

final alarmListNotifierProvider =
    StateNotifierProvider.autoDispose<AlarmListNotifier, AlarmListState>(
        (ref) => AlarmListNotifier());

final currentAlarmItem = Provider.autoDispose<Alarm>((ref) => throw UnimplementedError());