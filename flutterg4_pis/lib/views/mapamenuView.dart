import 'package:flutter/material.dart';
import 'package:flutterg4_pis/controls/utiles/Utiles.dart';

class MapaMenuView extends StatefulWidget {
  const MapaMenuView({Key? key}) : super(key: key);

  @override
  _MapaMenuViewState createState() => _MapaMenuViewState();
}

Future<String?> _obtenerRol() async {
  Utiles util = Utiles();
  var rol = await util.getValue("rol");
  return rol;
}

class _MapaMenuViewState extends State<MapaMenuView> {
  final _formKey = GlobalKey<FormState>();

  void _volver() {
    Navigator.pushNamed(context, "/principal");
  }

  @override
  Widget build(BuildContext context) {
  return Container(
    key: _formKey,
    child: Scaffold(
      backgroundColor: Colors.grey[300], // Cambio de color de fondo
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(40),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              "COMENTARIO-NOTICIA MAP",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Aumento de tamaño y negrita
            ),
          ),
          SizedBox(height: 20), // Espaciado entre elementos
          FutureBuilder<String?>(
            future: _obtenerRol(),
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data == "admin") {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Aumento del tamaño del botón
                      textStyle: TextStyle(fontSize: 18), // Aumento del tamaño de fuente del botón
                    ),
                    child: const Text("COMENTARIOS-NOTICIAS"),
                    onPressed: () {
                      Navigator.pushNamed(context, "/noticias");
                    },
                  );
                } else {
                  return Container();
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          SizedBox(height: 20), // Espaciado entre elementos
          FutureBuilder<String?>(
            future: _obtenerRol(),
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data == "admin") {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Aumento del tamaño del botón
                      textStyle: TextStyle(fontSize: 18), // Aumento del tamaño de fuente del botón
                    ),
                    child: const Text("COMENTARIOS TOTALES"),
                    onPressed: () {
                      Navigator.pushNamed(context, "/maps/comentarios");
                    },
                  );
                } else {
                  return Container();
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          SizedBox(height: 20), // Espaciado entre elementos
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Aumento del tamaño del botón
              textStyle: TextStyle(fontSize: 18), // Aumento del tamaño de fuente del botón
            ),
            child: const Text("PRINCIPAL"),
            onPressed: () => (_volver()),
          ),
        ],
      ),
    ),
  );
}

}