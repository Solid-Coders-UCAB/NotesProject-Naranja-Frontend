import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firstapp/application/getImageFromGalleryService.dart';
import '../../domain/errores.dart';

class imagePickerGalleryImp implements imagePickerGallery{
  
  imagePickerGalleryImp();

  @override
  Future<Either<MyError,File>> getImage() async {
      
      PickedFile? pickedImage = await ImagePicker().getImage(source: ImageSource.gallery , imageQuality: 50);

      if (pickedImage != null){
        PickedFile picked = pickedImage;
        return Right(File(picked.path));
      }

     return const Left( MyError(
            key: AppError.NotFound,
            message: 'not selected image'));
  }
  
}