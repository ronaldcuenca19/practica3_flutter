
import 'package:flutterg4_pis/controls/servicio_back/RespuestaGenerica.dart';
import 'package:flutterg4_pis/models/comentario.dart';

class ComentarioSw extends RespuestaGenerica {
  late List<Comentario> data = [];

  ComentarioSw();

  ComentarioSw.fromMap(List datos, String msg, int code) {
    for (var item in datos) {
      Map<String, dynamic> mapa = item;
      Comentario aux = Comentario.fromMap(mapa);
      data.add(aux);
    }

    this.msg = msg;
    this.code = code;
  }
}
