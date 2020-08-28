import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dedoduro/models/reclamacao.dart';
import 'package:dedoduro/pages/reclamacoes/reclamacoes.dart';
import 'package:dedoduro/repositories/reclamacao_repository.dart';
import 'package:dedoduro/repositories/reclamacao_repository_interface.dart';
import 'package:dedoduro/shared/db/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  const MapView({Key key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  IReclamacaoRepository reclamacaoRepository =
      ReclamacaoRepository(DatabaseHelper());
  List<Reclamacao> reclamacoes = [];

  @override
  void initState() {
    _loadReclamacoes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [_buildMap(), _buildContainer()],
    );
  }

  Future<void> _loadReclamacoes() async {
    var reclamacoesAux = await reclamacaoRepository.getAll();
    setState(() {
      reclamacoes = reclamacoesAux;
    });
    _gotoLocation(
      double.parse(reclamacoes[0].lat),
      double.parse(reclamacoes[0].lng),
    );
    for (var i = 0; i < reclamacoes.length; i++) {
      final reclamacao = reclamacoes[i];
      _createMarkers(
        double.parse(reclamacao.lat),
        double.parse(reclamacao.lng),
        reclamacao.titulo,
        reclamacao.descricao,
      );
    }
  }

  GoogleMap _buildMap() {
    return GoogleMap(
      mapType: MapType.hybrid,
      initialCameraPosition: CameraPosition(
        target: LatLng(37.42796133580664, -122.085749655962),
        zoom: 15.0,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: Set<Marker>.of(_markers.values),
    );
  }

  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 150.0,
        child: ListView.builder(
          itemCount: reclamacoes.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final reclamacao = reclamacoes[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(reclamacao),
            );
          },
        ),
      ),
    );
  }

  Widget _boxes(Reclamacao reclamacao) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(
          double.parse(reclamacao.lat),
          double.parse(reclamacao.lng),
        );
      },
      child: Container(
        child: new FittedBox(
          child: Material(
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Color(0x802196F3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 180,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(24.0),
                      child: Image.file(File(reclamacao.foto)),
                    ),
                  ),
                  Column(
                    children: [
                      Text(reclamacao.titulo),
                      Text(reclamacao.descricao),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }

  void _createMarkers(
      double latitude, double longitude, String title, String snippet) {
    var markerIdVal = Random().nextInt(1000);
    final MarkerId markerId = MarkerId('marker_id$markerIdVal');

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        latitude,
        longitude,
      ),
      infoWindow: InfoWindow(
        title: title,
        snippet: snippet,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      ),
    );
    setState(() {
      _markers[markerId] = marker;
    });
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }
}
