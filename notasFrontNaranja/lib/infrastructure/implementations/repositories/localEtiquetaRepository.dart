import 'package:either_dart/src/either.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/etiqueta.dart';
import 'package:firstapp/domain/nota.dart';
import 'package:firstapp/domain/repositories/etiquetaRepository.dart';

class localEtiquetaRepository implements etiquetaRepository {
  
  @override
  Future<Either<MyError, String>> createEtiqueta(etiqueta etiqueta) {
    // TODO: implement createEtiqueta
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, String>> deleteEtiqueta(String idEtiqueta) {
    // TODO: implement deleteEtiqueta
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, List<etiqueta>>> getAllEtiquetas(String idUsuario) {
    // TODO: implement getAllEtiquetas
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, etiqueta>> getEtiquetaById(String idEtiqueta) {
    // TODO: implement getEtiquetaById
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, List<Nota>>> getNotesByEtiqueta(String idEtiqueta, String idUsuario) {
    // TODO: implement getNotesByEtiqueta
    throw UnimplementedError();
  }

  @override
  Future<Either<MyError, String>> updateEtiqueta(etiqueta etiqueta) {
    // TODO: implement updateEtiqueta
    throw UnimplementedError();
  }
  
}