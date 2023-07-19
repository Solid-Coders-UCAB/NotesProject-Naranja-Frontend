import 'package:either_dart/either.dart';

import 'errores.dart';

class etiqueta {
  String nombre;
  String? id;
  String idUsuario;
  etiqueta({required this.nombre, required this.idUsuario, this.id});

    static Either<MyError, etiqueta> create({
    String? id,
    required nombre,
    required idUsuario
  }){
    return Right( etiqueta(
      nombre: nombre,
      idUsuario: idUsuario,
      id: id
     ) 
    );
  }
}