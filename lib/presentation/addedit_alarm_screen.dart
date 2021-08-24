import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location_alarm/presentation/widgets/google_map_page_widgets.dart';
import 'package:location_alarm/shared/providers.dart';

class AddEditAlarmScreen extends ConsumerStatefulWidget {
  const AddEditAlarmScreen({Key? key}) : super(key: key);
  static const routeName = 'addedit-alarm-screen';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddEditAlarmScreenState();
}

class _AddEditAlarmScreenState extends ConsumerState<AddEditAlarmScreen> {
  late GoogleMapController _mapController;
  static LatLng _initialPosition = LatLng(0, 0);
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    ref.read(addEditAlarmFormNotifierProvider.notifier).mapLoadedStateChanged;
  }

  void getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // _positionStream =
    //     Geolocator.getPositionStream().listen((Position position) {
    //   _currentPosition = position;
    // });
    getCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final mapLoaded = ref.watch(addEditAlarmFormNotifierProvider).hasMapLoaded;
    final initialPositionLoaded =
        ref.watch(addEditAlarmFormNotifierProvider).hasInitialPositionLoaded;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: Scaffold(
          body: !initialPositionLoaded
              ? CircularProgressIndicator()
              : Stack(
                  children: <Widget>[
                    SafeArea(
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: const LatLng(1.290270, 103.851959),
                          zoom: 50,
                        ),
                        myLocationButtonEnabled: false,
                        mapType: MapType.normal,
                        // markers: markers,
                        // circles: circles,
                        zoomGesturesEnabled: true,
                        zoomControlsEnabled: false,
                        // onTap: _onTapAction,
                      ),
                    ),
                    if (mapLoaded) zoomInAndOutButton(width, _mapController),
                    if (mapLoaded)
                      camMoveToCurrentLocationButton(
                          height, width, _mapController, ref),
                    if (mapLoaded) topFormBar(height, width, ref),
                  ],
                ),
        ),
      ),
    );
  }
}
