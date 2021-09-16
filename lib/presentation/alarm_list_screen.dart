import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:location_alarm/application/alarm.dart';
import 'package:location_alarm/presentation/settings_screen.dart';
import 'package:location_alarm/presentation/widgets/alarm_list_items.dart';
import 'package:location_alarm/shared/providers.dart';
import 'package:location_alarm/database/database.dart';
import 'package:location_alarm/presentation/addedit_alarm_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmListScreen extends ConsumerStatefulWidget {
  const AlarmListScreen({Key? key}) : super(key: key);
  static const routeName = 'alarm-list-screen';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AlarmListScreenState();
}

class _AlarmListScreenState extends ConsumerState<AlarmListScreen> {
  late List<Alarm> alarmsList;
  int? alarmType;
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(alarmListNotifierProvider.notifier).getAlarmsList();
      ref
          .read(alarmListNotifierProvider.notifier)
          .initialiseBackgroundLocation();
      // ref.read(alarmListNotifierProvider.notifier).initialisePositionStream();
      final pref = await SharedPreferences.getInstance();
      alarmType = pref.getInt('alarmType');
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location Alarm"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () =>
                Navigator.of(context).pushNamed(AlarmSettingsScreen.routeName, arguments: alarmType ?? 1),
          ),
        ],
      ),
      floatingActionButton: IconButton(
        splashColor: Theme.of(context).primaryColor,
        icon: const Icon(Icons.add),
        onPressed: () =>
            Navigator.of(context).pushNamed(AddEditAlarmScreen.routeName),
      ),
      body: Stack(
        children: [
          state.map(
            initial: (_) => Center(),
            loading: (_) => Center(
              child: CircularProgressIndicator(),
            ),
            noConnection: (_) => Center(),
            noLocationService: (_) => GestureDetector(
              onTap: () async {
                await Permission.locationAlways.request();
                await ref
                    .read(alarmListNotifierProvider.notifier)
                    .getAlarmsList();
              },
              child: const Center(
                child: Text("Background location service is required."),
              ),
            ),
            failure: (failure) => Center(
              child:
                  Text("An error occurred. Please contact support for help."),
            ),
            loaded: (loaded) => ListView.builder(
              itemCount: loaded.alarmList.length,
              itemBuilder: (context, index) => ProviderScope(overrides: [
                currentAlarmItem.overrideWithValue(loaded.alarmList[index]),
              ], child: const AlarmListItem()),
            ),
          ),
        ],
      ),
    );
  }
}
