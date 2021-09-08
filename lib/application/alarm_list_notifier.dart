import 'dart:async';
import 'package:background_location/background_location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:location_alarm/application/alarm.dart';
import 'package:location_alarm/application/alarm_list_state.dart';
import 'package:location_alarm/infrastructure/alarm_repository.dart';
import 'package:location_alarm/shared/providers.dart';

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
  bool locationPermission = false;

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

  void initialiseBackgroundLocation() {
    // BackgroundLocation.startLocationService();
    // // BackgroundLocation.getPermissions(
    // //   onGranted: () async {
    // //     print("permission granted background location");
    // //     locationPermission = true;
    // //     await BackgroundLocation.setAndroidConfiguration(1000);
    // //     BackgroundLocation.startLocationService(
    // //         /*distanceFilter : 10*/); //consider using distance filter
    // //   },
    // //   onDenied: () {
    // //     print("permission denied background location");
    // //     locationPermission = false;
    // //   },
    // // );
    // BackgroundLocation.getLocationUpdates((location) {
    //   // _alarmsList = Provider.of<Alarms>(context, listen: false).alarms;
    //   Position newPos = Position(
    //     latitude: location.latitude!,
    //     longitude: location.longitude!,
    //     speed: location.speed!,
    //     isMocked: location.isMock!,
    //     altitude: location.altitude!,
    //     accuracy: location.accuracy!,
    //     heading: 0,
    //     speedAccuracy: 0,
    //     timestamp: null,
    //   );
    // });
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

  void turnOnAlarm() async {
    alarmPlaying = true;
    // await FlutterRingtonePlayer.playRingtone(looping: false);
  }

  void turnOffAlarm() async {
    alarmPlaying = false;
    // await FlutterRingtonePlayer.stop();
  }

  void ringAlarm() {
    Timer.periodic(Duration(seconds: 2), (Timer t) {
      if (alarmType == 1) {
        FlutterRingtonePlayer.playRingtone(looping: false);
      }
      if (alarmType == 2) {
        FlutterRingtonePlayer.playRingtone(looping: false);
        //do vibration
      }
      if (alarmType == 3) {
        //do vibration
      } else {
        FlutterRingtonePlayer.playRingtone(looping: false);
      }

      if (!alarmPlaying) {
        t.cancel();
      }
    });
  }

  @override
  void dispose() async {
    await FlutterRingtonePlayer.stop();
    _positionStreamSubscription?.cancel();
    positionStreamController.close();
    BackgroundLocation.stopLocationService();
    super.dispose();
  }
}
