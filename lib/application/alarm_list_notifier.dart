import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_alarm/application/alarm_list_state.dart';
import 'package:location_alarm/infrastructure/alarm_repository.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmListNotifier extends StateNotifier<AlarmListState> {
  final AlarmRepository _alarmRepository;
  AlarmListNotifier(this._alarmRepository)
      : super(const AlarmListState.initial());

  Future<void> getAlarmsList() async {
    state = const AlarmListState.loading();

    //TODO: internet checker
    //TODO: location permission checker

    if (await Permission.locationAlways.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      print('get list now');
      final getListResult = await _alarmRepository.getAlarmList();

      getListResult.fold(
        (failure) => state = AlarmListState.failure(failure),
        (alarmList) => state = AlarmListState.loaded(alarmList),
      );
    } else {
      state = AlarmListState.noLocationService();
    }
  }
}
