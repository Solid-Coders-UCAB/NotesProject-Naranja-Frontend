// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:typed_data';

import 'package:firstapp/domain/etiqueta.dart';

class UpdateNoteParams {
  String idNota;
  int? longitud;
  int? latitud;
  String titulo;
  String contenido;
  List<Uint8List>? imagenes;
  DateTime n_date;
  String estado;
  String idCarpeta;
  List<etiqueta>? etiquetas;
  
  UpdateNoteParams({
    required this.estado,
    required this.idNota,
    required this.contenido,
    required this.titulo,
    this.longitud,
    this.latitud,
    this.imagenes,
    required this.n_date,
    required this.idCarpeta,
    this.etiquetas
  });

  get getIdNota => idNota;
  get getTitulo => titulo;
  get getContenido => contenido;
  get getLongitud => longitud;
  get getLatitud => latitud;
  get getDate => n_date;
}