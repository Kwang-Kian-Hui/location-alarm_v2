import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:location_alarm/application/alarm.dart';
import 'package:location_alarm/shared/providers.dart';

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
    super.initState();
    Future.microtask(() async {
      await ref.read(alarmListNotifierProvider.notifier).getAlarmsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(alarmListNotifierProvider);
    return Scaffold(
      body: state.map(
        initial: (_) => Container(),
        loading: (_) => Container(),
        noConnection: (_) => Container(),
        noLocationService: (_) => Container(),
        loaded: (loaded) => Container(),
      ),
    );
  }
}
