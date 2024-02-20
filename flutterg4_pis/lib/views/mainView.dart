import 'package:flutter/material.dart';
import 'package:flutterg4_pis/controls/utiles/Utiles.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

Future<String?> _obtenerRol() async {
  Utiles util = Utiles();
  var rol = await util.getValue("rol");
  return rol;
}

class _MainViewState extends State<MainView> {
  final _formKey = GlobalKey<FormState>();

  void _salir() {
    Utiles util = Utiles();
    util.removeAllItem();

    Navigator.pushNamed(context, "/home");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.blueGrey[200],
        body: ListView(
          padding: const EdgeInsets.all(32),
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(40),
              child: const Text(
                "PRINCICPAL (NOTICIAS)",
                style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "SISTEMA PARA QUE USUARIOS COMENTEN EN NOTICIAS Y PUEDAN SABER SU GEOLOCALIZACIÒN",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            ),
            FutureBuilder<String?>(
              future: _obtenerRol(),
              builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data == "admin") {
                    return Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: const Text("MAPAS"),
                        onPressed: () {
                          Navigator.pushNamed(context, "/maps");
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            ),
            FutureBuilder<String?>(
              future: _obtenerRol(),
              builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data == "usuario") {
                    return Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: const Text("NOTICIAS"),
                        onPressed: () {
                          Navigator.pushNamed(context, "/noticias");
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            ),
                   FutureBuilder<String?>(
              future: _obtenerRol(),
              builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data == "usuario") {
                    return Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: const Text("EDITAR USER", style: TextStyle(fontSize: 18, color: Colors.tealAccent),),
                        onPressed: () {
                          Navigator.pushNamed(context, "/usuarioConf");
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text("CERRAR SESION", style: TextStyle(fontSize: 18, color: Colors.cyan),),
                onPressed: () => (_salir()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}