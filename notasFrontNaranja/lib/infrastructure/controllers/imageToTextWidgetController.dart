// ignore_for_file: camel_case_types, file_names

import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:firstapp/application/getImageFromCameraService.dart';
import 'package:firstapp/application/imageToTextService.dart';
import 'package:firstapp/domain/errores.dart';

class imageToTextWidgetController{
  
  getImageFromCamaraService? camaraService;
  imageToTextService? imageToText;

  imageToTextWidgetController(getImageFromCamaraService c, imageToTextService i){
    camaraService = c ; imageToText = i;
  }

  Future<Either<MyError, File>?> getImageFromCamara() async {
      return await camaraService?.getImage();
   } 

  Future<Either<MyError, String>?> getconvertedText(File image) async {
      return await imageToText?.getConvertedText(image);
   }  

  Future<Either<MyError, String>?> getconvertedTextC() async {
      Either<MyError,File>? image = await camaraService?.getImage(); 
      Either<MyError, String>? text = await imageToText?.getConvertedText(image!.right);
      return text;
   } 

}