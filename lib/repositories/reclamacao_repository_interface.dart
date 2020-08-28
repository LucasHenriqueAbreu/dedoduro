import 'package:dedoduro/models/reclamacao.dart';
import 'package:dedoduro/shared/db/database_helper.dart';

abstract class IReclamacaoRepository {
  DatabaseHelper databaseHelper;

  Future<Reclamacao> insert(Reclamacao reclamacao);

  Future<Reclamacao> update(Reclamacao reclamacao);

  Future<Reclamacao> delete(Reclamacao reclamacao);

  Future<List<Reclamacao>> getAll();
}
