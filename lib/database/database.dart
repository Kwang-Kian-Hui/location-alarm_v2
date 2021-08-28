import 'dart:async';
import 'package:location_alarm/application/alarm.dart';
import 'package:location_alarm/database/fields.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AlarmsDatabase {
  static final AlarmsDatabase instance = AlarmsDatabase._init();
  static Database? _database;
  AlarmsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initialiseDatabase('loc_alarm.db');
    return _database!;
  }

  Future<Database> _initialiseDatabase(String fileName) async {
    final path = join(await getDatabasesPath(), fileName);
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future _createDatabase(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final intType = 'INTEGER NOT NULL';
    final latlngType = 'REAL NOT NULL';
    final textType = 'TEXT NOT NULL';
    await db.execute('''
          CREATE TABLE $alarmsTable(
            ${AlarmFields.alarmId} $idType, 
            ${AlarmFields.alarmName} $textType,
            ${AlarmFields.alarmRadius} $intType, 
            ${AlarmFields.destLat} $latlngType, 
            ${AlarmFields.destLng} $latlngType, 
            ${AlarmFields.alarmStatus} $intType
            )
          ''');
  }

  Future<void> addAlarm(Map<String, Object?> alarmDTO) async {
    print('add alarm in db now');
    final db = await instance.database;
    print('got the db');

    final id = await db.insert(alarmsTable, alarmDTO, conflictAlgorithm: ConflictAlgorithm.ignore);
    //use rawInsert for custom insert

    print('$id of the alarm');
    print('alarm inserted to db');
    final alarmList = await getAlarmsList();

    print('length: ${alarmList.length}');
    print(alarmList);
  }

  Future<Alarm> getAlarm(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      alarmsTable,
      columns: AlarmFields.values,
      where: '${AlarmFields.alarmId} = ?',
      whereArgs: [id], //prevent sql injection
    );

    if (maps.isNotEmpty) {
      return Alarm.fromJson(maps.first);
    }
    throw Exception('ID $id not found');
  }

  Future<List<Alarm>> getAlarmsList() async {
    final db = await instance.database;

    final orderBy = '${AlarmFields.alarmId}';
  
    final result = await db.query(alarmsTable, orderBy: orderBy);
    //use rawQuery for custom search

    return result.map((json) => Alarm.fromJson(json)).toList();
  }

  Future<int> update(Alarm alarm) async {
    final db = await instance.database;

    return db.update(alarmsTable, alarm.toJson(),
        where: '${AlarmFields.alarmId} = ?', whereArgs: [alarm.alarmId]);
    //use rawUpdate for custom update
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return db.delete(alarmsTable,
        where: '${AlarmFields.alarmId} = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
