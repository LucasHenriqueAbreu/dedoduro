import 'dart:io';

import 'package:dedoduro/models/reclamacao.dart';
import 'package:dedoduro/repositories/reclamacao_repository.dart';
import 'package:dedoduro/repositories/reclamacao_repository_interface.dart';
import 'package:dedoduro/shared/db/database_helper.dart';
import 'package:flutter/material.dart';

class Reclamacoes extends StatefulWidget {
  final String title;

  const Reclamacoes({Key key, @required this.title}) : super(key: key);

  @override
  _ReclamacoesState createState() => _ReclamacoesState();
}

class _ReclamacoesState extends State<Reclamacoes> {
  IReclamacaoRepository reclamacaoRepository =
      ReclamacaoRepository(DatabaseHelper());
  Future<List<Reclamacao>> reclamacoes;

  @override
  void initState() {
    reclamacoes = _loadReclamacoes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _createFutureBuilder(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openPageCadastro,
        child: Icon(Icons.add),
      ),
    );
  }

  Future<List<Reclamacao>> _loadReclamacoes() async {
    return await reclamacaoRepository.getAll();
  }

  FutureBuilder _createFutureBuilder() {
    return FutureBuilder<List<Reclamacao>>(
      future: reclamacoes,
      builder: _builder,
    );
  }

  Widget _createList(List<Reclamacao> reclamacoes) {
    return ListView.builder(
      itemCount: reclamacoes.length,
      itemBuilder: (context, index) => _createItemList(reclamacoes[index]),
    );
  }

  _createItemList(Reclamacao reclamacao) {
    return ListTile(
      leading: reclamacao.foto != null
          ? Hero(
              tag: reclamacao.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.file(File(reclamacao.foto)),
              ),
            )
          : null,
      title: Text(reclamacao.titulo),
      subtitle: Text(reclamacao.descricao),
      onTap: () => Navigator.pushNamed(context, '/reclamacao/detalhes',
          arguments: reclamacao),
    );
  }

  Widget _builder(
      BuildContext context, AsyncSnapshot<List<Reclamacao>> snapshot) {
    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
      if (snapshot.hasData && snapshot.data.length > 0) {
        return _createList(snapshot.data);
      } else {
        return Center(
          child: Text('Sem dados'),
        );
      }
    } else if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: Text('Nada foi encontrado'),
      );
    }
  }

  void _openPageCadastro() async {
    await Navigator.pushNamed(context, '/reclamacao/cadastro');
    setState(() {
      reclamacoes = _loadReclamacoes();
    });
  }
}
