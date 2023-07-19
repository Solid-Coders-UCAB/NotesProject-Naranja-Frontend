import 'package:either_dart/either.dart';
import 'package:firstapp/domain/user.dart';
import 'package:firstapp/infrastructure/views/systemWidgets/user_profile.dart';
import '../../application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';

// ignore: camel_case_types
class findUserByIdController {
  service<void, user> getUserByIDService;

  findUserByIdController({required this.getUserByIDService});

  Future<Either<MyError, user>> getUserById(UserProfileState widget) async {
    var serviceResponse = await getUserByIDService.execute(null);

    if (serviceResponse.isLeft) {
      return Left(serviceResponse.left);
    }
    //widget.setState(() {
    widget.nombre = serviceResponse.right.nombre!;
    widget.correo = serviceResponse.right.correo!;
    widget.fechaNacimiento = serviceResponse.right.fechaNacimiento.toString();
    if (serviceResponse.right.isSuscribed) {
      widget.suscripcion = "Suscripción Premium";
    } else {
      widget.suscripcion = "Suscripción Básica";
    }
    //});
    return Right(serviceResponse.right);
  }
}
