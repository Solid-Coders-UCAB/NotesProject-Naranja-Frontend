
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/controllerFactory.dart';
import 'package:flutter/material.dart';
import '../../controllers/imageToTextWidgetController.dart';


class ImagePickerScreen extends StatefulWidget {
  
  const ImagePickerScreen({super.key,});
  @override
  // ignore: no_logic_in_create_state
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

//logica
class _ImagePickerScreenState extends State<ImagePickerScreen> {
  imageToTextWidgetController controller = controllerFactory.imageToTextWidController();
  File? imageFile ;
  String? iaText = '';
  bool loading = false;
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Image Picker')),
      body: Padding(padding: const EdgeInsets.all(20), 
        child: loading == true ? const Center(child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator()
        ))         
        :
        Column(
        children: 
        [ 
          if (imageFile != null) 
            Image.file(imageFile!,height: 330) 
            else 
            const FlutterLogo(), Text(iaText!)]))
            ,
      
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_a_photo),
        onPressed: () { showImageAndTextFromCamara(); }
          

      ),
    );
  }

   Future showImageAndTextFromCamara() async {
    setState(() {
      loading = true;
    });
     Either<MyError,String>? etext = await controller.getconvertedTextC();
     setState(() {
       iaText = etext!.right;
       loading = false;
     });
  }

}