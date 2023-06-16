import 'package:firstapp/application/connectionCheckerDecorator.dart';
import 'package:firstapp/application/createNoteInServerService.dart';
import 'package:firstapp/application/getImageFromCameraService.dart';
import 'package:firstapp/application/imageToTextService.dart';
import 'package:firstapp/infrastructure/controllers/imageToTextWidgetController.dart';
import 'package:firstapp/infrastructure/controllers/notaNuevaWidgetController.dart';
import 'package:firstapp/infrastructure/implementations/HTTPnoteRepositoy.dart';
import 'package:firstapp/infrastructure/implementations/connectionCheckerImp.dart';
import 'package:firstapp/infrastructure/implementations/imagePickerImp.dart';
import 'package:firstapp/infrastructure/implementations/imageToTextImp.dart';

//fabrica de controladores

class controllerFactory {
  
  static imageToTextWidgetController imageToTextWidController(){ 
     imageToTextWidgetController imageToTextController = imageToTextWidgetController(
                                 getImageFromCamaraService(picker: imagePickerImp()),
                                 imageToTextService(ia: iaTextImp()));
      return imageToTextController;
  }

  static createNoteInServerService createNoInServerService(){
      return createNoteInServerService(noteRepo: httpNoteRepository());
  }

  static notaNuevaWidgetController notaNuevaWidController(){
    return notaNuevaWidgetController(imageToText: imageToTextService(ia: iaTextImp()), 
                                     imageService: getImageFromCamaraService(picker: imagePickerImp()), 
                                     createNotaService: connectionCheckerDecorator
                                                        (checker: connectionCheckerImp(), 
                                                        servicio: createNoteInServerService(noteRepo: httpNoteRepository())));    
  }

}                       

