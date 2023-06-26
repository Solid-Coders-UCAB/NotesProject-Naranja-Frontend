import 'dart:io';
import 'dart:typed_data';
import 'package:either_dart/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/parameterObjects/imageToTextParams.dart';
import 'package:firstapp/domain/parameterObjects/updateNoteParams.dart';

class editarNotaWidgetController {

  service<imageToTextParams,String> imageToText;
  service<void,File> imageService;
  service<void,File> galleryService;
  service<UpdateNoteParams,String> updateNotaService;

  editarNotaWidgetController({required this.imageToText, required this.imageService, required this.galleryService, required this.updateNotaService });

  Future<Either<MyError,String>> updateNota({required String titulo, required String contenido,int? longitud,int? latitud, List<Uint8List>? imagenes, required String idNota, required n_date} ) async {
    longitud??=0;
    latitud??=0;

    var serviceResponse = await updateNotaService.execute(UpdateNoteParams(idNota: idNota, titulo: titulo, contenido: contenido,imagenes: imagenes,longitud: longitud,latitud: latitud, n_date: n_date));

      if (serviceResponse.isLeft){
        return Left(serviceResponse.left);
      }

      return Right(serviceResponse.right);
  }
   
   Future<Either<MyError,String>> showTextFromIA () async {

    var imageReponse = await imageService.execute(null);

      if (imageReponse.isLeft){
          return Left(imageReponse.left);
      }

      
    var iaResponse = await imageToText.execute(imageToTextParams(image: imageReponse.right));
        if (iaResponse.isLeft){
          return Left(iaResponse.left);
        }
    
    return Right(iaResponse.right);
   }

   Future<Either<MyError,Uint8List>> getImageGallery () async {

    var imageReponse = await galleryService.execute(null);

      if (imageReponse.isLeft){
          return Left(imageReponse.left);
      }

      Uint8List imagen = imageReponse.right.readAsBytesSync();
    
    return Right(imagen);
   }
}