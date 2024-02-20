import 'dart:developer';
import 'package:flutterg4_pis/controls/utiles/Utiles.dart';
import 'package:flutterg4_pis/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutterg4_pis/controls/servicio_back/FacadeService.dart';
import 'package:validators/validators.dart';

class EditarView extends StatefulWidget {
  const EditarView({Key? key}) : super(key: key);

  @override
  _EditarViewState createState() => _EditarViewState();
}

class _EditarViewState extends State<EditarView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController auxNombre = TextEditingController();
  final TextEditingController auxApellido = TextEditingController();
  final TextEditingController auxCorreo = TextEditingController();
  final TextEditingController auxClave = TextEditingController();

  void _registrar() {
    setState(() async {
      FacadeService funcionEdit = FacadeService();
      Utiles util = Utiles();
      var exter = await util.getValue("external");

      if (_formKey.currentState!.validate()) {
        Map<String, String> mapa = {
          "nombres": auxNombre.text,
          "apellidos": auxApellido.text,
          "correo": auxCorreo.text,
          "clave": auxClave.text
        };

        print("mapa $mapa");

        funcionEdit.editarPersona(mapa, exter).then((value) async {
          if (value.code == 200) {
            final SnackBar msg =
                SnackBar(content: Text('Success: ${value.tag}'));
            ScaffoldMessenger.of(context).showSnackBar(msg);
            Navigator.pushNamed(context, "/principal");
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

  Future<Persona> _listar() async {
    FacadeService funcionEdit = FacadeService();
    Utiles util = Utiles();

    var param = await util.getValue("external");

    try {
      var value = await funcionEdit.personaLista(param);

      if (value.code == 200) {
        return value.data;
      } else {
        if (value.code != 200) {
          Navigator.pushNamed(context, '/principal');
        }
      }
    } catch (e) {
      log("Error al cargar persona: $e");
    }
    return Persona();
  }

  Future<String?> _obtenerRol() async {
    Utiles util = Utiles();
    var rol = await util.getValue("rol");
    print(rol.toString());
    return rol;
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
            FutureBuilder<Persona?>(
              future: _listar(),
              builder:
                  (BuildContext context, AsyncSnapshot<Persona?> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data != null) {
                    auxNombre.text = snapshot.data!.nombres;
                    auxApellido.text = snapshot.data!.apellidos;
                    auxCorreo.text = snapshot.data!.correo;
                    return Column(
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            "EDITAR REGISTRO",
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
                                return "Debe ingresar sus nombres";
                              }
                              return null;
                            },
                            decoration:
                                const InputDecoration(labelText: 'Nombres'),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            controller: auxApellido,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Debe ingresar sus apellidos";
                              }
                              return null;
                            },
                            decoration:
                                const InputDecoration(labelText: 'Apellidos'),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            controller: auxCorreo,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Correo Vacio";
                              }
                              if (!isEmail(value)) {
                                return "Correo Invalido";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Correo',
                              suffixIcon: Icon(Icons.alternate_email),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            controller: auxClave,
                            decoration: const InputDecoration(
                              labelText: 'Clave',
                              suffixIcon: Icon(Icons.key),
                            ),
                            obscureText: true,
                          ),
                        ),
                        Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ElevatedButton(
                            child: const Text("Modificar",  style: TextStyle(fontSize: 18, color: Colors.cyan),),
                            onPressed: () => (_registrar()),
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Si no hay datos
                    return Container();
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}