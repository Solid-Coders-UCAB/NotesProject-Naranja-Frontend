// ignore_for_file: camel_case_types, unused_field

import 'dart:io';
import 'package:image_picker/image_picker.dart';

abstract class imagePicker {
  Future<File> getImage();
}

class getImageFromCamaraService {
  imagePicker? _picker;
  
}

class imagePickerImp implements imagePicker{
  
  @override
  Future<File> getImage() async {
      
      PickedFile? pickedImage = await ImagePicker().getImage(
      source: ImageSource.camera ,
      imageQuality: 50);

      if (pickedImage != null){
        PickedFile picked = pickedImage;
        return File(picked.path);
      }

     return File('');
  }
  
}