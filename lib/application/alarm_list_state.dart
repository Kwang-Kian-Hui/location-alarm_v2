import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:location_alarm/application/alarm.dart';

part 'alarm_list_state.freezed.dart';

@freezed
class AlarmListState with _$AlarmListState {
  const AlarmListState._();
  const factory AlarmListState.initial() = Initial;
  const factory AlarmListState.loading() = Loading;
  const factory AlarmListState.noConnection() = NoConnection;
  const factory AlarmListState.noLocationService() = NoLocationService;
  const factory AlarmListState.loaded(List<Alarm> alarmList) = Loaded;
  const factory AlarmListState.error(String errorMessage) = Error;
}