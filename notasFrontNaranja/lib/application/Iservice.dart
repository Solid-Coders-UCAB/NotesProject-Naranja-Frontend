// ignore_for_file: camel_case_types, file_names

import 'package:either_dart/either.dart';
import 'package:firstapp/domain/errores.dart';

abstract class service<params,result> {
 Future<Either<MyError,result>> execute(params params);
}

abstract class Iservice<cmd> {
  Future<Either<MyError,cmd>> execute(cmd command);
}