
class Comentario {
  String texto = '';
  String cliente = '';
  String longitud = '';
  String latitud = '';
  bool estado = false;
  String external = '';

  Comentario();

  Comentario.fromMap(Map<dynamic, dynamic> mapa) {
    texto = mapa['texto'];
    cliente = mapa['cliente'];
    longitud = mapa['longitud'];
    latitud = mapa['latitud'];
    external = mapa['external_id'];
    estado = (mapa['estado'].toString() == 'true') ? true : false;
  }
}
