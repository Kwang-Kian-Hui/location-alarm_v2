import 'package:location_alarm/application/alarm.dart';
import 'package:location_alarm/database/database.dart';

class AlarmLocalService{
  final AlarmsDatabase _database;
  AlarmLocalService(this._database);
  

  Future<void> addAlarm(Alarm newAlarm) async {
    final newAlarmDTO = newAlarm.toJson();
    print('alarm to DTO');
    await _database.addAlarm(newAlarmDTO);
  }
}