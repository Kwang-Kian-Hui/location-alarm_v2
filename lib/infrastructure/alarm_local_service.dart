import 'package:location_alarm/application/alarm.dart';
import 'package:location_alarm/database/database.dart';

class AlarmLocalService{
  final AlarmsDatabase _database;
  AlarmLocalService(this._database);
  
  Future<List<Alarm>> getAlarmList() async{
    final alarmList = await _database.getAlarmList();

    return alarmList.map((json) => Alarm.fromJson(json)).toList();
  }

  Future<List<Alarm>> getAlarmListWhereAlarmIsOn() async{
    final alarmList = await _database.getAlarmListWhereAlarmIsOn();

    return alarmList.map((json) => Alarm.fromJson(json)).toList();
  }

  Future<void> addAlarm(Alarm newAlarm) async {
    final newAlarmDTO = newAlarm.toJson();
    await _database.addAlarm(newAlarmDTO);
  }

  Future<void> updateAlarm(Alarm updatedAlarm) async {
    final alarmDTO = updatedAlarm.toJson();
    await _database.updateAlarm(alarmDTO, updatedAlarm.alarmId);
  }

  Future<void> deleteAlarm(int alarmId) async {
    await _database.deleteAlarm(alarmId);
  }
}