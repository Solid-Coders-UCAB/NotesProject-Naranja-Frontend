import 'package:either_dart/src/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/repositories/userRepository.dart';
import 'package:firstapp/domain/user.dart';

class cerrarSesionService extends service<void,user> {

  userRepository localRepo;

  cerrarSesionService({required this.localRepo});

  @override
  Future<Either<MyError, user>> execute(void params) async {
    var getResponse = await localRepo.getUser();
      if (getResponse.isLeft){
        return Left(getResponse.left);
      }
    var deleteResponse = await localRepo.deleteUser(getResponse.right);
      if (deleteResponse.isLeft){
        return Left(getResponse.left);
      }

     return Right(getResponse.right);     
  }



  
}