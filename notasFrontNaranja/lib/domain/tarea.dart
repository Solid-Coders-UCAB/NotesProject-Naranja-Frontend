import 'package:either_dart/either.dart';

import 'errores.dart';

class tarea {
 String? id;
 String nombreTarea;
 bool completada;

 tarea({this.id, required this.nombreTarea, required this.completada});

  static Either<MyError,tarea> create({
    String? id,
    required String nombreTarea,
    required bool completada,
  }){
    return Right( tarea(
      id: id,
      nombreTarea: nombreTarea,
      completada: completada
    ) );
  }
 
}
