import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'addedit_alarm_form_state.freezed.dart';

@freezed
class AddEditAlarmFormState with _$AddEditAlarmFormState {
  const AddEditAlarmFormState._();
  const factory AddEditAlarmFormState({
    required bool showErrorMessage,
    required bool isInit,
    required bool isSaving,
    required bool successful,
    required bool hasSqlFailure,
    required bool hasMapLoaded,
    required bool hasInitialPositionLoaded,
    required GoogleMapController? mapController,
    required Set<Marker> markers,
    required Set<Circle> circles,
    required Position currentPosition,
    required String? nameErrorMessage,
    required String? destinationMarkErrorMessage,
    required int? alarmId,
    required String alarmName,
    required int alarmRadius,
    required double destLat,
    required double destLng,
    required TextEditingController destAddressController,
  }) = _AddEditAlarmFormState;

  factory AddEditAlarmFormState.initial() => AddEditAlarmFormState(
        showErrorMessage: false,
        isInit: true,
        isSaving: false,
        successful: false,
        hasSqlFailure: false,
        hasMapLoaded: false,
        hasInitialPositionLoaded: false,
        markers: <Marker>{},
        circles: <Circle>{},
        currentPosition: Position(
            longitude: 103.851959,
            latitude: 1.290270,
            timestamp: null,
            accuracy: 0.0,
            altitude: 0.0,
            heading: .00,
            speed: 0.0,
            speedAccuracy: 0.0),
        mapController: null,
        nameErrorMessage: null,
        destinationMarkErrorMessage: null,
        alarmId: null,
        alarmName: '',
        alarmRadius: 100,
        destLat: 0.0,
        destLng: 0.0,
        destAddressController: TextEditingController(),
      );
}
