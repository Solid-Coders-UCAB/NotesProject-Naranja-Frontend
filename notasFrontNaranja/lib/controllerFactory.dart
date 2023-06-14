import 'package:firstapp/application/getImageFromCameraService.dart';
import 'package:firstapp/application/imageToTextService.dart';
import 'package:firstapp/infrastructure/controllers/imageToTextWidgetController.dart';

//fabrica de controladores

class controllerFactory {
  
  static imageToTextWidgetController imageToTextWidController(){ 
     imageToTextWidgetController imageToTextController = imageToTextWidgetController(
                                 getImageFromCamaraService(imagePickerImp()),imageToTextService(iaTextImp()));
      return imageToTextController;
  }

}                       

