
class Noticia {
  String titulo = '';
  DateTime fecha = DateTime.now();
  String tipo_archivo = '';
  String cuerpo = '';
  String tipo_noticia = '';
  String archivo = '';
  bool estado = false;
  String id = '';

  Noticia();

  Noticia.fromMap(Map<dynamic, dynamic> mapa) {
    titulo = mapa['titulo'];
    cuerpo = mapa['cuerpo'];
    tipo_noticia = mapa['tipo_noticia'];
    tipo_archivo = mapa['tipo_archivo'];
    archivo = mapa['archivo'];
    fecha = DateTime.parse(mapa['fecha'].toString());
    estado = (mapa['estado'].toString() == 'true') ? true : false;
    id = mapa['id'];
  }
}
