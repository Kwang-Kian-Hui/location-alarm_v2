import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_alarm/application/alarm_list_state.dart';
import 'package:location_alarm/database/database.dart';

class AlarmListNotifier extends StateNotifier<AlarmListState>{
  AlarmListNotifier() : super(const AlarmListState.initial());

  Future<void> getAlarmsList() async{
    state = const AlarmListState.loading();

    //TODO: internet checker
    //TODO: location permission checker

    final listResult =  await AlarmsDatabase.instance.getAlarmsList();

    state = AlarmListState.loaded(listResult);
  }
}