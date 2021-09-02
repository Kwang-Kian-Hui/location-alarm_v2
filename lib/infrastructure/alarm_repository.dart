import 'package:dartz/dartz.dart';
import 'package:location_alarm/application/alarm.dart';
import 'package:location_alarm/infrastructure/alarm_local_service.dart';
import 'package:location_alarm/infrastructure/custom_failures.dart';


class AlarmRepository {
  final AlarmLocalService _alarmLocalService;
  // final InternetConnectionChecker _internetConnectionChecker;

  AlarmRepository(
      this._alarmLocalService/*, this._internetConnectionChecker*/);

  Future<Either<CustomFailures, List<Alarm>>> getAlarmList() async {
    try{
      return right(await _alarmLocalService.getAlarmList());
    } on Exception catch (_) {
      return left(const CustomFailures.unknown());
    }
  }

  Future<Either<CustomFailures, void>> addAlarm(Alarm newAlarm) async {
    // if (!await _internetConnectionChecker.hasConnection) {
    //   return left(const CustomFailures.noConnection());
    // }
    try {
      await _alarmLocalService.addAlarm(newAlarm);
      return right(null);
    } on Exception catch (_) {
      return left(const CustomFailures.unknown());
    }
  }

  Future<Either<CustomFailures, void>> updateAlarm(Alarm alarm) async {
    // if (!await _internetConnectionChecker.hasConnection) {
    //   return left(const CustomFailures.noConnection());
    // }
    try {
      await _alarmLocalService.updateAlarm(alarm);
      return right(null);
    } on Exception catch (_) {
      return left(const CustomFailures.unknown());
    }
  }
}