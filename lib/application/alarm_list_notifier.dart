import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_alarm/application/alarm_list_state.dart';
import 'package:location_alarm/infrastructure/alarm_repository.dart';

class AlarmListNotifier extends StateNotifier<AlarmListState>{
  final AlarmRepository _alarmRepository;
  AlarmListNotifier(this._alarmRepository) : super(const AlarmListState.initial());

  Future<void> getAlarmsList() async{
    state = const AlarmListState.loading();

    //TODO: internet checker
    //TODO: location permission checker

    final getListResult =  await _alarmRepository.getAlarmList();

    getListResult.fold(
      (failure) => state = AlarmListState.failure(failure),
      (alarmList) => state = AlarmListState.loaded(alarmList),
    );
  }
}