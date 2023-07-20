import 'package:either_dart/either.dart';
import '../../application/Iservice.dart';
import 'package:firstapp/application/DTOS/updateEtiquetaDTO.dart';
import 'package:firstapp/application/DTOS/deleteEtiquetaDTO.dart';
import 'package:firstapp/domain/errores.dart';

// ignore: camel_case_types
class editarEtiquetaWidgetController {

  service<updateEtiquetaDTO,String> updateEtiquetaService;
  service<deleteEtiquetaDTO,String> deleteEtiquetaService;

  editarEtiquetaWidgetController({required this.updateEtiquetaService, required this.deleteEtiquetaService});


  Future<Either<MyError,String>> updateEtiqueta({required String nombreEtiqueta, required String idEtiqueta} ) async {

    var serviceResponse = await updateEtiquetaService.execute(updateEtiquetaDTO(nombreEtiqueta: nombreEtiqueta, idEtiqueta: idEtiqueta));

      if (serviceResponse.isLeft){
        return Left(serviceResponse.left);
      }

      return Right(serviceResponse.right);
  }

  Future<Either<MyError,String>> deleteEtiqueta({required String idEtiqueta} ) async {

    var serviceResponse = await deleteEtiquetaService.execute(deleteEtiquetaDTO(idEtiqueta: idEtiqueta));

      if (serviceResponse.isLeft){
        return Left(serviceResponse.left);
      }

      return Right(serviceResponse.right);
  }
  
}