import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'addedit_alarm_form_state.freezed.dart';

@freezed
class AddEditAlarmFormState with _$AddEditAlarmFormState {
  const AddEditAlarmFormState._();
  const factory AddEditAlarmFormState({
    required bool hasConnection,
    required bool showErrorMessage,
    required bool isSaving,
    required bool successful,
    required bool hasSqlFailure,
    required bool hasMapLoaded,
    required bool hasInitialPositionLoaded,
    required String? nameErrorMessage,
    required String alarmName,
    required int alarmRadius,
    required double destLat,
    required double destLng,
    required CameraPosition cameraPosition,
  }) = _AddEditAlarmFormState;

  factory AddEditAlarmFormState.initial() => const AddEditAlarmFormState(
      hasConnection: true,
      showErrorMessage: false,
      isSaving: false,
      successful: false,
      hasSqlFailure: false,
      hasMapLoaded: false,
      hasInitialPositionLoaded: false,
      nameErrorMessage: null,
      alarmName: '',
      alarmRadius: 100,
      destLat: 0.0,
      destLng: 0.0,
      cameraPosition: CameraPosition(target: LatLng(0.0, 0.0)));
}
