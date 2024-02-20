
import 'package:flutterg4_pis/controls/servicio_back/RespuestaGenerica.dart';
import 'package:flutterg4_pis/models/user.dart';

class UsuarioSw extends RespuestaGenerica {
  late Persona data;

  UsuarioSw();

  UsuarioSw.fromMap(Map<String, dynamic> datos, String msg, int code) {
    data = Persona.fromMap(datos);

    this.msg = msg;
    this.code = code;
  }
}
