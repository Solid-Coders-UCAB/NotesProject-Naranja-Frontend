import 'dart:io';
import 'dart:typed_data';
import 'package:either_dart/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/domain/parameterObjects/imageToTextParams.dart';

class editarNotaWidgetController {

  service<imageToTextParams,String> imageToText;
  service<void,File> imageService;
  service<void,File> galleryService;
  // Aqui debe agregarse el servicio de editar nota

  editarNotaWidgetController({required this.imageToText, required this.imageService, required this.galleryService });

  //Future<Either<MyError,String>> updateNota(  ) ;
  
   
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