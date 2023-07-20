// ignore_for_file: camel_case_types, file_names

import 'package:either_dart/either.dart';
import 'package:firstapp/application/serviceDecorator.dart';

import '../domain/errores.dart';
import 'Iservice.dart';

class connectionCheckerDecorator<params,result> extends serviceDecorator<params,result>{
  
  connectionChecker checker;
  service<params, result> offlineService;

  connectionCheckerDecorator({required this.checker, required super.servicio,required this.offlineService});

    @override
    Future<Either<MyError,result>> execute(params params) async {   

      bool hasConnection = await checker.checkConnection();

      if (hasConnection){
        return await super.execute(params);
      }

        return const Left(MyError(key: AppError.NotFound,message: "error to get connection from this device"));

    }
}

abstract class connectionChecker{

  Future<bool> checkConnection();

}