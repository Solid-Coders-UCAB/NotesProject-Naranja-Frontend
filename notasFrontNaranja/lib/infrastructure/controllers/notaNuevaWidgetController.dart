import 'package:either_dart/either.dart';
import 'package:firstapp/application/createNoteInServerService.dart';
import 'package:firstapp/application/getImageFromCameraService.dart';
import 'package:firstapp/application/imageToTextService.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/parameterObjects/createNoteParams.dart';

class notaNuevaWidgetController {

  imageToTextService imageToText;
  getImageFromCamaraService imageService;
  createNoteInServerService createNotaService;

  notaNuevaWidgetController({required this.imageToText, required this.imageService, required this.createNotaService });

  Future<Either<MyError,String>> saveNota( {required String titulo,required String contenido }) async {
    
    var serviceResponse = await createNotaService.execute(CreatenoteParams(titulo: titulo, contenido: contenido));

      if (serviceResponse.isLeft){
        return Left(serviceResponse.left);
      }

      return Right(serviceResponse.right);
  }
  


}