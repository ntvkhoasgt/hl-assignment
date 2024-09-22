import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('jokes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const boolType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE responses (
  id $idType,
  text $textType,
  isFunny $boolType
)
''');
  }

  Future<void> createResponse(String text, bool isFunny) async {
    final db = await instance.database;
    final json = {'text': text, 'isFunny': isFunny ? 1 : 0};

    await db.insert('responses', json);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
