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
    
      return Left( MyError(key: AppError.NotFound));

  }
  
  

  
}