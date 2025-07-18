import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import './protein.dart'; // Import your model

class ProteinDatabase {
  static final ProteinDatabase instance = ProteinDatabase._init();
  static Database? _database;

  ProteinDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('proteins.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE proteins (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        link TEXT NOT NULL
      )
    ''');
  }

  Future<int> create(Protein protein) async {
    final db = await instance.database;
    return await db.insert('proteins', protein.toMap());
  }

  Future<List<Protein>> readAllProteins() async {
    final db = await instance.database;
    final result = await db.query('proteins');
    return result.map((map) => Protein.fromMap(map)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
