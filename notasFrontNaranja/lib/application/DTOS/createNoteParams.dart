// ignore_for_file: file_names

import 'dart:typed_data';

class CreatenoteParams {
  
  int? longitud;
  int? latitud;
  String titulo;
  String? contenido;
  List<Uint8List>? imagenes;
  
  CreatenoteParams({
    this.contenido,
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