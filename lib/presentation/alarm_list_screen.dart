import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:location_alarm/application/alarm.dart';
import 'package:location_alarm/database/database.dart';
import 'package:location_alarm/presentation/addedit_alarm_screen.dart';

enum MenuOptions {
  Edit,
  Delete,
}

class AlarmListScreen extends ConsumerStatefulWidget {
  const AlarmListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AlarmListScreenState();
}

class _AlarmListScreenState extends ConsumerState<AlarmListScreen> {
  late List<Alarm> alarmsList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      await AlarmsDatabase.instance.getAlarmsList();
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await AlarmsDatabase.instance.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      floatingActionButton: IconButton(
        icon: Icon(Icons.add),
        onPressed: () => Navigator.of(context).pushNamed(AddEditAlarmScreen.routeName),
      )
    );
  }
}