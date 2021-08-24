import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_alarm/presentation/widgets/google_map_page_widgets.dart';
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
          // ref.watch(addEditAlarmFormNotifierProvider).hasMapLoaded ? topFormBar(height, width, mapController!, ref) : Center(),
          // ref.watch(addEditAlarmFormNotifierProvider).hasMapLoaded ? zoomInAndOutButton(width, mapController!) : const Center(),

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
                    // markers: markers,
                    // circles: circles,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    // onTap: _onTapAction,
                  ),
                )
              : Center(child: CircularProgressIndicator()),
          Positioned(
            right: 15,
            bottom: 15,
            child: ref.watch(addEditAlarmFormNotifierProvider).hasMapLoaded
                ? camMoveToCurrentLocationButton(
                    height, width, mapController!, ref)
                : Container(),
          ),
        ],
      ),
    );
  }
}
