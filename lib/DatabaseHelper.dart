import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Databasehelper {
  static final Databasehelper _instance = Databasehelper._internal();
  static Database? _database;
  factory Databasehelper() {
    return _instance;
  }
  Databasehelper._internal();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    return openDatabase(join(dbPath, 'if.db'), version: 1, onCreate: _onCreate);
  }

 
  Future _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE IF NOT EXISTS medicamento(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, codigo TEXT)",
    );
    
    await db.execute(
      "CREATE TABLE IF NOT EXISTS farmacia(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, cidade TEXT)",
    );
 
    await db.execute(
    "CREATE TABLE IF NOT EXISTS relacion (id_medicamento INTEGER, id_farmacia INTEGER, PRIMARY KEY (id_medicamento, id_farmacia), FOREIGN KEY (id_medicamento) REFERENCES medicamento(id), FOREIGN KEY (id_farmacia) REFERENCES farmacia(id))",
  );


  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
