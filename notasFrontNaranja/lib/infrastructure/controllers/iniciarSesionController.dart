import 'package:either_dart/either.dart';
import 'package:firstapp/application/DTOS/cmdIniciarSesion.dart';
import 'package:firstapp/domain/repositories/userRepository.dart';


import '../../application/Iservice.dart';
import '../../domain/errores.dart';
import '../../domain/user.dart';

class iniciarSesionController{
  service<cmdIniciarSesion,user> iniciarSesionService;
  userRepository localUserRepo;

  iniciarSesionController({required this.iniciarSesionService,required this.localUserRepo});

Future<Either<MyError, user>> iniciarSesion({required String email,required String password}) async {
    return await iniciarSesionService.execute(cmdIniciarSesion(email: email, password: password));
  }
Future<Either<MyError, user>> checkUserInCache() async {
    return await localUserRepo.getUser();
  }  

}

