import 'package:either_dart/either.dart';
import 'package:firstapp/application/DTOS/updateFolderDTO.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/folder.dart';
import 'package:firstapp/domain/repositories/folderRepository.dart';
import 'package:firstapp/domain/repositories/userRepository.dart';

// ignore: camel_case_types
class updateFolderInServerService implements service<updateFolderDTO,String>{

  folderRepository folderRepo;
  userRepository localUserRepo;

  updateFolderInServerService({required this.folderRepo, required this.localUserRepo});

 
  @override
  Future<Either<MyError, String>> execute(params) async{
    var localres = await localUserRepo.getUser();
      if (localres.isLeft){
        return Left(localres.left);
      } 

    Either<MyError,folder> f = folder.create(
      name: params.getName(),
      id: params.getId(),
      predeterminada: false,
      idUsuario: localres.right.id
    );

      if (f.isLeft){
        return Left(f.left);
      }

    var repoResponse = await folderRepo.updateFolder(f.right);
      if (repoResponse.isRight){
        return Right(repoResponse.right);
      }

      return Left(repoResponse.left);
  }
   
}