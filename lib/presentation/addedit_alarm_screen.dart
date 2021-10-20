import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_alarm/application/addedit_alarm_form_state.dart';
import 'package:location_alarm/infrastructure/models/alarm.dart';
import 'package:location_alarm/presentation/addedit_alarm_form.dart';

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
    Future.microtask(() async {
      await ref
          .read(addEditAlarmFormNotifierProvider.notifier)
          .initialisePositionStream();
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments != null) {
        ref
            .read(addEditAlarmFormNotifierProvider.notifier)
            .initialiseValueForEditAlarmForm(arguments as Alarm);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AddEditAlarmFormState>(addEditAlarmFormNotifierProvider,
        (state) {
      if (state.successful) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }

      if (state.hasSqlFailure) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('An unexpected error occurred. Please contact support.'),
          duration: Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ));
      }
    });
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
