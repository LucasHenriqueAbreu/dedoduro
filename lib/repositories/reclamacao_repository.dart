import 'package:dedoduro/dao/reclamacao_dao.dart';
import 'package:dedoduro/shared/db/database_helper.dart';

import 'package:dedoduro/models/reclamacao.dart';

import 'reclamacao_repository_interface.dart';

class ReclamacaoRepository implements IReclamacaoRepository {
  final dao = ReclamacaoDao();

  @override
  DatabaseHelper databaseHelper;

  ReclamacaoRepository(this.databaseHelper);

  @override
  Future<Reclamacao> insert(Reclamacao reclamacao) async {
    final db = await databaseHelper.database;
    reclamacao.id = await db.insert(dao.tableName, dao.toMap(reclamacao));
    return reclamacao;
  }

  @override
  Future<Reclamacao> delete(Reclamacao reclamacao) async {
    final db = await databaseHelper.database;
    await db.delete(dao.tableName,
        where: dao.columnId + " = ?", whereArgs: [reclamacao.id]);
    return reclamacao;
  }

  @override
  Future<Reclamacao> update(Reclamacao reclamacao) async {
    final db = await databaseHelper.database;
    await db.update(dao.tableName, dao.toMap(reclamacao),
        where: dao.columnId + " = ?", whereArgs: [reclamacao.id]);
    return reclamacao;
  }

  @override
  Future<List<Reclamacao>> getAll() async {
    final db = await databaseHelper.database;
    List<Map> maps = await db.query(dao.tableName);
    return dao.fromList(maps);
  }
}
