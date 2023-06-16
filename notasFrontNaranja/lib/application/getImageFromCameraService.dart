// ignore_for_file: camel_case_types, unused_field, void_checks

import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';

abstract class imagePicker {
  Future<Either<MyError,File>> getImage();
}

class getImageFromCamaraService implements service<void,File>{
  
  imagePicker picker;

    getImageFromCamaraService({required this.picker});

   Future<Either<MyError,File>> getImage() async {    
     Either<MyError, File> imagePickerResponse = await picker.getImage();      
        if (imagePickerResponse.isLeft){
            return Left(imagePickerResponse.left);
        }
      return Right(imagePickerResponse.right);  
   }
   
     @override
     Future<Either<MyError, File>> execute(void params) async {
      Either<MyError, File> imagePickerResponse = await picker.getImage();      
        if (imagePickerResponse.isLeft){
            return Left(imagePickerResponse.left);
        }
      return Right(imagePickerResponse.right);   
     }
   
  
}

