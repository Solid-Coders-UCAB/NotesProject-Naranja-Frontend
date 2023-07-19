import 'package:either_dart/src/either.dart';
import 'package:firstapp/application/DTOS/updateUserDTO.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/repositories/userRepository.dart';
import 'package:firstapp/domain/user.dart';

// ignore: camel_case_types
class updateUserInServerService implements service<updateUserDTO, String> {
  userRepository userRepo;
  userRepository localUserRepo;

  updateUserInServerService(
      {required this.userRepo, required this.localUserRepo});

  @override
  Future<Either<MyError, String>> execute(params) async {
    var localres = await localUserRepo.getUser();
    if (localres.isLeft) {
      return Left(localres.left);
    }
    //creamos un usario
    Either<MyError, user> usuario = user.create(
        i: params.idUsuario,
        nombre: params.nombre,
        correo: params.correo,
        clave: params.clave,
        fechaNacimiento: params.fechaNacimiento,
        isSuscribed: params.suscripcion);

    //error al crear el usuario
    if (usuario.isLeft) {
      return Left(usuario.left);
    }

    //se guarda el usuario
    var response = await userRepo.updateUser(usuario.right);

    if (response.isLeft) {
      //error al guardar el usuario
      return Left(response.left);
    }

    return Right(response.right);
  }
}
