// ignore_for_file: camel_case_types, unused_field

import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:firstapp/domain/errores.dart';

abstract class imagePicker {
  Future<Either<MyError,File>> getImage();
}

class getImageFromCamaraService {
  
  imagePicker picker;

    getImageFromCamaraService({required this.picker});

   Future<Either<MyError,File>> getImage() async {    
     Either<MyError, File> imagePickerResponse = await picker.getImage();      
        if (imagePickerResponse.isLeft){
            return Left(imagePickerResponse.left);
        }
      return Right(imagePickerResponse.right);  
   }
  
}

