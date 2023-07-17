// ignore_for_file: file_names, camel_case_types

import 'package:either_dart/either.dart';
import 'package:firstapp/domain/repositories/userRepository.dart';

import '../domain/errores.dart';
import '../domain/folder.dart';
import '../domain/repositories/folderRepository.dart';
import 'Iservice.dart';

class getAllFoldersFromServerService implements service<void,List<folder>>{

  folderRepository folderRepo;
  userRepository localUserRepo;

  getAllFoldersFromServerService({required this.folderRepo,required this.localUserRepo});

 
  @override
  Future<Either<MyError,List<folder>>> execute(params) async{

    var localres = await localUserRepo.getUser();
      if (localres.isLeft){
        return Left(localres.left);
      } 

    var repoResponse = await folderRepo.getALLfolders(localres.right.id);
      
      if (repoResponse.isRight){
        print(repoResponse.right.length);
        return Right(repoResponse.right);
      }

      return Left(repoResponse.left);
  }


  
}