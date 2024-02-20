
import 'package:flutterg4_pis/controls/servicio_back/RespuestaGenerica.dart';
import 'package:flutterg4_pis/models/noticia.dart';

class NoticiaSw extends RespuestaGenerica {
  late List<Noticia> data = [];

  NoticiaSw();

  NoticiaSw.fromMap(List datos, String msg, int code) {
    for (var item in datos) {
      Map<String, dynamic> mapa = item;
      Noticia aux = Noticia.fromMap(mapa);
      data.add(aux);
    }

    this.msg = msg;
    this.code = code;
  }
}