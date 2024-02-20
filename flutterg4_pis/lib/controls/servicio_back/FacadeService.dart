import 'dart:convert';
import 'dart:developer';
import 'package:flutterg4_pis/controls/Conexion.dart';
import 'package:flutterg4_pis/controls/servicio_back/modelo/InicioSesionSw.dart';
import 'package:flutterg4_pis/controls/servicio_back/modelo/ComentarioSw.dart';
import 'package:flutterg4_pis/controls/servicio_back/modelo/NoticiaSw.dart';
import 'package:flutterg4_pis/controls/servicio_back/modelo/UsuarioSw.dart';
import 'package:flutterg4_pis/controls/utiles/Utiles.dart';
import 'package:http/http.dart' as http;

class FacadeService {
  Conexion c = Conexion();

  Future<InicioSesionSw> inicioSesion(Map<String, String> mapa) async {
    Map<String, String> header = {'Content-Type': 'application/json'};

    final String url = '${c.URL}login';
    final uri = Uri.parse(url);

    InicioSesionSw auxSW = InicioSesionSw();

    try {
      final response =
          await http.post(uri, headers: header, body: jsonEncode(mapa));

      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          auxSW.code = 404;
          auxSW.msg = 'Error';
          auxSW.tag = 'No se pudo encontrar el source';
          auxSW.datos = {};
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          auxSW.code = mapa['code'];
          auxSW.msg = mapa['msg'];
          auxSW.tag = mapa['tag'];
          auxSW.datos = mapa['datos'];
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        auxSW.code = mapa['code'];
        auxSW.msg = mapa['msg'];
        auxSW.tag = mapa['tag'];
        auxSW.datos = mapa['datos'];
      }
    } catch (e) {
      auxSW.code = 500;
      auxSW.msg = 'Error';
      auxSW.tag = 'Ocurrio un repentino Error';
      auxSW.datos = {};
    }
    return auxSW;
  }

  Future<InicioSesionSw> nuevaPersona(Map<String, String> mapa) async {
    Map<String, String> header = {'Content-Type': 'application/json'};

    final String url = '${c.URL}admin/persona/save';
    final uri = Uri.parse(url);

    InicioSesionSw auxSW = InicioSesionSw();

    try {
      final response =
          await http.post(uri, headers: header, body: jsonEncode(mapa));
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          auxSW.code = 404;
          auxSW.msg = 'Error';
          auxSW.tag = 'No se pudo encontrar el source';
          auxSW.datos = {};
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          auxSW.code = mapa['code'];
          auxSW.msg = mapa['msg'];
          auxSW.tag = mapa['tag'];
          auxSW.datos = {};
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        auxSW.code = mapa['code'];
        auxSW.msg = mapa['msg'];
        auxSW.tag = mapa['tag'];
        auxSW.datos = {};                                                                                                   
      }
    } catch (e) {
      auxSW.code = 500;
      auxSW.msg = 'Error';
      auxSW.tag = 'Ocurrio un repentino Error';
      auxSW.datos = {};
    }
    return auxSW;
  }

  Future<InicioSesionSw> editarPersona(
      Map<String, String> mapa, external) async {
    Utiles util = Utiles();
    var token = await util.getValue("token");

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'practica3-token': token ?? '',
    };

    final String url = '${c.URL}admin/personas/modificar/$external';
    final uri = Uri.parse(url);

    InicioSesionSw auxSW = InicioSesionSw();

    try {
      final response =
          await http.post(uri, headers: header, body: jsonEncode(mapa));
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          auxSW.code = 404;
          auxSW.msg = 'Error';
          auxSW.tag = 'No se pudo encontrar el source';
          auxSW.datos = {};
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          auxSW.code = mapa['code'];
          auxSW.msg = mapa['msg'];
          auxSW.tag = mapa['tag'];
          auxSW.datos = {};
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        auxSW.code = mapa['code'];
        auxSW.msg = mapa['msg'];
        auxSW.tag = mapa['tag'];
        auxSW.datos = {};
      }
    } catch (e) {
      auxSW.code = 500;
      auxSW.msg = 'Error';
      auxSW.tag = 'Ocurrio un repentino Error';
      auxSW.datos = {};
    }
    return auxSW;
  }

  Future<InicioSesionSw> guardarComentario(Map<String, String> mapa) async {
    Utiles util = Utiles();
    var token = await util.getValue("token");

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'practica3-token': token ?? '',
    };

    final String url = '${c.URL}admin/comentarios/save';
    final uri = Uri.parse(url);

    InicioSesionSw auxSW = InicioSesionSw();

    try {
      final response =
          await http.post(uri, headers: header, body: jsonEncode(mapa));
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          auxSW.code = 404;
          auxSW.msg = 'Error';
          auxSW.tag = 'No se pudo encontrar el source';
          auxSW.datos = {};
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          auxSW.code = mapa['code'];
          auxSW.msg = mapa['msg'];
          auxSW.tag = mapa['tag'];
          auxSW.datos = {};
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        auxSW.code = mapa['code'];
        auxSW.msg = mapa['msg'];
        auxSW.tag = mapa['tag'];
        auxSW.datos = {};
      }
    } catch (e) {
      auxSW.code = 500;
      auxSW.msg = 'Error';
      auxSW.tag = 'Ocurrio un repentino Error';
      auxSW.datos = {};
    }
    return auxSW;
  }

  Future<NoticiaSw> listadoNoticiaTotal() async {
    Utiles util = Utiles();
    var token = await util.getValue("token");

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'practica3-token': token ?? '',
    };

    final String url = '${c.URL}noticias';
    final uri = Uri.parse(url);

    NoticiaSw auxSW = NoticiaSw();

    try {
      final response = (await (http.get(uri, headers: header)));

      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          auxSW = NoticiaSw.fromMap([], 'Error No se pudo encontrar el source ', 404);
        } else {
          Map<String, dynamic> mapa = jsonDecode(response.body);
          auxSW = NoticiaSw.fromMap(
              [], mapa["msg"], int.parse(mapa["code"].toString()));
        }
      } else {
        Map<String, dynamic> mapa = jsonDecode(response.body);
        List datos = jsonDecode(jsonEncode(mapa["datos"]));
        auxSW = NoticiaSw.fromMap(
            datos, mapa["msg"], int.parse(mapa["code"].toString()));
      }
    } catch (e) {
      auxSW = NoticiaSw.fromMap([], 'Error $e', 500);
    }
    log(auxSW.toString());
    return auxSW;
  }

  Future<ComentarioSw> listadoComentarioTotal(external) async {
    Utiles util = Utiles();
    var token = await util.getValue("token");

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'practica3-token': token ?? '',
    };

    final String url = '${c.URL}comentarios/$external';
    final uri = Uri.parse(url);

    ComentarioSw auxSW = ComentarioSw();

    try {
      final response = (await (http.get(uri, headers: header)));

      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          auxSW = ComentarioSw.fromMap(
              [], 'Error No se pudo encontrar el source ', 404);
        } else {
          Map<String, dynamic> mapa = jsonDecode(response.body);
          auxSW = ComentarioSw.fromMap(
              [], mapa["msg"], int.parse(mapa["code"].toString()));
        }
      } else {
        Map<String, dynamic> mapa = jsonDecode(response.body);
        List datos = jsonDecode(jsonEncode(mapa["datos"]));
        auxSW = ComentarioSw.fromMap(
            datos, mapa["msg"], int.parse(mapa["code"].toString()));
      }
    } catch (e) {
      auxSW = ComentarioSw.fromMap([], 'Error $e', 500);
    }
    return auxSW;
  }

  Future<ComentarioSw> comentarioLista() async {
    Utiles util = Utiles();
    var token = await util.getValue("token");

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'practica3-token': token ?? '',
    };

    final String url = '${c.URL}comentarios';
    final uri = Uri.parse(url);

    ComentarioSw auxSW = ComentarioSw();

    try {
      final response = (await (http.get(uri, headers: header)));

      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          auxSW = ComentarioSw.fromMap(
              [], 'Error No se pudo encontrar el source ', 404);
        } else {
          Map<String, dynamic> mapa = jsonDecode(response.body);
          auxSW = ComentarioSw.fromMap(
              [], mapa["msg"], int.parse(mapa["code"].toString()));
        }
      } else {
        Map<String, dynamic> mapa = jsonDecode(response.body);
        List datos = jsonDecode(jsonEncode(mapa["datos"]));
        auxSW = ComentarioSw.fromMap(
            datos, mapa["msg"], int.parse(mapa["code"].toString()));
      }
    } catch (e) {
      auxSW = ComentarioSw.fromMap([], 'Error $e', 500);
    }
    return auxSW;
  }

  Future<InicioSesionSw> bajarCuenta(external, estado) async {
    Utiles util = Utiles();
    var token = await util.getValue("token");

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'practica3-token': token ?? '',
    };

    final String url = '${c.URL}admin/personas/banear/$external/$estado';
    final uri = Uri.parse(url);

    InicioSesionSw auxSW = InicioSesionSw();

    try {
      final response = await http.get(uri, headers: header);

      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          auxSW.code = 404;
          auxSW.msg = 'Error';
          auxSW.tag = 'No se pudo encontrar el source';
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          auxSW.code = mapa['code'];
          auxSW.msg = mapa['msg'];
          auxSW.tag = mapa['tag'];
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        auxSW.code = mapa['code'];
        auxSW.msg = mapa['msg'];
        auxSW.tag = mapa['tag'];
      }
    } catch (e) {
      auxSW.code = 500;
      auxSW.msg = 'Error';
      auxSW.tag = 'Ocurrio un repentino Error';
    }
    return auxSW;
  }

  Future<UsuarioSw> personaLista(external) async {
    Utiles util = Utiles();
    var token = await util.getValue("token");

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'practica3-token': token ?? '',
    };

    final String url = '${c.URL}admin/personas/get/$external';
    final uri = Uri.parse(url);

    UsuarioSw auxSW = UsuarioSw();

    try {
      final response = (await (http.get(uri, headers: header)));
      print("Obtener Usuariof${response.body}");
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          auxSW = UsuarioSw.fromMap({}, 'Error No se pudo encontrar el source ', 404);
        } else {
          Map<String, dynamic> mapa = jsonDecode(response.body);
          auxSW = UsuarioSw.fromMap(
              {}, mapa["msg"], int.parse(mapa["code"].toString()));
        }
      } else {
        Map<String, dynamic> mapa = jsonDecode(response.body);

        Map<String, dynamic> datos = mapa["info"];
        print("entro");
        print(datos);
        auxSW = UsuarioSw.fromMap(
            datos, mapa["msg"], int.parse(mapa["code"].toString()));
      }
    } catch (e) {
      auxSW = UsuarioSw.fromMap({}, 'Error $e', 500);
    }
    return auxSW;
  }
}
