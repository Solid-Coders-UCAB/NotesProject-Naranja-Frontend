// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:firstapp/domain/errores.dart';

import 'package:html/parser.dart';

import 'etiqueta.dart';

class Nota {

  List<Uint8List>? imagenes;
  int? longitud;
  int? latitud;
  String? estado;
  String titulo;
  String contenido;
  DateTime n_date;
  DateTime? n_edit_date;
  String id;
  List<etiqueta>? etiquetas;
  String idCarpeta;

  Nota({
    this.imagenes,
    this.n_edit_date,
    required this.n_date,
    required this.contenido,
    required this.titulo,
    required this.id,
    this.longitud,
    this.latitud,
    this.estado,
    this.etiquetas,
    required this.idCarpeta
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
    required String id,
    etiquetas,
    carpeta
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
      imagenes: imagenes,
      etiquetas: etiquetas,
      idCarpeta: carpeta
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
  get getCarpeta => idCarpeta;

  Uint8List? getFirstImage(){
    try{
      var document = parse(contenido);
       var imgElement = document.getElementsByTagName('img').firstWhere((element) =>
        element.attributes.containsKey('src') && element.attributes['src']!.startsWith('data:image/'));
       String base64Image = imgElement.attributes['src']!;
       Uint8List decodedImage = base64.decode(base64Image.split(',')[1]);
       return decodedImage;
    }catch(e){
      return null;
    }
  }

  List<String> getEtiquetasIds(){
    List<String> ids = [];
      for (var etiqueta in etiquetas!) {
        ids.add(etiqueta.id!);
      }
     return ids; 
  }
  


}
