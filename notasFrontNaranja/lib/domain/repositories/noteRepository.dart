// ignore_for_file: camel_case_types

import 'package:either_dart/either.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/nota.dart';

abstract class noteRepository {
    
    Future<Either<MyError,String>> createNota(Nota note);

}

