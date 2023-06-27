// ignore_for_file: non_constant_identifier_names

import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:firstapp/domain/errores.dart';

class Nota {

  List<Uint8List>? imagenes;
  int? longitud;
  int? latitud;
  String? estado;
  String? titulo;
  String? contenido;
  DateTime? n_date;
  DateTime? n_edit_date;
  String? id;

  Nota({
    this.imagenes,
    this.n_edit_date,
    this.n_date,
    this.contenido,
    this.titulo,
    this.id,
    this.longitud,
    this.latitud,
    this.estado
  });


  static Either<MyError,Nota> create({
    imagenes,
    DateTime? n_edit_date,
    n_date,
    contenido,
    titulo,
    longitud,
    latitud,
    estado,
    id
  }){
    return Right( Nota(
      n_date: n_date,
      n_edit_date: n_edit_date,
      contenido: contenido,
      titulo: titulo,
      longitud: longitud,
      latitud: latitud,
      estado: estado,
      id: id,
      imagenes: imagenes
    ) );
  }

  get getTitulo => titulo;
  get getContenido => contenido;
  get getDate => n_date;
  get getid => id;
  get getEditDate => n_edit_date;
  get getEstado => estado;
  get getLongitud => longitud;
  get getLatitud => latitud;

}
//Acá se tiene un modelo inicial de lo que contiene las notas