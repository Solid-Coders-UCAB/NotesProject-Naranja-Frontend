import 'package:either_dart/either.dart';
import '../../application/Iservice.dart';
import 'package:firstapp/application/DTOS/updateUserDTO.dart';
import 'package:firstapp/domain/errores.dart';

// ignore: camel_case_types
class editarUsuarioWidgetController {
  service<updateUserDTO, String> updateUsuarioService;

  editarUsuarioWidgetController({required this.updateUsuarioService});

  Future<Either<MyError, String>> updateUser(
      {required String idUsuario,
      required String nombre,
      required,
      required String correo,
      required String clave,
      required DateTime fechaNacimiento,
      required bool suscripcion}) async {
    var serviceResponse = await updateUsuarioService.execute(updateUserDTO(
        idUsuario: idUsuario,
        nombre: nombre,
        correo: correo,
        clave: clave,
        fechaNacimiento: fechaNacimiento,
        suscripcion: suscripcion));

    if (serviceResponse.isLeft) {
      return Left(serviceResponse.left);
    }

    return Right(serviceResponse.right);
  }
}
