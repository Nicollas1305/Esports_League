import 'package:esports_league/data/dummy_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper.namedConstructor();
  static Database? _database;

  DatabaseHelper.namedConstructor();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, 'campeonatos.db');

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE campeonatos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        quantidadeJogadores INTEGER,
        times TEXT
      )
    ''');
  }

  Future<int> createCampeonato(
      int quantidadeJogadores, String? liga, String? times) async {
    final db = await instance.database;
    final campeonato = {
      'quantidadeJogadores': quantidadeJogadores,
      'liga': liga,
      'times': times,
    };
    return await db.insert('campeonatos', campeonato);
  }

  Future<List<Map<String, dynamic>>> getCampeonatos() async {
    final db = await instance.database;
    return await db.query('campeonatos');
  }
}
