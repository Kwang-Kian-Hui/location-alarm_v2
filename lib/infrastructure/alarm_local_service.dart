import 'package:location_alarm/application/alarm.dart';
import 'package:location_alarm/database/database.dart';

class AlarmLocalService{
  final AlarmsDatabase _database;
  AlarmLocalService(this._database);
  
  Future<List<Alarm>> getAlarmList() async{
    final alarmList = await _database.getAlarmsList();

    return alarmList.map((json) => Alarm.fromJson(json)).toList();
  }

  Future<void> addAlarm(Alarm newAlarm) async {
    final newAlarmDTO = newAlarm.toJson();
    await _database.addAlarm(newAlarmDTO);
  }

  Future<void> updateAlarm(Alarm alarm) async {
    final alarmDTO = alarm.toJson();
    await _database.updateAlarm(alarmDTO, alarm.alarmId);
  }
}