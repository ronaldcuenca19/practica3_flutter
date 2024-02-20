
class Persona {
  String nombres = '';
  String apellidos = '';
  String correo = '';
  String external = '';

  Persona();

  Persona.fromMap(Map<dynamic, dynamic> mapa) {
    print(mapa);
    nombres = mapa['nombres'];
    apellidos = mapa['apellidos'];
    correo = mapa["cuenta"]['correo'];
    external = mapa['id'];
  }
}
