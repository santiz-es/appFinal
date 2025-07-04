
import 'package:appfinal/DatabaseHelper.dart';
import 'package:appfinal/Medicamento.dart';
import 'package:sqflite/sqflite.dart';

class MedicamentoDao {
  final Databasehelper _dbHelper = Databasehelper();

  //incluir no banco
  Future<void> incluirMedicamento(Medicamento m) async {
    final db = await _dbHelper.database;
    await db.insert(
      "medicamento",
      m.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Editar no banco
  Future<void> editarMedicamento(Medicamento m) async {
    final db = await _dbHelper.database;
    await db.update(
      "medicamento",
      m.toMap(), 
      where: "id = ?", 
      whereArgs: [m.id]);
  }

  //Excluir
  Future<void> deleteMedicamento(int index) async {
    final db = await _dbHelper.database;
    await db.delete(
      "medicamento", 
      where: "id = ?", 
      whereArgs: [index]);
  }

  //Listar
  Future<List<Medicamento>> listarMedicamento() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query("medicamento");
    return List.generate(maps.length, (index){
      return Medicamento.fromMap(maps[index]);
    });
  }

  // retorna lista de farmacias para o medicamento de id = medicamentoId
  Future<List<Map<String, dynamic>>> listarFarmaciasDoMedicamento(int medicamentoId) async {
  final db = await _dbHelper.database;
  return db.rawQuery('''
    SELECT f.id, f.nome AS farmacia, f.cidade
    FROM relacion r
    INNER JOIN farmacia f ON r.id_farmacia = f.id
    WHERE r.id_medicamento = ?
  ''', [medicamentoId]);
}
}
