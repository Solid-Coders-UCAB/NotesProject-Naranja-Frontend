import 'dart:typed_data';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import '../../../domain/errores.dart';
import 'package:screenshot/screenshot.dart';
import '../../../application/widgetToImageService.dart';

class ScreenshotImp implements widgetImage{
  
    @override
      Future<Either<MyError, Uint8List>> getImageFromWidget(Widget drawing) async {
       try {

        final controller = ScreenshotController();
        final bytes = await controller.captureFromWidget(
                Material(child: drawing)
              );
        return Right(bytes);

       } catch (e) {
          return Left(MyError(key: AppError.NotFound,message: '$e'));
       }     
    }
}