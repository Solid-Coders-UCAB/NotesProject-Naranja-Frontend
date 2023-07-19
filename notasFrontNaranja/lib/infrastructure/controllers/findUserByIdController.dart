import 'package:either_dart/either.dart';
import 'package:firstapp/domain/user.dart';
import 'package:firstapp/infrastructure/views/systemWidgets/user_profile.dart';
import '../../application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';

// ignore: camel_case_types
class findUserByIdController {
  service<void, user> getUserByIDService;

  findUserByIdController({required this.getUserByIDService});

  void getUserById(UserProfileState widget) async {
    widget.loading = true;
    var serviceResponse = await getUserByIDService.execute(null);

    if (serviceResponse.isLeft) {
      //return Left(serviceResponse.left);
    }
    print(serviceResponse.right.nombre);
    widget.changeState(serviceResponse.right);

    //return Right(serviceResponse.right);
  }
}
