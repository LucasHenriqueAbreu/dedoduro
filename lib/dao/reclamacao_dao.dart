import 'package:dedoduro/models/reclamacao.dart';
import 'package:dedoduro/shared/db/dao.dart';

class ReclamacaoDao implements Dao<Reclamacao> {
  final tableName = 'reclamacoes';
  final columnId = 'id';
  final _columnDescricao = 'descricao';
  final _columnTitulo = 'titulo';
  final _columnFoto = 'foto';
  final _columnLat = 'lat';
  final _columnLng = 'lng';

  @override
  Reclamacao fromMap(Map<String, dynamic> query) {
    Reclamacao reclamacao = Reclamacao();
    reclamacao.id = query[columnId];
    reclamacao.descricao = query[_columnDescricao];
    reclamacao.titulo = query[_columnTitulo];
    reclamacao.foto = query[_columnFoto];
    reclamacao.lat = query[_columnLat];
    reclamacao.lng = query[_columnLng];
    return reclamacao;
  }

  @override
  Map<String, dynamic> toMap(Reclamacao object) {
    return <String, dynamic>{
      columnId: object.id,
      _columnDescricao: object.descricao,
      _columnTitulo: object.titulo,
      _columnFoto: object.foto,
      _columnLat: object.lat,
      _columnLng: object.lng,
    };
  }

  @override
  List<Reclamacao> fromList(List<Map<String, dynamic>> query) {
    List<Reclamacao> reclamacoes = List<Reclamacao>();
    for (Map map in query) {
      reclamacoes.add(fromMap(map));
    }
    return reclamacoes;
  }
}
