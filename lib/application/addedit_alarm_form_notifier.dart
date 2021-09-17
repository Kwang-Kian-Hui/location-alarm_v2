import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_alarm/application/alarm.dart';
import 'package:location_alarm/application/place_and_suggestion.dart';
import 'package:location_alarm/application/value_validators.dart';
import 'package:location_alarm/infrastructure/google_places_api_provider.dart';
import 'package:riverpod/riverpod.dart';

import 'package:location_alarm/application/addedit_alarm_form_state.dart';
import 'package:location_alarm/infrastructure/alarm_repository.dart';
import 'package:uuid/uuid.dart';

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
    if (state.circles.isNotEmpty) {
      Circle newCircle = Circle(
        circleId: CircleId('${LatLng(state.destLat, state.destLng)}'),
        fillColor: Color.fromRGBO(70, 180, 255, 0.5),
        strokeWidth: 0,
        center: LatLng(state.destLat, state.destLng),
        radius: radius.toDouble(),
      );
      state.circles.clear();
      state.circles.add(newCircle);
    }
  }

  void alarmDestLatChanged(double latitude) {
    state = state.copyWith(destLat: latitude);
  }

  void alarmDestLngChanged(double longitude) {
    state = state.copyWith(destLng: longitude);
  }

  void addressTextChanged(String address){
    state.destAddressController.text = address;
  }

  void initialiseValueForEditAlarmForm(Alarm alarm) {
    state = state.copyWith(
      isInit: false,
      alarmId: alarm.alarmId,
      alarmName: alarm.alarmName,
      alarmRadius: alarm.alarmRadius,
      destLat: alarm.destLat,
      destLng: alarm.destLng,
    );
  }

  void loadMapController(GoogleMapController mapController) {
    state = state.copyWith(
        mapController: mapController, hasMapLoaded: !state.hasMapLoaded);
  }

  void initialPositionStateChanged() {
    state = state.copyWith(
        hasInitialPositionLoaded: !state.hasInitialPositionLoaded);
  }

  Future<void> initialisePositionStream() async {
    _positionStreamSubscription = await Geolocator.getPositionStream(
            intervalDuration: Duration(seconds: 2))
        .listen((Position position) {
      if (mounted) {
        state = state.copyWith(currentPosition: position);
        if (!state.hasInitialPositionLoaded) initialPositionStateChanged();
      }
    });
  }

  Future<void> initialiseMarkersAndCircles() async {
    List<Placemark> destinationPlacemark =
        await placemarkFromCoordinates(state.destLat, state.destLng);
    final destinationAddress =
        "${destinationPlacemark[0].name},${destinationPlacemark[0].locality},${destinationPlacemark[0].postalCode},${destinationPlacemark[0].country}";
    addressTextChanged(destinationAddress);

    createNewMarkerAndCircle();
  }

  Future<void> initialiseSession() async{
    initialiseMarkersAndCircles();
    state = state.copyWith(sessionToken: Uuid().v4());
  }

  void addOrUpdateNewMarker(LatLng newLatLng) async {
    List<Placemark> destinationPlacemark =
        await placemarkFromCoordinates(newLatLng.latitude, newLatLng.longitude);
    // _destinationLatLng = LatLng(newLatLng.latitude, newLatLng.longitude);
    alarmDestLatChanged(newLatLng.latitude);
    alarmDestLngChanged(newLatLng.longitude);
    final destinationAddress =
        "${destinationPlacemark[0].name},${destinationPlacemark[0].locality},${destinationPlacemark[0].postalCode},${destinationPlacemark[0].country}";
    state.destAddressController.text = destinationAddress;

    createNewMarkerAndCircle();
  }

  void createNewMarkerAndCircle(){
    Marker newMarker = Marker(
      markerId: MarkerId('${LatLng(state.destLat, state.destLng)}'),
      position: LatLng(
        state.destLat,
        state.destLng,
      ),
      draggable: true,
      // infoWindow: InfoWindow(
      //   title: 'Destination',
      //   snippet: destinationAddressController.text,
      // ),
      icon: BitmapDescriptor.defaultMarker,
      onDragEnd: (newLatLng) async {
        addOrUpdateNewMarker(newLatLng);
      },
    );

    Circle newCircle = Circle(
      circleId: CircleId('${LatLng(state.destLat, state.destLng)}'),
      fillColor: Color.fromRGBO(70, 180, 255, 0.5),
      strokeWidth: 0,
      center: LatLng(state.destLat, state.destLng),
      radius: state.alarmRadius.toDouble(),
    );

    if (state.markers.isEmpty) {
      state.markers.add(newMarker);
      state.circles.add(newCircle);
    } else {
      state.markers.clear();
      state.markers.add(newMarker);
      state.circles.clear();
      state.circles.add(newCircle);
    }
  }

  void retrieveResultAddressDetail(Suggestion result) async {
    // GooglePlaceApiProvider() getPlaceDetailFromId
    final placeDetails = await GooglePlaceApiProvider(state.sessionToken).getPlaceDetailFromId(result.placeId);
    // addressTextChanged(placeDetails);
  }

  Future<void> _validateInputs() async {
    var errorState = state.copyWith(showErrorMessage: true);
    //validate name
    errorState = errorState.copyWith(nameErrorMessage: null);
    final errorFound = validateNotEmpty(state.alarmName);
    if (errorFound) {
      errorState =
          errorState.copyWith(nameErrorMessage: 'Alarm name cannot be empty');
    }

    errorState = errorState.copyWith(destinationMarkErrorMessage: null);
    if(state.markers.length == 0){
      errorState = errorState.copyWith(destinationMarkErrorMessage: 'Please mark a destination');
    }

    state = errorState;
  }

  void addAlarm() async {
    state = state.copyWith(
      hasSqlFailure: false,
    );
    _validateInputs();

    if (state.nameErrorMessage == null && state.destinationMarkErrorMessage == null) {
      state = state.copyWith(
        isSaving: true,
      );
      final newAlarm = Alarm(
        alarmId: null,
        alarmName: state.alarmName,
        alarmRadius: state.alarmRadius,
        destLat: state.destLat,
        destLng: state.destLng,
        alarmStatus: false,
      );

      if (!state.hasSqlFailure) {
        final failureOrSuccess = await _alarmRepository.addAlarm(newAlarm);

        failureOrSuccess.fold((failure) {
          failure.maybeWhen(
            orElse: () {
              state = state.copyWith(
                isSaving: false,
                hasSqlFailure: true,
              );
            },
          );
        }, (_) {
          state = state.copyWith(
            isSaving: false,
            successful: true,
          );
        });
      }
    }
  }

  void updateAlarm() async {
    state = state.copyWith(
      hasSqlFailure: false,
    );
    _validateInputs();

    if (state.nameErrorMessage == null && state.destinationMarkErrorMessage == null) {
      state = state.copyWith(
        isSaving: true,
      );
      final updatedAlarm = Alarm(
        alarmId: state.alarmId,
        alarmName: state.alarmName,
        alarmRadius: state.alarmRadius,
        destLat: state.destLat,
        destLng: state.destLng,
        alarmStatus: false,
      );

      if (!state.hasSqlFailure) {
        final failureOrSuccess = await _alarmRepository.updateAlarm(updatedAlarm);

        failureOrSuccess.fold((failure) {
          failure.maybeWhen(
            orElse: () {
              state = state.copyWith(
                isSaving: false,
                hasSqlFailure: true,
              );
            },
          );
        }, (_) {
          state = state.copyWith(
            isSaving: false,
            successful: true,
          );
        });
      }
    }
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    state.destAddressController.dispose();
    super.dispose();
  }
}
