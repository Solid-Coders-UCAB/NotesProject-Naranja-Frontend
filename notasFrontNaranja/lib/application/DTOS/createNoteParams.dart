// ignore_for_file: file_names

import 'dart:typed_data';

import '../../domain/etiqueta.dart';

class CreatenoteParams {
  
  int? longitud;
  int? latitud;
  String titulo;
  String contenido;
  List<Uint8List>? imagenes;
  String? folderId;
  List<etiqueta>? etiquetas;
  
  CreatenoteParams({
    required this.contenido,
    required this.titulo,
    this.longitud,
    this.latitud,
    this.imagenes,
    this.etiquetas
  });


  get getTitulo => titulo;
  get getContenido => contenido;
  get getLongitud => longitud;
  get getLatitud => latitud;
  get getCarpeta => folderId;

}