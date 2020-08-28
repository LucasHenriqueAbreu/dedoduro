import 'package:dedoduro/pages/map/map_view.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatelessWidget {
  final String title;

  const DashBoard({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(Object context) {
    return MapView();
  }
}
