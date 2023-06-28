import 'dart:typed_data';

class CreatenoteParams {
  
  int? longitud;
  int? latitud;
  String titulo;
  String contenido;
  List<Uint8List>? imagenes;
  
  CreatenoteParams({
    required this.contenido,
    required this.titulo,
    this.longitud,
    this.latitud,
    this.imagenes
  });


  get getTitulo => titulo;
  get getContenido => contenido;
  get getLongitud => longitud;
  get getLatitud => latitud;
}