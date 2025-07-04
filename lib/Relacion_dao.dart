import 'package:appfinal/Relacion.dart';
import 'package:appfinal/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class RelacionDao {
  final Databasehelper _dbHelper = Databasehelper();

  Future<List<Relacion>> listarRelacion() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query("relacion");
    return List.generate(maps.length, (index) {
      return Relacion.fromMap(maps[index]);
    });
  }

  Future<void> incluirRelacion(Relacion relacion) async {
    final db = await _dbHelper.database;
    await db.insert(
      "relacion",
      relacion.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteRelacion(int medicamentoId, int farmaciaId) async {
    final db = await _dbHelper.database;
    await db.delete(
      "relacion",
      where: "id_medicamento = ? AND id_farmacia = ?",
      whereArgs: [medicamentoId, farmaciaId],
    );
  }
}
