// ignore_for_file: implementation_imports, camel_case_types, file_names

import 'package:either_dart/src/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';

class serviceDecorator<params,result> implements service<params,result>{
  
  service<params,result> servicio;

  serviceDecorator({required this.servicio});

  @override
  Future<Either<MyError,result>> execute(params params) async {    
    return await servicio.execute(params);
  }
  
}