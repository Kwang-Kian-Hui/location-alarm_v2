import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_alarm/application/addedit_alarm_form_state.dart';
import 'package:location_alarm/presentation/addedit_alarm_form.dart';

import 'package:location_alarm/presentation/widgets/google_map_page_widgets.dart';
import 'package:location_alarm/presentation/widgets/progress_indicator_overlay.dart';
import 'package:location_alarm/shared/providers.dart';

class AddEditAlarmScreen extends ConsumerStatefulWidget {
  const AddEditAlarmScreen({Key? key}) : super(key: key);
  static const routeName = 'addedit-alarm-screen';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddEditAlarmScreenState();
}

class _AddEditAlarmScreenState extends ConsumerState<AddEditAlarmScreen> {
  @override
  void initState() {
    Future.microtask(() async => await ref
        .read(addEditAlarmFormNotifierProvider.notifier)
        .initialisePositionStream());
    super.initState();
  }

  // @override
  // void () {
  //   super.initState();
  //   ref
  //       .read(addEditAlarmFormNotifierProvider.notifier)
  //       .initialisePositionStream();
  // }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
          height: height,
          width: width,
          child: Stack(
            children: [
              const AddEditAlarmForm(),
              ProgressIndicatorOverlay(
                isSaving: ref.watch(addEditAlarmFormNotifierProvider
                    .select((state) => state.isSaving)),
                text: 'Saving',
              ),
            ],
          )),
    );
  }
}
