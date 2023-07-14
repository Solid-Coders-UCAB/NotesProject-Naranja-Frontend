import 'package:either_dart/either.dart';
import 'package:firstapp/domain/nota.dart';

import 'errores.dart';

class folder {
 
 String? id;
 String name;
 List<Nota>? notas;
 bool predeterminada;

 folder({this.id,required this.predeterminada,required this.name});

  static Either<MyError,folder> create({
    required String name,
    String? id,
    required predeterminada
  }){
    return Right( folder(
      name: name,
      id: id,
      predeterminada: predeterminada
    ) );
  }
 
}