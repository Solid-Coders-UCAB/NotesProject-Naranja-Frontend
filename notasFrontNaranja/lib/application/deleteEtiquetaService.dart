import 'package:either_dart/either.dart';
import 'package:firstapp/application/DTOS/deleteEtiquetaDTO.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/repositories/etiquetaRepository.dart';
import 'package:firstapp/domain/repositories/userRepository.dart';

// ignore: camel_case_types
class deleteEtiquetaInServerService implements service<deleteEtiquetaDTO,String>{

  etiquetaRepository etiquetaRepo;
  userRepository localUserRepo;

  deleteEtiquetaInServerService({required this.etiquetaRepo, required this.localUserRepo});

 
  @override
  Future<Either<MyError, String>> execute(params) async{
    var localres = await localUserRepo.getUser();
      if (localres.isLeft){
        return Left(localres.left);
      } 

    var repoResponse = await etiquetaRepo.deleteEtiqueta(params.getId());
      if (repoResponse.isRight){
        return Right(repoResponse.right);
      }

      return Left(repoResponse.left);
  }
   
}