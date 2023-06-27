// ignore_for_file: camel_case_types, unused_field, void_checks, file_names
import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:firstapp/application/Iservice.dart';
import 'package:firstapp/domain/errores.dart';

abstract class imagePickerGallery {
  Future<Either<MyError,File>> getImage();
}

class getImageFromGalleryService implements service<void,File>{
  
  imagePickerGallery picker;

    getImageFromGalleryService({required this.picker});
   
     @override
     Future<Either<MyError, File>> execute(void params) async {
      Either<MyError, File> imagePickerResponse = await picker.getImage();      
        if (imagePickerResponse.isLeft){
            return Left(imagePickerResponse.left);
        }
      return Right(imagePickerResponse.right);   
     }
   
  
}
