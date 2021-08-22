import 'package:location_alarm/database/fields.dart';

class Alarm {
  final int alarmId;
  final String alarmName;
  final int alarmRadius;
  final double destLat;
  final double destLng;
  final bool alarmStatus;

  Alarm({
    required this.alarmId,
    required this.alarmName,
    required this.alarmRadius,
    required this.destLat,
    required this.destLng,
    required this.alarmStatus,
  });

  Alarm copy({
    int? alarmId,
    String? alarmName,
    int? alarmRadius,
    double? destLat,
    double? destLng,
    bool? alarmStatus
  }) => Alarm(
    alarmId: alarmId ?? this.alarmId,
  alarmName: alarmName ?? this.alarmName,
  alarmRadius: alarmRadius ?? this.alarmRadius,
  destLat: destLat ?? this.destLat,
  destLng: destLng ?? this.destLng,
  alarmStatus: alarmStatus ?? this.alarmStatus,
  );

  static Alarm fromJson(Map<String, Object?> json) => Alarm(
    alarmId: json[AlarmFields.alarmId] as int,
    alarmName: json[AlarmFields.alarmName] as String,
    alarmRadius: json[AlarmFields.alarmRadius] as int, 
    destLat: json[AlarmFields.destLat] as double, 
    destLng: json[AlarmFields.destLng] as double, 
    alarmStatus: json[AlarmFields.alarmStatus] == 1, 
  );

  Map<String, Object?> toJson() => {
    AlarmFields.alarmId: alarmId,
    AlarmFields.alarmName: alarmName,
    AlarmFields.alarmRadius: alarmRadius,
    AlarmFields.destLat: destLat,
    AlarmFields.destLng: destLng,
    AlarmFields.alarmStatus: alarmStatus ? 1 : 0,
  };
}