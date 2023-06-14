// ignore_for_file: camel_case_types

import 'package:either_dart/either.dart';
import 'package:firstapp/domain/errores.dart';

abstract class service<params,result> {
 Future<Either<MyError,result>> execute(params params);
}