import 'package:either_dart/either.dart';
import '../../application/Iservice.dart';
import 'package:firstapp/application/DTOS/createEtiquetaDTO.dart';
import 'package:firstapp/domain/errores.dart';

// ignore: camel_case_types
class etiquetaNuevaWidgetController {

  service<createEtiquetaDTO,String> createEtiquetaService;

  etiquetaNuevaWidgetController({required this.createEtiquetaService});


  Future<Either<MyError,String>> createEtiqueta({required String nombreEtiqueta} ) async {

    var serviceResponse = await createEtiquetaService.execute(createEtiquetaDTO(nombreEtiqueta: nombreEtiqueta));

      if (serviceResponse.isLeft){
        return Left(serviceResponse.left);
      }

      return Right(serviceResponse.right);
  }
  
}