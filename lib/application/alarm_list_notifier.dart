import 'dart:async';
import 'package:background_location/background_location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:location_alarm/infrastructure/models/alarm.dart';
import 'package:location_alarm/application/alarm_list_state.dart';
import 'package:location_alarm/infrastructure/alarm_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmListNotifier extends StateNotifier<AlarmListState> {
  final AlarmRepository _alarmRepository;
  AlarmListNotifier(this._alarmRepository)
      : super(const AlarmListState.initial());
  ValueNotifier<Position> currentPosition = ValueNotifier<Position>(Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0));
  bool alarmPlaying = false;
  bool locationPermission = false;
  List<Alarm> listOfAlarms = [];

  Future<void> getAlarmsList() async {
    state = const AlarmListState.loading();

    //TODO: internet checker

    await Permission.locationAlways.request();

    if (await Permission.locationAlways.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      final getListResult = await _alarmRepository.getAlarmList();

      getListResult.fold(
        (failure) => state = AlarmListState.failure(failure),
        (alarmList) {
          print("update alarm list");
          print(currentPosition);
          listOfAlarms = alarmList;
          state = AlarmListState.loaded(alarmList);
        },
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
      },
    );
  }

  Future<void> deleteAlarm(int alarmId) async {
    final deleteResult = await _alarmRepository.deleteAlarm(alarmId);

    deleteResult.fold(
      (f) => state = AlarmListState.failure(f),
      (r) => () {},
    );
  }

  Future<void> initialiseBackgroundLocation() async {
    await Permission.locationAlways.request();

    if (await Permission.locationAlways.request().isGranted) {
      locationPermission = true;
      await BackgroundLocation.setAndroidConfiguration(2);
      BackgroundLocation.setAndroidNotification(
        title: "Location Alarm",
        message: "Background location service is running",
      );
      BackgroundLocation.startLocationService();
    } else {
      locationPermission = false;
    }

    BackgroundLocation.getLocationUpdates((location) async {
      Position newPos = Position(
        latitude: location.latitude ?? 0,
        longitude: location.longitude ?? 0,
        speed: location.speed ?? 0,
        isMocked: location.isMock ?? false,
        altitude: location.altitude ?? 0,
        accuracy: location.accuracy ?? 0,
        heading: 0,
        speedAccuracy: 0,
        timestamp: null,
      );
      currentPosition.value = newPos;

      bool ringAlarm = false;
      //get list
      for (int i = 0; i < listOfAlarms.length; ++i) {
        if (listOfAlarms[i].alarmStatus) {
          double distance = Geolocator.distanceBetween(
            newPos.latitude,
            newPos.longitude,
            listOfAlarms[i].destLat,
            listOfAlarms[i].destLng,
          );
          if (distance < listOfAlarms[i].alarmRadius) {
            ringAlarm = true;
          }
        }
      }
      if (ringAlarm) {
        final pref = await SharedPreferences.getInstance();
        final alarmType = pref.getInt('alarmType');
        if (!alarmPlaying) {
          alarmPlaying = true;
          if (alarmType == 1) FlutterRingtonePlayer.playAlarm(); //alarm
          if (alarmType == 2) {
            Vibrate.vibrate();
            FlutterRingtonePlayer.playAlarm(); //alarm and vibrate
          }
        }
        if (alarmType != 1) Vibrate.vibrate();
      } else {
        if (alarmPlaying) {
          FlutterRingtonePlayer.stop();
          alarmPlaying = false;
        }
      }
    });
  }

  @override
  void dispose() async {
    await FlutterRingtonePlayer.stop();
    BackgroundLocation.stopLocationService();
    super.dispose();
  }
}
