import 'package:flutterg4_pis/controls/servicio_back/RespuestaGenerica.dart';

class InicioSesionSw extends RespuestaGenerica{
  String tag = '';
  InicioSesionSw({msg='', code=0, datos, this.tag=''});
  //RespuestaGenerica();
}