import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:location_alarm/application/alarm.dart';
import 'package:location_alarm/presentation/settings_screen.dart';
import 'package:location_alarm/presentation/widgets/alarm_list_items.dart';
import 'package:location_alarm/presentation/widgets/ringing_alarm_overlay.dart';
import 'package:location_alarm/shared/providers.dart';
import 'package:location_alarm/database/database.dart';
import 'package:location_alarm/presentation/addedit_alarm_screen.dart';

class AlarmListScreen extends ConsumerStatefulWidget {
  const AlarmListScreen({Key? key}) : super(key: key);
  static const routeName = 'alarm-list-screen';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AlarmListScreenState();
}

class _AlarmListScreenState extends ConsumerState<AlarmListScreen> {
  late List<Alarm> alarmsList;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(alarmListNotifierProvider.notifier).getAlarmsList();
      
      ref.read(alarmListNotifierProvider.notifier).initialisePositionStream();
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await AlarmsDatabase.instance.close();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(alarmListNotifierProvider);
    final alarmState =
        ref.watch(alarmListNotifierProvider.notifier).alarmPlaying;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location Alarm"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () =>
                Navigator.of(context).pushNamed(AlarmSettingsScreen.routeName),
          ),
        ],
      ),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () =>
            Navigator.of(context).pushNamed(AddEditAlarmScreen.routeName),
      ),
      body: Stack(
        children: [
          state.map(
            initial: (_) => const Center(),
            loading: (_) => const Center(
              child: CircularProgressIndicator(),
            ),
            noConnection: (_) => Container(), //TODO: no connection
            noLocationService: (_) => Container(), //TODO: no permission
            failure: (failure) => const Center(
              child: Text("An error occured, please contact support for help."),
            ), //TODO: error
            loaded: (loaded) => ListView.builder(
              itemCount: loaded.alarmList.length,
              itemBuilder: (context, index) => ProviderScope(overrides: [
                currentAlarmItem.overrideWithValue(loaded.alarmList[index]),
              ], child: const AlarmListItem()),
            ),
          ),
          if (alarmState) RingingAlarmOverlay(isRinging: alarmState),
        ],
      ),
    );
  }
}

