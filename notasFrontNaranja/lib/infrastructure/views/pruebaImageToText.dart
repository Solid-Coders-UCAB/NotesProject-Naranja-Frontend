
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:firstapp/domain/errores.dart';
import 'package:firstapp/module.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'imageToTextWidgetController.dart';


class ImagePickerScreen extends StatefulWidget {
  
  const ImagePickerScreen({super.key,});
  @override
  // ignore: no_logic_in_create_state
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

//logica
class _ImagePickerScreenState extends State<ImagePickerScreen> {
  imageToTextWidgetController controller = module.imageToTextWidController();
  File? imageFile ;
  String? iaText = '';
  

  Future pickImageFromCamara() async {

    String text = '';

      PickedFile? pickedImage = await ImagePicker().getImage(
      source: ImageSource.camera ,
      imageQuality: 50);

      if (pickedImage != null){
        PickedFile picked = pickedImage;

        File image = File(picked.path);

        final textDetector = GoogleMlKit.vision.textDetector();

        final recognisedText = await textDetector.processImage(InputImage.fromFile(image));
        await textDetector.close();

        for (TextBlock block in recognisedText.blocks) {
           
            for (TextLine line in block.lines) {
              text = "$text${line.text}\n";
          }
        }

        setState( () { imageFile = File(picked.path); iaText = text;} );
      }

}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Image Picker')),
      body: Padding(padding: const EdgeInsets.all(20), 
        child: Column(
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
      iaText = 'loading......';
    });
     Either<MyError,String>? etext = await controller.getconvertedTextC();
     setState(() {
       iaText = etext!.right;
     });
  }

}