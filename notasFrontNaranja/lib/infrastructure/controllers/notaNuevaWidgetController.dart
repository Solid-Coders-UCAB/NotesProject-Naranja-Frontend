import 'package:either_dart/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/application/getImageFromCameraService.dart';
import 'package:firstapp/application/imageToTextService.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/parameterObjects/createNoteParams.dart';

class notaNuevaWidgetController {

  imageToTextService imageToText;
  getImageFromCamaraService imageService;
  service<CreatenoteParams,String> createNotaService;

  notaNuevaWidgetController({required this.imageToText, required this.imageService, required this.createNotaService });

  Future<Either<MyError,String>> saveNota( {required String titulo,required String contenido,int? longitud,int? latitud} ) async {
    longitud??=0;
    latitud??=0;

    var serviceResponse = await createNotaService.execute(CreatenoteParams(titulo: titulo, contenido: contenido,longitud: longitud,latitud: latitud));

      if (serviceResponse.isLeft){
        return Left(serviceResponse.left);
      }

      return Right(serviceResponse.right);
  }
   
   Future<Either<MyError,String>> showTextFromIA () async {

    var imageReponse = await imageService.getImage();

      if (imageReponse.isLeft){
          return Left(imageReponse.left);
      }
      
    var iaResponse = await imageToText.getConvertedText(imageReponse.right);
        if (iaResponse.isLeft){
          return Left(iaResponse.left);
        }
    
    return Right(iaResponse.right);
   }
}