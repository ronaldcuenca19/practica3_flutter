import 'dart:developer';
import 'package:flutterg4_pis/controls/Conexion.dart';
import 'package:flutterg4_pis/models/comentario.dart';
import 'package:flutter/material.dart';
import 'package:flutterg4_pis/controls/servicio_back/FacadeService.dart';
import 'package:flutterg4_pis/controls/utiles/Utiles.dart';
import 'package:geolocator/geolocator.dart';

class ComentarioView extends StatefulWidget {
  const ComentarioView({Key? key}) : super(key: key);

  @override
  _ComentarioViewState createState() => _ComentarioViewState();
}

class _ComentarioViewState extends State<ComentarioView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController textoC = TextEditingController();
  double latitud = 0.0;
  double longitud = 0.0;

  Future<Position> _getLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          final snackBar = SnackBar(
            content: Text('Active los permisos de ubicación primero'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return Future.error('error');
        }
      }
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error al obtener la posición: $e');
      return Future.error(e.toString());
    }
  }

  void getCurrentLocation(param) async {
    Position posicion;

    try {
      posicion = await _getLocation();
      print(posicion);

      latitud = posicion.latitude;
      longitud = posicion.longitude;

      _register(param);
    } catch (e) {
      print('POSICIONAMIENTO ERRROR: $e');
    }
  }

  Future<void> _register(param) async {
    // Tu lógica de registro aquí
  }

  String? _getValue(param) {
    String paramString = param.toString();
    String noticiaValue = paramString.substring(1, paramString.length - 1);
    return noticiaValue;
  }

  Future<List<String>> _list(param) async {
    // Tu lógica de listado aquí
    return [];
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? parametro =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    String? external = _getValue(parametro?['external']);
    String? titulo = _getValue(parametro?['titulo']);
    String? tipo = _getValue(parametro?['tipo']);
    String? cuerpo = _getValue(parametro?['cuerpo']);
    String? archivo = _getValue(parametro?['archivo']);

    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.blueGrey[200],
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FutureBuilder<String?>(
                future: _obtainRole(),
                builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData && snapshot.data == "usuario") {
                      return Column(
                        children: [
                          MyCard(archivo!, titulo!, cuerpo!, tipo!),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: textoC,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "INGRESE UN COMENTARIO";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'COMENTARIO:',
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: ElevatedButton(
                              child: const Text("Registrar"),
                              onPressed: () async {
                                getCurrentLocation(external!);
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: FutureBuilder<List<String>>(
                    future: _list(external!),
                    initialData: const [],
                    builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        List<String> comments = snapshot.data ?? [];
                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: comments.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CommentList(comments[index]);
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Row(
          children: <Widget>[
            const Text("Principal: "),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/noticias");
              },
              child: const Text(
                "VOLVER",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _obtainRole() async {
    // Lógica para obtener el rol
    return null;
  }
}

class MyCard extends StatelessWidget {
  final String archivo;
  final String titulo;
  final String cuerpo;
  final String tipo;

  const MyCard(this.archivo, this.titulo, this.cuerpo, this.tipo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Card(
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Image.network(
                  '${Conexion.URL_MEDIA}$archivo',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  'NOTICIA $tipo: $titulo',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'CUERPO: $cuerpo',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentList extends StatelessWidget {
  final String comment;

  const CommentList(this.comment, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.green[900], // Cambio de color a verde oscuro
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ListTile(
        title: Text("Comentario: $comment"),
      ),
    );
  }
}
