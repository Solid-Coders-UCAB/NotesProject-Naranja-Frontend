import 'package:either_dart/either.dart';
import 'package:either_dart/src/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/repositories/userRepository.dart';
import 'package:firstapp/domain/user.dart';

class createSuscriptionService implements service<void, String> {
  userRepository localUserRepo;
  userRepository userRepo;

  createSuscriptionService(
      {required this.userRepo, required this.localUserRepo});

  @override
  Future<Either<MyError, String>> execute(void params) async {
    var localres = await localUserRepo.getUser();
    if (localres.isLeft) {
      return Left(localres.left);
    }

    var suscriptionResponse =
        await userRepo.createSuscription(localres.right.id);
    if (suscriptionResponse.isLeft) {
      return Left(suscriptionResponse.left);
    }
    var userResponse = await userRepo.getUserById(localres.right.id);
    if (userResponse.isLeft) {
      return Left(userResponse.left);
    }
    Either<MyError, user> usuario = user.create(
        i: userResponse.right.id,
        nombre: userResponse.right.nombre!,
        correo: userResponse.right.correo!,
        clave: userResponse.right.clave!,
        fechaNacimiento: userResponse.right.fechaNacimiento!,
        isSuscribed: true);

    if (usuario.isLeft) {
      return Left(usuario.left);
    }
    var updateUser = await userRepo.updateUser(usuario.right);

    if (updateUser.isLeft) {
      return Left(updateUser.left);
    }
    return Right(updateUser.right);
  }
}
