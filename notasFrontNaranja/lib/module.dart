import 'package:firstapp/application/getImageFromCameraService.dart';
import 'package:firstapp/application/imageToTextService.dart';
import 'package:firstapp/infrastructure/views/imageToTextWidgetController.dart';

class module {
  static imageToTextWidgetController imageToTextWidController(){
     imageToTextWidgetController imageToTextController = imageToTextWidgetController(
                              getImageFromCamaraService(imagePickerImp()),imageToTextService(iaTextImp()));
      return imageToTextController;
  }
}                       

