import 'package:either_dart/either.dart';
import 'package:firstapp/domain/etiqueta.dart';

import '../errores.dart';

// ignore: camel_case_types
abstract class etiquetaRepository {
    
    Future<Either<MyError, String>> createEtiqueta(etiqueta etiqueta);
    Future<Either<MyError, String>> updateEtiqueta(etiqueta etiqueta);
    Future<Either<MyError, List<etiqueta>>> getAllEtiquetas(String idUsuario);
  
}