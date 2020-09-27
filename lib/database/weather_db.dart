import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class WeatherDBProvider {
  WeatherDBProvider._();

  static final WeatherDBProvider db = WeatherDBProvider._();

  static Database _database;

  String dbName = "UsersWeather";
  String columnTime = 'time';
  String columnTemp = 'temperature';
  String columnDailyForecast = 'dailyForecast';
  String columHourlyForecast = 'hourlyForecast';

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "Users_weather.db";
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  //TODO complete creating db, google how to properly store maps and list as Uint8List<int>
  void _createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $dbName($columnTime TIMESTAMP PRIMARY, $columnTemp REAL)');
  }
}
