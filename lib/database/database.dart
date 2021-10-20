import 'dart:async';
import 'package:location_alarm/infrastructure/models/alarm.dart';
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
    final db = await instance.database;

    // ignore: unused_local_variable
    final id = await db.insert(alarmsTable, alarmDTO, conflictAlgorithm: ConflictAlgorithm.ignore);
    //use rawInsert for custom insert
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

  Future<List<Map<String, Object?>>> getAlarmList() async {
    final db = await instance.database;

    final orderBy = '${AlarmFields.alarmId}';
  
    final result = await db.query(alarmsTable, orderBy: orderBy);
    //use rawQuery for custom search

    return result;
  }

  Future<List<Map<String, Object?>>> getAlarmListWhereAlarmIsOn() async {
    final db = await instance.database;

    String whereString = '${AlarmFields.alarmStatus} = ?';
    List<dynamic> whereArguments = [1];
    final orderBy = '${AlarmFields.alarmId}';
  
    final result = await db.query(alarmsTable, orderBy: orderBy, where: whereString, whereArgs: whereArguments);
    //use rawQuery for custom search

    return result;
  }

  Future<int> updateAlarm(Map<String, Object?> alarmDTO, int? alarmId) async {
    final db = await instance.database;
    return db.update(alarmsTable, alarmDTO,
        where: '${AlarmFields.alarmId} = ?', whereArgs: [alarmId]);
    //use rawUpdate for custom update
  }

  Future<int> deleteAlarm(int id) async {
    final db = await instance.database;

    return db.delete(alarmsTable,
        where: '${AlarmFields.alarmId} = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
