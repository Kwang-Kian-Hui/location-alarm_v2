import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_alarm/application/addedit_alarm_form_notifier.dart';
import 'package:location_alarm/application/addedit_alarm_form_state.dart';
import 'package:location_alarm/infrastructure/alarm_local_service.dart';
import 'package:location_alarm/infrastructure/alarm_repository.dart';

final alarmLocalServiceProvider = Provider((ref) => AlarmLocalService());

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
