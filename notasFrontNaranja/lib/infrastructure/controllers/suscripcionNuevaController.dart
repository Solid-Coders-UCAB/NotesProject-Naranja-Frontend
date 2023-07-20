import 'package:either_dart/either.dart';
import 'package:firstapp/application/Iservice.dart';

import '../../domain/errores.dart';

class crearSuscripcionController {
  service<void, String> createSuscription;

  crearSuscripcionController({required this.createSuscription});
  Future<Either<MyError, String>> updateUser(
      {required String idUsuario,
      required String nombre,
      required String correo,
      required String clave,
      required DateTime fechaNacimiento,
      required bool suscripcion}) async {
    print("paso");
    var serviceResponse = await createSuscription.execute(null);

    if (serviceResponse.isLeft) {
      return Left(serviceResponse.left);
    }

    return Right(serviceResponse.right);
  }
}
