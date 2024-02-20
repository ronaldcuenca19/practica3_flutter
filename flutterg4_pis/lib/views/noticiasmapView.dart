import 'dart:developer';

import 'package:flutterg4_pis/controls/servicio_back/FacadeService.dart';
import 'package:flutterg4_pis/models/comentario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class NoticiasMapView extends StatefulWidget {
  const NoticiasMapView({Key? key}) : super(key: key);

  @override
  _NoticiasMapViewState createState() => _NoticiasMapViewState();
}

class _NoticiasMapViewState extends State<NoticiasMapView> {
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

  Future<List<Comentario>> _listar(param) async {
    FacadeService servicio = FacadeService();

    try {
      var value = await servicio.listadoComentarioTotal(param);
      if (value.code == 200) {
        return value.data;
      } else {
        if (value.code != 200) {
          Navigator.pushNamed(context, '/principal');
        }
      }
    } catch (e) {
      log("Error al cargar comentarios: $e");
    }
    return [];
  }

  String? _valorObj(param) {
    String paramString = param.toString();
    String noticiaValue = paramString.substring(1, paramString.length - 1);
    return noticiaValue;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? parametro =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    String? external = _valorObj(parametro?['external'].toString());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mapa'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FlutterMap(
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
          FutureBuilder(
            future: _listar(external),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return MarkerLayer(
                  markers: _markerPosition(snapshot.data),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}

List<Color> colores = [
  Colors.blueGrey[800]!, // Azul oscuro
  Colors.redAccent, // Rojo
  Colors.green, // Verde
  Colors.amber, // Ámbar
  Colors.deepPurple, // Púrpura
  Colors.teal, // Verde azulado
];

List<Marker> _markerPosition(List<Comentario> comentarios) {
  return comentarios.asMap().entries.map((entry) {
    int index = entry.key;
    Comentario coment = entry.value;

    return Marker(
      point: LatLng(
        double.parse(coment.latitud),
        double.parse(coment.longitud),
      ),
      builder: (context) {
        return Container(
          child: ListTile(
            leading: Icon(
              Icons.person_pin,
              color: colores[index % colores.length],
              size: 40,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    icon: Icon(
                      Icons.person_pin,
                      color: colores[index % colores.length],
                      size: 40,
                    ),
                    content: Text(
                      coment.cliente,
                      style: TextStyle(fontSize: 18), // Tamaño de fuente modificado
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("SALIR", style: TextStyle(fontSize: 16)), // Tamaño de fuente modificado
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }).toList();
}
