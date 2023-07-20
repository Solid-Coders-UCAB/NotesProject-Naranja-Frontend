import 'package:either_dart/either.dart';
import '../../application/Iservice.dart';
import 'package:firstapp/application/DTOS/updateFolderDTO.dart';
import 'package:firstapp/application/DTOS/deleteFolderDTO.dart';
import 'package:firstapp/domain/errores.dart';

// ignore: camel_case_types
class editarCarpetaWidgetController {

  service<updateFolderDTO,String> updateCarpetaService;
  service<deleteFolderDTO,String> deleteCarpetaService;

  editarCarpetaWidgetController({required this.updateCarpetaService, required this.deleteCarpetaService});


  Future<Either<MyError,String>> updateCarpeta({required String nombreCarpeta, required String idCarpeta} ) async {

    var serviceResponse = await updateCarpetaService.execute(updateFolderDTO(nombreCarpeta: nombreCarpeta, idCarpeta: idCarpeta));

      if (serviceResponse.isLeft){
        return Left(serviceResponse.left);
      }

      return Right(serviceResponse.right);
  }

    Future<Either<MyError,String>> deleteCarpeta({required String idCarpeta} ) async {

    var serviceResponse = await deleteCarpetaService.execute(deleteFolderDTO(idCarpeta: idCarpeta));

      if (serviceResponse.isLeft){
        return Left(serviceResponse.left);
      }

      return Right(serviceResponse.right);
  }
  
}