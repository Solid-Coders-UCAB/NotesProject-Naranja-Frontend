import 'package:either_dart/either.dart';

import '../../application/DTOS/cmdCreateUser.dart';
import '../../application/Iservice.dart';
import '../../domain/errores.dart';

class registroController {
  service<cmdCreateUser,cmdCreateUser> createUserService;

  registroController({required this.createUserService});

  Future<Either<MyError, cmdCreateUser>> acceder({
      required String nombre, 
      required String correo, 
      required String clave, 
      required DateTime fechaNacimiento
  })async{
    return await createUserService.execute(cmdCreateUser(
      nombre: nombre, 
      correo: correo, 
      clave: clave, 
      fechaNacimiento: fechaNacimiento));  
  }

}