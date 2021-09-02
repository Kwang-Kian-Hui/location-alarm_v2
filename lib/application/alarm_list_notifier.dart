import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:location_alarm/application/alarm.dart';
import 'package:location_alarm/application/alarm_list_state.dart';
import 'package:location_alarm/infrastructure/alarm_repository.dart';
import 'package:location_alarm/infrastructure/custom_failures.dart';
import 'package:location_alarm/shared/providers.dart';

class AlarmListNotifier extends StateNotifier<AlarmListState> {
  final AlarmRepository _alarmRepository;
  AlarmListNotifier(this._alarmRepository)
      : super(const AlarmListState.initial());

  StreamSubscription<Either<CustomFailures, List<Alarm>>>?
      _alarmListStreamSubscription;

  Future<void> getAlarmsList() async {
    state = const AlarmListState.loading();

    //TODO: internet checker
    //TODO: location permission checker

    final getListResult = await _alarmRepository.getAlarmList();

    getListResult.fold(
      (failure) => state = AlarmListState.failure(failure),
      (alarmList) => state = AlarmListState.loaded(alarmList),
    );
  }

  Future<void> updateAlarm(Alarm alarm) async {
    final updateResult = await _alarmRepository.updateAlarm(alarm);

    updateResult.fold(
      (f) => state = AlarmListState.failure(f),
      (r) => () {
        // print('override value');
        // currentAlarmItem.overrideWithValue(alarm);
      },
    );
  }
}
