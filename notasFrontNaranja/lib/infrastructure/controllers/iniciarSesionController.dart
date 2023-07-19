import 'package:either_dart/either.dart';
import 'package:firstapp/application/DTOS/cmdIniciarSesion.dart';

import '../../application/Iservice.dart';
import '../../domain/errores.dart';
import '../../domain/user.dart';

class iniciarSesionController{
  service<cmdIniciarSesion,user> iniciarSesionService;

  iniciarSesionController({required this.iniciarSesionService});

Future<Either<MyError, user>> iniciarSesion({required String email,required String password}) async {
    return await iniciarSesionService.execute(cmdIniciarSesion(email: email, password: password));
  }
}

