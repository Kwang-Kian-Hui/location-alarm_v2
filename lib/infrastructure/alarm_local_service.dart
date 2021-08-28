import 'package:location_alarm/application/alarm.dart';
import 'package:location_alarm/database/database.dart';

class AlarmLocalService{
  final AlarmsDatabase _database;
  AlarmLocalService(this._database);
  

  Future<void> addProduct(Alarm newAlarm) async {
    final newAlarmDTO = newAlarm.toJson();
    await _database.addAlarm(newAlarmDTO);
  }
}