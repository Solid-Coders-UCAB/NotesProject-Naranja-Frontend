import 'package:either_dart/either.dart';
import '../../application/Iservice.dart';
import 'package:firstapp/application/DTOS/createFolderDTO.dart';
import 'package:firstapp/domain/errores.dart';

// ignore: camel_case_types
class carpetaNuevaWidgetController {

  service<createFolderDTO,String> createCarpetaService;

  carpetaNuevaWidgetController({required this.createCarpetaService});


  Future<Either<MyError,String>> createCarpeta({required String nombreCarpeta} ) async {

    var serviceResponse = await createCarpetaService.execute(createFolderDTO(nombreCarpeta: nombreCarpeta));

      if (serviceResponse.isLeft){
        return Left(serviceResponse.left);
      }

      return Right(serviceResponse.right);
  }
  
}