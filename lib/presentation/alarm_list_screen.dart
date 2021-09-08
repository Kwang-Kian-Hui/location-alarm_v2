import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:location_alarm/application/alarm.dart';
import 'package:location_alarm/presentation/widgets/alarm_list_items.dart';
import 'package:location_alarm/shared/providers.dart';
import 'package:location_alarm/database/database.dart';
import 'package:location_alarm/presentation/addedit_alarm_screen.dart';
import 'package:permission_handler/permission_handler.dart';

// enum MenuOptions {
//   Edit,
//   Delete,
// }

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
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await AlarmsDatabase.instance.close();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final state = ref.watch(alarmListNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Location Alarm"),
      ),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () =>
            Navigator.of(context).pushNamed(AddEditAlarmScreen.routeName),
      ),
      body: state.map(
        initial: (_) => Container(),
        loading: (_) => Center(
          child: CircularProgressIndicator(),
        ),
        noConnection: (_) => Container(),
        noLocationService: (_) => GestureDetector(
          onTap: () async {
            await Permission.locationAlways.request();
            await ref.read(alarmListNotifierProvider.notifier).getAlarmsList();
          },
          child: const Center(
            child: Text("Background location service is required."),
          ),
        ),
        failure: (failure) => Center(
          child: Text("An unexpected error occurred."),
        ),
        loaded: (loaded) => ListView.builder(
          itemCount: loaded.alarmList.length,
          itemBuilder: (context, index) => ProviderScope(overrides: [
            currentAlarmItem.overrideWithValue(loaded.alarmList[index]),
          ], child: const AlarmListItem()),
        ),
      ),
    );
  }
}
