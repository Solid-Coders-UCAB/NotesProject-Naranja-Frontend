import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:image_picker/image_picker.dart';

import '../../application/getImageFromCameraService.dart';
import '../../domain/errores.dart';

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