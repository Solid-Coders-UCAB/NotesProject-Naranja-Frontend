import 'dart:typed_data';
import 'package:either_dart/either.dart';
import 'package:firstapp/application/widgetToImageService.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:flutter/material.dart';

class DrawingRoomController{
  
  WidgetToImageService imageService;

  DrawingRoomController({required this.imageService});

  Future<Either<MyError, Uint8List>> getImageFromWidget(Widget drawing) async {

    Either<MyError, Uint8List> imageReponse = await imageService.getConvertedImage(drawing);

    if (imageReponse.isLeft){
          return Left(imageReponse.left);
      }
    
    return Right(imageReponse.right);
      
   } 

}