import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutterg4_pis/controls/servicio_back/FacadeService.dart';
import 'package:flutterg4_pis/controls/utiles/Utiles.dart';
import 'package:validators/validators.dart';

class SessionView extends StatefulWidget {
  const SessionView({Key? key}) : super(key: key);

  @override
  _SessionViewState createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController correoControl = TextEditingController();
  final TextEditingController claveControl = TextEditingController();

  void _iniciar() {
    setState(() {
      FacadeService funcionIS = FacadeService();

      if (_formKey.currentState!.validate()) {
        Map<String, String> mapa = {
          "correo": correoControl.text,
          "clave": claveControl.text
        };

        funcionIS.inicioSesion(mapa).then((value) async {
          if (value.code == 200) {
            Utiles util = Utiles();
            if (value.datos['rol'] == "editor") {
              const SnackBar msg = SnackBar(
                  content: Text('ROL editor sin acceso al sistema'));
              ScaffoldMessenger.of(context).showSnackBar(msg);
              Navigator.pushNamed(context, "/home");
            } else {
              util.saveValue('token', value.datos['token']);
              util.saveValue('user', value.datos['user']);
              util.saveValue('external', value.datos['exter']);
              util.saveValue('rol', value.datos['rol']);

              final SnackBar msg =
                  SnackBar(content: Text('BIENVENIDO ${value.datos['user']}'));
              ScaffoldMessenger.of(context).showSnackBar(msg);
              Navigator.pushNamed(context, "/principal");
            }
          } else {
            final SnackBar msg = SnackBar(content: Text('Error: ${value.tag}'));
            ScaffoldMessenger.of(context).showSnackBar(msg);
          }
        });
      } else {
        log("Error");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200], // Cambiar el fondo a un color blanco crema
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight, // Alinear a la derecha
            padding: const EdgeInsets.all(10),
            child: const Text(
              "unl.edu.ec",
              style: TextStyle(
                color: Colors.yellow, // Cambiar color de azul a amarillo
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight, // Alinear a la derecha
            padding: const EdgeInsets.all(10),
            child: const Text(
              "APP Noticias Flutter",
              style: TextStyle(
                color: Colors.yellow, // Cambiar color de azul a amarillo
                fontSize: 20,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: correoControl,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Correo en Blanco";
                }
                if (!isEmail(value)) {
                  return "Correo Invalido";
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'CORREO ELECTRONICO',
                suffixIcon: Icon(Icons.alternate_email),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: claveControl,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Clave en Blanco";
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'CONTRASEÑA',
                suffixIcon: Icon(Icons.key),
              ),
              obscureText: true,
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              child: const Text("ENTRAR", style: TextStyle(fontSize: 16, color: Colors.cyan),),
              onPressed: () => (_iniciar()),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end, // Alinear al final (derecha)
            children: <Widget>[
              const Text("CUENTA NO REGISTRADA"),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/nuevoUser");
                },
                child: const Text(
                  "NUEVA CUENTA",
                  style: TextStyle(fontSize: 18, color: Colors.cyan),
      
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
