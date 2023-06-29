import 'package:either_dart/either.dart';
import '../../application/Iservice.dart';
import 'package:firstapp/application/DTOS/updateFolderDTO.dart';
import 'package:firstapp/domain/errores.dart';

// ignore: camel_case_types
class editarCarpetaWidgetController {

  service<updateFolderDTO,String> updateCarpetaService;

  editarCarpetaWidgetController({required this.updateCarpetaService});


  Future<Either<MyError,String>> updateCarpeta({required String nombreCarpeta, required String idCarpeta} ) async {

    var serviceResponse = await updateCarpetaService.execute(updateFolderDTO(nombreCarpeta: nombreCarpeta, idCarpeta: idCarpeta));

      if (serviceResponse.isLeft){
        return Left(serviceResponse.left);
      }

      return Right(serviceResponse.right);
  }
  
}