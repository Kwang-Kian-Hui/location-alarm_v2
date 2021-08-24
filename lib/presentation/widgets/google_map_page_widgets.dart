import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_alarm/shared/providers.dart';

Widget zoomInAndOutButton(width, mapController) {
  return SafeArea(
    child: Padding(
      padding: EdgeInsets.only(left: width / 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipOval(
            child: Material(
              color: Colors.grey[300],
              child: InkWell(
                splashColor: Colors.black,
                child: SizedBox(
                  width: width / 10,
                  height: width / 10,
                  child: Icon(Icons.add),
                ),
                onTap: () {
                  mapController.animateCamera(
                    CameraUpdate.zoomIn(),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: width / 30),
          ClipOval(
            child: Material(
              color: Colors.grey[300],
              child: InkWell(
                splashColor: Colors.black,
                child: SizedBox(
                  width: width / 10,
                  height: width / 10,
                  child: Icon(Icons.remove),
                ),
                onTap: () {
                  mapController.animateCamera(
                    CameraUpdate.zoomOut(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget camMoveToCurrentLocationButton(double height, double width,
    GoogleMapController mapController, WidgetRef ref) {
  return Padding(
    padding: EdgeInsets.only(
      left: width * 12 / 15,
      top: height * 13 / 15,
    ),
    child: ClipOval(
      child: Container(
        width: 60,
        height: 60,
        color: Colors.grey[300], // button color
        child: IconButton(
          icon: Icon(Icons.my_location),
          iconSize: 30,
          onPressed: () {
            final currentPosition = ref.read(addEditAlarmFormNotifierProvider).currentPosition;
            mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(
                    currentPosition.latitude,
                    currentPosition.longitude,
                  ),
                  zoom: 18.0,
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

Widget topFormBar(double height, double width,
    GoogleMapController mapController, WidgetRef ref) {
  print('top form bar');
  return SafeArea(
    child: Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: width / 30),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          width: width * 0.9,
          child: Padding(
            padding: EdgeInsets.all(width / 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Destination"),
                SizedBox(height: 10),
                // style text maybe?
                Row(
                  children: [
                    // searchAddressBar(height, width, context),
                    SizedBox(width: width * 0.01),
                    centerCurrentAndDestLocation(
                        height, width, mapController, ref),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    alarmNameTextFormField(height, width, ref),
                    SizedBox(width: width * 0.01),
                    alarmRadiusDropdownMenu(height, width, ref),
                    SizedBox(width: width * 0.01),
                    submitFormButton(height, width, ref),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget centerCurrentAndDestLocation(
    height, width, GoogleMapController mapController, WidgetRef ref) {
  final currentPosition =
      ref.read(addEditAlarmFormNotifierProvider).currentPosition;
  final destLat = ref.read(addEditAlarmFormNotifierProvider).destLat;
  final destLng = ref.read(addEditAlarmFormNotifierProvider).destLng;
  return Container(
    width: width * 0.12,
    height: height * 0.077,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      border: Border.all(
        width: 2,
      ),
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    child: IconButton(
      icon: Icon(
        Icons.location_on,
      ),
      onPressed: () {
        double _southWestLat;
        double _southWestLong;
        double _northEastLat;
        double _northEastLong;

        if (currentPosition.latitude <= destLat) {
          _southWestLat = currentPosition.latitude;
          _northEastLat = destLat;
        } else {
          _northEastLat = currentPosition.latitude;
          _southWestLat = destLat;
        }

        if (currentPosition.longitude <= destLng) {
          _southWestLong = currentPosition.longitude;
          _northEastLong = destLng;
        } else {
          _northEastLong = currentPosition.longitude;
          _southWestLong = destLng;
        }

        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(_northEastLat, _northEastLong),
              southwest: LatLng(_southWestLat, _southWestLong),
            ),
            100,
          ),
        );
      },
    ),
  );
}

Widget alarmNameTextFormField(double height, double width, WidgetRef ref) {
  return Container(
    width: width * 0.458,
    height: height * 0.068,
    child: TextFormField(
      initialValue: ref.read(addEditAlarmFormNotifierProvider).alarmName,
      //     errorText: ref.watch(addEditAlarmFormNotifierProvider
      //     .select((state) => state.showErrorMessage))
      // ? ref.watch(addEditAlarmFormNotifierProvider
      //     .select((state) => state.usualPriceErrorMessage))
      // : null,
      onChanged: (_) =>
          ref.read(addEditAlarmFormNotifierProvider.notifier).alarmNameChanged,
      decoration: InputDecoration(
        //labelText: "Search for Address",
        labelText: "Enter alarm name",
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide(
        //     color: Colors.blue,
        //     width: 2,
        //   ),
        // ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
      ),
    ),
  );
}

Widget alarmRadiusDropdownMenu(double height, double width, WidgetRef ref) {
  return Container(
    padding: EdgeInsets.only(left: 10, right: 10),
    width: width * 0.23,
    height: height * 0.068,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      border: Border.all(
        width: 2,
      ),
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    child: DropdownButton<int>(
      isExpanded: true,
      value: ref.watch(addEditAlarmFormNotifierProvider).alarmRadius,
      icon: const Icon(Icons.arrow_drop_down),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (newValue) {
        ref
            .read(addEditAlarmFormNotifierProvider.notifier)
            .alarmRadiusChanged(newValue!);
        //   if (circles.isNotEmpty) {
        //     Circle newCircle = Circle(
        //       circleId: CircleId('$_destinationLatLng'),
        //       fillColor: Color.fromRGBO(70, 180, 255, 0.5),
        //       strokeWidth: 0,
        //       center: _destinationLatLng,
        //       radius: radiusValue.toDouble(),
        //     );
        //     circles.clear();
        //     circles.add(newCircle);
        //   }
        // });
      },
      items: <int>[100, 300, 500, 1000, 2000]
          .map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    ),
  );
}

Widget submitFormButton(double height, double width, WidgetRef ref) {
  return Container(
    width: width * 0.12,
    height: height * 0.068,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      border: Border.all(
        width: 2,
      ),
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    // child: IconButton(
    //   icon: Icon(
    //     Icons.done,
    //   ),
    // onPressed: () async {
    //   // add new alarm
    //   if (destinationAddressController.text == "") {
    //     await showDialog<Null>(
    //       //wait for user to press button to close error msg
    //       context: context,
    //       builder: (ctx) => AlertDialog(
    //         title: Text("Please mark a destination"),
    //         content: Text(
    //           "Tap a location on the map to set a destination.", //error.toString(),
    //         ),
    //         actions: <Widget>[
    //           TextButton(
    //             child: Text("Okay"),
    //             onPressed: () {
    //               Navigator.of(ctx).pop();
    //             },
    //           ),
    //         ],
    //       ),
    //     );
    //   }
    //   _addEditAlarm();
    // },
    // ),
  );
}
