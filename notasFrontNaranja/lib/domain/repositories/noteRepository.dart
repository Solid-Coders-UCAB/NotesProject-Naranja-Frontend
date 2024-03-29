// ignore_for_file: camel_case_types

import 'package:either_dart/either.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/nota.dart';

abstract class noteRepository {
    
    Future<Either<MyError,String>> createNota(Nota note);
    Future<Either<MyError,String>> updateNota(Nota note);
    Future<Either<MyError,String>> deleteNota(Nota note);
    Future<Either<MyError,List<Nota>>> getALLnotes(String userId);
    Future<Either<MyError,List<Nota>>> getAllEliminatedNotes(String userId);
    Future<Either<MyError, List<Nota>>> getNotesByKeyword(String palabraClave, String idUsuario);

}

