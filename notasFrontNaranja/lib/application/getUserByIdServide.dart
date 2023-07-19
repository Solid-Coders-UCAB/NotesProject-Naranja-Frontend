import 'package:either_dart/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/user.dart';
import 'package:firstapp/domain/repositories/userRepository.dart';

// ignore: camel_case_types
class getUserByIdInServerService implements service<void, user> {
  userRepository userRepo;
  userRepository localUserRepo;

  getUserByIdInServerService(
      {required this.userRepo, required this.localUserRepo});

  @override
  Future<Either<MyError, user>> execute(params) async {
    var localres = await localUserRepo.getUser();
    if (localres.isLeft) {
      return Left(localres.left);
    }

    var repoResponse = await userRepo.getUserById(localres.right.id);
    if (repoResponse.isRight) {
      return Right(repoResponse.right);
    }
    return Left(repoResponse.left);
  }
}
