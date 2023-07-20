import 'package:firstapp/domain/user.dart';
import 'package:firstapp/infrastructure/views/systemWidgets/user_profile.dart';
import '../../application/Iservice.dart';

// ignore: camel_case_types
class findUserByIdController {
  service<void, user> getUserByIDService;

  findUserByIdController({required this.getUserByIDService});

  void getUserById(UserProfileState widget) async {
    widget.loading = true;
    var serviceResponse = await getUserByIDService.execute(null);

    if (serviceResponse.isLeft) {
      print(serviceResponse.left.message);
      // ignore: invalid_use_of_protected_member
      widget.setState(() {
          widget.loading = false;
        });
      //return Left(serviceResponse.left);
    }

    if (serviceResponse.isRight) {
      widget.changeState(serviceResponse.right);
    }
    
    //return Right(serviceResponse.right);
  }
}
