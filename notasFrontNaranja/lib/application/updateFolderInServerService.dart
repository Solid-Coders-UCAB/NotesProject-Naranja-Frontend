import 'package:either_dart/either.dart';
import 'package:firstapp/application/DTOS/updateFolderDTO.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/folder.dart';
import 'package:firstapp/domain/repositories/folderRepository.dart';

// ignore: camel_case_types
class updateFolderInServerService implements service<updateFolderDTO,String>{

  folderRepository folderRepo;

  updateFolderInServerService({required this.folderRepo});

 
  @override
  Future<Either<MyError, String>> execute(params) async{

    Either<MyError,folder> f = folder.create(
      name: params.getName(),
      id: params.getId(),
      predeterminada: false
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