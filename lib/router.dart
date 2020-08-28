import 'package:dedoduro/pages/dedo_duro.dart';
import 'package:dedoduro/pages/reclamacoes/cadastro/cadastro.dart';
import 'package:dedoduro/pages/reclamacoes/detalhes/detalhes.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRouter(RouteSettings settings) {
    final argumentos = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => DedoDuro());
      case '/reclamacao/cadastro':
        return MaterialPageRoute(builder: (_) => Cadastro());
      case '/reclamacao/detalhes':
        return MaterialPageRoute(
          builder: (_) => Detalhes(
            reclamacao: argumentos,
          ),
        );
    }
  }
}
