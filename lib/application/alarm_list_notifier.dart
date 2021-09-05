import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import 'package:location_alarm/application/alarm.dart';
import 'package:location_alarm/application/alarm_list_state.dart';
import 'package:location_alarm/infrastructure/alarm_repository.dart';

class AlarmListNotifier extends StateNotifier<AlarmListState> {
  final AlarmRepository _alarmRepository;
  AlarmListNotifier(this._alarmRepository)
      : super(const AlarmListState.initial());

  StreamController<Position> positionStreamController =
      StreamController<Position>();
  StreamSubscription<Position>? _positionStreamSubscription;
  ValueNotifier<Position> currentPosition = ValueNotifier<Position>(Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 0.0,
      altitude: 0.0,
      heading: .00,
      speed: 0.0,
      speedAccuracy: 0.0));
  bool alarmPlaying = false;

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

  void initialisePositionStream() {
    positionStreamController.addStream(Geolocator.getPositionStream(
      intervalDuration: Duration(seconds: 2),
    ));
    _positionStreamSubscription =
        positionStreamController.stream.listen((position) {
      currentPosition.value = position;
    });
  }

  void playAlarm() async {
    alarmPlaying = true;
    // await FlutterRingtonePlayer.playRingtone(looping: false); 
  }

  void stopAlarm() async {
    alarmPlaying = false;
    // await FlutterRingtonePlayer.stop();
  }

  

  @override
  void dispose() async {
    await FlutterRingtonePlayer.stop();
    _positionStreamSubscription?.cancel();
    positionStreamController.close();
    super.dispose();
  }
}
