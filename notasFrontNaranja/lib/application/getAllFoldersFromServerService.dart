import 'package:either_dart/either.dart';

import '../domain/errores.dart';
import '../domain/folder.dart';
import '../domain/repositories/folderRepository.dart';
import 'DTOS/createFolderDTO.dart';
import 'Iservice.dart';

class getAllFoldersFromServerService implements service<void,List<folder>>{

  folderRepository folderRepo;

  getAllFoldersFromServerService({required this.folderRepo});

 
  @override
  Future<Either<MyError,List<folder>>> execute(params) async{

    var repoResponse = await folderRepo.getALLfolders();
      
      if (repoResponse.isRight){
        return Right(repoResponse.right);
      }

      return Left(repoResponse.left);
  }


  
}