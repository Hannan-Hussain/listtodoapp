import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        task TEXT NOT NULL,
        time TEXT NOT NULL
      )
    ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('todos', row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    final db = await instance.database;
    return await db.query('todos');
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}
