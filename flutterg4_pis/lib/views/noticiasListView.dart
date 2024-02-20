import 'dart:developer';

import 'package:flutterg4_pis/controls/Conexion.dart';
import 'package:flutterg4_pis/controls/servicio_back/FacadeService.dart';
import 'package:flutterg4_pis/controls/utiles/Utiles.dart';
import 'package:flutterg4_pis/models/noticia.dart';
import 'package:flutter/material.dart';

class NoticiasListView extends StatefulWidget {
  const NoticiasListView({Key? key}) : super(key: key);

  @override
  _NoticiasListViewState createState() => _NoticiasListViewState();
}

Future<String?> _obtenerRol() async {
  Utiles util = Utiles();
  var rol = await util.getValue("rol");
  return rol;
}

class _NoticiasListViewState extends State<NoticiasListView> {
  Future<List<Noticia>> _listar() async {
    FacadeService servicio = FacadeService();

    try {
      var value = await servicio.listadoNoticiaTotal();

      if (value.code == 200) {
        return value.data;
      } else {
        if (value.code != 200) {
          Utiles util = Utiles();
          util.removeAllItem();
          Navigator.pushNamed(context, '/home');
        }
      }
    } catch (e) {
      log("Error al cargar noticias: $e");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      padding: const EdgeInsets.all(8),
      color: Colors.blueGrey[900], // Cambiar el color de fondo a un tono de gris oscuro
      child: FutureBuilder<List<Noticia>>(
        future: _listar(),
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return NoticiasCard(snapshot.data[index]);
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    ),
    bottomNavigationBar: Container(
      color: Colors.blueGrey[800], // Cambiar el color de fondo del botón de navegación inferior a un tono de gris más oscuro
      child: Row(
        children: <Widget>[
          const Text("PRINCIPAL: ", style: TextStyle(color: Colors.white)), // Cambiar el color del texto a blanco
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, "/principal");
            },
            child: const Text(
              "Regresar",
              style: TextStyle(fontSize: 20, color: Colors.white), // Cambiar el color del texto a blanco
            ),
          ),
        ],
      ),
    ),
  );
}

}

class NoticiasCard extends StatelessWidget {
  final Noticia noti;

  // Constructor con parámetro obligatorio
  const NoticiasCard(this.noti, {super.key});

  @override
  Widget build(BuildContext context) {
  return Card(
    elevation: 10,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Image.network(
            '${Conexion.URL_MEDIA}${noti.archivo}',
            width: 80, // Ancho de la imagen
            height: 80, // Alto de la imagen
            fit: BoxFit.cover, // Ajuste de la imagen para cubrir el espacio
          ),
          title: Text(
            'NOTICIA ${noti.tipo_noticia}: ${noti.titulo}',
            overflow: TextOverflow.ellipsis, // Evita desbordamiento del título
          ),
          subtitle: Text(
            'CUERPO: ${noti.cuerpo}',
            overflow: TextOverflow.ellipsis, // Evita desbordamiento del contenido
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alineación de los botones
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    "/comentarios/nuevo",
                    arguments: {
                      'external': {noti.id},
                      'titulo': {noti.titulo},
                      'tipo': {noti.tipo_noticia},
                      'cuerpo': {noti.cuerpo},
                      'archivo': {noti.archivo},
                    },
                  );
                },
                child: Text(
                  'NUEVO COMENTARIO',
                  style: TextStyle(fontSize: 14), // Tamaño de fuente del botón
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    "/comentarios/nuevo",
                    arguments: {
                      'external': {noti.id},
                      'titulo': {noti.titulo},
                      'tipo': {noti.tipo_noticia},
                      'cuerpo': {noti.cuerpo},
                      'archivo': {noti.archivo},
                    },
                  );
                },
                child: Text(
                  'COMENTARIOS',
                  style: TextStyle(fontSize: 14), // Tamaño de fuente del botón
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    "/maps/noticias",
                    arguments: {
                      'external': {noti.id},
                    },
                  );
                },
                child: Text(
                  'MAPA',
                  style: TextStyle(fontSize: 14), // Tamaño de fuente del botón
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

}