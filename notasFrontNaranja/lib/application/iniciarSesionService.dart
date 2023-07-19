import 'package:either_dart/src/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/repositories/userRepository.dart';

import '../domain/user.dart';
import 'DTOS/cmdIniciarSesion.dart';

class iniciarSesionService implements service<cmdIniciarSesion,user> {
  
  userRepository localRepo;
  userRepository httpRepo;

  iniciarSesionService({required this.localRepo,required this.httpRepo});
  
  @override
  Future<Either<MyError, user>> execute(cmdIniciarSesion params) async {
    
      var serverResponse = await httpRepo.getUserByEmailAndPass(params.email, params.password);
        if (serverResponse.isLeft){
          return Left(serverResponse.left);
        }
      var cacheResponse =  await localRepo.saveUser(serverResponse.right);
       if (cacheResponse.isLeft){
        return Left(cacheResponse.left);
       } 
    return Right(serverResponse.right);
  }
  
  

  
}