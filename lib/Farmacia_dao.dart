
import 'package:appfinal/DatabaseHelper.dart';
import 'package:appfinal/Farmacia.dart';
import 'package:sqflite/sqflite.dart';

class FarmaciaDao {
  final Databasehelper _dbHelper = Databasehelper();

  //incluir no banco
  Future<void> incluirFarmacia(Farmacia f) async {
    final db = await _dbHelper.database;
    await db.insert(
      "farmacia",
      f.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Editar no banco
  Future<void> editarFarmacia(Farmacia f) async {
    final db = await _dbHelper.database;
    await db.update(
      "farmacia",
      f.toMap(), 
      where: "id = ?", 
      whereArgs: [f.id]);
  }

  //Excluir
  Future<void> deleteFarmacia(int index) async {
    final db = await _dbHelper.database;
    await db.delete(
      "farmacia", 
      where: "id = ?", 
      whereArgs: [index]);
  }

  //Listar
  Future<List<Farmacia>> listarFarmacia() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query("farmacia");
    return List.generate(maps.length, (index){
      return Farmacia.fromMap(maps[index]);
    });
  }

  Future<List<Farmacia>> listarFarmaciasObjDoMedicamento(int medicamentoId) async {
  final db = await _dbHelper.database;
  final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT f.id, f.nome, f.cidade
    FROM relacion r
    INNER JOIN farmacia f ON r.id_farmacia = f.id
    WHERE r.id_medicamento = ?
  ''', [medicamentoId]);

  return result.map((map) => Farmacia.fromMap(map)).toList();
}
}
