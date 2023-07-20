
import 'package:either_dart/either.dart';
import 'package:firstapp/application/connectionCheckerDecorator.dart';
import 'package:firstapp/application/serviceDecorator.dart';

import '../domain/errores.dart';
import 'Iservice.dart';

class offlineDecorator<params,result> extends serviceDecorator<params,result>{

  service<params, result> offlineService;
  connectionChecker checker;

  offlineDecorator({required super.servicio,required this.offlineService,required this.checker});

    @override
    Future<Either<MyError,result>> execute(params params) async {   
      
      var onlineExecute = await super.execute(params);
      var offlineExecute = await offlineService.execute(params); 

        if (onlineExecute.isRight){
          return Right(onlineExecute.right);
        }
          
          bool isConnected = await checker.checkConnection();
          if (offlineExecute.isRight && !(isConnected) ){
            return Right(offlineExecute.right);
          }
          
          if (onlineExecute.isLeft && (isConnected) ){
            return Left(onlineExecute.left);
          }

          print(offlineExecute.left.message);

    return Left(offlineExecute.left);
  }
         
      
}
