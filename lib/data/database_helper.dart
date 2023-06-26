import 'package:esports_league/model/Championship.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  late Database _database;

  DatabaseHelper._privateConstructor();

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

    // Imprimir informações sobre o banco de dados
    List<Map<String, dynamic>> tables =
        await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    print("Lista de tabelas no banco de dados:");
    tables.forEach((table) {
      print(table['name']);
    });
    print(getDatabasesPath());
  }

  Future<int> createChampionship(String name, String date, List<String> teams,
      List<String> players) async {
    Database? db = await instance.database;
    if (db != null) {
      Map<String, dynamic> row = {
        'name': name,
        'date': date,
        'teams': teams.join(','),
        'players': players.join(','),
      };
      return await db.insert('championships', row);
    } else {
      throw Exception("Database is null");
    }
  }

  Future<List<Championship>> readChampionships() async {
    Database? db = await instance.database;
    if (db == null) {
      throw Exception('Database is not initialized');
    }
    List<Map<String, dynamic>> results = await db.query('championships');
    return results.map((row) => Championship.fromJson(row)).toList();
  }

  Future<int> updateChampionship(Championship championship) async {
    Database? db = await instance.database;
    if (db == null) {
      throw Exception('Database is not initialized');
    }
    Map<String, dynamic> row = championship.toJson();
    return await db.update(
      'championships',
      row,
      where: 'id = ?',
      whereArgs: [championship.id],
    );
  }

  Future<int> deleteChampionship(int id) async {
    Database? db = await instance.database;
    if (db == null) {
      throw Exception('Database is not initialized');
    }
    return await db.delete(
      'championships',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
