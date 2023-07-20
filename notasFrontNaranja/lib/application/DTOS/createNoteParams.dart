// ignore_for_file: file_names

import 'dart:typed_data';
import 'package:firstapp/domain/tarea.dart';
import '../../domain/etiqueta.dart';

class CreatenoteParams {
  
  double? longitud;
  double? latitud;
  String titulo;
  String contenido;
  List<Uint8List>? imagenes;
  String? folderId;
  List<etiqueta>? etiquetas;
  List<tarea> tareas;

  CreatenoteParams({
    required this.contenido,
    required this.titulo,
    this.longitud,
    this.latitud,
    this.imagenes,
    this.etiquetas,
    this.folderId,
    required this.tareas,
  });


  get getTitulo => titulo;
  get getContenido => contenido;
  get getLongitud => longitud;
  get getLatitud => latitud;
  get getCarpeta => folderId;
  get getTareas => tareas;

}