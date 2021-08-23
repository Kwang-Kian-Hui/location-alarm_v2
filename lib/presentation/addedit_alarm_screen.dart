import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location_alarm/presentation/widgets/google_map_widgets.dart';

class AddEditAlarmScreen extends ConsumerStatefulWidget {
  const AddEditAlarmScreen({Key? key}) : super(key: key);
  static const routeName = 'addedit-alarm-screen';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddEditAlarmScreenState();
}

class _AddEditAlarmScreenState extends ConsumerState<AddEditAlarmScreen> {
  late GoogleMapController _mapController;

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              googleMapBackground(_mapController),
              zoomInAndOutButton(width, _mapController),
              camMoveToCurrentLocationButton(height, width, _mapController, ref),
              topFormBar(height, width, ref),
            ],
          ),
        ),
      ),
    );
  }
}


