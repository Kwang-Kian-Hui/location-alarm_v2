import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddEditAlarmScreen extends ConsumerStatefulWidget {
  const AddEditAlarmScreen({Key? key}) : super(key: key);
  static const routeName = 'addedit-alarm-screen';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddEditAlarmScreenState();
}

class _AddEditAlarmScreenState extends ConsumerState<AddEditAlarmScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: Scaffold(
          // key: homeScaffoldKey,
          body: Stack(
            children: <Widget>[
              _googleMap(),
              // _zoomInAndOutButton(width),
              // _topBar(height, width),
              // _camMoveToCurrentLocation(height, width),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _googleMap() {
  return GoogleMap(
    initialCameraPosition: CameraPosition(
      target: LatLng(1.290270, 103.851959),
    ),
  );
}
