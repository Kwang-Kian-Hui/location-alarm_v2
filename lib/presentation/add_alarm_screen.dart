import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddEditAlarmScreen extends ConsumerStatefulWidget {
  const AddEditAlarmScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddEditAlarmScreenState();
}

class _AddEditAlarmScreenState extends ConsumerState<AddEditAlarmScreen> {
  late GoogleMapController _mapController;

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
              _googleMap(_mapController),
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

Widget _googleMap(GoogleMapController _mapController) {
  return GoogleMap(
    initialCameraPosition: CameraPosition(
      target: LatLng(1.290270, 103.851959),
      zoom: 18,
    ),
    myLocationButtonEnabled: false,
    mapType: MapType.normal,
    // markers: markers,
    // circles: circles,
    zoomGesturesEnabled: true,
    zoomControlsEnabled: false,
    onMapCreated: (controller) {
      _mapController = controller;

    }, 
    // onTap: _onTapAction,
  );
}



// Widget _camMoveToCurrentLocation(height, width) {
//     return SafeArea(
//       child: Padding(
//         padding: EdgeInsets.only(
//           left: width * 12 / 15,
//           top: height * 13 / 15,
//         ),
//         child: ClipOval(
//           child: Container(
//             width: 60,
//             height: 60,
//             color: Colors.grey[300], // button color
//             child: IconButton(
//               icon: Icon(Icons.my_location),
//               iconSize: 30,
//               onPressed: () {
//                 mapController.animateCamera(
//                   CameraUpdate.newCameraPosition(
//                     CameraPosition(
//                       target: LatLng(
//                         // Will be fetching in the next step
//                         _currentPosition.latitude,
//                         _currentPosition.longitude,
//                       ),
//                       zoom: 18.0,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }