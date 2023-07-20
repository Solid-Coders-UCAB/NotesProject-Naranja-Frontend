// ignore_for_file: file_names, camel_case_types

import 'package:either_dart/either.dart';
import 'package:firstapp/application/DTOS/createEtiquetaDTO.dart';
//import 'package:either_dart/src/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/etiqueta.dart';
import 'package:firstapp/domain/repositories/etiquetaRepository.dart';
import 'package:firstapp/domain/repositories/userRepository.dart';

class createEtiquetaInServerService implements service<createEtiquetaDTO,String>{

  etiquetaRepository etiquetaRepo;
  userRepository localUserRepo;

  createEtiquetaInServerService({required this.etiquetaRepo, required this.localUserRepo});

 
  @override
  Future<Either<MyError, String>> execute(params) async{

    var localres = await localUserRepo.getUser();
      if (localres.isLeft){
        return Left(localres.left);
      } 

    Either<MyError,etiqueta> f = etiqueta.create(
      nombre: params.getName,
      idUsuario: localres.right.id
    );

      if (f.isLeft){
        return Left(f.left);
      }

    var repoResponse = await etiquetaRepo.createEtiqueta(f.right);
      if (repoResponse.isRight){
        return Right(repoResponse.right);
      }

      return Left(repoResponse.left);
  }


  
}