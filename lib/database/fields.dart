final String alarmsTable = 'alarms-table';

class AlarmFields {
  static final List<String> values = [
    alarmId,
    alarmName,
    alarmRadius,
    destLat,
    destLng,
    alarmStatus,
  ];

  static final String alarmId = '_id';
  static final String alarmName = 'alarmName';
  static final String alarmRadius = 'alarmRadius';
  static final String destLat = 'destLat';
  static final String destLng = 'destLng';
  static final String alarmStatus = 'alarmStatus';
}
