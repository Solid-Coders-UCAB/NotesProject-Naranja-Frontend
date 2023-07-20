
import 'package:either_dart/either.dart';
import 'package:firstapp/application/serviceDecorator.dart';
import '../domain/errores.dart';
import 'package:firstapp/domain/user.dart';
import 'Iservice.dart';

class suscripcionDecorator<params,result> extends serviceDecorator<params,result>{
  service<void, user> getUserByIdService;
  suscripcionDecorator({required super.servicio, required this.getUserByIdService});

    @override
    Future<Either<MyError,result>> execute(params params) async {  
      var serviceResponse = await getUserByIdService.execute(null);
  
      if (serviceResponse.isRight) {
        // Se verifica que el usuario este suscrito
        if (serviceResponse.right.getSuscripcion) {
        // Aqui se ejecuta el servicio envuelto
          var servicioPremiumExecute = await super.execute(params);

          if (servicioPremiumExecute.isRight){
            return Right(servicioPremiumExecute.right);
          }
          return Left(servicioPremiumExecute.left);
        } else {
          return const Left(MyError(key: AppError.NotFound, message: "No posee suscripcion")); 
        }
    }
 
    return Left(serviceResponse.left);  

  }
              
}