import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_alarm/presentation/widgets/addedit_alarm_form_widgets.dart';
import 'package:location_alarm/shared/providers.dart';

class AddEditAlarmForm extends ConsumerWidget {
  const AddEditAlarmForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void _onMapCreated(GoogleMapController controller) {
      ref
          .read(addEditAlarmFormNotifierProvider.notifier)
          .loadMapController(controller);
    }

    void _onTapAction(LatLng latlng) async {
    try {
      print('ontapaction');
      ref.read(addEditAlarmFormNotifierProvider.notifier).addOrUpdateNewMarker(latlng);
    } catch (e) {
      print(e);
    }
  }

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final mapController =
        ref.watch(addEditAlarmFormNotifierProvider).mapController;
    // final initialPositionLoaded =
    //     ref.watch(addEditAlarmFormNotifierProvider).hasInitialPositionLoaded;

    // ref.listen<AddEditAlarmFormState>(addEditAlarmFormNotifierProvider, (state) {})
    return SafeArea(
      child: Stack(
        clipBehavior: Clip.hardEdge,
        fit: StackFit.expand,
        children: <Widget>[
          ref.read(addEditAlarmFormNotifierProvider).hasInitialPositionLoaded
              ? Positioned(
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          ref
                              .read(addEditAlarmFormNotifierProvider)
                              .currentPosition
                              .latitude,
                          ref
                              .read(addEditAlarmFormNotifierProvider)
                              .currentPosition
                              .longitude),
                      zoom: 18,
                    ),
                    myLocationButtonEnabled: false,
                    mapType: MapType.normal,
                    markers: ref.watch(addEditAlarmFormNotifierProvider).markers,
                    circles: ref.watch(addEditAlarmFormNotifierProvider).circles,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    onTap: _onTapAction,
                  ),
                )
              : Center(child: CircularProgressIndicator()),
          // Positioned(
          //   right: 15,
          //   bottom: 15,
          //   child: ref.watch(addEditAlarmFormNotifierProvider).hasMapLoaded
          //       ? camMoveToCurrentLocationButton(
          //           height, width, mapController!, ref)
          //       : Container(),
          // ),
          // Positioned(
          //   child: ref.watch(addEditAlarmFormNotifierProvider).hasMapLoaded
          //       ? zoomInAndOutButton(width, mapController!)
          //       : Container(),
          // ),
          // Positioned.fill(
          //   top: 5,
          //   child: Align(
          //     alignment: Alignment.topCenter,
          //     child: ref.watch(addEditAlarmFormNotifierProvider).hasMapLoaded
          //         ? topFormBar(height, width, mapController!, ref)
          //         : Container(),
          //   ),
          // ),
          ref.watch(addEditAlarmFormNotifierProvider).hasMapLoaded
                ? camMoveToCurrentLocationButton(
                    height, width, mapController!, ref)
                : Container(),
          ref.watch(addEditAlarmFormNotifierProvider).hasMapLoaded
                ? zoomInAndOutButton(width, mapController!)
                : Container(),
          ref.watch(addEditAlarmFormNotifierProvider).hasMapLoaded
                  ? topFormBar(height, width, context, mapController!, ref)
                  : Container(),
        ],
      ),
    );
  }
}
