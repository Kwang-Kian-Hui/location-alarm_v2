import 'dart:async';
import 'package:dartz/dartz.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_alarm/infrastructure/custom_failures.dart';
import 'package:riverpod/riverpod.dart';

import 'package:location_alarm/application/addedit_alarm_form_state.dart';
import 'package:location_alarm/infrastructure/alarm_repository.dart';

class AddEditAlarmFormNotifier extends StateNotifier<AddEditAlarmFormState> {
  final AlarmRepository _alarmRepository;
  AddEditAlarmFormNotifier(this._alarmRepository)
      : super(AddEditAlarmFormState.initial());

  StreamSubscription<Position>? _positionStreamSubscription;

  void alarmNameChanged(String name) {
    state = state.copyWith(alarmName: name.trim());
  }

  void alarmRadiusChanged(int radius) {
    state = state.copyWith(alarmRadius: radius);
  }

  void alarmDestLatChanged() {}

  void alarmDestLngChanged() {}

  void alarmCameraPositionChanged() {}

  void loadMapController(GoogleMapController mapController) {
    print('map state loaded');
    state = state.copyWith(
        mapController: mapController, hasMapLoaded: !state.hasMapLoaded);
  }

  void initialPositionStateChanged() {
    print('initial pos state changed');
    state = state.copyWith(
        hasInitialPositionLoaded: !state.hasInitialPositionLoaded);
  }

  Future<void> initialisePositionStream() async {
    print('get position stream');
    _positionStreamSubscription = await Geolocator.getPositionStream(
            intervalDuration: Duration(seconds: 2))
        .listen((Position position) {
      print(position.latitude);
      print(position.longitude);
      if (mounted) {
        print('update pos');
        state = state.copyWith(currentPosition: position);
        if(!state.hasInitialPositionLoaded) initialPositionStateChanged();
      }
    });
  }

  Future<void> _validateInputs() async {}

  void addAlarm() {}

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }
}
