import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_alarm/application/alarm.dart';
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
      if (mounted) {
        print('update pos');
        state = state.copyWith(currentPosition: position);
        if (!state.hasInitialPositionLoaded) initialPositionStateChanged();
      }
    });
  }

  void addOrUpdateNewMarker(LatLng newLatLng) async {
    print('placemarkfromcoord');
    List<Placemark> destinationPlacemark =
        await placemarkFromCoordinates(newLatLng.latitude, newLatLng.longitude);
    // _destinationLatLng = LatLng(newLatLng.latitude, newLatLng.longitude);
    state = state.copyWith(destLat: newLatLng.latitude);
    state = state.copyWith(destLng: newLatLng.longitude);
    print('replaced latlng');
    // print("destination latlng: $_destinationLatLng");
    print('address writing');
    final destinationAddress =
        "${destinationPlacemark[0].name},${destinationPlacemark[0].locality},${destinationPlacemark[0].postalCode},${destinationPlacemark[0].country}";
    state.destAddressController.text = destinationAddress;

    print('make new marker');
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

    print('make new circle');
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
      print('added new marker and circle');
    } else {
      state.markers.clear();
      state.markers.add(newMarker);
      state.circles.clear();
      state.circles.add(newCircle);
      print('cleared and added new marker and circle');
    }
  }

  Future<void> _validateInputs() async {}

  void addAlarm() async {
    print('add alarm');
    state = state.copyWith(
      hasConnection: true,
      hasSqlFailure: false,
    );
    // _validateInputs();

    print('got here');
    if (state.nameErrorMessage == null) {
      state = state.copyWith(
        isSaving: true,
        hasConnection: true,
      );
    }

    print('new alarm up');
    final newAlarm = Alarm(
      alarmId: null,
      alarmName: state.alarmName,
      alarmRadius: state.alarmRadius,
      destLat: state.destLat,
      destLng: state.destLng,
      alarmStatus: false,
    );

    if (!state.hasSqlFailure && state.hasConnection) {
      print('attempt add alarm await');
      final failureOrSuccess = await _alarmRepository.addAlarm(newAlarm);

      failureOrSuccess.fold((failure) {
        failure.maybeWhen(
          noConnection: () {
            state = state.copyWith(
              hasConnection: false,
              isSaving: false,
            );
          },
          orElse: () {
            state = state.copyWith(
              isSaving: false,
              hasSqlFailure: true,
            );
          },
        );
      }, (_) {
        print('successfully added');
        state = state.copyWith(
          isSaving: false,
          successful: true,
        );
      });
    }
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    state.destAddressController.dispose();
    super.dispose();
  }
}
