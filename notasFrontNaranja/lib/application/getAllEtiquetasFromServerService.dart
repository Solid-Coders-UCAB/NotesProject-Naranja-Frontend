// ignore_for_file: file_names, camel_case_types
import 'package:either_dart/either.dart';
import 'package:firstapp/domain/repositories/userRepository.dart';
import '../domain/errores.dart';
import '../domain/etiqueta.dart';
import '../domain/repositories/etiquetaRepository.dart';
import 'Iservice.dart';

class getAllEtiquetasFromServerService implements service<void,List<etiqueta>>{

  etiquetaRepository etiquetaRepo;
  userRepository localUserRepo;

  getAllEtiquetasFromServerService({required this.etiquetaRepo,required this.localUserRepo});

 
  @override
  Future<Either<MyError,List<etiqueta>>> execute(params) async{

    var localres = await localUserRepo.getUser();
      if (localres.isLeft){
        return Left(localres.left);
      } 

    var repoResponse = await etiquetaRepo.getAllEtiquetas(localres.right.id);
      
      if (repoResponse.isRight){
        return Right(repoResponse.right);
      }

      return Left(repoResponse.left);
  }


  
}