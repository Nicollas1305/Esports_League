import 'package:esports_league/model/Championship.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:esports_league/model/Championship.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  late Database _database;

  DatabaseHelper._privateConstructor() {
    _initDatabase();
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'esports_league.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS championships (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        date TEXT,
        teams TEXT
      )
    ''');
  }

  Future<int> createChampionship(
      String name, String date, List<String> teams) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {
      'name': name,
      'date': date,
      'teams': teams
          .join(','), // Convert the list of teams to a comma-separated string
    };
    return await db.insert('championships', row);
  }

  Future<List<Championship>> readChampionships() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query('championships');
    return results.map((row) => Championship.fromJson(row)).toList();
  }

  Future<int> updateChampionship(Championship championship) async {
    Database db = await instance.database;
    Map<String, dynamic> row = championship.toJson();
    return await db.update(
      'championships',
      row,
      where: 'id = ?',
      whereArgs: [championship.id],
    );
  }

  Future<int> deleteChampionship(int id) async {
    Database db = await instance.database;
    return await db.delete(
      'championships',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
