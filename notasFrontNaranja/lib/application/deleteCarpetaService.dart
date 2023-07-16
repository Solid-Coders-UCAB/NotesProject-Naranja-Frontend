import 'package:either_dart/either.dart';
import 'package:firstapp/application/DTOS/deleteFolderDTO.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/repositories/folderRepository.dart';
import 'package:firstapp/domain/repositories/userRepository.dart';

// ignore: camel_case_types
class deleteCarpetaInServerService implements service<deleteFolderDTO,String>{

  folderRepository folderRepo;
  userRepository localUserRepo;

  deleteCarpetaInServerService({required this.folderRepo, required this.localUserRepo});

 
  @override
  Future<Either<MyError, String>> execute(params) async{
    var localres = await localUserRepo.getUser();
      if (localres.isLeft){
        return Left(localres.left);
      } 

    var repoResponse = await folderRepo.deleteCarpeta(params.getId());
      if (repoResponse.isRight){
        return Right(repoResponse.right);
      }

      return Left(repoResponse.left);
  }
   
}