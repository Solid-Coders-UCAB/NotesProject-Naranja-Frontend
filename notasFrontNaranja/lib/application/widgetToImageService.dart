// ignore_for_file: camel_case_types, file_names
import 'dart:typed_data';
import 'package:either_dart/either.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:flutter/material.dart';

class WidgetToImageService {
  
  widgetImage converter;

  WidgetToImageService( { required this.converter} );

  Future<Either<MyError,Uint8List>> getConvertedImage(Widget drawing) async {
    Either<MyError, Uint8List> converterResponse = await converter.getImageFromWidget(drawing);
      
      if (converterResponse.isRight){
        return Right(converterResponse.right);
      }else{
        return Left(converterResponse.left);
      }
  }
  
}

abstract class widgetImage {
  Future<Either<MyError,Uint8List>> getImageFromWidget(Widget drawing);
}