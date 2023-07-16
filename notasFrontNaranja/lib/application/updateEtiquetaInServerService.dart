import 'package:either_dart/either.dart';
import 'package:firstapp/application/DTOS/updateEtiquetaDTO.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/etiqueta.dart';
import 'package:firstapp/domain/repositories/etiquetaRepository.dart';
import 'package:firstapp/domain/repositories/userRepository.dart';

// ignore: camel_case_types
class updateEtiquetaInServerService implements service<updateEtiquetaDTO,String>{

  etiquetaRepository etiquetaRepo;
  userRepository localUserRepo;

  updateEtiquetaInServerService({required this.etiquetaRepo, required this.localUserRepo});

 
  @override
  Future<Either<MyError, String>> execute(params) async{
    var localres = await localUserRepo.getUser();
      if (localres.isLeft){
        return Left(localres.left);
      } 

    Either<MyError,etiqueta> e = etiqueta.create(
      nombre: params.getNombre(),
      id: params.getId(),
      idUsuario: localres.right.id
    );

      if (e.isLeft){
        return Left(e.left);
      }

    var repoResponse = await etiquetaRepo.updateEtiqueta(e.right);
      if (repoResponse.isRight){
        return Right(repoResponse.right);
      }

      return Left(repoResponse.left);
  }
   
}