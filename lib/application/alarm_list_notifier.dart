import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_alarm/application/alarm_list_state.dart';

class AlarmListNotifier extends StateNotifier<AlarmListState>{
  AlarmListNotifier() : super(const AlarmListState.initial());

  
}