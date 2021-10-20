import 'package:dartz/dartz.dart';
import 'package:location_alarm/infrastructure/models/alarm.dart';
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

  Future<Either<CustomFailures, List<Alarm>>> getAlarmListWhereAlarmIsOn() async {
    try{
      return right(await _alarmLocalService.getAlarmListWhereAlarmIsOn());
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

  Future<Either<CustomFailures, void>> updateAlarm(Alarm updatedAlarm) async {
    // if (!await _internetConnectionChecker.hasConnection) {
    //   return left(const CustomFailures.noConnection());
    // }
    try {
      await _alarmLocalService.updateAlarm(updatedAlarm);
      return right(null);
    } on Exception catch (_) {
      return left(const CustomFailures.unknown());
    }
  }

  Future<Either<CustomFailures, void>> deleteAlarm(int alarmId) async {
    // if (!await _internetConnectionChecker.hasConnection) {
    //   return left(const CustomFailures.noConnection());
    // }
    try {
      await _alarmLocalService.deleteAlarm(alarmId);
      return right(null);
    } on Exception catch (_) {
      return left(const CustomFailures.unknown());
    }
  }
}