// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:typed_data';

class UpdateNoteParams {
  String? idNota;
  int? longitud;
  int? latitud;
  String titulo;
  String? contenido;
  List<Uint8List>? imagenes;
  DateTime? n_date;
  
  UpdateNoteParams({
    this.idNota,
    this.contenido,
    required this.titulo,
    this.longitud,
    this.latitud,
    this.imagenes,
    this.n_date
  });

  get getIdNota => idNota;
  get getTitulo => titulo;
  get getContenido => contenido;
  get getLongitud => longitud;
  get getLatitud => latitud;
  get getDate => n_date;
}