import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_alarm/application/alarm.dart';
import 'package:location_alarm/application/alarm_list_notifier.dart';
import 'package:location_alarm/application/alarm_list_state.dart';
import 'package:location_alarm/application/addedit_alarm_form_notifier.dart';
import 'package:location_alarm/application/addedit_alarm_form_state.dart';
import 'package:location_alarm/database/database.dart';
import 'package:location_alarm/infrastructure/alarm_local_service.dart';
import 'package:location_alarm/infrastructure/alarm_repository.dart';

final alarmDatabaseProvider = Provider((ref) => AlarmsDatabase.instance);

final alarmLocalServiceProvider = Provider(
  (ref) => AlarmLocalService(ref.watch(alarmDatabaseProvider)),
);

final alarmRepositoryProvider = Provider(
  (ref) => AlarmRepository(
    ref.watch(alarmLocalServiceProvider),
  ),
);

final addEditAlarmFormNotifierProvider = StateNotifierProvider.autoDispose<
    AddEditAlarmFormNotifier, AddEditAlarmFormState>(
  (ref) => AddEditAlarmFormNotifier(
    ref.watch(alarmRepositoryProvider),
  ),
);

final alarmListNotifierProvider =
    StateNotifierProvider.autoDispose<AlarmListNotifier, AlarmListState>(
        (ref) => AlarmListNotifier(ref.watch(alarmRepositoryProvider)));

final currentAlarmItem = Provider.autoDispose<Alarm>((ref) => throw UnimplementedError());

int? alarmType;