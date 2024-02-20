import 'dart:convert';
import 'package:flutterg4_pis/controls/servicio_back/RespuestaGenerica.dart';
import 'package:http/http.dart' as http;
import 'package:flutterg4_pis/controls/utiles/Utiles.dart';

class Conexion {
  final String URL = "http://10.0.2.15:3000/api/";
  static const String URL_MEDIA = "http://10.0.2.15:3000/multimedia/";
  static bool NO_TOKEN = false;

  Future<RespuestaGenerica> solicitudGet(String recurso, bool token) async {
    Map<String, String> header = {'Content-Type': 'application/json'};
    if (token == true) {
      Utiles util = Utiles();
      if (token == true) {
        header = {'Content-Type': 'application/json', 'practica3-token': 'ludwig'};
      }
      var tokenA = await util.getValue('token');
      header = {
        'Content-Type': 'application/json',
        'practica3-token': tokenA ?? ''
      };
    }

    final String url = URL + recurso;
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri, headers: header);
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          return _response(404, "Recurso no encontrado", []);
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          return _response(mapa['code'], mapa['msg'], mapa['datos']);
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        return _response(mapa['code'], mapa['msg'], mapa['datos']);
      }
      // return RespuestaGenerica();
    } catch (e) {
      return _response(500, "Error Inesperado", []);
    }
  }

  Future<RespuestaGenerica> solicitudPost(
      String recurso, bool token, Map<dynamic, dynamic> data) async {
    Map<String, String> header = {'Content-Type': 'application/json'};
    if (token == true) {
      Utiles util = Utiles();
      if (token == true) {
        header = {'Content-Type': 'application/json', 'practica3-token': 'ludwig'};
      }
      var tokenA = await util.getValue('token');
      header = {
        'Content-Type': 'application/json',
        'practica3-token': tokenA ?? ''
      };
    }

    final String url = URL + recurso;
    final uri = Uri.parse(url);

    try {
      final response = await http.post(uri, headers: header);
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          return _response(404, "Recurso no encontrado", []);
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          return _response(mapa['code'], mapa['msg'], mapa['datos']);
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        return _response(mapa['code'], mapa['msg'], mapa['datos']);
      }
    } catch (e) {
      return _response(500, "Error Inesperado", []);
    }
  }

  RespuestaGenerica _response(int code, String msg, dynamic data) {
    var respuesta = RespuestaGenerica();
    respuesta.code = code;
    respuesta.msg = msg;
    respuesta.datos = data;
    return respuesta;
  }
}
