import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:location_alarm/application/alarm.dart';
import 'package:location_alarm/presentation/widgets/alarm_list_items.dart';
import 'package:location_alarm/shared/providers.dart';
import 'package:location_alarm/database/database.dart';
import 'package:location_alarm/presentation/addedit_alarm_screen.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Location Alarm"),
      ),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).pushNamed(AddEditAlarmScreen.routeName),
      ),
      body: state.map(
        initial: (_) => Container(),
        loading: (_) => Center(
          child: CircularProgressIndicator(),
        ),
        noConnection: (_) => Container(),
        noLocationService: (_) => Container(),
        failure: (failure) => Container(),
        loaded: (loaded) => ListView.builder(
          itemCount: loaded.alarmList.length,
          itemBuilder: (context, index) => ProviderScope(
            overrides: [
              currentAlarmItem.overrideWithValue(loaded.alarmList[index]),
            ],
            child: const AlarmListItem()),
        ),
      ),
    );
  }
}
