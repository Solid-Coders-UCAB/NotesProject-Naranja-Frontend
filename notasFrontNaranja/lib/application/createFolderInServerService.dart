// ignore_for_file: file_names, camel_case_types

import 'package:either_dart/either.dart';
//import 'package:either_dart/src/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/folder.dart';
import 'package:firstapp/domain/repositories/folderRepository.dart';
import 'DTOS/createFolderDTO.dart';

class createFolderInServerService implements service<createFolderDTO,String>{

  folderRepository folderRepo;

  createFolderInServerService({required this.folderRepo});

 
  @override
  Future<Either<MyError, String>> execute(params) async{

    Either<MyError,folder> f = folder.create(
      name: params.getName
    );

      if (f.isLeft){
        return Left(f.left);
      }

    var repoResponse = await folderRepo.createFolder(f.right);
      if (repoResponse.isRight){
        return Right(repoResponse.right);
      }

      return Left(repoResponse.left);
  }


  
}