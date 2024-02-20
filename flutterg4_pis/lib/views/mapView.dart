import 'dart:developer';

import 'package:flutterg4_pis/controls/servicio_back/FacadeService.dart';
import 'package:flutterg4_pis/models/comentario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  static const TOKEN_MAPBOX =
      'pk.eyJ1IjoibHVpczE2OSIsImEiOiJjbHMyOWl2dW0wOWcwMnFuejFxc29wMG5iIn0.cxAolwZYn7HqhWoPFZK2mw';

  MapOptions _createMapOptions() {
    return MapOptions(
      center: LatLng(-3.9834385, -79.2159910),
      minZoom: 2,
      maxZoom: 20,
      zoom: 12,
    );
  }

  Future<List<Comentario>> _listar() async {
    FacadeService servicio = FacadeService();

    try {
      var value = await servicio.comentarioLista();
      if (value.code == 200) {
        return value.data;
      } else {
        if (value.code != 200) {
          Navigator.pushNamed(context, '/principal');
        }
      }
    } catch (e) {
      log("No se pudo cargar los comentarios: $e");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: const Text('MAPA'),
      backgroundColor: Colors.blueAccent,
    ),
    body: FutureBuilder<List<Comentario>>(
      future: _listar(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Comentario> comentarios = snapshot.data ?? [];
          return FlutterMap(
            options: _createMapOptions(),
            nonRotatedChildren: [
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                additionalOptions: const {
                  'accessToken': TOKEN_MAPBOX,
                  'id': 'mapbox/streets-v12'
                },
              ),
              MarkerLayer(
                markers: _crearMarcadores(comentarios),
              ),
            ],
          );
        }
      },
    ),
  );
}
}

List<Color> colores = [
  Colors.blueAccent,
  Colors.red,
  Colors.green,
  const Color.fromARGB(255, 134, 54, 17),
  Colors.white,
  const Color.fromARGB(255, 244, 54, 212),
  const Color.fromARGB(255, 136, 255, 0),
  const Color.fromARGB(255, 0, 0, 0),
  const Color.fromARGB(255, 54, 231, 244),
  const Color.fromARGB(183, 244, 54, 219),
  const Color.fromARGB(255, 244, 155, 54)
];
List<Marker> _crearMarcadores(List<Comentario> comentarios) {
  return comentarios.map((comentario) {
    int index = comentarios.indexOf(comentario);
    return Marker(
      point: LatLng(
        double.parse(comentario.latitud),
        double.parse(comentario.longitud),
      ),
      builder: (context) {
        return IconButton(
          icon: Icon(
            Icons.person_pin,
            color: colores[index % colores.length],
            size: 40,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(comentario.cliente),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("SALIR"),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }).toList();
}
