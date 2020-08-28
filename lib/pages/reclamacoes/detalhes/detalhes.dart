import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dedoduro/models/reclamacao.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Detalhes extends StatefulWidget {
  final Reclamacao reclamacao;
  const Detalhes({Key key, this.reclamacao}) : super(key: key);

  @override
  _DetalhesState createState() => _DetalhesState();
}

class _DetalhesState extends State<Detalhes> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  @override
  void initState() {
    _alterarMarkerMap(double.parse(widget.reclamacao.lat),
        double.parse(widget.reclamacao.lng));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reclamacao.titulo),
      ),
      body: Stack(
        children: [_buildMap(), _buildContainer()],
      ),
    );
  }

  GoogleMap _buildMap() {
    return GoogleMap(
      mapType: MapType.hybrid,
      initialCameraPosition: CameraPosition(
        target: LatLng(double.parse(widget.reclamacao.lat),
            double.parse(widget.reclamacao.lng)),
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
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5.0, left: 5.0, right: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: widget.reclamacao.id,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(File(widget.reclamacao.foto)),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.error),
                        title: Text(widget.reclamacao.titulo),
                        subtitle: Text(widget.reclamacao.descricao),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _alterarMarkerMap(double latitude, double longitude) {
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
        title: 'Localização da reclamação',
        snippet: '',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      ),
    );

    _markers = <MarkerId, Marker>{};
    _markers[markerId] = marker;
  }
}
