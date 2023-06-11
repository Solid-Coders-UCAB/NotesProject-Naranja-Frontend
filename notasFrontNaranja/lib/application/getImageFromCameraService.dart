// ignore_for_file: camel_case_types, unused_field

import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:image_picker/image_picker.dart';

abstract class imagePicker {
  Future<Either<MyError,File>> getImage();
}

class getImageFromCamaraService {
  imagePicker? picker;

    getImageFromCamaraService(imagePicker p){
      picker = p;
    }

   Future<Either<MyError,File>?> getImage() async {    
     Either<MyError, File>? image = await picker?.getImage();      
        if (image!.isLeft){
            return Left(image.left);
        }
      return Right(image.right);  
   }
  
}

class imagePickerImp implements imagePicker{
  
  imagePickerImp();

  @override
  Future<Either<MyError,File>> getImage() async {
      
      PickedFile? pickedImage = await ImagePicker().getImage(
      source: ImageSource.camera ,
      imageQuality: 50);

      if (pickedImage != null){
        PickedFile picked = pickedImage;
        return Right(File(picked.path));
      }

     return const Left( MyError(
            key: AppError.NotFound,
            message: 'not selected image'));
  }
  
}