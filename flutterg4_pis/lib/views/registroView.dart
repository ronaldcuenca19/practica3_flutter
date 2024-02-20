import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutterg4_pis/controls/servicio_back/FacadeService.dart';
import 'package:validators/validators.dart';

class RegistroView extends StatefulWidget {
  const RegistroView({Key? key}) : super(key: key);

  @override
  _RegistroViewState createState() => _RegistroViewState();
}

class _RegistroViewState extends State<RegistroView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController auxNombre = TextEditingController();
  final TextEditingController apellidoC = TextEditingController();
  final TextEditingController auxCorreo = TextEditingController();
  final TextEditingController auxClave = TextEditingController();

  void _registrar() {
    setState(() {
      FacadeService servicio = FacadeService();

      if (_formKey.currentState!.validate()) {
        Map<String, String> mapa = {
          "nombres": auxNombre.text,
          "apellidos": apellidoC.text,
          "correo": auxCorreo.text,
          "clave": auxClave.text
        };

        servicio.nuevaPersona(mapa).then((value) async {
          
          if (value.code == 200) {
            final SnackBar msg =
                SnackBar(content: Text('Success: ${value.tag}'));
            ScaffoldMessenger.of(context).showSnackBar(msg);
            Navigator.pushNamed(context, "/home");
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
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.blueGrey[200],
        body: ListView(
          padding: const EdgeInsets.all(32),
          children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Nuevo Usuario",
                style: TextStyle(
                color: Colors.yellow, // Cambiar color de azul a amarillo
                fontWeight: FontWeight.bold,
                fontSize: 30,),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "unl.edu.ec",
                style: TextStyle( color: Colors.yellow, // Cambiar color de azul a amarillo
                fontWeight: FontWeight.bold,
                fontSize: 30,),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                  controller: auxNombre,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Nombres Vacios";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Nombres')),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: apellidoC,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Apellidos Vacios";
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Apellidos'),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: auxCorreo,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Correo";
                  }
                  if (!isEmail(value)) {
                    return "Correo Invalido";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: 'Correo',
                    suffixIcon: Icon(Icons.alternate_email)),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: auxClave,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Clave Vacia";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: 'Clave', suffixIcon: Icon(Icons.key)),
                obscureText: true,
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text("REGISTRAR",  style: TextStyle(fontSize: 18, color: Colors.cyan),),
                onPressed: () => (_registrar()),
              ),
            ),
            Row(
              children: <Widget>[
                const Text("Tu cuenta ya existe"),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/home");
                    },
                    child: const Text(
                      "Login,",
                       style: TextStyle(fontSize: 18, color: Colors.cyan),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}